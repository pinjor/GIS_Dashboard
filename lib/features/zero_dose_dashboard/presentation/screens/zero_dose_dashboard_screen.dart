import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gis_dashboard/core/common/enums/vaccine_type.dart';
import '../../../../core/common/constants/constants.dart';
import '../../../summary/presentation/controllers/summary_controller.dart';
import '../../../summary/domain/vaccine_coverage_response.dart';
import '../widgets/zero_dose_bar_chart_widget.dart';

class ZeroDoseDashboardScreen extends ConsumerWidget {
  const ZeroDoseDashboardScreen({super.key});

  String _getLocationName(String locationName) {
    if (locationName.isEmpty) return 'Bangladesh';
    return locationName.replaceAll(RegExp(r'\s*\(.*?\)'), '').trim();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
        areasWithZeroDose.sort((a, b) {
          final zeroDoseA = (a.target ?? 0) - (a.coverage ?? 0);
          final zeroDoseB = (b.target ?? 0) - (b.coverage ?? 0);
          return zeroDoseB.compareTo(zeroDoseA);
        });

        // Take top 5
        topZeroDoseAreas = areasWithZeroDose.take(5).toList();
      }
    }

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
                // Bar chart showing top 5 zero dose areas
                Expanded(
                  child: ZeroDoseBarChartWidget(
                    topAreas: topZeroDoseAreas,
                    locationName: locationName,
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
}
