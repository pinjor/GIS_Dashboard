import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gis_dashboard/core/common/constants/constants.dart';
import 'package:gis_dashboard/core/common/widgets/custom_loading_widget.dart';
import 'package:gis_dashboard/core/utils/utils.dart';
import '../../domain/filter_state.dart';
import '../controllers/filter_controller.dart';
import '../../../map/utils/map_enums.dart';
import '../../../epi_center/presentation/controllers/epi_center_controller.dart';

class FilterDialogBoxWidget extends ConsumerStatefulWidget {
  const FilterDialogBoxWidget({super.key});

  @override
  ConsumerState<FilterDialogBoxWidget> createState() =>
      _FilterDialogBoxWidgetState();
}

class _FilterDialogBoxWidgetState extends ConsumerState<FilterDialogBoxWidget> {
  // Local state for temporary selections (until user clicks Filter)
  late AreaType _selectedAreaType;
  late String _selectedVaccine;
  late String _selectedDivision;
  String? _selectedCityCorporation;
  String? _selectedDistrict;
  late String _selectedYear;

  // Extended hierarchical selections (for EPI details screen)
  String? _selectedUpazila;
  String? _selectedUnion;
  String? _selectedWard;
  String? _selectedSubblock;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Initialize with current filter state - will be set on first build
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initializeFilterState();
  }

  /// Initialize filter state properly for both normal and EPI contexts
  void _initializeFilterState() {
    final currentFilter = ref.read(filterControllerProvider);
    final filterNotifier = ref.read(filterControllerProvider.notifier);

    // Always preserve the current area type
    _selectedAreaType = currentFilter.selectedAreaType;
    _selectedVaccine = currentFilter.selectedVaccine;
    _selectedYear = currentFilter.selectedYear;

    // Initialize based on area type
    if (_selectedAreaType == AreaType.district) {
      _initializeDistrictAreaType(currentFilter, filterNotifier);
    } else if (_selectedAreaType == AreaType.cityCorporation) {
      _initializeCityCorporationAreaType(currentFilter, filterNotifier);
    }

    print('Filter Dialog Initialized:');
    print('  Area Type: $_selectedAreaType');
    print('  Division: $_selectedDivision');
    print('  District: $_selectedDistrict');
    print('  City Corporation: $_selectedCityCorporation');
    print('  Is EPI Context: ${currentFilter.isEpiDetailsContext}');
    print('  Upazila: $_selectedUpazila');
    print('  Union: $_selectedUnion');
    print('  Ward: $_selectedWard');
    print('  Subblock: $_selectedSubblock');
  }

  /// Initialize district area type selections
  void _initializeDistrictAreaType(
    FilterState currentFilter,
    FilterControllerNotifier filterNotifier,
  ) {
    // Validate and set division - ensure it exists in dropdown items
    final availableDivisions = filterNotifier.divisionDropdownItems;
    if (availableDivisions.contains(currentFilter.selectedDivision)) {
      _selectedDivision = currentFilter.selectedDivision;
    } else {
      _selectedDivision =
          'All'; // Fallback to 'All' if current selection is invalid
    }

    // Validate and set district
    final availableDistricts = filterNotifier.districtDropdownItems;
    if (currentFilter.selectedDistrict != null &&
        availableDistricts.contains(currentFilter.selectedDistrict)) {
      _selectedDistrict = currentFilter.selectedDistrict;
    } else {
      _selectedDistrict =
          null; // This represents 'All' in the district dropdown
    }

    // Initialize extended hierarchical selections (for EPI details screen)
    if (currentFilter.isEpiDetailsContext) {
      // For EPI context, properly validate hierarchical selections
      final availableUpazilas = filterNotifier.upazilaDropdownItems;
      if (currentFilter.selectedUpazila != null &&
          availableUpazilas.contains(currentFilter.selectedUpazila)) {
        _selectedUpazila = currentFilter.selectedUpazila;
      } else {
        _selectedUpazila = null;
      }

      final availableUnions = filterNotifier.unionDropdownItems;
      if (currentFilter.selectedUnion != null &&
          availableUnions.contains(currentFilter.selectedUnion)) {
        _selectedUnion = currentFilter.selectedUnion;
      } else {
        _selectedUnion = null;
      }

      final availableWards = filterNotifier.wardDropdownItems;
      if (currentFilter.selectedWard != null &&
          availableWards.contains(currentFilter.selectedWard)) {
        _selectedWard = currentFilter.selectedWard;
      } else {
        _selectedWard = null;
      }

      final availableSubblocks = filterNotifier.subblockDropdownItems;
      if (currentFilter.selectedSubblock != null &&
          availableSubblocks.contains(currentFilter.selectedSubblock)) {
        _selectedSubblock = currentFilter.selectedSubblock;
      } else {
        _selectedSubblock = null;
      }
    } else {
      // For normal context, clear hierarchical selections
      _selectedUpazila = null;
      _selectedUnion = null;
      _selectedWard = null;
      _selectedSubblock = null;
    }

    // Clear city corporation selection for district area type
    _selectedCityCorporation = null;
  }

  /// Initialize city corporation area type selections
  void _initializeCityCorporationAreaType(
    FilterState currentFilter,
    FilterControllerNotifier filterNotifier,
  ) {
    // Validate and set city corporation
    final availableCityCorporations =
        filterNotifier.cityCorporationDropdownItems;
    if (currentFilter.selectedCityCorporation != null &&
        availableCityCorporations.contains(
          currentFilter.selectedCityCorporation,
        )) {
      _selectedCityCorporation = currentFilter.selectedCityCorporation;
    } else {
      _selectedCityCorporation = null;
    }

    // Clear district-related selections for city corporation area type
    _selectedDivision = 'All';
    _selectedDistrict = null;
    _selectedUpazila = null;
    _selectedUnion = null;
    _selectedWard = null;
    _selectedSubblock = null;
  }

  /// Initialize state when area type changes via radio buttons
  void _initializeForAreaTypeChange() {
    final currentFilter = ref.read(filterControllerProvider);

    if (_selectedAreaType == AreaType.district) {
      // For district: set to current filter values or defaults
      _selectedDivision = currentFilter.selectedDivision.isNotEmpty
          ? currentFilter.selectedDivision
          : 'All';
      _selectedDistrict = currentFilter.selectedDistrict;
      _selectedCityCorporation = null;

      // For EPI context, preserve hierarchical selections
      if (currentFilter.isEpiDetailsContext) {
        _selectedUpazila = currentFilter.selectedUpazila;
        _selectedUnion = currentFilter.selectedUnion;
        _selectedWard = currentFilter.selectedWard;
        _selectedSubblock = currentFilter.selectedSubblock;
      } else {
        _selectedUpazila = null;
        _selectedUnion = null;
        _selectedWard = null;
        _selectedSubblock = null;
      }
    } else if (_selectedAreaType == AreaType.cityCorporation) {
      // For city corporation: clear district fields
      _selectedDivision = 'All';
      _selectedDistrict = null;
      _selectedUpazila = null;
      _selectedUnion = null;
      _selectedWard = null;
      _selectedSubblock = null;
      _selectedCityCorporation = currentFilter.selectedCityCorporation;
    }
  }

  /// Sync local widget state with provider state (used after reset)
  void _syncLocalStateWithProvider() {
    setState(() {
      _initializeFilterState();
    });
  }

  void _applyFilters({
    required FilterState filterState,
    required FilterControllerNotifier filterNotifier,
  }) {
    // Apply filters to global state with timestamp
    final isEpiContext = filterState.isEpiDetailsContext;

    // Check if EPI is from City Corporation (detect by checking current EPI data)
    final epiState = ref.read(epiCenterControllerProvider);
    final epiData = epiState.epiCenterData;
    final isEpiFromCC =
        epiData?.cityCorporationName != null &&
        epiData!.cityCorporationName!.isNotEmpty;

    // For EPI from City Corporation: buttons do nothing (null behavior)
    if (isEpiContext && isEpiFromCC) {
      return; // Do nothing - no navigation pop, no filter application
    }

    filterNotifier.applyFilters(
      vaccine: isEpiContext
          ? null
          : _selectedVaccine, // No vaccine selection in EPI context
      areaType: _selectedAreaType,
      year: _selectedYear,
      division: _selectedAreaType == AreaType.district
          ? _selectedDivision
          : null,
      district: _selectedAreaType == AreaType.district
          ? _selectedDistrict
          : null,
      cityCorporation: _selectedAreaType == AreaType.cityCorporation
          ? _selectedCityCorporation
          : null,
      // Extended hierarchical fields (for EPI context)
      upazila: _selectedAreaType == AreaType.district && isEpiContext
          ? _selectedUpazila
          : null,
      union: _selectedAreaType == AreaType.district && isEpiContext
          ? _selectedUnion
          : null,
      ward: _selectedAreaType == AreaType.district && isEpiContext
          ? _selectedWard
          : null,
      subblock: _selectedAreaType == AreaType.district && isEpiContext
          ? _selectedSubblock
          : null,
    );

    Navigator.of(context).pop();
  }

  void _resetFilters({
    required FilterState filterState,
    required FilterControllerNotifier filterNotifier,
  }) {
    final isEpiContext = filterState.isEpiDetailsContext;

    // Check if EPI is from City Corporation (detect by checking current EPI data)
    final epiState = ref.read(epiCenterControllerProvider);
    final epiData = epiState.epiCenterData;
    final isEpiFromCC =
        epiData?.cityCorporationName != null &&
        epiData!.cityCorporationName!.isNotEmpty;

    // For EPI from City Corporation: buttons do nothing (null behavior)
    if (isEpiContext && isEpiFromCC) {
      return; // Do nothing - no navigation pop, no filter application
    }

    if (isEpiContext) {
      // For EPI context, reset to initial EPI values instead of clearing everything
      filterNotifier.resetToInitialEpiValues();
    } else {
      // For normal context, reset filters to default
      filterNotifier.resetFilters();
    }

    // Sync local state with provider state after reset
    _syncLocalStateWithProvider();

    Navigator.of(context).pop();
  }

  /// Check if all required fields are selected for district-based EPI context
  bool _isFilterButtonEnabled(FilterState filterState) {
    final isEpiContext = filterState.isEpiDetailsContext;

    // Check if EPI is from City Corporation
    final epiState = ref.read(epiCenterControllerProvider);
    final epiData = epiState.epiCenterData;
    final isEpiFromCC =
        epiData?.cityCorporationName != null &&
        epiData!.cityCorporationName!.isNotEmpty;

    // For non-EPI context or EPI from CC, always enable
    if (!isEpiContext || isEpiFromCC) {
      return true;
    }

    // For district-based EPI context, check if all fields are selected
    if (_selectedAreaType == AreaType.district) {
      return _selectedDivision != 'All' &&
          _selectedDistrict != null &&
          _selectedUpazila != null &&
          _selectedUnion != null &&
          _selectedWard != null &&
          _selectedSubblock != null;
    }

    // For CC area type in EPI context, disable
    if (_selectedAreaType == AreaType.cityCorporation) {
      return _selectedCityCorporation != null;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Color(Constants.primaryColor);
    final filterState = ref.watch(filterControllerProvider);
    final filterNotifier = ref.read(filterControllerProvider.notifier);

    // Debug logging for filter dialog state
    print('Filter Dialog Build:');
    print('  Current Provider Area Type: ${filterState.selectedAreaType}');
    print('  Local Selected Area Type: $_selectedAreaType');
    print('  Is EPI Context: ${filterState.isEpiDetailsContext}');

    // Sync local selections with provider state when dropdown items change
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        // Validate district selection
        if (_selectedDistrict != null &&
            !filterNotifier.districtDropdownItems.contains(_selectedDistrict)) {
          _selectedDistrict = null;
        }

        // Validate hierarchical selections (for EPI context)
        if (filterState.isEpiDetailsContext) {
          // Validate upazila selection
          if (_selectedUpazila != null &&
              !filterNotifier.upazilaDropdownItems.contains(_selectedUpazila)) {
            _selectedUpazila = null;
          }

          // Validate union selection
          if (_selectedUnion != null &&
              !filterNotifier.unionDropdownItems.contains(_selectedUnion)) {
            _selectedUnion = null;
          }

          // Validate ward selection
          if (_selectedWard != null &&
              !filterNotifier.wardDropdownItems.contains(_selectedWard)) {
            _selectedWard = null;
          }

          // Validate subblock selection
          if (_selectedSubblock != null &&
              !filterNotifier.subblockDropdownItems.contains(
                _selectedSubblock,
              )) {
            _selectedSubblock = null;
          }
        }
      });
    });

    return filterState.isLoadingAreas
        ? const Center(
            child: CustomLoadingWidget(loadingText: 'Updating filter...'),
          )
        : Padding(
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
                                _selectedAreaType = AreaType.district;
                                _initializeForAreaTypeChange();
                              });
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Radio<AreaType>(
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  visualDensity: VisualDensity.compact,
                                  activeColor: primaryColor,
                                  value: AreaType.district,
                                  groupValue: _selectedAreaType,
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedAreaType = value!;
                                      _initializeForAreaTypeChange();
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
                                _selectedAreaType = AreaType.cityCorporation;
                                _initializeForAreaTypeChange();
                              });
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Radio<AreaType>(
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  visualDensity: VisualDensity.compact,
                                  activeColor: primaryColor,
                                  value: AreaType.cityCorporation,
                                  groupValue: _selectedAreaType,
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedAreaType = value!;
                                      _initializeForAreaTypeChange();
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
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                        ),
                      ),
                      8.h,
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                        initialValue: _selectedYear,
                        items: ['2025', '2024']
                            .map(
                              (year) => DropdownMenuItem(
                                value: year,
                                child: Text(year),
                              ),
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
                      if (_selectedAreaType == AreaType.district) ...[
                        // Division Dropdown
                        const Text(
                          'Division',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                          ),
                        ),
                        8.h,
                        if (filterState.isLoadingAreas)
                          const Center(child: CircularProgressIndicator())
                        else if (filterState.areasError != null)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Failed to load divisions'),
                              8.h,
                              ElevatedButton(
                                onPressed: () =>
                                    filterNotifier.retryLoadAreas(),
                                child: const Text('Retry'),
                              ),
                            ],
                          )
                        else
                          DropdownButtonFormField<String>(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                            initialValue:
                                filterNotifier.divisionDropdownItems.contains(
                                  _selectedDivision,
                                )
                                ? _selectedDivision
                                : 'All', // Fallback to 'All' if selected division is not in the list
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
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                          ),
                        ),
                        8.h,
                        DropdownButtonFormField<String?>(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                          initialValue:
                              _selectedDistrict, // This can be null which represents 'All'
                          hint: const Text('All'),
                          items: [
                            const DropdownMenuItem<String?>(
                              value: null,
                              child: Text('All'),
                            ),
                            ...filterNotifier.districtDropdownItems.map(
                              (district) => DropdownMenuItem<String?>(
                                value: district,
                                child: Text(district),
                              ),
                            ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _selectedDistrict = value;
                            });
                          },
                        ),

                        // Extended hierarchical fields (only for EPI details context)
                        if (filterState.isEpiDetailsContext) ...[
                          16.h,
                          // Upazila Dropdown
                          const Text(
                            'Upazila',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                            ),
                          ),
                          8.h,
                          DropdownButtonFormField<String?>(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                            initialValue:
                                filterNotifier.upazilaDropdownItems.contains(
                                  _selectedUpazila,
                                )
                                ? _selectedUpazila
                                : null,
                            hint: const Text('All'),
                            items: [
                              const DropdownMenuItem<String?>(
                                value: null,
                                child: Text('All'),
                              ),
                              ...filterNotifier.upazilaDropdownItems
                                  .where((item) => item != 'All')
                                  .map(
                                    (upazila) => DropdownMenuItem<String?>(
                                      value: upazila,
                                      child: Text(upazila),
                                    ),
                                  ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                _selectedUpazila = value;
                                _selectedUnion = null;
                                _selectedWard = null;
                                _selectedSubblock = null;
                              });
                              filterNotifier.updateUpazila(value);
                            },
                          ),
                          16.h,
                          // Union Dropdown
                          const Text(
                            'Union',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                            ),
                          ),
                          8.h,
                          DropdownButtonFormField<String?>(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                            initialValue:
                                filterNotifier.unionDropdownItems.contains(
                                  _selectedUnion,
                                )
                                ? _selectedUnion
                                : null,
                            hint: const Text('All'),
                            items: [
                              const DropdownMenuItem<String?>(
                                value: null,
                                child: Text('All'),
                              ),
                              ...filterNotifier.unionDropdownItems
                                  .where((item) => item != 'All')
                                  .map(
                                    (union) => DropdownMenuItem<String?>(
                                      value: union,
                                      child: Text(union),
                                    ),
                                  ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                _selectedUnion = value;
                                _selectedWard = null;
                                _selectedSubblock = null;
                              });
                              filterNotifier.updateUnion(value);
                            },
                          ),
                          16.h,
                          // Ward Dropdown
                          const Text(
                            'Ward',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                            ),
                          ),
                          8.h,
                          DropdownButtonFormField<String?>(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                            initialValue:
                                filterNotifier.wardDropdownItems.contains(
                                  _selectedWard,
                                )
                                ? _selectedWard
                                : null,
                            hint: const Text('All'),
                            items: [
                              const DropdownMenuItem<String?>(
                                value: null,
                                child: Text('All'),
                              ),
                              ...filterNotifier.wardDropdownItems
                                  .where((item) => item != 'All')
                                  .map(
                                    (ward) => DropdownMenuItem<String?>(
                                      value: ward,
                                      child: Text(ward),
                                    ),
                                  ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                _selectedWard = value;
                                _selectedSubblock = null;
                              });
                              filterNotifier.updateWard(value);
                            },
                          ),
                          16.h,
                          // Subblock Dropdown
                          const Text(
                            'Sub Block',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                            ),
                          ),
                          8.h,
                          DropdownButtonFormField<String?>(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                            initialValue:
                                filterNotifier.subblockDropdownItems.contains(
                                  _selectedSubblock,
                                )
                                ? _selectedSubblock
                                : null,
                            hint: const Text('All'),
                            items: [
                              const DropdownMenuItem<String?>(
                                value: null,
                                child: Text('All'),
                              ),
                              ...filterNotifier.subblockDropdownItems
                                  .where((item) => item != 'All')
                                  .map(
                                    (subblock) => DropdownMenuItem<String?>(
                                      value: subblock,
                                      child: Text(subblock),
                                    ),
                                  ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                _selectedSubblock = value;
                              });
                              filterNotifier.updateSubblock(value);
                            },
                          ),
                        ],
                      ] else if (_selectedAreaType ==
                          AreaType.cityCorporation) ...[
                        // City Corporation Dropdown
                        const Text(
                          'City Corporation',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                          ),
                        ),
                        8.h,
                        if (filterState.isLoadingAreas)
                          const Center(child: CircularProgressIndicator())
                        else if (filterState.areasError != null)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Failed to load city corporations'),
                              8.h,
                              ElevatedButton(
                                onPressed: () =>
                                    filterNotifier.retryLoadAreas(),
                                child: const Text('Retry'),
                              ),
                            ],
                          )
                        else
                          DropdownButtonFormField<String>(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                            initialValue:
                                filterNotifier.cityCorporationDropdownItems
                                    .contains(_selectedCityCorporation)
                                ? _selectedCityCorporation
                                : null, // Clear selection if it's not in the available list
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
                      // Vaccine Selection (hidden in EPI details context)
                      if (!filterState.isEpiDetailsContext) ...[
                        const Text(
                          'Select Vaccine',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
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
                      ] else ...[
                        16.h, // Spacing when vaccine selection is hidden
                      ],
                      // Action Buttons
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    _isFilterButtonEnabled(filterState)
                                    ? Colors.blue
                                    : Colors.grey,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(5),
                                  ),
                                ),
                              ),
                              onPressed: _isFilterButtonEnabled(filterState)
                                  ? () => _applyFilters(
                                      filterNotifier: filterNotifier,
                                      filterState: filterState,
                                    )
                                  : null,
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
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(5),
                                  ),
                                ),
                              ),
                              onPressed: () => _resetFilters(
                                filterNotifier: filterNotifier,
                                filterState: filterState,
                              ),
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
