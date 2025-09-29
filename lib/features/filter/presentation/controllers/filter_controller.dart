import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/utils/utils.dart';
import '../../domain/filter_state.dart';
import '../../domain/area_response_model.dart';
import '../../data/filter_repository.dart';
import '../../../map/utils/map_enums.dart';

/// Global filter state provider
final filterControllerProvider =
    StateNotifierProvider<FilterControllerNotifier, FilterState>((ref) {
      final repository = ref.watch(filterRepositoryProvider);
      return FilterControllerNotifier(repository: repository);
    });

class FilterControllerNotifier extends StateNotifier<FilterState> {
  final FilterRepository _repository;

  FilterControllerNotifier({required FilterRepository repository})
    : _repository = repository,
      super(const FilterState()) {
    // Initialize area data when provider is created
    _loadAllAreas();
  }

  /// Load all area data (divisions, districts, city corporations) at startup
  Future<void> _loadAllAreas() async {
    state = state.copyWith(isLoadingAreas: true, clearAreasError: true);

    try {
      print('FilterProvider: Starting to load all areas...');

      // Fetch all area types in parallel
      final results = await Future.wait([
        _repository.fetchAllDivisions(),
        _repository.fetchAllDistricts(),
        _repository.fetchAllCityCorporations(),
      ]);

      final divisions = results[0];
      final districts = results[1];
      final cityCorporations = results[2];

      print(
        'FilterProvider: Loaded ${divisions.length} divisions, ${districts.length} districts, ${cityCorporations.length} city corporations',
      );

      state = state.copyWith(
        divisions: divisions,
        districts: districts,
        cityCorporations: cityCorporations,
        filteredDistricts: districts, // Initially show all districts
        isLoadingAreas: false,
      );

      print('FilterProvider: All areas loaded successfully');
    } catch (e) {
      print('FilterProvider: Error loading areas: $e');
      state = state.copyWith(isLoadingAreas: false, areasError: e.toString());
    }
  }

  /// Update vaccine selection
  void updateVaccine(String vaccine) {
    state = state.copyWith(selectedVaccine: vaccine);
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
    state = state.copyWith(
      selectedUpazila: upazila,
      clearUnion: true,
      clearWard: true,
      clearSubblock: true,
      unions: const [],
      wards: const [],
      subblocks: const [],
    );

    if (upazila != null && upazila != 'All') {
      final upazilaUid = _getUpazilaUid(upazila);
      if (upazilaUid != null) {
        _loadUnionsByUpazila(upazilaUid);
      }
    }
  }

  /// Update union selection and load wards
  void updateUnion(String? union) {
    state = state.copyWith(
      selectedUnion: union,
      clearWard: true,
      clearSubblock: true,
      wards: const [],
      subblocks: const [],
    );

    if (union != null && union != 'All') {
      final unionUid = _getUnionUid(union);
      if (unionUid != null) {
        _loadWardsByUnion(unionUid);
      }
    }
  }

  /// Update ward selection and load subblocks
  void updateWard(String? ward) {
    state = state.copyWith(
      selectedWard: ward,
      clearSubblock: true,
      subblocks: const [],
    );

    if (ward != null && ward != 'All') {
      final wardUid = _getWardUid(ward);
      if (wardUid != null) {
        _loadSubblocksByWard(wardUid);
      }
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
  }) async {
    print('FilterProvider: Initializing from EPI data');

    // Extract hierarchical data from EPI response
    final String? divisionName = epiData?.divisionName;
    final String? districtName = epiData?.districtName;
    final String? upazilaName = epiData?.upazilaName;
    final String? unionName = epiData?.unionName;
    final String? wardName = epiData?.wardName;
    final String? subblockName = epiData?.subBlockName;
    final String? subblockUid = epiData?.subblockId;
    final String? cityCorporationName = epiData?.cityCorporationName;

    // Determine area type based on EPI context
    final AreaType areaType =
        cityCorporationName != null && cityCorporationName.isNotEmpty
        ? AreaType.cityCorporation
        : AreaType.district;

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

    // Update state with EPI context data
    state = state.copyWith(
      isEpiDetailsContext: isEpiDetailsContext,
      initialSubblockUid: subblockUid,
      selectedAreaType: areaType,
      selectedDivision: divisionName ?? state.selectedDivision,
      selectedDistrict: districtName,
      selectedCityCorporation: areaType == AreaType.cityCorporation
          ? cityCorporationName
          : null,
      selectedUpazila: upazilaName,
      selectedUnion: unionName,
      selectedWard: wardName,
      selectedSubblock: subblockName,
      upazilas: upazilas,
      unions: unions,
      wards: wards,
      subblocks: subblocks,
    );

    print('FilterProvider: EPI context initialized successfully');
    print('  Area Type: $areaType');
    print('  Division: $divisionName');
    print('  District: $districtName');
    print('  City Corporation: $cityCorporationName');
    print('  Upazila: $upazilaName');
    print('  Union: $unionName');
    print('  Ward: $wardName');
    print('  Subblock: $subblockName');
  }

  /// Reset to initial EPI values (for EPI details context)
  void resetToInitialEpiValues() {
    if (!state.isEpiDetailsContext || state.initialSubblockUid == null) return;

    print('FilterProvider: Resetting to initial EPI values');

    // This would reset to the original EPI data values
    // For now, we'll need to re-initialize from the original EPI data
    // The EPI details screen should call initializeFromEpiData again
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

    // Log detailed comparison
    if (areaType != null) {
      logg.i(
        '   AreaType: $areaType vs $initialAreaType = ${areaType != initialAreaType}',
      );
    }
    if (division != null) {
      logg.i(
        '   Division: $division vs $initialDivision = ${division != initialDivision}',
      );
    }
    if (cityCorporation != null) {
      logg.i(
        '   CityCorporation: $cityCorporation vs $initialCityCorporation = ${cityCorporation != initialCityCorporation}',
      );
    }
    if (district != null) {
      logg.i(
        '   District: $district vs $initialDistrict = ${district != initialDistrict}',
      );
    }
    if (upazila != null) {
      logg.i(
        '   Upazila: $upazila vs $initialUpazila = ${upazila != initialUpazila}',
      );
    }
    if (union != null) {
      logg.i('   Union: $union vs $initialUnion = ${union != initialUnion}');
    }
    if (ward != null) {
      logg.i('   Ward: $ward vs $initialWard = ${ward != initialWard}');
    }
    if (subblock != null) {
      logg.i(
        '   Subblock: $subblock vs $initialSubblock = ${subblock != initialSubblock}',
      );
    }
    if (year != null) {
      logg.i('   Year: $year vs $initialYear = ${year != initialYear}');
    }

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
