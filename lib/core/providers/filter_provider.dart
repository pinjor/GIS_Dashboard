import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Filter state for managing user selections
class FilterState {
  final String selectedVaccine;
  final String selectedAreaType;
  final String selectedDivision;
  final String? selectedCityCorporation;
  final String selectedYear;

  const FilterState({
    this.selectedVaccine = 'Penta - 1st',
    this.selectedAreaType = 'district',
    this.selectedDivision = 'All',
    this.selectedCityCorporation,
    this.selectedYear = '2025',
  });

  FilterState copyWith({
    String? selectedVaccine,
    String? selectedAreaType,
    String? selectedDivision,
    String? selectedCityCorporation,
    String? selectedYear,
  }) {
    return FilterState(
      selectedVaccine: selectedVaccine ?? this.selectedVaccine,
      selectedAreaType: selectedAreaType ?? this.selectedAreaType,
      selectedDivision: selectedDivision ?? this.selectedDivision,
      selectedCityCorporation:
          selectedCityCorporation ?? this.selectedCityCorporation,
      selectedYear: selectedYear ?? this.selectedYear,
    );
  }
}

/// Global filter state provider
final filterProvider = StateNotifierProvider<FilterNotifier, FilterState>((
  ref,
) {
  return FilterNotifier();
});

class FilterNotifier extends StateNotifier<FilterState> {
  FilterNotifier() : super(const FilterState());

  void updateVaccine(String vaccine) {
    state = state.copyWith(selectedVaccine: vaccine);
  }

  void updateAreaType(String areaType) {
    state = state.copyWith(selectedAreaType: areaType);
  }

  void updateDivision(String division) {
    state = state.copyWith(selectedDivision: division);
  }

  void updateCityCorporation(String? cityCorporation) {
    state = state.copyWith(selectedCityCorporation: cityCorporation);
  }

  void updateYear(String year) {
    state = state.copyWith(selectedYear: year);
  }

  void resetFilters() {
    state = const FilterState();
  }
}
