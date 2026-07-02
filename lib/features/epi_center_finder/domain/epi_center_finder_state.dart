import '../../epi_center/domain/epi_center_details_response.dart';
import 'epi_center_result.dart';

/// State for EPI Center Finder
class EpiCenterFinderState {
  final bool isLoading;
  final String? error;
  final List<EpiCenterResult> results;
  final double? userLat;
  final double? userLng;
  final bool hasLocationPermission;
  final String? locationError;
  final DateTime? startDate;
  final DateTime? endDate;
  final int? sessionCount;
  final String? selectedCenterId;
  final bool isLoadingDetails;
  final String? detailsError;
  final EpiCenterDetailsResponse? selectedCenterDetails;

  EpiCenterFinderState({
    this.isLoading = false,
    this.error,
    this.results = const [],
    this.userLat,
    this.userLng,
    this.hasLocationPermission = false,
    this.locationError,
    this.startDate,
    this.endDate,
    this.sessionCount,
    this.selectedCenterId,
    this.isLoadingDetails = false,
    this.detailsError,
    this.selectedCenterDetails,
  });

  EpiCenterFinderState copyWith({
    bool? isLoading,
    String? error,
    List<EpiCenterResult>? results,
    double? userLat,
    double? userLng,
    bool? hasLocationPermission,
    String? locationError,
    DateTime? startDate,
    DateTime? endDate,
    int? sessionCount,
    String? selectedCenterId,
    bool? isLoadingDetails,
    String? detailsError,
    EpiCenterDetailsResponse? selectedCenterDetails,
    bool clearError = false,
    bool clearLocationError = false,
    bool clearDetailsError = false,
    bool clearSelectedCenterDetails = false,
  }) {
    return EpiCenterFinderState(
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      results: results ?? this.results,
      userLat: userLat ?? this.userLat,
      userLng: userLng ?? this.userLng,
      hasLocationPermission:
          hasLocationPermission ?? this.hasLocationPermission,
      locationError: clearLocationError
          ? null
          : (locationError ?? this.locationError),
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      sessionCount: sessionCount ?? this.sessionCount,
      selectedCenterId: selectedCenterId ?? this.selectedCenterId,
      isLoadingDetails: isLoadingDetails ?? this.isLoadingDetails,
      detailsError: clearDetailsError
          ? null
          : (detailsError ?? this.detailsError),
      selectedCenterDetails: clearSelectedCenterDetails
          ? null
          : (selectedCenterDetails ?? this.selectedCenterDetails),
    );
  }
}
