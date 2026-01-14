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
    
    // 🔍 DEBUG: Log vaccine data structure
    if (vaccines.isNotEmpty) {
      logg.i(
        'Summary Screen: Found ${vaccines.length} vaccines. '
        'Selected vaccine UID: ${filterState.selectedVaccine}',
      );
      for (var vaccine in vaccines) {
        logg.i(
          'Vaccine: ${vaccine.vaccineName} (UID: ${vaccine.vaccineUid}), '
          'totalTarget: ${vaccine.totalTarget}, '
          'totalTargetMale: ${vaccine.totalTargetMale}, '
          'totalTargetFemale: ${vaccine.totalTargetFemale}, '
          'totalCoverage: ${vaccine.totalCoverage}, '
          'totalCoverageMale: ${vaccine.totalCoverageMale}, '
          'totalCoverageFemale: ${vaccine.totalCoverageFemale}',
        );
      }
    }
    
    final selectedVaccineData = vaccines.isNotEmpty
        ? vaccines.firstWhere(
            (vaccine) => vaccine.vaccineUid == filterState.selectedVaccine,
            orElse: () => vaccines.first,
          )
        : null;
    
    // Calculate totals - use top-level fields if available, otherwise sum from areas
    int selectedVaccineTotalTarget;
    int selectedVaccineTotalCoverage;
    int targetMale;
    int targetFemale;
    int coverageMale;
    int coverageFemale;
    
    if (selectedVaccineData != null) {
      // Try top-level fields first
      targetMale = selectedVaccineData.totalTargetMale ?? 0;
      targetFemale = selectedVaccineData.totalTargetFemale ?? 0;
      coverageMale = selectedVaccineData.totalCoverageMale ?? 0;
      coverageFemale = selectedVaccineData.totalCoverageFemale ?? 0;
      
      // If top-level fields are 0 or null, try to sum from areas array
      if ((targetMale == 0 && targetFemale == 0) && 
          selectedVaccineData.areas != null && 
          selectedVaccineData.areas!.isNotEmpty) {
        logg.i(
          'Summary Screen: Top-level target fields are 0, calculating from areas array (${selectedVaccineData.areas!.length} areas)',
        );
        targetMale = selectedVaccineData.areas!
            .map((area) => area.targetMale ?? 0)
            .fold(0, (sum, value) => sum + value);
        targetFemale = selectedVaccineData.areas!
            .map((area) => area.targetFemale ?? 0)
            .fold(0, (sum, value) => sum + value);
      }
      
      if ((coverageMale == 0 && coverageFemale == 0) && 
          selectedVaccineData.areas != null && 
          selectedVaccineData.areas!.isNotEmpty) {
        logg.i(
          'Summary Screen: Top-level coverage fields are 0, calculating from areas array (${selectedVaccineData.areas!.length} areas)',
        );
        coverageMale = selectedVaccineData.areas!
            .map((area) => area.coverageMale ?? 0)
            .fold(0, (sum, value) => sum + value);
        coverageFemale = selectedVaccineData.areas!
            .map((area) => area.coverageFemale ?? 0)
            .fold(0, (sum, value) => sum + value);
      }
      
      selectedVaccineTotalTarget = targetMale + targetFemale;
      selectedVaccineTotalCoverage = coverageMale + coverageFemale;
    } else {
      selectedVaccineTotalTarget = 0;
      selectedVaccineTotalCoverage = 0;
      targetMale = 0;
      targetFemale = 0;
      coverageMale = 0;
      coverageFemale = 0;
    }
    
    // 🔍 DEBUG: Log calculated values
    logg.i(
      'Summary Screen: Selected vaccine data - '
      'totalTarget: $selectedVaccineTotalTarget, '
      'totalCoverage: $selectedVaccineTotalCoverage, '
      'targetMale: $targetMale, '
      'targetFemale: $targetFemale, '
      'coverageMale: $coverageMale, '
      'coverageFemale: $coverageFemale, '
      'areas count: ${selectedVaccineData?.areas?.length ?? 0}',
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
                  HeaderTitleIconFilterWidget(),
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
                  // 16.h,
                  // const VaccinePerformanceGraphWidget(),
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
