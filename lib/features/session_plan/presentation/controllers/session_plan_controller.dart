import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gis_dashboard/core/common/constants/api_constants.dart';
import 'package:gis_dashboard/core/service/data_service.dart';
import 'package:gis_dashboard/core/utils/utils.dart';
import 'package:gis_dashboard/features/map/domain/area_coords_geo_json_response.dart';
import 'package:gis_dashboard/features/session_plan/domain/session_plan_coords_response.dart';
import 'package:gis_dashboard/features/filter/presentation/controllers/filter_controller.dart';
import 'package:gis_dashboard/features/filter/domain/filter_state.dart';
import 'package:gis_dashboard/features/map/presentation/controllers/map_controller.dart';

// State class for Session Plan
class SessionPlanState {
  final bool isLoading;
  final String? error;
  final AreaCoordsGeoJsonResponse? areaCoordsGeoJsonData;
  final SessionPlanCoordsResponse? sessionPlanCoordsData;

  SessionPlanState({
    this.isLoading = false,
    this.error,
    this.areaCoordsGeoJsonData,
    this.sessionPlanCoordsData,
  });

  SessionPlanState copyWith({
    bool? isLoading,
    String? error,
    AreaCoordsGeoJsonResponse? areaCoordsGeoJsonData,
    SessionPlanCoordsResponse? sessionPlanCoordsData,
    bool clearError = false,
  }) {
    return SessionPlanState(
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      areaCoordsGeoJsonData:
          areaCoordsGeoJsonData ?? this.areaCoordsGeoJsonData,
      sessionPlanCoordsData:
          sessionPlanCoordsData ?? this.sessionPlanCoordsData,
    );
  }
}

final sessionPlanControllerProvider =
    StateNotifierProvider<SessionPlanController, SessionPlanState>((ref) {
      return SessionPlanController(
        dataService: ref.read(dataServiceProvider),
        ref: ref,
      );
    });

class SessionPlanController extends StateNotifier<SessionPlanState> {
  final DataService _dataService;
  final Ref _ref;

  SessionPlanController({
    required DataService dataService,
    required Ref ref,
  })  : _dataService = dataService,
        _ref = ref,
        super(SessionPlanState());

  Future<void> loadInitialData({String? startDate, String? endDate}) async {
    // Load with no area filter (country level)
    await loadDataWithFilter(
      areaUid: null,
      geoJsonPath: ApiConstants.districtJsonPath,
      startDate: startDate,
      endDate: endDate,
    );
  }

  /// Load session plan data based on current filter state
  Future<void> loadDataWithFilter({
    String? areaUid,
    String? geoJsonPath,
    String? startDate,
    String? endDate,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      logg.i("Loading session plan data with filter...");

      // Get filter state to determine area UID if not provided
      final filterState = _ref.read(filterControllerProvider);
      final mapNotifier = _ref.read(mapControllerProvider.notifier);
      
      // Use provided areaUid or get from map controller's focalAreaUid
      final effectiveAreaUid = areaUid ?? mapNotifier.focalAreaUid;
      final areaParam = effectiveAreaUid ?? 'undefined';
      
      logg.i("Session Plan: Using area UID: $areaParam");

      // Construct URL based on parameters
      String sessionPlanUrl = '${ApiConstants.sessionPlans}?area=$areaParam';
      if (startDate != null && startDate.isNotEmpty) {
        sessionPlanUrl += '&start_date=$startDate';
      } else {
        sessionPlanUrl += '&start_date=';
      }

      if (endDate != null && endDate.isNotEmpty) {
        sessionPlanUrl += '&end_date=$endDate';
      } else {
        sessionPlanUrl += '&end_date=';
      }

      logg.i("Fetching session plans from: $sessionPlanUrl");

      // Determine GeoJSON path based on filter level
      String effectiveGeoJsonPath;
      if (geoJsonPath != null) {
        effectiveGeoJsonPath = geoJsonPath;
      } else {
        // Determine GeoJSON path based on filter state
        effectiveGeoJsonPath = _getGeoJsonPathForFilter(filterState, mapNotifier);
      }

      logg.i("Fetching GeoJSON from: $effectiveGeoJsonPath");

      final results = await Future.wait([
        _dataService.fetchAreaGeoJsonCoordsData(
          urlPath: effectiveGeoJsonPath,
          forceRefresh: false,
        ),
        _dataService.getSessionPlanCoords(
          urlPath: sessionPlanUrl,
          forceRefresh: true,
        ),
      ]);

      final areaCoordsGeoJsonData = results[0] as AreaCoordsGeoJsonResponse;
      final sessionPlanCoordsData = results[1] as SessionPlanCoordsResponse;

      logg.i(
        "Loaded session plan data with ${sessionPlanCoordsData.features?.length ?? 0} features",
      );

      state = state.copyWith(
        areaCoordsGeoJsonData: areaCoordsGeoJsonData,
        sessionPlanCoordsData: sessionPlanCoordsData,
        isLoading: false,
        clearError: true,
      );
    } catch (e) {
      logg.e("Error loading session plan data: $e");
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load session plan data: $e',
      );
    }
  }

  /// Get GeoJSON path based on current filter state
  /// This follows the same logic as map controller for determining the appropriate GeoJSON path
  String _getGeoJsonPathForFilter(
    FilterState filterState,
    MapControllerNotifier mapNotifier,
  ) {
    // Get the focal area UID to determine the filter level
    final focalAreaUid = mapNotifier.focalAreaUid;
    
    if (focalAreaUid == null) {
      // Country level - use district GeoJSON
      return ApiConstants.districtJsonPath;
    }

    // Use the focalAreaUid to construct the GeoJSON path
    // This matches the pattern used in map controller
    return ApiConstants.getGeoJsonPath(slug: focalAreaUid);
  }

  // Reload with specific dates
  Future<void> updateDateFilter(String startDate, String endDate) async {
    await loadDataWithFilter(startDate: startDate, endDate: endDate);
  }
}
