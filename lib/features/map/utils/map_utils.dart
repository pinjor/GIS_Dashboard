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
    "Coverage data available for ${coverageMap.length} districts for vaccine: $selectedVaccine",
  );
  logg.i("Total GeoJSON features: ${features.length}");

  int matchedCount = 0;
  int noDataCount = 0;

  final polygonList = features
      .map((feature) {
        final geometry = feature['geometry'];
        final info = feature['info'];

        // Extract district information from GeoJSON
        final String areaName = info?['name'] ?? 'Unknown Area';
        final String? orgUid = info?['org_uid'];

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
          logg.w(
            "No coverage data found for district: $areaName (org_uid: $orgUid)",
          );
        }

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

        // Get color based on coverage percentage
        final polygonColor = CoverageColors.getCoverageColor(
          coveragePercentage,
        );

        return AreaPolygon(
          polygon: Polygon(
            points: points,
            color: polygonColor.withValues(
              alpha:
                  0.6, // Semi-transparent so underlying map labels show through
            ),
            borderColor: const Color(0xFF333333), // Dark border for visibility
            borderStrokeWidth: 1.0,
          ),
          areaId: orgUid ?? areaName,
          areaName: areaName,
          level: 'district',
          coveragePercentage: coveragePercentage ?? 0.0,
        );
      })
      .where((areaPolygon) => areaPolygon != null)
      .cast<AreaPolygon>()
      .toList();

  logg.i(
    "Processed $matchedCount districts with coverage data, $noDataCount without data",
  );
  return polygonList;
}
