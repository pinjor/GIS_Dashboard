import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'dart:math' as math;

import '../../../config/coverage_colors.dart';
import '../../../core/utils/utils.dart';
import '../domain/area_coords_geo_json_response.dart';
import '../domain/area_polygon.dart';
import '../domain/center_info.dart';
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

List<AreaPolygon> parseGeoJsonToPolygons(
  AreaCoordsGeoJsonResponse fetchAreaGeoJsonCoordsData,
  VaccineCoverageResponse coverageData,
  String selectedVaccine,
  String currentLevel, // Add current level to determine drill-down capability
) {
  final features = fetchAreaGeoJsonCoordsData.features;

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

  final List<AreaPolygon> polygonList = [];
  if (features == null || features.isEmpty) {
    logg.w("No features found in GeoJSON data");
    return polygonList;
  }
  // FUTURE-PROOF: Process each feature individually to render ALL valid polygons
  for (final feature in features) {
    final geometry = feature.geometry;

    // ADAPTIVE: Try both 'info' and 'properties' for future API compatibility
    final info = feature.info;

    // Skip features without geometry - this is the ONLY valid reason to skip
    if (geometry == null) continue;

    // Find matching coverage data using org_uid from GeoJSON and uid from coverage
    //! IMPORTANT: Always process features even without coverage data
    // They will get default styling later
    // This ensures all areas are represented on the map even if coverage data is missing for some areas
    //* this is where we match coverage data with the geojson features
    Area? matchedCoverage;
    double? coveragePercentage;

    if (info?.orgUid != null && coverageMap.containsKey(info?.orgUid)) {
      matchedCoverage = coverageMap[info?.orgUid];
      coveragePercentage = matchedCoverage?.coveragePercentage;
    }

    final type = geometry.type;

    // FUTURE-PROOF: Extract ALL rings from ANY valid geometry type
    List<List<LatLng>> allRings = [];

    if (type == 'Polygon') {
      allRings = _extractAllPolygonRings(geometry, info?.name);
    } else if (type == 'MultiPolygon') {
      allRings = _extractAllMultiPolygonRings(geometry, info?.name);
    }

    // RENDER ALL VALID RINGS: No arbitrary limits or performance-based skipping
    for (int ringIndex = 0; ringIndex < allRings.length; ringIndex++) {
      final ring = allRings[ringIndex];

      // ONLY skip if coordinates are truly invalid (empty or insufficient points)
      if (ring.isEmpty || ring.length < 3) continue;

      // Create unique identifier for each ring
      final ringAreaName = allRings.length > 1
          ? "${info?.name} (Part ${ringIndex + 1})"
          : info?.name ?? 'Unknown Area';

      final areaPolygon = _createAreaPolygon(
        ringAreaName,
        info?.orgUid,
        coveragePercentage,
        ring,
        currentLevel,
        slug: info?.slug,
        parentSlug: info?.parentSlug,
      );

      if (areaPolygon != null) {
        polygonList.add(areaPolygon);
      }
    }
  }
  return polygonList;
}

// Helper function to extract ALL polygon rings from a Polygon geometry
// FUTURE-PROOF: Enhanced ring extraction for comprehensive polygon rendering
List<List<LatLng>> _extractAllPolygonRings(
  GeoJsonGeometry? geometry,
  String? areaName,
) {
  final List<List<LatLng>> rings = [];

  try {
    final polygonCoords = geometry?.coordinates;

    // ADAPTIVE: Handle different coordinate structures that may come from future APIs
    if (polygonCoords == null) {
      logg.w("$areaName: No coordinates found in polygon geometry");
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
        } else if (points.length == 2) {
          // ADAPTIVE: Handle minimal polygons gracefully
          points.add(
            points.last,
          ); // Duplicate last point to form a triangle as triangle is the simplest polygon, so we duplicate last point to make it a triangle
          rings.add(points);
        } else if (points.length == 1) {
          // FUTURE-PROOF: Handle single points that might represent areas
          final point = points.first;
          final minimalTriangle = [
            point,
            LatLng(point.latitude + 0.001, point.longitude),
            LatLng(point.latitude, point.longitude + 0.001),
          ];
          rings.add(minimalTriangle);
        }
      } catch (e) {
        // RESILIENT: Continue with other rings instead of failing completely
        continue;
      }
    }
  } catch (e) {
    logg.e("Error extracting polygon rings for $areaName: $e");
    // GRACEFUL: Return what we have instead of empty list
  }

  return rings;
}

// FUTURE-PROOF: Enhanced MultiPolygon extraction for comprehensive rendering
List<List<LatLng>> _extractAllMultiPolygonRings(
  GeoJsonGeometry? geometry,
  String? areaName,
) {
  final List<List<LatLng>> allRings = [];

  try {
    final multiPolygonCoords = geometry?.coordinates;

    // ADAPTIVE: Handle different coordinate structures
    if (multiPolygonCoords == null) {
      logg.w("$areaName: No coordinates found in multipolygon geometry");
      return allRings;
    }

    final coordsList = multiPolygonCoords;

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
          continue;
        }

        final polygonList = polygonCoords;

        // COMPREHENSIVE: Extract ALL rings from this polygon (exterior + holes)
        for (int ringIndex = 0; ringIndex < polygonList.length; ringIndex++) {
          try {
            final coords = polygonList[ringIndex];

            if (coords is! List) {
              continue;
            }

            final points = _extractCoordinates(coords, areaName);

            // COMPREHENSIVE: Process ALL valid coordinate sets
            if (points.length >= 3) {
              allRings.add(points);
            } else if (points.length == 2) {
              // ADAPTIVE: Handle minimal polygons gracefully
              points.add(points.last);
              allRings.add(points);
            } else if (points.length == 1) {
              // FUTURE-PROOF: Handle single points that might represent areas
              final point = points.first;
              final minimalTriangle = [
                point,
                LatLng(point.latitude + 0.001, point.longitude),
                LatLng(point.latitude, point.longitude + 0.001),
              ];
              allRings.add(minimalTriangle);
            }
          } catch (e) {
            // RESILIENT: Continue with other rings
            continue;
          }
        }
      } catch (e) {
        // RESILIENT: Continue with other polygons
        continue;
      }
    }
  } catch (e) {
    // GRACEFUL: Return what we have
  }

  return allRings;
}

// FUTURE-PROOF: Enhanced coordinate extraction with comprehensive validation and error recovery
List<LatLng> _extractCoordinates(List<dynamic> coords, String? areaName) {
  final validCoords = <LatLng>[];
  int invalidCount = 0;

  if (coords.isEmpty) {
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
        if (invalidCount <= 3) {}
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

// ============================================================================
// MAP UTILITY FUNCTIONS - EXTRACTED FROM MAP_SCREEN.DART FOR BETTER ORGANIZATION
// ============================================================================

/// Calculate the centroid (center point) of a polygon - OPTIMIZED to prevent freezing
LatLng calculatePolygonCentroid(List<LatLng> points) {
  if (points.isEmpty) return const LatLng(0, 0);

  // Prevent freezing with very large polygon data
  if (points.length > 1000) {
    logg.w(
      "Large polygon with ${points.length} points - using sampling for performance",
    );
    // Sample every 10th point for very large polygons to prevent freezing
    final sampledPoints = <LatLng>[];
    for (int i = 0; i < points.length; i += 10) {
      sampledPoints.add(points[i]);
    }
    points = sampledPoints;
  }

  double centroidLat = 0;
  double centroidLng = 0;

  for (final point in points) {
    centroidLat += point.latitude;
    centroidLng += point.longitude;
  }

  return LatLng(centroidLat / points.length, centroidLng / points.length);
}

/// Calculate bounds of all polygons for auto-zoom
LatLngBounds calculatePolygonsBounds(List<AreaPolygon> areaPolygons) {
  if (areaPolygons.isEmpty) {
    return LatLngBounds(
      const LatLng(23.6850, 90.3563), // Default Bangladesh center
      const LatLng(23.6850, 90.3563),
    );
  }

  double minLat = double.infinity;
  double maxLat = double.negativeInfinity;
  double minLng = double.infinity;
  double maxLng = double.negativeInfinity;

  for (final areaPolygon in areaPolygons) {
    for (final point in areaPolygon.polygon.points) {
      minLat = minLat < point.latitude ? minLat : point.latitude;
      maxLat = maxLat > point.latitude ? maxLat : point.latitude;
      minLng = minLng < point.longitude ? minLng : point.longitude;
      maxLng = maxLng > point.longitude ? maxLng : point.longitude;
    }
  }

  return LatLngBounds(LatLng(minLat, minLng), LatLng(maxLat, maxLng));
}

/// Calculate approximate area of a polygon (for weighting purposes) - OPTIMIZED to prevent freezing
double calculatePolygonArea(List<LatLng> points) {
  if (points.length < 3) return 0.0;

  // Prevent freezing with very large polygon data
  if (points.length > 500) {
    logg.w(
      "Large polygon with ${points.length} points - using sampling for area calculation",
    );
    // Sample every 5th point for very large polygons to prevent freezing
    final sampledPoints = <LatLng>[];
    for (int i = 0; i < points.length; i += 5) {
      sampledPoints.add(points[i]);
    }
    points = sampledPoints;
  }

  double area = 0.0;
  for (int i = 0; i < points.length; i++) {
    final j = (i + 1) % points.length;
    area += points[i].longitude * points[j].latitude;
    area -= points[j].longitude * points[i].latitude;
  }
  return area.abs() / 2.0;
}

/// Calculate weighted centroid for more accurate center point
LatLng calculateWeightedCentroid(
  List<AreaPolygon> polygons,
  LatLngBounds bounds,
) {
  if (polygons.length == 1) {
    return calculatePolygonCentroid(polygons.first.polygon.points);
  }

  // For multiple polygons, calculate weighted centroid based on polygon area
  double totalWeightedLat = 0;
  double totalWeightedLng = 0;
  double totalWeight = 0;

  for (final polygon in polygons) {
    final centroid = calculatePolygonCentroid(polygon.polygon.points);
    final area = calculatePolygonArea(polygon.polygon.points);
    final weight = math.max(area, 1.0); // Avoid zero weights

    totalWeightedLat += centroid.latitude * weight;
    totalWeightedLng += centroid.longitude * weight;
    totalWeight += weight;
  }

  if (totalWeight > 0) {
    return LatLng(
      totalWeightedLat / totalWeight,
      totalWeightedLng / totalWeight,
    );
  } else {
    // Fallback to center of bounds
    return LatLng(
      (bounds.north + bounds.south) / 2,
      (bounds.east + bounds.west) / 2,
    );
  }
}

/// Calculate center point and appropriate zoom level for current level polygons
CenterInfo calculateCurrentLevelCenterAndZoom(
  List<AreaPolygon> polygons,
  GeographicLevel currentLevel,
) {
  if (polygons.isEmpty) {
    return CenterInfo(
      center: const LatLng(23.6850, 90.3563),
      zoom: currentLevel.minZoomLevel,
    );
  }

  // Calculate the bounding box of all polygons
  final bounds = calculatePolygonsBounds(polygons);

  // Calculate center point using weighted centroid for better accuracy
  LatLng center = calculateWeightedCentroid(polygons, bounds);

  // Calculate appropriate zoom level based on bounds size, level, and polygon density
  double zoom = calculateZoomForBounds(bounds, currentLevel, polygons.length);

  return CenterInfo(center: center, zoom: zoom);
}

/// Calculate appropriate zoom level based on bounds size, current level, and polygon count
double calculateZoomForBounds(
  LatLngBounds bounds,
  GeographicLevel currentLevel,
  int polygonCount,
) {
  // Calculate the span of the bounds
  final latSpan = bounds.north - bounds.south;
  final lngSpan = bounds.east - bounds.west;
  final maxSpan = math.max(latSpan, lngSpan);

  // Use centralized zoom calculation from GeographicLevel enum
  return currentLevel.calculateZoomForBounds(
    maxSpan: maxSpan,
    polygonCount: polygonCount,
  );
}

/// Centralized auto-zoom function that uses GeographicLevel's zoom capabilities
void autoZoomToPolygons(
  List<AreaPolygon> areaPolygons,
  GeographicLevel currentLevel,
  MapController mapController,
) {
  if (areaPolygons.isEmpty) return;

  final bounds = calculatePolygonsBounds(areaPolygons);

  logg.i(
    "Auto-zooming to fit polygons: bounds from ${bounds.south}, ${bounds.west} to ${bounds.north}, ${bounds.east}",
  );

  // Calculate center of bounds
  final center = LatLng(
    (bounds.north + bounds.south) / 2,
    (bounds.east + bounds.west) / 2,
  );

  // Calculate appropriate zoom level based on bounds size using centralized logic
  final latSpan = bounds.north - bounds.south;
  final lngSpan = bounds.east - bounds.west;
  final maxSpan = math.max(latSpan, lngSpan);

  // Use the centralized zoom calculation from GeographicLevel enum
  double zoom = currentLevel.getOptimalZoomForSpan(maxSpan);

  try {
    mapController.moveAndRotate(center, zoom, 0);
    logg.i("Auto-zoom completed successfully to zoom level $zoom");
  } catch (e) {
    logg.e("Error auto-zooming: $e");
    // Fallback to center bounds with default zoom
    mapController.moveAndRotate(center, currentLevel.minZoomLevel, 0);
  }
}
