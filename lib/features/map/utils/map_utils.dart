import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../../core/utils/utils.dart';
import '../domain/area_polygon.dart';
import '../domain/vaccine_coverage.dart';

List<AreaPolygon> parseGeoJsonToPolygons(
  String geoJson,
  List<VaccineCoverage> coverageData,
) {
  final decoded = jsonDecode(geoJson) as Map<String, dynamic>;
  final features = decoded['features'] as List<dynamic>;

  logg.i(
    "Parsing ${features.length} GeoJSON features with ${coverageData.length} coverage areas",
  );

  return features
      .map((feature) {
        final props = feature['properties'] ?? {};
        final String areaName = props['name'] ?? 'Unknown Area';
        final String areaId = props['uid'] ?? props['id'] ?? areaName;

        // Find coverage data for this area using UID
        final coverage = coverageData.firstWhere(
          (c) =>
              c.uid == areaId || c.name.toLowerCase() == areaName.toLowerCase(),
          orElse: () => VaccineCoverage(
            uid: areaId,
            name: areaName,
            coveragePercentage: 0,
          ),
        );

        final geometry = feature['geometry'];
        final type = geometry['type'];

        List<LatLng> points = [];

        if (type == 'Polygon') {
          final coords = geometry['coordinates'][0] as List<dynamic>;
          points = coords
              .map((coord) {
                if (coord is List && coord.length >= 2) {
                  final lat = coord[1] as num;
                  final lng = coord[0] as num;
                  // Validate coordinates are within Bangladesh bounds
                  if (lat >= 20.5 &&
                      lat <= 26.8 &&
                      lng >= 88.0 &&
                      lng <= 92.8) {
                    return LatLng(lat.toDouble(), lng.toDouble());
                  }
                }
                return null;
              })
              .where((point) => point != null)
              .cast<LatLng>()
              .toList();
        } else if (type == 'MultiPolygon') {
          // Take the first polygon from multipolygon
          final coords = geometry['coordinates'][0][0] as List<dynamic>;
          points = coords
              .map((coord) {
                if (coord is List && coord.length >= 2) {
                  final lat = coord[1] as num;
                  final lng = coord[0] as num;
                  // Validate coordinates are within Bangladesh bounds
                  if (lat >= 20.5 &&
                      lat <= 26.8 &&
                      lng >= 88.0 &&
                      lng <= 92.8) {
                    return LatLng(lat.toDouble(), lng.toDouble());
                  }
                }
                return null;
              })
              .where((point) => point != null)
              .cast<LatLng>()
              .toList();
        }

        // Skip polygons with insufficient valid coordinates
        if (points.length < 3) {
          logg.w(
            "Skipping polygon for $areaName - insufficient valid coordinates",
          );
          return null;
        }

        return AreaPolygon(
          polygon: Polygon(
            points: points,
            color: Colors.white.withValues(
              alpha: 0.3,
            ), // Very transparent white so underlying names show through
            borderColor: const Color(
              0xFF333333,
            ), // Darker border for visibility
            borderStrokeWidth: 1.0,
          ),
          areaId: areaId,
          areaName: areaName,
          level: 'district',
          coveragePercentage: coverage.coveragePercentage,
        );
      })
      .where((areaPolygon) => areaPolygon != null)
      .cast<AreaPolygon>()
      .toList();
}
