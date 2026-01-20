import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/common/constants/constants.dart';
import '../../../../core/common/widgets/custom_loading_widget.dart';
import '../../../../core/utils/utils.dart';
import '../../../epi_center/presentation/controllers/epi_center_controller.dart';
import '../../../epi_center/presentation/widgets/epi_center_about_details_widget.dart';
import '../../../epi_center/presentation/widgets/epi_center_microplan_widgets.dart';
import '../../../epi_center/presentation/widgets/epi_yearly_session_personnel_widget.dart';
import '../../../filter/presentation/controllers/filter_controller.dart';
import '../../../filter/filter.dart';
import '../../../map/presentation/controllers/map_controller.dart';
import '../../../map/utils/map_enums.dart';
import '../../../summary/presentation/controllers/summary_controller.dart';
import '../../../summary/domain/vaccine_coverage_response.dart';

class MicroPlanScreen extends ConsumerStatefulWidget {
  const MicroPlanScreen({super.key});

  @override
  ConsumerState<MicroPlanScreen> createState() => _MicroPlanScreenState();
}

class _MicroPlanScreenState extends ConsumerState<MicroPlanScreen> {
  // ✅ Add debouncing and cancellation support
  Timer? _loadDebounceTimer;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // ✅ Load EPI center data when screen is first shown (immediate load, no debounce)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scheduleLoadMicroPlanData(immediate: true);
    });
  }

  @override
  void dispose() {
    _loadDebounceTimer?.cancel();
    super.dispose();
  }

  /// Build breadcrumb path from filter state
  String _buildBreadcrumbPath(FilterState filterState) {
    final breadcrumbs = <String>[];
    
    // Add division if selected (and not "All")
    if (filterState.selectedDivision != 'All') {
      breadcrumbs.add(filterState.selectedDivision);
    }
    
    // For district area type
    if (filterState.selectedAreaType == AreaType.district) {
      if (filterState.selectedDistrict != null) {
        breadcrumbs.add(filterState.selectedDistrict!);
      }
      if (filterState.selectedUpazila != null) {
        breadcrumbs.add(filterState.selectedUpazila!);
      }
      if (filterState.selectedUnion != null) {
        breadcrumbs.add(filterState.selectedUnion!);
      }
      if (filterState.selectedWard != null) {
        breadcrumbs.add(filterState.selectedWard!);
      }
      if (filterState.selectedSubblock != null && 
          filterState.selectedSubblock != 'All') {
        breadcrumbs.add(filterState.selectedSubblock!);
      }
    } 
    // For city corporation area type
    else if (filterState.selectedAreaType == AreaType.cityCorporation) {
      if (filterState.selectedCityCorporation != null) {
        breadcrumbs.add(filterState.selectedCityCorporation!);
      }
      if (filterState.selectedZone != null) {
        breadcrumbs.add(filterState.selectedZone!);
      }
      if (filterState.selectedWard != null) {
        breadcrumbs.add(filterState.selectedWard!);
      }
      if (filterState.selectedSubblock != null && 
          filterState.selectedSubblock != 'All') {
        breadcrumbs.add(filterState.selectedSubblock!);
      }
    }
    
    if (breadcrumbs.isEmpty) {
      return '';
    }
    
    return breadcrumbs.join(' / ');
  }

  /// Show filter dialog
  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Color(Constants.cardColor),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
        insetPadding: const EdgeInsets.symmetric(horizontal: 16),
        child: const FilterDialogBoxWidget(
          isEpiContext: false,
          isMicroplanContext: true,
        ),
      ),
    );
  }

  /// Set error state for division-level requests (prevents memory exhaustion)
  void _setDivisionLevelError(EpiCenterController epiController) {
    // ✅ Use controller method to set error state without making API call
    epiController.setErrorState(
      'Microplan data is not available at division level due to data size limitations. Please select a district, upazila, union, ward, or subblock in the filter.',
    );
  }

  /// Load microplan data with debouncing and optimization
  void _scheduleLoadMicroPlanData({bool immediate = false}) {
    // Cancel any pending load
    _loadDebounceTimer?.cancel();
    
    if (immediate) {
      _loadMicroPlanData();
    } else {
      // ✅ Debounce: Wait 300ms before loading to prevent rapid successive loads
      _loadDebounceTimer = Timer(const Duration(milliseconds: 300), () {
        if (mounted) {
          _loadMicroPlanData();
        }
      });
    }
  }

  Future<void> _loadMicroPlanData() async {
    // ✅ Prevent multiple simultaneous loads
    if (_isLoading) {
      logg.d("Micro Plan: Load already in progress, skipping duplicate request");
      return;
    }

    _isLoading = true;

    try {
      // ✅ Ensure UI updates immediately by yielding control
      await Future.delayed(Duration.zero);
      
      final mapNotifier = ref.read(mapControllerProvider.notifier);
      final filterState = ref.read(filterControllerProvider);
      final epiController = ref.read(epiCenterControllerProvider.notifier);

      // ✅ Get orgUid from focalAreaUid (which reads from current filter state)
      final orgUid = mapNotifier.focalAreaUid;
      final year = filterState.selectedYear;

      logg.i("🔄 Loading Micro Plan data (orgUid: $orgUid, year: $year)");

      // ✅ Check if this is a division-level filter BEFORE making API call
      // Division-level EPI data is too large (~90MB+) and causes heap exhaustion
      final isDivisionLevel = filterState.selectedDivision != 'All' &&
          filterState.selectedDistrict == null &&
          filterState.selectedUpazila == null &&
          filterState.selectedUnion == null &&
          filterState.selectedWard == null &&
          filterState.selectedSubblock == null &&
          filterState.selectedCityCorporation == null &&
          filterState.selectedZone == null;

      if (isDivisionLevel) {
        logg.w("⚠️ Division-level filter detected - EPI data too large for division level");
        logg.w("   Preventing request to avoid memory exhaustion");
        
        // ✅ Set error state immediately without making API call
        // This prevents the expensive API call and JSON parsing that causes heap exhaustion
        _setDivisionLevelError(epiController);
        return;
      }

      // ✅ FIX: For subblock-level requests, the /chart/ endpoint requires just the subblock UID
      // The concatenated path format works for /epi/ endpoint but not for /chart/ endpoint
      String effectiveUid;
      
      // ✅ Detect subblock level by checking both filter state AND path format
      // Path format: district/upazila/union/ward/subblock (5 segments) indicates subblock level
      final isSubblockPath = orgUid != null && 
          orgUid.contains('/') && 
          orgUid.split('/').length == 5;
      final hasSubblockFilter = filterState.selectedSubblock != null &&
          filterState.selectedSubblock != 'All';
      
      if (isSubblockPath || hasSubblockFilter) {
        // ✅ Subblock-level detected - extract just the subblock UID
        String? subblockUid;
        
        if (hasSubblockFilter) {
          // Try to get from filter controller first (most reliable)
          final filterController = ref.read(filterControllerProvider.notifier);
          subblockUid = filterController.getSubblockUid(filterState.selectedSubblock!);
          logg.i("   > Subblock filter found in state: ${filterState.selectedSubblock}");
        }
        
        // Fallback: extract from path if filter lookup failed or path format detected
        if (subblockUid == null && isSubblockPath) {
          subblockUid = orgUid.split('/').last;
          logg.i("   > Subblock detected from path format (5 segments) - extracted UID: $subblockUid");
        }
        
        if (subblockUid != null) {
          effectiveUid = subblockUid;
          logg.i("   > ✅ Subblock-level filter - using subblock UID only: $effectiveUid");
        } else {
          // Last resort: use orgUid as-is
          effectiveUid = orgUid ?? 'null';
          logg.w("   > ⚠️ Could not extract subblock UID, using orgUid as-is: $effectiveUid");
        }
      } else {
        // For other levels, use the orgUid as-is
        effectiveUid = (orgUid != null && orgUid.isNotEmpty)
            ? orgUid
            : 'null';
      }

      logg.i("   > Effective UID for API: $effectiveUid");

      // ✅ Fetch data using the effective UID
      // This is already async and won't block the UI thread
      await epiController.fetchEpiCenterDataByOrgUid(orgUid: effectiveUid, year: year);
    } finally {
      _isLoading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final epiState = ref.watch(epiCenterControllerProvider);
    final filterState = ref.watch(filterControllerProvider);
    final mapState = ref.watch(mapControllerProvider);
    final summaryState = ref.watch(summaryControllerProvider);

    final epiCenterData = epiState.epiCenterData;
    final selectedYear = filterState.selectedYear;
    
    // ✅ Optimize coverage data access - only read when needed (lazy evaluation)
    // This prevents expensive reads on every build
    VaccineCoverageResponse? coverageData;
    String? selectedVaccineUid;
    String? coverageDataSource; // ✅ DEBUG: Track which source is used
    
    // ✅ DEBUG: Always log coverage data check, even if EPI data is null
    logg.i('🔍 [0-11m DEBUG] Checking coverage data sources for microplan:');
    logg.i('   > EPI Center Data: ${epiCenterData != null ? "present" : "null"}');
    logg.i('   > Filter: ${filterState.selectedAreaType}, ${filterState.selectedDivision}, ${filterState.selectedDistrict}, ${filterState.selectedUpazila}, ${filterState.selectedUnion}, ${filterState.selectedWard}, ${filterState.selectedSubblock}');
    logg.i('   > Map state level: ${mapState.currentLevel}, area: ${mapState.currentAreaName}');
    
    // Only fetch coverage data if we have EPI data (avoid unnecessary work)
    if (epiCenterData != null) {
      final mapNotifier = ref.read(mapControllerProvider.notifier);
      
      if (mapNotifier.unfilteredCoverageData != null) {
        coverageData = mapNotifier.unfilteredCoverageData;
        coverageDataSource = 'unfilteredCoverageData (map controller)';
        logg.i('   ✅ Using unfilteredCoverageData from map controller');
        logg.i('      > Vaccines count: ${coverageData?.vaccines?.length ?? 0}');
        if (coverageData?.vaccines != null && coverageData!.vaccines!.isNotEmpty) {
          final firstVaccine = coverageData.vaccines!.first;
          logg.i('      > First vaccine: ${firstVaccine.vaccineName} (UID: ${firstVaccine.vaccineUid})');
          logg.i('      > First vaccine targets: totalMale=${firstVaccine.totalTargetMale}, totalFemale=${firstVaccine.totalTargetFemale}');
          logg.i('      > First vaccine areas count: ${firstVaccine.areas?.length ?? 0}');
        }
      } else if (summaryState.coverageData != null) {
        coverageData = summaryState.coverageData;
        coverageDataSource = 'coverageData (summary controller)';
        logg.i('   ✅ Using coverageData from summary controller');
        logg.i('      > Vaccines count: ${coverageData?.vaccines?.length ?? 0}');
      } else if (mapState.coverageData != null) {
        coverageData = mapState.coverageData;
        coverageDataSource = 'coverageData (map state)';
        logg.i('   ✅ Using coverageData from map state');
        logg.i('      > Vaccines count: ${coverageData?.vaccines?.length ?? 0}');
      } else {
        logg.w('   ⚠️ No coverage data available from any source');
      }
      
      selectedVaccineUid = filterState.selectedVaccine;
      logg.i('   > Selected vaccine UID: $selectedVaccineUid');
      logg.i('   > Coverage data source: $coverageDataSource');
    } else {
      logg.w('🔍 [0-11m DEBUG] No EPI center data available, skipping coverage data lookup');
    }

    // ✅ Listen to filter state changes and reload microplan data
    ref.listen<FilterState>(filterControllerProvider, (previous, current) {
      if (previous != null) {
        // Check if timestamp changed (filter was applied)
        final timestampChanged = current.lastAppliedTimestamp != null &&
            previous.lastAppliedTimestamp != current.lastAppliedTimestamp;
        
        // Also check if any relevant filter values changed
        final filterChanged = 
            previous.selectedYear != current.selectedYear ||
            previous.selectedAreaType != current.selectedAreaType ||
            previous.selectedDivision != current.selectedDivision ||
            previous.selectedDistrict != current.selectedDistrict ||
            previous.selectedCityCorporation != current.selectedCityCorporation ||
            previous.selectedZone != current.selectedZone ||
            previous.selectedUpazila != current.selectedUpazila ||
            previous.selectedUnion != current.selectedUnion ||
            previous.selectedWard != current.selectedWard ||
            previous.selectedSubblock != current.selectedSubblock;
        
        if (timestampChanged || filterChanged) {
          logg.i("🔄 Micro Plan: Filter applied - scheduling reload (year: ${current.selectedYear}, area: ${current.selectedAreaType})");
          
          // ✅ Use debounced loading to prevent rapid successive loads
          // This prevents ANR when filters change quickly
          _scheduleLoadMicroPlanData();
        }
      }
    });

    // ✅ Build breadcrumb path from filter state
    final breadcrumbPath = _buildBreadcrumbPath(filterState);
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(Constants.primaryColor),
        title: const Text('Micro Plan', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          // ✅ Add filter button to AppBar
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.white),
            onPressed: _showFilterDialog,
            tooltip: 'Filter',
          ),
        ],
      ),
      // ✅ Add breadcrumb navigation below AppBar
      body: Column(
        children: [
          if (breadcrumbPath.isNotEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: Colors.grey[100],
              child: Row(
                children: [
                  Icon(Icons.home, size: 18, color: Colors.grey[700]),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      breadcrumbPath,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[800],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          Expanded(
            child: epiState.isLoading
          ? const Center(
              child: CustomLoadingWidget(
                loadingText: 'Loading micro plan data...',
              ),
            )
          : epiState.hasError
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 64,
                      color: Colors.orange[600],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      epiState.errorMessage ?? 'Failed to load microplan data',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    if (epiState.errorMessage?.contains('division level') == true) ...[
                      const SizedBox(height: 16),
                      const Text(
                        'Microplan data is available at district level and below. Please select a district, upazila, union, ward, or subblock in the filter.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () => _scheduleLoadMicroPlanData(immediate: true),
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            )
          : epiCenterData == null
          ? const Center(
              child: Text(
                'No micro plan data available',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Microplan section
                  EpiCenterMicroplanSection(
                    epiCenterDetailsData: epiCenterData,
                    coverageData: coverageData, // ✅ Pass coverage data for consistent calculation
                    selectedVaccineUid: selectedVaccineUid, // ✅ Pass selected vaccine UID
                  ),
                  const SizedBox(height: 24),
                  EpiCenterAboutDetailsWidget(
                    epiCenterDetailsData: epiCenterData,
                    selectedYear: selectedYear,
                  ),
                  const SizedBox(height: 10),
                  EpiYearlySessionPersonnelWidget(
                    epiCenterDetailsData: epiCenterData,
                    selectedYear: selectedYear,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
