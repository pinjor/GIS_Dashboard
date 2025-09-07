import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gis_dashboard/core/common/constants/constants.dart';
import 'package:gis_dashboard/core/utils/utils.dart';
import '../providers/filter_provider.dart';

class FilterDialogBoxWidget extends ConsumerStatefulWidget {
  const FilterDialogBoxWidget({super.key});

  @override
  ConsumerState<FilterDialogBoxWidget> createState() =>
      _FilterDialogBoxWidgetState();
}

class _FilterDialogBoxWidgetState extends ConsumerState<FilterDialogBoxWidget> {
  // Local state for temporary selections (until user clicks Filter)
  late String _selectedAreaType;
  late String _selectedVaccine;
  late String _selectedDivision;
  String? _selectedCityCorporation;
  String? _selectedDistrict;
  late String _selectedYear;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Initialize with current filter state - will be set on first build
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Initialize with current filter state
    final currentFilter = ref.read(filterProvider);
    _selectedAreaType = currentFilter.selectedAreaType;
    _selectedVaccine = currentFilter.selectedVaccine;
    _selectedDivision = currentFilter.selectedDivision;
    _selectedCityCorporation = currentFilter.selectedCityCorporation;
    _selectedDistrict = currentFilter.selectedDistrict;
    _selectedYear = currentFilter.selectedYear;
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Color(Constants.primaryColor);
    final filterState = ref.watch(filterProvider);
    final filterNotifier = ref.read(filterProvider.notifier);

    // Sync local district selection with provider state when districts are filtered
    if (_selectedDistrict != null &&
        !filterNotifier.districtDropdownItems.contains(_selectedDistrict)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          _selectedDistrict = null;
        });
      });
    }

    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Material(
            color: Color(Constants.cardColor),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                5.h,
                // Area Type Selection
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedAreaType = 'district';
                        });
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Radio(
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            visualDensity: VisualDensity.compact,
                            activeColor: primaryColor,
                            value: 'district',
                            groupValue: _selectedAreaType,
                            onChanged: (value) {
                              setState(() {
                                _selectedAreaType = value!;
                              });
                            },
                          ),
                          const Text('District'),
                        ],
                      ),
                    ),
                    12.w,
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedAreaType = 'city_corporation';
                        });
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Radio(
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            visualDensity: VisualDensity.compact,
                            activeColor: primaryColor,
                            value: 'city_corporation',
                            groupValue: _selectedAreaType,
                            onChanged: (value) {
                              setState(() {
                                _selectedAreaType = value!;
                              });
                            },
                          ),
                          const Text('City Corporation'),
                        ],
                      ),
                    ),
                  ],
                ),
                16.h,
                // Period Selection
                const Text(
                  'Period',
                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
                ),
                8.h,
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  value: _selectedYear,
                  items: ['2025', '2024']
                      .map(
                        (year) =>
                            DropdownMenuItem(value: year, child: Text(year)),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedYear = value;
                      });
                    }
                  },
                ),
                16.h,
                // Area-specific dropdowns
                if (_selectedAreaType == 'district') ...[
                  // Division Dropdown
                  const Text(
                    'Division',
                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
                  ),
                  8.h,
                  if (filterState.isLoadingAreas)
                    const Center(child: CircularProgressIndicator())
                  else if (filterState.areasError != null)
                    Column(
                      children: [
                        Text('Error: ${filterState.areasError}'),
                        8.h,
                        ElevatedButton(
                          onPressed: () => filterNotifier.retryLoadAreas(),
                          child: const Text('Retry'),
                        ),
                      ],
                    )
                  else
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      value: _selectedDivision,
                      items: filterNotifier.divisionDropdownItems
                          .map(
                            (division) => DropdownMenuItem(
                              value: division,
                              child: Text(division),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _selectedDivision = value;
                            _selectedDistrict =
                                null; // Clear district when division changes
                          });
                          // Update the provider to filter districts based on selected division
                          filterNotifier.updateDivision(value);
                        }
                      },
                    ),
                  16.h,
                  // District Dropdown
                  const Text(
                    'District',
                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
                  ),
                  8.h,
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    value: _selectedDistrict,
                    hint: const Text('All'),
                    items: ['All', ...filterNotifier.districtDropdownItems]
                        .map(
                          (district) => DropdownMenuItem(
                            value: district == 'All' ? null : district,
                            child: Text(district),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedDistrict = value;
                      });
                    },
                  ),
                ] else if (_selectedAreaType == 'city_corporation') ...[
                  // City Corporation Dropdown
                  const Text(
                    'City Corporation',
                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
                  ),
                  8.h,
                  if (filterState.isLoadingAreas)
                    const Center(child: CircularProgressIndicator())
                  else if (filterState.areasError != null)
                    Column(
                      children: [
                        Text('Error: ${filterState.areasError}'),
                        8.h,
                        ElevatedButton(
                          onPressed: () => filterNotifier.retryLoadAreas(),
                          child: const Text('Retry'),
                        ),
                      ],
                    )
                  else
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      value: _selectedCityCorporation,
                      hint: const Text('Select City Corporation'),
                      items: filterNotifier.cityCorporationDropdownItems
                          .map(
                            (corporation) => DropdownMenuItem(
                              value: corporation,
                              child: Text(corporation),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedCityCorporation = value;
                        });
                      },
                    ),
                ],
                16.h,
                // Vaccine Selection
                const Text(
                  'Select Vaccine',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                ),
                8.h,
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // First column
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 4,
                        children: [
                          _buildRadio('Penta - 1st', primaryColor),
                          _buildRadio('Penta - 2nd', primaryColor),
                          _buildRadio('Penta - 3rd', primaryColor),
                        ],
                      ),
                    ),
                    // Second column
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 4,
                        children: [
                          _buildRadio('MR - 1st', primaryColor),
                          _buildRadio('MR - 2nd', primaryColor),
                          _buildRadio('BCG', primaryColor),
                        ],
                      ),
                    ),
                  ],
                ),
                24.h,
                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                        ),
                        onPressed: () {
                          // Apply filters to global state with timestamp
                          filterNotifier.applyFilters(
                            vaccine: _selectedVaccine,
                            areaType: _selectedAreaType,
                            year: _selectedYear,
                            division: _selectedAreaType == 'district'
                                ? _selectedDivision
                                : null,
                            district: _selectedAreaType == 'district'
                                ? _selectedDistrict
                                : null,
                            cityCorporation:
                                _selectedAreaType == 'city_corporation'
                                ? _selectedCityCorporation
                                : null,
                          );

                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          'Filter',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    8.w,
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                        ),
                        onPressed: () {
                          // Reset filters to default
                          filterNotifier.resetFilters();
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          'Reset',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRadio(String label, Color primaryColor) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedVaccine = label;
        });
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Radio(
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            visualDensity: VisualDensity.compact,
            activeColor: primaryColor,
            value: label,
            groupValue: _selectedVaccine,
            onChanged: (value) {
              setState(() {
                _selectedVaccine = value!;
              });
            },
          ),
          Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }
}
