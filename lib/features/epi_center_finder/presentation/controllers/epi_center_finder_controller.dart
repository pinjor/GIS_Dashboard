import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../core/service/data_service.dart';
import '../../../../core/utils/utils.dart';
import '../../../epi_center/domain/epi_center_details_response.dart';
import '../../domain/epi_center_finder_state.dart';
import '../../domain/epi_center_result.dart';
import '../../data/epi_center_finder_repository.dart';
import '../../../filter/presentation/controllers/filter_controller.dart';
import '../../../map/utils/map_enums.dart';
import '../../../session_plan/utils/session_plan_area_param_builder.dart';

final epiCenterFinderControllerProvider =
    StateNotifierProvider<EpiCenterFinderController, EpiCenterFinderState>(
        (ref) {
  return EpiCenterFinderController(
    repository: ref.read(epiCenterFinderRepositoryProvider),
    ref: ref,
  );
});

class EpiCenterFinderController
    extends StateNotifier<EpiCenterFinderState> {
  final EpiCenterFinderRepository _repository;
  final Ref _ref;
  final Map<String, EpiCenterDetailsResponse> _detailsCache = {};

  EpiCenterFinderController({
    required EpiCenterFinderRepository repository,
    required Ref ref,
  })  : _repository = repository,
        _ref = ref,
        super(EpiCenterFinderState(
          startDate: DateTime.now(),
          endDate: DateTime.now(),
        ));

  void setDateRange(DateTime startDate, DateTime endDate) {
    state = state.copyWith(startDate: startDate, endDate: endDate);
  }

  /// Search EPI centers using the selected date range and geographic filters.
  Future<void> searchWithCurrentFilters() async {
    final start = state.startDate ?? DateTime.now();
    final end = state.endDate ?? DateTime.now();
    await requestLocationAndSearch(start, end);
  }

  String? _resolveAreaParam() {
    final filterState = _ref.read(filterControllerProvider);
    final filterNotifier = _ref.read(filterControllerProvider.notifier);

    if (filterState.selectedAreaType == AreaType.cityCorporation &&
        SessionPlanAreaParamBuilder.isCityCorporationUnselected(filterState)) {
      return null;
    }

    return SessionPlanAreaParamBuilder.build(filterState, filterNotifier);
  }

  /// Request location permission and get current location, then search.
  Future<void> requestLocationAndSearch(
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      state = state.copyWith(
        isLoading: true,
        clearError: true,
        clearLocationError: true,
        startDate: startDate,
        endDate: endDate,
      );

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

      await searchNearbyCenters(
        startDate,
        endDate,
        position.latitude,
        position.longitude,
      );
    } catch (e) {
      logg.e("EPI Center Finder: Error getting location: $e");
      state = state.copyWith(
        isLoading: false,
        locationError: 'Failed to get location: ${e.toString()}',
      );
    }
  }

  /// Search for EPI centers near user location within filtered session plans.
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

      final areaParam = _resolveAreaParam();

      logg.i(
        "EPI Center Finder: Searching near ($userLat, $userLng), area: ${areaParam ?? 'country'}, date: ${startDate.toString().split(' ')[0]}",
      );

      final sessionPlanData = await _repository.fetchSessionPlans(
        startDate: startDate,
        endDate: endDate,
        areaParam: areaParam,
      );

      if (sessionPlanData.features == null ||
          sessionPlanData.features!.isEmpty) {
        logg.i("EPI Center Finder: No session plans found for filters");
        _detailsCache.clear();
        state = state.copyWith(
          isLoading: false,
          results: [],
          sessionCount: 0,
          selectedCenterId: null,
          clearSelectedCenterDetails: true,
          clearDetailsError: true,
          error: null,
        );
        return;
      }

      logg.i(
        "EPI Center Finder: Found ${sessionPlanData.features!.length} session plan features",
      );

      final allResults = <EpiCenterResult>[];
      for (final feature in sessionPlanData.features!) {
        try {
          final result = EpiCenterResult.fromSessionPlanFeature(
            feature,
            userLat,
            userLng,
            startDate,
          );

          allResults.add(result);
        } catch (e) {
          logg.w("EPI Center Finder: Error processing feature: $e");
          continue;
        }
      }

      final uniqueResults = <String, EpiCenterResult>{};

      for (final result in allResults) {
        final uniqueKey = result.orgUid ?? '${result.lat}_${result.lng}';

        if (uniqueResults.containsKey(uniqueKey)) {
          final existing = uniqueResults[uniqueKey]!;
          if (result.sessionDate.isBefore(existing.sessionDate)) {
            uniqueResults[uniqueKey] = result;
          }
        } else {
          uniqueResults[uniqueKey] = result;
        }
      }

      final deduplicatedResults = uniqueResults.values.toList()
        ..sort((a, b) => a.distanceKm.compareTo(b.distanceKm));

      final visibleCount = deduplicatedResults.length;
      logg.i(
        "EPI Center Finder: $visibleCount centers to display "
        "(API session_count: ${sessionPlanData.sessionCount ?? 'null'}, "
        'features: ${sessionPlanData.features!.length})',
      );

      _detailsCache.clear();
      final firstId =
          deduplicatedResults.isNotEmpty ? deduplicatedResults.first.id : null;

      state = state.copyWith(
        isLoading: false,
        results: deduplicatedResults,
        sessionCount: visibleCount,
        selectedCenterId: firstId,
        clearSelectedCenterDetails: true,
        clearDetailsError: true,
        error: null,
      );

      if (deduplicatedResults.isNotEmpty) {
        await loadCenterDetails(deduplicatedResults.first);
      }
    } catch (e) {
      logg.e("EPI Center Finder: Error searching centers: $e");
      _detailsCache.clear();
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to search EPI centers: ${e.toString()}',
        results: [],
        sessionCount: 0,
        selectedCenterId: null,
        clearSelectedCenterDetails: true,
      );
    }
  }

  EpiCenterResult? resultById(String id) {
    for (final result in state.results) {
      if (result.id == id) return result;
    }
    return null;
  }

  Future<void> loadCenterDetails(EpiCenterResult result) async {
    state = state.copyWith(
      selectedCenterId: result.id,
      clearDetailsError: true,
    );

    final orgUid = result.orgUid;
    if (orgUid == null || orgUid.isEmpty) {
      state = state.copyWith(
        isLoadingDetails: false,
        clearSelectedCenterDetails: true,
        detailsError: 'EPI center details are not available for this session.',
      );
      return;
    }

    if (_detailsCache.containsKey(orgUid)) {
      state = state.copyWith(
        isLoadingDetails: false,
        selectedCenterDetails: _detailsCache[orgUid],
        clearDetailsError: true,
      );
      return;
    }

    state = state.copyWith(isLoadingDetails: true, clearDetailsError: true);

    try {
      final year = _ref.read(filterControllerProvider).selectedYear;
      final details = await _ref.read(dataServiceProvider).getEpiCenterDetailsByOrgUid(
            orgUid: orgUid,
            year: year,
          );
      _detailsCache[orgUid] = details;
      state = state.copyWith(
        isLoadingDetails: false,
        selectedCenterDetails: details,
        clearDetailsError: true,
      );
      logg.i('EPI Center Finder: Loaded details for ${result.name} ($orgUid)');
    } catch (e) {
      logg.e('EPI Center Finder: Failed to load details for $orgUid: $e');
      state = state.copyWith(
        isLoadingDetails: false,
        clearSelectedCenterDetails: true,
        detailsError: 'Failed to load EPI center details.',
      );
    }
  }

  void selectCenter(String? centerId) {
    state = state.copyWith(selectedCenterId: centerId);
  }

  void clearSelection() {
    state = state.copyWith(selectedCenterId: null);
  }

  Future<void> openAppSettingsForPermission() async {
    await openAppSettings();
  }
}
