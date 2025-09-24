import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gis_dashboard/core/common/constants/constants.dart';
import 'package:gis_dashboard/features/epi_center/domain/epi_center_details_response.dart';
import 'package:gis_dashboard/features/epi_center/presentation/widgets/epi_center_about_details_widget.dart';
import 'package:gis_dashboard/features/epi_center/presentation/widgets/epi_yearly_session_personnel_widget.dart';

// Core imports
import '../../../../core/common/widgets/custom_loading_widget.dart';

// Feature imports
import '../../../../core/utils/utils.dart';
import '../controllers/epi_center_controller.dart';
import '../../../filter/presentation/controllers/filter_controller.dart';

// Widget imports
import '../widgets/epi_center_widgets.dart';

class EpiCenterDetailsScreen extends ConsumerStatefulWidget {
  final String epiCenterName;
  final String epiUid;
  final int? currentLevel;
  final String? ccUid;

  const EpiCenterDetailsScreen({
    super.key,
    required this.epiCenterName,
    required this.epiUid,
    this.currentLevel,
    this.ccUid,
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
      final year =
          int.tryParse(filterState.selectedYear) ?? DateTime.now().year;

      logg.i('🔍 EPI Center Screen - Loading data for:');
      logg.i('   EPI UID: ${widget.epiUid}');
      logg.i('   Center Name: ${widget.epiCenterName}');
      logg.i('   Year: $year');
      logg.i('   CC UID: ${widget.ccUid}');

      ref
          .read(epiCenterControllerProvider.notifier)
          .fetchEpiCenterData(
            epiUid: widget.epiUid,
            year: year,
            ccUid: widget.ccUid,
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    final epiState = ref.watch(epiCenterControllerProvider);
    final filterState = ref.watch(filterControllerProvider);
    final selectedYear = filterState.selectedYear;
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
          : _buildContent(epiState.epiCenterData!, selectedYear),
    );
  }

  Widget _buildContent(
    EpiCenterDetailsResponse? epiCenterData,
    String selectedYear,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Location breadcrumb: Country > Division > District > Upazila > EPI Center
          EpiCenterLocationBreadcrumb(epiData: epiCenterData),
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
