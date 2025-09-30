import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gis_dashboard/core/common/constants/constants.dart';
import 'package:gis_dashboard/core/utils/utils.dart';
import 'package:gis_dashboard/features/filter/presentation/widgets/custom_radio_button.dart';
import '../../domain/filter_state.dart';
import '../controllers/filter_controller.dart';
import '../../../map/utils/map_enums.dart';
import '../../../epi_center/presentation/controllers/epi_center_controller.dart';

class FilterDialogBoxWidget extends ConsumerStatefulWidget {
  final bool isEpiContext;

  const FilterDialogBoxWidget({super.key, this.isEpiContext = false});

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

  // Store initial values for reset functionality and change detection
  late AreaType _initialAreaType;
  late String _initialVaccine;
  late String _initialDivision;
  String? _initialCityCorporation;
  String? _initialDistrict;
  late String _initialYear;
  String? _initialUpazila;
  String? _initialUnion;
  String? _initialWard;
  String? _initialSubblock;

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

  @override
  void dispose() {
    // Clean up any resources
    _formKey.currentState?.dispose();

    super.dispose();
  }

  /// Initialize filter state properly for both normal and EPI contexts
  void _initializeFilterState() {
    final currentFilter = ref.read(filterControllerProvider);
    final filterNotifier = ref.read(filterControllerProvider.notifier);

    // Always preserve the current area type
    _selectedAreaType = currentFilter.selectedAreaType;
    _selectedVaccine = currentFilter.selectedVaccine;
    _selectedYear = currentFilter.selectedYear;

    // ✅ CRITICAL: Store initial values ONCE when dialog first opens
    // These values must NEVER be updated during the dialog's lifetime
    // This ensures we can compare against the original state in applyFilters
    _initialAreaType = currentFilter.selectedAreaType;
    _initialVaccine = currentFilter.selectedVaccine;
    _initialYear = currentFilter.selectedYear;

    logg.i('🎯 Filter Dialog: Capturing initial values from provider state:');
    logg.i('   Provider AreaType: ${currentFilter.selectedAreaType}');
    logg.i('   Provider Division: ${currentFilter.selectedDivision}');
    logg.i('   Provider District: ${currentFilter.selectedDistrict}');
    logg.i('   Provider Upazila: ${currentFilter.selectedUpazila}');
    logg.i('   Provider Union: ${currentFilter.selectedUnion}');
    logg.i('   Provider Ward: ${currentFilter.selectedWard}');
    logg.i('   Provider Subblock: ${currentFilter.selectedSubblock}');
    logg.i('   Provider Year: ${currentFilter.selectedYear}');
    logg.i('isEpiContext: ${widget.isEpiContext}');

    // Initialize based on area type
    if (_selectedAreaType == AreaType.district) {
      _initializeDistrictAreaType(currentFilter, filterNotifier);
    } else if (_selectedAreaType == AreaType.cityCorporation) {
      _initializeCityCorporationAreaType(currentFilter, filterNotifier);
    }
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

    // Store initial values for district area type - NEVER update these during dialog lifetime
    _initialDivision = _selectedDivision;
    _initialDistrict = _selectedDistrict;
    _initialCityCorporation = null;

    // Initialize extended hierarchical selections (for EPI details screen)
    if (widget.isEpiContext) {
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

      // Store initial hierarchical values - NEVER update these during dialog lifetime
      _initialUpazila = _selectedUpazila;
      _initialUnion = _selectedUnion;
      _initialWard = _selectedWard;
      _initialSubblock = _selectedSubblock;

      logg.i('🔧 EPI Filter Dialog: Initial hierarchical values stored');
      logg.i('   Initial Upazila: $_initialUpazila');
      logg.i('   Initial Union: $_initialUnion');
      logg.i('   Initial Ward: $_initialWard');
      logg.i('   Initial Subblock: $_initialSubblock');

      // Debug log all initial values for comparison
      logg.i('🔍 All Initial Values Captured:');
      logg.i('   _initialAreaType: $_initialAreaType');
      logg.i('   _initialVaccine: $_initialVaccine');
      logg.i('   _initialYear: $_initialYear');
      logg.i('   _initialDivision: $_initialDivision');
      logg.i('   _initialDistrict: $_initialDistrict');
      logg.i('   _initialCityCorporation: $_initialCityCorporation');
    } else {
      // For normal context, clear hierarchical selections
      _selectedUpazila = null;
      _selectedUnion = null;
      _selectedWard = null;
      _selectedSubblock = null;

      // Store initial hierarchical values as null for normal context
      _initialUpazila = null;
      _initialUnion = null;
      _initialWard = null;
      _initialSubblock = null;
    }

    // Clear city corporation selection for district area type any way
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

    // Store initial values for city corporation area type - NEVER update these during dialog lifetime
    _initialDivision = 'All';
    _initialDistrict = null;
    _initialCityCorporation = _selectedCityCorporation;
    _initialUpazila = null;
    _initialUnion = null;
    _initialWard = null;
    _initialSubblock = null;
  }

  /// Initialize state when area type changes via radio buttons
  void _handleFilterViewOnRadioButtonTap() {
    final currentFilter = ref.read(filterControllerProvider);

    if (!widget.isEpiContext) {
      // For normal context, reset hierarchical selections
      _selectedUpazila = null;
      _selectedUnion = null;
      _selectedWard = null;
      _selectedSubblock = null;

      if (_selectedAreaType == AreaType.district &&
          currentFilter.selectedAreaType == AreaType.cityCorporation) {
        // Switching from CC to District: reset to defaults
        _selectedDivision = 'All';
        _selectedDistrict = null;
      } else if (_selectedAreaType == AreaType.cityCorporation &&
          currentFilter.selectedAreaType == AreaType.district) {
        // Switching from District to CC: reset to defaults
        _selectedCityCorporation = null;
      }
    } else {
      if (_selectedAreaType == AreaType.district &&
          currentFilter.selectedAreaType == AreaType.cityCorporation) {
        // Switching from CC to District: reset to defaults
        _selectedDivision = 'All';
        _selectedDistrict = null;
        _selectedUpazila = null;
        _selectedUnion = null;
        _selectedWard = null;
        _selectedSubblock = null;
      } else if (_selectedAreaType == AreaType.cityCorporation &&
          currentFilter.selectedAreaType == AreaType.district) {
        // Switching from District to CC: reset to defaults for only CC as hierarchical levels will be preserved
        _selectedCityCorporation = null;
      }
    }
  }

  /// Sync local widget state with provider state (used after reset)
  void _syncLocalStateWithProvider() {
    setState(() {
      _initializeFilterState();
    });
  }

  /// Check if any values have changed from initial values
  bool _hasValuesChanged() {
    final hasChanged =
        _selectedAreaType != _initialAreaType ||
        _selectedVaccine != _initialVaccine ||
        _selectedDivision != _initialDivision ||
        _selectedCityCorporation != _initialCityCorporation ||
        _selectedDistrict != _initialDistrict ||
        _selectedYear != _initialYear ||
        _selectedUpazila != _initialUpazila ||
        _selectedUnion != _initialUnion ||
        _selectedWard != _initialWard ||
        _selectedSubblock != _initialSubblock;

    // if (hasChanged) {
    //   logg.i('🔄 Filter values changed detected:');
    //   if (_selectedAreaType != _initialAreaType) {
    //     logg.i('   AreaType: $_initialAreaType → $_selectedAreaType');
    //   }
    //   if (_selectedVaccine != _initialVaccine) {
    //     logg.i('   Vaccine: $_initialVaccine → $_selectedVaccine');
    //   }
    //   if (_selectedDivision != _initialDivision) {
    //     logg.i('   Division: $_initialDivision → $_selectedDivision');
    //   }
    //   if (_selectedDistrict != _initialDistrict) {
    //     logg.i('   District: $_initialDistrict → $_selectedDistrict');
    //   }
    //   if (_selectedYear != _initialYear) {
    //     logg.i('   Year: $_initialYear → $_selectedYear');
    //   }
    //   if (_selectedUpazila != _initialUpazila) {
    //     logg.i('   Upazila: $_initialUpazila → $_selectedUpazila');
    //   }
    //   if (_selectedUnion != _initialUnion) {
    //     logg.i('   Union: $_initialUnion → $_selectedUnion');
    //   }
    //   if (_selectedWard != _initialWard) {
    //     logg.i('   Ward: $_initialWard → $_selectedWard');
    //   }
    //   if (_selectedSubblock != _initialSubblock) {
    //     logg.i('   Subblock: $_initialSubblock → $_selectedSubblock');
    //   }
    // }

    return hasChanged;
  }

  /// Reset all selections to initial values
  void _resetToInitialValues() {
    setState(() {
      _selectedAreaType = _initialAreaType;
      _selectedVaccine = _initialVaccine;
      _selectedDivision = _initialDivision;
      _selectedCityCorporation = _initialCityCorporation;
      _selectedDistrict = _initialDistrict;
      _selectedYear = _initialYear;
      _selectedUpazila = _initialUpazila;
      _selectedUnion = _initialUnion;
      _selectedWard = _initialWard;
      _selectedSubblock = _initialSubblock;
    });
  }

  void _applyFilters({
    required FilterState filterState,
    required FilterControllerNotifier filterNotifier,
  }) {
    // Apply filters to global state with timestamp
    final isEpiContext = widget.isEpiContext;
    // Check if EPI is from City Corporation (detect by checking current EPI data)
    final epiState = ref.read(epiCenterControllerProvider);
    final epiData = epiState.epiCenterData;
    final isEpiFromCC =
        epiData?.cityCorporationName != null &&
        epiData!.cityCorporationName!.isNotEmpty;

    // For EPI from City Corporation: buttons do nothing (null behavior)
    if (isEpiContext && isEpiFromCC) {
      Navigator.of(context).pop();
      return; // Do nothing - no navigation pop, no filter application
    }

    // Check if any values have changed from initial values
    if (!_hasValuesChanged()) {
      logg.i('🔄 No filter changes detected - closing dialog');
      Navigator.of(context).pop();
      return;
    }

    logg.i('🚀 Applying filters with current selections:');
    logg.i(
      '   Current AreaType: $_selectedAreaType vs Initial: $_initialAreaType',
    );
    logg.i(
      '   Current Division: $_selectedDivision vs Initial: $_initialDivision',
    );
    logg.i(
      '   Current District: $_selectedDistrict vs Initial: $_initialDistrict',
    );
    logg.i(
      '   Current Upazila: $_selectedUpazila vs Initial: $_initialUpazila',
    );
    logg.i('   Current Union: $_selectedUnion vs Initial: $_initialUnion');
    logg.i('   Current Ward: $_selectedWard vs Initial: $_initialWard');
    logg.i(
      '   Current Subblock: $_selectedSubblock vs Initial: $_initialSubblock',
    );
    logg.i('   Current Year: $_selectedYear vs Initial: $_initialYear');

    // Only apply the changed values to avoid triggering unnecessary hierarchical loading
    final Map<String, dynamic> changedValues = {};

    if (_selectedAreaType != _initialAreaType) {
      changedValues['areaType'] = _selectedAreaType;
    }
    if (!isEpiContext && _selectedVaccine != _initialVaccine) {
      changedValues['vaccine'] = _selectedVaccine;
    }
    if (_selectedYear != _initialYear) {
      changedValues['year'] = _selectedYear;
    }

    if (_selectedAreaType == AreaType.district) {
      if (_selectedDivision != _initialDivision) {
        changedValues['division'] = _selectedDivision;
      }
      if (_selectedDistrict != _initialDistrict) {
        changedValues['district'] = _selectedDistrict;
      }

      if (isEpiContext) {
        if (_selectedUpazila != _initialUpazila) {
          changedValues['upazila'] = _selectedUpazila;
        }
        if (_selectedUnion != _initialUnion) {
          changedValues['union'] = _selectedUnion;
        }
        if (_selectedWard != _initialWard) {
          changedValues['ward'] = _selectedWard;
        }
        if (_selectedSubblock != _initialSubblock) {
          changedValues['subblock'] = _selectedSubblock;
        }
      }
    } else if (_selectedAreaType == AreaType.cityCorporation) {
      if (_selectedCityCorporation != _initialCityCorporation) {
        changedValues['cityCorporation'] = _selectedCityCorporation;
      }
    }

    // ✅ Apply all current selections (not just changed values) but pass initial values for comparison
    // The key insight: we pass the current _selectedXXX values but the controller will use
    // our stored _initialXXX values to determine what actually changed
    filterNotifier.applyFiltersWithInitialValues(
      // Current selections
      vaccine: !isEpiContext ? _selectedVaccine : null,
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
      // Initial values for comparison
      initialVaccine: _initialVaccine,
      initialAreaType: _initialAreaType,
      initialYear: _initialYear,
      initialDivision: _initialDivision,
      initialDistrict: _initialDistrict,
      initialCityCorporation: _initialCityCorporation,
      initialUpazila: _initialUpazila,
      initialUnion: _initialUnion,
      initialWard: _initialWard,
      initialSubblock: _initialSubblock,
    );

    Navigator.of(context).pop();
  }

  void _resetFilters({
    required FilterState filterState,
    required FilterControllerNotifier filterNotifier,
  }) {
    final isEpiContext = widget.isEpiContext;

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

    logg.i('🔄 Resetting filters to initial values');

    if (isEpiContext) {
      // For EPI context, reset to initial values (the values when dialog was first opened)
      _resetToInitialValues();

      // Apply the reset values to the provider to restore the EPI context
      filterNotifier.applyFilters(
        vaccine: null, // No vaccine in EPI context
        areaType: _initialAreaType,
        year: _initialYear,
        division: _initialAreaType == AreaType.district
            ? _initialDivision
            : null,
        district: _initialAreaType == AreaType.district
            ? _initialDistrict
            : null,
        cityCorporation: _initialAreaType == AreaType.cityCorporation
            ? _initialCityCorporation
            : null,
        upazila: _initialAreaType == AreaType.district ? _initialUpazila : null,
        union: _initialAreaType == AreaType.district ? _initialUnion : null,
        ward: _initialAreaType == AreaType.district ? _initialWard : null,
        subblock: _initialAreaType == AreaType.district
            ? _initialSubblock
            : null,
      );
    } else {
      // For normal context, reset filters to default
      filterNotifier.resetFilters();
      // Sync local state with provider state after reset
      _syncLocalStateWithProvider();
    }

    Navigator.of(context).pop();
  }

  /// Check if filter button should be enabled
  bool _isFilterButtonEnabled(FilterState filterState) {
    final isEpiContext = widget.isEpiContext;

    // Check if EPI is from City Corporation
    final epiState = ref.read(epiCenterControllerProvider);
    final epiData = epiState.epiCenterData;
    final isEpiFromCC =
        epiData?.cityCorporationName != null &&
        epiData!.cityCorporationName!.isNotEmpty;

    // For EPI from City Corporation, disable both buttons (no filtering allowed)
    if (isEpiContext && isEpiFromCC) {
      return false;
    }

    // For non-EPI context, always enable (basic filtering always allowed)
    if (!isEpiContext) {
      return true;
    }

    // Ensure hierarchical consistency
    if (_selectedWard != null && _selectedUnion == null) {
      return false; // Invalid state
    }

    // For district-based EPI context, enable if any hierarchical level is selected
    // (or if values have changed from initial - allow reset to work)
    // if areatype is district and any specific level is not selected then button is disabled
    if (_selectedAreaType == AreaType.district) {
      // Allow if any specific level is selected OR if values have changed
      // Option 1: Require ALL fields to be selected (strict)
      return (_selectedDivision != 'All' &&
              _selectedDistrict != null &&
              _selectedUpazila != null &&
              _selectedUnion != null &&
              _selectedWard != null &&
              _selectedSubblock != null) ||
          _hasValuesChanged();
    }

    // For CC area type in EPI context, enable if CC is selected
    if (_selectedAreaType == AreaType.cityCorporation) {
      return _selectedCityCorporation != null || _hasValuesChanged();
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Color(Constants.primaryColor);
    final filterState = ref.watch(filterControllerProvider);
    final filterNotifier = ref.read(filterControllerProvider.notifier);

    // Sync local selections with provider state when dropdown items change
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        // Validate district selection
        if (_selectedDistrict != null &&
            !filterNotifier.districtDropdownItems.contains(_selectedDistrict)) {
          _selectedDistrict = null;
        }

        // Validate hierarchical selections (for EPI context)
        if (widget.isEpiContext) {
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

    return
    //  filterState.isLoadingAreas
    //     ? const Center(
    //         child: CustomLoadingWidget(loadingText: 'Updating filter...'),
    //       )
    //     :
    Padding(
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
                    Row(
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
                              _handleFilterViewOnRadioButtonTap();
                            });
                          },
                        ),
                        const Text('District'),
                      ],
                    ),
                    12.w,
                    Row(
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
                              _handleFilterViewOnRadioButtonTap();
                            });
                          },
                        ),
                        const Text('City Corporation'),
                      ],
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
                  initialValue: _selectedYear,
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
                if (_selectedAreaType == AreaType.district) ...[
                  // Division Dropdown
                  const Text(
                    'Division',
                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
                  ),
                  8.h,
                  if (filterState.areasError != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Failed to load divisions'),
                        8.h,
                        ElevatedButton(
                          onPressed: () => filterNotifier.retryLoadAreas(),
                          child: const Text('Retry'),
                        ),
                      ],
                    )
                  else if (!filterState.isLoadingAreas)
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
                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
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
                  if (widget.isEpiContext) ...[
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
                ] else if (_selectedAreaType == AreaType.cityCorporation) ...[
                  // City Corporation Dropdown
                  const Text(
                    'City Corporation',
                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
                  ),
                  8.h,
                  if (filterState.areasError != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Failed to load city corporations'),
                        8.h,
                        ElevatedButton(
                          onPressed: () => filterNotifier.retryLoadAreas(),
                          child: const Text('Retry'),
                        ),
                      ],
                    )
                  else if (!filterState.isLoadingAreas)
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      initialValue:
                          filterNotifier.cityCorporationDropdownItems.contains(
                            _selectedCityCorporation,
                          )
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
                if (!widget.isEpiContext) ...[
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
                            CustomRadioButton(
                              label: 'Penta - 1st',
                              primaryColor: primaryColor,
                              selectedVaccine: _selectedVaccine,
                              onChanged: (val) {
                                setState(() {
                                  _selectedVaccine = val;
                                });
                              },
                            ),
                            CustomRadioButton(
                              label: 'Penta - 2nd',
                              primaryColor: primaryColor,
                              selectedVaccine: _selectedVaccine,
                              onChanged: (val) {
                                setState(() {
                                  _selectedVaccine = val;
                                });
                              },
                            ),
                            CustomRadioButton(
                              label: 'Penta - 3rd',
                              primaryColor: primaryColor,
                              selectedVaccine: _selectedVaccine,
                              onChanged: (val) {
                                setState(() {
                                  _selectedVaccine = val;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      // Second column
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 4,
                          children: [
                            CustomRadioButton(
                              label: 'MR - 1st',
                              primaryColor: primaryColor,
                              selectedVaccine: _selectedVaccine,
                              onChanged: (val) {
                                setState(() {
                                  _selectedVaccine = val;
                                });
                              },
                            ),
                            CustomRadioButton(
                              label: 'MR - 2nd',
                              primaryColor: primaryColor,
                              selectedVaccine: _selectedVaccine,
                              onChanged: (val) {
                                setState(() {
                                  _selectedVaccine = val;
                                });
                              },
                            ),
                            CustomRadioButton(
                              label: 'BCG',
                              primaryColor: primaryColor,
                              selectedVaccine: _selectedVaccine,
                              onChanged: (val) {
                                setState(() {
                                  _selectedVaccine = val;
                                });
                              },
                            ),
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
                          backgroundColor: _isFilterButtonEnabled(filterState)
                              ? Colors.blue
                              : Colors.grey,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
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
                            borderRadius: BorderRadius.all(Radius.circular(5)),
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
}
