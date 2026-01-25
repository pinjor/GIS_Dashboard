import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:gis_dashboard/core/common/constants/constants.dart';
import 'package:gis_dashboard/core/utils/utils.dart';
import 'package:gis_dashboard/features/filter/presentation/controllers/filter_controller.dart';
import 'package:gis_dashboard/features/filter/domain/filter_state.dart';
import 'package:gis_dashboard/features/map/utils/map_enums.dart';
import 'package:gis_dashboard/features/session_plan/presentation/controllers/session_plan_controller.dart';

class SessionPlanFilterDialog extends ConsumerStatefulWidget {
  const SessionPlanFilterDialog({super.key});

  @override
  ConsumerState<SessionPlanFilterDialog> createState() =>
      _SessionPlanFilterDialogState();
}

class _SessionPlanFilterDialogState
    extends ConsumerState<SessionPlanFilterDialog> {
  // Local state for temporary selections
  late AreaType _selectedAreaType;
  late String _selectedDivision;
  String? _selectedCityCorporation;
  String? _selectedDistrict;
  String? _selectedZone;
  String? _selectedUpazila;
  String? _selectedUnion;
  String? _selectedWard;

  // Date range state
  DateTime? _fromDate;
  DateTime? _toDate;

  // Store initial values for reset
  late AreaType _initialAreaType;
  late String _initialDivision;
  String? _initialCityCorporation;
  String? _initialDistrict;
  String? _initialZone;
  String? _initialUpazila;
  String? _initialUnion;
  String? _initialWard;

  @override
  void initState() {
    super.initState();
    _initializeFilterState();
  }

  void _initializeFilterState() {
    final currentFilter = ref.read(filterControllerProvider);
    final sessionPlanState = ref.read(sessionPlanControllerProvider);

    _selectedAreaType = currentFilter.selectedAreaType;
    _selectedDivision = currentFilter.selectedDivision;

    // Store initial values
    _initialAreaType = currentFilter.selectedAreaType;
    _initialDivision = currentFilter.selectedDivision;
    _initialCityCorporation = currentFilter.selectedCityCorporation;
    _initialDistrict = currentFilter.selectedDistrict;
    _initialZone = currentFilter.selectedZone;
    _initialUpazila = currentFilter.selectedUpazila;
    _initialUnion = currentFilter.selectedUnion;
    _initialWard = currentFilter.selectedWard;

    // Initialize current selections
    if (_selectedAreaType == AreaType.district) {
      _selectedDistrict = currentFilter.selectedDistrict;
      _selectedUpazila = currentFilter.selectedUpazila;
      _selectedUnion = currentFilter.selectedUnion;
      _selectedWard = currentFilter.selectedWard;
    } else {
      _selectedCityCorporation = currentFilter.selectedCityCorporation;
      _selectedZone = currentFilter.selectedZone;
    }

    // Initialize dates from session plan state if available, otherwise default to today
    if (sessionPlanState.startDate != null && sessionPlanState.startDate!.isNotEmpty) {
      try {
        _fromDate = DateFormat('yyyy-MM-dd').parse(sessionPlanState.startDate!);
      } catch (e) {
        _fromDate = DateTime.now();
      }
    } else {
      _fromDate = DateTime.now();
    }

    if (sessionPlanState.endDate != null && sessionPlanState.endDate!.isNotEmpty) {
      try {
        _toDate = DateFormat('yyyy-MM-dd').parse(sessionPlanState.endDate!);
      } catch (e) {
        _toDate = DateTime.now();
      }
    } else {
      _toDate = DateTime.now();
    }

  }

  Future<void> _selectFromDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _fromDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != _fromDate) {
      setState(() {
        _fromDate = picked;
      });
    }
  }

  Future<void> _selectToDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _toDate ?? DateTime.now(),
      firstDate: _fromDate ?? DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != _toDate) {
      setState(() {
        _toDate = picked;
      });
    }
  }

  void _applyFilters() async {
    final filterNotifier = ref.read(filterControllerProvider.notifier);
    final sessionPlanNotifier =
        ref.read(sessionPlanControllerProvider.notifier);
    final currentFilter = ref.read(filterControllerProvider);

    // ✅ VALIDATION: Validate date range
    if (_fromDate != null && _toDate != null) {
      if (_toDate!.isBefore(_fromDate!)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('End date must be after or equal to start date'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
    }

    // ✅ VALIDATION: Ensure hierarchy is maintained
    // District filter hierarchy: division → district → upazila → union → ward
    if (_selectedAreaType == AreaType.district) {
      // Validate union selection requires district and upazila
      if (_selectedUnion != null && _selectedUnion != 'Select Union') {
        if (_selectedDistrict == null || _selectedUpazila == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Please select District and Upazila before selecting Union'),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }
      }

      // Validate ward selection requires district, upazila, and union
      if (_selectedWard != null && _selectedWard != 'Select Ward') {
        if (_selectedDistrict == null || 
            _selectedUpazila == null || 
            _selectedUnion == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Please select District, Upazila, and Union before selecting Ward'),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }
      }

      // Validate upazila selection requires district
      if (_selectedUpazila != null && _selectedUpazila != 'Select Upazila') {
        if (_selectedDistrict == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Please select District before selecting Upazila'),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }
      }
    }

    // City Corporation filter hierarchy: city corporation → zone
    if (_selectedAreaType == AreaType.cityCorporation) {
      // Validate zone selection requires city corporation
      if (_selectedZone != null && _selectedZone != 'Select Zone') {
        if (_selectedCityCorporation == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Please select City Corporation before selecting Zone'),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }
      }
    }

    // Apply area filters first
    filterNotifier.updateAreaType(_selectedAreaType);
    filterNotifier.updateDivision(_selectedDivision);

    if (_selectedAreaType == AreaType.district) {
      filterNotifier.updateDistrict(_selectedDistrict);
      filterNotifier.updateUpazila(_selectedUpazila);
      filterNotifier.updateUnion(_selectedUnion);
      filterNotifier.updateWard(_selectedWard);
      filterNotifier.updateCityCorporation(null);
      filterNotifier.updateZone(null);
    } else {
      filterNotifier.updateCityCorporation(_selectedCityCorporation);
      filterNotifier.updateZone(_selectedZone);
      filterNotifier.updateDistrict(null);
      filterNotifier.updateUpazila(null);
      filterNotifier.updateUnion(null);
      filterNotifier.updateWard(null);
    }

    // Apply filters and trigger timestamp update
    filterNotifier.applyFiltersWithInitialValues(
      areaType: _selectedAreaType,
      division: _selectedDivision,
      district: _selectedDistrict,
      upazila: _selectedUpazila,
      union: _selectedUnion,
      ward: _selectedWard,
      cityCorporation: _selectedCityCorporation,
      zone: _selectedZone,
      initialAreaType: _initialAreaType,
      initialDivision: _initialDivision,
      initialDistrict: _initialDistrict,
      initialUpazila: _initialUpazila,
      initialUnion: _initialUnion,
      initialWard: _initialWard,
      initialCityCorporation: _initialCityCorporation,
      initialZone: _initialZone,
      initialYear: currentFilter.selectedYear,
      initialVaccine: currentFilter.selectedVaccine,
      initialMonths: currentFilter.selectedMonths,
      forceTimestampUpdate: true,
    );

    // Format dates as YYYY-MM-DD for API
    final startDate = _fromDate != null
        ? DateFormat('yyyy-MM-dd').format(_fromDate!)
        : null;
    final endDate =
        _toDate != null ? DateFormat('yyyy-MM-dd').format(_toDate!) : null;

    // Close dialog first
    Navigator.of(context).pop();
    
    // ✅ FIX: Set loading state IMMEDIATELY after closing dialog
    // This ensures the loading overlay appears right away
    // We trigger loadDataWithFilter which sets isLoading: true

    // ✅ OPTIMIZATION 5: Reduced delay - filter state updates faster
    // The filter state listener in session_plan_screen will trigger a reload,
    // but we need to ensure the filter state is updated first
    await Future.delayed(const Duration(milliseconds: 50)); // Reduced from 200ms
    
    // Wait for upazilas to load if upazila is selected
    if (_selectedUpazila != null && _selectedUpazila != 'Select Upazila') {
      final currentFilterState = ref.read(filterControllerProvider);
      if (currentFilterState.upazilas.isEmpty && _selectedDistrict != null) {
        logg.i('Session Plan Filter: Waiting for upazilas to load...');
        int retries = 0;
        const maxRetries = 30; // 3 seconds max wait
        
        while (retries < maxRetries) {
          await Future.delayed(const Duration(milliseconds: 100));
          final updatedFilterState = ref.read(filterControllerProvider);
          if (updatedFilterState.upazilas.isNotEmpty) {
            logg.i('Session Plan Filter: Upazilas loaded (${updatedFilterState.upazilas.length} items)');
            break;
          }
          retries++;
        }
      }
    }
    
    // Load session plan data with date filters
    // The filter state listener in session_plan_screen will also trigger a reload,
    // but we call it here explicitly with the date filters to ensure it happens
    logg.i('Session Plan Filter: Loading data with dates - start: $startDate, end: $endDate');
    await sessionPlanNotifier.loadDataWithFilter(
      startDate: startDate,
      endDate: endDate,
    );
  }

  void _resetFilters() async {
    // ✅ FIX: Reset to default values (country view), not initial values
    // Reset local dialog state to defaults
    final filterState = ref.read(filterControllerProvider);
    final today = DateTime.now();
    
    setState(() {
      // Reset to default area type (district) and country view
      _selectedAreaType = filterState.selectedAreaType; // Keep area type
      _selectedDivision = 'All';
      _selectedCityCorporation = null;
      _selectedDistrict = null;
      _selectedZone = null;
      _selectedUpazila = null;
      _selectedUnion = null;
      _selectedWard = null;
      // Reset dates to today
      _fromDate = today;
      _toDate = today;
    });

    // Reset filter controller to defaults (country view)
    final filterNotifier = ref.read(filterControllerProvider.notifier);
    final sessionPlanNotifier = ref.read(sessionPlanControllerProvider.notifier);

    // Use the filter controller's resetFilters method which properly resets based on area type
    filterNotifier.resetFilters();

    // Close dialog first
    Navigator.of(context).pop();

    // Wait a bit for filter state to update
    await Future.delayed(const Duration(milliseconds: 150));
    
    // Load session plan data with reset filters (country level, today's dates)
    await sessionPlanNotifier.loadDataWithFilter(
      startDate: DateFormat('yyyy-MM-dd').format(today),
      endDate: DateFormat('yyyy-MM-dd').format(today),
    );
  }

  void _printMap() {
    // TODO: Implement print map functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Print Map functionality coming soon')),
    );
  }

  int _getTotalSessions() {
    final sessionPlanState = ref.watch(sessionPlanControllerProvider);
    final data = sessionPlanState.sessionPlanCoordsData;
    
    // ✅ FIX: Always prioritize sessionCount from API (this is the total count, not limited by features)
    // sessionCount is the actual total from the API (e.g., 39,727)
    // features.length is limited (e.g., 10,000 max from API pagination or marker limit)
    // Only use features.length as fallback if sessionCount is truly null/0
    int count = 0;
    
    // ✅ DEBUG: Log all relevant data to understand what's happening
    logg.i('Session Plan Filter: _getTotalSessions called');
    logg.i('  - data is null: ${data == null}');
    logg.i('  - sessionCount: ${data?.sessionCount}');
    logg.i('  - features length: ${data?.features?.length}');
    logg.i('  - isLoading: ${sessionPlanState.isLoading}');
    logg.i('  - error: ${sessionPlanState.error}');
    
    if (data != null) {
      if (data.sessionCount != null && data.sessionCount! > 0) {
        // ✅ Use sessionCount from API - this is the correct total (e.g., 39,727)
        count = data.sessionCount!;
        logg.i('Session Plan Filter: ✅ Using sessionCount from API: $count');
      } else if (data.features != null && data.features!.isNotEmpty) {
        // Fallback to features.length only if sessionCount is null/0
        count = data.features!.length;
        logg.w('Session Plan Filter: ⚠️ sessionCount is null/0 (${data.sessionCount}), using features.length as fallback: $count');
      } else {
        logg.w('Session Plan Filter: ⚠️ Both sessionCount and features are null/empty');
      }
    } else {
      logg.w('Session Plan Filter: ⚠️ sessionPlanCoordsData is null');
    }
    
    // Debug logging to help troubleshoot session count issues
    if (count == 0 && !sessionPlanState.isLoading && sessionPlanState.error == null) {
      logg.w('Session Plan Filter: Total sessions is 0 - sessionCount: ${data?.sessionCount}, features length: ${data?.features?.length}');
    }
    
    logg.i('Session Plan Filter: Returning total sessions count: $count');
    return count;
  }

  @override
  Widget build(BuildContext context) {
    final filterState = ref.watch(filterControllerProvider);
    final filterNotifier = ref.read(filterControllerProvider.notifier);

    return Dialog(
      backgroundColor: Color(Constants.cardColor),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Area Type Selection (Radio Buttons)
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedAreaType = AreaType.district;
                        _selectedCityCorporation = null;
                        _selectedZone = null;
                      });
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Radio<AreaType>(
                          value: AreaType.district,
                          groupValue: _selectedAreaType,
                          onChanged: (value) {
                            setState(() {
                              _selectedAreaType = value!;
                              _selectedCityCorporation = null;
                              _selectedZone = null;
                            });
                          },
                        ),
                        Flexible(
                          child: Text(
                            'District',
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedAreaType = AreaType.cityCorporation;
                        _selectedDistrict = null;
                        _selectedUpazila = null;
                        _selectedUnion = null;
                        _selectedWard = null;
                      });
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Radio<AreaType>(
                          value: AreaType.cityCorporation,
                          groupValue: _selectedAreaType,
                          onChanged: (value) {
                            setState(() {
                              _selectedAreaType = value!;
                              _selectedDistrict = null;
                              _selectedUpazila = null;
                              _selectedUnion = null;
                              _selectedWard = null;
                            });
                          },
                        ),
                        Flexible(
                          child: Text(
                            'City Corporation',
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Total Session Display Button
            Builder(
              builder: (context) {
                // ✅ Use Builder to ensure reactive updates when session plan state changes
                final sessionPlanState = ref.watch(sessionPlanControllerProvider);
                final currentTotalSessions = _getTotalSessions();
                
                // ✅ Format number with commas to match web version (e.g., 39,727)
                final formattedCount = currentTotalSessions.toString().replaceAllMapped(
                  RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                  (Match m) => '${m[1]},',
                );
                
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: Color(Constants.primaryColor),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    sessionPlanState.isLoading
                        ? 'Loading sessions...'
                        : 'Total Session: $formattedCount',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),

            // Date Range Filter
            const Text(
              'Date Range',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => _selectFromDate(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Row(
                        children: [
                          Flexible(
                            child: Text(
                              _fromDate != null
                                  ? DateFormat('MM/dd/yyyy').format(_fromDate!)
                                  : 'Select From Date',
                              style: const TextStyle(fontSize: 14),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(Icons.calendar_today, size: 18),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: InkWell(
                    onTap: () => _selectToDate(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Row(
                        children: [
                          Flexible(
                            child: Text(
                              _toDate != null
                                  ? DateFormat('MM/dd/yyyy').format(_toDate!)
                                  : 'Select To Date',
                              style: const TextStyle(fontSize: 14),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(Icons.calendar_today, size: 18),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Geographical Hierarchy Filters
            if (_selectedAreaType == AreaType.district) ...[
              // Division Dropdown
              _buildDropdown(
                label: 'Division',
                value: _selectedDivision,
                items: _buildDivisionItems(filterState),
                onChanged: (value) {
                  setState(() {
                    _selectedDivision = value ?? 'All';
                    _selectedDistrict = null;
                    _selectedUpazila = null;
                    _selectedUnion = null;
                    _selectedWard = null;
                  });
                  if (value != null && value != 'All') {
                    filterNotifier.updateDivision(value);
                  }
                },
              ),
              const SizedBox(height: 12),

              // District Dropdown
              _buildDropdown(
                label: 'District',
                value: _selectedDistrict ?? 'All',
                items: _buildDistrictItems(filterState),
                onChanged: (value) {
                  setState(() {
                    _selectedDistrict = value == 'All' ? null : value;
                    _selectedUpazila = null;
                    _selectedUnion = null;
                    _selectedWard = null;
                  });
                  if (value != null && value != 'All') {
                    filterNotifier.updateDistrict(value);
                  }
                },
              ),
              const SizedBox(height: 12),

              // Upazila Dropdown
              _buildDropdown(
                label: 'Upazila',
                value: _selectedUpazila ?? 'Select Upazila',
                items: _buildUpazilaItems(filterState),
                onChanged: (value) {
                  setState(() {
                    _selectedUpazila = value == 'Select Upazila' ? null : value;
                    _selectedUnion = null;
                    _selectedWard = null;
                  });
                  if (value != null && value != 'Select Upazila') {
                    filterNotifier.updateUpazila(value);
                  }
                },
              ),
              const SizedBox(height: 12),

              // Union Dropdown
              _buildDropdown(
                label: 'Union',
                value: _selectedUnion ?? 'Select Union',
                items: _buildUnionItems(filterState),
                onChanged: (value) {
                  setState(() {
                    _selectedUnion = value == 'Select Union' ? null : value;
                    _selectedWard = null;
                  });
                  if (value != null && value != 'Select Union') {
                    filterNotifier.updateUnion(value);
                  }
                },
              ),
              const SizedBox(height: 12),

              // Ward Dropdown
              _buildDropdown(
                label: 'Ward',
                value: _selectedWard ?? 'Select Ward',
                items: _buildWardItems(filterState),
                onChanged: (value) {
                  setState(() {
                    _selectedWard = value == 'Select Ward' ? null : value;
                  });
                  if (value != null && value != 'Select Ward') {
                    filterNotifier.updateWard(value);
                  }
                },
              ),
            ] else ...[
              // City Corporation Dropdown
              _buildDropdown(
                label: 'City Corporation',
                value: _selectedCityCorporation ?? 'All',
                items: _buildCityCorporationItems(filterState),
                onChanged: (value) {
                  setState(() {
                    _selectedCityCorporation = value == 'All' ? null : value;
                    _selectedZone = null;
                  });
                  if (value != null && value != 'All') {
                    filterNotifier.updateCityCorporation(value);
                  }
                },
              ),
              const SizedBox(height: 12),

              // Zone Dropdown
              _buildDropdown(
                label: 'Zone',
                value: _selectedZone ?? 'Select Zone',
                items: _buildZoneItems(filterState),
                onChanged: (value) {
                  setState(() {
                    _selectedZone = value == 'Select Zone' ? null : value;
                  });
                  if (value != null && value != 'Select Zone') {
                    filterNotifier.updateZone(value);
                  }
                },
              ),
            ],
            const SizedBox(height: 24),

            // Action Buttons (Filter on left, Reset on right)
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _applyFilters,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(Constants.primaryColor),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    child: const Text(
                      'Filter',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: _resetFilters,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    child: const Text('Reset'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Print Map Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _printMap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(Constants.primaryColor),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                child: const Text(
                  'Print Map',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<String> _buildDivisionItems(FilterState filterState) {
    final divisionNames = filterState.divisions
        .map((d) => d.name ?? '')
        .where((n) => n.isNotEmpty)
        .toSet() // Use Set to remove duplicates
        .toList();
    
    // Ensure "All" is only added once and is the first item
    if (divisionNames.contains('All')) {
      divisionNames.remove('All');
    }
    return ['All', ...divisionNames];
  }

  List<String> _buildDistrictItems(FilterState filterState) {
    final districtNames = filterState.filteredDistricts
        .map((d) => d.name ?? '')
        .where((n) => n.isNotEmpty)
        .toSet() // Use Set to remove duplicates
        .toList();
    
    // Ensure "All" is only added once and is the first item
    if (districtNames.contains('All')) {
      districtNames.remove('All');
    }
    return ['All', ...districtNames];
  }

  List<String> _buildCityCorporationItems(FilterState filterState) {
    final ccNames = filterState.cityCorporations
        .map((cc) => cc.name ?? '')
        .where((n) => n.isNotEmpty)
        .toSet() // Use Set to remove duplicates
        .toList();
    
    // Ensure "All" is only added once and is the first item
    if (ccNames.contains('All')) {
      ccNames.remove('All');
    }
    return ['All', ...ccNames];
  }

  List<String> _buildUpazilaItems(FilterState filterState) {
    final upazilaNames = filterState.upazilas
        .map((u) => u.name ?? '')
        .where((n) => n.isNotEmpty)
        .toSet() // Use Set to remove duplicates
        .toList();
    
    // Ensure "Select Upazila" is only added once and is the first item
    if (upazilaNames.contains('Select Upazila')) {
      upazilaNames.remove('Select Upazila');
    }
    return ['Select Upazila', ...upazilaNames];
  }

  List<String> _buildUnionItems(FilterState filterState) {
    final unionNames = filterState.unions
        .map((u) => u.name ?? '')
        .where((n) => n.isNotEmpty)
        .toSet() // Use Set to remove duplicates
        .toList();
    
    // Ensure "Select Union" is only added once and is the first item
    if (unionNames.contains('Select Union')) {
      unionNames.remove('Select Union');
    }
    return ['Select Union', ...unionNames];
  }

  List<String> _buildWardItems(FilterState filterState) {
    final wardNames = filterState.wards
        .map((w) => w.name ?? '')
        .where((n) => n.isNotEmpty)
        .toSet() // Use Set to remove duplicates
        .toList();
    
    // Ensure "Select Ward" is only added once and is the first item
    if (wardNames.contains('Select Ward')) {
      wardNames.remove('Select Ward');
    }
    return ['Select Ward', ...wardNames];
  }

  List<String> _buildZoneItems(FilterState filterState) {
    final zoneNames = filterState.zones
        .map((z) => z.name ?? '')
        .where((n) => n.isNotEmpty)
        .toSet() // Use Set to remove duplicates
        .toList();
    
    // Ensure "Select Zone" is only added once and is the first item
    if (zoneNames.contains('Select Zone')) {
      zoneNames.remove('Select Zone');
    }
    return ['Select Zone', ...zoneNames];
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    // Ensure the value exists in items, otherwise use null or first item
    final validValue = items.contains(value) ? value : (items.isNotEmpty ? items.first : null);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          isExpanded: true,
          value: validValue,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            );
          }).toList(),
          selectedItemBuilder: (BuildContext context) {
            return items.map((String item) {
              return Text(
                item,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: const TextStyle(fontSize: 14),
              );
            }).toList();
          },
          onChanged: onChanged,
        ),
      ],
    );
  }
}
