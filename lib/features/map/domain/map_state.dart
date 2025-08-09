import 'package:gis_dashboard/features/map/domain/vaccine_coverage.dart';

class MapState {
  final String? geoJson;
  final List<VaccineCoverage>? coverageData;
  final String currentLevel;
  final bool isLoading;

  MapState({
    this.geoJson,
    this.coverageData,
    this.currentLevel = 'district',
    this.isLoading = false,
  });

  MapState copyWith({
    String? geoJson,
    List<VaccineCoverage>? coverageData,
    String? currentLevel,
    bool? isLoading,
  }) {
    return MapState(
      geoJson: geoJson ?? this.geoJson,
      coverageData: coverageData ?? this.coverageData,
      currentLevel: currentLevel ?? this.currentLevel,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}