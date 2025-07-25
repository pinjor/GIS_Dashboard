import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:gis_dashboard/core/utils/utils.dart';

class VaccineDonutChartWidget extends StatelessWidget {
  const VaccineDonutChartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final sections = [
      PieChartSectionData(
        value: 45,
        color: Color(0xFFF48FB1),
        title: '45%',
        radius: 40,
      ),
      PieChartSectionData(
        value: 5,
        color: Color(0xFFEC407A),
        title: '5%',
        radius: 40,
      ),
      PieChartSectionData(
        value: 42,
        color: Color(0xFF40C4F8),
        title: '42%',
        radius: 40,
      ),
      PieChartSectionData(
        value: 8,
        color: Color(0xFF0288D1),
        title: '8%',
        radius: 40,
      ),
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
                'Vaccine Coverage',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            20.h,
            Row(
              children: [
                SizedBox(
                  height: 130,
                  width: 130,
                  child: PieChart(
                    PieChartData(
                      sections: sections,
                      centerSpaceRadius: 35,
                      sectionsSpace: 2,
                      startDegreeOffset: 180,
                    ),
                  ),
                ),
                32.w,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    LegendItem('Vaccinated Boys', Color(0xFF42A5F5)),
                    LegendItem('Dropout Boys', Color(0xFF0288D1)),
                    LegendItem('Vaccinated Girls', Color(0xFFF48FB1)),
                    LegendItem('Dropout Girls', Color(0xFFEC407A)),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class LegendItem extends StatelessWidget {
  final String text;
  final Color color;

  const LegendItem(this.text, this.color, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(color: color),
          ),
          const SizedBox(width: 8),
          Text(text, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
