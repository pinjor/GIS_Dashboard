import 'package:flutter/material.dart';
import '../../../../core/common/constants/constants.dart';
import '../../../epi_center/presentation/widgets/epi_center_about_details_widget.dart';
import '../../../epi_center/presentation/widgets/epi_center_microplan_widgets.dart';
import '../../../epi_center/presentation/widgets/epi_yearly_session_personnel_widget.dart';

class MicroPlanScreen extends StatelessWidget {
  const MicroPlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(Constants.primaryColor),
        title: const Text('Micro Plan', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // EpiCenterMicroplanSection(epiCenterDetailsData: epiCenterData),
          // const SizedBox(height: 24),
          // EpiCenterAboutDetailsWidget(
          //   epiCenterDetailsData: epiCenterData,
          //   selectedYear: selectedYear,
          // ),
          // SizedBox(height: 10),
          // EpiYearlySessionPersonnelWidget(
          //   epiCenterDetailsData: epiCenterData,
          //   selectedYear: selectedYear,
          // ),

        ],
      ),
    );
  }
}
