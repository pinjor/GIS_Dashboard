import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gis_dashboard/core/common/constants/api_constants.dart';
import 'package:gis_dashboard/core/service/data_service.dart';
import 'package:gis_dashboard/features/filter/filter.dart';

import '../../../../core/utils/utils.dart';
import 'map_state.dart';
import '../../domain/vaccine_coverage_response.dart';

final mapControllerProvider =
    StateNotifierProvider<MapControllerNotifier, MapState>((ref) {
      return MapControllerNotifier(
        dataService: ref.read(dataServiceProvider),
        filterNotifier: ref.read(filterProvider.notifier),
      );
    });

class MapControllerNotifier extends StateNotifier<MapState> {
  final DataService _dataService;
  final FilterNotifier _filterNotifier;

  MapControllerNotifier({
    required DataService dataService,
    required FilterNotifier filterNotifier,
  }) : _dataService = dataService,
       _filterNotifier = filterNotifier,
       super(MapState());

  Future<void> loadInitialData({bool forceRefresh = false}) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      logg.i("Loading initial map data...");

      // Try to get cached data first
      final cachedCoverageData = _dataService.getCachedCoverageData();
      if (cachedCoverageData != null && !forceRefresh) {
        logg.i("Using cached map data");
        // Still need to load GeoJSON for map rendering
        final geoJson = await _dataService.getGeoJson(
          urlPath: ApiConstants.districtJsonPath,
          forceRefresh: forceRefresh,
        );

        state = state.copyWith(
          geoJson: geoJson,
          coverageData: cachedCoverageData,
          currentLevel: 'district',
          navigationStack: [], // Reset to country level
          currentAreaName: 'Bangladesh',
          isLoading: false,
          clearError: true,
        );
        return;
      }

      final results = await Future.wait([
        _dataService.getGeoJson(
          urlPath: ApiConstants.districtJsonPath,
          forceRefresh: forceRefresh,
        ),
        _dataService.getVaccinationCoverage(
          urlPath: ApiConstants.districtCoveragePath25,
          forceRefresh: forceRefresh,
        ),
      ]);

      final geoJson = results[0] as String;
      final coverageData = results[1] as VaccineCoverageResponse;
      logg.i(
        'metadata: ${coverageData.metadata} year: ${coverageData.metadata?.year}',
      );
      logg.i(
        "Loaded Coverage data for ${coverageData.vaccines?.first.vaccineName} and ${coverageData.vaccines?.first.areas?.length} coverage areas",
      );

      state = state.copyWith(
        geoJson: geoJson,
        coverageData: coverageData,
        currentLevel: 'district',
        navigationStack: [], // Reset to country level
        currentAreaName: 'Bangladesh',
        isLoading: false,
        clearError: true, // Explicitly clear any previous errors
      );
    } catch (e) {
      logg.e("Error loading initial data: $e");
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load map data: $e',
      );
    }
  }

  Future<void> refreshMapData() async {
    await loadInitialData(forceRefresh: true);
  }

  /// Drill down to a specific area based on the slug
  Future<void> drillDownToArea({
    required String areaName,
    required String slug,
    required String newLevel,
    String? parentSlug,
  }) async {
    // Check if slug is empty (no drilldown data available)
    if (slug.isEmpty) {
      logg.w("Cannot drill down to $areaName - slug is empty");
      state = state.copyWith(error: 'No detailed data available for $areaName');
      return;
    }

    // First clear any existing error state explicitly
    state = state.copyWith(clearError: true, isLoading: false);
    // Then set loading state
    state = state.copyWith(isLoading: true);

    try {
      logg.i("Drilling down to $areaName with slug: $slug");

      // Get current filter state for year selection
      final currentFilter = _filterNotifier.state;
      final selectedYear = currentFilter.selectedYear;

      // Construct API paths using the slug
      final geoJsonPath = ApiConstants.getGeoJsonPath(slug: slug);
      final coveragePath = ApiConstants.getCoveragePath(
        slug: slug,
        year: selectedYear,
      );

      logg.i("Fetching GeoJSON from: $geoJsonPath");
      logg.i("Fetching coverage from: $coveragePath");

      final results = await Future.wait([
        _dataService.getGeoJson(
          urlPath: geoJsonPath,
          forceRefresh: true, // Always refresh for drilldown
        ),
        _dataService.getVaccinationCoverage(
          urlPath: coveragePath,
          forceRefresh: true, // Always refresh for drilldown
        ),
      ]);

      final geoJson = results[0] as String;
      final coverageData = results[1] as VaccineCoverageResponse;

      // Create new navigation level
      final newNavLevel = DrilldownLevel(
        level: newLevel,
        slug: slug,
        name: areaName,
        parentSlug: parentSlug,
      );

      // Add to navigation stack
      final newStack = List<DrilldownLevel>.from(state.navigationStack)
        ..add(newNavLevel);

      state = state.copyWith(
        geoJson: geoJson,
        coverageData: coverageData,
        currentLevel: newLevel,
        navigationStack: newStack,
        currentAreaName: areaName,
        isLoading: false,
        clearError: true,
      );

      logg.i("Successfully drilled down to $areaName at level $newLevel");
    } catch (e) {
      logg.e("Error drilling down to $areaName: $e");
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load data for $areaName: $e',
      );
    }
  }

  /// Go back one level in the navigation stack
  Future<void> goBack() async {
    if (state.navigationStack.isEmpty) {
      logg.w("Cannot go back - already at top level");
      return;
    }

    // First clear any existing error state explicitly
    state = state.copyWith(clearError: true, isLoading: false);
    // Then set loading state
    state = state.copyWith(isLoading: true);

    try {
      final newStack = List<DrilldownLevel>.from(state.navigationStack)
        ..removeLast();

      if (newStack.isEmpty) {
        // Going back to country level
        await loadInitialData(forceRefresh: true);
      } else {
        // Going back to previous drilldown level
        final previousLevel = newStack.last;
        final currentFilter = _filterNotifier.state;
        final selectedYear = currentFilter.selectedYear;

        final geoJsonPath = ApiConstants.getGeoJsonPath(
          slug: previousLevel.slug,
        );
        final coveragePath = ApiConstants.getCoveragePath(
          slug: previousLevel.slug,
          year: selectedYear,
        );

        final results = await Future.wait([
          _dataService.getGeoJson(urlPath: geoJsonPath, forceRefresh: true),
          _dataService.getVaccinationCoverage(
            urlPath: coveragePath,
            forceRefresh: true,
          ),
        ]);

        final geoJson = results[0] as String;
        final coverageData = results[1] as VaccineCoverageResponse;

        state = state.copyWith(
          geoJson: geoJson,
          coverageData: coverageData,
          currentLevel: previousLevel.level,
          navigationStack: newStack,
          currentAreaName: previousLevel.name,
          isLoading: false,
          clearError: true,
        );
      }

      logg.i("Successfully navigated back");
    } catch (e) {
      logg.e("Error navigating back: $e");
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to navigate back: $e',
      );
    }
  }

  /// Reset to country level
  Future<void> resetToCountryLevel() async {
    logg.i("Resetting to country level");
    await loadInitialData(forceRefresh: true);
  }

  /// Reload current level data (useful when filter changes)
  Future<void> reloadCurrentLevel() async {
    if (state.navigationStack.isEmpty) {
      // At country level
      await loadInitialData(forceRefresh: true);
    } else {
      // At some drilldown level
      final currentLevel = state.navigationStack.last;
      await drillDownToArea(
        areaName: currentLevel.name ?? currentLevel.level,
        slug: currentLevel.slug ?? '',
        newLevel: currentLevel.level,
        parentSlug: currentLevel.parentSlug,
      );
    }
  }

  /// Explicitly clear any error state
  void clearError() {
    logg.i("Explicitly clearing error state");
    state = state.copyWith(clearError: true);
  }
}
