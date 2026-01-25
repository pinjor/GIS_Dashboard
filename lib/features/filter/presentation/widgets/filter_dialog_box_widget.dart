import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gis_dashboard/core/common/constants/constants.dart';
import 'package:gis_dashboard/core/common/enums/vaccine_type.dart';
import 'package:gis_dashboard/core/utils/utils.dart';
import 'package:gis_dashboard/features/filter/presentation/widgets/custom_radio_button.dart';
import '../../domain/filter_state.dart';
import '../controllers/filter_controller.dart';
import '../../../map/utils/map_enums.dart';
import '../../../epi_center/presentation/controllers/epi_center_controller.dart';

class FilterDialogBoxWidget extends ConsumerStatefulWidget {
  final bool isEpiContext;
  final bool isMicroplanContext;

  const FilterDialogBoxWidget({
    super.key,
    this.isEpiContext = false,
    this.isMicroplanContext = false,
  });

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
  String? _selectedZone;
  late String _selectedYear;

  // Extended hierarchical selections (for EPI details screen)
  String? _selectedUpazila;
  String? _selectedUnion;
  String? _selectedWard;
  String? _selectedSubblock;
  List<String> _selectedMonths = []; // Local state for selected months

  // Store initial values for reset functionality and change detection
  late AreaType _initialAreaType;
  late String _initialVaccine;
  late String _initialDivision;
  String? _initialCityCorporation;
  String? _initialDistrict;
  String? _initialZone;
  late String _initialYear;
  String? _initialUpazila;
  String? _initialUnion;
  String? _initialWard;
  String? _initialSubblock;
  List<String> _initialMonths = []; // Initial state for selected months

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
  Future<void> _initializeFilterState() async {
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
    _initialAreaType = currentFilter.selectedAreaType;
    _initialVaccine = currentFilter.selectedVaccine;
    _initialYear = currentFilter.selectedYear;
    _initialMonths = List.from(currentFilter.selectedMonths); // Deep copy
    _selectedMonths = List.from(
      currentFilter.selectedMonths,
    ); // Initialize local selection

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

    // ✅ FIX: Initialize based on area type - prioritize CC view in EPI+CC context
    if (widget.isEpiContext &&
        currentFilter.selectedAreaType == AreaType.cityCorporation) {
      // Show CC filter view first when in EPI context with CC area type
      logg.i('🎯 EPI+CC Context: Showing CC filter view directly');
      _initializeCityCorporationAreaType(currentFilter, filterNotifier);
    } else if (_selectedAreaType == AreaType.district) {
      await _initializeDistrictAreaType(currentFilter, filterNotifier);
    } else if (_selectedAreaType == AreaType.cityCorporation) {
      _initializeCityCorporationAreaType(currentFilter, filterNotifier);
    }
  }

  /// Initialize district area type selections
  Future<void> _initializeDistrictAreaType(
    FilterState currentFilter,
    FilterControllerNotifier filterNotifier,
  ) async {
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

    // Initialize extended hierarchical selections (for both EPI context and main screen filtering)
    // ✅ FIX: Allow hierarchical selections in non-EPI context for upazila-level filtering
    final availableUpazilas = filterNotifier.upazilaDropdownItems;
    if (currentFilter.selectedUpazila != null &&
        availableUpazilas.contains(currentFilter.selectedUpazila)) {
      _selectedUpazila = currentFilter.selectedUpazila;
    } else {
      _selectedUpazila = null;
    }

    // ✅ FIX: Preserve union selection even if unions list isn't loaded yet
    // This prevents the union value from being lost when the filter dialog opens
    final availableUnions = filterNotifier.unionDropdownItems;
    if (currentFilter.selectedUnion != null) {
      if (availableUnions.contains(currentFilter.selectedUnion)) {
        _selectedUnion = currentFilter.selectedUnion;
      } else if (availableUnions.isEmpty) {
        // If unions list is empty, preserve the selected union value
        // It will be validated later when unions are loaded
        _selectedUnion = currentFilter.selectedUnion;
        logg.i('Preserving union selection "${currentFilter.selectedUnion}" even though unions list is empty');
      } else {
        // Unions list is loaded but doesn't contain the selected union
        _selectedUnion = null;
        logg.w('Union "${currentFilter.selectedUnion}" not found in available unions: $availableUnions');
      }
    } else {
      _selectedUnion = null;
    }

    // ✅ FIX: Preserve ward selection even if wards list isn't loaded yet
    // This prevents the ward value from being lost when the filter dialog opens
    final availableWards = filterNotifier.wardDropdownItems;
    if (currentFilter.selectedWard != null) {
      if (availableWards.contains(currentFilter.selectedWard)) {
        _selectedWard = currentFilter.selectedWard;
      } else if (availableWards.isEmpty) {
        // If wards list is empty, preserve the selected ward value
        // It will be validated later when wards are loaded
        _selectedWard = currentFilter.selectedWard;
        logg.i('Preserving ward selection "${currentFilter.selectedWard}" even though wards list is empty');
      } else {
        // Wards list is loaded but doesn't contain the selected ward
        _selectedWard = null;
        logg.w('Ward "${currentFilter.selectedWard}" not found in available wards: $availableWards');
      }
    } else {
      _selectedWard = null;
    }

    // ✅ FIX: Preserve subblock selection even if subblocks list isn't loaded yet
    // This prevents the subblock value from being lost when the filter dialog opens
    final availableSubblocks = filterNotifier.subblockDropdownItems;
    if (currentFilter.selectedSubblock != null) {
      if (availableSubblocks.contains(currentFilter.selectedSubblock)) {
        _selectedSubblock = currentFilter.selectedSubblock;
      } else if (availableSubblocks.isEmpty) {
        // If subblocks list is empty, preserve the selected subblock value
        // It will be validated later when subblocks are loaded
        _selectedSubblock = currentFilter.selectedSubblock;
        logg.i('Preserving subblock selection "${currentFilter.selectedSubblock}" even though subblocks list is empty');
      } else {
        // Subblocks list is loaded but doesn't contain the selected subblock
        _selectedSubblock = null;
        logg.w('Subblock "${currentFilter.selectedSubblock}" not found in available subblocks: $availableSubblocks');
      }
    } else {
      _selectedSubblock = null;
    }

    // Store initial hierarchical values - NEVER update these during dialog lifetime
    _initialUpazila = _selectedUpazila;
    _initialUnion = _selectedUnion;
    _initialWard = _selectedWard;
    _initialSubblock = _selectedSubblock;


    // ✅ FIX: Reload unions if upazila is selected but unions list is empty
    // This must happen BEFORE trying to reload wards
    if (_selectedUpazila != null &&
        _selectedUpazila != 'All' &&
        currentFilter.unions.isEmpty) {
      logg.i(
        "🔄 Upazila selected but unions list empty, reloading unions for: $_selectedUpazila",
      );
      final upazilaUid = filterNotifier.getUpazilaUid(_selectedUpazila!);
      if (upazilaUid != null) {
        await filterNotifier.loadUnionsByUpazila(upazilaUid);
        // Refresh currentFilter after loading unions
        final updatedFilter = ref.read(filterControllerProvider);
        // Update _selectedUnion if it was preserved
        if (_selectedUnion != null && updatedFilter.unions.isNotEmpty) {
          final unionExists = updatedFilter.unions.any((u) => u.name == _selectedUnion);
          if (!unionExists) {
            logg.w('Preserved union "$_selectedUnion" not found in loaded unions');
            _selectedUnion = null;
          }
        }
      } else {
        logg.w(
          "⚠️ Could not get upazila UID for $_selectedUpazila to reload unions",
        );
      }
    }

    // ✅ FIX: Reload wards if union is selected but wards list is empty
    if (_selectedUnion != null &&
        _selectedUnion != 'All' &&
        currentFilter.wards.isEmpty) {
      logg.i(
        "🔄 Union selected but wards list empty, reloading wards for: $_selectedUnion",
      );
      // Get fresh filter state in case unions were just loaded
      final freshFilterState = ref.read(filterControllerProvider);
      final unionUid = filterNotifier.getUnionUid(_selectedUnion!);
      if (unionUid != null) {
        await filterNotifier.loadWardsByUnion(unionUid);
        // Refresh and update _selectedWard if it was preserved
        final updatedFilter = ref.read(filterControllerProvider);
        if (_selectedWard != null && updatedFilter.wards.isNotEmpty) {
          final wardExists = updatedFilter.wards.any((w) => w.name == _selectedWard);
          if (!wardExists) {
            logg.w('Preserved ward "$_selectedWard" not found in loaded wards');
            _selectedWard = null;
          }
        }
      } else {
        logg.w(
          "⚠️ Could not get union UID for $_selectedUnion to reload wards. "
          "Available unions: ${freshFilterState.unions.map((u) => u.name).toList()}",
        );
      }
    }

    // ✅ FIX: Reload subblocks if ward is selected but subblocks list is empty
    if (_selectedWard != null &&
        _selectedWard != 'All' &&
        currentFilter.subblocks.isEmpty) {
      logg.i(
        "🔄 Ward selected but subblocks list empty, reloading subblocks for: $_selectedWard",
      );
      // Get fresh filter state in case wards were just loaded
      final freshFilterState = ref.read(filterControllerProvider);
      final wardUid = filterNotifier.getWardUid(_selectedWard!);
      if (wardUid != null) {
        // Load subblocks directly using the public method
        await filterNotifier.loadSubblocksByWard(wardUid);
        // Refresh and update _selectedSubblock if it was preserved
        final updatedFilter = ref.read(filterControllerProvider);
        if (_selectedSubblock != null && updatedFilter.subblocks.isNotEmpty) {
          final subblockExists = updatedFilter.subblocks.any((s) => s.name == _selectedSubblock);
          if (!subblockExists) {
            logg.w('Preserved subblock "$_selectedSubblock" not found in loaded subblocks');
            _selectedSubblock = null;
          }
        }
      } else {
        logg.w(
          "⚠️ Could not get ward UID for $_selectedWard to reload subblocks. "
          "Available wards: ${freshFilterState.wards.map((w) => w.name).toList()}",
        );
      }
    }

    logg.i('🔧 Filter Dialog: Initial hierarchical values stored');
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

    // Clear city corporation selection for district area type any way
    _selectedCityCorporation = null;
  }

  /// Initialize city corporation area type selections
  void _initializeCityCorporationAreaType(
    FilterState currentFilter,
    FilterControllerNotifier filterNotifier,
  ) {
    // ✅ FIX: Always show current CC, especially in EPI context
    final availableCityCorporations =
        filterNotifier.cityCorporationDropdownItems;
    if (currentFilter.selectedCityCorporation != null &&
        availableCityCorporations.contains(
          currentFilter.selectedCityCorporation,
        )) {
      _selectedCityCorporation = currentFilter.selectedCityCorporation;
      logg.i('✅ CC Field: Set to current CC - $_selectedCityCorporation');
    } else {
      // In EPI context, still try to set the current CC even if validation fails
      if (widget.isEpiContext &&
          currentFilter.selectedCityCorporation != null) {
        _selectedCityCorporation = currentFilter.selectedCityCorporation;
        logg.i(
          '🔧 EPI Context: Force setting CC field - $_selectedCityCorporation',
        );
      } else {
        _selectedCityCorporation = null;
      }
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
    _initialZone = null;
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
    // For microplan context, don't check vaccine and months changes
    final hasChanged =
        _selectedAreaType != _initialAreaType ||
        (!widget.isMicroplanContext && _selectedVaccine != _initialVaccine) ||
        _selectedDivision != _initialDivision ||
        _selectedCityCorporation != _initialCityCorporation ||
        _selectedZone != _initialZone ||
        _selectedDistrict != _initialDistrict ||
        _selectedYear != _initialYear ||
        _selectedUpazila != _initialUpazila ||
        _selectedUnion != _initialUnion ||
        _selectedWard != _initialWard ||
        _selectedSubblock != _initialSubblock ||
        (!widget.isMicroplanContext && _areMonthsChanged()); // Check for months changes only if not microplan context

    return hasChanged;
  }

  bool _areMonthsChanged() {
    if (_selectedMonths.length != _initialMonths.length) return true;
    final currentSet = _selectedMonths.toSet();
    final initialSet = _initialMonths.toSet();
    return currentSet.difference(initialSet).isNotEmpty ||
        initialSet.difference(currentSet).isNotEmpty;
  }

  // /// Reset all selections to initial values
  // void _resetToInitialValues() {
  //   setState(() {
  //     _selectedAreaType = _initialAreaType;
  //     _selectedVaccine = _initialVaccine;
  //     _selectedDivision = _initialDivision;
  //     _selectedCityCorporation = _initialCityCorporation;
  //     _selectedDistrict = _initialDistrict;
  //     _selectedYear = _initialYear;
  //     _selectedUpazila = _initialUpazila;
  //     _selectedUnion = _initialUnion;
  //     _selectedWard = _initialWard;
  //     _selectedSubblock = _initialSubblock;
  //   });
  // }

  void _applyFilters({
    required FilterState filterState,
    required FilterControllerNotifier filterNotifier,
  }) {
    // Apply filters to global state with timestamp
    final isEpiContext = widget.isEpiContext;
    // ✅ FIX: Check if EPI is from City Corporation using filter state (more reliable)
    final filterState = ref.read(filterControllerProvider);
    final isEpiFromCC =
        filterState.selectedAreaType == AreaType.cityCorporation;

    // ✅ FIX: Enhanced CC+EPI context handling - fetch CC data if different CC selected
    if (isEpiContext && isEpiFromCC) {
      logg.i('🏙️ CC+EPI Context: Checking for CC changes');
      logg.i('   Selected CC: $_selectedCityCorporation');
      logg.i('   Initial CC: $_initialCityCorporation');

      // ✅ FIX: Always fetch CC data (supports both refresh same CC + switch to different CC)
      if (_selectedCityCorporation != null) {
        final isRefreshingSameCC =
            _selectedCityCorporation == _initialCityCorporation;

        logg.i(
          isRefreshingSameCC
              ? '🔄 Same CC selected: Refreshing data for $_selectedCityCorporation'
              : '🔄 CC Changed: Fetching whole CC EPI data for $_selectedCityCorporation',
        );

        // Get CC UID for API call
        final ccUid = filterNotifier.getCityCorporationUid(
          _selectedCityCorporation!,
        );
        if (ccUid != null) {
          // ✅ FIX: Update initial values before API call (avoids setState after pop)
          _initialCityCorporation = _selectedCityCorporation;
          logg.i(
            '🔄 Updated _initialCityCorporation to: $_initialCityCorporation',
          );

          // Fetch whole CC's EPI data using existing method
          final epiController = ref.read(epiCenterControllerProvider.notifier);
          Future.microtask(() async {
            try {
              await epiController.fetchEpiCenterDataByOrgUid(
                orgUid: ccUid,
                year: _selectedYear,
              );
              logg.i(
                '✅ Successfully loaded whole CC EPI data for $_selectedCityCorporation',
              );
            } catch (e) {
              logg.e('❌ Error loading CC EPI data: $e');
            }
          });
        } else {
          logg.w('⚠️ Could not find UID for CC: $_selectedCityCorporation');
        }
      } else {
        logg.w('⚠️ No CC selected for fetching');
      }

      Navigator.of(context).pop();
      return;
    }

    // For microplan context, always apply filters (even if no changes detected)
    // This ensures data reload happens when filter button is clicked
    final shouldApplyFilters = widget.isMicroplanContext || _hasValuesChanged();
    
    if (!shouldApplyFilters) {
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
      '   Current CityCorporation: $_selectedCityCorporation vs Initial: $_initialCityCorporation',
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
    logg.i('   Current Months: $_selectedMonths vs Initial: $_initialMonths');

    // 🔍 DEBUG: Log vaccine selection status
    logg.i('🧪 FILTER DIALOG: Vaccine selection status:');
    logg.i('   isEpiContext: $isEpiContext');
    logg.i('   _selectedVaccine: "$_selectedVaccine"');
    logg.i('   _initialVaccine: "$_initialVaccine"');
    logg.i('   Changed: ${_selectedVaccine != _initialVaccine}');

    // Only apply the changed values to avoid triggering unnecessary hierarchical loading
    final Map<String, dynamic> changedValues = {};

    if (_selectedAreaType != _initialAreaType) {
      changedValues['areaType'] = _selectedAreaType;
    }
    if (!isEpiContext && !widget.isMicroplanContext && _selectedVaccine != _initialVaccine) {
      changedValues['vaccine'] = _selectedVaccine;
      logg.i(
        '🧪 FILTER DIALOG: ✅ Vaccine change will be applied: "$_selectedVaccine"',
      );
    } else if ((isEpiContext || widget.isMicroplanContext) && _selectedVaccine != _initialVaccine) {
      // 🔍 DEBUG: This is the critical line - vaccine is being SKIPPED in EPI/microplan context!
      logg.w(
        '🧪 FILTER DIALOG: ⚠️ Vaccine change SKIPPED because isEpiContext=$isEpiContext or isMicroplanContext=${widget.isMicroplanContext}! Selected: "$_selectedVaccine"',
      );
    }
    if (_selectedYear != _initialYear) {
      changedValues['year'] = _selectedYear;
    }
    // Only apply months filter if not in microplan context
    if (!widget.isMicroplanContext && _areMonthsChanged()) {
      changedValues['months'] = _selectedMonths;
    }

    if (_selectedAreaType == AreaType.district) {
      if (_selectedDivision != _initialDivision) {
        changedValues['division'] = _selectedDivision;
      }
      if (_selectedDistrict != _initialDistrict) {
        changedValues['district'] = _selectedDistrict;
      }

      // ✅ FIX: Apply hierarchical filters for both EPI context and main filter
      // Ward and subblock should be available in main filter too
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
    } else if (_selectedAreaType == AreaType.cityCorporation) {
      if (_selectedCityCorporation != _initialCityCorporation) {
        changedValues['cityCorporation'] = _selectedCityCorporation;
      }
      if (_selectedZone != _initialZone) {
        changedValues['zone'] = _selectedZone;
      }
    }

    // ✅ Apply all current selections (not just changed values) but pass initial values for comparison
    // The key insight: we pass the current _selectedXXX values but the controller will use
    // our stored _initialXXX values to determine what actually changed
    logg.i('🔧 Microplan Filter: Applying filters with forceTimestampUpdate=${widget.isMicroplanContext}');
    filterNotifier.applyFiltersWithInitialValues(
      // Current selections
      vaccine: (!isEpiContext && !widget.isMicroplanContext) ? _selectedVaccine : null,
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
      zone: _selectedAreaType == AreaType.cityCorporation
          ? _selectedZone
          : null,
      // ✅ FIX: Allow hierarchical filtering in non-EPI context (for upazila-level map/summary filtering)
      upazila: _selectedAreaType == AreaType.district
          ? _selectedUpazila
          : null,
      union: _selectedAreaType == AreaType.district
          ? _selectedUnion
          : null,
      ward: _selectedAreaType == AreaType.district
          ? _selectedWard
          : null,
      subblock: _selectedAreaType == AreaType.district
          ? _selectedSubblock
          : null,
      months: (!isEpiContext && !widget.isMicroplanContext) ? _selectedMonths : null, // Pass selected months
      // Initial values for comparison
      initialVaccine: _initialVaccine,
      initialAreaType: _initialAreaType,
      initialYear: _initialYear,
      initialMonths: _initialMonths, // Pass initial months
      initialDivision: _initialDivision,
      initialDistrict: _initialDistrict,
      initialCityCorporation: _initialCityCorporation,
      initialZone: _initialZone,
      initialUpazila: _initialUpazila,
      initialUnion: _initialUnion,
      initialWard: _initialWard,
      initialSubblock: _initialSubblock,
      forceTimestampUpdate: widget.isMicroplanContext, // ✅ Force timestamp update for microplan context
    );
    
    if (widget.isMicroplanContext) {
      logg.i('✅ Microplan Filter: Filters applied with forced timestamp update');
    }

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

    // ✅ FIX: CC+EPI context reset - just pop dialog, no actual reset
    if (isEpiContext && isEpiFromCC) {
      logg.i('🏙️ CC+EPI Context: Reset just closes dialog (no actual reset)');
      Navigator.of(context).pop();
      return;
    }

    logg.i('🔄 Resetting filters to initial values');

    if (isEpiContext) {
      // ✅ NEW: Extended filter reset - return to original First EDS
      logg.i('🔄 Extended Filter Reset: Restoring to original First EDS');
      filterNotifier.resetToOriginalEpiState();
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
    final isMicroplanContext = widget.isMicroplanContext;

    // Check if EPI is from City Corporation
    // ✅ FIX: Check if EPI is from City Corporation using filter state (more reliable)
    final isEpiFromCC =
        filterState.selectedAreaType == AreaType.cityCorporation;

    // ✅ FIX: CC+EPI context - always enable for any CC selection (allows refresh + switching)
    if (isEpiContext && isEpiFromCC) {
      // Enable for any CC selection (same CC = refresh data, different CC = switch CC)
      return _selectedCityCorporation != null;
    }

    // For microplan context, always enable filter button (allows data refresh)
    if (isMicroplanContext) {
      return true;
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
    // Generate years from current year down to 2024
    final int currentYear = DateTime.now().year;
    final int startYear = 2024;
    final List<String> years = List.generate(
      currentYear - startYear + 1,
      (index) => (currentYear - index).toString(),
    );
    // Sync local selections with provider state when dropdown items change
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        // Validate district selection
        if (_selectedDistrict != null &&
            !filterNotifier.districtDropdownItems.contains(_selectedDistrict)) {
          _selectedDistrict = null;
        }

        // ✅ FIX: Validate hierarchical selections for both EPI context and main screen filtering
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

        // ✅ FIX: Only clear ward selection if wards are loaded and ward doesn't exist
        // Don't clear if wards list is empty (they might be loading)
        final availableWards = filterNotifier.wardDropdownItems;
        if (_selectedWard != null &&
            availableWards.isNotEmpty &&
            !availableWards.contains(_selectedWard)) {
          logg.w('Clearing invalid ward selection "$_selectedWard" - not in available wards: $availableWards');
          _selectedWard = null;
        }

        // Validate subblock selection
        if (_selectedSubblock != null &&
            !filterNotifier.subblockDropdownItems.contains(
              _selectedSubblock,
            )) {
          _selectedSubblock = null;
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
                  items: years
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
                // Month Selection (Only in normal context, not in microplan context)
                if (!widget.isEpiContext && !widget.isMicroplanContext) ...[
                  16.h,
                  const Text(
                    'Months',
                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
                  ),
                  8.h,
                  _buildMonthFilter(context, filterNotifier),
                ],
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
                        // Clear child selections when district changes
                        _selectedUpazila = null;
                        _selectedUnion = null;
                        _selectedWard = null;
                      });
                      // Trigger upazila loading
                      filterNotifier.updateDistrict(value);
                    },
                  ),

                  // Extended hierarchical fields (for District area type in non-EPI context, or EPI context)
                  if ((_selectedAreaType == AreaType.district &&
                          !widget.isEpiContext) ||
                      widget.isEpiContext) ...[
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
                    // ✅ FIX: Make union dropdown reactive to state changes
                    Builder(
                      builder: (context) {
                        // Watch filter state to reactively update when unions are loaded
                        ref.watch(filterControllerProvider);
                        final unionDropdownItems = filterNotifier.unionDropdownItems;
                        
                        return DropdownButtonFormField<String?>(
                          isExpanded: true,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                          initialValue: unionDropdownItems.contains(_selectedUnion)
                              ? _selectedUnion
                              : null,
                          hint: const Text('All'),
                          items: [
                            const DropdownMenuItem<String?>(
                              value: null,
                              child: Text('All'),
                            ),
                            ...unionDropdownItems
                                .where((item) => item != 'All')
                                .map(
                                  (union) => DropdownMenuItem<String?>(
                                    value: union,
                                    child: Text(
                                      union,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ),
                                ),
                          ],
                      onChanged: (value) async {
                        setState(() {
                          _selectedUnion = value;
                          _selectedWard = null;
                          _selectedSubblock = null;
                        });
                        // ✅ FIX: Wait for wards to be loaded after union is selected
                        await filterNotifier.updateUnion(value);
                        
                        // If union is selected and wards aren't loaded, try to load them
                        if (value != null && value != 'All') {
                          final currentFilterState = ref.read(filterControllerProvider);
                          if (currentFilterState.wards.isEmpty) {
                            logg.i('Union selected but wards not loaded, waiting for them...');
                            // Wait for wards to load (max 3 seconds)
                            int retries = 0;
                            const maxRetries = 30;
                            
                            while (retries < maxRetries) {
                              await Future.delayed(const Duration(milliseconds: 100));
                              final updatedState = ref.read(filterControllerProvider);
                              if (updatedState.wards.isNotEmpty) {
                                logg.i('Wards loaded (${updatedState.wards.length} items)');
                                // Trigger rebuild to update dropdown
                                if (mounted) setState(() {});
                                break;
                              }
                              retries++;
                            }
                          } else {
                            // Wards already loaded, trigger rebuild to update dropdown
                            if (mounted) setState(() {});
                          }
                        }
                      },
                        );
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
                    // ✅ FIX: Make ward dropdown reactive to state changes
                    Builder(
                      builder: (context) {
                        // Watch filter state to reactively update when wards are loaded
                        ref.watch(filterControllerProvider);
                        final wardDropdownItems = filterNotifier.wardDropdownItems;
                        
                        return DropdownButtonFormField<String?>(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                          initialValue: wardDropdownItems.contains(_selectedWard)
                              ? _selectedWard
                              : null,
                          hint: const Text('All'),
                          items: [
                            const DropdownMenuItem<String?>(
                              value: null,
                              child: Text('All'),
                            ),
                            ...wardDropdownItems
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
                        );
                      },
                    ),

                    // ✅ Subblock Dropdown (shown when ward is selected, not just EPI context)
                    if (_selectedWard != null && _selectedWard != 'All') ...[
                      16.h,
                      const Text(
                        'Subblock',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                        ),
                      ),
                      8.h,
                      // ✅ FIX: Make subblock dropdown reactive to state changes
                      Builder(
                        builder: (context) {
                          // Watch filter state to reactively update when subblocks are loaded
                          ref.watch(filterControllerProvider);
                          final subblockDropdownItems = filterNotifier.subblockDropdownItems;
                          
                          return DropdownButtonFormField<String?>(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                            initialValue: subblockDropdownItems.contains(_selectedSubblock)
                                ? _selectedSubblock
                                : null,
                            hint: const Text('All'),
                            items: [
                              const DropdownMenuItem<String?>(
                                value: null,
                                child: Text('All'),
                              ),
                              ...subblockDropdownItems
                                  .where((item) => item != 'All')
                                  .map(
                                    (subblock) => DropdownMenuItem<String?>(
                                      value: subblock,
                                      child: Text(subblock),
                                    ),
                                  ),
                            ],
                            onChanged: (value) async {
                              setState(() {
                                _selectedSubblock = value;
                              });
                              filterNotifier.updateSubblock(value);
                            },
                          );
                        },
                      ),
                    ],
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
                          _selectedZone = null; // Clear zone when CC changes
                        });
                        // Trigger zone loading
                        if (value != null) {
                          filterNotifier.updateCityCorporation(value);
                        }
                      },
                    ),

                  // Zone Dropdown (only show if CC is selected and not in EPI context)
                  if (_selectedCityCorporation != null &&
                      !widget.isEpiContext) ...[
                    16.h,
                    const Text(
                      'Zone',
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
                          filterNotifier.zoneDropdownItems.contains(
                            _selectedZone,
                          )
                          ? _selectedZone
                          : null,
                      hint: const Text('All'),
                      items: [
                        const DropdownMenuItem<String?>(
                          value: null,
                          child: Text('All'),
                        ),
                        ...filterNotifier.zoneDropdownItems.map(
                          (zone) => DropdownMenuItem<String?>(
                            value: zone,
                            child: Text(zone),
                          ),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedZone = value;
                        });
                      },
                    ),
                  ],
                ],
                16.h,
                // Vaccine Selection (hidden in EPI details context and microplan context)
                if (!widget.isEpiContext && !widget.isMicroplanContext) ...[
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
                              label: VaccineType.bcg.displayName,
                              primaryColor: primaryColor,
                              selectedVaccine:
                                  VaccineType.fromUid(
                                    _selectedVaccine,
                                  )?.displayName ??
                                  '',
                              onChanged: (val) {
                                setState(() {
                                  _selectedVaccine = VaccineType.bcg.uid;
                                });
                              },
                            ),
                            CustomRadioButton(
                              label: VaccineType.penta2.displayName,
                              primaryColor: primaryColor,
                              selectedVaccine:
                                  VaccineType.fromUid(
                                    _selectedVaccine,
                                  )?.displayName ??
                                  '',
                              onChanged: (val) {
                                setState(() {
                                  _selectedVaccine = VaccineType.penta2.uid;
                                });
                              },
                            ),
                            CustomRadioButton(
                              label: VaccineType.mr1.displayName,
                              primaryColor: primaryColor,
                              selectedVaccine:
                                  VaccineType.fromUid(
                                    _selectedVaccine,
                                  )?.displayName ??
                                  '',
                              onChanged: (val) {
                                setState(() {
                                  _selectedVaccine = VaccineType.mr1.uid;
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
                              label: VaccineType.penta1.displayName,
                              primaryColor: primaryColor,
                              selectedVaccine:
                                  VaccineType.fromUid(
                                    _selectedVaccine,
                                  )?.displayName ??
                                  '',
                              onChanged: (val) {
                                setState(() {
                                  _selectedVaccine = VaccineType.penta1.uid;
                                });
                              },
                            ),
                            CustomRadioButton(
                              label: VaccineType.penta3.displayName,
                              primaryColor: primaryColor,
                              selectedVaccine:
                                  VaccineType.fromUid(
                                    _selectedVaccine,
                                  )?.displayName ??
                                  '',
                              onChanged: (val) {
                                setState(() {
                                  _selectedVaccine = VaccineType.penta3.uid;
                                });
                              },
                            ),
                            CustomRadioButton(
                              label: VaccineType.mr2.displayName,
                              primaryColor: primaryColor,
                              selectedVaccine:
                                  VaccineType.fromUid(
                                    _selectedVaccine,
                                  )?.displayName ??
                                  '',
                              onChanged: (val) {
                                setState(() {
                                  _selectedVaccine = VaccineType.mr2.uid;
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

  Widget _buildMonthFilter(
    BuildContext context,
    FilterControllerNotifier filterNotifier,
  ) {
    return InkWell(
      onTap: () async {
        final availableMonths = filterNotifier.monthDropdownItems;
        final selected = await showDialog<List<String>>(
          context: context,
          builder: (context) {
            final tempSelectedMonths = List<String>.from(_selectedMonths);
            return StatefulBuilder(
              builder: (context, setStateDialog) {
                return AlertDialog(
                  title: const Text('Select Months'),
                  content: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: availableMonths.map((month) {
                        return CheckboxListTile(
                          title: Text(month),
                          value: tempSelectedMonths.contains(month),
                          onChanged: (bool? value) {
                            setStateDialog(() {
                              if (value == true) {
                                tempSelectedMonths.add(month);
                              } else {
                                tempSelectedMonths.remove(month);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () =>
                          Navigator.pop(context, tempSelectedMonths),
                      child: const Text('OK'),
                    ),
                  ],
                );
              },
            );
          },
        );

        if (selected != null) {
          setState(() {
            _selectedMonths = selected;
          });
        }
      },
      child: InputDecorator(
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          suffixIcon: Icon(Icons.arrow_drop_down),
        ),
        child: _selectedMonths.isEmpty
            ? const Text(
                'Select Months',
                style: TextStyle(color: Colors.black54, fontSize: 16),
              )
            : Wrap(
                spacing: 6.0,
                runSpacing: 4.0,
                children: _selectedMonths.map((month) {
                  return Chip(
                    label: Text(month, style: const TextStyle(fontSize: 12)),
                    backgroundColor: Theme.of(
                      context,
                    ).primaryColor.withOpacity(0.1),
                    onDeleted: () {
                      setState(() {
                        _selectedMonths.remove(month);
                      });
                    },
                    padding: EdgeInsets.zero,
                    labelPadding: const EdgeInsets.symmetric(horizontal: 8),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  );
                }).toList(),
              ),
      ),
    );
  }
}
