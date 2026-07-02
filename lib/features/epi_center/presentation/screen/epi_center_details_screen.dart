import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gis_dashboard/core/common/constants/constants.dart';
import 'package:gis_dashboard/features/epi_center/domain/epi_center_details_response.dart';
import 'package:gis_dashboard/features/epi_center/presentation/widgets/epi_center_about_details_widget.dart';
import 'package:gis_dashboard/features/epi_center/presentation/widgets/epi_yearly_session_personnel_widget.dart';
import 'package:gis_dashboard/features/summary/domain/vaccine_coverage_response.dart';
import 'package:gis_dashboard/features/epi_center/utils/epi_details_helpers.dart';

import '../../../../core/common/widgets/custom_loading_widget.dart';
import '../../../../core/utils/utils.dart';
import '../../../filter/presentation/widgets/filter_dialog_box_widget.dart';
import '../controllers/epi_center_controller.dart';
import '../../domain/epi_center_state.dart';
import '../../../filter/presentation/controllers/filter_controller.dart';
import '../../../filter/domain/filter_state.dart';
import '../../../map/presentation/controllers/map_controller.dart';
import '../widgets/epi_center_widgets.dart';

class EpiCenterDetailsScreen extends ConsumerStatefulWidget {
  final String epiUid;
  final int? currentLevel;
  final String? ccUid;
  final bool isOrgUidRequest; // Flag to indicate org_uid-based request
  final VaccineCoverageResponse? coverageData; // ✅ Coverage data for consistent target calculation
  final String? selectedVaccineUid; // ✅ Selected vaccine UID

  const EpiCenterDetailsScreen({
    super.key,
    required this.epiUid,
    this.currentLevel,
    this.ccUid,
    this.isOrgUidRequest = false, // Default to false for backward compatibility
    this.coverageData, // ✅ Optional coverage data
    this.selectedVaccineUid, // ✅ Optional selected vaccine UID
  });

  @override
  ConsumerState<EpiCenterDetailsScreen> createState() =>
      _EpiCenterDetailsScreenState();
}

class _EpiCenterDetailsScreenState
    extends ConsumerState<EpiCenterDetailsScreen> {
  Timer? _reloadTimer;

  @override
  void initState() {
    super.initState();
    // Always load EPI center data when the screen initializes
    // The epiUid is required and should always be available from the navigation
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadEpiCenterData();
    });
  }

  @override
  void dispose() {
    // Clean up any resources
    _reloadTimer?.cancel();
    super.dispose();
  }

  void _clearEpiContextOfFilter() {
    final filterController = ref.read(filterControllerProvider.notifier);
    filterController.clearEpiDetailsContext();
  }

  /// Handle filter changes in EPI context
  Future<void> _reloadEpiDetailsDataForFilterChange(String selectedYear) async {
    // Cancel any previous reload timer
    _reloadTimer?.cancel();

    // Start a new timer - wait 400ms before executing
    _reloadTimer = Timer(const Duration(milliseconds: 400), () async {
      await _performEpiReload(selectedYear);
    });
  }

  Future<void> _performEpiReload(String selectedYear) async {
    final filterState = ref.read(filterControllerProvider);
    final filterController = ref.read(filterControllerProvider.notifier);
    final epiController = ref.read(epiCenterControllerProvider.notifier);
    final currentEpiData = ref.read(epiCenterControllerProvider).epiCenterData;

    logg.i('🔔 EPI Filter Change Detected');
    logg.i('isEpiDetailsContext: ${filterState.isEpiDetailsContext}');
    logg.i('🔄 EPI Filter Applied - Reloading data for year #$selectedYear');

    // Allow hierarchical list loads to finish after applyFilters updates.
    await Future.delayed(const Duration(milliseconds: 300));

    final mapNotifier = ref.read(mapControllerProvider.notifier);
    final chartUid = await EpiDetailsHelpers.resolveChartUidAsync(
      filterNotifier: filterController,
      getFilterState: () => ref.read(filterControllerProvider),
      currentEpiData: currentEpiData,
      orgUid: mapNotifier.focalAreaUid,
    );

    if (chartUid == null || chartUid.isEmpty) {
      logg.w('🚫 Could not resolve chart UID from filter - keeping current data');
      return;
    }

    logg.i('📍 Loading EPI chart data for UID: $chartUid');

    try {
      await epiController.fetchEpiCenterDataByOrgUid(
        orgUid: chartUid,
        year: selectedYear,
      );
      logg.i('✅ Successfully reloaded EPI data for filter change');
    } catch (e) {
      logg.e('❌ Failed to reload EPI data: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load EPI data: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _loadEpiCenterData() async {
    Future.microtask(() {
      final filterState = ref.read(filterControllerProvider);
      final year = filterState.selectedYear;

      final controller = ref.read(epiCenterControllerProvider.notifier);

      if (widget.isOrgUidRequest) {
        // Use org_uid-based API call for city corporation wards
        controller.fetchEpiCenterDataByOrgUid(
          orgUid: widget.epiUid,
          year: year,
        );
      } else {
        // Use regular API call for district-based EPI centers
        controller.fetchEpiCenterData(
          epiUid: widget.epiUid,
          year: int.tryParse(year) ?? DateTime.now().year,
          ccUid: widget.ccUid,
        );
      }
    });
  }

  /// Initialize filter context with EPI data
  void _initializeFilterWithEpiData(dynamic epiData) {
    if (epiData == null) {
      logg.w('🚫 EPI Filter Initialization: EPI data is null');
      return;
    }

    logg.i('🔧 EPI Filter Initialization: Starting with EPI data');
    Future.microtask(() {
      final filterController = ref.read(filterControllerProvider.notifier);
      filterController.initializeFromEpiData(
        epiData: epiData,
        isEpiDetailsContext: true,
        epiUid: widget.epiUid, // ✅ FIX: Pass the EPI UID from screen
        ccUid: widget.ccUid, // ✅ FIX: Pass the CC UID from screen
      );
      logg.i('✅ EPI Filter Initialization: Completed');
    });
  }

  @override
  Widget build(BuildContext context) {
    final epiState = ref.watch(epiCenterControllerProvider);
    final filterState = ref.watch(filterControllerProvider);
    final selectedYear = filterState.selectedYear;
    final updatedAt = epiState.epiCenterData?.area?.updatedAt;

    // Initialize filter context when EPI data is loaded
    if (epiState.epiCenterData != null && !filterState.isEpiDetailsContext) {
      logg.i('🔧 EPI Screen: Initializing filter context with EPI data');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _initializeFilterWithEpiData(epiState.epiCenterData);
      });
    }

    // Listen for filter changes in EPI context
    ref.listen<FilterState>(filterControllerProvider, (previous, current) {
      logg.i(
        '👂 EPI Screen: Filter state changed: ${current.lastAppliedTimestamp != previous?.lastAppliedTimestamp}',
      );
      if (previous?.lastAppliedTimestamp != current.lastAppliedTimestamp &&
          current.lastAppliedTimestamp != null) {
        logg.i(
          '🔔 EPI Screen: Detected filter application - reloading EPI data',
        );
        _reloadEpiDetailsDataForFilterChange(current.selectedYear);
      }
    });

    // ✅ FIX: Listen for EPI state changes to update filter when new CC data is loaded
    ref.listen<EpiCenterState>(epiCenterControllerProvider, (
      previous,
      current,
    ) {
      // Get current filter state inside the listener
      final currentFilterState = ref.read(filterControllerProvider);

      // Check if EPI data was successfully loaded and it's different from previous
      if (previous?.epiCenterData != current.epiCenterData &&
          current.epiCenterData != null &&
          !current.isLoading &&
          !current.hasError &&
          currentFilterState.isEpiDetailsContext) {
        logg.i('🔄 EPI Screen: New EPI data loaded - updating filter state');
        logg.i(
          '   Previous EPI data: ${previous?.epiCenterData?.cityCorporationName}',
        );
        logg.i(
          '   Current EPI data: ${current.epiCenterData?.cityCorporationName}',
        );

        // Update filter state to reflect the newly loaded CC data
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _initializeFilterWithEpiData(current.epiCenterData);
        });
      }
    });

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          // Clear EPI context when navigating back
          _clearEpiContextOfFilter();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          leading: BackButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Clear EPI context when navigating back
              _clearEpiContextOfFilter();
            },
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'EPI Center Details',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          backgroundColor: Colors.white,
          elevation: 2,
        ),
        body: epiState.isLoading
            ? const Center(
                child: CustomLoadingWidget(
                  loadingText: 'Loading EPI Center data...',
                ),
              )
            : epiState.hasError || epiState.epiCenterData == null
            ? EpiCenterEmptyStateWidget()
            : _buildContent(
                epiState.epiCenterData!,
                selectedYear,
                updatedAt,
                filterState,
              ),
      ),
    );
  }

  Widget _buildContent(
    EpiCenterDetailsResponse? epiCenterData,
    String selectedYear,
    String? updatedAt,
    FilterState filterState,
  ) {
    final updatedAtTime = formatDateTime(updatedAt);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Location breadcrumb: Country > Division > District > Upazila > EPI Center
          EpiCenterLocationBreadcrumb(epiData: epiCenterData),
          if (updatedAtTime != null) ...[
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.access_time, size: 14, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      'Data last updated at: $updatedAtTime',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
                IconButton(
                  icon: SvgPicture.asset(
                    Constants.filterIconPath,
                    width: 20,
                    height: 20,
                    colorFilter: const ColorFilter.mode(
                      Colors.grey,
                      BlendMode.srcIn,
                    ),
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => Dialog(
                        backgroundColor: Color(Constants.cardColor),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        insetPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                        ),
                        child: const FilterDialogBoxWidget(isEpiContext: true),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
          const SizedBox(height: 16),

          // City corporation info (if available)
          // EpiCenterCityCorporationInfo(epiData: epiCenterData),
          _buildTargetCard(
            epiCenterData,
            selectedYear,
            widget.coverageData,
            widget.selectedVaccineUid,
            ref,
          ),
          const SizedBox(height: 16),

          // Coverage tables
          EpiCenterCoverageTablesWidget(epiCenterDetailsData: epiCenterData),
          const SizedBox(height: 24),

          // Chart section
          EpiCenterTargetCoverageGraphChartWidget(
            chartData: epiCenterData?.chartData,
            selectedYear: selectedYear,
          ), // datasets field is responsible for the graph
          const SizedBox(height: 24),
          // Microplan section
          EpiCenterMicroplanSection(
            epiCenterDetailsData: epiCenterData,
          ),
          const SizedBox(height: 24),
          if (EpiDetailsHelpers.shouldShowSubblockOnlySections(filterState)) ...[
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
    );
  }

  Widget _buildTargetCard(
    EpiCenterDetailsResponse? epiCenterData,
    String selectedYear,
    VaccineCoverageResponse? coverageData,
    String? selectedVaccineUid,
    WidgetRef ref,
  ) {
    final filterState = ref.read(filterControllerProvider);
    final filterNotifier = ref.read(filterControllerProvider.notifier);

    final calcTarget = EpiDetailsHelpers.resolveTargetValue(
      epiData: epiCenterData,
      filterState: filterState,
      filterNotifier: filterNotifier,
      coverageData: coverageData,
      selectedVaccineUid: selectedVaccineUid,
      selectedYear: selectedYear,
    );

    final targetValue = calcTarget != null ? calcTarget.toString() : 'N/A';

    return Card(
      elevation: 0,
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(Constants.dartImgPath, width: 35),
            12.w,
            Text(
              'Target: $targetValue',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
