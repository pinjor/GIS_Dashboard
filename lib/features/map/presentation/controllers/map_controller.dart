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

      // Get current filter state for year selection
      final currentFilter = _filterNotifier.state;
      final selectedYear = currentFilter.selectedYear;

      // Try to get cached data first, but only if it's for the correct year
      final cachedCoverageData = _dataService.getCachedCoverageData();
      if (cachedCoverageData != null &&
          !forceRefresh &&
          cachedCoverageData.metadata?.year == selectedYear) {
        logg.i("Using cached map data for year $selectedYear");
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

      // Use dynamic year-based coverage path
      final coveragePath = ApiConstants.getCoveragePath(year: selectedYear);
      logg.i(
        "Loading coverage data for year $selectedYear from: $coveragePath",
      );

      final results = await Future.wait([
        _dataService.getGeoJson(
          urlPath: ApiConstants.districtJsonPath,
          forceRefresh: forceRefresh,
        ),
        _dataService.getVaccinationCoverage(
          urlPath: coveragePath,
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
      // Don't show error state, just ignore the request silently
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

      // For union and deeper levels (not upazila), also fetch EPI data (3 simultaneous requests)
      List<Future> apiRequests = [
        _dataService.getGeoJson(
          urlPath: geoJsonPath,
          forceRefresh: true, // Always refresh for drilldown
        ),
        _dataService.getVaccinationCoverage(
          urlPath: coveragePath,
          forceRefresh: true, // Always refresh for drilldown
        ),
      ];

      // Add EPI request ONLY for union and deeper levels (not for district or upazila)
      if (newLevel == 'union' || newLevel == 'ward' || newLevel == 'subblock') {
        final epiPath = ApiConstants.getEpiPath(slug: slug);
        logg.i("Fetching EPI data from: $epiPath");
        apiRequests.add(
          _dataService.getEpiData(urlPath: epiPath, forceRefresh: true),
        );
      }

      final results = await Future.wait(apiRequests);

      final geoJson = results[0] as String;
      final coverageData = results[1] as VaccineCoverageResponse;

      // EPI data is only available for union and deeper levels (not district or upazila)
      String? epiData;
      if ((newLevel == 'union' ||
              newLevel == 'ward' ||
              newLevel == 'subblock') &&
          results.length > 2) {
        epiData = results[2] as String;
        logg.i("Successfully fetched EPI data for $areaName");
      }

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
        epiData: epiData,
        currentLevel: newLevel,
        navigationStack: newStack,
        currentAreaName: areaName,
        isLoading: false,
        clearError: true,
      );

      logg.i("Successfully drilled down to $areaName at level $newLevel");
    } catch (e) {
      logg.e("Error drilling down to $areaName: $e");

      // GRACEFUL DEGRADATION: Don't show error screens, just silently fail and stay at current level
      // This prevents the app from getting stuck in error states
      state = state.copyWith(
        isLoading: false,
        clearError: true, // Clear any error state instead of setting one
      );

      // Log the error but don't expose it to UI to prevent blocking user interaction
      logg.w(
        "Drill down to $areaName failed gracefully - staying at current level. Error: $e",
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

        // Prepare API requests
        List<Future> apiRequests = [
          _dataService.getGeoJson(urlPath: geoJsonPath, forceRefresh: true),
          _dataService.getVaccinationCoverage(
            urlPath: coveragePath,
            forceRefresh: true,
          ),
        ];

        // Add EPI request if going back to union or deeper level (not district or upazila)
        if (previousLevel.level == 'union' ||
            previousLevel.level == 'ward' ||
            previousLevel.level == 'subblock') {
          final epiPath = ApiConstants.getEpiPath(slug: previousLevel.slug);
          apiRequests.add(
            _dataService.getEpiData(urlPath: epiPath, forceRefresh: true),
          );
        }

        final results = await Future.wait(apiRequests);

        final geoJson = results[0] as String;
        final coverageData = results[1] as VaccineCoverageResponse;

        // EPI data is only available for union and deeper levels (not district or upazila)
        String? epiData;
        if ((previousLevel.level == 'union' ||
                previousLevel.level == 'ward' ||
                previousLevel.level == 'subblock') &&
            results.length > 2) {
          epiData = results[2] as String;
        }

        state = state.copyWith(
          geoJson: geoJson,
          coverageData: coverageData,
          epiData: epiData,
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

      // GRACEFUL DEGRADATION: Don't show error screens, just silently fail
      // This prevents navigation issues and keeps the app stable
      state = state.copyWith(
        isLoading: false,
        clearError: true, // Clear any error state instead of setting one
      );

      // Log the error but don't expose it to UI
      logg.w(
        "Navigation back failed gracefully - staying at current level. Error: $e",
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

  /// Refresh coverage data when year changes (keeps GeoJSON unchanged)
  Future<void> refreshCoverageForYearChange() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      // Get current filter state for year selection
      final currentFilter = _filterNotifier.state;
      final selectedYear = currentFilter.selectedYear;

      logg.i("Refreshing coverage data for year change to: $selectedYear");

      String coveragePath;
      if (state.navigationStack.isEmpty) {
        // At country level
        coveragePath = ApiConstants.getCoveragePath(year: selectedYear);
      } else {
        // At drilldown level
        final currentLevel = state.navigationStack.last;
        coveragePath = ApiConstants.getCoveragePath(
          slug: currentLevel.slug,
          year: selectedYear,
        );
      }

      logg.i("Fetching coverage from: $coveragePath");

      final coverageData = await _dataService.getVaccinationCoverage(
        urlPath: coveragePath,
        forceRefresh: true, // Always refresh for year change
      );

      state = state.copyWith(
        coverageData: coverageData,
        isLoading: false,
        clearError: true,
      );

      logg.i("Successfully refreshed coverage data for year $selectedYear");
    } catch (e) {
      logg.e("Error refreshing coverage data for year change: $e");
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load coverage data for selected year: $e',
      );
    }
  }

  /// Explicitly clear any error state
  void clearError() {
    logg.i("Explicitly clearing error state");
    state = state.copyWith(clearError: true);
  }
}
