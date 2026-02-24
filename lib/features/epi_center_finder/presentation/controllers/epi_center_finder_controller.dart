import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../core/utils/utils.dart';
import '../../domain/epi_center_finder_state.dart';
import '../../domain/epi_center_result.dart';
import '../../data/epi_center_finder_repository.dart';

final epiCenterFinderControllerProvider =
    StateNotifierProvider<EpiCenterFinderController, EpiCenterFinderState>(
        (ref) {
  return EpiCenterFinderController(
    repository: ref.read(epiCenterFinderRepositoryProvider),
  );
});

class EpiCenterFinderController
    extends StateNotifier<EpiCenterFinderState> {
  final EpiCenterFinderRepository _repository;

  EpiCenterFinderController({
    required EpiCenterFinderRepository repository,
  })  : _repository = repository,
        super(EpiCenterFinderState(
          startDate: DateTime.now(),
          endDate: DateTime.now(),
        ));

  /// Update selected date range without searching
  void updateDateRange(DateTime startDate, DateTime endDate) {
    state = state.copyWith(
      startDate: startDate,
      endDate: endDate,
    );
  }

  /// Request location permission and get current location
  Future<void> requestLocationAndSearch(DateTime startDate, DateTime endDate) async {
    try {
      state = state.copyWith(
        isLoading: true,
        clearError: true,
        clearLocationError: true,
        startDate: startDate,
        endDate: endDate,
      );

      // Request location permission
      final permissionStatus = await Permission.location.request();
      
      if (permissionStatus.isDenied || permissionStatus.isPermanentlyDenied) {
        logg.w("EPI Center Finder: Location permission denied");
        state = state.copyWith(
          isLoading: false,
          hasLocationPermission: false,
          locationError: permissionStatus.isPermanentlyDenied
              ? 'Location permission is permanently denied. Please enable it in app settings.'
              : 'Location permission is required to find nearby EPI centers.',
        );
        return;
      }

      // Check if location services are enabled
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        logg.w("EPI Center Finder: Location services disabled");
        state = state.copyWith(
          isLoading: false,
          hasLocationPermission: true,
          locationError: 'Location services are disabled. Please enable GPS.',
        );
        return;
      }

      // Get current location
      logg.i("EPI Center Finder: Getting current location...");
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      logg.i(
        "EPI Center Finder: Location obtained - lat: ${position.latitude}, lng: ${position.longitude}",
      );

      state = state.copyWith(
        userLat: position.latitude,
        userLng: position.longitude,
        hasLocationPermission: true,
        clearLocationError: true,
      );

      // Now search for EPI centers
      await searchNearbyCenters(startDate, endDate, position.latitude, position.longitude);
    } catch (e) {
      logg.e("EPI Center Finder: Error getting location: $e");
      state = state.copyWith(
        isLoading: false,
        locationError: 'Failed to get location: ${e.toString()}',
      );
    }
  }

  /// Search for EPI centers near user location
  Future<void> searchNearbyCenters(
    DateTime startDate,
    DateTime endDate,
    double userLat,
    double userLng,
  ) async {
    try {
      state = state.copyWith(
        isLoading: true,
        clearError: true,
        startDate: startDate,
        endDate: endDate,
        userLat: userLat,
        userLng: userLng,
      );

      logg.i(
        "EPI Center Finder: Searching for centers near ($userLat, $userLng) from ${startDate.toString().split(' ')[0]} to ${endDate.toString().split(' ')[0]}",
      );

      // Fetch session plans for the selected date range
      final sessionPlanData = await _repository.fetchSessionPlansByDateRange(startDate, endDate);

      if (sessionPlanData.features == null ||
          sessionPlanData.features!.isEmpty) {
        logg.i("EPI Center Finder: No session plans found for date range");
        state = state.copyWith(
          isLoading: false,
          results: [],
          error: null,
        );
        return;
      }

      logg.i(
        "EPI Center Finder: Found ${sessionPlanData.features!.length} session plan features",
      );

      // Convert to EpiCenterResult and filter by distance (5km)
      final allResults = <EpiCenterResult>[];
      for (final feature in sessionPlanData.features!) {
        try {
          // Use start date for distance calculation (or parse from sessionDates if available)
          final result = EpiCenterResult.fromSessionPlanFeature(
            feature,
            userLat,
            userLng,
            startDate, // Use start date as reference
          );

          // Filter: only include centers within 5km
          if (result.distanceKm <= 5.0) {
            allResults.add(result);
          }
        } catch (e) {
          logg.w("EPI Center Finder: Error processing feature: $e");
          // Skip invalid features
          continue;
        }
      }

      // Sort by distance (nearest first)
      allResults.sort((a, b) => a.distanceKm.compareTo(b.distanceKm));

      logg.i(
        "EPI Center Finder: Found ${allResults.length} centers within 5km",
      );

      state = state.copyWith(
        isLoading: false,
        results: allResults,
        error: null,
      );
    } catch (e) {
      logg.e("EPI Center Finder: Error searching centers: $e");
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to search EPI centers: ${e.toString()}',
        results: [],
      );
    }
  }

  /// Select a center (for highlighting on map/table)
  void selectCenter(String? centerId) {
    state = state.copyWith(selectedCenterId: centerId);
  }

  /// Clear selection
  void clearSelection() {
    state = state.copyWith(selectedCenterId: null);
  }

  /// Open app settings for location permission
  Future<void> openAppSettingsForPermission() async {
    await openAppSettings();
  }
}
