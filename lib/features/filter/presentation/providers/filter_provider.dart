import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/filter_state.dart';
import '../../domain/area_response_model.dart';
import '../../data/filter_repository.dart';

/// Global filter state provider
final filterProvider = StateNotifierProvider<FilterNotifier, FilterState>((
  ref,
) {
  final repository = ref.watch(filterRepositoryProvider);
  return FilterNotifier(repository);
});

class FilterNotifier extends StateNotifier<FilterState> {
  final FilterRepository _repository;

  FilterNotifier(this._repository) : super(const FilterState()) {
    // Initialize area data when provider is created
    _loadAllAreas();
  }

  /// Load all area data (divisions, districts, city corporations) at startup
  Future<void> _loadAllAreas() async {
    state = state.copyWith(isLoadingAreas: true, areasError: null);

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
  void updateAreaType(String areaType) {
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
        selectedDistrict: null, // Clear district selection when showing all
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

  /// Load districts for a specific division
  Future<void> _loadDistrictsByDivision(String divisionUid) async {
    try {
      print('FilterProvider: Loading districts for division UID: $divisionUid');
      final filteredDistricts = await _repository.fetchDistrictsByDivisionId(
        divisionUid,
      );
      print(
        'FilterProvider: Loaded ${filteredDistricts.length} districts for division',
      );
      state = state.copyWith(
        filteredDistricts: filteredDistricts,
        selectedDistrict:
            null, // Clear district selection when division changes
      );
    } catch (e) {
      print('FilterProvider: API call failed, filtering locally: $e');
      // If API call fails, filter from existing districts
      final filteredDistricts = state.districts
          .where((district) => district.parentUid == divisionUid)
          .toList();

      print(
        'FilterProvider: Local filtering found ${filteredDistricts.length} districts',
      );
      state = state.copyWith(
        filteredDistricts: filteredDistricts,
        selectedDistrict: null,
      );
    }
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

  /// Reset all filters to default values
  void resetFilters() {
    state = state.copyWith(
      selectedVaccine: 'Penta - 1st',
      selectedAreaType: 'district',
      selectedDivision: 'All',
      selectedCityCorporation: null,
      selectedDistrict: null,
      selectedYear: '2025',
      filteredDistricts: state.districts, // Reset to show all districts
    );
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
}
