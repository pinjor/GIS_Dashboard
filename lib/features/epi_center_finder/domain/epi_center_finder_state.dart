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
  final String? selectedCenterId; // For highlighting selected center

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
    this.selectedCenterId,
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
    String? selectedCenterId,
    bool clearError = false,
    bool clearLocationError = false,
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
      selectedCenterId: selectedCenterId ?? this.selectedCenterId,
    );
  }
}
