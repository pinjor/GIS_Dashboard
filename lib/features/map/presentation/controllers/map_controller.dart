import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gis_dashboard/core/common/constants/api_constants.dart';
import 'package:gis_dashboard/core/service/data_service.dart';
import 'package:gis_dashboard/features/epi_center/domain/epi_center_coords_response.dart';
import 'package:gis_dashboard/features/filter/filter.dart';
import 'package:gis_dashboard/features/map/utils/map_enums.dart';

import '../../../../core/utils/utils.dart';
import '../../domain/area_coords_geo_json_response.dart';
import 'map_state.dart';
import '../../../summary/domain/vaccine_coverage_response.dart';
import '../../../../core/utils/vaccine_data_calculator.dart';

final mapControllerProvider =
    StateNotifierProvider<MapControllerNotifier, MapState>((ref) {
      final controller = MapControllerNotifier(
        dataService: ref.read(dataServiceProvider),
        filterNotifier: ref.read(filterControllerProvider.notifier),
      );

      // Listen to filter state mainly for months
      ref.listen<FilterState>(filterControllerProvider, (previous, next) {
        if (previous?.selectedMonths != next.selectedMonths) {
          controller.applyMonthFilter(next.selectedMonths);
        }
      });

      return controller;
    });

class MapControllerNotifier extends StateNotifier<MapState> {
  final DataService _dataService;
  final FilterControllerNotifier _filterNotifier;
  VaccineCoverageResponse? _unfilteredCoverageData;

  MapControllerNotifier({
    required DataService dataService,
    required FilterControllerNotifier filterNotifier,
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

      // Use dynamic year-based coverage path
      final coveragePath = ApiConstants.getCoveragePath(year: selectedYear);
      logg.i(
        "Loading coverage data for year $selectedYear from: $coveragePath",
      );

      final results = await Future.wait([
        _dataService.fetchAreaGeoJsonCoordsData(
          urlPath: ApiConstants.districtJsonPath,
          forceRefresh: forceRefresh,
        ),
        _dataService.getVaccinationCoverage(
          urlPath: coveragePath,
          forceRefresh: forceRefresh,
        ),
      ]);

      final areaCoordsGeoJsonData = results[0] as AreaCoordsGeoJsonResponse;
      final coverageData = results[1] as VaccineCoverageResponse;
      // logg.i(
      //   'metadata: ${coverageData.metadata} year: ${coverageData.metadata?.year}',
      // );
      // logg.i(
      //   "Loaded Coverage data for ${coverageData.vaccines?.first.vaccineName} and ${coverageData.vaccines?.first.areas?.length} coverage areas",
      // );

      _unfilteredCoverageData = coverageData;
      // Apply existing month filter if any
      final filteredData = VaccineDataCalculator.recalculateCoverageData(
        coverageData,
        currentFilter.selectedMonths,
      );

      state = state.copyWith(
        areaCoordsGeoJsonData: areaCoordsGeoJsonData,
        coverageData: filteredData,
        currentLevel: GeographicLevel
            .country, // Fixed: Country level should use country enum
        navigationStack: [], // Reset to country level
        currentAreaName: 'Bangladesh',
        isLoading: false,
        clearError: true, // Explicitly clear any previous errors
      );

      _logCurrentAreaUids(source: "Initial Data (Country)");
    } catch (e) {
      logg.e("Error loading initial data: $e");
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load map data: $e',
      );
    }
  }

  // Future<void> refreshMapData() async {
  //   await loadInitialData(forceRefresh: true);
  // }

  /// Load all city corporations view (when CC area type selected but no specific CC chosen)
  Future<void> loadAllCityCorporationsData({bool forceRefresh = false}) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      logg.i("Loading All City Corporations map data...");

      // Get current filter state for year selection
      final currentFilter = _filterNotifier.state;
      final selectedYear = currentFilter.selectedYear;

      // Use the specific All CCs endpoints
      final geoJsonPath = ApiConstants.allCityCorporationsGeoJson;
      final coveragePath = ApiConstants.getAllCityCorporationsCoveragePath(
        selectedYear,
      );

      logg.i("Loading All CCs GeoJSON from: $geoJsonPath");
      logg.i(
        "Loading All CCs coverage for year $selectedYear from: $coveragePath",
      );

      final results = await Future.wait([
        _dataService.fetchAreaGeoJsonCoordsData(
          urlPath: geoJsonPath,
          forceRefresh: forceRefresh,
        ),
        _dataService.getVaccinationCoverage(
          urlPath: coveragePath,
          forceRefresh: forceRefresh,
        ),
      ]);

      final areaCoordsGeoJsonData = results[0] as AreaCoordsGeoJsonResponse;
      final coverageData = results[1] as VaccineCoverageResponse;

      _unfilteredCoverageData = coverageData;
      // Apply existing month filter if any
      final filteredData = VaccineDataCalculator.recalculateCoverageData(
        coverageData,
        currentFilter.selectedMonths,
      );

      state = state.copyWith(
        areaCoordsGeoJsonData: areaCoordsGeoJsonData,
        coverageData: filteredData,
        currentLevel: GeographicLevel.country, // Treat as country-level view
        navigationStack: [], // Reset navigation stack
        currentAreaName: 'All City Corporations',
        isLoading: false,
        clearError: true,
      );

      logg.i("✅ Successfully loaded All City Corporations view");
    } catch (e) {
      logg.e("Error loading All City Corporations data: $e");
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load All City Corporations data: $e',
      );
    }
  }

  /// Drill down to a specific area based on the slug
  Future<void> drillDownToArea({
    required String areaName,
    required String slug,
    required String
    newLevel, // Keep as String for now since it comes from API/parsing
    String? parentSlug,
  }) async {
    // Convert string level to enum for internal logic
    final newLevelEnum = GeographicLevel.fromString(newLevel);

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

      // Fetch required data (GeoJSON and coverage) - these must succeed
      final requiredRequests = [
        _dataService.fetchAreaGeoJsonCoordsData(
          urlPath: geoJsonPath,
          forceRefresh: true, // Always refresh for drilldown
        ),
        _dataService.getVaccinationCoverage(
          urlPath: coveragePath,
          forceRefresh: true, // Always refresh for drilldown
        ),
      ];

      final requiredResults = await Future.wait(requiredRequests);
      final areaCoordsGeoJsonData =
          requiredResults[0] as AreaCoordsGeoJsonResponse;
      final coverageData = requiredResults[1] as VaccineCoverageResponse;

      // Fetch optional EPI data separately - failures here won't block drilldown
      EpiCenterCoordsResponse? epiCenterCoordsData;
      if (newLevelEnum.hasEpiData) {
        try {
          final epiPath = ApiConstants.getEpiPath(slug: slug);
          logg.i("Fetching EPI data from: $epiPath");
          epiCenterCoordsData = await _dataService.getEpiCenterCoordsData(
            urlPath: epiPath,
            forceRefresh: true,
          );
          logg.i("Successfully fetched EPI data for $areaName");
        } catch (e) {
          logg.w(
            "EPI data not available for $areaName - continuing without EPI data: $e",
          );
          epiCenterCoordsData = null; // Continue with null EPI data
        }
      }

      // Create new navigation level
      final newNavLevel = DrilldownLevel(
        level: newLevelEnum,
        slug: slug,
        name: areaName,
        parentSlug: parentSlug,
      );

      // Add to navigation stack
      final newStack = List<DrilldownLevel>.from(state.navigationStack)
        ..add(newNavLevel);

      _unfilteredCoverageData = coverageData;
      // Apply existing month filter if any
      final filteredData = VaccineDataCalculator.recalculateCoverageData(
        coverageData,
        currentFilter.selectedMonths,
      );

      state = state.copyWith(
        areaCoordsGeoJsonData: areaCoordsGeoJsonData,
        coverageData: filteredData,
        epiCenterCoordsData: epiCenterCoordsData,
        currentLevel: newLevelEnum,
        navigationStack: newStack,
        currentAreaName: areaName,
        isLoading: false,
        clearError: true,
        clearEpiData: epiCenterCoordsData == null, // Clear EPI data if null
      );

      _logCurrentAreaUids(source: "Drilldown to $areaName");

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
        logg.i("Going back to country level - resetting geographic filters");

        // Reset geographic filters to country view defaults (preserves vaccine, area type, year)
        _filterNotifier.resetGeographicFiltersToCountryView();

        await loadInitialData(forceRefresh: true);
      } else {
        // Going back to previous drilldown level
        final previousLevel = newStack.last;
        final currentFilter = _filterNotifier.state;
        final selectedYear = currentFilter.selectedYear;

        // Use fallback strategy for city corporation levels
        List<Future> apiRequests = [];
        if (previousLevel.level == GeographicLevel.cityCorporation) {
          // For city corporation, use fallback methods
          apiRequests = [
            _dataService.fetchAreaGeoJsonCoordsDataWithFallback(
              urlPaths: ApiConstants.getCityCorporationGeoJsonPaths(
                ccUid: previousLevel.slug,
                ccName: previousLevel.name,
              ),
              forceRefresh: true,
            ),
            _dataService.getVaccinationCoverageWithFallback(
              urlPaths: ApiConstants.getCityCorporationCoveragePaths(
                ccUid: previousLevel.slug,
                ccName: previousLevel.name,
                year: selectedYear,
              ),
              forceRefresh: true,
            ),
          ];
        } else {
          // For regular levels, use standard paths
          final geoJsonPath = ApiConstants.getGeoJsonPath(
            slug: previousLevel.slug,
          );
          final coveragePath = ApiConstants.getCoveragePath(
            slug: previousLevel.slug,
            year: selectedYear,
          );

          apiRequests = [
            _dataService.fetchAreaGeoJsonCoordsData(
              urlPath: geoJsonPath,
              forceRefresh: true,
            ),
            _dataService.getVaccinationCoverage(
              urlPath: coveragePath,
              forceRefresh: true,
            ),
          ];
        }

        // Fetch required data first
        final requiredResults = await Future.wait(apiRequests);
        final areaCoordsGeoJsonData =
            requiredResults[0] as AreaCoordsGeoJsonResponse;
        final coverageData = requiredResults[1] as VaccineCoverageResponse;

        // Handle optional EPI data separately for better error handling
        final previousLevelEnum = previousLevel.level;
        EpiCenterCoordsResponse? epiCenterCoordsData;
        if (previousLevelEnum.hasEpiData) {
          try {
            if (previousLevel.level == GeographicLevel.cityCorporation) {
              // For city corporation, use fallback methods for EPI data too
              epiCenterCoordsData = await _dataService
                  .getEpiCenterCoordsDataWithFallback(
                    urlPaths: ApiConstants.getCityCorporationEpiPaths(
                      ccUid: previousLevel.slug,
                      ccName: previousLevel.name,
                    ),
                    forceRefresh: true,
                  );
            } else {
              // For regular levels, use standard EPI path
              final epiPath = ApiConstants.getEpiPath(slug: previousLevel.slug);
              epiCenterCoordsData = await _dataService.getEpiCenterCoordsData(
                urlPath: epiPath,
                forceRefresh: true,
              );
            }
            logg.i(
              "Successfully fetched EPI data for going back to ${previousLevel.name}",
            );
          } catch (e) {
            logg.w(
              "EPI data not available for ${previousLevel.name} - continuing without EPI data: $e",
            );
            epiCenterCoordsData = null; // Continue with null EPI data
          }
        }

        _unfilteredCoverageData = coverageData;
        // Apply existing month filter if any
        final filteredData = VaccineDataCalculator.recalculateCoverageData(
          coverageData,
          currentFilter.selectedMonths,
        );

        state = state.copyWith(
          areaCoordsGeoJsonData: areaCoordsGeoJsonData,
          coverageData: filteredData,
          epiCenterCoordsData: epiCenterCoordsData,
          currentLevel: previousLevel.level,
          navigationStack: newStack,
          currentAreaName: previousLevel.name,
          isLoading: false,
          clearError: true,
        );

        _logCurrentAreaUids(source: "Go Back to ${previousLevel.name}");
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

    // Reset geographic filters to country view defaults (preserves vaccine, area type, year)
    _filterNotifier.resetGeographicFiltersToCountryView();

    await loadInitialData(forceRefresh: false);
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

      _unfilteredCoverageData = coverageData;
      // Apply existing month filter if any
      final filteredData = VaccineDataCalculator.recalculateCoverageData(
        coverageData,
        currentFilter.selectedMonths,
      );

      state = state.copyWith(
        coverageData: filteredData,
        isLoading: false,
        clearError: true,
      );

      _logCurrentAreaUids(source: "Year Change ($selectedYear)");

      logg.i("Successfully refreshed coverage data for year $selectedYear");
    } catch (e) {
      logg.e("Error refreshing coverage data for year change: $e");
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load coverage data for selected year: $e',
      );
    }
  }

  /// Load division-specific data when user selects division filter and district is null or all or empty etc.
  Future<void> loadDivisionData({required String divisionName}) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      // Get current filter state
      final currentFilter = _filterNotifier.state;
      final selectedYear = currentFilter.selectedYear;

      // Convert division name to proper slug format
      final divisionSlug = ApiConstants.divisionNameToSlug(divisionName);

      logg.i("Loading division data for: $divisionName (slug: $divisionSlug)");

      // Construct API paths for division
      final geoJsonPath = ApiConstants.getDivisionGeoJsonPath(
        divisionSlug: divisionSlug,
      );
      final coveragePath = ApiConstants.getDivisionCoveragePath(
        divisionSlug: divisionSlug,
        year: selectedYear,
      );

      logg.i("Fetching division GeoJSON from: $geoJsonPath");
      logg.i("Fetching division coverage from: $coveragePath");

      final results = await Future.wait([
        _dataService.fetchAreaGeoJsonCoordsData(
          urlPath: geoJsonPath,
          forceRefresh: true,
        ),
        _dataService.getVaccinationCoverage(
          urlPath: coveragePath,
          forceRefresh: true,
        ),
      ]);

      final areaCoordsGeoJsonData = results[0] as AreaCoordsGeoJsonResponse;
      final coverageData = results[1] as VaccineCoverageResponse;

      // Create navigation level for division
      final divisionNavLevel = DrilldownLevel(
        level: GeographicLevel.division,
        slug: 'divisions/$divisionSlug',
        name: divisionName,
        parentSlug: null,
      );

      _unfilteredCoverageData = coverageData;
      // Apply existing month filter if any
      final filteredData = VaccineDataCalculator.recalculateCoverageData(
        coverageData,
        currentFilter.selectedMonths,
      );

      state = state.copyWith(
        areaCoordsGeoJsonData: areaCoordsGeoJsonData,
        coverageData: filteredData,
        currentLevel: GeographicLevel.division,
        navigationStack: [
          divisionNavLevel,
        ], // Start fresh navigation for division
        currentAreaName: divisionName,
        isLoading: false,
        clearError: true,
        clearEpiData: true, // Clear EPI data for divisions
      );

      _logCurrentAreaUids(source: "Division Filter ($divisionName)");

      // logg.i("Successfully loaded division data for $divisionName");
    } catch (e) {
      logg.e("Error loading division data for $divisionName: $e");
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load division data: $e',
      );
    }
  }

  /// Load city corporation-specific data when user selects city corporation filter
  Future<void> loadCityCorporationData({
    required String cityCorporationName,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      // Get current filter state
      final currentFilter = _filterNotifier.state;
      final selectedYear = currentFilter.selectedYear;

      // Get city corporation UID from filter state for fallback strategy
      final ccUid = _filterNotifier.getCityCorporationUid(cityCorporationName);

      logg.i(
        "Loading city corporation data for: $cityCorporationName (UID: $ccUid)",
      );

      // Generate fallback URL paths (UID first, then name-based)
      final geoJsonPaths = ApiConstants.getCityCorporationGeoJsonPaths(
        ccUid: ccUid,
        ccName: cityCorporationName,
      );
      final coveragePaths = ApiConstants.getCityCorporationCoveragePaths(
        ccUid: ccUid,
        ccName: cityCorporationName,
        year: selectedYear,
      );
      final epiPaths = ApiConstants.getCityCorporationEpiPaths(
        ccUid: ccUid,
        ccName: cityCorporationName,
      );

      logg.i("City corporation GeoJSON fallback paths: $geoJsonPaths");
      logg.i("City corporation coverage fallback paths: $coveragePaths");
      logg.i("City corporation EPI fallback paths: $epiPaths");

      // Use fallback strategy for all three API calls
      final results = await Future.wait([
        _dataService.fetchAreaGeoJsonCoordsDataWithFallback(
          urlPaths: geoJsonPaths,
          forceRefresh: true,
        ),
        _dataService.getVaccinationCoverageWithFallback(
          urlPaths: coveragePaths,
          forceRefresh: true,
        ),
        _dataService.getEpiCenterCoordsDataWithFallback(
          urlPaths: epiPaths,
          forceRefresh: true,
        ),
      ]);

      final areaCoordsGeoJsonData = results[0] as AreaCoordsGeoJsonResponse;
      final coverageData = results[1] as VaccineCoverageResponse;
      final epiCenterCoordsData = results[2] as EpiCenterCoordsResponse;

      // Create navigation level for city corporation using UID or name-based slug
      final ccSlug =
          ccUid?.toLowerCase() ??
          ApiConstants.cityCorporationNameToSlug(cityCorporationName);
      final ccNavLevel = DrilldownLevel(
        level: GeographicLevel.cityCorporation, // Use city corporation level
        slug: ccSlug,
        name: cityCorporationName,
        parentSlug: null,
      );

      _unfilteredCoverageData = coverageData;
      // Apply existing month filter if any
      final filteredData = VaccineDataCalculator.recalculateCoverageData(
        coverageData,
        currentFilter.selectedMonths,
      );

      state = state.copyWith(
        areaCoordsGeoJsonData: areaCoordsGeoJsonData,
        coverageData: filteredData,
        epiCenterCoordsData:
            epiCenterCoordsData, // Include EPI data for city corporations
        currentLevel: GeographicLevel
            .cityCorporation, // City corporations are at city corporation level
        navigationStack: [
          ccNavLevel,
        ], // Start fresh navigation for city corporation
        currentAreaName: cityCorporationName,
        isLoading: false,
        clearError: true,
      );

      _logCurrentAreaUids(
        source: "City Corporation Filter ($cityCorporationName)",
      );

      logg.i(
        "Successfully loaded city corporation data for $cityCorporationName",
      );
    } catch (e) {
      logg.e(
        "Error loading city corporation data for $cityCorporationName: $e",
      );
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load city corporation data: $e',
      );
    }
  }

  /// Load district-specific data when user selects district filter
  /// This uses dynamic slug extraction from country-level GeoJSON
  /// this is when user also selects district from filter
  /// ! this has some serious problems like in currentLevel determination
  Future<void> loadDistrictData({required String districtName}) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      // Get current filter state
      final currentFilter = _filterNotifier.state;
      final selectedYear = currentFilter.selectedYear;

      // Get district slug from country-level GeoJSON data
      final districtSlug = await _getDistrictSlugFromCountryData(districtName);

      if (districtSlug == null) {
        throw Exception(
          'Could not find district $districtName in GeoJSON data or district has no slug',
        );
      }

      logg.i("Loading district data for: $districtName (slug: $districtSlug)");

      // Construct API paths for district using the actual slug from filter data
      final geoJsonPath = ApiConstants.getGeoJsonPath(slug: districtSlug);
      final coveragePath = ApiConstants.getCoveragePath(
        slug: districtSlug,
        year: selectedYear,
      );

      logg.i("Fetching district GeoJSON from: $geoJsonPath");
      logg.i("Fetching district coverage from: $coveragePath");

      final results = await Future.wait([
        _dataService.fetchAreaGeoJsonCoordsData(
          urlPath: geoJsonPath,
          forceRefresh: true,
        ),
        _dataService.getVaccinationCoverage(
          urlPath: coveragePath,
          forceRefresh: true,
        ),
      ]);

      final areaCoordsGeoJsonData = results[0] as AreaCoordsGeoJsonResponse;
      final coverageData = results[1] as VaccineCoverageResponse;

      // Create navigation level for district
      final districtNavLevel = DrilldownLevel(
        level: GeographicLevel.district,
        slug: districtSlug,
        name: districtName,
        parentSlug: null,
      );

      // Build navigation stack properly preserving division hierarchy
      List<DrilldownLevel> newNavigationStack;

      // Check if there's a division context from filter that should be preserved
      final selectedDivision = currentFilter.selectedDivision;
      final hasValidDivisionContext =
          selectedDivision != 'All' && selectedDivision.isNotEmpty;

      // Check if current navigation stack already has a division level
      final currentHasDivisionLevel =
          state.navigationStack.isNotEmpty &&
          state.navigationStack.any(
            (level) => level.level == GeographicLevel.division,
          );

      if (hasValidDivisionContext && !currentHasDivisionLevel) {
        // We have a division filter but no division in navigation stack
        // This means user went directly from country -> division -> district via filters
        // We should preserve the division level in navigation
        final divisionSlug = ApiConstants.divisionNameToSlug(selectedDivision);
        final divisionNavLevel = DrilldownLevel(
          level: GeographicLevel.division,
          slug: 'divisions/$divisionSlug',
          name: selectedDivision,
          parentSlug: null,
        );

        newNavigationStack = [divisionNavLevel, districtNavLevel];
        logg.i(
          "Preserved division '$selectedDivision' in navigation hierarchy",
        );
      } else if (currentHasDivisionLevel) {
        // Current navigation already has division, build upon it
        final existingStack = List<DrilldownLevel>.from(state.navigationStack);
        // Remove any existing district/lower levels and add new district
        existingStack.removeWhere(
          (level) => level.level.index >= GeographicLevel.district.index,
        );
        newNavigationStack = [...existingStack, districtNavLevel];
        logg.i("Built upon existing division navigation hierarchy");
      } else {
        // No division context, start fresh with just district
        newNavigationStack = [districtNavLevel];
        logg.i("Starting fresh navigation with district only");
      }

      _unfilteredCoverageData = coverageData;
      // Apply existing month filter if any
      final filteredData = VaccineDataCalculator.recalculateCoverageData(
        coverageData,
        currentFilter.selectedMonths,
      );

      state = state.copyWith(
        areaCoordsGeoJsonData: areaCoordsGeoJsonData,
        coverageData: filteredData,
        currentLevel: GeographicLevel.district,
        navigationStack: newNavigationStack,
        currentAreaName: districtName,
        isLoading: false,
        clearError: true,
        clearEpiData: true, // Clear EPI data for districts from filter
      );

      _logCurrentAreaUids(source: "District Filter ($districtName)");

      // logg.i("Successfully loaded district data for $districtName");
    } catch (e) {
      logg.e("Error loading district data for $districtName: $e");
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load district data: $e',
      );
    }
  }

  /// Load upazila data by name (for hierarchical filter)
  Future<void> loadUpazilaData({required String upazilaName}) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final currentFilter = _filterNotifier.state;
      final selectedYear = currentFilter.selectedYear;

      // Build concatenated path: district_uid/upazila_uid
      final districtUid = _filterNotifier.getDistrictUid(
        currentFilter.selectedDistrict!,
      );
      final upazilaUid = _filterNotifier.getUpazilaUid(upazilaName);

      if (districtUid == null || upazilaUid == null) {
        throw Exception('Could not find UIDs for hierarchical path');
      }

      final concatenatedSlug = '$districtUid/$upazilaUid';
      logg.i(
        "Loading upazila data for: $upazilaName (Path: $concatenatedSlug)",
      );

      // Construct API paths using concatenated slug
      final geoJsonPath = ApiConstants.getGeoJsonPath(slug: concatenatedSlug);
      final coveragePath = ApiConstants.getCoveragePath(
        slug: concatenatedSlug,
        year: selectedYear,
      );

      final results = await Future.wait([
        _dataService.fetchAreaGeoJsonCoordsData(
          urlPath: geoJsonPath,
          forceRefresh: true,
        ),
        _dataService.getVaccinationCoverage(
          urlPath: coveragePath,
          forceRefresh: true,
        ),
      ]);

      final areaCoordsGeoJsonData = results[0] as AreaCoordsGeoJsonResponse;
      final coverageData = results[1] as VaccineCoverageResponse;

      // Get district name and slug for navigation stack
      final districtName = currentFilter.selectedDistrict!;
      final districtSlug = await _getDistrictSlugFromCountryData(districtName);

      // Create navigation level for upazila
      final upazilaNavLevel = DrilldownLevel(
        level: GeographicLevel.upazila,
        slug: concatenatedSlug,
        name: upazilaName,
        parentSlug: districtSlug,
      );

      // Create navigation level for district
      final districtNavLevel = DrilldownLevel(
        level: GeographicLevel.district,
        slug: districtSlug ?? districtUid,
        name: districtName,
        parentSlug: null,
      );

      // Build navigation stack properly preserving division hierarchy
      List<DrilldownLevel> newNavigationStack;

      // Check if there's a division context from filter that should be preserved
      final selectedDivision = currentFilter.selectedDivision;
      final hasValidDivisionContext =
          selectedDivision != 'All' && selectedDivision.isNotEmpty;

      // Check if current navigation stack already has a division level
      final currentHasDivisionLevel =
          state.navigationStack.isNotEmpty &&
          state.navigationStack.any(
            (level) => level.level == GeographicLevel.division,
          );

      if (hasValidDivisionContext && !currentHasDivisionLevel) {
        // We have a division filter but no division in navigation stack
        // This means user went directly from country -> division -> district -> upazila via filters
        // We should preserve the division level in navigation
        final divisionSlug = ApiConstants.divisionNameToSlug(selectedDivision);
        final divisionNavLevel = DrilldownLevel(
          level: GeographicLevel.division,
          slug: 'divisions/$divisionSlug',
          name: selectedDivision,
          parentSlug: null,
        );

        newNavigationStack = [divisionNavLevel, districtNavLevel, upazilaNavLevel];
        logg.i(
          "Preserved division '$selectedDivision' in upazila navigation hierarchy",
        );
      } else if (currentHasDivisionLevel) {
        // Current navigation already has division, build upon it
        final existingStack = List<DrilldownLevel>.from(state.navigationStack);
        // Remove any existing district/lower levels and add new district and upazila
        existingStack.removeWhere(
          (level) => level.level.index >= GeographicLevel.district.index,
        );
        newNavigationStack = [...existingStack, districtNavLevel, upazilaNavLevel];
        logg.i("Built upon existing division navigation hierarchy for upazila");
      } else {
        // No division context, start fresh with district and upazila
        newNavigationStack = [districtNavLevel, upazilaNavLevel];
        logg.i("Starting fresh navigation with district and upazila");
      }

      _unfilteredCoverageData = coverageData;
      final filteredData = VaccineDataCalculator.recalculateCoverageData(
        coverageData,
        currentFilter.selectedMonths,
      );

      state = state.copyWith(
        areaCoordsGeoJsonData: areaCoordsGeoJsonData,
        coverageData: filteredData,
        currentLevel: GeographicLevel.upazila,
        navigationStack: newNavigationStack,
        currentAreaName: upazilaName,
        isLoading: false,
        clearError: true,
      );

      logg.i("✅ Successfully loaded upazila data for $upazilaName");
    } catch (e) {
      logg.e("Error loading upazila data: $e");
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load upazila data: $e',
      );
    }
  }

  /// Load union data by name (for hierarchical filter)
  Future<void> loadUnionData({required String unionName}) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final currentFilter = _filterNotifier.state;
      final selectedYear = currentFilter.selectedYear;

      // Build concatenated path: district_uid/upazila_uid/union_uid
      final districtUid = _filterNotifier.getDistrictUid(
        currentFilter.selectedDistrict!,
      );
      final upazilaUid = _filterNotifier.getUpazilaUid(
        currentFilter.selectedUpazila!,
      );
      final unionUid = _filterNotifier.getUnionUid(unionName);

      // ✅ FIX: Add detailed logging for union UID lookup
      logg.i("Union UID lookup for '$unionName':");
      logg.i("  Unions list size: ${currentFilter.unions.length}");
      logg.i("  Union UID result: $unionUid");
      if (unionUid == null && currentFilter.unions.isNotEmpty) {
        logg.w("  Available union names: ${currentFilter.unions.map((u) => u.name).toList()}");
      }

      if (districtUid == null || upazilaUid == null || unionUid == null) {
        final errorMsg = 'Could not find UIDs for hierarchical path: '
            'district=$districtUid, upazila=$upazilaUid, union=$unionUid';
        logg.e(errorMsg);
        throw Exception(errorMsg);
      }

      final concatenatedSlug = '$districtUid/$upazilaUid/$unionUid';
      logg.i("Loading union data for: $unionName (Path: $concatenatedSlug)");

      // Construct API paths using concatenated slug
      final geoJsonPath = ApiConstants.getGeoJsonPath(slug: concatenatedSlug);
      final coveragePath = ApiConstants.getCoveragePath(
        slug: concatenatedSlug,
        year: selectedYear,
      );

      final results = await Future.wait([
        _dataService.fetchAreaGeoJsonCoordsData(
          urlPath: geoJsonPath,
          forceRefresh: true,
        ),
        _dataService.getVaccinationCoverage(
          urlPath: coveragePath,
          forceRefresh: true,
        ),
      ]);

      final areaCoordsGeoJsonData = results[0] as AreaCoordsGeoJsonResponse;
      final coverageData = results[1] as VaccineCoverageResponse;

      // Get district name and slug for navigation stack
      final districtName = currentFilter.selectedDistrict!;
      final districtSlug = await _getDistrictSlugFromCountryData(districtName);

      // Get upazila name and build upazila slug
      final upazilaName = currentFilter.selectedUpazila!;
      final upazilaSlug = '$districtUid/$upazilaUid';

      // Create navigation level for union
      final unionNavLevel = DrilldownLevel(
        level: GeographicLevel.union,
        slug: concatenatedSlug,
        name: unionName,
        parentSlug: upazilaSlug,
      );

      // Create navigation level for upazila
      final upazilaNavLevel = DrilldownLevel(
        level: GeographicLevel.upazila,
        slug: upazilaSlug,
        name: upazilaName,
        parentSlug: districtSlug ?? districtUid,
      );

      // Create navigation level for district
      final districtNavLevel = DrilldownLevel(
        level: GeographicLevel.district,
        slug: districtSlug ?? districtUid,
        name: districtName,
        parentSlug: null,
      );

      // Build navigation stack properly preserving division hierarchy
      List<DrilldownLevel> newNavigationStack;

      // Check if there's a division context from filter that should be preserved
      final selectedDivision = currentFilter.selectedDivision;
      final hasValidDivisionContext =
          selectedDivision != 'All' && selectedDivision.isNotEmpty;

      // Check if current navigation stack already has a division level
      final currentHasDivisionLevel =
          state.navigationStack.isNotEmpty &&
          state.navigationStack.any(
            (level) => level.level == GeographicLevel.division,
          );

      if (hasValidDivisionContext && !currentHasDivisionLevel) {
        // We have a division filter but no division in navigation stack
        // This means user went directly from country -> division -> district -> upazila -> union via filters
        // We should preserve the division level in navigation
        final divisionSlug = ApiConstants.divisionNameToSlug(selectedDivision);
        final divisionNavLevel = DrilldownLevel(
          level: GeographicLevel.division,
          slug: 'divisions/$divisionSlug',
          name: selectedDivision,
          parentSlug: null,
        );

        newNavigationStack = [divisionNavLevel, districtNavLevel, upazilaNavLevel, unionNavLevel];
        logg.i(
          "Preserved division '$selectedDivision' in union navigation hierarchy",
        );
      } else if (currentHasDivisionLevel) {
        // Current navigation already has division, build upon it
        final existingStack = List<DrilldownLevel>.from(state.navigationStack);
        // Remove any existing district/lower levels and add new district, upazila, and union
        existingStack.removeWhere(
          (level) => level.level.index >= GeographicLevel.district.index,
        );
        newNavigationStack = [...existingStack, districtNavLevel, upazilaNavLevel, unionNavLevel];
        logg.i("Built upon existing division navigation hierarchy for union");
      } else {
        // No division context, start fresh with district, upazila, and union
        newNavigationStack = [districtNavLevel, upazilaNavLevel, unionNavLevel];
        logg.i("Starting fresh navigation with district, upazila, and union");
      }

      _unfilteredCoverageData = coverageData;
      final filteredData = VaccineDataCalculator.recalculateCoverageData(
        coverageData,
        currentFilter.selectedMonths,
      );

      state = state.copyWith(
        areaCoordsGeoJsonData: areaCoordsGeoJsonData,
        coverageData: filteredData,
        currentLevel: GeographicLevel.union,
        navigationStack: newNavigationStack,
        currentAreaName: unionName,
        isLoading: false,
        clearError: true,
      );

      logg.i("✅ Successfully loaded union data for $unionName");
    } catch (e) {
      logg.e("Error loading union data: $e");
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load union data: $e',
      );
    }
  }

  /// Load ward data by name (for hierarchical filter)
  Future<void> loadWardData({required String wardName}) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final currentFilter = _filterNotifier.state;
      final selectedYear = currentFilter.selectedYear;

      // Build concatenated path: district_uid/upazila_uid/union_uid/ward_uid
      final districtUid = _filterNotifier.getDistrictUid(
        currentFilter.selectedDistrict!,
      );
      final upazilaUid = _filterNotifier.getUpazilaUid(
        currentFilter.selectedUpazila!,
      );
      final unionUid = _filterNotifier.getUnionUid(
        currentFilter.selectedUnion!,
      );
      final wardUid = _filterNotifier.getWardUid(wardName);

      if (districtUid == null ||
          upazilaUid == null ||
          unionUid == null ||
          wardUid == null) {
        throw Exception('Could not find UIDs for hierarchical path');
      }

      final concatenatedSlug = '$districtUid/$upazilaUid/$unionUid/$wardUid';
      logg.i("Loading ward data for: $wardName (Path: $concatenatedSlug)");

      // Construct API paths using concatenated slug
      final geoJsonPath = ApiConstants.getGeoJsonPath(slug: concatenatedSlug);
      final coveragePath = ApiConstants.getCoveragePath(
        slug: concatenatedSlug,
        year: selectedYear,
      );

      final results = await Future.wait([
        _dataService.fetchAreaGeoJsonCoordsData(
          urlPath: geoJsonPath,
          forceRefresh: true,
        ),
        _dataService.getVaccinationCoverage(
          urlPath: coveragePath,
          forceRefresh: true,
        ),
      ]);

      final areaCoordsGeoJsonData = results[0] as AreaCoordsGeoJsonResponse;
      final coverageData = results[1] as VaccineCoverageResponse;

      // Get district name and slug for navigation stack
      final districtName = currentFilter.selectedDistrict!;
      final districtSlug = await _getDistrictSlugFromCountryData(districtName);

      // Get upazila name and build upazila slug
      final upazilaName = currentFilter.selectedUpazila!;
      final upazilaSlug = '$districtUid/$upazilaUid';

      // Get union name and build union slug
      final unionName = currentFilter.selectedUnion!;
      final unionSlug = '$districtUid/$upazilaUid/$unionUid';

      // Create navigation level for ward
      final wardNavLevel = DrilldownLevel(
        level: GeographicLevel.ward,
        slug: concatenatedSlug,
        name: wardName,
        parentSlug: unionSlug,
      );

      // Create navigation level for union
      final unionNavLevel = DrilldownLevel(
        level: GeographicLevel.union,
        slug: unionSlug,
        name: unionName,
        parentSlug: upazilaSlug,
      );

      // Create navigation level for upazila
      final upazilaNavLevel = DrilldownLevel(
        level: GeographicLevel.upazila,
        slug: upazilaSlug,
        name: upazilaName,
        parentSlug: districtSlug ?? districtUid,
      );

      // Create navigation level for district
      final districtNavLevel = DrilldownLevel(
        level: GeographicLevel.district,
        slug: districtSlug ?? districtUid,
        name: districtName,
        parentSlug: null,
      );

      // Build navigation stack properly preserving division hierarchy
      List<DrilldownLevel> newNavigationStack;

      // Check if there's a division context from filter that should be preserved
      final selectedDivision = currentFilter.selectedDivision;
      final hasValidDivisionContext =
          selectedDivision != 'All' && selectedDivision.isNotEmpty;

      // Check if current navigation stack already has a division level
      final currentHasDivisionLevel =
          state.navigationStack.isNotEmpty &&
          state.navigationStack.any(
            (level) => level.level == GeographicLevel.division,
          );

      if (hasValidDivisionContext && !currentHasDivisionLevel) {
        // We have a division filter but no division in navigation stack
        // This means user went directly from country -> division -> district -> upazila -> union -> ward via filters
        // We should preserve the division level in navigation
        final divisionSlug = ApiConstants.divisionNameToSlug(selectedDivision);
        final divisionNavLevel = DrilldownLevel(
          level: GeographicLevel.division,
          slug: 'divisions/$divisionSlug',
          name: selectedDivision,
          parentSlug: null,
        );

        newNavigationStack = [divisionNavLevel, districtNavLevel, upazilaNavLevel, unionNavLevel, wardNavLevel];
        logg.i(
          "Preserved division '$selectedDivision' in ward navigation hierarchy",
        );
      } else if (currentHasDivisionLevel) {
        // Current navigation already has division, build upon it
        final existingStack = List<DrilldownLevel>.from(state.navigationStack);
        // Remove any existing district/lower levels and add new district, upazila, union, and ward
        existingStack.removeWhere(
          (level) => level.level.index >= GeographicLevel.district.index,
        );
        newNavigationStack = [...existingStack, districtNavLevel, upazilaNavLevel, unionNavLevel, wardNavLevel];
        logg.i("Built upon existing division navigation hierarchy for ward");
      } else {
        // No division context, start fresh with district, upazila, union, and ward
        newNavigationStack = [districtNavLevel, upazilaNavLevel, unionNavLevel, wardNavLevel];
        logg.i("Starting fresh navigation with district, upazila, union, and ward");
      }

      // Fetch EPI data for ward level (uses concatenated path like GeoJSON and coverage)
      EpiCenterCoordsResponse? epiCenterCoordsData;
      try {
        // ✅ FIX: Use concatenated slug for EPI path (same as GeoJSON and coverage)
        // This matches the pattern: district/upazila/union/ward
        final epiPath = ApiConstants.getEpiPath(slug: concatenatedSlug);
        logg.i("Fetching EPI data from: $epiPath (using concatenated slug: $concatenatedSlug)");
        epiCenterCoordsData = await _dataService.getEpiCenterCoordsData(
          urlPath: epiPath,
          forceRefresh: true,
        );
        logg.i(
          "Successfully fetched EPI data for $wardName "
          "(${epiCenterCoordsData.features?.length ?? 0} EPI centers)",
        );
      } catch (e) {
        logg.w("EPI data not available for $wardName - continuing without EPI data: $e");
        epiCenterCoordsData = null;
      }

      _unfilteredCoverageData = coverageData;
      final filteredData = VaccineDataCalculator.recalculateCoverageData(
        coverageData,
        currentFilter.selectedMonths,
      );

      state = state.copyWith(
        areaCoordsGeoJsonData: areaCoordsGeoJsonData,
        coverageData: filteredData,
        epiCenterCoordsData: epiCenterCoordsData,
        currentLevel: GeographicLevel.ward,
        navigationStack: newNavigationStack,
        currentAreaName: wardName,
        isLoading: false,
        clearError: true,
      );

      logg.i("✅ Successfully loaded ward data for $wardName");
    } catch (e) {
      logg.e("Error loading ward data: $e");
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load ward data: $e',
      );
    }
  }

  /// Load zone-specific data when user selects zone filter
  Future<void> loadZoneData({required String zoneName}) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final currentFilter = _filterNotifier.state;
      final selectedYear = currentFilter.selectedYear;

      // Build concatenated path: cc_uid/zone_uid
      final ccUid = _filterNotifier.getCityCorporationUid(
        currentFilter.selectedCityCorporation!,
      );
      final zoneUid = _filterNotifier.getZoneUid(zoneName);

      if (ccUid == null || zoneUid == null) {
        throw Exception('Could not find UIDs for zone path: CC=$ccUid, Zone=$zoneUid');
      }

      final concatenatedSlug = '$ccUid/$zoneUid';
      logg.i("Loading zone data for: $zoneName (Path: $concatenatedSlug)");

      // Construct API paths using concatenated slug
      final geoJsonPath = ApiConstants.getGeoJsonPath(slug: concatenatedSlug);
      final coveragePath = ApiConstants.getCoveragePath(
        slug: concatenatedSlug,
        year: selectedYear,
      );

      final results = await Future.wait([
        _dataService.fetchAreaGeoJsonCoordsData(
          urlPath: geoJsonPath,
          forceRefresh: true,
        ),
        _dataService.getVaccinationCoverage(
          urlPath: coveragePath,
          forceRefresh: true,
        ),
      ]);

      final areaCoordsGeoJsonData = results[0] as AreaCoordsGeoJsonResponse;
      final coverageData = results[1] as VaccineCoverageResponse;

      // Get city corporation name and slug for navigation stack
      final ccName = currentFilter.selectedCityCorporation!;
      final ccSlug = ccUid.toLowerCase();

      // Create navigation level for zone
      final zoneNavLevel = DrilldownLevel(
        level: GeographicLevel.zone,
        slug: concatenatedSlug,
        name: zoneName,
        parentSlug: ccSlug,
      );

      // Create navigation level for city corporation
      final ccNavLevel = DrilldownLevel(
        level: GeographicLevel.cityCorporation,
        slug: ccSlug,
        name: ccName,
        parentSlug: null,
      );

      // Build navigation stack
      final newNavigationStack = [ccNavLevel, zoneNavLevel];

      // Fetch EPI data for zone level
      EpiCenterCoordsResponse? epiCenterCoordsData;
      try {
        final epiPath = ApiConstants.getEpiPath(slug: concatenatedSlug);
        logg.i("Fetching EPI data from: $epiPath (using concatenated slug: $concatenatedSlug)");
        epiCenterCoordsData = await _dataService.getEpiCenterCoordsData(
          urlPath: epiPath,
          forceRefresh: true,
        );
        logg.i(
          "Successfully fetched EPI data for $zoneName "
          "(${epiCenterCoordsData.features?.length ?? 0} EPI centers)",
        );
      } catch (e) {
        logg.w("EPI data not available for $zoneName - continuing without EPI data: $e");
        epiCenterCoordsData = null;
      }

      _unfilteredCoverageData = coverageData;
      final filteredData = VaccineDataCalculator.recalculateCoverageData(
        coverageData,
        currentFilter.selectedMonths,
      );

      state = state.copyWith(
        areaCoordsGeoJsonData: areaCoordsGeoJsonData,
        coverageData: filteredData,
        epiCenterCoordsData: epiCenterCoordsData,
        currentLevel: GeographicLevel.zone,
        navigationStack: newNavigationStack,
        currentAreaName: zoneName,
        isLoading: false,
        clearError: true,
      );

      logg.i("✅ Successfully loaded zone data for $zoneName");
    } catch (e) {
      logg.e("Error loading zone data: $e");
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load zone data: $e',
      );
    }
  }

  /// Extract district slug from country-level GeoJSON data
  /// This loads fresh country data to ensure we have all districts available
  Future<String?> _getDistrictSlugFromCountryData(String districtName) async {
    try {
      logg.i(
        "Loading country-level GeoJSON to find slug for district: $districtName",
      );

      // Load fresh country-level GeoJSON that contains all districts
      final countryGeoJson = await _dataService.fetchAreaGeoJsonCoordsData(
        urlPath: ApiConstants.districtJsonPath,
        forceRefresh: false, // Use cache if available for performance
      );

      final features = countryGeoJson.features;
      if (features == null || features.isEmpty) {
        logg.w("Country-level GeoJSON has no features");
        return null;
      }
      // Search for the district in the GeoJSON features
      for (final feature in features) {
        final info = feature.info;

        final featureName = info?.name;
        final slug = info?.slug;

        // Match district name and return the actual slug from GeoJSON
        if (featureName != null &&
            featureName.toLowerCase() == districtName.toLowerCase() &&
            slug != null &&
            slug.isNotEmpty) {
          logg.i("Found slug for $districtName: $slug");
          return slug;
        }
      }

      logg.w(
        "Could not find slug for district: $districtName in country-level GeoJSON data",
      );
      return null;
    } catch (e) {
      logg.e("Error extracting district slug from country GeoJSON: $e");
      return null;
    }
  }

  /// Explicitly clear any error state
  void clearError() {
    logg.i("Explicitly clearing error state");
    state = state.copyWith(clearError: true);
  }

  /// Specialized logging for the CURRENT focal area's UIDs
  void _logCurrentAreaUids({required String source}) {
    final areaName = state.currentAreaName;
    if (areaName == 'Bangladesh') return;

    logg.i("🎯 UID_REPORT: Focal Area '$areaName' (Trigger: $source)");

    // 1. Get UID from Filter State (The most common source of truth for IDs)
    // 1. Get UID from Filter State or Navigation Stack
    final uid = focalAreaUid;

    if (uid != null) {
      logUidInfo(
        source: source,
        layer: "Focal Area",
        name: areaName ?? "Unknown",
        uid: uid,
      );
    }
  }

  /// Get the UID of the current focal area (deepest filter or navigation level)
  String? get focalAreaUid {
    // 1. Get UID from Filter State (The most common source of truth for IDs)
    final filterState = _filterNotifier.state;
    String? filterUid;

    // ✅ Check from deepest to shallowest level
    if (filterState.selectedSubblock != null &&
        filterState.selectedSubblock != 'All') {
      filterUid = _filterNotifier.getSubblockUid(filterState.selectedSubblock!);
    } else if (filterState.selectedWard != null &&
        filterState.selectedWard != 'All') {
      filterUid = _filterNotifier.getWardUid(filterState.selectedWard!);
    } else if (filterState.selectedUnion != null &&
        filterState.selectedUnion != 'All') {
      filterUid = _filterNotifier.getUnionUid(filterState.selectedUnion!);
    } else if (filterState.selectedUpazila != null &&
        filterState.selectedUpazila != 'All') {
      filterUid = _filterNotifier.getUpazilaUid(filterState.selectedUpazila!);
    } else if (filterState.selectedDistrict != null &&
        filterState.selectedDistrict != 'All') {
      filterUid = _filterNotifier.getDistrictUid(filterState.selectedDistrict!);
    } else if (filterState.selectedDivision != 'All') {
      filterUid = _filterNotifier.getDivisionUid(filterState.selectedDivision);
    } 
    // ✅ FIX: Check for zone selection (for city corporation hierarchy)
    else if (filterState.selectedZone != null &&
        filterState.selectedZone != 'All' &&
        filterState.selectedCityCorporation != null) {
      // For zones, we need to return the concatenated slug (ccUid/zoneUid)
      // This matches the pattern used in loadZoneData
      final ccUid = _filterNotifier.getCityCorporationUid(
        filterState.selectedCityCorporation!,
      );
      final zoneUid = _filterNotifier.getZoneUid(filterState.selectedZone!);
      if (ccUid != null && zoneUid != null) {
        filterUid = '$ccUid/$zoneUid';
        logg.i('focalAreaUid: Using concatenated zone path: $filterUid');
      }
    } 
    // ✅ Check for city corporation (only if no zone is selected)
    else if (filterState.selectedCityCorporation != null &&
        filterState.selectedCityCorporation != 'All') {
      filterUid = _filterNotifier.getCityCorporationUid(
        filterState.selectedCityCorporation!,
      );
    }

    if (filterUid != null) {
      return filterUid;
    }

    // 2. Get UID from Navigation Stack (The slug used for the API request)
    // This is especially important for zones since they use concatenated slugs
    if (state.navigationStack.isNotEmpty) {
      final slug = state.navigationStack.last.slug;
      logg.i('focalAreaUid: Using navigation stack slug: $slug');
      return slug;
    }

    return null;
  }

  /// Get unfiltered coverage data (for summary controller to apply its own month filtering)
  VaccineCoverageResponse? get unfilteredCoverageData => _unfilteredCoverageData;

  /// Apply month filter to existing data
  void applyMonthFilter(List<String> selectedMonths) {
    if (_unfilteredCoverageData == null) return;

    logg.i("Applying month filter to MAP: $selectedMonths");

    final filteredData = VaccineDataCalculator.recalculateCoverageData(
      _unfilteredCoverageData,
      selectedMonths,
    );

    state = state.copyWith(coverageData: filteredData);
  }

  // ============================================================================
  // MAP-FILTER SYNC FUNCTIONALITY (Integrated from MapFilterSyncService)
  // ============================================================================

  /// Check if a UID corresponds to a district using live backend data
  bool isDistrictUid(String uid) {
    final filterState = _filterNotifier.state;
    final districts = filterState.districts;
    return districts.any((district) => district.uid == uid);
  }

  /// Get division name for a district UID using live backend data
  String? getDivisionNameForDistrict(String districtUid) {
    try {
      final filterState = _filterNotifier.state;

      // Find the district with this UID
      final districts = filterState.districts;
      final district = districts.where((d) => d.uid == districtUid).firstOrNull;

      if (district?.parentUid == null) {
        logg.w("🔍 District UID '$districtUid' has no parent_uid");
        return null;
      }

      // Find the division with the parent UID
      final divisions = filterState.divisions;
      final division = divisions
          .where((d) => d.uid == district!.parentUid)
          .firstOrNull;

      if (division?.name == null) {
        logg.w("🔍 No division found for parent_uid '${district!.parentUid}'");
        return null;
      }

      logg.d(
        "✅ DYNAMIC: District '$districtUid' → Division '${division!.name}'",
      );
      return division.name;
    } catch (e) {
      logg.e("❌ Error resolving division for district '$districtUid': $e");
      return null;
    }
  }

  /// Get district name for a district UID using live backend data
  String? getDistrictName(String districtUid) {
    try {
      final filterState = _filterNotifier.state;
      final districts = filterState.districts;
      final district = districts.where((d) => d.uid == districtUid).firstOrNull;

      if (district?.name == null) {
        logg.w("🔍 No district found for UID '$districtUid'");
        return null;
      }

      logg.d(
        "✅ DYNAMIC: District UID '$districtUid' → Name '${district!.name}'",
      );
      return district.name;
    } catch (e) {
      logg.e("❌ Error resolving district name for UID '$districtUid': $e");
      return null;
    }
  }

  /// Sync filters with tapped district using live backend data

  Future<bool> syncFiltersWithDistrict(String districtUid) async {
    try {
      logg.d(
        "🔄 DYNAMIC SYNC: Starting filter sync for district UID '$districtUid'",
      );

      // Get district and division names using live data
      final districtName = getDistrictName(districtUid);
      final divisionName = getDivisionNameForDistrict(districtUid);

      if (districtName == null || divisionName == null) {
        logg.w(
          "❌ Cannot sync - missing names: district='$districtName', division='$divisionName'",
        );
        return false;
      }

      // Update filters using the existing FilterController methods
      logg.d("🎯 DYNAMIC SYNC: Updating division to '$divisionName'");
      _filterNotifier.updateDivision(divisionName);

      // Small delay to let division update propagate
      await Future.delayed(const Duration(milliseconds: 100));

      logg.d("🎯 DYNAMIC SYNC: Updating district to '$districtName'");
      _filterNotifier.updateDistrict(districtName);

      logg.i(
        "✅ DYNAMIC SYNC: Successfully synced filters - Division: '$divisionName', District: '$districtName'",
      );
      return true;
    } catch (e) {
      logg.e(
        "❌ DYNAMIC SYNC: Error syncing filters for district '$districtUid': $e",
      );
      return false;
    }
  }

  /// Check if the filter data is ready for sync operations
  bool get isFilterSyncReady {
    final filterState = _filterNotifier.state;
    return !filterState.isLoadingAreas &&
        filterState.areasError == null &&
        filterState.divisions.isNotEmpty &&
        filterState.districts.isNotEmpty;
  }
}
