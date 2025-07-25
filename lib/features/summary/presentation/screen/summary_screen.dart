// 📁 screens/summary_screen.dart
import 'package:flutter/material.dart';
import 'package:gis_dashboard/core/utils/utils.dart';
import 'package:gis_dashboard/features/summary/presentation/widget/summary_card_widget.dart';

import '../../../../core/common/constants/constants.dart';
import '../../../../core/common/widgets/header_title_icon_filter_widget.dart';
import '../widget/line_chart_achievements_widget.dart';
import '../widget/vaccine_donut_chart_widget.dart';

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
          Row(
            children: const [
              Expanded(
                child: SummaryCardWidget(
                  iconPath: Constants.childrenIconPath,
                  label: 'Total Children',
                  duration: '0-11 month',
                  value: '153,543',
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: SummaryCardWidget(
                  iconPath: Constants.dosesIconPath,
                  label: 'Doses Administered',
                  duration: '0-11 month',
                  value: '103,543',
                ),
              ),
            ],
          ),
          16.h,
          const VaccineDonutChartWidget(),
          16.h,

          const LineChartAchievementsWidget(),
        ],
      ),
    );
  }
}
