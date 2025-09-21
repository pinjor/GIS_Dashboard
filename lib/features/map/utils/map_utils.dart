import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../../config/coverage_colors.dart';
import '../../../core/utils/utils.dart';
import '../domain/area_polygon.dart';
import '../../summary/domain/vaccine_coverage_response.dart';
import 'map_enums.dart';

/// Check if a point is inside a polygon using ray casting algorithm - OPTIMIZED to prevent freezing
bool isTappedPointInPolygon(LatLng point, List<LatLng> polygon) {
  if (polygon.length < 3) return false;

  // Prevent freezing with very large polygon data
  if (polygon.length > 1000) {
    logg.d(
      "Large polygon with ${polygon.length} points - using sampling for hit testing",
    );
    // Sample every 20th point for very large polygons to prevent freezing
    final sampledPolygon = <LatLng>[];
    for (int i = 0; i < polygon.length; i += 20) {
      sampledPolygon.add(polygon[i]);
    }
    polygon = sampledPolygon;
  }

  int intersections = 0;
  for (int i = 0; i < polygon.length; i++) {
    int j = (i + 1) % polygon.length;

    if ((polygon[i].longitude > point.longitude) !=
            (polygon[j].longitude > point.longitude) &&
        (point.latitude <
            (polygon[j].latitude - polygon[i].latitude) *
                    (point.longitude - polygon[i].longitude) /
                    (polygon[j].longitude - polygon[i].longitude) +
                polygon[i].latitude)) {
      intersections++;
    }
  }
  return intersections % 2 == 1;
}

// this utils function has to be clean and well documented
// no redundant code should be there

// FUTURE-PROOF: Adaptive data extraction helpers for API changes

/// Extracts area name from feature(for a specific area) with multiple fallback strategies
/// info and features comes from the GeoJSON structure
/// so if we make a model of the whole GeoJSON response, info is part of that model
/// so then we can pass that model instead of Map
/// then even we dont need this function to extract area name
/// as we can directly access it from the model
/// but for now we keep it like this for flexibility
///! so if we make the proper model of the GeoJSON response, we can remove this function
/// as we can directly access it from the model
/// * or can make modification in this function to accept model instead of Map
String _extractAreaName(
  Map<String, dynamic> info,
  Map<String, dynamic> feature,
) {
  // Try multiple possible field names for future API compatibility
  return info['name'] as String? ??
      info['title'] as String? ??
      info['area_name'] as String? ??
      info['areaName'] as String? ??
      feature['name'] as String? ??
      feature['title'] as String? ??
      'Unknown Area';
}

/// Extracts organization UID with fallback strategies
/// so if we make a model of the whole GeoJSON response, info is part of that model
/// so then we can pass that model instead of Map
/// then even we dont need this function to extract organization UID
/// as we can directly access it from the model
/// ! so if we make the proper model of the GeoJSON response, we can remove this function
/// as we can directly access it from the model
/// * or can make modification in this function to accept model instead of Map
String? _extractOrgUid(
  Map<String, dynamic> info,
  Map<String, dynamic> feature,
) {
  return info['org_uid'] as String? ??
      info['orgUid'] as String? ??
      info['uid'] as String? ??
      info['id'] as String? ??
      feature['org_uid'] as String? ??
      feature['uid'] as String? ??
      feature['id'] as String?;
}

/// Extracts slug with fallback strategies
/// so if we make a model of the whole GeoJSON response, info is part of that model
/// so then we can pass that model instead of Map
/// then even we dont need this function to extract slug
/// as we can directly access it from the model
/// ! so if we make the proper model of the GeoJSON response, we can remove this function
/// as we can directly access it from the model
/// * or can make modification in this function to accept model instead of Map
String? _extractSlug(Map<String, dynamic> info, Map<String, dynamic> feature) {
  return info['slug'] as String? ??
      info['area_slug'] as String? ??
      info['areaSlug'] as String? ??
      feature['slug'] as String?;
}

/// Extracts parent slug with fallback strategies
/// so if we make a model of the whole GeoJSON response, info is part of that model
/// so then we can pass that model instead of Map
/// then even we dont need this function to extract parent slug
/// as we can directly access it from the model
/// * or can make modification in this function to accept model instead of Map
/// ! so if we make the proper model of the GeoJSON response, we can remove this function
/// as we can directly access it from the model
String? _extractParentSlug(
  Map<String, dynamic> info,
  Map<String, dynamic> feature,
) {
  return info['parent_slug'] as String? ??
      info['parentSlug'] as String? ??
      info['parent'] as String? ??
      feature['parent_slug'] as String? ??
      feature['parent'] as String?;
}

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
    "Starting FUTURE-PROOF GeoJSON parsing: ${features.length} features, ${coverageMap.length} coverage areas for vaccine: $selectedVaccine",
  );

  // Enhanced debugging for future API changes
  //! will be removed later
  if (features.isNotEmpty) {
    final firstFeature = features[0];
    logg.d("Sample feature structure: ${firstFeature.runtimeType}");
    logg.d("Sample geometry type: ${firstFeature['geometry']?['type']}");
    logg.d(
      "!!!!!!!!!!!!!!!!!!!!Sample info keys: ${firstFeature['info']?.keys.toList()}",
    );
    logg.d(
      "Sample properties keys: ${firstFeature['properties']?.keys.toList()}",
    );

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

  // these counters are for logging and debugging purposes
  // to track how many features were processed, matched with coverage data, skipped, etc.
  // they help ensure the parsing logic is working as intended
  // features means each area in the GeoJSON
  // polygons means each polygon created for each area
  int matchedCount = 0;
  int noDataCount = 0;
  int processedFeatures = 0;
  int skippedFeatures = 0;
  int totalPolygonsCreated = 0;
  int totalRingsProcessed = 0;

  final List<AreaPolygon> polygonList = [];

  // FUTURE-PROOF: Process each feature individually to render ALL valid polygons
  for (final feature in features) {
    final geometry = feature['geometry'];

    // ADAPTIVE: Try both 'info' and 'properties' for future API compatibility
    final info = feature['info'] as Map<String, dynamic>? ?? {};

    // FLEXIBLE: Extract area information with fallbacks for future changes
    final String areaName = _extractAreaName(info, feature);
    final String? orgUid = _extractOrgUid(info, feature);
    final String? slug = _extractSlug(info, feature);
    final String? parentSlug = _extractParentSlug(info, feature);

    // Skip features without geometry - this is the ONLY valid reason to skip
    if (geometry == null) {
      logg.w(
        "Skipping feature $areaName - no geometry (this is the only valid skip reason)",
      );
      skippedFeatures++;
      continue;
    }

    // Find matching coverage data using org_uid from GeoJSON and uid from coverage
    //! IMPORTANT: Always process features even without coverage data
    // They will get default styling later
    // This ensures all areas are represented on the map even if coverage data is missing for some areas
    //* this is where we match coverage data with the geojson features
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
      // ALWAYS process features without coverage data - they'll get default styling
      logg.d(
        "No coverage data found for area: $areaName (org_uid: $orgUid) - will use default styling",
      );
    }

    final type = geometry['type'];

    // FUTURE-PROOF: Extract ALL rings from ANY valid geometry type
    List<List<LatLng>> allRings = [];

    if (type == 'Polygon') {
      allRings = _extractAllPolygonRings(geometry, areaName);
    } else if (type == 'MultiPolygon') {
      allRings = _extractAllMultiPolygonRings(geometry, areaName);
    } else if (type == 'Point' || type == 'LineString') {
      // Future API might include other geometry types - log but don't render
      logg.i(
        "Skipping non-polygon geometry type: $type for $areaName (valid for other purposes)",
      );
      skippedFeatures++;
      continue;
    } else {
      // Unknown geometry type - be defensive but informative
      logg.w(
        "Unknown geometry type: $type for $areaName - attempting polygon extraction anyway",
      );
      allRings = _extractAllPolygonRings(geometry, areaName);
    }

    totalRingsProcessed += allRings.length;

    // RENDER ALL VALID RINGS: No arbitrary limits or performance-based skipping
    for (int ringIndex = 0; ringIndex < allRings.length; ringIndex++) {
      final ring = allRings[ringIndex];

      // ONLY skip if coordinates are truly invalid (empty or insufficient points)
      if (ring.isEmpty || ring.length < 3) {
        logg.d(
          "$areaName: Skipping ring $ringIndex - insufficient coordinates (${ring.length} points)",
        );
        continue;
      }

      // Create unique identifier for each ring
      final ringAreaName = allRings.length > 1
          ? "$areaName (Part ${ringIndex + 1})"
          : areaName;

      final areaPolygon = _createAreaPolygon(
        ringAreaName,
        orgUid,
        coveragePercentage,
        ring,
        currentLevel,
        slug: slug,
        parentSlug: parentSlug,
      );

      if (areaPolygon != null) {
        polygonList.add(areaPolygon);
        totalPolygonsCreated++;
      }
    }

    processedFeatures++;
  }

  logg.i(
    "FUTURE-PROOF GeoJSON parsing completed in ${stopwatch.elapsedMilliseconds}ms: $processedFeatures features processed, $totalRingsProcessed rings processed, $totalPolygonsCreated polygons created, $matchedCount with coverage data, $noDataCount without data, $skippedFeatures skipped",
  );
  logg.i("Final comprehensive polygon count: ${polygonList.length}");

  stopwatch.stop();
  return polygonList;
}

// Helper function to extract ALL polygon rings from a Polygon geometry
// FUTURE-PROOF: Enhanced ring extraction for comprehensive polygon rendering
List<List<LatLng>> _extractAllPolygonRings(
  Map<String, dynamic> geometry,
  String areaName,
) {
  final List<List<LatLng>> rings = [];

  try {
    final polygonCoords = geometry['coordinates'];

    // ADAPTIVE: Handle different coordinate structures that may come from future APIs
    if (polygonCoords == null) {
      logg.w("$areaName: No coordinates found in polygon geometry");
      return rings;
    }

    if (polygonCoords is! List) {
      logg.w(
        "$areaName: Unexpected coordinate type: ${polygonCoords.runtimeType}",
      );
      return rings;
    }

    final coordsList = polygonCoords;
    logg.d("$areaName: Processing Polygon with ${coordsList.length} rings");

    // For Polygon: coordinates = [exterior_ring, hole1, hole2, ...]
    for (int ringIndex = 0; ringIndex < coordsList.length; ringIndex++) {
      try {
        final coords = coordsList[ringIndex];

        if (coords is! List) {
          logg.w(
            "$areaName: Unexpected ring coordinate type at $ringIndex: ${coords.runtimeType}",
          );
          continue;
        }

        final points = _extractCoordinates(coords, areaName);

        // COMPREHENSIVE: Process ALL valid coordinate sets
        if (points.length >= 3) {
          rings.add(points);
          logg.d(
            "$areaName: Successfully extracted polygon ring $ringIndex with ${points.length} points",
          );
        } else if (points.length == 2) {
          // ADAPTIVE: Handle minimal polygons gracefully
          points.add(
            points.last,
          ); // Duplicate last point to form a triangle as triangle is the simplest polygon, so we duplicate last point to make it a triangle
          rings.add(points);
          logg.d(
            "$areaName: Created minimal triangle for ring $ringIndex (2 points extended to 3)",
          );
        } else if (points.length == 1) {
          // FUTURE-PROOF: Handle single points that might represent areas
          final point = points.first;
          final minimalTriangle = [
            point,
            LatLng(point.latitude + 0.001, point.longitude),
            LatLng(point.latitude, point.longitude + 0.001),
          ];
          rings.add(minimalTriangle);
          logg.d(
            "$areaName: Created minimal triangle from single point at ring $ringIndex",
          );
        } else {
          logg.d(
            "$areaName: Skipping ring $ringIndex - insufficient valid coordinates (${points.length} points)",
          );
        }
      } catch (e) {
        logg.e("Error processing polygon ring $ringIndex for $areaName: $e");
        // RESILIENT: Continue with other rings instead of failing completely
        continue;
      }
    }
  } catch (e) {
    logg.e("Error extracting polygon rings for $areaName: $e");
    // GRACEFUL: Return what we have instead of empty list
  }

  logg.d(
    "$areaName: Successfully extracted ${rings.length} polygon rings total",
  );
  return rings;
}

// FUTURE-PROOF: Enhanced MultiPolygon extraction for comprehensive rendering
List<List<LatLng>> _extractAllMultiPolygonRings(
  Map<String, dynamic> geometry,
  String areaName,
) {
  final List<List<LatLng>> allRings = [];

  try {
    final multiPolygonCoords = geometry['coordinates'];

    // ADAPTIVE: Handle different coordinate structures
    if (multiPolygonCoords == null) {
      logg.w("$areaName: No coordinates found in multipolygon geometry");
      return allRings;
    }

    if (multiPolygonCoords is! List) {
      logg.w(
        "$areaName: Unexpected multipolygon coordinate type: ${multiPolygonCoords.runtimeType}",
      );
      return allRings;
    }

    final coordsList = multiPolygonCoords;
    logg.d(
      "$areaName: Processing MultiPolygon with ${coordsList.length} polygons",
    );

    // For MultiPolygon: coordinates = [polygon1, polygon2, ...]
    // Each polygon = [exterior_ring, hole1, hole2, ...]
    for (
      int polygonIndex = 0;
      polygonIndex < coordsList.length;
      polygonIndex++
    ) {
      try {
        final polygonCoords = coordsList[polygonIndex];

        if (polygonCoords is! List) {
          logg.w(
            "$areaName: Unexpected polygon coordinate type at $polygonIndex: ${polygonCoords.runtimeType}",
          );
          continue;
        }

        final polygonList = polygonCoords;

        // COMPREHENSIVE: Extract ALL rings from this polygon (exterior + holes)
        for (int ringIndex = 0; ringIndex < polygonList.length; ringIndex++) {
          try {
            final coords = polygonList[ringIndex];

            if (coords is! List) {
              logg.w(
                "$areaName: Unexpected ring coordinate type at polygon $polygonIndex ring $ringIndex: ${coords.runtimeType}",
              );
              continue;
            }

            final points = _extractCoordinates(coords, areaName);

            // COMPREHENSIVE: Process ALL valid coordinate sets
            if (points.length >= 3) {
              allRings.add(points);
              logg.d(
                "$areaName: Successfully extracted polygon $polygonIndex ring $ringIndex with ${points.length} points",
              );
            } else if (points.length == 2) {
              // ADAPTIVE: Handle minimal polygons gracefully
              points.add(points.last);
              allRings.add(points);
              logg.d(
                "$areaName: Created minimal triangle for polygon $polygonIndex ring $ringIndex (2 points extended to 3)",
              );
            } else if (points.length == 1) {
              // FUTURE-PROOF: Handle single points that might represent areas
              final point = points.first;
              final minimalTriangle = [
                point,
                LatLng(point.latitude + 0.001, point.longitude),
                LatLng(point.latitude, point.longitude + 0.001),
              ];
              allRings.add(minimalTriangle);
              logg.d(
                "$areaName: Created minimal triangle from single point at polygon $polygonIndex ring $ringIndex",
              );
            } else {
              logg.d(
                "$areaName: Skipping polygon $polygonIndex ring $ringIndex - insufficient valid coordinates (${points.length} points)",
              );
            }
          } catch (e) {
            logg.e(
              "Error processing polygon $polygonIndex ring $ringIndex for $areaName: $e",
            );
            // RESILIENT: Continue with other rings
            continue;
          }
        }
      } catch (e) {
        logg.e("Error processing polygon $polygonIndex for $areaName: $e");
        // RESILIENT: Continue with other polygons
        continue;
      }
    }
  } catch (e) {
    logg.e("Error extracting multipolygon rings for $areaName: $e");
    // GRACEFUL: Return what we have
  }

  logg.d(
    "$areaName: Successfully extracted ${allRings.length} total rings from MultiPolygon",
  );
  return allRings;
}

// FUTURE-PROOF: Enhanced coordinate extraction with comprehensive validation and error recovery
List<LatLng> _extractCoordinates(List<dynamic> coords, String areaName) {
  final validCoords = <LatLng>[];
  int invalidCount = 0;

  if (coords.isEmpty) {
    logg.w(
      "$areaName: Empty coordinates array - this might indicate an API structure change",
    );
    return validCoords;
  }

  // ADAPTIVE: Handle different coordinate formats that might come from future APIs
  for (int i = 0; i < coords.length; i++) {
    try {
      final coord = coords[i];

      // COMPREHENSIVE: Handle multiple possible coordinate formats
      double? lat, lng;

      if (coord is List && coord.length >= 2) {
        // Standard [lng, lat] format
        final dynamic lngValue = coord[0];
        final dynamic latValue = coord[1];

        if (lngValue is num && latValue is num) {
          lng = lngValue.toDouble();
          lat = latValue.toDouble();
        }
      } else if (coord is Map) {
        // FUTURE-PROOF: Handle object-based coordinates like {lat: x, lng: y} or {latitude: x, longitude: y}
        final latKeys = ['lat', 'latitude', 'y'];
        final lngKeys = ['lng', 'longitude', 'lon', 'x'];

        for (final key in latKeys) {
          if (coord[key] is num) {
            lat = (coord[key] as num).toDouble();
            break;
          }
        }

        for (final key in lngKeys) {
          if (coord[key] is num) {
            lng = (coord[key] as num).toDouble();
            break;
          }
        }
      } else if (coord is num &&
          i < coords.length - 1 &&
          coords[i + 1] is num) {
        // ADAPTIVE: Handle flat array format [lng1, lat1, lng2, lat2, ...]
        lng = coord.toDouble();
        lat = (coords[i + 1] as num).toDouble();
        i++; // Skip next element since we consumed it
      }

      // COMPREHENSIVE: Validate and add coordinate if valid
      if (lat != null && lng != null) {
        if (_isValidCoordinate(lat, lng)) {
          validCoords.add(LatLng(lat, lng));
        } else {
          invalidCount++;
          if (invalidCount <= 3) {
            // Log first few invalid coordinates for debugging API changes
            logg.d(
              "$areaName: Invalid coordinate at index $i: lat=$lat, lng=$lng (possible API change or data quality issue)",
            );
          }
        }
      } else {
        invalidCount++;
        if (invalidCount <= 3) {
          logg.d(
            "$areaName: Unparseable coordinate at index $i: $coord (format: ${coord.runtimeType})",
          );
        }
      }
    } catch (e) {
      invalidCount++;
      if (invalidCount <= 3) {
        logg.e("$areaName: Error processing coordinate at index $i: $e");
      }
      // RESILIENT: Continue processing other coordinates
      continue;
    }
  }

  // INFORMATIVE: Log summary for monitoring API changes
  if (invalidCount > 0) {
    logg.w(
      "$areaName: Processed ${coords.length} coordinates, found $invalidCount invalid (${((invalidCount / coords.length) * 100).toStringAsFixed(1)}% invalid rate)",
    );
  } else {
    logg.d(
      "$areaName: Successfully processed ${validCoords.length} coordinates with 100% validity",
    );
  }

  return validCoords;
}

// Helper function to validate individual coordinates
bool _isValidCoordinate(double lat, double lng) {
  // Check for NaN and infinite values
  if (!lat.isFinite || !lng.isFinite) {
    return false;
  }

  // Check for valid Earth coordinate ranges
  if (lat.abs() > 90.0 || lng.abs() > 180.0) {
    return false;
  }

  // Additional check for obviously wrong coordinates (zeros might be valid in some contexts)
  // For Bangladesh, latitude should be roughly 20-27 and longitude should be roughly 88-93
  // But we'll be permissive to handle edge cases and neighboring areas
  if (lat < -90.0 || lat > 90.0 || lng < -180.0 || lng > 180.0) {
    return false;
  }

  return true;
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

    // Allow drill-down based on geographic level capabilities
    final currentLevelEnum = GeographicLevel.fromString(currentLevel);
    final canDrillDown =
        currentLevelEnum.canDrillDown && slug != null && slug.isNotEmpty;

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
      canDrillDown:
          canDrillDown, // Allow drill-down from division, district, upazila, union, and ward levels
    );
  } catch (e) {
    logg.e("Error creating area polygon for $areaName: $e");
    return null;
  }
}
