import 'package:gis_dashboard/features/map/domain/vaccine_coverage_response.dart';

class MapState {
  final String? geoJson;
  final VaccineCoverageResponse? coverageData;
  final String currentLevel;
  final bool isLoading;
  final String? error;

  MapState({
    this.geoJson,
    this.coverageData,
    this.currentLevel = 'district',
    this.isLoading = false,
    this.error,
  });

  MapState copyWith({
    String? geoJson,
    VaccineCoverageResponse? coverageData,
    String? currentLevel,
    bool? isLoading,
    String? error,
  }) {
    return MapState(
      geoJson: geoJson ?? this.geoJson,
      coverageData: coverageData ?? this.coverageData,
      currentLevel: currentLevel ?? this.currentLevel,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}
