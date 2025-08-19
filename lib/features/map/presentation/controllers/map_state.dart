import 'package:gis_dashboard/features/map/domain/vaccine_coverage_response.dart';

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
  final String? geoJson;
  final VaccineCoverageResponse? coverageData;
  final String currentLevel;
  final List<DrilldownLevel> navigationStack;
  final bool isLoading;
  final String? error;
  final String? currentAreaName;

  MapState({
    this.geoJson,
    this.coverageData,
    this.currentLevel = 'district',
    this.navigationStack = const [],
    this.isLoading = false,
    this.error,
    this.currentAreaName,
  });

  MapState copyWith({
    String? geoJson,
    VaccineCoverageResponse? coverageData,
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
        .map((level) => level.name ?? level.level)
        .join(' > ');
  }
}
