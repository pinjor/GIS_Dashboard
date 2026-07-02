import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/common/constants/constants.dart';
import '../../../../core/common/widgets/custom_loading_widget.dart';
import '../../../../core/utils/utils.dart';
import '../../../epi_center/utils/chart_area_uid_resolver.dart';
import '../../../epi_center/utils/epi_details_helpers.dart';
import '../../../epi_center/presentation/controllers/epi_center_controller.dart';
import '../../../epi_center/presentation/widgets/epi_center_about_details_widget.dart';
import '../../../epi_center/presentation/widgets/epi_center_microplan_widgets.dart';
import '../../../epi_center/presentation/widgets/epi_yearly_session_personnel_widget.dart';
import '../../../filter/filter.dart';
import '../../../map/presentation/controllers/map_controller.dart';
import '../../../map/utils/map_enums.dart';

class MicroPlanScreen extends ConsumerStatefulWidget {
  const MicroPlanScreen({super.key});

  @override
  ConsumerState<MicroPlanScreen> createState() => _MicroPlanScreenState();
}

class _MicroPlanScreenState extends ConsumerState<MicroPlanScreen> {
  // ✅ Add debouncing and cancellation support
  Timer? _loadDebounceTimer;
  bool _isLoading = false;
  bool _pendingReload = false;

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

  Future<String?> _resolveChartUid() async {
    final filterNotifier = ref.read(filterControllerProvider.notifier);
    await filterNotifier.ensureHierarchyListsLoaded();
    final filterState = ref.read(filterControllerProvider);
    final orgUid = ref.read(mapControllerProvider.notifier).focalAreaUid;
    final epiData = ref.read(epiCenterControllerProvider).epiCenterData;

    final chartUid = ChartAreaUidResolver.resolveChartUid(
      filterState: filterState,
      filterNotifier: filterNotifier,
      orgUid: orgUid,
      currentEpiData: epiData,
    );

    logg.i('Micro Plan: Resolved chart UID → $chartUid');
    return chartUid;
  }

  Future<void> _loadMicroPlanData() async {
    if (_isLoading) {
      _pendingReload = true;
      logg.d(
        "Micro Plan: Load already in progress, queuing another reload",
      );
      return;
    }

    _isLoading = true;

    try {
      do {
        _pendingReload = false;
        await _loadMicroPlanDataOnce();
      } while (_pendingReload && mounted);
    } finally {
      _isLoading = false;
    }
  }

  Future<void> _loadMicroPlanDataOnce() async {
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
        final hasDeepSelection =
            !ChartAreaUidResolver.isPlaceholder(filterState.selectedSubblock) ||
            !ChartAreaUidResolver.isPlaceholder(filterState.selectedWard) ||
            !ChartAreaUidResolver.isPlaceholder(filterState.selectedUnion) ||
            !ChartAreaUidResolver.isPlaceholder(filterState.selectedUpazila) ||
            !ChartAreaUidResolver.isPlaceholder(filterState.selectedDistrict) ||
            !ChartAreaUidResolver.isPlaceholder(filterState.selectedZone);

        if (!hasDeepSelection &&
            (isDivisionLevel ||
                (filterState.selectedDivision != 'All' &&
                    filterState.selectedDistrict == null &&
                    filterState.selectedCityCorporation == null))) {
          logg.w("⚠️ Short UID detected (likely division) - blocking request");
          logg.w("   > UID: $orgUid (length: ${orgUid.length})");
          _setDivisionLevelError(epiController);
          return;
        }
      }

      if (orgUid == null &&
          ChartAreaUidResolver.isPlaceholder(filterState.selectedDistrict) &&
          ChartAreaUidResolver.isPlaceholder(filterState.selectedCityCorporation)) {
        logg.w("⚠️ No area selected - focalAreaUid returned null");
        epiController.setErrorState(
          'Please select an area in the filter to view microplan data. Select a district, upazila, union, ward, subblock, city corporation, or zone.',
        );
        return;
      }

      final effectiveUid = await _resolveChartUid();
      logg.i('Micro Plan: effective chart UID=$effectiveUid');

      if (effectiveUid == null || effectiveUid.isEmpty || effectiveUid == 'null') {
        logg.w("⚠️ Invalid or missing UID - cannot fetch microplan data");
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
  }

  @override
  Widget build(BuildContext context) {
    final epiState = ref.watch(epiCenterControllerProvider);
    final filterState = ref.watch(filterControllerProvider);

    final epiCenterData = epiState.epiCenterData;
    final selectedYear = filterState.selectedYear;
    final showSubblockSections =
        EpiDetailsHelpers.shouldShowSubblockOnlySections(filterState);

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

          final needsImmediateReload =
              previous.selectedSubblock != current.selectedSubblock ||
              previous.selectedWard != current.selectedWard ||
              previous.selectedUnion != current.selectedUnion;

          _scheduleLoadMicroPlanData(immediate: needsImmediateReload);
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
                        ),
                        if (showSubblockSections) ...[
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
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
