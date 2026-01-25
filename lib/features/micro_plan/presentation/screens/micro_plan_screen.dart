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

    // For district area type
    if (filterState.selectedAreaType == AreaType.district) {
      // Add division if selected (and not "All") - only for district hierarchy
      if (filterState.selectedDivision != 'All') {
        breadcrumbs.add(filterState.selectedDivision);
      }
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
    // For city corporation area type - only show City Corporation and Zone
    else if (filterState.selectedAreaType == AreaType.cityCorporation) {
      if (filterState.selectedCityCorporation != null) {
        breadcrumbs.add(filterState.selectedCityCorporation!);
      }
      if (filterState.selectedZone != null) {
        breadcrumbs.add(filterState.selectedZone!);
      }
      // Note: Ward and Subblock are intentionally excluded from breadcrumb
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
      logg.d(
        "Micro Plan: Load already in progress, skipping duplicate request",
      );
      return;
    }

    _isLoading = true;

    try {
      // ✅ Ensure UI updates immediately by yielding control
      await Future.delayed(Duration.zero);

      final mapNotifier = ref.read(mapControllerProvider.notifier);
      final filterState = ref.read(filterControllerProvider);
      final epiController = ref.read(epiCenterControllerProvider.notifier);
      final year = filterState.selectedYear;

      logg.i("🔄 Loading Micro Plan data");
      logg.i("   > Area Type: ${filterState.selectedAreaType}");
      logg.i("   > Year: $year");
      logg.i("   > Division: ${filterState.selectedDivision}");
      logg.i("   > District: ${filterState.selectedDistrict}");
      logg.i("   > City Corporation: ${filterState.selectedCityCorporation}");
      logg.i("   > Zone: ${filterState.selectedZone}");
      logg.i("   > Upazila: ${filterState.selectedUpazila}");
      logg.i("   > Union: ${filterState.selectedUnion}");
      logg.i("   > Ward: ${filterState.selectedWard}");
      logg.i("   > Subblock: ${filterState.selectedSubblock}");

      // ✅ CRITICAL FIX: Check if this is a division-level filter FIRST, before getting UID
      // Division-level EPI data is too large (~90MB+) and causes heap exhaustion/timeouts
      final isDivisionLevel =
          filterState.selectedDivision != 'All' &&
          filterState.selectedDistrict == null &&
          filterState.selectedUpazila == null &&
          filterState.selectedUnion == null &&
          filterState.selectedWard == null &&
          filterState.selectedSubblock == null &&
          filterState.selectedCityCorporation == null &&
          filterState.selectedZone == null;

      if (isDivisionLevel) {
        logg.w(
          "⚠️ Division-level filter detected - EPI data too large for division level",
        );
        logg.w("   > Division: ${filterState.selectedDivision}");
        logg.w("   > All other filters are null - this is division-only selection");
        logg.w("   > Preventing API request to avoid memory exhaustion and timeouts");

        // ✅ Set error state immediately without making API call
        // This prevents the expensive API call and JSON parsing that causes heap exhaustion
        _setDivisionLevelError(epiController);
        return;
      }

      // ✅ Get orgUid from focalAreaUid (which reads from current filter state)
      final orgUid = mapNotifier.focalAreaUid;
      logg.i("   > Org UID from focalAreaUid: $orgUid");

      // ✅ Additional check: If orgUid is a short UID (likely division), also block it
      // Division UIDs are typically short (10-15 chars) and don't contain slashes
      if (orgUid != null && orgUid.length < 20 && !orgUid.contains('/')) {
        // Check if it's actually a division by verifying no lower-level filters are set
        if (isDivisionLevel || 
            (filterState.selectedDivision != 'All' &&
             filterState.selectedDistrict == null &&
             filterState.selectedCityCorporation == null)) {
          logg.w("⚠️ Short UID detected (likely division) - blocking request");
          logg.w("   > UID: $orgUid (length: ${orgUid.length})");
          _setDivisionLevelError(epiController);
          return;
        }
      }

      // ✅ Check if no area is selected (orgUid is null)
      // This happens when area type is selected but no specific area is chosen
      if (orgUid == null) {
        logg.w("⚠️ No area selected - focalAreaUid returned null");
        logg.w("   > Please select a specific area (district, upazila, union, ward, subblock, city corporation, or zone)");
        
        epiController.setErrorState(
          'Please select an area in the filter to view microplan data. Select a district, upazila, union, ward, subblock, city corporation, or zone.',
        );
        return;
      }

      // ✅ FIX: The /chart/ endpoint requires single UIDs, not concatenated paths
      // The concatenated path format works for /epi/ endpoint but not for /chart/ endpoint
      // For city corporation hierarchy:
      // - Zone level: ccUid/zoneUid (2 segments) -> extract zoneUid
      // - Ward level: ccUid/zoneUid/wardUid (3 segments) -> extract wardUid
      // - Subblock level: ccUid/zoneUid/wardUid/subblockUid (4 segments) -> extract subblockUid
      // For district hierarchy:
      // - Subblock level: district/upazila/union/ward/subblock (5 segments) -> extract subblockUid
      String effectiveUid;

      final isCityCorporation =
          filterState.selectedAreaType == AreaType.cityCorporation;
      final pathSegments = orgUid.contains('/')
          ? orgUid.split('/').length
          : 0;

      logg.i(
        "   > Area type: ${filterState.selectedAreaType}, isCityCorporation: $isCityCorporation",
      );
      logg.i(
        "   > Path segments: $pathSegments, orgUid: $orgUid",
      );

      // ✅ Handle city corporation hierarchy
      if (isCityCorporation) {
        final filterController = ref.read(filterControllerProvider.notifier);
        
        // Check for subblock level (4 segments: ccUid/zoneUid/wardUid/subblockUid)
        if (pathSegments == 4 || 
            (filterState.selectedSubblock != null &&
             filterState.selectedSubblock != 'All')) {
          String? subblockUid;
          
          if (filterState.selectedSubblock != null &&
              filterState.selectedSubblock != 'All') {
            subblockUid = filterController.getSubblockUid(
              filterState.selectedSubblock!,
            );
            logg.i(
              "   > Subblock filter found: ${filterState.selectedSubblock}, UID: $subblockUid",
            );
          }
          
          // Fallback: extract from path
          if (subblockUid == null && pathSegments == 4) {
            subblockUid = orgUid.split('/').last;
            logg.i(
              "   > Subblock detected from path (4 segments) - extracted UID: $subblockUid",
            );
          }
          
          if (subblockUid != null) {
            effectiveUid = subblockUid;
            logg.i(
              "   > ✅ City Corporation Subblock - using subblock UID only: $effectiveUid",
            );
          } else {
            effectiveUid = orgUid;
            logg.w(
              "   > ⚠️ Could not extract subblock UID, using orgUid as-is: $effectiveUid",
            );
          }
        }
        // Check for ward level (3 segments: ccUid/zoneUid/wardUid)
        else if (pathSegments == 3 ||
                 (filterState.selectedWard != null &&
                  filterState.selectedWard != 'All' &&
                  (filterState.selectedSubblock == null ||
                   filterState.selectedSubblock == 'All'))) {
          String? wardUid;
          
          if (filterState.selectedWard != null &&
              filterState.selectedWard != 'All') {
            wardUid = filterController.getWardUid(
              filterState.selectedWard!,
            );
            logg.i(
              "   > Ward filter found: ${filterState.selectedWard}, UID: $wardUid",
            );
          }
          
          // Fallback: extract from path
          if (wardUid == null && pathSegments == 3) {
            wardUid = orgUid.split('/').last;
            logg.i(
              "   > Ward detected from path (3 segments) - extracted UID: $wardUid",
            );
          }
          
          if (wardUid != null) {
            effectiveUid = wardUid;
            logg.i(
              "   > ✅ City Corporation Ward - using ward UID only: $effectiveUid",
            );
          } else {
            effectiveUid = orgUid;
            logg.w(
              "   > ⚠️ Could not extract ward UID, using orgUid as-is: $effectiveUid",
            );
          }
        }
        // Check for zone level (2 segments: ccUid/zoneUid)
        else if (pathSegments == 2 ||
                 (filterState.selectedZone != null &&
                  filterState.selectedZone != 'All' &&
                  (filterState.selectedWard == null ||
                   filterState.selectedWard == 'All'))) {
          String? zoneUid;
          
          if (filterState.selectedZone != null &&
              filterState.selectedZone != 'All') {
            zoneUid = filterController.getZoneUid(
              filterState.selectedZone!,
            );
            logg.i(
              "   > Zone filter found: ${filterState.selectedZone}, UID: $zoneUid",
            );
          }
          
          // Fallback: extract from path
          if (zoneUid == null && pathSegments == 2) {
            zoneUid = orgUid.split('/').last;
            logg.i(
              "   > Zone detected from path (2 segments) - extracted UID: $zoneUid",
            );
          }
          
          if (zoneUid != null) {
            effectiveUid = zoneUid;
            logg.i(
              "   > ✅ City Corporation Zone - using zone UID only: $effectiveUid",
            );
          } else {
            effectiveUid = orgUid;
            logg.w(
              "   > ⚠️ Could not extract zone UID, using orgUid as-is: $effectiveUid",
            );
          }
        }
        // City corporation level (1 segment: ccUid) - use as-is
        else {
          effectiveUid = orgUid;
          logg.i("   > City Corporation level - using orgUid as-is: $effectiveUid");
        }
      }
      // ✅ Handle district hierarchy
      else {
        // Check for subblock level (5 segments: district/upazila/union/ward/subblock)
        final isSubblockPath = pathSegments == 5;
        final hasSubblockFilter =
            filterState.selectedSubblock != null &&
            filterState.selectedSubblock != 'All';

        if (isSubblockPath || hasSubblockFilter) {
          String? subblockUid;

          if (hasSubblockFilter) {
            final filterController = ref.read(filterControllerProvider.notifier);
            subblockUid = filterController.getSubblockUid(
              filterState.selectedSubblock!,
            );
            logg.i(
              "   > Subblock filter found: ${filterState.selectedSubblock}, UID: $subblockUid",
            );
          }

          // Fallback: extract from path
          if (subblockUid == null && isSubblockPath) {
            subblockUid = orgUid.split('/').last;
            logg.i(
              "   > Subblock detected from path (5 segments) - extracted UID: $subblockUid",
            );
          }

          if (subblockUid != null) {
            effectiveUid = subblockUid;
            logg.i(
              "   > ✅ District Subblock - using subblock UID only: $effectiveUid",
            );
          } else {
            effectiveUid = orgUid;
            logg.w(
              "   > ⚠️ Could not extract subblock UID, using orgUid as-is: $effectiveUid",
            );
          }
        } else {
          // For other district levels (ward, union, upazila, district), use orgUid as-is
          effectiveUid = orgUid.isNotEmpty ? orgUid : 'null';
          logg.i("   > District level (not subblock) - using orgUid as-is: $effectiveUid");
        }
      }

      logg.i("   > Effective UID for API: $effectiveUid");

      // ✅ Validate UID before making API call
      if (effectiveUid.isEmpty || effectiveUid == 'null') {
        logg.w("⚠️ Invalid or missing UID - cannot fetch microplan data");
        logg.w("   > Effective UID: '$effectiveUid'");
        logg.w("   > Please ensure a valid area is selected in the filter");
        
        epiController.setErrorState(
          'No area selected. Please select a district, upazila, union, ward, subblock, city corporation, or zone in the filter.',
        );
        return;
      }

      // ✅ Fetch data using the effective UID
      // This is already async and won't block the UI thread
      await epiController.fetchEpiCenterDataByOrgUid(
        orgUid: effectiveUid,
        year: year,
      );
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
    logg.i(
      '   > EPI Center Data: ${epiCenterData != null ? "present" : "null"}',
    );
    logg.i(
      '   > Filter: ${filterState.selectedAreaType}, ${filterState.selectedDivision}, ${filterState.selectedDistrict}, ${filterState.selectedUpazila}, ${filterState.selectedUnion}, ${filterState.selectedWard}, ${filterState.selectedSubblock}',
    );
    logg.i(
      '   > Map state level: ${mapState.currentLevel}, area: ${mapState.currentAreaName}',
    );

    // Only fetch coverage data if we have EPI data (avoid unnecessary work)
    if (epiCenterData != null) {
      final mapNotifier = ref.read(mapControllerProvider.notifier);

      if (mapNotifier.unfilteredCoverageData != null) {
        coverageData = mapNotifier.unfilteredCoverageData;
        coverageDataSource = 'unfilteredCoverageData (map controller)';
        logg.i('   ✅ Using unfilteredCoverageData from map controller');
        logg.i(
          '      > Vaccines count: ${coverageData?.vaccines?.length ?? 0}',
        );
        if (coverageData?.vaccines != null &&
            coverageData!.vaccines!.isNotEmpty) {
          final firstVaccine = coverageData.vaccines!.first;
          logg.i(
            '      > First vaccine: ${firstVaccine.vaccineName} (UID: ${firstVaccine.vaccineUid})',
          );
          logg.i(
            '      > First vaccine targets: totalMale=${firstVaccine.totalTargetMale}, totalFemale=${firstVaccine.totalTargetFemale}',
          );
          logg.i(
            '      > First vaccine areas count: ${firstVaccine.areas?.length ?? 0}',
          );
        }
      } else if (summaryState.coverageData != null) {
        coverageData = summaryState.coverageData;
        coverageDataSource = 'coverageData (summary controller)';
        logg.i('   ✅ Using coverageData from summary controller');
        logg.i(
          '      > Vaccines count: ${coverageData?.vaccines?.length ?? 0}',
        );
      } else if (mapState.coverageData != null) {
        coverageData = mapState.coverageData;
        coverageDataSource = 'coverageData (map state)';
        logg.i('   ✅ Using coverageData from map state');
        logg.i(
          '      > Vaccines count: ${coverageData?.vaccines?.length ?? 0}',
        );
      } else {
        logg.w('   ⚠️ No coverage data available from any source');
      }

      selectedVaccineUid = filterState.selectedVaccine;
      logg.i('   > Selected vaccine UID: $selectedVaccineUid');
      logg.i('   > Coverage data source: $coverageDataSource');
    } else {
      logg.w(
        '🔍 [0-11m DEBUG] No EPI center data available, skipping coverage data lookup',
      );
    }

    // ✅ Listen to filter state changes and reload microplan data
    ref.listen<FilterState>(filterControllerProvider, (previous, current) {
      if (previous != null) {
        // Check if timestamp changed (filter was applied)
        final timestampChanged =
            current.lastAppliedTimestamp != null &&
            previous.lastAppliedTimestamp != current.lastAppliedTimestamp;

        // Also check if any relevant filter values changed
        final filterChanged =
            previous.selectedYear != current.selectedYear ||
            previous.selectedAreaType != current.selectedAreaType ||
            previous.selectedDivision != current.selectedDivision ||
            previous.selectedDistrict != current.selectedDistrict ||
            previous.selectedCityCorporation !=
                current.selectedCityCorporation ||
            previous.selectedZone != current.selectedZone ||
            previous.selectedUpazila != current.selectedUpazila ||
            previous.selectedUnion != current.selectedUnion ||
            previous.selectedWard != current.selectedWard ||
            previous.selectedSubblock != current.selectedSubblock;

        if (timestampChanged || filterChanged) {
          logg.i(
            "🔄 Micro Plan: Filter applied - scheduling reload (year: ${current.selectedYear}, area: ${current.selectedAreaType})",
          );

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
                            epiState.errorMessage ??
                                'Failed to load microplan data',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          if (epiState.errorMessage?.contains(
                                'division level',
                              ) ==
                              true) ...[
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
                            onPressed: () =>
                                _scheduleLoadMicroPlanData(immediate: true),
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
                          coverageData:
                              coverageData, // ✅ Pass coverage data for consistent calculation
                          selectedVaccineUid:
                              selectedVaccineUid, // ✅ Pass selected vaccine UID
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
