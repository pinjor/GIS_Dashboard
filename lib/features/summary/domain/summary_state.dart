import 'package:gis_dashboard/features/map/domain/vaccine_coverage_response.dart';

class SummaryState {
  final VaccineCoverageResponse? coverageData;
  final bool isLoading;
  final String? error;
  final String currentLevel;
  final String currentAreaName;

  SummaryState({
    this.coverageData,
    this.isLoading = false,
    this.error,
    this.currentLevel = 'district',
    this.currentAreaName = 'Bangladesh',
  });

  SummaryState copyWith({
    VaccineCoverageResponse? coverageData,
    bool? isLoading,
    String? error,
    String? currentLevel,
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
