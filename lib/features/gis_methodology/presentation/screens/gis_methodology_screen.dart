import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gis_dashboard/core/common/constants/constants.dart';
import 'package:gis_dashboard/features/gis_methodology/presentation/widgets/crowd_mapping_widget.dart';

import 'package:gis_dashboard/features/gis_methodology/presentation/widgets/processing_header_section.dart';

import '../../../../core/common/constants/app_sizes.dart';
import '../widgets/dashboard_feature_overview.dart';
import '../widgets/e_stir_dashboard_widget.dart';
import '../widgets/etl_processing_widget.dart';
import '../widgets/gis_database_preparation_widget.dart';
import '../widgets/gis_mapping_process_tabs_widget.dart';
import '../widgets/gis_processing_data_collection_widget.dart';
import '../widgets/gis_data_preparation_widget.dart';
import '../widgets/impact_section_widget.dart';
import '../widgets/output_gis_dashboard_widget.dart';
import '../widgets/planning_module_widget.dart';

class GisMethodologyScreen extends StatefulWidget {
  const GisMethodologyScreen({super.key});

  @override
  State<GisMethodologyScreen> createState() => _GisMethodologyScreenState();
}

class _GisMethodologyScreenState extends State<GisMethodologyScreen> {
  final ScrollController _scrollController = ScrollController();

  final GlobalKey _epiCollectionKey = GlobalKey();
  final GlobalKey _crowdMappingKey = GlobalKey();
  final GlobalKey _gisDataPrepKey = GlobalKey();
  final GlobalKey _etlKey = GlobalKey();
  final GlobalKey _dashboardKey = GlobalKey();

  void _scrollTo(GlobalKey key) {
    final targetContext = key.currentContext;
    if (targetContext == null || !_scrollController.hasClients) return;

    final targetRenderObject = targetContext.findRenderObject();
    if (targetRenderObject == null) return;

    final viewport = RenderAbstractViewport.of(targetRenderObject);
    final revealOffset = viewport.getOffsetToReveal(targetRenderObject, 0.0).offset;
    final targetOffset = (revealOffset - 12).clamp(
      _scrollController.position.minScrollExtent,
      _scrollController.position.maxScrollExtent,
    );

    _scrollController.animateTo(
      targetOffset.toDouble(),
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(Constants.scaffoldBackgroundColor),
      appBar: AppBar(
        title: const Text('GIS Methodology'),
        backgroundColor: Color(Constants.primaryColor),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        // padding: const EdgeInsets.all(Sizes.p16),
        child: Padding(
          padding: const EdgeInsets.all(0.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              ProcessingHeaderSection(
                onTapEpiCenterCollection: () => _scrollTo(_epiCollectionKey),
                onTapCrowdMapping: () => _scrollTo(_crowdMappingKey),
                onTapGisDataPreparation: () => _scrollTo(_gisDataPrepKey),
                onTapDashboardDevelopment: () => _scrollTo(_dashboardKey),
                onTapEtlProcessing: () => _scrollTo(_etlKey),
              ),
              const SizedBox(height: Sizes.p16),
              KeyedSubtree(
                key: _epiCollectionKey,
                child: const GisProcessingDataCollectionWidget(),
              ),
              const SizedBox(height: Sizes.p16),
              KeyedSubtree(
                key: _gisDataPrepKey,
                child: const GisDataPreparationWidget(),
              ),
              const SizedBox(height: Sizes.p32),
              KeyedSubtree(
                key: _etlKey,
                child: const EtlProcessingWidget(),
              ),
              const SizedBox(height: Sizes.p32),
              KeyedSubtree(
                key: _crowdMappingKey,
                child: const CrowdMappingWidget(),
              ),
              const SizedBox(height: Sizes.p32),
              const GisMappingProcessTabsWidget(),
              const SizedBox(height: Sizes.p32),
              const GisDatabasePreparationWidget(),
              const SizedBox(height: Sizes.p32),

              KeyedSubtree(
                key: _dashboardKey,
                child: const DashboardFeatureOverview(),
              ),
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
