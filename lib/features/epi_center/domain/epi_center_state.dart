import 'epi_center_details_response.dart';

class EpiCenterState {
  final bool isLoading;
  final bool hasError;
  final String? errorMessage;
  final EpiCenterDetailsResponse? epiCenterData;
  final String? currentEpiUid;
  final String? currentCcUid;
  final int selectedYear;

  const EpiCenterState({
    this.isLoading = false,
    this.hasError = false,
    this.errorMessage,
    this.epiCenterData,
    this.currentEpiUid,
    this.currentCcUid,
    this.selectedYear = 2025,
  });

  EpiCenterState copyWith({
    bool? isLoading,
    bool? hasError,
    String? errorMessage,
    EpiCenterDetailsResponse? epiCenterData,
    String? currentEpiUid,
    String? currentCcUid,
    int? selectedYear,
    bool clearEpiCenterData = false,
    bool clearError = false,
  }) {
    return EpiCenterState(
      isLoading: isLoading ?? this.isLoading,
      hasError: clearError ? false : (hasError ?? this.hasError),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      epiCenterData:
          clearEpiCenterData ? null : (epiCenterData ?? this.epiCenterData),
      currentEpiUid: currentEpiUid ?? this.currentEpiUid,
      currentCcUid: currentCcUid ?? this.currentCcUid,
      selectedYear: selectedYear ?? this.selectedYear,
    );
  }
}
