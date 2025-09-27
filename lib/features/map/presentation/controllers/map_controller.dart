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
      logg.i(
        'metadata: ${coverageData.metadata} year: ${coverageData.metadata?.year}',
      );
      logg.i(
        "Loaded Coverage data for ${coverageData.vaccines?.first.vaccineName} and ${coverageData.vaccines?.first.areas?.length} coverage areas",
      );

      state = state.copyWith(
        areaCoordsGeoJsonData: areaCoordsGeoJsonData,
        coverageData: coverageData,
        currentLevel: GeographicLevel
            .country, // Fixed: Country level should use country enum
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

      state = state.copyWith(
        areaCoordsGeoJsonData: areaCoordsGeoJsonData,
        coverageData: coverageData,
        epiCenterCoordsData: epiCenterCoordsData,
        currentLevel: newLevelEnum,
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

        state = state.copyWith(
          areaCoordsGeoJsonData: areaCoordsGeoJsonData,
          coverageData: coverageData,
          epiCenterCoordsData: epiCenterCoordsData,
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

      state = state.copyWith(
        areaCoordsGeoJsonData: areaCoordsGeoJsonData,
        coverageData: coverageData,
        epiCenterCoordsData: null, // No EPI data for divisions
        currentLevel: GeographicLevel.division,
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

      state = state.copyWith(
        areaCoordsGeoJsonData: areaCoordsGeoJsonData,
        coverageData: coverageData,
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

      state = state.copyWith(
        areaCoordsGeoJsonData: areaCoordsGeoJsonData,
        coverageData: coverageData,
        epiCenterCoordsData: null, // No EPI data for districts from filter
        currentLevel: GeographicLevel.district,
        navigationStack: newNavigationStack,
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

  /// Check if the filter data is ready for sync operations
  bool get isFilterSyncReady {
    final filterState = _filterNotifier.state;
    return !filterState.isLoadingAreas &&
        filterState.areasError == null &&
        filterState.divisions.isNotEmpty &&
        filterState.districts.isNotEmpty;
  }
}
