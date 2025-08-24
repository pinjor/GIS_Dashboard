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
  String currentLevel, // Add current level to determine drill-down capability
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
  final Map<String, List<Map<String, dynamic>>> areaGroups = {};

  for (final feature in features) {
    final geometry = feature['geometry'];
    final info = feature['info'];

    // Extract area information from GeoJSON
    final String areaName = info?['name'] ?? 'Unknown Area';
    final String? orgUid = info?['org_uid'];
    final String? slug = info?['slug'];
    final String? parentSlug = info?['parent_slug'];

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

    // Group features by area name to combine parts
    if (!areaGroups.containsKey(areaName)) {
      areaGroups[areaName] = [];
    }

    areaGroups[areaName]!.add({
      'geometry': geometry,
      'areaName': areaName,
      'orgUid': orgUid,
      'coveragePercentage': coveragePercentage,
      'slug': slug,
      'parentSlug': parentSlug,
    });
  }

  // Process grouped areas
  for (final entry in areaGroups.entries) {
    final areaName = entry.key;
    final featureGroup = entry.value;

    // Collect all valid polygon points for this area
    final List<List<LatLng>> allPolygonRings = [];

    String? areaOrgUid;
    double? areaCoveragePercentage;
    String? areaSlug;
    String? areaParentSlug;

    // Process all features for this area name
    for (final featureData in featureGroup) {
      final geometry = featureData['geometry'];
      areaOrgUid ??= featureData['orgUid'];
      areaCoveragePercentage ??= featureData['coveragePercentage'];
      areaSlug ??= featureData['slug'];
      areaParentSlug ??= featureData['parentSlug'];

      final type = geometry['type'];

      // Process different geometry types and collect all rings
      if (type == 'Polygon') {
        final polygonRings = _extractPolygonRings(geometry, areaName);
        allPolygonRings.addAll(polygonRings);
      } else if (type == 'MultiPolygon') {
        final multiPolygonRings = _extractMultiPolygonRings(geometry, areaName);
        allPolygonRings.addAll(multiPolygonRings);
      } else {
        logg.w("Unsupported geometry type: $type for $areaName");
        skippedFeatures++;
      }
    }

    // Create a single AreaPolygon for this area using the largest/most significant ring
    if (allPolygonRings.isNotEmpty) {
      // Use the ring with the most points (usually the main area)
      final mainRing = allPolygonRings.reduce(
        (a, b) => a.length > b.length ? a : b,
      );

      final areaPolygon = _createAreaPolygon(
        areaName, // Use original name without "Part X" suffix
        areaOrgUid,
        areaCoveragePercentage,
        mainRing,
        currentLevel,
        slug: areaSlug,
        parentSlug: areaParentSlug,
      );

      if (areaPolygon != null) {
        polygonList.add(areaPolygon);
        processedPolygons++;
        logg.d(
          "Created unified polygon for $areaName with ${allPolygonRings.length} parts",
        );
      }
    }
  }

  logg.i(
    "GeoJSON parsing completed in ${stopwatch.elapsedMilliseconds}ms: $processedPolygons total areas processed, $matchedCount with coverage data, $noDataCount without data, $skippedFeatures skipped",
  );
  logg.i("Final unified polygon count: ${polygonList.length}");

  stopwatch.stop();
  return polygonList;
}

// Helper function to extract polygon rings from a Polygon geometry
List<List<LatLng>> _extractPolygonRings(
  Map<String, dynamic> geometry,
  String areaName,
) {
  try {
    final coordinatesArray = geometry['coordinates'] as List<dynamic>;
    final List<List<LatLng>> rings = [];

    if (coordinatesArray.isNotEmpty) {
      // Standard polygon structure: coordinates[0] is the outer ring
      final coords = coordinatesArray[0] as List<dynamic>;
      final points = _extractCoordinates(coords, areaName);

      if (points.length >= 3) {
        rings.add(points);
      } else if (points.length == 2) {
        // Create a minimal triangle for debugging
        points.add(points.last);
        rings.add(points);
      }
    }

    return rings;
  } catch (e) {
    logg.e("Error extracting polygon rings for $areaName: $e");
    return [];
  }
}

// Helper function to extract polygon rings from a MultiPolygon geometry
List<List<LatLng>> _extractMultiPolygonRings(
  Map<String, dynamic> geometry,
  String areaName,
) {
  final List<List<LatLng>> rings = [];

  try {
    final multiPolygonCoords = geometry['coordinates'] as List<dynamic>;

    for (int i = 0; i < multiPolygonCoords.length; i++) {
      try {
        final polygonCoords = multiPolygonCoords[i] as List<dynamic>;

        if (polygonCoords.isNotEmpty && polygonCoords[0] is List) {
          // Take the outer ring (first element) of each polygon
          final coords = polygonCoords[0] as List<dynamic>;
          final points = _extractCoordinates(coords, areaName);

          if (points.length >= 3) {
            rings.add(points);
          } else if (points.length == 2) {
            // Create a minimal triangle for debugging
            points.add(points.last);
            rings.add(points);
          }
        }
      } catch (e) {
        logg.e("Error processing polygon part ${i + 1} for $areaName: $e");
        // Continue processing other parts
      }
    }
  } catch (e) {
    logg.e("Error extracting multipolygon rings for $areaName: $e");
  }

  return rings;
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
  String currentLevel, {
  String? slug,
  String? parentSlug,
}) {
  try {
    // Get color based on coverage percentage
    final polygonColor = CoverageColors.getCoverageColor(coveragePercentage);

    // Allow drill-down for district and upazila levels, with valid slug
    final canDrillDown =
        (currentLevel == 'district' || currentLevel == 'upazila') &&
        slug != null &&
        slug.isNotEmpty;

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
      level: currentLevel, // Use the actual current level
      coveragePercentage: coveragePercentage ?? 0.0,
      slug: slug,
      parentSlug: parentSlug,
      canDrillDown: canDrillDown, // Only allow drill-down from district level
    );
  } catch (e) {
    logg.e("Error creating area polygon for $areaName: $e");
    return null;
  }
}
