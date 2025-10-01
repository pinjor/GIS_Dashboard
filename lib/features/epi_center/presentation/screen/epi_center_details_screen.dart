import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gis_dashboard/core/common/constants/constants.dart';
import 'package:gis_dashboard/features/epi_center/domain/epi_center_details_response.dart';
import 'package:gis_dashboard/features/epi_center/presentation/widgets/epi_center_about_details_widget.dart';
import 'package:gis_dashboard/features/epi_center/presentation/widgets/epi_yearly_session_personnel_widget.dart';

import '../../../../core/common/widgets/custom_loading_widget.dart';
import '../../../../core/utils/utils.dart';
import '../../../filter/presentation/widgets/filter_dialog_box_widget.dart';
import '../controllers/epi_center_controller.dart';
import '../../../filter/presentation/controllers/filter_controller.dart';
import '../../../filter/domain/filter_state.dart';
import '../../../map/utils/map_enums.dart';
import '../widgets/epi_center_widgets.dart';

class EpiCenterDetailsScreen extends ConsumerStatefulWidget {
  final String epiUid;
  final int? currentLevel;
  final String? ccUid;
  final bool isOrgUidRequest; // Flag to indicate org_uid-based request

  const EpiCenterDetailsScreen({
    super.key,
    required this.epiUid,
    this.currentLevel,
    this.ccUid,
    this.isOrgUidRequest = false, // Default to false for backward compatibility
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

    logg.i('🔔 EPI Filter Change Detected');
    logg.i('isEpiDetailsContext: ${filterState.isEpiDetailsContext}');

    logg.i('🔄 EPI Filter Applied - Reloading data for year #$selectedYear');

    // For district area type, handle hierarchical filtering at any level
    if (filterState.selectedAreaType == AreaType.district) {
      final filterController = ref.read(filterControllerProvider.notifier);
      final epiController = ref.read(epiCenterControllerProvider.notifier);

      // ✅ PLAN A: Hierarchical data (unions, wards, subblocks) is instantly
      // available from cached lists - no need to load or wait for API calls!

      String? targetUid;
      String? targetName;
      final selectedSubblock = filterState.selectedSubblock;

      logg.i('🔍 Determining target level from filter state:');
      logg.i('   Selected Subblock: $selectedSubblock');
      logg.i('   Selected Ward: ${filterState.selectedWard}');
      logg.i('   Selected Union: ${filterState.selectedUnion}');
      logg.i('   Selected Upazila: ${filterState.selectedUpazila}');

      // Determine the most specific level selected (bottom-up approach)
      // Bottom-up hierarchical selection (most specific first)
      if (filterState.selectedSubblock != null &&
          filterState.selectedSubblock != 'All') {
        targetUid = filterController.getSubblockUid(selectedSubblock!);
        targetName = filterState.selectedSubblock;
        logg.i('🎯 Target level: SUBBLOCK ($targetName, UID: $targetUid)');
      } else if (filterState.selectedWard != null &&
          filterState.selectedWard != 'All') {
        targetUid = filterController.getWardUid(filterState.selectedWard!);
        targetName = filterState.selectedWard;
        logg.i('🎯 Target level: WARD ($targetName, UID: $targetUid)');
      } else if (filterState.selectedUnion != null &&
          filterState.selectedUnion != 'All') {
        targetUid = filterController.getUnionUid(filterState.selectedUnion!);
        targetName = filterState.selectedUnion;
        logg.i('🎯 Target level: UNION ($targetName, UID: $targetUid)');
      } else if (filterState.selectedUpazila != null &&
          filterState.selectedUpazila != 'All') {
        targetUid = filterController.getUpazilaUid(
          filterState.selectedUpazila!,
        );
        targetName = filterState.selectedUpazila;
        logg.i('🎯 Target level: UPAZILA ($targetName, UID: $targetUid)');
      }

      if (targetUid != null && targetName != null) {
        logg.i('📍 Loading EPI data for: $targetName (UID: $targetUid)');

        try {
          await epiController.fetchEpiCenterData(
            epiUid: targetUid,
            year: int.tryParse(selectedYear) ?? DateTime.now().year,
            ccUid: null,
          );
          logg.i('✅ Successfully reloaded EPI data for filter change');
        } catch (e) {
          logg.e('❌ Failed to reload EPI data: $e');
          // Handle error appropriately
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Failed to load EPI data: ${e.toString()}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      } else {
        logg.w(
          '🚫 targetUid is NULL - this indicates hierarchical data is not loaded yet or selection is invalid',
        );
        logg.w(
          '   This should be fixed by ensuring hierarchical data is loaded first',
        );
        logg.i(
          '📍 No specific hierarchical level selected - keeping current EPI data',
        );
      }
    } else {
      logg.i(
        '   Area type is not district - no hierarchical filtering applied',
      );
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
              // if (widget.currentLevel != null)
              //   Text(
              //     'EPI Center Details',
              //     style: TextStyle(
              //       fontSize: 14,
              //       color: Colors.grey[600],
              //       fontWeight: FontWeight.normal,
              //     ),
              //   ),
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
            : _buildContent(epiState.epiCenterData!, selectedYear, updatedAt),
      ),
    );
  }

  Widget _buildContent(
    EpiCenterDetailsResponse? epiCenterData,
    String selectedYear,
    String? updatedAt,
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
                Text(
                  'Last updated at: $updatedAtTime',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
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
          _buildTargetCard(epiCenterData, selectedYear),
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
          EpiCenterMicroplanSection(epiCenterDetailsData: epiCenterData),
          const SizedBox(height: 24),
          EpiCenterAboutDetailsWidget(
            epiCenterDetailsData: epiCenterData,
            selectedYear: selectedYear,
          ),
          SizedBox(height: 10),
          EpiYearlySessionPersonnelWidget(
            epiCenterDetailsData: epiCenterData,
            selectedYear: selectedYear,
          ),
        ],
      ),
    );
  }

  Widget _buildTargetCard(
    EpiCenterDetailsResponse? epiCenterData,
    String selectedYear,
  ) {
    final vaccineTarget =
        epiCenterData?.area?.vaccineTarget?.child0To11Month[selectedYear];
    final targetValue = vaccineTarget != null
        ? ((vaccineTarget.male?.toInt() ?? 0) +
              (vaccineTarget.female?.toInt() ?? 0))
        : 'N/A';

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
