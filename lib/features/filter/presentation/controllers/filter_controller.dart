import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/utils/utils.dart';
import '../../domain/filter_state.dart';
import '../../domain/area_response_model.dart';
import '../../data/filter_repository.dart';
import '../../../map/utils/map_enums.dart';
import '../../../epi_center/presentation/controllers/epi_center_controller.dart';

/// Global filter state provider
final filterControllerProvider =
    StateNotifierProvider<FilterControllerNotifier, FilterState>((ref) {
      final repository = ref.watch(filterRepositoryProvider);
      final controller = FilterControllerNotifier(
        repository: repository,
        ref: ref,
      );

      ref.onDispose(() {
        controller.clearEpiDetailsContext();
      });

      return controller;
    });

class FilterControllerNotifier extends StateNotifier<FilterState> {
  final FilterRepository _repository;
  final Ref _ref;

  FilterControllerNotifier({
    required FilterRepository repository,
    required Ref ref,
  }) : _repository = repository,
       _ref = ref,
       super(const FilterState()) {
    // Initialize area data when provider is created
    _loadAllAreas();
  }

  /// Load all area data (divisions, districts, city corporations) at startup
  ///
  /// Uses individual error handling instead of Future.wait() to provide graceful degradation:
  /// - If one data type fails, others can still load successfully
  /// - Partial data is better than complete failure
  /// - Map sync requires divisions + districts (city corporations optional)
  Future<void> _loadAllAreas() async {
    state = state.copyWith(isLoadingAreas: true, clearAreasError: true);

    print('FilterProvider: Starting to load all areas...');

    bool hasAnySuccess = false;
    List<String> failedTypes = [];
    List<AreaResponseModel> divisions = [];
    List<AreaResponseModel> districts = [];
    List<AreaResponseModel> cityCorporations = [];

    // Load divisions independently
    try {
      divisions = await _repository.fetchAllDivisions();
      print('FilterProvider: ✅ Loaded ${divisions.length} divisions');
      hasAnySuccess = true;
    } catch (e) {
      print('FilterProvider: ❌ Failed to load divisions: $e');
      logg.e('Failed to load divisions: $e');
      failedTypes.add('divisions');
    }

    // Load districts independently
    try {
      districts = await _repository.fetchAllDistricts();
      print('FilterProvider: ✅ Loaded ${districts.length} districts');
      hasAnySuccess = true;
    } catch (e) {
      print('FilterProvider: ❌ Failed to load districts: $e');
      logg.e('Failed to load districts: $e');
      failedTypes.add('districts');
    }

    // Load city corporations independently
    try {
      cityCorporations = await _repository.fetchAllCityCorporations();
      print(
        'FilterProvider: ✅ Loaded ${cityCorporations.length} city corporations',
      );
      hasAnySuccess = true;
    } catch (e) {
      print('FilterProvider: ❌ Failed to load city corporations: $e');
      logg.e('Failed to load city corporations: $e');
      failedTypes.add('city corporations');
    }

    // Update state with whatever data was successfully loaded
    state = state.copyWith(
      divisions: divisions,
      districts: districts,
      cityCorporations: cityCorporations,
      filteredDistricts:
          districts, // Initially show all successfully loaded districts
      isLoadingAreas: false,
      areasError: hasAnySuccess
          ? (failedTypes.isEmpty
                ? null
                : 'Partial load: ${failedTypes.join(", ")} failed to load')
          : 'Failed to load all area data - please check your internet connection',
    );

    if (hasAnySuccess) {
      if (failedTypes.isEmpty) {
        print('FilterProvider: ✅ All areas loaded successfully');
      } else {
        print(
          'FilterProvider: ⚠️ Partial success - ${failedTypes.join(", ")} failed',
        );
        logg.w(
          'Partial area data loaded - ${failedTypes.join(", ")} unavailable',
        );
      }
    } else {
      print('FilterProvider: ❌ Complete failure - no area data loaded');
      logg.e('Critical: All area data types failed to load');
    }
  }

  /// Update vaccine selection
  void updateVaccine(String vaccine) {
    logg.i(
      '🧪 VACCINE UPDATE: Changing from "${state.selectedVaccine}" to "$vaccine"',
    );
    state = state.copyWith(selectedVaccine: vaccine);
    logg.i(
      '🧪 VACCINE UPDATE: State now has selectedVaccine = "${state.selectedVaccine}"',
    );
  }

  /// Update area type selection
  void updateAreaType(AreaType areaType) {
    state = state.copyWith(selectedAreaType: areaType);
  }

  /// Update division selection and filter districts accordingly
  void updateDivision(String divisionName) {
    print('FilterProvider: Updating division to: $divisionName');
    state = state.copyWith(selectedDivision: divisionName);

    // Filter districts based on selected division
    if (divisionName == 'All') {
      print('FilterProvider: Showing all ${state.districts.length} districts');
      state = state.copyWith(
        filteredDistricts: state.districts,
        clearDistrict: true, // Clear district selection when showing all
      );
    } else {
      // Find the division by name to get its UID
      final selectedDiv = state.divisions.firstWhere(
        (div) => div.name == divisionName,
        orElse: () => const AreaResponseModel(),
      );

      if (selectedDiv.uid != null) {
        print('FilterProvider: Found division with UID: ${selectedDiv.uid}');
        _loadDistrictsByDivision(selectedDiv.uid!);
      } else {
        print(
          'FilterProvider: Division not found or UID is null for: $divisionName',
        );
      }
    }
  }

  /// Load all districts for a specific division
  /// ! maybe not needed if local filtering works fine
  Future<void> _loadDistrictsByDivision(String divisionUid) async {
    // try {
    //   print('FilterProvider: Loading districts for division UID: $divisionUid');
    //   final filteredDistricts = await _repository.fetchDistrictsByDivisionId(
    //     divisionUid,
    //   );
    //   print(
    //     'FilterProvider: Loaded ${filteredDistricts.length} districts for division',
    //   );
    //   state = state.copyWith(
    //     filteredDistricts: filteredDistricts,
    //     selectedDistrict:
    //         null, // Clear district selection when division changes
    //   );
    // } catch (e) {
    //   print('FilterProvider: API call failed, filtering locally: $e');
    // If API call fails, filter from existing districts
    final filteredDistricts = state.districts
        .where((district) => district.parentUid == divisionUid)
        .toList();

    print(
      'FilterProvider: Local filtering found ${filteredDistricts.length} districts',
    );
    state = state.copyWith(
      filteredDistricts: filteredDistricts,
      clearDistrict: true,
    );
    // }
  }

  /// Update city corporation selection
  void updateCityCorporation(String? cityCorporation) {
    state = state.copyWith(selectedCityCorporation: cityCorporation);
  }

  /// Update district selection
  void updateDistrict(String? district) {
    state = state.copyWith(selectedDistrict: district);
  }

  /// Update year selection
  void updateYear(String year) {
    state = state.copyWith(selectedYear: year);
  }

  /// Update upazila selection and load unions
  void updateUpazila(String? upazila) {
    // Only clear child data if the selection actually changed
    if (state.selectedUpazila != upazila) {
      print(
        'FilterProvider: Upazila changed from ${state.selectedUpazila} to $upazila - clearing child data',
      );
      state = state.copyWith(
        selectedUpazila: upazila,
        clearUnion: true,
        clearWard: true,
        clearSubblock: true,
        unions: const [],
        wards: const [],
        subblocks: const [],
      );

      // Load new data only if changed and valid
      if (upazila != null && upazila != 'All') {
        final upazilaUid = _getUpazilaUid(upazila);
        if (upazilaUid != null) {
          _loadUnionsByUpazila(upazilaUid);
        }
      }
    } else {
      // Same value - just update the selection without clearing children
      print(
        'FilterProvider: Upazila unchanged ($upazila) - preserving child data',
      );
      state = state.copyWith(selectedUpazila: upazila);
    }
  }

  /// Update union selection and load wards
  void updateUnion(String? union) {
    // Only clear child data if the selection actually changed
    if (state.selectedUnion != union) {
      print(
        'FilterProvider: Union changed from ${state.selectedUnion} to $union - clearing child data',
      );
      state = state.copyWith(
        selectedUnion: union,
        clearWard: true,
        clearSubblock: true,
        wards: const [],
        subblocks: const [],
      );

      // Load new data only if changed and valid
      if (union != null && union != 'All') {
        final unionUid = _getUnionUid(union);
        if (unionUid != null) {
          _loadWardsByUnion(unionUid);
        }
      }
    } else {
      // Same value - just update the selection without clearing children
      print('FilterProvider: Union unchanged ($union) - preserving child data');
      state = state.copyWith(selectedUnion: union);
    }
  }

  /// Update ward selection and load subblocks
  void updateWard(String? ward) {
    // Only clear child data if the selection actually changed
    if (state.selectedWard != ward) {
      print(
        'FilterProvider: Ward changed from ${state.selectedWard} to $ward - clearing child data',
      );
      state = state.copyWith(
        selectedWard: ward,
        clearSubblock: true,
        subblocks: const [],
      );

      // Load new data only if changed and valid
      if (ward != null && ward != 'All') {
        final wardUid = _getWardUid(ward);
        if (wardUid != null) {
          _loadSubblocksByWard(wardUid);
        }
      }
    } else {
      // Same value - just update the selection without clearing children
      print('FilterProvider: Ward unchanged ($ward) - preserving child data');
      state = state.copyWith(selectedWard: ward);
    }
  }

  /// Update subblock selection
  void updateSubblock(String? subblock) {
    state = state.copyWith(selectedSubblock: subblock);
  }

  /// Reset specific filter fields based on area type
  /// Area type and vaccine selection are preserved
  void resetFilters() {
    print(
      'FilterProvider: Resetting filters based on area type: ${state.selectedAreaType}',
    );

    // Define default values based on area type
    const defaultYear = '2025';

    if (state.selectedAreaType == AreaType.district) {
      // For district area type: reset period, division, and district
      const defaultDivision = 'All';

      print('FilterProvider: Resetting district area type filters');
      state = state.copyWith(
        selectedDivision: defaultDivision,
        selectedYear: defaultYear,
        filteredDistricts: state.districts, // Reset to show all districts
        clearDistrict: true, // Explicitly clear district selection
        lastAppliedTimestamp: DateTime.now(), // Trigger map update
      );
    } else if (state.selectedAreaType == AreaType.cityCorporation) {
      // For city corporation area type: reset period and city corporation

      print('FilterProvider: Resetting city corporation area type filters');
      state = state.copyWith(
        selectedYear: defaultYear,
        clearCityCorporation:
            true, // Explicitly clear city corporation selection
        lastAppliedTimestamp: DateTime.now(), // Trigger map update
      );
    }

    print('FilterProvider: Filter reset completed');
  }

  /// Retry loading areas if there was an error
  Future<void> retryLoadAreas() async {
    await _loadAllAreas();
  }

  /// Get dropdown items for divisions (including 'All' option)
  List<String> get divisionDropdownItems {
    final divisionNames = state.divisions
        .map((div) => div.name ?? '')
        .where((name) => name.isNotEmpty)
        .toList();
    return ['All', ...divisionNames];
  }

  /// Get dropdown items for city corporations
  List<String> get cityCorporationDropdownItems {
    return state.cityCorporations
        .map((cc) => cc.name ?? '')
        .where((name) => name.isNotEmpty)
        .toList();
  }

  /// Get dropdown items for districts (filtered based on selected division)
  List<String> get districtDropdownItems {
    return state.filteredDistricts
        .map((district) => district.name ?? '')
        .where((name) => name.isNotEmpty)
        .toList();
  }

  /// Get city corporation UID by name for URL generation
  String? getCityCorporationUid(String ccName) {
    try {
      final cc = state.cityCorporations.firstWhere(
        (corporation) => corporation.name == ccName,
      );
      return cc.uid;
    } catch (e) {
      print('FilterProvider: City corporation UID not found for: $ccName');
      return null;
    }
  }

  /// Get district slug by district name from GeoJSON data

  /// Load unions by upazila UID
  Future<void> _loadUnionsByUpazila(String upazilaUid) async {
    try {
      final unions = await _repository.fetchAreasByParentUid(upazilaUid);
      state = state.copyWith(unions: unions);
      print(
        'FilterProvider: Loaded ${unions.length} unions for upazila: $upazilaUid',
      );
    } catch (e) {
      print('FilterProvider: Error loading unions: $e');
    }
  }

  /// Load wards by union UID
  Future<void> _loadWardsByUnion(String unionUid) async {
    try {
      final wards = await _repository.fetchAreasByParentUid(unionUid);
      state = state.copyWith(wards: wards);
      print(
        'FilterProvider: Loaded ${wards.length} wards for union: $unionUid',
      );
    } catch (e) {
      print('FilterProvider: Error loading wards: $e');
    }
  }

  /// Load subblocks by ward UID
  Future<void> _loadSubblocksByWard(String wardUid) async {
    try {
      final subblocks = await _repository.fetchAreasByParentUid(wardUid);
      state = state.copyWith(subblocks: subblocks);
      print(
        'FilterProvider: Loaded ${subblocks.length} subblocks for ward: $wardUid',
      );
    } catch (e) {
      print('FilterProvider: Error loading subblocks: $e');
    }
  }

  /// Get upazila UID by name
  String? _getUpazilaUid(String upazilaName) {
    final upazila = state.upazilas.firstWhere(
      (upazila) => upazila.name == upazilaName,
      orElse: () => const AreaResponseModel(),
    );
    return upazila.uid;
  }

  /// Get union UID by name
  String? _getUnionUid(String unionName) {
    final union = state.unions.firstWhere(
      (union) => union.name == unionName,
      orElse: () => const AreaResponseModel(),
    );
    return union.uid;
  }

  /// Get ward UID by name
  String? _getWardUid(String wardName) {
    final ward = state.wards.firstWhere(
      (ward) => ward.name == wardName,
      orElse: () => const AreaResponseModel(),
    );
    return ward.uid;
  }

  /// Get dropdown items for upazilas
  List<String> get upazilaDropdownItems {
    if (state.upazilas.isEmpty) return ['All'];
    return [
      'All',
      ...state.upazilas
          .map((u) => u.name ?? '')
          .where((name) => name.isNotEmpty),
    ];
  }

  /// Get dropdown items for unions
  List<String> get unionDropdownItems {
    if (state.unions.isEmpty) return ['All'];
    return [
      'All',
      ...state.unions.map((u) => u.name ?? '').where((name) => name.isNotEmpty),
    ];
  }

  /// Get dropdown items for wards
  List<String> get wardDropdownItems {
    if (state.wards.isEmpty) return ['All'];
    return [
      'All',
      ...state.wards.map((w) => w.name ?? '').where((name) => name.isNotEmpty),
    ];
  }

  /// Get dropdown items for subblocks
  List<String> get subblockDropdownItems {
    if (state.subblocks.isEmpty) return ['All'];
    return [
      'All',
      ...state.subblocks
          .map((s) => s.name ?? '')
          .where((name) => name.isNotEmpty),
    ];
  }

  /// Get subblock UID by name (for EPI data fetching)
  String? getSubblockUid(String subblockName) {
    final subblock = state.subblocks.firstWhere(
      (subblock) => subblock.name == subblockName,
      orElse: () => const AreaResponseModel(),
    );
    return subblock.uid;
  }

  /// Get upazila UID by name (for EPI data fetching)
  String? getUpazilaUid(String upazilaName) {
    final upazila = state.upazilas.firstWhere(
      (upazila) => upazila.name == upazilaName,
      orElse: () => const AreaResponseModel(),
    );
    return upazila.uid;
  }

  /// Get union UID by name (for EPI data fetching)
  String? getUnionUid(String unionName) {
    final union = state.unions.firstWhere(
      (union) => union.name == unionName,
      orElse: () => const AreaResponseModel(),
    );
    return union.uid;
  }

  /// Get ward UID by name (for EPI data fetching)
  String? getWardUid(String wardName) {
    final ward = state.wards.firstWhere(
      (ward) => ward.name == wardName,
      orElse: () => const AreaResponseModel(),
    );
    return ward.uid;
  }

  /// Initialize filter with EPI data context
  Future<void> initializeFromEpiData({
    required dynamic epiData,
    required bool isEpiDetailsContext,
    String? epiUid,
    String? ccUid,
  }) async {
    print('FilterProvider: Initializing from EPI data');
    logg.i('🔧 EPI Initialization Parameters:');
    logg.i('   epiUid: $epiUid');
    logg.i('   ccUid: $ccUid');
    logg.i('   isEpiDetailsContext: $isEpiDetailsContext');

    // ✅ CAPTURE ORIGINAL STATE: Only on first EPI initialization OR CC context change
    final bool isFirstEpiInitialization = !state.isEpiDetailsContext;
    logg.i('   isFirstEpiInitialization: $isFirstEpiInitialization');

    // Extract hierarchical data from EPI response
    final String? divisionName = epiData?.divisionName;
    final String? districtName = epiData?.districtName;
    final String? upazilaName = epiData?.upazilaName;
    final String? unionName = epiData?.unionName;
    final String? wardName = epiData?.wardName;
    final String? subblockName = epiData?.subBlockName;
    final String? subblockUid = epiData?.subblockId;
    final String? cityCorporationName = epiData?.cityCorporationName;

    // ✅ FIX: Determine area type based on ccUid parameter (more reliable than EPI data fields)
    final AreaType areaType = ccUid != null && ccUid.isNotEmpty
        ? AreaType.cityCorporation
        : AreaType.district;

    // Use ccUid as CC name if EPI data doesn't have cityCorporationName
    final String? effectiveCcName = cityCorporationName ?? ccUid;

    // ✅ FIX: Detect CC context change to reset filter state appropriately
    logg.i('🔍 CC Context Analysis:');
    logg.i('   Area Type: $areaType');
    logg.i('   Current Filter CC: ${state.selectedCityCorporation}');
    logg.i('   EPI cityCorporationName: $cityCorporationName');
    logg.i('   EPI ccUid: $ccUid');
    logg.i('   Effective CC Name: $effectiveCcName');
    logg.i('   Is EPI Details Context: ${state.isEpiDetailsContext}');

    // ✅ FIX: Always update CC context when we have valid CC data, especially when filter has different CC
    final bool shouldUpdateCcContext =
        areaType == AreaType.cityCorporation &&
        effectiveCcName != null &&
        (state.selectedCityCorporation == null ||
            state.selectedCityCorporation != effectiveCcName);

    if (shouldUpdateCcContext) {
      logg.i('🔄 CC Context Update Detected:');
      logg.i('   Current Filter CC: ${state.selectedCityCorporation}');
      logg.i('   New EPI Data CC: $effectiveCcName');
      logg.i('   → Updating filter state to match EPI data CC');
    } else if (areaType == AreaType.cityCorporation) {
      if (effectiveCcName != null) {
        logg.i('🔄 CC Context Status: Will maintain CC as $effectiveCcName');
      } else {
        logg.i('🔄 CC Context Status: No effective CC name found');
      }
    }

    // Convert to AreaResponseModel lists
    final List<AreaResponseModel> upazilas =
        (epiData?.upazilas as List<dynamic>?)
            ?.map((item) => AreaResponseModel(uid: item.uid, name: item.name))
            .toList() ??
        [];

    final List<AreaResponseModel> unions =
        (epiData?.unions as List<dynamic>?)
            ?.map((item) => AreaResponseModel(uid: item.uid, name: item.name))
            .toList() ??
        [];

    final List<AreaResponseModel> wards =
        (epiData?.wards as List<dynamic>?)
            ?.map((item) => AreaResponseModel(uid: item.uid, name: item.name))
            .toList() ??
        [];

    final List<AreaResponseModel> subblocks =
        (epiData?.subblocks as List<dynamic>?)
            ?.map((item) => AreaResponseModel(uid: item.uid, name: item.name))
            .toList() ??
        [];

    // ✅ PLAN A: Cache complete hierarchical lists and UIDs on first initialization
    String? cachedUpazilaUid;
    String? cachedUnionUid;
    String? cachedWardUid;
    String? cachedSubblockUid;

    // ✅ FIX: Cache hierarchical data on first initialization OR CC context update
    final bool shouldCacheHierarchicalData =
        isFirstEpiInitialization || shouldUpdateCcContext;

    if (shouldCacheHierarchicalData) {
      // Find UIDs for selected items from the hierarchical data
      cachedUpazilaUid = upazilas
          .firstWhere(
            (item) => item.name == upazilaName,
            orElse: () => AreaResponseModel(uid: '', name: ''),
          )
          .uid;

      cachedUnionUid = unions
          .firstWhere(
            (item) => item.name == unionName,
            orElse: () => AreaResponseModel(uid: '', name: ''),
          )
          .uid;

      cachedWardUid = wards
          .firstWhere(
            (item) => item.name == wardName,
            orElse: () => AreaResponseModel(uid: '', name: ''),
          )
          .uid;

      cachedSubblockUid = subblocks
          .firstWhere(
            (item) => item.name == subblockName,
            orElse: () => AreaResponseModel(uid: '', name: ''),
          )
          .uid;

      final String cacheReason = isFirstEpiInitialization
          ? 'first initialization'
          : 'CC context change';
      logg.i(
        '🗄️ PLAN A: Caching hierarchical state for instant reset ($cacheReason)',
      );
      logg.i(
        '   Caching ${upazilas.length} upazilas (selected UID: $cachedUpazilaUid)',
      );
      logg.i(
        '   Caching ${unions.length} unions (selected UID: $cachedUnionUid)',
      );
      logg.i('   Caching ${wards.length} wards (selected UID: $cachedWardUid)');
      logg.i(
        '   Caching ${subblocks.length} subblocks (selected UID: $cachedSubblockUid)',
      );
    }

    // Update state with EPI context data
    state = state.copyWith(
      isEpiDetailsContext: isEpiDetailsContext,
      initialSubblockUid: subblockUid,
      selectedAreaType: areaType,
      selectedDivision: divisionName ?? state.selectedDivision,
      selectedDistrict: districtName,
      selectedCityCorporation: areaType == AreaType.cityCorporation
          ? effectiveCcName
          : null,
      selectedUpazila: upazilaName,
      selectedUnion: unionName,
      selectedWard: wardName,
      selectedSubblock: subblockName,
      upazilas: upazilas,
      unions: unions,
      wards: wards,
      subblocks: subblocks,
      // ✅ CAPTURE ORIGINAL STATE: On first EPI initialization OR CC context change
      originalEpiUid: shouldCacheHierarchicalData
          ? epiUid
          : state.originalEpiUid,
      originalCcUid: shouldCacheHierarchicalData ? ccUid : state.originalCcUid,
      originalDivision: shouldCacheHierarchicalData
          ? (divisionName ?? state.selectedDivision)
          : state.originalDivision,
      originalDistrict: shouldCacheHierarchicalData
          ? districtName
          : state.originalDistrict,
      originalUpazila: shouldCacheHierarchicalData
          ? upazilaName
          : state.originalUpazila,
      originalUnion: shouldCacheHierarchicalData
          ? unionName
          : state.originalUnion,
      originalWard: shouldCacheHierarchicalData ? wardName : state.originalWard,
      originalSubblock: shouldCacheHierarchicalData
          ? subblockName
          : state.originalSubblock,
      originalYear: shouldCacheHierarchicalData
          ? state.selectedYear
          : state.originalYear,
      // ✅ PLAN A: Cache complete hierarchical data for instant reset
      originalUpazilasList: shouldCacheHierarchicalData
          ? [...upazilas]
          : state.originalUpazilasList,
      originalUnionsList: shouldCacheHierarchicalData
          ? [...unions]
          : state.originalUnionsList,
      originalWardsList: shouldCacheHierarchicalData
          ? [...wards]
          : state.originalWardsList,
      originalSubblocksList: shouldCacheHierarchicalData
          ? [...subblocks]
          : state.originalSubblocksList,
      originalUpazilaUid: shouldCacheHierarchicalData
          ? cachedUpazilaUid
          : state.originalUpazilaUid,
      originalUnionUid: shouldCacheHierarchicalData
          ? cachedUnionUid
          : state.originalUnionUid,
      originalWardUid: shouldCacheHierarchicalData
          ? cachedWardUid
          : state.originalWardUid,
      originalSubblockUid: shouldCacheHierarchicalData
          ? cachedSubblockUid
          : state.originalSubblockUid,
    );

    print('FilterProvider: EPI context initialized successfully');
    print('  Area Type: $areaType');
    print('  Division: $divisionName');
    print('  District: $districtName');
    print('  City Corporation: $effectiveCcName');
    print('  Upazila: $upazilaName');
    print('  Union: $unionName');
    print('  Ward: $wardName');
    print('  Subblock: $subblockName');

    // ✅ DEBUG: Log captured original values
    if (shouldCacheHierarchicalData) {
      final String logReason = isFirstEpiInitialization
          ? 'first initialization'
          : 'CC context change';
      logg.i('📸 PLAN A: Original State + Cached Data Captured ($logReason):');
      logg.i('   originalEpiUid: ${state.originalEpiUid}');
      logg.i('   originalCcUid: ${state.originalCcUid}');
      logg.i('   originalDivision: ${state.originalDivision}');
      logg.i('   originalDistrict: ${state.originalDistrict}');
      logg.i(
        '   originalUpazila: ${state.originalUpazila} (UID: ${state.originalUpazilaUid})',
      );
      logg.i(
        '   originalUnion: ${state.originalUnion} (UID: ${state.originalUnionUid})',
      );
      logg.i(
        '   originalWard: ${state.originalWard} (UID: ${state.originalWardUid})',
      );
      logg.i(
        '   originalSubblock: ${state.originalSubblock} (UID: ${state.originalSubblockUid})',
      );
      logg.i('   originalYear: ${state.originalYear}');
      logg.i(
        '   Cached Lists: ${state.originalUpazilasList?.length ?? 0} upazilas, '
        '${state.originalUnionsList?.length ?? 0} unions, '
        '${state.originalWardsList?.length ?? 0} wards, '
        '${state.originalSubblocksList?.length ?? 0} subblocks',
      );
    } else {
      logg.i(
        '🔄 Subsequent initialization - original state and cached data preserved',
      );
    }
  }

  /// ✅ PLAN A: Reset to original EPI state using cached hierarchical data
  /// This method instantly restores complete filter state + hierarchical lists for optimal UX
  void resetToOriginalEpiState() {
    final timestamp = DateTime.now();
    logg.i('🚀 PLAN A: Instant Reset to Original EPI State [$timestamp]');

    if (!state.isEpiDetailsContext) {
      // Non-EPI context: use normal reset
      logg.i('FilterProvider: Not in EPI context, using normal reset');
      resetFilters();
      return;
    }

    // Check if we have original state and cached data to restore
    if (state.originalEpiUid == null || state.originalUpazilasList == null) {
      logg.w(
        'FilterProvider: ⚠️ No original EPI state or cached data found, skipping reset',
      );
      return;
    }

    // Check if already at original state
    if (_isAlreadyAtOriginalState()) {
      logg.i('FilterProvider: ✅ Already at original state, no reload needed');
      return;
    }

    logg.i('🔄 BEFORE RESET:');
    logg.i('  Division: ${state.selectedDivision}');
    logg.i('  District: ${state.selectedDistrict}');
    logg.i('  Upazila: ${state.selectedUpazila}');
    logg.i('  Union: ${state.selectedUnion}');
    logg.i('  Ward: ${state.selectedWard}');
    logg.i('  Subblock: ${state.selectedSubblock}');
    logg.i(
      '  Lists: ${state.upazilas.length} upazilas, ${state.unions.length} unions, ${state.wards.length} wards, ${state.subblocks.length} subblocks',
    );

    // ✅ PLAN A: Atomic restoration using cached data
    logg.i(
      '⚡ Performing INSTANT restoration using cached hierarchical data...',
    );

    state = state.copyWith(
      // Restore original selections
      selectedDivision: state.originalDivision ?? 'All',
      selectedDistrict: state.originalDistrict,
      selectedUpazila: state.originalUpazila,
      selectedUnion: state.originalUnion,
      selectedWard: state.originalWard,
      selectedSubblock: state.originalSubblock,
      selectedYear: state.originalYear ?? state.selectedYear,

      // ✅ PLAN A: Instantly restore complete hierarchical lists from cache
      upazilas: [...(state.originalUpazilasList ?? [])],
      unions: [...(state.originalUnionsList ?? [])],
      wards: [...(state.originalWardsList ?? [])],
      subblocks: [...(state.originalSubblocksList ?? [])],

      // Trigger EPI reload by updating timestamp
      lastAppliedTimestamp: timestamp,
    );

    logg.i('✅ AFTER RESET (INSTANT):');
    logg.i('  Division: ${state.selectedDivision}');
    logg.i('  District: ${state.selectedDistrict}');
    logg.i('  Upazila: ${state.selectedUpazila}');
    logg.i('  Union: ${state.selectedUnion}');
    logg.i('  Ward: ${state.selectedWard}');
    logg.i('  Subblock: ${state.selectedSubblock}');
    logg.i(
      '  Restored Lists: ${state.upazilas.length} upazilas, ${state.unions.length} unions, ${state.wards.length} wards, ${state.subblocks.length} subblocks',
    );
    logg.i(
      '🎯 PLAN A: Instant reset completed! EPI screen will now reload with first subblock.',
    );
  }

  /// Check if current state matches original EPI state
  bool _isAlreadyAtOriginalState() {
    return state.selectedDivision == state.originalDivision &&
        state.selectedDistrict == state.originalDistrict &&
        state.selectedUpazila == state.originalUpazila &&
        state.selectedUnion == state.originalUnion &&
        state.selectedWard == state.originalWard &&
        state.selectedSubblock == state.originalSubblock &&
        state.selectedYear == state.originalYear;
  }

  /// Reset geographic filters to country view defaults
  /// Preserves area type, vaccine selection, and year
  /// This is used when navigating back to country level from drilldown
  void resetGeographicFiltersToCountryView() {
    print(
      'FilterProvider: Resetting geographic filters to country view defaults',
    );

    // Reset geographic selections to country view defaults
    const defaultDivision = 'All';

    print(
      'FilterProvider: Resetting to country view - clearing geographic selections',
    );
    state = state.copyWith(
      selectedDivision: defaultDivision,
      filteredDistricts: state.districts, // Reset to show all districts
      clearDistrict: true, // Clear district selection
      clearCityCorporation: true, // Clear city corporation selection
    );

    print('FilterProvider: Geographic filters reset to country view completed');
  }

  /// Clear EPI context when navigating away from EPI details screens
  /// This ensures map functionality returns to normal when EPI screens are closed
  void clearEpiDetailsContext() {
    if (!state.isEpiDetailsContext) {
      print('FilterProvider: EPI context already cleared');
      return;
    }

    logg.i('FilterProvider: 🧹 Clearing EPI details context...');
    // old state values
    logg.i('BEFORE: isEpiDetailsContext: ${state.isEpiDetailsContext}');
    logg.i('BEFORE: initialSubblockUid: ${state.initialSubblockUid}');
    logg.i('BEFORE: selectedUpazila: ${state.selectedUpazila}');
    logg.i('BEFORE: selectedUnion: ${state.selectedUnion}');
    logg.i('BEFORE: selectedWard: ${state.selectedWard}');
    logg.i('BEFORE: selectedSubblock: ${state.selectedSubblock}');

    // ✅ RACE CONDITION FIX: Clear EPI data to prevent re-initialization
    // This breaks the race condition because epiState.epiCenterData becomes null
    try {
      final epiController = _ref.read(epiCenterControllerProvider.notifier);
      epiController.reset();
      logg.i('FilterProvider: 🗑️ EPI data cleared to prevent race condition');
    } catch (e) {
      logg.w('FilterProvider: ⚠️ Could not clear EPI data: $e');
      // Continue with filter context clearing even if EPI data clearing fails
    }

    state = state.copyWith(
      isEpiDetailsContext: false,
      clearInitialSubblockUid: true,
      // Clear extended hierarchical selections that were loaded for EPI context
      clearUpazila: true,
      clearUnion: true,
      clearWard: true,
      clearSubblock: true,
      // Clear hierarchical data lists that were loaded for EPI context
      upazilas: const [],
      unions: const [],
      wards: const [],
      subblocks: const [],
      // ✅ CLEAR ORIGINAL STATE: Clean up when exiting EPI context
      clearOriginalEpiUid: true,
      clearOriginalCcUid: true,
      clearOriginalDivision: true,
      clearOriginalDistrict: true,
      clearOriginalUpazila: true,
      clearOriginalUnion: true,
      clearOriginalWard: true,
      clearOriginalSubblock: true,
      clearOriginalYear: true,
      // ✅ PLAN A: Clear cached hierarchical data
      clearOriginalCachedData: true,
    );

    logg.i(
      'FilterProvider: ✅ EPI context cleared - map functionality restored',
    );

    // new state values
    logg.i('AFTER: isEpiDetailsContext: ${state.isEpiDetailsContext}');
    logg.i('AFTER: initialSubblockUid: ${state.initialSubblockUid}');
    logg.i('AFTER: selectedUpazila: ${state.selectedUpazila}');
    logg.i('AFTER: selectedUnion: ${state.selectedUnion}');
    logg.i('AFTER: selectedWard: ${state.selectedWard}');
    logg.i('AFTER: selectedSubblock: ${state.selectedSubblock}');
  }

  /// Apply filters with initial values for proper change detection
  /// This method receives both current and initial values to determine what actually changed
  void applyFiltersWithInitialValues({
    // Current selections
    String? vaccine,
    AreaType? areaType,
    String? division,
    String? cityCorporation,
    String? district,
    String? upazila,
    String? union,
    String? ward,
    String? subblock,
    String? year,
    // Initial values for comparison
    required String initialVaccine,
    required AreaType initialAreaType,
    required String initialYear,
    required String initialDivision,
    String? initialDistrict,
    String? initialCityCorporation,
    String? initialUpazila,
    String? initialUnion,
    String? initialWard,
    String? initialSubblock,
  }) {
    logg.i('🔍 FilterProvider: Comparing current vs initial values:');

    // Compare current values with initial values to detect changes
    final bool hasNonVaccineChanges =
        (areaType != null && areaType != initialAreaType) ||
        (division != null && division != initialDivision) ||
        (cityCorporation != null &&
            cityCorporation != initialCityCorporation) ||
        (district != null && district != initialDistrict) ||
        (upazila != null && upazila != initialUpazila) ||
        (union != null && union != initialUnion) ||
        (ward != null && ward != initialWard) ||
        (subblock != null && subblock != initialSubblock) ||
        (year != null && year != initialYear);

    // Update individual filter selections
    if (vaccine != null) updateVaccine(vaccine);
    if (areaType != null) updateAreaType(areaType);
    if (year != null) updateYear(year);
    if (division != null) updateDivision(division);
    if (cityCorporation != null) updateCityCorporation(cityCorporation);
    if (district != null) updateDistrict(district);
    if (upazila != null) updateUpazila(upazila);
    if (union != null) updateUnion(union);
    if (ward != null) updateWard(ward);
    if (subblock != null) updateSubblock(subblock);

    logg.i(
      'FilterProvider: Non-vaccine changes detected: $hasNonVaccineChanges',
    );

    // Only mark the timestamp when non-vaccine filters actually changed
    if (hasNonVaccineChanges) {
      state = state.copyWith(lastAppliedTimestamp: DateTime.now());
      logg.i('✅ FilterProvider: Timestamp updated - EPI screen will reload');
    } else {
      logg.i('FilterProvider: No non-vaccine changes, timestamp not updated');
    }
  }

  /// Apply filters and mark the timestamp when filters are applied
  /// Only updates timestamp for non-vaccine changes to prevent unnecessary map loading
  void applyFilters({
    String? vaccine,
    AreaType? areaType,
    String? division,
    String? cityCorporation,
    String? district,
    String? upazila,
    String? union,
    String? ward,
    String? subblock,
    String? year,
  }) {
    // Capture current state before any updates
    // ✅ Capture individual values BEFORE any updates
    final oldAreaType = state.selectedAreaType;
    final oldDivision = state.selectedDivision;
    final oldCityCorporation = state.selectedCityCorporation;
    final oldDistrict = state.selectedDistrict;
    final oldUpazila = state.selectedUpazila;
    final oldUnion = state.selectedUnion;
    final oldWard = state.selectedWard;
    final oldSubblock = state.selectedSubblock;
    final oldYear = state.selectedYear;

    // Log old values
    logg.i(
      'Old values: areaType=$oldAreaType, division=$oldDivision, '
      'cityCorporation=$oldCityCorporation, district=$oldDistrict, '
      'upazila=$oldUpazila, union=$oldUnion, ward=$oldWard, '
      'subblock=$oldSubblock, year=$oldYear',
    );

    // Update individual filter selections
    if (vaccine != null) updateVaccine(vaccine);
    if (areaType != null) updateAreaType(areaType);
    if (year != null) updateYear(year);
    if (division != null) updateDivision(division);
    if (cityCorporation != null) updateCityCorporation(cityCorporation);
    if (district != null) updateDistrict(district);
    if (upazila != null) updateUpazila(upazila);
    if (union != null) updateUnion(union);
    if (ward != null) updateWard(ward);
    if (subblock != null) updateSubblock(subblock);

    // Log new values after updates
    logg.i(
      'New values: areaType=${state.selectedAreaType}, '
      'division=${state.selectedDivision}, '
      'cityCorporation=${state.selectedCityCorporation}, '
      'district=${state.selectedDistrict}, '
      'upazila=${state.selectedUpazila}, '
      'union=${state.selectedUnion}, '
      'ward=${state.selectedWard}, '
      'subblock=${state.selectedSubblock}, '
      'year=${state.selectedYear}',
    );

    // Check if any non-vaccine filters actually changed from their previous values
    // ✅ Now compare with the captured old values
    final bool hasNonVaccineChanges =
        (areaType != null && areaType != oldAreaType) ||
        (division != null && division != oldDivision) ||
        (cityCorporation != null && cityCorporation != oldCityCorporation) ||
        (district != null && district != oldDistrict) ||
        (upazila != null && upazila != oldUpazila) ||
        (union != null && union != oldUnion) ||
        (ward != null && ward != oldWard) ||
        (subblock != null && subblock != oldSubblock) ||
        (year != null && year != oldYear);

    logg.i(
      'FilterProvider: Non-vaccine changes detected: $hasNonVaccineChanges',
    );
    // Only mark the timestamp when non-vaccine filters actually changed
    // This prevents map loading when only vaccine changes
    if (hasNonVaccineChanges) {
      state = state.copyWith(lastAppliedTimestamp: DateTime.now());
    } else {
      logg.i('FilterProvider: No non-vaccine changes, timestamp not updated');
    }
  }
}
