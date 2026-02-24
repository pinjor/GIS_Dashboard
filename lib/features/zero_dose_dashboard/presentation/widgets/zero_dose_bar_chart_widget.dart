import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:gis_dashboard/features/summary/domain/vaccine_coverage_response.dart';
import 'package:gis_dashboard/features/filter/domain/filter_state.dart';
import 'package:gis_dashboard/features/map/utils/map_enums.dart';

class ZeroDoseBarChartWidget extends StatelessWidget {
  final List<Area> topAreas;
  final String locationName;
  final FilterState filterState;

  const ZeroDoseBarChartWidget({
    super.key,
    required this.topAreas,
    required this.locationName,
    required this.filterState,
  });

  @override
  Widget build(BuildContext context) {
    if (topAreas.isEmpty) {
      return const Center(
        child: Text(
          'No data available',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    // Calculate the maximum absolute zero dose count for scaling (to handle both positive and negative)
    final maxZeroDose = topAreas
        .map((area) {
          final zeroDose = (area.target ?? 0) - (area.coverage ?? 0);
          return zeroDose.abs(); // Use absolute value for scaling
        })
        .reduce((a, b) => a > b ? a : b);

    // Determine the area type label and parent name based on filter level
    String areaTypeLabel = 'Districts';
    String parentName = locationName;

    // Check from deepest to shallowest filter level
    if (filterState.selectedSubblock != null &&
        filterState.selectedSubblock != 'All') {
      // If subblock is selected, we're showing subblocks (but this is unlikely as we'd be at subblock level)
      areaTypeLabel = 'Subblocks';
      parentName = filterState.selectedWard ?? locationName;
    } else if (filterState.selectedWard != null &&
        filterState.selectedWard != 'All') {
      // If ward is selected, show subblocks or zones within that ward
      if (filterState.selectedAreaType == AreaType.cityCorporation) {
        areaTypeLabel = 'Zones';
      } else {
        areaTypeLabel = 'Subblocks';
      }
      parentName = 'Ward ${filterState.selectedWard}';
    } else if (filterState.selectedUnion != null &&
        filterState.selectedUnion != 'All') {
      areaTypeLabel = 'Wards';
      parentName = filterState.selectedUnion ?? locationName;
    } else if (filterState.selectedUpazila != null &&
        filterState.selectedUpazila != 'All') {
      areaTypeLabel = 'Unions';
      parentName = filterState.selectedUpazila ?? locationName;
    } else if (filterState.selectedDistrict != null &&
        filterState.selectedDistrict != 'All') {
      areaTypeLabel = 'Upazilas';
      parentName = filterState.selectedDistrict ?? locationName;
    } else if (filterState.selectedZone != null &&
        filterState.selectedZone != 'All') {
      areaTypeLabel = 'Wards';
      parentName = filterState.selectedZone ?? locationName;
    } else if (filterState.selectedDivision != 'All') {
      areaTypeLabel = 'Districts';
      parentName = filterState.selectedDivision;
    } else if (filterState.selectedCityCorporation != null &&
        filterState.selectedCityCorporation != 'All') {
      areaTypeLabel = 'Zones';
      parentName = filterState.selectedCityCorporation ?? locationName;
    }

    return Column(
      children: [
        // Title
        Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Top 5 $areaTypeLabel In $parentName',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),

        // Bar chart
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              // Calculate available height for bars (subtract space for text labels)
              // Text label at top: ~20px, spacing: 8px, area name at bottom: ~80px
              const double topLabelHeight = 20.0;
              const double spacing = 8.0;
              const double bottomLabelHeight = 80.0;
              final double availableBarHeight =
                  constraints.maxHeight -
                  topLabelHeight -
                  spacing -
                  bottomLabelHeight;

              // Calculate zero line position (middle of available height)
              final double zeroLinePosition = availableBarHeight / 2;
              
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 16.0,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: topAreas.map((area) {
                    // Calculate zero dose (can be negative if coverage exceeds target)
                    final zeroDoseCount = (area.target ?? 0) - (area.coverage ?? 0);
                    // Use absolute value for height calculation, but keep sign for display
                    final heightFactor = maxZeroDose > 0
                        ? zeroDoseCount.abs() / maxZeroDose
                        : 0.0;
                    final isNegative = zeroDoseCount < 0;
                    final barHeight = zeroLinePosition * heightFactor;

                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Bar value text (above bar for positive, below for negative)
                            if (!isNegative)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 4.0),
                                child: Text(
                                  zeroDoseCount.toString(),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),

                            // Bar container with zero line
                            Flexible(
                              child: SizedBox(
                                height: availableBarHeight,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    // Zero line indicator
                                    Positioned(
                                      left: 0,
                                      right: 0,
                                      top: zeroLinePosition - 0.5,
                                      child: Container(
                                        height: 1,
                                        color: Colors.grey.withOpacity(0.5),
                                      ),
                                    ),
                                    // Bar - extends up for positive, down for negative
                                    Positioned(
                                      left: 0,
                                      right: 0,
                                      bottom: isNegative ? zeroLinePosition : null,
                                      top: isNegative ? null : zeroLinePosition - barHeight,
                                      child: Container(
                                        height: barHeight,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF2196F3), // Blue color
                                          borderRadius: isNegative
                                              ? const BorderRadius.vertical(
                                                  bottom: Radius.circular(4),
                                                )
                                              : const BorderRadius.vertical(
                                                  top: Radius.circular(4),
                                                ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            // Bar value text (below bar for negative values)
                            if (isNegative)
                              Padding(
                                padding: const EdgeInsets.only(top: 4.0),
                                child: Text(
                                  zeroDoseCount.toString(),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),

                            const SizedBox(height: 8),

                            // Area name - reduced height
                            SizedBox(
                              height: 80,
                              child: Transform.rotate(
                                angle: -math.pi / 4,
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    area.name ?? 'Unknown',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
