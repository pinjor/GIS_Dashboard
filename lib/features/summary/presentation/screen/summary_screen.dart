import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gis_dashboard/core/common/widgets/network_error_widget.dart';
import 'package:gis_dashboard/features/filter/filter.dart';
import 'package:gis_dashboard/core/utils/utils.dart';
import 'package:gis_dashboard/core/utils/target_calculator.dart';
import 'package:gis_dashboard/features/epi_center/utils/epi_details_helpers.dart';

import '../../../../core/common/constants/constants.dart';
import '../../../../core/common/widgets/custom_loading_widget.dart';
import '../../../../core/common/widgets/header_title_icon_filter_widget.dart';
import '../../../map/presentation/controllers/map_controller.dart';
import '../controllers/summary_controller.dart';
import '../widget/summary_card_widget.dart';
import '../widget/vaccine_performance_graph_widget.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(summaryControllerProvider.notifier).loadSummaryData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final summaryState = ref.watch(summaryControllerProvider);
    final filterState = ref.watch(filterControllerProvider);
    final filterNotifier = ref.read(filterControllerProvider.notifier);
    final mapState = ref.watch(mapControllerProvider);
    final isMapLoading = mapState.isLoading;

    final areaFilter = isMapLoading
        ? (uid: null, name: null)
        : EpiDetailsHelpers.resolveCoverageAreaFilter(
            filterState,
            filterNotifier,
            currentLevel: summaryState.currentLevel,
            currentAreaName: summaryState.currentAreaName,
          );

    final targetData = TargetCalculator.getTargetData(
      summaryState.coverageData,
      filterState.selectedVaccine,
      areaUid: areaFilter.uid,
      areaName: areaFilter.uid == null ? areaFilter.name : null,
    );

    final coverageData = TargetCalculator.getCoverageData(
      summaryState.coverageData,
      filterState.selectedVaccine,
      areaUid: areaFilter.uid,
      areaName: areaFilter.uid == null ? areaFilter.name : null,
    );

    final targetMale = targetData?.male ?? 0;
    final targetFemale = targetData?.female ?? 0;
    final selectedVaccineTotalTarget = targetData?.total ?? 0;

    final coverageMale = coverageData?.male ?? 0;
    final coverageFemale = coverageData?.female ?? 0;
    final selectedVaccineTotalCoverage = coverageData?.total ?? 0;

    logg.i(
      'Summary Screen: area=${areaFilter.name ?? areaFilter.uid ?? summaryState.currentAreaName} '
      'target=$selectedVaccineTotalTarget coverage=$selectedVaccineTotalCoverage',
    );

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
                  HeaderTitleIconFilterWidget(
                    areaLabel:
                        '${summaryState.currentAreaName}, ${filterState.selectedYear}',
                  ),
                  const SizedBox(height: 16),
                  Column(
                    children: [
                      SummaryCardWidget(
                        label: 'Total Children (0-11 m)',
                        value: selectedVaccineTotalTarget.toString(),
                        boysCount: targetMale,
                        girlsCount: targetFemale,
                      ),
                      10.h,
                      SummaryCardWidget(
                        label: 'Vaccinated Children',
                        value: selectedVaccineTotalCoverage.toString(),
                        boysCount: coverageMale,
                        girlsCount: coverageFemale,
                        isFirst: false,
                      ),
                    ],
                  ),
                  16.h,
                  const VaccineCoveragePerformanceTableWidget(),
                  16.h,
                  const VaccinePerformanceGraphWidget(),
                  16.h,
                  const ViewDetailsButtonWidget(),
                ],
              ),
            ),
    );
  }
}
