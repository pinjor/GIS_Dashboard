import 'package:flutter_riverpod/flutter_riverpod.dart';
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

  /// Get district slug by district name from GeoJSON data

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

  /// Apply filters and mark the timestamp when filters are applied
  /// Only updates timestamp for non-vaccine changes to prevent unnecessary map loading
  void applyFilters({
    String? vaccine,
    AreaType? areaType,
    String? division,
    String? cityCorporation,
    String? district,
    String? year,
  }) {
    // Capture current state before any updates
    final currentState = state;

    // Update individual filter selections
    if (vaccine != null) updateVaccine(vaccine);
    if (areaType != null) updateAreaType(areaType);
    if (year != null) updateYear(year);
    if (division != null) updateDivision(division);
    if (cityCorporation != null) updateCityCorporation(cityCorporation);
    if (district != null) updateDistrict(district);

    // Check if any non-vaccine filters actually changed from their previous values
    final bool hasNonVaccineChanges =
        (areaType != null && areaType != currentState.selectedAreaType) ||
        (division != null && division != currentState.selectedDivision) ||
        (cityCorporation != null &&
            cityCorporation != currentState.selectedCityCorporation) ||
        (district != null && district != currentState.selectedDistrict) ||
        (year != null && year != currentState.selectedYear);

    // Only mark the timestamp when non-vaccine filters actually changed
    // This prevents map loading when only vaccine changes
    if (hasNonVaccineChanges) {
      state = state.copyWith(lastAppliedTimestamp: DateTime.now());
    }
  }
}
