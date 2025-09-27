import 'package:gis_dashboard/features/epi_center/domain/epi_center_coords_response.dart';
import 'package:gis_dashboard/features/map/domain/area_coords_geo_json_response.dart';
import 'package:gis_dashboard/features/summary/domain/vaccine_coverage_response.dart';
import 'package:gis_dashboard/features/map/utils/map_enums.dart';

import '../../../../core/utils/utils.dart';

/// Represents a level in the drilldown hierarchy
class DrilldownLevel {
  final GeographicLevel level;
  final String? slug;
  final String? name;
  final String? parentSlug;

  const DrilldownLevel({
    required this.level,
    this.slug,
    this.name,
    this.parentSlug,
  });

  DrilldownLevel copyWith({
    GeographicLevel? level,
    String? slug,
    String? name,
    String? parentSlug,
  }) {
    return DrilldownLevel(
      level: level ?? this.level,
      slug: slug ?? this.slug,
      name: name ?? this.name,
      parentSlug: parentSlug ?? this.parentSlug,
    );
  }
}

class MapState {
  final AreaCoordsGeoJsonResponse?
  areaCoordsGeoJsonData; // GeoJSON data for the current map view e.g coordinates in GeoJSON format
  final VaccineCoverageResponse? coverageData; // Vaccine coverage data
  final EpiCenterCoordsResponse?
  epiCenterCoordsData; // EPI vaccination centers data e.g coordinates in GeoJSON format
  final GeographicLevel currentLevel;
  final List<DrilldownLevel> navigationStack; // Stack to track drilldown levels
  final bool isLoading;
  final String? error;
  final String? currentAreaName; // Name of the current area being viewed

  MapState({
    this.areaCoordsGeoJsonData,
    this.coverageData,
    this.epiCenterCoordsData,
    this.currentLevel =
        GeographicLevel.country, // Fixed: Default to country level
    this.navigationStack = const [],
    this.isLoading = false,
    this.error,
    this.currentAreaName,
  });

  MapState copyWith({
    AreaCoordsGeoJsonResponse? areaCoordsGeoJsonData,
    VaccineCoverageResponse? coverageData,
    EpiCenterCoordsResponse? epiCenterCoordsData,
    GeographicLevel? currentLevel,
    List<DrilldownLevel>? navigationStack,
    bool? isLoading,
    String? error,
    String? currentAreaName,
    bool clearError = false,
    bool clearEpiData = false,
  }) {
    return MapState(
      areaCoordsGeoJsonData:
          areaCoordsGeoJsonData ?? this.areaCoordsGeoJsonData,
      coverageData: coverageData ?? this.coverageData,
      epiCenterCoordsData: clearEpiData
          ? null
          : (epiCenterCoordsData ?? this.epiCenterCoordsData),
      currentLevel: currentLevel ?? this.currentLevel,
      navigationStack: navigationStack ?? this.navigationStack,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      currentAreaName: currentAreaName ?? this.currentAreaName,
    );
  }

  /// Check if we can drill down (i.e., not at the top level)
  bool get canGoBack => navigationStack.isNotEmpty;

  /// Get the current area's slug for API calls
  String? get currentSlug =>
      navigationStack.isNotEmpty ? navigationStack.last.slug : null;

  /// Get the display path for breadcrumb navigation
  String get displayPath {
    if (navigationStack.isEmpty) return 'Bangladesh';

    return navigationStack
        .map((level) {
          logg.i(
            "Level: ${level.level.value}, Name: ${level.name} in displayPath::navigationStack",
          );
          final name = level.name ?? level.level.value;
          // Remove trailing parts that start with a space and then (some text)

          return name.replaceAll(RegExp(r'\s*\(.*?\)'), '').trim();
        })
        .join(' > ');
  }
}
