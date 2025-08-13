import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gis_dashboard/core/utils/utils.dart';
import 'package:gis_dashboard/core/providers/filter_provider.dart';
import 'package:gis_dashboard/features/summary/presentation/controllers/summary_controller.dart';

import '../../../../core/common/constants/constants.dart';

class VaccinePerformanceGraphWidget extends ConsumerWidget {
  const VaccinePerformanceGraphWidget({super.key});

  // Helper function to format large numbers for Y-axis
  String _formatYAxisLabel(double value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M';
    } else if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(0)}K';
    } else {
      return value.toInt().toString();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filterState = ref.watch(filterProvider);
    final summaryState = ref.watch(summaryControllerProvider);

    // Show loading or error state
    if (summaryState.isLoading) {
      return Card(
        color: Color(Constants.cardColor),
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: const Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Vaccine Achievements',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              SizedBox(height: 16),
              SizedBox(
                height: 200,
                child: Center(child: CircularProgressIndicator()),
              ),
            ],
          ),
        ),
      );
    }

    if (summaryState.error != null ||
        summaryState.coverageData?.vaccines?.isEmpty == true) {
      return Card(
        color: Color(Constants.cardColor),
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: const Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Vaccine Achievements',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              SizedBox(height: 16),
              SizedBox(
                height: 200,
                child: Center(
                  child: Text(
                    'No data available',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Find the selected vaccine from the coverage data
    final vaccines = summaryState.coverageData?.vaccines ?? [];
    final selectedVaccine = vaccines.isNotEmpty
        ? vaccines.firstWhere(
            (vaccine) => vaccine.vaccineName == filterState.selectedVaccine,
            orElse: () => vaccines.first,
          )
        : null;

    // Extract monthly coverage data
    List<FlSpot> spots = [];
    double maxY = 100; // Default max value

    if (selectedVaccine?.monthWiseTotalCoverages != null) {
      final monthlyData = selectedVaccine!.monthWiseTotalCoverages!;
      final coverageValues = <double>[];

      for (int month = 1; month <= 12; month++) {
        final monthData = monthlyData[month.toString()];
        final coverage = monthData?.coverage?.toDouble() ?? 0.0;
        spots.add(FlSpot(month - 1.0, coverage));
        coverageValues.add(coverage);
      }

      // Calculate dynamic max Y value with some padding
      if (coverageValues.isNotEmpty) {
        final maxValue = coverageValues.reduce((a, b) => a > b ? a : b);
        maxY = maxValue * 1.2; // Add 20% padding
        if (maxY < 100) maxY = 100; // Minimum scale
        // Round up to nearest thousand for better visualization
        if (maxY > 1000) {
          maxY = ((maxY / 1000).ceil() * 1000).toDouble();
        }
      }
    } else {
      // Fallback data if no monthly data is available
      spots = [
        FlSpot(0, 250),
        FlSpot(1, 700),
        FlSpot(2, 500),
        FlSpot(3, 480),
        FlSpot(4, 510),
        FlSpot(5, 730),
        FlSpot(6, 710),
        FlSpot(7, 600),
        FlSpot(8, 550),
        FlSpot(9, 650),
        FlSpot(10, 870),
        FlSpot(11, 640),
      ];
      maxY = 1000;
    }

    return Card(
      color: Color(Constants.cardColor),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '${selectedVaccine?.vaccineName ?? filterState.selectedVaccine} Vaccine Achievements',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            16.h,

            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  borderData: FlBorderData(show: true),
                  gridData: FlGridData(show: true),
                  maxY: maxY,
                  minY: 0,
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 50,
                        getTitlesWidget: (value, _) {
                          return Text(
                            _formatYAxisLabel(value),
                            style: const TextStyle(
                              fontSize: 11,
                              color: Colors.black,
                            ),
                          );
                        },
                        interval: maxY > 10000 ? maxY / 4 : maxY / 5,
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, _) {
                          const months = [
                            'Jan',
                            'Feb',
                            'Mar',
                            'Apr',
                            'May',
                            'Jun',
                            'Jul',
                            'Aug',
                            'Sep',
                            'Oct',
                            'Nov',
                            'Dec',
                          ];
                          return Text(
                            months[value.toInt()],
                            style: const TextStyle(fontSize: 10),
                          );
                        },
                        interval: 1,
                      ),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: false,
                      barWidth: 2,
                      shadow: const Shadow(
                        color: Colors.blue,
                        blurRadius: 4,
                        offset: Offset(2, 2),
                      ),
                      curveSmoothness: 0.1,
                      dotData: FlDotData(show: true),
                      belowBarData: BarAreaData(
                        show: true,
                        applyCutOffY: true,
                        gradient: LinearGradient(
                          colors: [
                            Colors.blue.withOpacity(0.4),
                            Colors.blue.withOpacity(0.01),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        color: Colors.blue.withOpacity(0.3),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
