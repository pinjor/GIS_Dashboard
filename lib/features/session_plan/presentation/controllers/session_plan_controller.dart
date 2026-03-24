import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:gis_dashboard/core/common/constants/api_constants.dart';
import 'package:gis_dashboard/core/service/data_service.dart';
import 'package:gis_dashboard/core/utils/utils.dart';
import 'package:gis_dashboard/features/map/domain/area_coords_geo_json_response.dart';
import 'package:gis_dashboard/features/session_plan/domain/session_plan_coords_response.dart';
import 'package:gis_dashboard/features/filter/presentation/controllers/filter_controller.dart';
import 'package:gis_dashboard/features/filter/domain/filter_state.dart';
import 'package:gis_dashboard/features/filter/domain/area_response_model.dart';
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
    // ✅ CRITICAL FIX: Store dates in state IMMEDIATELY if provided, BEFORE any async operations
    // This ensures dates are available for subsequent calls (e.g., from filter state listener)
    if (startDate != null && startDate.isNotEmpty && endDate != null && endDate.isNotEmpty) {
      logg.i("Session Plan: 🔍 Storing dates in state IMMEDIATELY - startDate: $startDate, endDate: $endDate");
      state = state.copyWith(
        startDate: startDate,
        endDate: endDate,
        isLoading: true,
        clearError: true,
      );
      logg.i("Session Plan: ✅ Dates stored in state before async operations");
    } else {
      state = state.copyWith(isLoading: true, clearError: true);
    }
    
    try {
      logg.i("Loading session plan data with filter...");
      
      // ✅ CRITICAL FIX: Log what dates we received as parameters
      logg.i("Session Plan: 🔍 Received dates as parameters - startDate: ${startDate ?? 'null'}, endDate: ${endDate ?? 'null'}");
      logg.i("Session Plan: 🔍 Current state dates - startDate: ${state.startDate ?? 'null'}, endDate: ${state.endDate ?? 'null'}");
      
      // ✅ CRITICAL FIX: If dates are not provided, use dates from state (preserve user's date filter)
      // This ensures that when loadDataWithFilter() is called after map drilldown,
      // it uses the dates that were previously set by the user, not today's date
      if (startDate == null || startDate.isEmpty) {
        startDate = state.startDate;
        if (startDate != null && startDate.isNotEmpty) {
          logg.i("Session Plan: ✅ Using startDate from state: $startDate");
        } else {
          logg.w("Session Plan: ⚠️ No startDate in state, will default to today");
        }
      } else {
        logg.i("Session Plan: ✅ Using startDate from parameters: $startDate");
      }
      
      if (endDate == null || endDate.isEmpty) {
        endDate = state.endDate;
        if (endDate != null && endDate.isNotEmpty) {
          logg.i("Session Plan: ✅ Using endDate from state: $endDate");
        } else {
          logg.w("Session Plan: ⚠️ No endDate in state, will default to today");
        }
      } else {
        logg.i("Session Plan: ✅ Using endDate from parameters: $endDate");
      }

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
      
      // ✅ FIX: Wait for unions to be loaded if union is selected but list is empty
      // This ensures union UID can be retrieved for building the area path
      if (filterState.selectedUnion != null && 
          filterState.selectedUnion != 'All' &&
          filterState.unions.isEmpty &&
          filterState.selectedUpazila != null &&
          filterState.selectedUpazila != 'All') {
        logg.w('Session Plan: Unions list is empty, waiting for them to load...');
        int retries = 0;
        const maxRetries = 30; // 3 seconds max wait
        
        while (retries < maxRetries) {
          await Future.delayed(const Duration(milliseconds: 100));
          final currentFilterState = _ref.read(filterControllerProvider);
          if (currentFilterState.unions.isNotEmpty) {
            logg.i('Session Plan: Unions loaded (${currentFilterState.unions.length} items)');
            break;
          }
          retries++;
        }
        
        if (_ref.read(filterControllerProvider).unions.isEmpty) {
          logg.e('Session Plan: Unions still not loaded after waiting - proceeding anyway');
        }
      }

      // ✅ FIX: Wait for wards to be loaded if ward is selected but list is empty
      // This prevents ward filter from silently falling back to union-level area UID.
      if (filterState.selectedWard != null &&
          filterState.selectedWard != 'All' &&
          filterState.wards.isEmpty &&
          filterState.selectedUnion != null &&
          filterState.selectedUnion != 'All') {
        logg.w('Session Plan: Wards list is empty, waiting for them to load...');
        int retries = 0;
        const maxRetries = 40; // 4 seconds max wait

        while (retries < maxRetries) {
          await Future.delayed(const Duration(milliseconds: 100));
          final currentFilterState = _ref.read(filterControllerProvider);
          if (currentFilterState.wards.isNotEmpty) {
            logg.i('Session Plan: Wards loaded (${currentFilterState.wards.length} items)');
            break;
          }
          retries++;
        }

        if (_ref.read(filterControllerProvider).wards.isEmpty) {
          logg.e('Session Plan: Wards still not loaded after waiting - ward filter may fallback');
        }
      }
      
      // ✅ FIX: Build correct area UID based on filter hierarchy
      // For union/ward levels, we need concatenated paths like district/upazila/union or district/upazila/union/ward
      String? effectiveAreaUid = areaUid;
      
      logg.i("Session Plan: 🔍🔍🔍 Building area UID for session plan API");
      logg.i("Session Plan: 🔍 Filter state - Division: ${filterState.selectedDivision}, District: ${filterState.selectedDistrict}, Upazila: ${filterState.selectedUpazila}, Union: ${filterState.selectedUnion}");
      logg.i("Session Plan: 🔍 Upazilas list size: ${filterState.upazilas.length}, Districts list size: ${filterState.districts.length}");
      
      if (effectiveAreaUid == null) {
        // Build area UID based on filter state (check from deepest to shallowest)
        logg.i("Session Plan: 🔍 Building area UID from filter state...");
        effectiveAreaUid = await _buildAreaUidForSessionPlan(filterState, filterNotifier);
        logg.i("Session Plan: 🔍 Built area UID: ${effectiveAreaUid ?? 'null'}");
        
        // ✅ CRITICAL FIX: If we couldn't build area UID, try fallback strategies
        if (effectiveAreaUid == null || effectiveAreaUid.isEmpty) {
          logg.w("Session Plan: ⚠️ Could not build area UID from filter state, trying fallback strategies...");
          
          // Strategy 1: Try map controller's focalAreaUid
          effectiveAreaUid = mapNotifier.focalAreaUid;
          if (effectiveAreaUid != null && effectiveAreaUid.isNotEmpty) {
            logg.i("Session Plan: ✅ Using map controller focalAreaUid: $effectiveAreaUid");
          } else {
            // Strategy 2: Try to use district UID as fallback if district is selected
            if (filterState.selectedDistrict != null && filterState.selectedDistrict != 'All') {
              final districtUid = filterNotifier.getDistrictUid(filterState.selectedDistrict!);
              if (districtUid != null && districtUid.isNotEmpty) {
                logg.w("Session Plan: ⚠️ Using district UID as fallback: $districtUid");
                effectiveAreaUid = districtUid;
              }
            }
            
            // Strategy 3: If still null, use division UID as last resort
            if ((effectiveAreaUid == null || effectiveAreaUid.isEmpty) && 
                filterState.selectedDivision != 'All') {
              final divisionUid = filterNotifier.getDivisionUid(filterState.selectedDivision);
              if (divisionUid != null && divisionUid.isNotEmpty) {
                logg.w("Session Plan: ⚠️ Using division UID as last resort: $divisionUid");
                effectiveAreaUid = divisionUid;
              }
            }
          }
        }
      } else {
        logg.i("Session Plan: 🔍 Using provided areaUid parameter: $effectiveAreaUid");
      }
      
      // ✅ CRITICAL FIX: Validate area parameter before using it
      // Never use 'undefined' - it will cause API to return 0 results
      String areaParam;
      if (effectiveAreaUid == null || effectiveAreaUid.isEmpty) {
        logg.e("Session Plan: ❌❌❌ CRITICAL ERROR - area UID is null, empty, or undefined!");
        logg.e("Session Plan: This will cause API to return 0 results");
        logg.e("Session Plan: Filter hierarchy - Division: ${filterState.selectedDivision}, District: ${filterState.selectedDistrict}, Upazila: ${filterState.selectedUpazila}, Union: ${filterState.selectedUnion}");
        logg.e("Session Plan: Upazilas list: ${filterState.upazilas.map((u) => '${u.name} (${u.uid})').toList()}");
        logg.e("Session Plan: Districts list: ${filterState.districts.map((d) => '${d.name} (${d.uid})').toList()}");
        
        // ✅ FIX: Don't use 'undefined' - omit area parameter or use empty string
        // Some APIs might accept empty area parameter for country-level data
        // But for session plans, we need a valid area, so we'll log an error and proceed
        // The API will return 0 results, but at least we won't crash
        areaParam = ''; // Empty string instead of 'undefined'
        logg.e("Session Plan: ⚠️ Using empty area parameter - API may return 0 results");
      } else {
        areaParam = effectiveAreaUid;
        logg.i("Session Plan: ✅✅✅ Area UID is valid: $effectiveAreaUid");
      }
      
      logg.i("Session Plan: 🔍🔍🔍 Final area parameter: $areaParam");
      logg.i("Session Plan: Filter state - District: ${filterState.selectedDistrict}, Upazila: ${filterState.selectedUpazila}, Union: ${filterState.selectedUnion}");

      // ✅ FIX: Construct URL based on parameters
      // Only include area parameter if it's not empty
      String sessionPlanUrl = ApiConstants.sessionPlans;
      if (areaParam.isNotEmpty) {
        sessionPlanUrl += '?area=$areaParam';
      } else {
        // If area parameter is empty, start with ? for date parameters
        sessionPlanUrl += '?';
      }
      
      // ✅ FIX: Always include date parameters (even if empty) to ensure proper filtering
      // Format: YYYY-MM-DD (e.g., 2025-12-01)
      // ⚠️ CRITICAL: If dates are null or empty, avoid single-day default.
      // Use current month range to reduce false "0 sessions" responses.
      // Note: startDate and endDate have already been updated from state if they were null
      String finalStartDate;
      String finalEndDate;
      
      if (startDate != null && startDate.isNotEmpty) {
        finalStartDate = startDate;
      } else {
        final now = DateTime.now();
        final monthStart = DateTime(now.year, now.month, 1);
        finalStartDate = DateFormat('yyyy-MM-dd').format(monthStart);
        logg.w("Session Plan: ⚠️ No start_date provided (not in state either), using month start: $finalStartDate");
      }
      
      if (endDate != null && endDate.isNotEmpty) {
        finalEndDate = endDate;
      } else {
        final now = DateTime.now();
        final monthEnd = DateTime(now.year, now.month + 1, 0);
        finalEndDate = DateFormat('yyyy-MM-dd').format(monthEnd);
        logg.w("Session Plan: ⚠️ No end_date provided (not in state either), using month end: $finalEndDate");
      }
      
      // ✅ FIX: Add date parameters (use & if area param exists, otherwise these are first params)
      if (areaParam.isNotEmpty) {
        sessionPlanUrl += '&start_date=$finalStartDate';
        sessionPlanUrl += '&end_date=$finalEndDate';
      } else {
        sessionPlanUrl += 'start_date=$finalStartDate';
        sessionPlanUrl += '&end_date=$finalEndDate';
      }
      logg.i("Session Plan: 🔍 Final date parameters - start_date: $finalStartDate, end_date: $finalEndDate");

      // ✅ FIX: Use safer limit for unfiltered country-level requests to reduce timeout risks.
      final limit = areaParam.isEmpty ? 10000 : 50000;
      sessionPlanUrl += '&limit=$limit';
      logg.i("Session Plan: Requesting up to $limit features");

      // ✅ CRITICAL: Log the FULL API URL for debugging
      logg.i("Session Plan: 🔍🔍🔍 FULL API URL: $sessionPlanUrl");
      logg.i("Session Plan: 🔍 Area parameter: $areaParam");
      logg.i("Session Plan: 🔍 Start date: $finalStartDate, End date: $finalEndDate");
      logg.i("Session Plan: 🔍 Filter state - Division: ${filterState.selectedDivision}, District: ${filterState.selectedDistrict}, Upazila: ${filterState.selectedUpazila}, Union: ${filterState.selectedUnion}");

      // ✅ OPTIMIZATION 1: Check if area changed - if not, reuse existing GeoJSON
      final previousAreaUid = await _getCurrentAreaUidFromState();
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
          final geoJsonAreaUid = await _buildAreaUidForSessionPlan(filterState, filterNotifier);
          
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
      logg.i("Session Plan: 🔍🔍🔍 About to call session plan API");
      logg.i("Session Plan: Fetching session plan data (forceRefresh: $areaChanged)");
      logg.i("Session Plan: 🔍🔍🔍 FULL API URL: $sessionPlanUrl");
      logg.i("Session Plan: 🔍 Area parameter: $areaParam");
      logg.i("Session Plan: 🔍 Start date: $finalStartDate, End date: $finalEndDate");
      
      var sessionPlanCoordsData = await _dataService.getSessionPlanCoords(
        urlPath: sessionPlanUrl,
        forceRefresh: areaChanged, // ✅ OPTIMIZATION 3: Only force refresh if area changed
      );
      logg.i("Session Plan: ✅✅✅ API call completed - received data");
      logg.i("Session Plan: ✅ Features count: ${sessionPlanCoordsData.features?.length ?? 0}");
      logg.i("Session Plan: ✅ Session count: ${sessionPlanCoordsData.sessionCount ?? 'null'}");

      // Fallback for division-level session plan fetch if primary area parameter yields no data.
      final isDivisionOnlySelection =
          filterState.selectedDivision != 'All' &&
          (filterState.selectedDistrict == null || filterState.selectedDistrict == 'All') &&
          (filterState.selectedUpazila == null || filterState.selectedUpazila == 'All') &&
          (filterState.selectedUnion == null || filterState.selectedUnion == 'All') &&
          (filterState.selectedWard == null || filterState.selectedWard == 'All') &&
          (filterState.selectedSubblock == null || filterState.selectedSubblock == 'All') &&
          (filterState.selectedCityCorporation == null || filterState.selectedCityCorporation == 'All') &&
          (filterState.selectedZone == null || filterState.selectedZone == 'All');

      if ((sessionPlanCoordsData.features == null || sessionPlanCoordsData.features!.isEmpty) &&
          isDivisionOnlySelection) {
        final divisionSlug = ApiConstants.divisionNameToSlug(filterState.selectedDivision);
        final fallbackCandidates = <String>[
          if (mapNotifier.focalAreaUid != null && mapNotifier.focalAreaUid!.isNotEmpty)
            mapNotifier.focalAreaUid!,
          divisionSlug,
        ].where((c) => c.isNotEmpty && c != areaParam).toList();

        for (final candidateArea in fallbackCandidates) {
          final fallbackUrl =
              '${ApiConstants.sessionPlans}?area=$candidateArea&start_date=$finalStartDate&end_date=$finalEndDate&limit=50000';
          logg.w('Session Plan: ⚠️ Division fallback attempt with area=$candidateArea');
          final fallbackData = await _dataService.getSessionPlanCoords(
            urlPath: fallbackUrl,
            forceRefresh: true,
          );
          final fallbackCount = fallbackData.features?.length ?? 0;
          logg.i('Session Plan: Division fallback features count: $fallbackCount');
          if (fallbackCount > 0) {
            sessionPlanCoordsData = fallbackData;
            logg.i('Session Plan: ✅ Division fallback succeeded with area=$candidateArea');
            break;
          }
        }
      }

      logg.i(
        "Session Plan: ✅ Loaded session plan data - features: ${sessionPlanCoordsData.features?.length ?? 0}, sessionCount: ${sessionPlanCoordsData.sessionCount ?? 'null'}",
      );
      
      // ✅ CRITICAL DEBUG: Verify sessionCount is correctly set
      if (sessionPlanCoordsData.sessionCount != null && sessionPlanCoordsData.sessionCount! > 0) {
        logg.i("Session Plan: ✅✅✅ sessionCount is VALID: ${sessionPlanCoordsData.sessionCount} (this should be displayed in filter dialog)");
        logg.i("Session Plan: ✅✅✅ API returned ${sessionPlanCoordsData.sessionCount} sessions for area: $areaParam, dates: $finalStartDate to $finalEndDate");
      } else {
        logg.e("Session Plan: ❌❌❌ sessionCount IS NULL or 0 - this is why the count shows 0!");
        logg.e("Session Plan: ❌ sessionCount value: ${sessionPlanCoordsData.sessionCount}");
        logg.e("Session Plan: ❌ features count: ${sessionPlanCoordsData.features?.length ?? 0}");
        logg.e("Session Plan: ❌ API URL was: $sessionPlanUrl");
        logg.e("Session Plan: ❌ Area parameter: $areaParam");
        logg.e("Session Plan: ❌ Date range: $finalStartDate to $finalEndDate");
        logg.e("Session Plan: ❌ Filter - Division: ${filterState.selectedDivision}, District: ${filterState.selectedDistrict}, Upazila: ${filterState.selectedUpazila}");
        logg.e("Session Plan: ❌ If web app shows 286 but mobile shows 0, check if area parameter format is correct");
      }
      
      // ✅ DEBUG: Log the raw JSON to verify session_count is in the response
      try {
        final rawJson = sessionPlanCoordsData.toJson();
        final sessionCountFromJson = rawJson['session_count'];
        logg.i("Session Plan: 🔍 Raw JSON - session_count field: $sessionCountFromJson (type: ${sessionCountFromJson.runtimeType})");
        logg.i("Session Plan: 🔍 Raw JSON - type: ${rawJson['type']}, features count: ${(rawJson['features'] as List?)?.length ?? 0}");
        
        // ✅ CRITICAL: If session_count is in JSON but not parsed, there's a parsing issue
        if (sessionCountFromJson != null && sessionPlanCoordsData.sessionCount == null) {
          logg.e("Session Plan: ❌❌❌ CRITICAL: session_count exists in JSON ($sessionCountFromJson) but NOT parsed into sessionCount!");
          logg.e("Session Plan: ❌ This indicates a JSON parsing issue in SessionPlanCoordsResponse model!");
        }
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

      // ✅ FIX: Store dates in state for persistence (use final dates)
      // finalStartDate and finalEndDate are guaranteed to be non-null at this point
      final stateStartDate = finalStartDate;
      final stateEndDate = finalEndDate;
      
      state = state.copyWith(
        areaCoordsGeoJsonData: areaCoordsGeoJsonData,
        sessionPlanCoordsData: sessionPlanCoordsData,
        startDate: stateStartDate, // Store dates in state for persistence
        endDate: stateEndDate,
        isLoading: false,
        clearError: true,
      );
      
      // ✅ DEBUG: Log date filter state
      logg.i("Session Plan: ✅ Date filter applied - startDate: $stateStartDate, endDate: $stateEndDate");
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
  Future<String?> _getCurrentAreaUidFromState() async {
    // Try to determine area UID from current state
    // This is used to check if area changed (to skip GeoJSON reload)
    final filterState = _ref.read(filterControllerProvider);
    final filterNotifier = _ref.read(filterControllerProvider.notifier);
    
    // Use the same logic as _buildAreaUidForSessionPlan to get current area UID
    return await _buildAreaUidForSessionPlan(filterState, filterNotifier);
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
  /// Session plan API expects the deepest selected area UID.
  /// Prefer single UID (ward/union/upazila) over concatenated hierarchy paths.
  Future<String?> _buildAreaUidForSessionPlan(
    FilterState filterState,
    FilterControllerNotifier filterNotifier,
  ) async {
    // Use a local variable that can be updated if filter state changes during async operations
    FilterState currentFilterState = filterState;
    // Check from deepest to shallowest level (matching map controller logic)
    // For ward level, use ward UID directly
    if (currentFilterState.selectedWard != null && currentFilterState.selectedWard != 'All') {
      String? wardUid = filterNotifier.getWardUid(currentFilterState.selectedWard!);

      // If ward UID is not immediately available, force-load wards from selected union and retry.
      if ((wardUid == null || wardUid.isEmpty) &&
          currentFilterState.selectedUnion != null &&
          currentFilterState.selectedUnion != 'All') {
        final unionUid = filterNotifier.getUnionUid(currentFilterState.selectedUnion!);
        if (unionUid != null && unionUid.isNotEmpty) {
          try {
            await filterNotifier.loadWardsByUnion(unionUid);
          } catch (_) {}
        }

        int retries = 0;
        const maxRetries = 30; // 3 seconds max wait
        while (retries < maxRetries && (wardUid == null || wardUid.isEmpty)) {
          await Future.delayed(const Duration(milliseconds: 100));
          wardUid = filterNotifier.getWardUid(currentFilterState.selectedWard!);
          if (wardUid != null && wardUid.isNotEmpty) {
            break;
          }
          retries++;
        }
      }

      if (wardUid != null && wardUid.isNotEmpty) {
        logg.i('Session Plan: Using ward UID: $wardUid');
        return wardUid;
      }
    }

    // For union level, use union UID directly
    if (currentFilterState.selectedUnion != null && currentFilterState.selectedUnion != 'All') {
      final unionUid = filterNotifier.getUnionUid(currentFilterState.selectedUnion!);
      if (unionUid != null && unionUid.isNotEmpty) {
        logg.i('Session Plan: Using union UID: $unionUid');
        return unionUid;
      }
    }
    
    // For upazila level, use upazila UID directly
    if (currentFilterState.selectedUpazila != null && currentFilterState.selectedUpazila != 'All') {
      logg.i('Session Plan: 🔍 Building upazila path - District: ${currentFilterState.selectedDistrict}, Upazila: ${currentFilterState.selectedUpazila}');
      logg.i('Session Plan: 🔍 Upazilas list size: ${currentFilterState.upazilas.length}');
      logg.i('Session Plan: 🔍 Districts list size: ${currentFilterState.districts.length}');
      
      // ✅ CRITICAL FIX: Wait for upazilas to be loaded if the list is empty
      // This ensures we can get the upazila UID and parentUid even if the filter listener fires before loading completes
      if (currentFilterState.upazilas.isEmpty && currentFilterState.selectedDistrict != null && currentFilterState.selectedDistrict != 'All') {
        logg.w('Session Plan: ⚠️ Upazilas list is empty, waiting for them to load...');
        // Trigger loading by calling updateDistrict (idempotent - won't reload if already set)
        // This ensures upazilas are being loaded if they haven't started yet
        filterNotifier.updateDistrict(currentFilterState.selectedDistrict!);
        
        // Wait for upazilas to load (with retry)
        int retries = 0;
        const maxRetries = 50; // 5 seconds max wait
        while (retries < maxRetries) {
          await Future.delayed(const Duration(milliseconds: 100));
          final updatedFilterState = _ref.read(filterControllerProvider);
          if (updatedFilterState.upazilas.isNotEmpty) {
            logg.i('Session Plan: ✅ Upazilas loaded (${updatedFilterState.upazilas.length} items)');
            // Update currentFilterState reference to use the updated state
            currentFilterState = updatedFilterState;
            break;
          }
          retries++;
        }
        
        if (currentFilterState.upazilas.isEmpty) {
          logg.e('Session Plan: ❌ Upazilas still not loaded after waiting - proceeding anyway');
        }
      }
      
      if (currentFilterState.selectedDistrict != null && 
          currentFilterState.selectedDistrict != 'All') {
        var upazilaUid = filterNotifier.getUpazilaUid(currentFilterState.selectedUpazila!);
        
        logg.i('Session Plan: 🔍 UID lookup result - upazilaUid: $upazilaUid');
        
        // If UID is null, wait for data to load and retry
        if (upazilaUid == null) {
          logg.w('Session Plan: ⚠️ Could not get upazila UID, waiting and retrying...');
          logg.w('  Upazila: ${filterState.selectedUpazila}, upazilaUid: $upazilaUid');
          logg.w('  Upazilas list size: ${filterState.upazilas.length}');
          
          // ✅ FIX: Wait for upazilas/districts to load and retry
          int retries = 0;
          const maxRetries = 50;
          while (retries < maxRetries && upazilaUid == null) {
            await Future.delayed(const Duration(milliseconds: 100));
            final updatedFilterState = _ref.read(filterControllerProvider);
            
            // Retry getting UID
            if (upazilaUid == null && updatedFilterState.upazilas.isNotEmpty) {
              final upazilaExists = updatedFilterState.upazilas.any(
                (u) => u.name?.trim() == currentFilterState.selectedUpazila!.trim() ||
                       u.name?.trim().toLowerCase() == currentFilterState.selectedUpazila!.trim().toLowerCase(),
              );
              if (upazilaExists) {
                upazilaUid = filterNotifier.getUpazilaUid(currentFilterState.selectedUpazila!);
                if (upazilaUid != null) {
                  logg.i('Session Plan: ✅ Got upazila UID after waiting: $upazilaUid');
                }
              }
            }
            
            if (upazilaUid != null) {
              logg.i('Session Plan: ✅ Retry successful - got upazila UID after waiting (retry $retries)');
              break;
            }
            retries++;
          }
          
          if (upazilaUid == null) {
            logg.e('Session Plan: ❌ Still missing upazila UID after waiting');
            final currentFilterState = _ref.read(filterControllerProvider);
            logg.e('  Current upazilas list size: ${currentFilterState.upazilas.length}');
            if (currentFilterState.upazilas.isNotEmpty) {
              logg.e('  Available upazilas: ${currentFilterState.upazilas.map((u) => '${u.name} (${u.uid})').toList()}');
            }
            // Don't return null - try fallback
          }
        }
        
        if (upazilaUid != null && upazilaUid.isNotEmpty) {
          logg.i('Session Plan: ✅ Using upazila UID: $upazilaUid');
          return upazilaUid;
        } else {
          // Fallback: use district UID if available
          final districtUid = filterNotifier.getDistrictUid(currentFilterState.selectedDistrict!);
          if (districtUid != null && districtUid.isNotEmpty) {
            logg.w('Session Plan: ⚠️ Falling back to district UID (upazila UID missing): $districtUid');
            return districtUid;
          }
          
          // Final fallback: return null (handled by caller)
          logg.e('Session Plan: ❌❌❌ CRITICAL: Cannot build upazila area UID');
          logg.e('Session Plan: District: ${currentFilterState.selectedDistrict}');
          logg.e('Session Plan: Upazila: ${currentFilterState.selectedUpazila}, upazilaUid: $upazilaUid');
          logg.e('Session Plan: Upazilas list size: ${currentFilterState.upazilas.length}');
          if (currentFilterState.upazilas.isNotEmpty) {
            logg.e('Session Plan: Available upazilas: ${currentFilterState.upazilas.map((u) => '${u.name} (${u.uid})').toList()}');
          }
          return null;
        }
      } else {
        // ✅ FIX: District is null or "All" - try to find district from upazilla's parentUid
        // When upazillas are loaded, each upazilla has a parentUid that points to its district
        logg.w('Session Plan: ⚠️ District is null or "All" but upazilla is selected');
        logg.w('Session Plan: Attempting to find district from upazilla parentUid...');
        
        // ✅ CRITICAL: Wait for upazilas to load if list is empty
        if (currentFilterState.upazilas.isEmpty) {
          logg.w('Session Plan: Upazilas list is empty, waiting for them to load...');
          int retries = 0;
          const maxRetries = 50; // 5 seconds max wait
          while (retries < maxRetries) {
            await Future.delayed(const Duration(milliseconds: 100));
            final updatedFilterState = _ref.read(filterControllerProvider);
            if (updatedFilterState.upazilas.isNotEmpty) {
              currentFilterState = updatedFilterState;
              break;
            }
            retries++;
          }
        }
        
        final upazilaUid = filterNotifier.getUpazilaUid(currentFilterState.selectedUpazila!);
        
        // Try to find the upazilla in the list and get its parentUid (which should be the district UID)
        String? foundDistrictUid;
        if (currentFilterState.upazilas.isNotEmpty && currentFilterState.selectedUpazila != null) {
          final upazila = currentFilterState.upazilas.firstWhere(
            (u) => u.name?.trim() == currentFilterState.selectedUpazila!.trim() ||
                   u.name?.trim().toLowerCase() == currentFilterState.selectedUpazila!.trim().toLowerCase(),
            orElse: () => const AreaResponseModel(),
          );
          
          if (upazila.parentUid != null && upazila.parentUid!.isNotEmpty) {
            foundDistrictUid = upazila.parentUid;
            logg.i('Session Plan: ✅ Found district UID from upazilla parentUid: $foundDistrictUid');
          } else {
            logg.w('Session Plan: ⚠️ Upazilla found but parentUid is null or empty');
          }
        }
        
        if (upazilaUid != null && foundDistrictUid != null) {
          // Build concatenated path with found district
          final concatenatedPath = '${foundDistrictUid.toLowerCase()}/${upazilaUid.toLowerCase()}';
          logg.i('Session Plan: ✅✅✅ Built concatenated path with district from parentUid: $concatenatedPath');
          return concatenatedPath;
        } else if (upazilaUid != null) {
          // Fallback to upazila UID only if we can't find district
          logg.w('Session Plan: ⚠️ Using upazila UID only (district not found from parentUid): $upazilaUid');
          return upazilaUid;
        } else {
          // Final fallback: try to use district UID if available
          if (currentFilterState.selectedDistrict != null && currentFilterState.selectedDistrict != 'All') {
            final districtUid = filterNotifier.getDistrictUid(currentFilterState.selectedDistrict!);
            logg.w('Session Plan: ⚠️ Upazila UID not found, falling back to district UID: $districtUid');
            return districtUid;
          }
          logg.e('Session Plan: ❌ Cannot build area UID - upazila UID is null and no district selected');
          return null;
        }
      }
    }
    
    // For district level, use district UID (single UID is correct)
    if (currentFilterState.selectedDistrict != null && currentFilterState.selectedDistrict != 'All') {
      return filterNotifier.getDistrictUid(currentFilterState.selectedDistrict!);
    }
    
    // For division level, use division UID (single UID is correct)
    if (currentFilterState.selectedDivision != 'All') {
      return filterNotifier.getDivisionUid(currentFilterState.selectedDivision);
    }
    
    // For city corporation hierarchy
    if (currentFilterState.selectedAreaType == AreaType.cityCorporation) {
      // For zone level, build concatenated path: ccUid/zoneUid
      if (currentFilterState.selectedZone != null && currentFilterState.selectedZone != 'All') {
        final ccUid = filterNotifier.getCityCorporationUid(currentFilterState.selectedCityCorporation ?? '');
        final zoneUid = filterNotifier.getZoneUid(currentFilterState.selectedZone!);
        
        if (ccUid != null && zoneUid != null) {
          final concatenatedPath = '$ccUid/$zoneUid';
          logg.i('Session Plan: Built concatenated zone path: $concatenatedPath');
          return concatenatedPath;
        }
      }
      
      // For city corporation level, use CC UID (single UID is correct)
      if (currentFilterState.selectedCityCorporation != null && 
          currentFilterState.selectedCityCorporation != 'All') {
        return filterNotifier.getCityCorporationUid(currentFilterState.selectedCityCorporation!);
      }
    }
    
    return null;
  }
}
