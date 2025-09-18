import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gis_dashboard/core/common/constants/api_constants.dart';
import 'package:gis_dashboard/core/service/data_service.dart';
import 'package:gis_dashboard/features/filter/filter.dart';

import '../../../../core/utils/utils.dart';
import 'map_state.dart';
import '../../../summary/domain/vaccine_coverage_response.dart';

final mapControllerProvider =
    StateNotifierProvider<MapControllerNotifier, MapState>((ref) {
      return MapControllerNotifier(
        dataService: ref.read(dataServiceProvider),
        filterNotifier: ref.read(filterControllerProvider.notifier),
      );
    });

class MapControllerNotifier extends StateNotifier<MapState> {
  final DataService _dataService;
  final FilterControllerNotifier _filterNotifier;

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

      // Try to get cached data first, but only if it's for the correct year
      final cachedCoverageData = _dataService.getCachedCoverageData();
      if (cachedCoverageData != null &&
          !forceRefresh &&
          cachedCoverageData.metadata?.year.toString() == selectedYear) {
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

  // Future<void> refreshMapData() async {
  //   await loadInitialData(forceRefresh: true);
  // }

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

      // Add EPI request only when drilling down to a specific area (not for collections)
      // EPI is only available for specific upazila, union, ward, or subblock areas
      // When drilling down from district->upazila, we load multiple upazilas so no EPI
      // EPI should only be fetched when clicking on a specific upazila/union/ward/subblock
      if ((newLevel == 'union' ||
              newLevel == 'ward' ||
              newLevel == 'subblock') ||
          (newLevel == 'upazila' && state.currentLevel != 'district')) {
        final epiPath = ApiConstants.getEpiPath(slug: slug);
        logg.i("Fetching EPI data from: $epiPath");
        apiRequests.add(
          _dataService.getEpiData(urlPath: epiPath, forceRefresh: true),
        );
      }

      final results = await Future.wait(apiRequests);

      final geoJson = results[0] as String;
      final coverageData = results[1] as VaccineCoverageResponse;

      // EPI data is available for specific upazila, union and deeper levels (not collections)
      String? epiData;
      if (((newLevel == 'union' ||
                  newLevel == 'ward' ||
                  newLevel == 'subblock') ||
              (newLevel == 'upazila' && state.currentLevel != 'district')) &&
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

        // Add EPI request if going back to upazila, union or deeper level (not district)
        if (previousLevel.level == 'upazila' ||
            previousLevel.level == 'union' ||
            previousLevel.level == 'ward') {
          final epiPath = ApiConstants.getEpiPath(slug: previousLevel.slug);
          apiRequests.add(
            _dataService.getEpiData(urlPath: epiPath, forceRefresh: true),
          );
        }

        final results = await Future.wait(apiRequests);

        final geoJson = results[0] as String;
        final coverageData = results[1] as VaccineCoverageResponse;

        // EPI data is available for upazila, union and deeper levels (not district)
        String? epiData;
        if ((previousLevel.level == 'upazila' ||
                previousLevel.level == 'union' ||
                previousLevel.level == 'ward') &&
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
    await loadInitialData(forceRefresh: false);
  }

  // /// Reload current level data (useful when filter changes)
  // Future<void> reloadCurrentLevel() async {
  //   if (state.navigationStack.isEmpty) {
  //     // At country level
  //     await loadInitialData(forceRefresh: true);
  //   } else {
  //     // At some drilldown level
  //     final currentLevel = state.navigationStack.last;
  //     await drillDownToArea(
  //       areaName: currentLevel.name ?? currentLevel.level,
  //       slug: currentLevel.slug ?? '',
  //       newLevel: currentLevel.level,
  //       parentSlug: currentLevel.parentSlug,
  //     );
  //   }
  // }

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
        _dataService.getGeoJson(urlPath: geoJsonPath, forceRefresh: true),
        _dataService.getVaccinationCoverage(
          urlPath: coveragePath,
          forceRefresh: true,
        ),
      ]);

      final geoJson = results[0] as String;
      final coverageData = results[1] as VaccineCoverageResponse;

      // Create navigation level for division
      final divisionNavLevel = DrilldownLevel(
        level: 'division',
        slug: 'divisions/$divisionSlug',
        name: divisionName,
        parentSlug: null,
      );

      state = state.copyWith(
        geoJson: geoJson,
        coverageData: coverageData,
        epiData: null, // No EPI data for divisions
        currentLevel: 'division',
        navigationStack: [
          divisionNavLevel,
        ], // Start fresh navigation for division
        currentAreaName: divisionName,
        isLoading: false,
        clearError: true,
      );

      logg.i("Successfully loaded division data for $divisionName");
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

      // Get city corporation slug using proper name conversion
      final ccSlug = ApiConstants.cityCorporationNameToSlug(
        cityCorporationName,
      );

      logg.i(
        "Loading city corporation data for: $cityCorporationName (slug: $ccSlug)",
      );

      // Construct API paths for city corporation
      final geoJsonPath = ApiConstants.getCityCorporationGeoJsonPath(
        ccSlug: ccSlug,
      );
      final coveragePath = ApiConstants.getCityCorporationCoveragePath(
        ccSlug: ccSlug,
        year: selectedYear,
      );
      final epiPath = ApiConstants.getCityCorporationEpiPath(ccSlug: ccSlug);

      logg.i("Fetching city corporation GeoJSON from: $geoJsonPath");
      logg.i("Fetching city corporation coverage from: $coveragePath");
      logg.i("Fetching city corporation EPI from: $epiPath");

      final results = await Future.wait([
        _dataService.getGeoJson(urlPath: geoJsonPath, forceRefresh: true),
        _dataService.getVaccinationCoverage(
          urlPath: coveragePath,
          forceRefresh: true,
        ),
        _dataService.getEpiData(urlPath: epiPath, forceRefresh: true),
      ]);

      final geoJson = results[0] as String;
      final coverageData = results[1] as VaccineCoverageResponse;
      final epiData = results[2] as String;

      // Create navigation level for city corporation
      final ccNavLevel = DrilldownLevel(
        level: 'city_corporation',
        slug: 'city-corporations/$ccSlug',
        name: cityCorporationName,
        parentSlug: null,
      );

      state = state.copyWith(
        geoJson: geoJson,
        coverageData: coverageData,
        epiData: epiData, // Include EPI data for city corporations
        currentLevel: 'city_corporation',
        navigationStack: [
          ccNavLevel,
        ], // Start fresh navigation for city corporation
        currentAreaName: cityCorporationName,
        isLoading: false,
        clearError: true,
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
        _dataService.getGeoJson(urlPath: geoJsonPath, forceRefresh: true),
        _dataService.getVaccinationCoverage(
          urlPath: coveragePath,
          forceRefresh: true,
        ),
      ]);

      final geoJson = results[0] as String;
      final coverageData = results[1] as VaccineCoverageResponse;

      // Create navigation level for district
      final districtNavLevel = DrilldownLevel(
        level: 'district',
        slug: districtSlug,
        name: districtName,
        parentSlug: null,
      );

      state = state.copyWith(
        geoJson: geoJson,
        coverageData: coverageData,
        epiData: null, // No EPI data for districts from filter
        currentLevel: 'district',
        navigationStack: [
          districtNavLevel,
        ], // Start fresh navigation for district
        currentAreaName: districtName,
        isLoading: false,
        clearError: true,
      );

      logg.i("Successfully loaded district data for $districtName");
    } catch (e) {
      logg.e("Error loading district data for $districtName: $e");
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load district data: $e',
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
      final countryGeoJson = await _dataService.getGeoJson(
        urlPath: ApiConstants.districtJsonPath,
        forceRefresh: false, // Use cache if available for performance
      );

      final decoded = jsonDecode(countryGeoJson) as Map<String, dynamic>;
      final features = decoded['features'] as List<dynamic>;

      // Search for the district in the GeoJSON features
      for (final feature in features) {
        final info =
            feature['info'] as Map<String, dynamic>? ?? <String, dynamic>{};

        final String? featureName = info['name'] as String?;
        final String? slug = info['slug'] as String?;

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
  /// ! this needs some modifications : should not allow any api calling at all
  /// ! should just update things at once using existing data in filter state
  /// ! maybe it is updating district two times
  /// ! needs further investigation
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

  // /// Get debug information about available filter data
  // Map<String, dynamic> getFilterSyncDebugInfo() {
  //   final filterState = _filterNotifier.state;
  //   return {
  //     'divisionsLoaded': filterState.divisions.length,
  //     'districtsLoaded': filterState.districts.length,
  //     'isLoadingAreas': filterState.isLoadingAreas,
  //     'hasError': filterState.areasError != null,
  //     'selectedDivision': filterState.selectedDivision,
  //     'selectedDistrict': filterState.selectedDistrict,
  //     'sampleDistricts': filterState.districts
  //         .take(3)
  //         .map((d) => '${d.uid}: ${d.name}')
  //         .toList(),
  //     'sampleDivisions': filterState.divisions
  //         .take(3)
  //         .map((d) => '${d.uid}: ${d.name}')
  //         .toList(),
  //   };
  // }

  /// Check if the filter data is ready for sync operations
  bool get isFilterSyncReady {
    final filterState = _filterNotifier.state;
    return !filterState.isLoadingAreas &&
        filterState.areasError == null &&
        filterState.divisions.isNotEmpty &&
        filterState.districts.isNotEmpty;
  }
}
