import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../../config/coverage_colors.dart';
import '../../../core/utils/utils.dart';
import '../domain/area_polygon.dart';
import '../domain/vaccine_coverage_response.dart';

List<AreaPolygon> parseGeoJsonToPolygons(
  String geoJson,
  VaccineCoverageResponse coverageData,
  String selectedVaccine,
) {
  final stopwatch = Stopwatch()..start();

  final decoded = jsonDecode(geoJson) as Map<String, dynamic>;
  final features = decoded['features'] as List<dynamic>;

  // Find the selected vaccine data
  final vaccines = coverageData.vaccines ?? [];
  final selectedVaccineData = vaccines.isNotEmpty
      ? vaccines.firstWhere(
          (vaccine) => vaccine.vaccineName == selectedVaccine,
          orElse: () => vaccines.first,
        )
      : null;

  if (selectedVaccineData == null) {
    logg.e("No vaccine data found for $selectedVaccine");
    return [];
  }

  // Create a map for quick coverage lookup by UID
  final Map<String, Area> coverageMap = {};
  final areas = selectedVaccineData.areas ?? [];
  for (final area in areas) {
    if (area.uid != null) {
      coverageMap[area.uid!] = area;
    }
  }

  logg.i(
    "Starting GeoJSON parsing: ${features.length} features, ${coverageMap.length} coverage areas for vaccine: $selectedVaccine",
  );

  // Debug: Log first few features to understand structure
  if (features.isNotEmpty) {
    final firstFeature = features[0];
    logg.d("Sample feature structure: ${firstFeature.runtimeType}");
    logg.d("Sample geometry type: ${firstFeature['geometry']?['type']}");
    logg.d("Sample info keys: ${firstFeature['info']?.keys.toList()}");

    // Log coordinate structure for debugging
    final geometry = firstFeature['geometry'];
    if (geometry != null && geometry['coordinates'] != null) {
      final coords = geometry['coordinates'];
      logg.d("Sample coordinate structure: ${coords.runtimeType}");
      if (coords is List && coords.isNotEmpty) {
        logg.d("First coordinate array length: ${coords.length}");
        if (coords[0] is List && (coords[0] as List).isNotEmpty) {
          final firstCoordSet = coords[0] as List;
          logg.d("First coordinate set length: ${firstCoordSet.length}");
          if (firstCoordSet.isNotEmpty && firstCoordSet[0] is List) {
            final firstCoord = firstCoordSet[0] as List;
            logg.d("Sample coordinate: $firstCoord");
          }
        }
      }
    }
  }

  int matchedCount = 0;
  int noDataCount = 0;
  int processedPolygons = 0;
  int skippedFeatures = 0;

  final List<AreaPolygon> polygonList = [];

  for (final feature in features) {
    final geometry = feature['geometry'];
    final info = feature['info'];

    // Extract district information from GeoJSON
    final String areaName = info?['name'] ?? 'Unknown Area';
    final String? orgUid = info?['org_uid'];

    // Skip features without geometry
    if (geometry == null) {
      logg.w("Skipping feature $areaName - no geometry");
      skippedFeatures++;
      continue;
    }

    // Find matching coverage data using org_uid from GeoJSON and uid from coverage
    Area? matchedCoverage;
    double? coveragePercentage;

    if (orgUid != null && coverageMap.containsKey(orgUid)) {
      matchedCoverage = coverageMap[orgUid];
      coveragePercentage = matchedCoverage?.coveragePercentage;
      matchedCount++;
      logg.d(
        "Found coverage for $areaName: ${coveragePercentage?.toStringAsFixed(1)}%",
      );
    } else {
      noDataCount++;
      // Still process features without coverage data - they'll get default styling
      logg.d(
        "No coverage data found for district: $areaName (org_uid: $orgUid) - will use default styling",
      );
    }

    final type = geometry['type'];

    // Process different geometry types
    if (type == 'Polygon') {
      final polygonData = _processPolygonGeometry(
        geometry,
        areaName,
        orgUid,
        coveragePercentage,
      );
      if (polygonData != null) {
        polygonList.add(polygonData);
        processedPolygons++;
      }
    } else if (type == 'MultiPolygon') {
      // Process ALL polygons in MultiPolygon, not just the first one
      final multiPolygons = _processMultiPolygonGeometry(
        geometry,
        areaName,
        orgUid,
        coveragePercentage,
      );
      polygonList.addAll(multiPolygons);
      processedPolygons += multiPolygons.length;
    } else {
      logg.w("Unsupported geometry type: $type for $areaName");
      skippedFeatures++;
    }
  }

  logg.i(
    "GeoJSON parsing completed in ${stopwatch.elapsedMilliseconds}ms: $processedPolygons total polygons, $matchedCount with coverage data, $noDataCount without data, $skippedFeatures skipped",
  );
  logg.i("Final polygon count: ${polygonList.length}");

  // Additional debugging: analyze polygon distribution by area
  final Map<String, int> areaPolygonCounts = {};
  for (final polygon in polygonList) {
    final areaName = polygon.areaName.split(' Part ')[0]; // Remove part suffix
    areaPolygonCounts[areaName] = (areaPolygonCounts[areaName] ?? 0) + 1;
  }

  // Log areas with multiple polygons (likely MultiPolygon features)
  final multiPolygonAreas =
      areaPolygonCounts.entries.where((entry) => entry.value > 1).toList()
        ..sort((a, b) => b.value.compareTo(a.value));

  if (multiPolygonAreas.isNotEmpty) {
    logg.i("Areas with multiple polygon parts:");
    for (final entry in multiPolygonAreas.take(10)) {
      // Show top 10
      logg.i("  ${entry.key}: ${entry.value} parts");
    }
  }

  stopwatch.stop();
  return polygonList;
}

// Helper function to process single Polygon geometry
AreaPolygon? _processPolygonGeometry(
  Map<String, dynamic> geometry,
  String areaName,
  String? orgUid,
  double? coveragePercentage,
) {
  try {
    final coordinatesArray = geometry['coordinates'] as List<dynamic>;

    // Handle different coordinate structures
    List<dynamic> coords;
    if (coordinatesArray.isNotEmpty) {
      // Standard polygon structure: coordinates[0] is the outer ring
      coords = coordinatesArray[0] as List<dynamic>;
    } else {
      logg.w("$areaName: Empty coordinates array");
      return null;
    }

    final points = _extractCoordinates(coords, areaName);

    // More lenient coordinate requirement - even 2 points can be useful for debugging
    if (points.length < 2) {
      logg.w(
        "Skipping polygon for $areaName - insufficient valid coordinates (${points.length})",
      );
      return null;
    }

    // For polygons with less than 3 points, create a simple line or point representation
    if (points.length == 2) {
      logg.i("$areaName: Creating line polygon with ${points.length} points");
      // Duplicate the last point to create a minimal triangle
      points.add(points.last);
    }

    return _createAreaPolygon(areaName, orgUid, coveragePercentage, points);
  } catch (e) {
    logg.e("Error processing polygon for $areaName: $e");
    // Try to extract coordinate information for debugging
    try {
      final coords = geometry['coordinates'];
      logg.e("  Coordinate structure: ${coords.runtimeType}");
      if (coords is List) {
        logg.e("  Coordinate array length: ${coords.length}");
        if (coords.isNotEmpty) {
          logg.e("  First element type: ${coords[0].runtimeType}");
        }
      }
    } catch (debugError) {
      logg.e("  Could not analyze coordinate structure: $debugError");
    }
    return null;
  }
}

// Helper function to process MultiPolygon geometry
List<AreaPolygon> _processMultiPolygonGeometry(
  Map<String, dynamic> geometry,
  String areaName,
  String? orgUid,
  double? coveragePercentage,
) {
  final List<AreaPolygon> polygons = [];

  try {
    final multiPolygonCoords = geometry['coordinates'] as List<dynamic>;

    // Process ALL polygon parts - don't limit them for completeness
    // This ensures we don't miss any boundaries
    logg.d("$areaName: Processing ${multiPolygonCoords.length} polygon parts");

    for (int i = 0; i < multiPolygonCoords.length; i++) {
      try {
        final polygonCoords = multiPolygonCoords[i] as List<dynamic>;

        // Handle different MultiPolygon structures
        List<dynamic> coords;
        if (polygonCoords.isNotEmpty && polygonCoords[0] is List) {
          // Take the outer ring (first element) of each polygon
          coords = polygonCoords[0] as List<dynamic>;
        } else {
          logg.w("$areaName Part ${i + 1}: Unexpected polygon structure");
          continue;
        }

        final points = _extractCoordinates(coords, areaName);

        if (points.length >= 3) {
          final polygon = _createAreaPolygon(
            "$areaName${i > 0 ? ' Part ${i + 1}' : ''}",
            orgUid,
            coveragePercentage,
            points,
          );
          if (polygon != null) {
            polygons.add(polygon);
          }
        } else if (points.length == 2) {
          // Create a minimal triangle for debugging
          points.add(points.last);
          final polygon = _createAreaPolygon(
            "$areaName Part ${i + 1} (Line)",
            orgUid,
            coveragePercentage,
            points,
          );
          if (polygon != null) {
            polygons.add(polygon);
          }
        } else {
          logg.d(
            "Skipping polygon part ${i + 1} for $areaName - insufficient coordinates (${points.length})",
          );
        }
      } catch (e) {
        logg.e("Error processing polygon part ${i + 1} for $areaName: $e");
        // Continue processing other parts
      }
    }
  } catch (e) {
    logg.e("Error processing multipolygon for $areaName: $e");
  }

  logg.d("Processed ${polygons.length} polygon parts for $areaName");
  return polygons;
}

// Helper function to extract and validate coordinates
List<LatLng> _extractCoordinates(List<dynamic> coords, String areaName) {
  final validCoords = <LatLng>[];
  int invalidCount = 0;

  for (final coord in coords) {
    try {
      if (coord is List && coord.length >= 2) {
        final lng = (coord[0] as num).toDouble();
        final lat = (coord[1] as num).toDouble();

        // Very relaxed coordinate validation - accept any reasonable coordinate values
        // Only filter out clearly invalid values like NaN, infinite, or extreme outliers
        if (!lat.isNaN && !lng.isNaN && lat.isFinite && lng.isFinite) {
          // Accept any coordinate that could realistically be on Earth
          if (lat.abs() <= 90.0 && lng.abs() <= 180.0) {
            validCoords.add(LatLng(lat, lng));
          } else {
            invalidCount++;
            if (invalidCount <= 5) {
              // Log first few extreme outliers
              logg.d(
                "$areaName: Extreme coordinate filtered: lat=$lat, lng=$lng",
              );
            }
          }
        } else {
          invalidCount++;
          if (invalidCount <= 5) {
            // Log first few NaN/infinite values
            logg.d(
              "$areaName: Invalid coordinate filtered: lat=$lat, lng=$lng",
            );
          }
        }
      } else {
        invalidCount++;
      }
    } catch (e) {
      invalidCount++;
      if (invalidCount <= 5) {
        // Log first few parsing errors
        logg.d("$areaName: Coordinate parsing error: $e");
      }
    }
  }

  if (invalidCount > 0) {
    logg.d(
      "$areaName: ${validCoords.length} valid coordinates, $invalidCount invalid",
    );
  }

  return validCoords;
}

// Helper function to create AreaPolygon
AreaPolygon? _createAreaPolygon(
  String areaName,
  String? orgUid,
  double? coveragePercentage,
  List<LatLng> points,
) {
  try {
    // Get color based on coverage percentage
    final polygonColor = CoverageColors.getCoverageColor(coveragePercentage);

    return AreaPolygon(
      polygon: Polygon(
        points: points,
        color: polygonColor.withValues(
          alpha: 0.6, // Semi-transparent so underlying map labels show through
        ),
        borderColor: const Color(0xFF333333), // Dark border for visibility
        borderStrokeWidth: 0.8,
      ),
      areaId: orgUid ?? areaName,
      areaName: areaName,
      level: 'district',
      coveragePercentage: coveragePercentage ?? 0.0,
    );
  } catch (e) {
    logg.e("Error creating area polygon for $areaName: $e");
    return null;
  }
}
