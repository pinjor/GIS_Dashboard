import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:gis_dashboard/features/summary/domain/vaccine_coverage_response.dart';

class ZeroDoseBarChartWidget extends StatelessWidget {
  final List<Area> topAreas;
  final String locationName;

  const ZeroDoseBarChartWidget({
    super.key,
    required this.topAreas,
    required this.locationName,
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

    // Calculate the maximum zero dose count for scaling
    final maxZeroDose = topAreas
        .map((area) => (area.target ?? 0) - (area.coverage ?? 0))
        .reduce((a, b) => a > b ? a : b);

    return Column(
      children: [
        // Title
        Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Top 5 Districts Of $locationName',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),

        // Bar chart
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 16.0,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: topAreas.map((area) {
                final zeroDoseCount = (area.target ?? 0) - (area.coverage ?? 0);
                final heightFactor = maxZeroDose > 0
                    ? zeroDoseCount / maxZeroDose
                    : 0.0;

                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // Bar value text
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

                        // Bar
                        Container(
                          width: double.infinity,
                          height: 300 * heightFactor,
                          decoration: BoxDecoration(
                            color: const Color(0xFF2196F3), // Blue color
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(4),
                            ),
                          ),
                        ),

                        const SizedBox(height: 8),

                        // Area name
                        SizedBox(
                          height: 120,
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
          ),
        ),
      ],
    );
  }
}
