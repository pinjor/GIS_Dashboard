import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gis_dashboard/core/common/constants/api_constants.dart';
import 'package:gis_dashboard/core/service/data_service.dart';
import 'package:gis_dashboard/features/summary/domain/summary_state.dart';

import '../../../../core/utils/utils.dart';

final summaryControllerProvider =
    StateNotifierProvider<SummaryControllerNotifier, SummaryState>((ref) {
      return SummaryControllerNotifier(
        dataService: ref.read(dataServiceProvider),
      );
    });

class SummaryControllerNotifier extends StateNotifier<SummaryState> {
  final DataService _dataService;

  SummaryControllerNotifier({required DataService dataService})
    : _dataService = dataService,
      super(SummaryState());

  Future<void> loadSummaryData({bool forceRefresh = false}) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      logg.i("Loading summary data...");

      // Try to get cached data first
      final cachedData = _dataService.getCachedCoverageData();
      if (cachedData != null && !forceRefresh) {
        logg.i("Using cached summary data");
        state = state.copyWith(coverageData: cachedData, isLoading: false);
        return;
      }

      final coverageData = await _dataService.getVaccinationCoverage(
        urlPath: ApiConstants.districtCoveragePath25,
        forceRefresh: forceRefresh,
      );

      logg.i(
        "Loaded summary data for ${coverageData.vaccines?.first.vaccineName} and ${coverageData.vaccines?.first.areas?.length} coverage areas",
      );

      state = state.copyWith(coverageData: coverageData, isLoading: false);
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
