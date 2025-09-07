import 'area_response_model.dart';

/// Filter state for managing user selections and area data
class FilterState {
  final String selectedVaccine;
  final String selectedAreaType;
  final String selectedDivision;
  final String? selectedCityCorporation;
  final String? selectedDistrict;
  final String selectedYear;

  // Area data
  final List<AreaResponseModel> divisions;
  final List<AreaResponseModel> districts;
  final List<AreaResponseModel> cityCorporations;
  final List<AreaResponseModel>
  filteredDistricts; // Districts filtered by selected division

  // Loading states
  final bool isLoadingAreas;
  final String? areasError;

  // Filter application tracking
  final DateTime? lastAppliedTimestamp;

  const FilterState({
    this.selectedVaccine = 'Penta - 1st',
    this.selectedAreaType = 'district',
    this.selectedDivision = 'All',
    this.selectedCityCorporation,
    this.selectedDistrict,
    this.selectedYear = '2025',
    this.divisions = const [],
    this.districts = const [],
    this.cityCorporations = const [],
    this.filteredDistricts = const [],
    this.isLoadingAreas = false,
    this.areasError,
    this.lastAppliedTimestamp,
  });

  FilterState copyWith({
    String? selectedVaccine,
    String? selectedAreaType,
    String? selectedDivision,
    String? selectedCityCorporation,
    String? selectedDistrict,
    String? selectedYear,
    List<AreaResponseModel>? divisions,
    List<AreaResponseModel>? districts,
    List<AreaResponseModel>? cityCorporations,
    List<AreaResponseModel>? filteredDistricts,
    bool? isLoadingAreas,
    String? areasError,
    DateTime? lastAppliedTimestamp,
  }) {
    return FilterState(
      selectedVaccine: selectedVaccine ?? this.selectedVaccine,
      selectedAreaType: selectedAreaType ?? this.selectedAreaType,
      selectedDivision: selectedDivision ?? this.selectedDivision,
      selectedCityCorporation:
          selectedCityCorporation ?? this.selectedCityCorporation,
      selectedDistrict: selectedDistrict ?? this.selectedDistrict,
      selectedYear: selectedYear ?? this.selectedYear,
      divisions: divisions ?? this.divisions,
      districts: districts ?? this.districts,
      cityCorporations: cityCorporations ?? this.cityCorporations,
      filteredDistricts: filteredDistricts ?? this.filteredDistricts,
      isLoadingAreas: isLoadingAreas ?? this.isLoadingAreas,
      areasError: areasError ?? this.areasError,
      lastAppliedTimestamp: lastAppliedTimestamp ?? this.lastAppliedTimestamp,
    );
  }
}
