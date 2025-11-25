import 'package:flutter/material.dart';
import 'package:gis_dashboard/core/common/constants/constants.dart';
import 'package:gis_dashboard/features/gis_methodology/presentation/widgets/crowd_mapping_widget.dart';

import 'package:gis_dashboard/features/gis_methodology/presentation/widgets/processing_header_section.dart';

import '../../../../core/common/constants/app_sizes.dart';
import '../widgets/dashboard_feature_overview.dart';
import '../widgets/e_stir_dashboard_widget.dart';
import '../widgets/gis_database_preparation_widget.dart';
import '../widgets/gis_mapping_process_tabs_widget.dart';
import '../widgets/gis_processing_data_collection_widget.dart';
import '../widgets/gis_data_preparation_widget.dart';
import '../widgets/impact_section_widget.dart';
import '../widgets/output_gis_dashboard_widget.dart';
import '../widgets/planning_module_widget.dart';

class GisProcessingScreen extends StatelessWidget {
  const GisProcessingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(Constants.scaffoldBackgroundColor),
      appBar: AppBar(
        title: const Text('GIS Processing'),
        backgroundColor: Color(Constants.primaryColor),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        // padding: const EdgeInsets.all(Sizes.p16),
        child: Padding(
          padding: const EdgeInsets.all(0.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              const ProcessingHeaderSection(),
              const SizedBox(height: Sizes.p16),
              const GisProcessingDataCollectionWidget(),
              const SizedBox(height: Sizes.p16),
              const GisDataPreparationWidget(),
              const SizedBox(height: Sizes.p32),
              const CrowdMappingWidget(),
              const SizedBox(height: Sizes.p32),
              const GisMappingProcessTabsWidget(),
              const SizedBox(height: Sizes.p32),
              const GisDatabasePreparationWidget(),
              const SizedBox(height: Sizes.p32),

              const DashboardFeatureOverview(),
              const SizedBox(height: Sizes.p32),
              const EStirDashboardWidget(),
              const SizedBox(height: Sizes.p32),
              const PlanningModulesWidget(),
              const SizedBox(height: Sizes.p32),
              const OutputGisDashboardWidget(),
              const SizedBox(height: Sizes.p32),
              const ImpactSectionWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
