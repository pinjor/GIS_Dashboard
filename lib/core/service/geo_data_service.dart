import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../features/map/domain/area_polygon.dart';
import '../common/constants/constants.dart';
import '../utils/load_json.dart';

class GeoDataService {
  static const Map<String, String> levelHierarchy = {
    'district': 'upazilla',
    'upazilla': 'unions',
    'unions': 'wards',
    'wards': 'subblocks',
  };

  static const Map<String, String> levelJsonPaths = {
    'district': Constants.districtGeoJsonPath,
    'upazilla': Constants.upazillaGeoJsonPath,
    'unions': Constants.unionsGeoJsonPath,
    'wards': Constants.wardsGeoJsonPath,
    'subblocks': Constants.subBlocksGeoJsonPath,
  };

  // Geographic bounds for major districts in Bangladesh
  static const Map<String, List<List<double>>> districtBounds = {
    'Dhaka': [
      [23.7808875, 90.2792398],
      [23.8203313, 90.2792398],
      [23.8203313, 90.4254871],
      [23.7808875, 90.4254871],
    ],
    'Chittagong': [
      [22.2172, 91.7700],
      [22.3847, 91.7700],
      [22.3847, 91.8850],
      [22.2172, 91.8850],
    ],
    'Rajshahi': [
      [24.3633, 88.5644],
      [24.3844, 88.5644],
      [24.3844, 88.6267],
      [24.3633, 88.6267],
    ],
    'Khulna': [
      [22.7758, 89.5403],
      [22.8456, 89.5403],
      [22.8456, 89.5847],
      [22.7758, 89.5847],
    ],
    'Sylhet': [
      [24.8897, 91.8611],
      [24.9144, 91.8611],
      [24.9144, 91.8889],
      [24.8897, 91.8889],
    ],
    'Barisal': [
      [22.6833, 90.3500],
      [22.7167, 90.3500],
      [22.7167, 90.3833],
      [22.6833, 90.3833],
    ],
  };

  /// Load coverage data for a specific administrative level
  static Future<Map<String, dynamic>> loadCoverageData(String level) async {
    final jsonPath = levelJsonPaths[level];
    if (jsonPath == null) {
      throw Exception('Unknown administrative level: $level');
    }
    return await loadJson(jsonPath);
  }

  /// Get color based on coverage percentage
  static Color getCoverageColor(double percentage) {
    if (percentage >= 80) return Colors.green.withOpacity(0.6);
    if (percentage >= 60) return Colors.yellow.withOpacity(0.6);
    if (percentage >= 40) return Colors.orange.withOpacity(0.6);
    return Colors.red.withOpacity(0.6);
  }

  /// Create polygons for districts with coverage data
  static List<AreaPolygon> createDistrictPolygons(
    Map<String, dynamic> coverageData,
  ) {
    final List<AreaPolygon> polygons = [];

    for (final districtEntry in districtBounds.entries) {
      final districtName = districtEntry.key;
      final bounds = districtEntry.value;

      final points = bounds.map((coord) => LatLng(coord[0], coord[1])).toList();

      // Find coverage data for this district
      double coveragePercentage = 0.0;
      String? districtId;

      if (coverageData['vaccines'] != null) {
        final vaccines = coverageData['vaccines'] as List;
        if (vaccines.isNotEmpty) {
          final vaccine = vaccines[0]; // Use first vaccine
          final areas = vaccine['areas'] as List?;
          if (areas != null) {
            final districtData = areas.firstWhere(
              (area) => area['name'] == districtName,
              orElse: () => null,
            );
            if (districtData != null) {
              coveragePercentage = (districtData['coverage_percentage'] ?? 0.0)
                  .toDouble();
              districtId = districtData['uid'] ?? 'unknown_$districtName';
            }
          }
        }
      }

      // Use a fallback ID if not found in data
      districtId ??=
          'district_${districtName.toLowerCase().replaceAll(' ', '_')}';

      polygons.add(
        AreaPolygon(
          polygon: Polygon(
            points: points,
            color: getCoverageColor(coveragePercentage),
            borderColor: Colors.blue.withOpacity(0.8),
            borderStrokeWidth: 2.0,
            isFilled: true,
          ),
          areaId: districtId,
          areaName: districtName,
          level: 'district',
          coveragePercentage: coveragePercentage,
        ),
      );
    }

    return polygons;
  }

  /// Create sub-level polygons (dummy implementation)
  static List<AreaPolygon> createSubLevelPolygons(
    String parentId,
    String level,
    Map<String, dynamic> coverageData,
  ) {
    final List<AreaPolygon> polygons = [];

    // Generate dummy sub-divisions
    for (int i = 1; i <= 4; i++) {
      final subAreaId = '${parentId}_${level}_$i';
      final subAreaName = '$level $i';
      final bounds = _generateRandomBounds();

      final points = bounds.map((coord) => LatLng(coord[0], coord[1])).toList();

      // Simulate coverage data for sub-areas
      final coveragePercentage = (20.0 + (i * 15)) % 100;

      polygons.add(
        AreaPolygon(
          polygon: Polygon(
            points: points,
            color: getCoverageColor(coveragePercentage),
            borderColor: Colors.blue.withOpacity(0.8),
            borderStrokeWidth: 1.5,
            isFilled: true,
          ),
          areaId: subAreaId,
          areaName: subAreaName,
          level: level,
          coveragePercentage: coveragePercentage,
        ),
      );
    }

    return polygons;
  }

  static List<List<double>> _generateRandomBounds() {
    // Generate a small rectangular area for demonstration
    final baseLat =
        23.7 + (DateTime.now().millisecondsSinceEpoch % 1000) / 10000;
    final baseLng =
        90.3 + (DateTime.now().millisecondsSinceEpoch % 1000) / 10000;
    const size = 0.05;

    return [
      [baseLat, baseLng],
      [baseLat + size, baseLng],
      [baseLat + size, baseLng + size],
      [baseLat, baseLng + size],
    ];
  }

  /// Check if a point is inside a polygon
  static bool isPointInPolygon(LatLng point, List<LatLng> polygon) {
    int intersections = 0;
    for (int i = 0; i < polygon.length; i++) {
      int j = (i + 1) % polygon.length;
      if (_isIntersecting(point, polygon[i], polygon[j])) {
        intersections++;
      }
    }
    return intersections % 2 == 1;
  }

  static bool _isIntersecting(LatLng point, LatLng p1, LatLng p2) {
    if (p1.latitude > point.latitude != p2.latitude > point.latitude) {
      double slope =
          (point.longitude - p1.longitude) / (point.latitude - p1.latitude);
      double intersectLng =
          p1.longitude + slope * (point.latitude - p1.latitude);
      return point.longitude < intersectLng;
    }
    return false;
  }
}
