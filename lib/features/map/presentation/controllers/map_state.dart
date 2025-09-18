import 'package:gis_dashboard/features/summary/domain/vaccine_coverage_response.dart';

import '../../../../core/utils/utils.dart';

/// Represents a level in the drilldown hierarchy
class DrilldownLevel {
  final String level;
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
    String? level,
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
  final String?
  geoJson; // GeoJSON data for the current map view e.g coordinates in GeoJSON format
  final VaccineCoverageResponse? coverageData; // Vaccine coverage data
  final String?
  epiData; // EPI vaccination centers data e.g coordinates in GeoJSON format
  final String currentLevel;
  final List<DrilldownLevel> navigationStack; // Stack to track drilldown levels
  final bool isLoading;
  final String? error;
  final String? currentAreaName; // Name of the current area being viewed

  MapState({
    this.geoJson,
    this.coverageData,
    this.epiData,
    this.currentLevel = 'district',
    this.navigationStack = const [],
    this.isLoading = false,
    this.error,
    this.currentAreaName,
  });

  MapState copyWith({
    String? geoJson,
    VaccineCoverageResponse? coverageData,
    String? epiData,
    String? currentLevel,
    List<DrilldownLevel>? navigationStack,
    bool? isLoading,
    String? error,
    String? currentAreaName,
    bool clearError = false,
  }) {
    return MapState(
      geoJson: geoJson ?? this.geoJson,
      coverageData: coverageData ?? this.coverageData,
      epiData: epiData ?? this.epiData,
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
            "Level: ${level.level}, Name: ${level.name} in displayPath::navigationStack",
          );
          final name = level.name ?? level.level;
          // Remove trailing parts that start with a space and then (some text)

          return name.replaceAll(RegExp(r'\s*\(.*?\)'), '').trim();
        })
        .join(' > ');
  }
}
