import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gis_dashboard/core/common/constants/api_constants.dart';
import 'package:gis_dashboard/core/service/data_service.dart';
import 'package:gis_dashboard/core/utils/utils.dart';
import 'package:gis_dashboard/features/map/domain/area_coords_geo_json_response.dart';
import 'package:gis_dashboard/features/session_plan/domain/session_plan_coords_response.dart';

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
      return SessionPlanController(dataService: ref.read(dataServiceProvider));
    });

class SessionPlanController extends StateNotifier<SessionPlanState> {
  final DataService _dataService;

  SessionPlanController({required DataService dataService})
    : _dataService = dataService,
      super(SessionPlanState());

  Future<void> loadInitialData({String? startDate, String? endDate}) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      logg.i("Loading initial session plan data...");

      // Construct URL based on parameters
      String sessionPlanUrl = '${ApiConstants.sessionPlans}?area=undefined';
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

      final results = await Future.wait([
        _dataService.fetchAreaGeoJsonCoordsData(
          urlPath: ApiConstants.districtJsonPath,
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

  // Reload with specific dates
  Future<void> updateDateFilter(String startDate, String endDate) async {
    await loadInitialData(startDate: startDate, endDate: endDate);
  }
}
