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
import '../widgets/epi_center_widgets.dart';

class EpiCenterDetailsScreen extends ConsumerStatefulWidget {
  final String epiCenterName;
  final String epiUid;
  final int? currentLevel;
  final String? ccUid;
  final bool isOrgUidRequest; // Flag to indicate org_uid-based request

  const EpiCenterDetailsScreen({
    super.key,
    required this.epiCenterName,
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
  @override
  void initState() {
    super.initState();
    // Always load EPI center data when the screen initializes
    // The epiUid is required and should always be available from the navigation
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadEpiCenterData();
    });
  }

  Future<void> _loadEpiCenterData() async {
    Future.microtask(() {
      final filterState = ref.read(filterControllerProvider);
      final year = filterState.selectedYear;

      logg.i('🔍 EPI Center Screen - Loading data for:');
      logg.i('   EPI UID: ${widget.epiUid}');
      logg.i('   Center Name: ${widget.epiCenterName}');
      logg.i('   Year: $year');
      logg.i('   CC UID: ${widget.ccUid}');
      logg.i('   Is Org UID Request: ${widget.isOrgUidRequest}');

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

  @override
  Widget build(BuildContext context) {
    final epiState = ref.watch(epiCenterControllerProvider);
    final filterState = ref.watch(filterControllerProvider);
    final selectedYear = filterState.selectedYear;
    final updatedAt = epiState.epiCenterData?.area?.updatedAt;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.epiCenterName,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            if (widget.currentLevel != null)
              Text(
                'EPI Center Details',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.normal,
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
          ? EpiCenterEmptyStateWidget(epiCenterName: widget.epiCenterName)
          : _buildContent(epiState.epiCenterData!, selectedYear, updatedAt),
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
                        child: const FilterDialogBoxWidget(turnOff: true),
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
