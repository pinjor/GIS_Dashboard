import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gis_dashboard/core/utils/utils.dart';
import 'package:gis_dashboard/features/epi_center/presentation/screen/epi_center_details_screen.dart';
import 'package:gis_dashboard/features/map/presentation/controllers/map_controller.dart';
import 'package:gis_dashboard/features/summary/presentation/controllers/summary_controller.dart';
import 'package:gis_dashboard/features/filter/presentation/controllers/filter_controller.dart';

class ViewDetailsButtonWidget extends ConsumerWidget {
  const ViewDetailsButtonWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          final mapNotifier = ref.read(mapControllerProvider.notifier);
          final summaryState = ref.read(summaryControllerProvider);
          final filterState = ref.read(filterControllerProvider);

          final orgUid = mapNotifier.focalAreaUid;
          // ✅ Pass coverage data to EPI details screen for consistent target calculation
          final coverageData = summaryState.coverageData;

          logg.i("🖱️ View Details Button Tapped");
          logg.i("   > Coverage data available: ${coverageData != null}");
          logg.i("   > Selected vaccine UID: ${filterState.selectedVaccine}");
          
          // If orgUid is null (country level), we pass 'null' as a string to the API
          // This matches the backend requirement: /chart/null?year=...
          final effectiveUid = (orgUid != null && orgUid.isNotEmpty)
              ? orgUid
              : 'null';

          logg.i("   > Effective UID for API: $effectiveUid");

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EpiCenterDetailsScreen(
                epiUid: effectiveUid,
                isOrgUidRequest: true,
                coverageData: coverageData, // ✅ Pass coverage data
                selectedVaccineUid: filterState.selectedVaccine, // ✅ Pass selected vaccine
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
