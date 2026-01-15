import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gis_dashboard/features/map/presentation/controllers/map_controller.dart';
import 'package:gis_dashboard/features/map/presentation/controllers/map_state.dart';
import 'package:gis_dashboard/features/map/utils/map_enums.dart';
import 'package:gis_dashboard/features/filter/presentation/controllers/filter_controller.dart';
import 'package:gis_dashboard/features/filter/domain/filter_state.dart';
import 'package:gis_dashboard/features/summary/domain/vaccine_coverage_response.dart';
import 'package:gis_dashboard/core/utils/vaccine_data_calculator.dart';

import '../../../../core/common/constants/api_constants.dart';
import '../../../../core/service/data_service.dart';
import '../../../../core/utils/utils.dart';
import '../../domain/summary_state.dart';

final summaryControllerProvider =
    StateNotifierProvider<SummaryControllerNotifier, SummaryState>((ref) {
      final controller = SummaryControllerNotifier(
        dataService: ref.read(dataServiceProvider),
        ref: ref, // ✅ Pass ref to access mapControllerProvider
      );

      // Listen to map state changes to auto-update summary
      ref.listen<MapState>(mapControllerProvider, (previous, next) {
        // Update summary when map data changes and is not loading
        logg.i(
          'Summary: Map state changed - isLoading: ${next.isLoading}, '
          'hasCoverageData: ${next.coverageData != null}, '
          'error: ${next.error}, '
          'level: ${next.currentLevel}, '
          'areaName: ${next.currentAreaName}, '
          'coverageChanged: ${previous?.coverageData != next.coverageData}, '
          'levelChanged: ${previous?.currentLevel != next.currentLevel}',
        );
        
        if (!next.isLoading &&
            next.coverageData != null &&
            next.error == null &&
            (previous?.coverageData != next.coverageData ||
                previous?.currentLevel != next.currentLevel)) {
          logg.i('Summary: Updating summary with map data');
          final filterState = ref.read(filterControllerProvider);
          controller.updateDataAndFilter(next, filterState.selectedMonths);
        } else {
          logg.w(
            'Summary: Skipping update - isLoading: ${next.isLoading}, '
            'hasCoverageData: ${next.coverageData != null}, '
            'error: ${next.error}, '
            'coverageChanged: ${previous?.coverageData != next.coverageData}, '
            'levelChanged: ${previous?.currentLevel != next.currentLevel}',
          );
        }
      });

      // Listen to filter state changes
      ref.listen<FilterState>(filterControllerProvider, (previous, next) {
        if (previous?.selectedMonths != next.selectedMonths) {
          controller.applyMonthFilter(next.selectedMonths);
        }
      });

      return controller;
    });

class SummaryControllerNotifier extends StateNotifier<SummaryState> {
  final DataService _dataService;
  final Ref _ref; // ✅ Store ref to access other providers
  VaccineCoverageResponse? _unfilteredCoverageData;

  SummaryControllerNotifier({
    required DataService dataService,
    required Ref ref,
  })  : _dataService = dataService,
        _ref = ref,
        super(SummaryState());

  /// Update summary with data from map state and apply month filter
  void updateDataAndFilter(MapState mapState, List<String> selectedMonths) {
    logg.i(
      "Updating summary with map data for ${mapState.currentAreaName} at level ${mapState.currentLevel}",
    );

    // ✅ FIX: Get unfiltered data from map controller instead of already-filtered mapState.coverageData
    // This prevents double-filtering and ensures correct month scaling
    final mapNotifier = _ref.read(mapControllerProvider.notifier);
    _unfilteredCoverageData = mapNotifier.unfilteredCoverageData ?? mapState.coverageData;
    
    logg.i(
      'Summary: Using unfiltered data from map - '
      'hasUnfilteredData: ${mapNotifier.unfilteredCoverageData != null}, '
      'selectedMonths: $selectedMonths (${selectedMonths.length} months)',
    );

    final filteredData = VaccineDataCalculator.recalculateCoverageData(
      _unfilteredCoverageData,
      selectedMonths,
    );

    // 🔍 DEBUG: Log target values to verify scaling
    if (filteredData?.vaccines?.isNotEmpty == true) {
      final firstVaccine = filteredData!.vaccines!.first;
      logg.i(
        'Summary: Month-filtered data - '
        'totalTarget: ${firstVaccine.totalTarget}, '
        'totalTargetMale: ${firstVaccine.totalTargetMale}, '
        'totalTargetFemale: ${firstVaccine.totalTargetFemale}, '
        'monthFactor: ${selectedMonths.length / 12.0}',
      );
    }

    logg.i(
      'Summary: Updated with coverage data - '
      'vaccines count: ${filteredData?.vaccines?.length ?? 0}, '
      'area name: ${mapState.currentAreaName}, '
      'level: ${mapState.currentLevel}',
    );

    state = state.copyWith(
      coverageData: filteredData,
      currentLevel: mapState.currentLevel,
      currentAreaName: mapState.currentAreaName,
      isLoading: false,
      error: null,
    );
    
    logg.i('Summary: State updated successfully');
  }

  /// Apply month filter to existing data
  void applyMonthFilter(List<String> selectedMonths) {
    if (_unfilteredCoverageData == null) return;

    logg.i("Applying month filter: $selectedMonths");

    final filteredData = VaccineDataCalculator.recalculateCoverageData(
      _unfilteredCoverageData,
      selectedMonths,
    );

    state = state.copyWith(coverageData: filteredData);
  }

  Future<void> loadSummaryData({bool forceRefresh = false}) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      logg.i("Loading summary data...");

      final coverageData = await _dataService.getVaccinationCoverage(
        urlPath: ApiConstants.getCoveragePath(
          year: DateTime.now().year.toString(),
        ),
        forceRefresh: forceRefresh,
      );

      // // 🔍 DEBUG: Save JSON to file
      // if (coverageData.vaccines != null) {
      //   try {
      //     final file = File('debug_output/response.json');
      //     await file.create(recursive: true);
      //     // Assuming the model has toJson() because it's freezed
      //     await file.writeAsString(jsonEncode(coverageData.toJson()));
      //     logg.i("✅ DEBUG: Saved response.json to ${file.absolute.path}");
      //   } catch (e) {
      //     logg.e("Failed to write debug file: $e");
      //   }
      // }

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
