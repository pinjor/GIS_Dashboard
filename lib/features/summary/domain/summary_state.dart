import 'package:gis_dashboard/features/map/domain/vaccine_coverage_response.dart';

class SummaryState {
  final VaccineCoverageResponse? coverageData;
  final bool isLoading;
  final String? error;

  SummaryState({this.coverageData, this.isLoading = false, this.error});

  SummaryState copyWith({
    VaccineCoverageResponse? coverageData,
    bool? isLoading,
    String? error,
  }) {
    return SummaryState(
      coverageData: coverageData ?? this.coverageData,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}
