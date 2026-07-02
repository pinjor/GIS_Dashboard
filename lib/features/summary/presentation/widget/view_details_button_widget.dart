import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gis_dashboard/core/utils/utils.dart';
import 'package:gis_dashboard/features/epi_center/presentation/controllers/epi_center_controller.dart';
import 'package:gis_dashboard/features/epi_center/presentation/screen/epi_center_details_screen.dart';
import 'package:gis_dashboard/features/epi_center/utils/chart_area_uid_resolver.dart';
import 'package:gis_dashboard/features/map/presentation/controllers/map_controller.dart';
import 'package:gis_dashboard/features/summary/presentation/controllers/summary_controller.dart';
import 'package:gis_dashboard/features/filter/presentation/controllers/filter_controller.dart';

class ViewDetailsButtonWidget extends ConsumerWidget {
  const ViewDetailsButtonWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: ElevatedButton(
        onPressed: () async {
          final mapNotifier = ref.read(mapControllerProvider.notifier);
          final summaryState = ref.read(summaryControllerProvider);
          final filterNotifier = ref.read(filterControllerProvider.notifier);
          final epiState = ref.read(epiCenterControllerProvider);
          final coverageData = summaryState.coverageData;
          final filterState = ref.read(filterControllerProvider);

          await filterNotifier.ensureHierarchyListsLoaded();

          final effectiveUid = ChartAreaUidResolver.resolveChartUid(
            filterState: ref.read(filterControllerProvider),
            filterNotifier: filterNotifier,
            orgUid: mapNotifier.focalAreaUid,
            currentEpiData: epiState.epiCenterData,
          );

          if (effectiveUid == null || effectiveUid.isEmpty) {
            logg.w('View Details: Could not resolve chart UID');
            return;
          }

          logg.i('View Details: chart UID=$effectiveUid');

          if (!context.mounted) return;

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EpiCenterDetailsScreen(
                epiUid: effectiveUid,
                isOrgUidRequest: true,
                coverageData: coverageData,
                selectedVaccineUid: filterState.selectedVaccine,
              ),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: const Text(
          'View Details',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
