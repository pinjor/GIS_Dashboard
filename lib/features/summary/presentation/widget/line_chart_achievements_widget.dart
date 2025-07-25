// 📁 widgets/line_chart_achievements.dart
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:gis_dashboard/core/utils/utils.dart';

class LineChartAchievementsWidget extends StatelessWidget {
  const LineChartAchievementsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final List<FlSpot> spots = [
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

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: const Text(
                'Penta-1 Vaccine Achievements',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            16.h,

            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  borderData: FlBorderData(show: true),
                  gridData: FlGridData(show: true),
                  maxY: 1000,
                  minY: 0,
                  titlesData: FlTitlesData(
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
