import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gis_dashboard/core/utils/utils.dart';
import 'package:gis_dashboard/features/epi_center/presentation/screen/epi_center_details_screen.dart';
import 'package:gis_dashboard/features/map/presentation/controllers/map_controller.dart';
import 'package:gis_dashboard/features/summary/presentation/controllers/summary_controller.dart';
import 'package:gis_dashboard/features/filter/presentation/controllers/filter_controller.dart';
import 'package:gis_dashboard/features/map/utils/map_enums.dart';

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

          // ✅ FIX: The /chart/ endpoint requires single UIDs, not concatenated paths
          // The concatenated path format works for /epi/ endpoint but not for /chart/ endpoint
          // For district hierarchy:
          // - Subblock level: district/upazila/union/ward/subblock (5 segments) -> extract subblockUid
          // - Ward level: district/upazila/union/ward (4 segments) -> extract wardUid
          // - Union level: district/upazila/union (3 segments) -> extract unionUid
          // - Upazila level: district/upazila (2 segments) -> extract upazilaUid
          // - District level: district (1 segment) -> use as-is
          String effectiveUid;

          // If orgUid is null (country level), we pass 'null' as a string to the API
          if (orgUid == null || orgUid.isEmpty) {
            effectiveUid = 'null';
            logg.i("   > Country level - using 'null' for API");
          } else {
            final isCityCorporation =
                filterState.selectedAreaType == AreaType.cityCorporation;
            final pathSegments = orgUid.contains('/')
                ? orgUid.split('/').length
                : 1;

            logg.i(
              "   > Area type: ${filterState.selectedAreaType}, isCityCorporation: $isCityCorporation",
            );
            logg.i("   > Path segments: $pathSegments, orgUid: $orgUid");

            // ✅ Handle city corporation hierarchy
            if (isCityCorporation) {
              final filterController = ref.read(
                filterControllerProvider.notifier,
              );

              // Check for subblock level (4 segments: ccUid/zoneUid/wardUid/subblockUid)
              if (pathSegments == 4 ||
                  (filterState.selectedSubblock != null &&
                      filterState.selectedSubblock != 'All')) {
                String? subblockUid;

                if (filterState.selectedSubblock != null &&
                    filterState.selectedSubblock != 'All') {
                  subblockUid = filterController.getSubblockUid(
                    filterState.selectedSubblock!,
                  );
                  logg.i(
                    "   > Subblock filter found: ${filterState.selectedSubblock}, UID: $subblockUid",
                  );
                }

                // Fallback: extract from path
                if (subblockUid == null && pathSegments == 4) {
                  subblockUid = orgUid.split('/').last;
                  logg.i(
                    "   > Subblock detected from path (4 segments) - extracted UID: $subblockUid",
                  );
                }

                if (subblockUid != null) {
                  effectiveUid = subblockUid;
                  logg.i(
                    "   > ✅ City Corporation Subblock - using subblock UID only: $effectiveUid",
                  );
                } else {
                  effectiveUid = orgUid;
                  logg.w(
                    "   > ⚠️ Could not extract subblock UID, using orgUid as-is: $effectiveUid",
                  );
                }
              }
              // Check for ward level (3 segments: ccUid/zoneUid/wardUid)
              else if (pathSegments == 3 ||
                  (filterState.selectedWard != null &&
                      filterState.selectedWard != 'All' &&
                      (filterState.selectedSubblock == null ||
                          filterState.selectedSubblock == 'All'))) {
                String? wardUid;

                if (filterState.selectedWard != null &&
                    filterState.selectedWard != 'All') {
                  wardUid = filterController.getWardUid(
                    filterState.selectedWard!,
                  );
                  logg.i(
                    "   > Ward filter found: ${filterState.selectedWard}, UID: $wardUid",
                  );
                }

                // Fallback: extract from path
                if (wardUid == null && pathSegments == 3) {
                  wardUid = orgUid.split('/').last;
                  logg.i(
                    "   > Ward detected from path (3 segments) - extracted UID: $wardUid",
                  );
                }

                if (wardUid != null) {
                  effectiveUid = wardUid;
                  logg.i(
                    "   > ✅ City Corporation Ward - using ward UID only: $effectiveUid",
                  );
                } else {
                  effectiveUid = orgUid;
                  logg.w(
                    "   > ⚠️ Could not extract ward UID, using orgUid as-is: $effectiveUid",
                  );
                }
              }
              // Check for zone level (2 segments: ccUid/zoneUid)
              else if (pathSegments == 2 ||
                  (filterState.selectedZone != null &&
                      filterState.selectedZone != 'All' &&
                      (filterState.selectedWard == null ||
                          filterState.selectedWard == 'All'))) {
                String? zoneUid;

                if (filterState.selectedZone != null &&
                    filterState.selectedZone != 'All') {
                  zoneUid = filterController.getZoneUid(
                    filterState.selectedZone!,
                  );
                  logg.i(
                    "   > Zone filter found: ${filterState.selectedZone}, UID: $zoneUid",
                  );
                }

                // Fallback: extract from path
                if (zoneUid == null && pathSegments == 2) {
                  zoneUid = orgUid.split('/').last;
                  logg.i(
                    "   > Zone detected from path (2 segments) - extracted UID: $zoneUid",
                  );
                }

                if (zoneUid != null) {
                  effectiveUid = zoneUid;
                  logg.i(
                    "   > ✅ City Corporation Zone - using zone UID only: $effectiveUid",
                  );
                } else {
                  effectiveUid = orgUid;
                  logg.w(
                    "   > ⚠️ Could not extract zone UID, using orgUid as-is: $effectiveUid",
                  );
                }
              }
              // City corporation level (1 segment: ccUid) - use as-is
              else {
                effectiveUid = orgUid;
                logg.i(
                  "   > City Corporation level - using orgUid as-is: $effectiveUid",
                );
              }
            }
            // ✅ Handle district hierarchy
            else {
              // Check for subblock level (5 segments: district/upazila/union/ward/subblock)
              final isSubblockPath = pathSegments == 5;
              final hasSubblockFilter =
                  filterState.selectedSubblock != null &&
                  filterState.selectedSubblock != 'All';

              if (isSubblockPath || hasSubblockFilter) {
                String? subblockUid;

                if (hasSubblockFilter) {
                  final filterController = ref.read(
                    filterControllerProvider.notifier,
                  );
                  subblockUid = filterController.getSubblockUid(
                    filterState.selectedSubblock!,
                  );
                  logg.i(
                    "   > Subblock filter found: ${filterState.selectedSubblock}, UID: $subblockUid",
                  );
                }

                // Fallback: extract from path
                if (subblockUid == null && isSubblockPath) {
                  subblockUid = orgUid.split('/').last;
                  logg.i(
                    "   > Subblock detected from path (5 segments) - extracted UID: $subblockUid",
                  );
                }

                if (subblockUid != null) {
                  effectiveUid = subblockUid;
                  logg.i(
                    "   > ✅ District Subblock - using subblock UID only: $effectiveUid",
                  );
                } else {
                  effectiveUid = orgUid;
                  logg.w(
                    "   > ⚠️ Could not extract subblock UID, using orgUid as-is: $effectiveUid",
                  );
                }
              }
              // Check for ward level (4 segments: district/upazila/union/ward)
              else if (pathSegments == 4 ||
                  (filterState.selectedWard != null &&
                      filterState.selectedWard != 'All' &&
                      (filterState.selectedSubblock == null ||
                          filterState.selectedSubblock == 'All'))) {
                String? wardUid;

                if (filterState.selectedWard != null &&
                    filterState.selectedWard != 'All') {
                  final filterController = ref.read(
                    filterControllerProvider.notifier,
                  );
                  wardUid = filterController.getWardUid(
                    filterState.selectedWard!,
                  );
                  logg.i(
                    "   > Ward filter found: ${filterState.selectedWard}, UID: $wardUid",
                  );
                }

                // Fallback: extract from path
                if (wardUid == null && pathSegments == 4) {
                  wardUid = orgUid.split('/').last;
                  logg.i(
                    "   > Ward detected from path (4 segments) - extracted UID: $wardUid",
                  );
                }

                if (wardUid != null) {
                  effectiveUid = wardUid;
                  logg.i(
                    "   > ✅ District Ward - using ward UID only: $effectiveUid",
                  );
                } else {
                  effectiveUid = orgUid;
                  logg.w(
                    "   > ⚠️ Could not extract ward UID, using orgUid as-is: $effectiveUid",
                  );
                }
              }
              // Check for union level (3 segments: district/upazila/union)
              else if (pathSegments == 3 ||
                  (filterState.selectedUnion != null &&
                      filterState.selectedUnion != 'All' &&
                      (filterState.selectedWard == null ||
                          filterState.selectedWard == 'All'))) {
                String? unionUid;

                if (filterState.selectedUnion != null &&
                    filterState.selectedUnion != 'All') {
                  final filterController = ref.read(
                    filterControllerProvider.notifier,
                  );
                  unionUid = filterController.getUnionUid(
                    filterState.selectedUnion!,
                  );
                  logg.i(
                    "   > Union filter found: ${filterState.selectedUnion}, UID: $unionUid",
                  );
                }

                // Fallback: extract from path
                if (unionUid == null && pathSegments == 3) {
                  unionUid = orgUid.split('/').last;
                  logg.i(
                    "   > Union detected from path (3 segments) - extracted UID: $unionUid",
                  );
                }

                if (unionUid != null) {
                  effectiveUid = unionUid;
                  logg.i(
                    "   > ✅ District Union - using union UID only: $effectiveUid",
                  );
                } else {
                  effectiveUid = orgUid;
                  logg.w(
                    "   > ⚠️ Could not extract union UID, using orgUid as-is: $effectiveUid",
                  );
                }
              }
              // Check for upazila level (2 segments: district/upazila)
              else if (pathSegments == 2 ||
                  (filterState.selectedUpazila != null &&
                      filterState.selectedUpazila != 'All' &&
                      (filterState.selectedUnion == null ||
                          filterState.selectedUnion == 'All'))) {
                String? upazilaUid;

                if (filterState.selectedUpazila != null &&
                    filterState.selectedUpazila != 'All') {
                  final filterController = ref.read(
                    filterControllerProvider.notifier,
                  );
                  upazilaUid = filterController.getUpazilaUid(
                    filterState.selectedUpazila!,
                  );
                  logg.i(
                    "   > Upazila filter found: ${filterState.selectedUpazila}, UID: $upazilaUid",
                  );
                }

                // Fallback: extract from path
                if (upazilaUid == null && pathSegments == 2) {
                  upazilaUid = orgUid.split('/').last;
                  logg.i(
                    "   > Upazila detected from path (2 segments) - extracted UID: $upazilaUid",
                  );
                }

                if (upazilaUid != null) {
                  effectiveUid = upazilaUid;
                  logg.i(
                    "   > ✅ District Upazila - using upazila UID only: $effectiveUid",
                  );
                } else {
                  effectiveUid = orgUid;
                  logg.w(
                    "   > ⚠️ Could not extract upazila UID, using orgUid as-is: $effectiveUid",
                  );
                }
              }
              // District level (1 segment: district) - use as-is
              else {
                effectiveUid = orgUid;
                logg.i(
                  "   > District level - using orgUid as-is: $effectiveUid",
                );
              }
            }
          }

          logg.i("   > Effective UID for API: $effectiveUid");

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EpiCenterDetailsScreen(
                epiUid: effectiveUid,
                isOrgUidRequest: true,
                coverageData: coverageData, // ✅ Pass coverage data
                selectedVaccineUid:
                    filterState.selectedVaccine, // ✅ Pass selected vaccine
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
