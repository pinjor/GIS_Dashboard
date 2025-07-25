// 📁 screens/summary_screen.dart
import 'package:flutter/material.dart';

import '../../../../core/common/widgets/header_title_icon_filter_widget.dart';

class SummaryScreen extends StatelessWidget {
  const SummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeaderTitleIconFilterWidget(
            region: 'Bangladesh',
            year: '2015',
            vaccine: 'Penta-1',
          ),
          const SizedBox(height: 16),
          // Row(
          //   children: const [
          //     Expanded(
          //       child: SummaryCard(
          //         iconPath: 'assets/icons/children.svg',
          //         label: 'Total Children\n(0-11 month)',
          //         value: '153,543',
          //       ),
          //     ),
          //     SizedBox(width: 12),
          //     Expanded(
          //       child: SummaryCard(
          //         iconPath: 'assets/icons/doses.svg',
          //         label: 'Doses Administered\n(0-11 month)',
          //         value: '103,543',
          //       ),
          //     ),
          //   ],
          // ),
          const SizedBox(height: 24),
          const Text(
            'Vaccine Coverage',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          // const VaccineDonutChart(),
          const SizedBox(height: 24),
          const Text(
            'Penta-1 Vaccine Achievements',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          // const LineChartAchievements(),
        ],
      ),
    );
  }
}

// NOTE: Assume `FilterPanel`, `SummaryCard`, `VaccineDonutChart`, and `LineChartAchievements`
// are implemented in their respective widget files.
