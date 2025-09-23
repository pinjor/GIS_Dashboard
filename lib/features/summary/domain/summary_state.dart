import 'package:gis_dashboard/features/summary/domain/vaccine_coverage_response.dart';
import 'package:gis_dashboard/features/map/utils/map_enums.dart';

class SummaryState {
  final VaccineCoverageResponse? coverageData;
  final bool isLoading;
  final String? error;
  final GeographicLevel currentLevel;
  final String currentAreaName;

  SummaryState({
    this.coverageData,
    this.isLoading = false,
    this.error,
    this.currentLevel =
        GeographicLevel.country, // Fixed: Initial level should be country
    this.currentAreaName = 'Bangladesh',
  });

  SummaryState copyWith({
    VaccineCoverageResponse? coverageData,
    bool? isLoading,
    String? error,
    GeographicLevel? currentLevel,
    String? currentAreaName,
  }) {
    return SummaryState(
      coverageData: coverageData ?? this.coverageData,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      currentLevel: currentLevel ?? this.currentLevel,
      currentAreaName: currentAreaName ?? this.currentAreaName,
    );
  }
}
