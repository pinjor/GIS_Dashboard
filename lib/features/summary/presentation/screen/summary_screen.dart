import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gis_dashboard/core/common/widgets/network_error_widget.dart';
import 'package:gis_dashboard/features/filter/filter.dart';
import 'package:gis_dashboard/core/utils/utils.dart';

import '../../../../core/common/constants/constants.dart';
import '../../../../core/common/widgets/custom_loading_widget.dart';
import '../../../../core/common/widgets/header_title_icon_filter_widget.dart';
import '../../../map/presentation/controllers/map_controller.dart';
import '../controllers/summary_controller.dart';
import '../widget/summary_card_widget.dart';
import '../widget/vaccine_performance_graph_widget_v2.dart';
import '../widget/vaccine_coverage_performance_table_widget.dart';
import '../widget/view_details_button_widget.dart';

class SummaryScreen extends ConsumerStatefulWidget {
  const SummaryScreen({super.key});

  @override
  ConsumerState<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends ConsumerState<SummaryScreen> {
  @override
  void initState() {
    super.initState();
    // Load data when screen is first shown
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(summaryControllerProvider.notifier).loadSummaryData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final summaryState = ref.watch(summaryControllerProvider);
    final filterState = ref.watch(filterControllerProvider);
    final isMapLoading = ref.watch(mapControllerProvider).isLoading;

    // Find the selected vaccine data
    final vaccines = summaryState.coverageData?.vaccines ?? [];
    final selectedVaccineData = vaccines.isNotEmpty
        ? vaccines.firstWhere(
            (vaccine) => vaccine.vaccineUid == filterState.selectedVaccine,
            orElse: () => vaccines.first,
          )
        : null;
    final selectedVaccineTotalTarget =
        (selectedVaccineData?.totalTargetMale ?? 0) +
        (selectedVaccineData?.totalTargetFemale ?? 0);
    final selectedVaccineTotalCoverage =
        (selectedVaccineData?.totalCoverageMale ?? 0) +
        (selectedVaccineData?.totalCoverageFemale ?? 0);
    return Scaffold(
      backgroundColor: Color(Constants.scaffoldBackgroundColor),
      body: summaryState.isLoading
          ? Center(
              child: CustomLoadingWidget(
                loadingText: 'Loading summary data...',
              ),
            )
          : summaryState.error != null
          ? NetworkErrorWidget(
              error: summaryState.error!,
              onRetry: () {
                ref
                    .read(summaryControllerProvider.notifier)
                    .refreshSummaryData();
              },
            )
          : isMapLoading
          ? Container(
              color: Colors.black.withValues(alpha: 0.3),
              child: const Center(child: CustomLoadingWidget()),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HeaderTitleIconFilterWidget(),
                  const SizedBox(height: 16),
                  Column(
                    children: [
                      SummaryCardWidget(
                        label: 'Total Children (0-11 m)',
                        value: selectedVaccineTotalTarget.toString(),
                        boysCount: selectedVaccineData?.totalTargetMale ?? 0,
                        girlsCount: selectedVaccineData?.totalTargetFemale ?? 0,
                      ),
                      10.h,
                      SummaryCardWidget(
                        label: 'Vaccinated Children',
                        value: selectedVaccineTotalCoverage.toString(),
                        boysCount: selectedVaccineData?.totalCoverageMale ?? 0,
                        girlsCount:
                            selectedVaccineData?.totalCoverageFemale ?? 0,
                        isFirst: false,
                      ),
                    ],
                  ),
                  16.h,
                  const VaccineCoveragePerformanceTableWidget(),
                  // 16.h,
                  // const VaccinePerformanceGraphWidget(),
                  16.h,
                  const VaccinePerformanceGraphWidgetV2(),

                  16.h,
                  const ViewDetailsButtonWidget(),
                ],
              ),
            ),
    );
  }
}
