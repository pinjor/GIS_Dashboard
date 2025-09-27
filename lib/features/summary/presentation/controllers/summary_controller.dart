import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gis_dashboard/core/common/constants/api_constants.dart';
import 'package:gis_dashboard/features/summary/domain/summary_state.dart';
import 'package:gis_dashboard/features/map/presentation/controllers/map_controller.dart';
import 'package:gis_dashboard/features/map/presentation/controllers/map_state.dart';
import 'package:gis_dashboard/features/map/utils/map_enums.dart';

import '../../../../core/service/data_service.dart';
import '../../../../core/utils/utils.dart';

final summaryControllerProvider =
    StateNotifierProvider<SummaryControllerNotifier, SummaryState>((ref) {
      final controller = SummaryControllerNotifier(
        dataService: ref.read(dataServiceProvider),
      );

      // Listen to map state changes to auto-update summary
      ref.listen<MapState>(mapControllerProvider, (previous, next) {
        // Update summary when map data changes and is not loading
        if (!next.isLoading &&
            next.coverageData != null &&
            next.error == null &&
            (previous?.coverageData != next.coverageData ||
                previous?.currentLevel != next.currentLevel)) {
          controller._updateWithMapData(next);
        }
      });

      return controller;
    });

class SummaryControllerNotifier extends StateNotifier<SummaryState> {
  final DataService _dataService;

  SummaryControllerNotifier({required DataService dataService})
    : _dataService = dataService,
      super(SummaryState());

  /// Update summary with data from map state (called when drill-down occurs)
  void _updateWithMapData(MapState mapState) {
    logg.i(
      "Updating summary with map data for ${mapState.currentAreaName} at level ${mapState.currentLevel}",
    );

    state = state.copyWith(
      coverageData: mapState.coverageData,
      currentLevel: mapState.currentLevel,
      currentAreaName: mapState.currentAreaName,
      isLoading: false,
      error: null,
    );
  }

  Future<void> loadSummaryData({bool forceRefresh = false}) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      logg.i("Loading summary data...");

      final coverageData = await _dataService.getVaccinationCoverage(
        urlPath: ApiConstants.districtCoveragePath25,
        forceRefresh: forceRefresh,
      );

      logg.i(
        "Loaded summary data for ${coverageData.vaccines?.first.vaccineName} and ${coverageData.vaccines?.first.areas?.length} coverage areas",
      );

      state = state.copyWith(
        coverageData: coverageData,
        currentLevel: GeographicLevel.district,
        currentAreaName: 'Bangladesh',
        isLoading: false,
        error: null,
      );
    } catch (e) {
      logg.e("Error loading summary data: $e");
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load summary data: $e',
      );
    }
  }

  Future<void> refreshSummaryData() async {
    await loadSummaryData(forceRefresh: true);
  }

}
