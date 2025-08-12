import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gis_dashboard/core/providers/filter_provider.dart';
import 'package:gis_dashboard/core/utils/utils.dart';
import 'package:gis_dashboard/features/map/presentation/widget/custom_loading_map_widget.dart';
import 'package:gis_dashboard/features/summary/presentation/widget/summary_card_widget.dart';

import '../../../../core/common/constants/constants.dart';
import '../../../../core/common/widgets/header_title_icon_filter_widget.dart';
import '../controllers/summary_controller.dart';
import '../widget/line_chart_achievements_widget.dart';

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
    final filterState = ref.watch(filterProvider);

    // Find the selected vaccine data
    final vaccines = summaryState.coverageData?.vaccines ?? [];
    final selectedVaccineData = vaccines.isNotEmpty
        ? vaccines.firstWhere(
            (vaccine) => vaccine.vaccineName == filterState.selectedVaccine,
            orElse: () => vaccines.first,
          )
        : null;

    return Scaffold(
      backgroundColor: Color(Constants.scaffoldBackgroundColor),
      body: summaryState.isLoading
          ? Center(
              child: CustomLoadingMapWidget(
                loadingText: 'Loading summary data...',
              ),
            )
          : summaryState.error != null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${summaryState.error}'),
                  ElevatedButton(
                    onPressed: () {
                      ref
                          .read(summaryControllerProvider.notifier)
                          .refreshSummaryData();
                    },
                    child: Text('Retry'),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HeaderTitleIconFilterWidget(),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: SummaryCardWidget(
                          iconPath: Constants.childrenIconPath,
                          label: 'Total Children',
                          duration: '0-11 month',
                          value:
                              selectedVaccineData?.totalTarget?.toString() ??
                              'Unknown',
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: SummaryCardWidget(
                          iconPath: Constants.dosesIconPath,
                          label: 'Doses Administered',
                          duration: '0-11 month',
                          value:
                              selectedVaccineData?.totalCoverage?.toString() ??
                              'Unknown',
                        ),
                      ),
                    ],
                  ),
                  // 16.h,
                  // const VaccineDonutChartWidget(),
                  // performance table needed here
                  16.h,

                  const LineChartAchievementsWidget(),
                ],
              ),
            ),
    );
  }
}
