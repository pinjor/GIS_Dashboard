import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gis_dashboard/core/common/enums/vaccine_type.dart';
import '../../../../core/common/constants/constants.dart';
import '../../../../core/utils/utils.dart';
import '../../../summary/presentation/controllers/summary_controller.dart';
import '../../../summary/domain/vaccine_coverage_response.dart';
import '../../../filter/filter.dart';
import '../widgets/zero_dose_bar_chart_widget.dart';

class ZeroDoseDashboardScreen extends ConsumerStatefulWidget {
  const ZeroDoseDashboardScreen({super.key});

  @override
  ConsumerState<ZeroDoseDashboardScreen> createState() =>
      _ZeroDoseDashboardScreenState();
}

class _ZeroDoseDashboardScreenState
    extends ConsumerState<ZeroDoseDashboardScreen> {

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
        child: const FilterDialogBoxWidget(isEpiContext: false),
      ),
    );
  }

  String _getLocationName(String locationName) {
    if (locationName.isEmpty) return 'Bangladesh';
    return locationName.replaceAll(RegExp(r'\s*\(.*?\)'), '').trim();
  }

  @override
  Widget build(BuildContext context) {
    final summaryState = ref.watch(summaryControllerProvider);
    final coverageData = summaryState.coverageData;
    final locationName = _getLocationName(summaryState.currentAreaName);

    // Extract Penta-1 vaccine data and calculate top 5 zero dose areas
    List<Area> topZeroDoseAreas = [];

    if (coverageData?.vaccines != null) {
      // Find Penta-1 vaccine
      final pentaVaccine = coverageData!.vaccines!.firstWhere(
        (vaccine) => vaccine.vaccineUid == VaccineType.penta1.uid,
        orElse: () => const Vaccine(),
      );

      if (pentaVaccine.areas != null && pentaVaccine.areas!.isNotEmpty) {
        // Calculate zero dose count for each area
        final areasWithZeroDose = pentaVaccine.areas!.map((area) {
          return area;
        }).toList();

        // Sort by zero dose count (target - coverage) in descending order
        // ✅ Allow negative values - they show areas where coverage exceeded target
        areasWithZeroDose.sort((a, b) {
          final zeroDoseA = (a.target ?? 0) - (a.coverage ?? 0);
          final zeroDoseB = (b.target ?? 0) - (b.coverage ?? 0);
          return zeroDoseB.compareTo(zeroDoseA);
        });

        // Take top 5
        topZeroDoseAreas = areasWithZeroDose.take(5).toList();
      }
    }

    // ✅ Listen to filter state changes - data will automatically update via summary controller
    ref.listen<FilterState>(filterControllerProvider, (previous, current) {
      if (previous != null &&
          current.lastAppliedTimestamp != null &&
          previous.lastAppliedTimestamp != current.lastAppliedTimestamp) {
        logg.i("Zero Dose Dashboard: Filter applied - data will update via summary controller");
      }
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(Constants.primaryColor),
        title: const Text(
          'Zero Dose Dashboard',
          style: TextStyle(color: Colors.white),
        ),
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
      body: summaryState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : summaryState.error != null
          ? Center(
              child: Text(
                'Error: ${summaryState.error}',
                style: const TextStyle(color: Colors.red),
              ),
            )
          : topZeroDoseAreas.isEmpty
          ? const Center(
              child: Text(
                'No Penta-1 data available',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : Column(
              children: [
                // Total Zero Dose Children summary card
                _buildTotalZeroDoseCard(coverageData),
                
                // Bar chart showing top 5 zero dose areas
                Expanded(
                  child: ZeroDoseBarChartWidget(
                    topAreas: topZeroDoseAreas,
                    locationName: locationName,
                    filterState: ref.read(filterControllerProvider),
                  ),
                ),

                // Placeholder for coverage visualizer (to be implemented later)
                // const Padding(
                //   padding: EdgeInsets.all(16.0),
                //   child: MapCoverageVisualizerCardWidget(
                //     currentLevel: GeographicLevel.country,
                //   ),
                // ),
              ],
            ),
    );
  }

  /// Build the total zero dose children summary card
  Widget _buildTotalZeroDoseCard(VaccineCoverageResponse? coverageData) {
    int totalZeroDoseCount = 0;

    if (coverageData?.vaccines != null) {
      // Find Penta-1 vaccine
      final pentaVaccine = coverageData!.vaccines!.firstWhere(
        (vaccine) => vaccine.vaccineUid == VaccineType.penta1.uid,
        orElse: () => const Vaccine(),
      );

      // Calculate total zero dose: totalTarget - totalCoverage
      // ✅ Allow negative values to show when coverage exceeds target
      if (pentaVaccine.totalTarget != null && pentaVaccine.totalCoverage != null) {
        totalZeroDoseCount = (pentaVaccine.totalTarget ?? 0) - (pentaVaccine.totalCoverage ?? 0);
        // Negative values are allowed - they indicate coverage exceeded target
      }
    }

    return Container(
      margin: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color(0xFF2196F3), // Blue color matching the bar chart
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Text section
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Total Zero Dose Children',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    totalZeroDoseCount.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            // Icons section
            Row(
              children: [
                const Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 24,
                ),
                const SizedBox(width: 4),
                const Icon(
                  Icons.child_care,
                  color: Colors.white,
                  size: 24,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
