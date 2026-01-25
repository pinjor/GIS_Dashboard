import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gis_dashboard/core/common/constants/constants.dart';
import 'package:gis_dashboard/core/common/enums/vaccine_type.dart';
import 'package:gis_dashboard/features/filter/filter.dart';

import '../../../features/summary/presentation/controllers/summary_controller.dart';
import '../../../features/map/presentation/controllers/map_controller.dart';
import '../../utils/utils.dart';

class HeaderTitleIconFilterWidget extends ConsumerWidget {
  final VoidCallback? onFilterTap;

  const HeaderTitleIconFilterWidget({super.key, this.onFilterTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filterState = ref.watch(filterControllerProvider);
    final summaryState = ref.watch(summaryControllerProvider);
    final mapState = ref.watch(mapControllerProvider);
    final generatedAt = summaryState.coverageData?.metadata?.generatedAt;
    final generatedAtTime = formatDateTime(generatedAt);
    
    // ✅ FIX: Get EPI center count from map controller's EPI data
    // EPI data is loaded based on current filter level, so this count reflects the filtered area
    final epiCenterCount = mapState.epiCenterCoordsData?.features?.length ?? 0;
    
    // ✅ FIX: Always show count if EPI data has been loaded (even if 0)
    // This matches web behavior where count is always displayed
    final shouldShowCount = mapState.epiCenterCoordsData != null;
    
    // Debug logging to help troubleshoot EPI center count issues
    if (epiCenterCount == 0 && !mapState.isLoading && shouldShowCount) {
      logg.w('Header: EPI center count is 0 - epiCenterCoordsData: ${mapState.epiCenterCoordsData != null}, features: ${mapState.epiCenterCoordsData?.features?.length ?? 0}');
      logg.w('Header: Current level: ${mapState.currentLevel.value}, area: ${mapState.currentAreaName ?? "none"}');
    } else if (epiCenterCount > 0) {
      logg.i('Header: EPI center count: $epiCenterCount (level: ${mapState.currentLevel.value})');
    } else if (!shouldShowCount && !mapState.isLoading) {
      logg.w('Header: EPI data not loaded yet - epiCenterCoordsData is null');
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Bangladesh, ${filterState.selectedYear}",
                  style: TextStyle(fontSize: 15, color: Colors.grey[700]),
                ),
                Text(
                  VaccineType.fromUid(
                        filterState.selectedVaccine,
                      )?.displayName ??
                      '',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                // ✅ FIX: Display EPI center count (always show if EPI data has been loaded)
                if (shouldShowCount)
                  Text(
                    "$epiCenterCount EPI ${epiCenterCount == 1 ? 'Center' : 'Centers'}",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              ],
            ),
            IconButton(
              icon: SvgPicture.asset(
                Constants.filterIconPath,
                width: 24,
                height: 24,
                colorFilter: const ColorFilter.mode(
                  Colors.grey,
                  BlendMode.srcIn,
                ),
              ),
              onPressed:
                  onFilterTap ??
                  () {
                    showDialog(
                      context: context,
                      builder: (_) => Dialog(
                        backgroundColor: Color(Constants.cardColor),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        insetPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                        ),
                        child: const FilterDialogBoxWidget(isEpiContext: false),
                      ),
                    );
                  },
            ),
          ],
        ),
        if (generatedAtTime != null)
          Text(
            "Last data synced at: $generatedAtTime",
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
      ],
    );
  }
}
