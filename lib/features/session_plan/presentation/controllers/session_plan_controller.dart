import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gis_dashboard/core/common/constants/api_constants.dart';
import 'package:gis_dashboard/core/service/data_service.dart';
import 'package:gis_dashboard/core/utils/utils.dart';
import 'package:gis_dashboard/features/map/domain/area_coords_geo_json_response.dart';
import 'package:gis_dashboard/features/session_plan/domain/session_plan_coords_response.dart';
import 'package:gis_dashboard/features/filter/presentation/controllers/filter_controller.dart';
import 'package:gis_dashboard/features/filter/domain/filter_state.dart';
import 'package:gis_dashboard/features/map/presentation/controllers/map_controller.dart';
import 'package:gis_dashboard/features/map/utils/map_enums.dart';

// State class for Session Plan
class SessionPlanState {
  final bool isLoading;
  final String? error;
  final AreaCoordsGeoJsonResponse? areaCoordsGeoJsonData;
  final SessionPlanCoordsResponse? sessionPlanCoordsData;
  final String? startDate;
  final String? endDate;

  SessionPlanState({
    this.isLoading = false,
    this.error,
    this.areaCoordsGeoJsonData,
    this.sessionPlanCoordsData,
    this.startDate,
    this.endDate,
  });

  SessionPlanState copyWith({
    bool? isLoading,
    String? error,
    AreaCoordsGeoJsonResponse? areaCoordsGeoJsonData,
    SessionPlanCoordsResponse? sessionPlanCoordsData,
    String? startDate,
    String? endDate,
    bool clearError = false,
  }) {
    return SessionPlanState(
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      areaCoordsGeoJsonData:
          areaCoordsGeoJsonData ?? this.areaCoordsGeoJsonData,
      sessionPlanCoordsData:
          sessionPlanCoordsData ?? this.sessionPlanCoordsData,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
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
      final filterNotifier = _ref.read(filterControllerProvider.notifier);
      final mapNotifier = _ref.read(mapControllerProvider.notifier);
      
      // ✅ FIX: Wait for upazilas to be loaded if upazila is selected but list is empty
      if (filterState.selectedUpazila != null && 
          filterState.selectedUpazila != 'All' &&
          filterState.upazilas.isEmpty &&
          filterState.selectedDistrict != null &&
          filterState.selectedDistrict != 'All') {
        logg.w('Session Plan: Upazilas list is empty, waiting for them to load...');
        int retries = 0;
        const maxRetries = 30; // 3 seconds max wait
        
        while (retries < maxRetries) {
          await Future.delayed(const Duration(milliseconds: 100));
          final currentFilterState = _ref.read(filterControllerProvider);
          if (currentFilterState.upazilas.isNotEmpty) {
            logg.i('Session Plan: Upazilas loaded (${currentFilterState.upazilas.length} items)');
            break;
          }
          retries++;
        }
        
        if (_ref.read(filterControllerProvider).upazilas.isEmpty) {
          logg.e('Session Plan: Upazilas still not loaded after waiting - proceeding anyway');
        }
      }
      
      // ✅ FIX: Build correct area UID based on filter hierarchy
      // For union/ward levels, we need concatenated paths like district/upazila/union or district/upazila/union/ward
      String? effectiveAreaUid = areaUid;
      
      if (effectiveAreaUid == null) {
        // Build area UID based on filter state (check from deepest to shallowest)
        effectiveAreaUid = _buildAreaUidForSessionPlan(filterState, filterNotifier);
        
        // Fallback to map controller's focalAreaUid if we couldn't build one
        effectiveAreaUid ??= mapNotifier.focalAreaUid;
      }
      
      final areaParam = effectiveAreaUid ?? 'undefined';
      
      logg.i("Session Plan: Using area UID: $areaParam");
      logg.i("Session Plan: Filter state - District: ${filterState.selectedDistrict}, Upazila: ${filterState.selectedUpazila}");

      // Construct URL based on parameters
      String sessionPlanUrl = '${ApiConstants.sessionPlans}?area=$areaParam';
      
      // ✅ FIX: Always include date parameters (even if empty) to ensure proper filtering
      // Format: YYYY-MM-DD (e.g., 2025-12-01)
      if (startDate != null && startDate.isNotEmpty) {
        sessionPlanUrl += '&start_date=$startDate';
        logg.i("Session Plan: Using start_date: $startDate");
      } else {
        sessionPlanUrl += '&start_date=';
        logg.i("Session Plan: No start_date provided (empty)");
      }

      if (endDate != null && endDate.isNotEmpty) {
        sessionPlanUrl += '&end_date=$endDate';
        logg.i("Session Plan: Using end_date: $endDate");
      } else {
        sessionPlanUrl += '&end_date=';
        logg.i("Session Plan: No end_date provided (empty)");
      }

      // ✅ FIX: Add limit parameter to fetch more features (if API supports it)
      // Try to get all sessions, but cap at 50,000 to prevent memory issues
      // The API might have a max limit, so we'll see what it returns
      sessionPlanUrl += '&limit=50000';
      logg.i("Session Plan: Requesting up to 50,000 features (API may limit to 10,000)");

      logg.i("Fetching session plans from: $sessionPlanUrl");

      // ✅ OPTIMIZATION 1: Check if area changed - if not, reuse existing GeoJSON
      final previousAreaUid = _getCurrentAreaUidFromState();
      final currentAreaUid = effectiveAreaUid;
      final areaChanged = previousAreaUid != currentAreaUid;
      
      logg.i("Session Plan: Area check - previous: $previousAreaUid, current: $currentAreaUid, changed: $areaChanged");
      
      // ✅ OPTIMIZATION: Skip GeoJSON reload if only dates changed (saves 1-2 seconds)
      // Check if dates changed but area didn't
      final previousStartDate = state.startDate;
      final previousEndDate = state.endDate;
      final datesChanged = (startDate != previousStartDate) || (endDate != previousEndDate);
      final onlyDatesChanged = datesChanged && !areaChanged;
      
      if (onlyDatesChanged) {
        logg.i("Session Plan: ✅ Only dates changed - skipping GeoJSON reload (saves ~1-2 seconds)");
      }

      // ✅ FIX: Use the map controller's GeoJSON data if available (after drilldown)
      // This ensures we use the exact same GeoJSON that the map controller loaded
      final mapState = _ref.read(mapControllerProvider);
      AreaCoordsGeoJsonResponse? areaCoordsGeoJsonData;
      
      // ✅ OPTIMIZATION 1: Reuse existing GeoJSON if area hasn't changed OR only dates changed
      if ((!areaChanged || onlyDatesChanged) && state.areaCoordsGeoJsonData != null) {
        logg.i("Session Plan: ✅ Reusing existing GeoJSON (area unchanged or only dates changed)");
        areaCoordsGeoJsonData = state.areaCoordsGeoJsonData;
      }
      // Check if map controller has GeoJSON data for the current filter level
      else if (mapState.areaCoordsGeoJsonData != null && !mapState.isLoading && !onlyDatesChanged) {
        // Use map controller's GeoJSON data (already loaded from drilldown)
        logg.i("Session Plan: Using GeoJSON data from map controller (already loaded from drilldown)");
        areaCoordsGeoJsonData = mapState.areaCoordsGeoJsonData;
      } 
      // Only load new GeoJSON if area changed and we don't have it from map controller
      // Skip GeoJSON reload if only dates changed (saves 1-2 seconds)
      else if (areaChanged && !onlyDatesChanged) {
        // Map controller doesn't have GeoJSON yet, load it ourselves
        logg.i("Session Plan: Map controller doesn't have GeoJSON, loading separately");
        
        // Determine GeoJSON path based on filter level
        String effectiveGeoJsonPath;
        if (geoJsonPath != null) {
          effectiveGeoJsonPath = geoJsonPath;
        } else {
          // ✅ FIX: Use the same area UID building logic for GeoJSON path as for session plan API
          // This ensures consistency between the area parameter and GeoJSON path
          final geoJsonAreaUid = _buildAreaUidForSessionPlan(filterState, filterNotifier);
          
          if (geoJsonAreaUid != null) {
            // Use the built area UID to construct GeoJSON path
            effectiveGeoJsonPath = ApiConstants.getGeoJsonPath(slug: geoJsonAreaUid);
          } else {
            // Fallback to using map controller's focalAreaUid or filter-based path
            effectiveGeoJsonPath = _getGeoJsonPathForFilter(filterState, mapNotifier);
          }
        }

        logg.i("Fetching GeoJSON from: $effectiveGeoJsonPath (using area UID: $effectiveAreaUid)");

        // ✅ FIX: Try to fetch GeoJSON, but allow session plan to work even if GeoJSON is missing
        // Some area levels (like division) may not have GeoJSON files, but session plan data might still exist
        
        // ✅ FIX: Check if this is a city corporation filter and use fallback strategy
        final isCityCorporationLevel = filterState.selectedAreaType == AreaType.cityCorporation &&
            filterState.selectedCityCorporation != null &&
            filterState.selectedCityCorporation != 'All' &&
            filterState.selectedZone == null;
        
        try {
          if (isCityCorporationLevel) {
            // Use fallback strategy for city corporations (UID first, then name-based)
            final filterNotifier = _ref.read(filterControllerProvider.notifier);
            final ccUid = filterNotifier.getCityCorporationUid(filterState.selectedCityCorporation!);
            final ccName = filterState.selectedCityCorporation!;
            
            if (ccUid != null) {
              final geoJsonPaths = ApiConstants.getCityCorporationGeoJsonPaths(
                ccUid: ccUid,
                ccName: ccName,
              );
              logg.i("City corporation GeoJSON fallback paths: $geoJsonPaths");
              areaCoordsGeoJsonData = await _dataService.fetchAreaGeoJsonCoordsDataWithFallback(
                urlPaths: geoJsonPaths,
                forceRefresh: false,
              );
              logg.i("✅ Successfully fetched city corporation GeoJSON data");
            } else {
              // Fallback to single path if UID not found
              areaCoordsGeoJsonData = await _dataService.fetchAreaGeoJsonCoordsData(
                urlPath: effectiveGeoJsonPath,
                forceRefresh: false,
              );
              logg.i("✅ Successfully fetched GeoJSON data");
            }
          } else {
            // For other area types, use standard method
            areaCoordsGeoJsonData = await _dataService.fetchAreaGeoJsonCoordsData(
              urlPath: effectiveGeoJsonPath,
              forceRefresh: false,
            );
            logg.i("✅ Successfully fetched GeoJSON data");
          }
        } catch (geoJsonError) {
          // GeoJSON not found (404) - this is acceptable for some area levels
          // We can still show session plan markers without polygons
          logg.w("⚠️ GeoJSON not available for $effectiveGeoJsonPath - continuing without polygons");
          logg.w("   Error: $geoJsonError");
          areaCoordsGeoJsonData = null; // Allow null - markers can still be displayed
        }
      }

      // ✅ OPTIMIZATION 2 & 3: Load session plan data (with smart caching)
      // Only force refresh if area changed, otherwise use cache
      logg.i("Session Plan: Fetching session plan data (forceRefresh: $areaChanged)");
      final sessionPlanCoordsData = await _dataService.getSessionPlanCoords(
        urlPath: sessionPlanUrl,
        forceRefresh: areaChanged, // ✅ OPTIMIZATION 3: Only force refresh if area changed
      );

      logg.i(
        "Session Plan: ✅ Loaded session plan data - features: ${sessionPlanCoordsData.features?.length ?? 0}, sessionCount: ${sessionPlanCoordsData.sessionCount ?? 'null'}",
      );
      
      // ✅ DEBUG: Verify sessionCount is correctly set
      if (sessionPlanCoordsData.sessionCount != null) {
        logg.i("Session Plan: ✅ sessionCount is NOT null: ${sessionPlanCoordsData.sessionCount}");
      } else {
        logg.w("Session Plan: ⚠️ sessionCount IS null - this might be why the count is wrong!");
        logg.w("Session Plan: ⚠️ Check if API response contains 'session_count' field");
      }
      
      // ✅ DEBUG: Log the raw JSON to verify session_count is in the response
      try {
        final rawJson = sessionPlanCoordsData.toJson();
        logg.i("Session Plan: Serialized JSON - session_count field: ${rawJson['session_count']}");
        logg.i("Session Plan: Serialized JSON - type: ${rawJson['type']}, features count: ${(rawJson['features'] as List?)?.length ?? 0}");
      } catch (e) {
        logg.w("Session Plan: Could not log serialized JSON: $e");
      }
      
      if (sessionPlanCoordsData.features == null || sessionPlanCoordsData.features!.isEmpty) {
        logg.w("Session Plan: ⚠️ No session plan features returned for area: $areaParam");
        logg.w("Session Plan: Check if date range is valid (start: $startDate, end: $endDate)");
      }

      // ✅ If we have session plan data but no GeoJSON, that's okay - show markers only
      if (areaCoordsGeoJsonData == null && sessionPlanCoordsData.features != null && sessionPlanCoordsData.features!.isNotEmpty) {
        logg.i("⚠️ No GeoJSON available, but ${sessionPlanCoordsData.features!.length} session plan markers will be displayed");
      }

      state = state.copyWith(
        areaCoordsGeoJsonData: areaCoordsGeoJsonData,
        sessionPlanCoordsData: sessionPlanCoordsData,
        startDate: startDate, // Store dates in state for persistence
        endDate: endDate,
        isLoading: false,
        clearError: true,
      );
      
      // ✅ DEBUG: Log date filter state
      logg.i("Session Plan: ✅ Date filter applied - startDate: ${startDate ?? 'null'}, endDate: ${endDate ?? 'null'}");
      logg.i("Session Plan: ✅ State updated with dates - startDate: ${state.startDate ?? 'null'}, endDate: ${state.endDate ?? 'null'}");
    } catch (e) {
      logg.e("Error loading session plan data: $e");
      
      // ✅ Provide more specific error messages
      String errorMessage = 'Failed to load session plan data';
      if (e.toString().contains('404') || e.toString().contains('not found')) {
        errorMessage = 'Session plan data not available for the selected area. Please try a different area or date range.';
      } else if (e.toString().contains('timeout')) {
        errorMessage = 'Request timed out. Please check your internet connection and try again.';
      } else if (e.toString().contains('No internet')) {
        errorMessage = 'No internet connection. Please check your network settings.';
      } else {
        errorMessage = 'Failed to load session plan data: ${e.toString()}';
      }
      
      state = state.copyWith(
        isLoading: false,
        error: errorMessage,
      );
    }
  }

  /// Get current area UID from state (for optimization - check if area changed)
  String? _getCurrentAreaUidFromState() {
    // Try to determine area UID from current state
    // This is used to check if area changed (to skip GeoJSON reload)
    final filterState = _ref.read(filterControllerProvider);
    final filterNotifier = _ref.read(filterControllerProvider.notifier);
    
    // Use the same logic as _buildAreaUidForSessionPlan to get current area UID
    return _buildAreaUidForSessionPlan(filterState, filterNotifier);
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

    // ✅ FIX: Check if this is a division-level filter
    // Division-level filters use a different path format: /shapes/divisions/division-slug/shape.json.gz
    final isDivisionLevel = filterState.selectedDivision != 'All' &&
        filterState.selectedDistrict == null &&
        filterState.selectedUpazila == null &&
        filterState.selectedUnion == null &&
        filterState.selectedWard == null &&
        filterState.selectedSubblock == null &&
        filterState.selectedCityCorporation == null &&
        filterState.selectedZone == null;

    if (isDivisionLevel && focalAreaUid.length < 20 && !focalAreaUid.contains('/')) {
      // This is a division UID - use division-specific path format
      final divisionSlug = ApiConstants.divisionNameToSlug(filterState.selectedDivision);
      return ApiConstants.getDivisionGeoJsonPath(divisionSlug: divisionSlug);
    }

    // ✅ FIX: Check if this is a city corporation-level filter
    // City corporation filters need special handling with fallback paths
    // Check filter state directly, not focalAreaUid, because focalAreaUid might be wrong
    final isCityCorporationLevel = filterState.selectedAreaType == AreaType.cityCorporation &&
        filterState.selectedCityCorporation != null &&
        filterState.selectedCityCorporation != 'All' &&
        filterState.selectedZone == null;

    if (isCityCorporationLevel) {
      // Get city corporation UID for fallback paths
      final filterNotifier = _ref.read(filterControllerProvider.notifier);
      final ccUid = filterNotifier.getCityCorporationUid(filterState.selectedCityCorporation!);
      if (ccUid != null) {
        // Use city corporation fallback paths (UID first, then name-based)
        // Return the first path (UID-based) - the actual fallback is handled in loadDataWithFilter
        final ccName = filterState.selectedCityCorporation!;
        final geoJsonPaths = ApiConstants.getCityCorporationGeoJsonPaths(
          ccUid: ccUid,
          ccName: ccName,
        );
        if (geoJsonPaths.isNotEmpty) {
          return geoJsonPaths.first;
        }
      }
    }

    // For other levels, use the standard GeoJSON path
    // This matches the pattern used in map controller
    return ApiConstants.getGeoJsonPath(slug: focalAreaUid);
  }

  // Reload with specific dates
  Future<void> updateDateFilter(String startDate, String endDate) async {
    await loadDataWithFilter(startDate: startDate, endDate: endDate);
  }

  /// Build correct area UID for session plan API based on filter hierarchy
  /// This ensures union/ward levels use concatenated paths (district/upazila/union or district/upazila/union/ward)
  String? _buildAreaUidForSessionPlan(
    FilterState filterState,
    FilterControllerNotifier filterNotifier,
  ) {
    // Check from deepest to shallowest level (matching map controller logic)
    // ✅ FIX: For union level, build concatenated path: district/upazila/union
    if (filterState.selectedUnion != null && filterState.selectedUnion != 'All') {
      // Union requires district and upazila to be selected (hierarchical dependency)
      if (filterState.selectedDistrict != null && 
          filterState.selectedDistrict != 'All' &&
          filterState.selectedUpazila != null && 
          filterState.selectedUpazila != 'All') {
        final districtUid = filterNotifier.getDistrictUid(filterState.selectedDistrict!);
        final upazilaUid = filterNotifier.getUpazilaUid(filterState.selectedUpazila!);
        final unionUid = filterNotifier.getUnionUid(filterState.selectedUnion!);
        
        if (districtUid != null && upazilaUid != null && unionUid != null) {
          final concatenatedPath = '$districtUid/$upazilaUid/$unionUid';
          logg.i('Session Plan: Built concatenated union path: $concatenatedPath');
          return concatenatedPath;
        } else {
          logg.w('Session Plan: Could not build concatenated union path - missing UIDs');
          logg.w('  districtUid: $districtUid, upazilaUid: $upazilaUid, unionUid: $unionUid');
          // Fallback to union UID only
          return unionUid;
        }
      } else {
        // Fallback to union UID only if district/upazila not selected
        final unionUid = filterNotifier.getUnionUid(filterState.selectedUnion!);
        logg.w('Session Plan: Using union UID only (district/upazila not selected): $unionUid');
        return unionUid;
      }
    }
    
    // ✅ FIX: For ward level, build concatenated path: district/upazila/union/ward
    if (filterState.selectedWard != null && filterState.selectedWard != 'All') {
      final wardUid = filterNotifier.getWardUid(filterState.selectedWard!);
      
      // Ward requires union, upazila, and district to be selected for full concatenated path
      if (filterState.selectedUnion != null && 
          filterState.selectedUnion != 'All' &&
          filterState.selectedUpazila != null && 
          filterState.selectedUpazila != 'All' &&
          filterState.selectedDistrict != null && 
          filterState.selectedDistrict != 'All') {
        final districtUid = filterNotifier.getDistrictUid(filterState.selectedDistrict!);
        final upazilaUid = filterNotifier.getUpazilaUid(filterState.selectedUpazila!);
        final unionUid = filterNotifier.getUnionUid(filterState.selectedUnion!);
        
        if (districtUid != null && 
            upazilaUid != null && 
            unionUid != null && 
            wardUid != null) {
          final concatenatedPath = '$districtUid/$upazilaUid/$unionUid/$wardUid';
          logg.i('Session Plan: Built concatenated ward path: $concatenatedPath');
          return concatenatedPath;
        } else {
          logg.w('Session Plan: Could not build concatenated ward path - missing UIDs');
          logg.w('  districtUid: $districtUid, upazilaUid: $upazilaUid, unionUid: $unionUid, wardUid: $wardUid');
        }
      }
      
      // Fallback to ward UID only if we don't have full context
      if (wardUid != null) {
        logg.w('Session Plan: Using ward UID only (incomplete hierarchy context): $wardUid');
        return wardUid;
      }
    }
    
    // ✅ FIX: For upazila level, build concatenated path: district/upazila
    if (filterState.selectedUpazila != null && filterState.selectedUpazila != 'All') {
      // Upazila requires district to be selected (hierarchical dependency)
      if (filterState.selectedDistrict != null && 
          filterState.selectedDistrict != 'All') {
        logg.i('Session Plan: Building upazila path - District: ${filterState.selectedDistrict}, Upazila: ${filterState.selectedUpazila}');
        logg.i('Session Plan: Upazilas list size: ${filterState.upazilas.length}');
        
        final districtUid = filterNotifier.getDistrictUid(filterState.selectedDistrict!);
        final upazilaUid = filterNotifier.getUpazilaUid(filterState.selectedUpazila!);
        
        logg.i('Session Plan: UID lookup results - districtUid: $districtUid, upazilaUid: $upazilaUid');
        
        if (districtUid == null || upazilaUid == null) {
          logg.e('Session Plan: Could not build concatenated upazila path - missing UIDs');
          logg.e('  District: ${filterState.selectedDistrict}, districtUid: $districtUid');
          logg.e('  Upazila: ${filterState.selectedUpazila}, upazilaUid: $upazilaUid');
          if (filterState.upazilas.isNotEmpty) {
            logg.e('  Available upazilas: ${filterState.upazilas.map((u) => '${u.name} (${u.uid})').toList()}');
          } else {
            logg.e('  Upazilas list is EMPTY - this might be the issue!');
          }
        }
        
        if (districtUid != null && upazilaUid != null) {
          final concatenatedPath = '$districtUid/$upazilaUid';
          logg.i('Session Plan: ✅ Built concatenated upazila path: $concatenatedPath');
          return concatenatedPath;
        } else {
          // Fallback to upazila UID only
          logg.w('Session Plan: Falling back to upazila UID only: $upazilaUid');
          return upazilaUid;
        }
      } else {
        // Fallback to upazila UID only if district not selected
        final upazilaUid = filterNotifier.getUpazilaUid(filterState.selectedUpazila!);
        logg.w('Session Plan: Using upazila UID only (district not selected): $upazilaUid');
        return upazilaUid;
      }
    }
    
    // For district level, use district UID (single UID is correct)
    if (filterState.selectedDistrict != null && filterState.selectedDistrict != 'All') {
      return filterNotifier.getDistrictUid(filterState.selectedDistrict!);
    }
    
    // For division level, use division UID (single UID is correct)
    if (filterState.selectedDivision != 'All') {
      return filterNotifier.getDivisionUid(filterState.selectedDivision);
    }
    
    // For city corporation hierarchy
    if (filterState.selectedAreaType == AreaType.cityCorporation) {
      // For zone level, build concatenated path: ccUid/zoneUid
      if (filterState.selectedZone != null && filterState.selectedZone != 'All') {
        final ccUid = filterNotifier.getCityCorporationUid(filterState.selectedCityCorporation ?? '');
        final zoneUid = filterNotifier.getZoneUid(filterState.selectedZone!);
        
        if (ccUid != null && zoneUid != null) {
          final concatenatedPath = '$ccUid/$zoneUid';
          logg.i('Session Plan: Built concatenated zone path: $concatenatedPath');
          return concatenatedPath;
        }
      }
      
      // For city corporation level, use CC UID (single UID is correct)
      if (filterState.selectedCityCorporation != null && 
          filterState.selectedCityCorporation != 'All') {
        return filterNotifier.getCityCorporationUid(filterState.selectedCityCorporation!);
      }
    }
    
    return null;
  }
}
