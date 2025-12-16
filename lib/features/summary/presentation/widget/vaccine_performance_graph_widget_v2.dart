import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gis_dashboard/core/common/enums/vaccine_type.dart';
import 'package:gis_dashboard/core/utils/utils.dart';
import 'package:gis_dashboard/features/filter/filter.dart';
import 'package:gis_dashboard/features/summary/presentation/controllers/summary_controller.dart';
import 'package:intl/intl.dart';

import '../../../../core/common/constants/constants.dart';

class VaccinePerformanceGraphWidgetV2 extends ConsumerWidget {
  const VaccinePerformanceGraphWidgetV2({super.key});

  String _getFormattedAreaName(String area) {
    // Bogura (Part ..) should return just: Bogura
    return area.split(' (')[0];
  }

  // Format number for Y-axis (no abbreviations, just numbers)
  String _formatYAxisLabel(double value) {
    final formatter = NumberFormat('#,###');
    return formatter.format(value.toInt());
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filterState = ref.watch(filterControllerProvider);
    final summaryState = ref.watch(summaryControllerProvider);

    // Show loading or error state
    if (summaryState.isLoading) {
      return Card(
        color: Color(Constants.cardColor),
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: const Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'No of children vaccinated',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                ),
              ),
              SizedBox(height: 16),
              SizedBox(
                height: 200,
                child: Center(child: CircularProgressIndicator()),
              ),
            ],
          ),
        ),
      );
    }

    if (summaryState.error != null ||
        summaryState.coverageData?.vaccines?.isEmpty == true) {
      return Card(
        color: Color(Constants.cardColor),
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: const Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'No of children vaccinated',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                ),
              ),
              SizedBox(height: 16),
              SizedBox(
                height: 200,
                child: Center(
                  child: Text(
                    'No data available',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Find BCG vaccine specifically from the coverage data
    final vaccines = summaryState.coverageData?.vaccines ?? [];

    final bcgVaccine = vaccines.isNotEmpty
        ? vaccines.firstWhere(
            (vaccine) => vaccine.vaccineName == VaccineType.bcg.displayName,
            orElse: () {
              // If BCG not found, try to use first available vaccine
              logg.w(
                'BCG vaccine not found, returning first available vaccine.',
              );
              return vaccines.first;
            },
          )
        : null;

    if (bcgVaccine == null) {
      return Card(
        color: Color(Constants.cardColor),
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: const Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'No of children vaccinated',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                ),
              ),
              SizedBox(height: 16),
              SizedBox(
                height: 200,
                child: Center(
                  child: Text(
                    'BCG vaccine data not available',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Get total target for calculating monthly targets - use BCG's target
    final totalTarget = bcgVaccine.totalTarget ?? 0;
    final monthlyTargetPerMonth = totalTarget > 0 ? (totalTarget / 12) : 0.0;

    // Extract monthly coverage data and calculate monthly targets
    List<FlSpot> coverageSpots = [];
    List<FlSpot> targetSpots = [];
    List<double> allValues = [];

    // Show only 11 months (Jan to Nov) as per the reference image
    // Use BCG's monthly coverage data
    if (bcgVaccine.monthWiseTotalCoverages != null) {
      final monthlyData = bcgVaccine.monthWiseTotalCoverages!;

      for (int month = 1; month <= 11; month++) {
        final monthData = monthlyData[month.toString()];
        final coverage = monthData?.coverage?.toDouble() ?? 0.0;

        // Calculate progressive monthly target: (totalTarget / 12) * monthNumber
        final monthlyTarget = monthlyTargetPerMonth * month;

        coverageSpots.add(FlSpot(month - 1.0, coverage));
        targetSpots.add(FlSpot(month - 1.0, monthlyTarget));

        allValues.add(coverage);
        allValues.add(monthlyTarget);
      }
    } else {
      // Fallback data if no monthly data is available
      for (int month = 1; month <= 11; month++) {
        final monthlyTarget = monthlyTargetPerMonth * month;
        final coverage = 0.0;

        coverageSpots.add(FlSpot(month - 1.0, coverage));
        targetSpots.add(FlSpot(month - 1.0, monthlyTarget));

        allValues.add(coverage);
        allValues.add(monthlyTarget);
      }
    }

    // Always use 1,400,000 as max Y value to match reference image exactly
    // This prevents points from going off screen
    const double maxY = 1400000.0;

    // Ensure spots don't contain invalid values and clamp to maxY
    coverageSpots = coverageSpots.map((spot) {
      if (!spot.y.isFinite || spot.y.isNaN) {
        return FlSpot(spot.x, 0.0);
      }
      // Clamp values to maxY to prevent overflow
      final clampedY = spot.y > maxY ? maxY : spot.y;
      return FlSpot(spot.x, clampedY);
    }).toList();

    targetSpots = targetSpots.map((spot) {
      if (!spot.y.isFinite || spot.y.isNaN) {
        return FlSpot(spot.x, 0.0);
      }
      // Clamp values to maxY to prevent overflow
      final clampedY = spot.y > maxY ? maxY : spot.y;
      return FlSpot(spot.x, clampedY);
    }).toList();

    // Always show "BCG" in legend to match reference image
    final vaccineName = VaccineType.bcg.displayName;

    // Safety check: ensure we have valid spots
    if (coverageSpots.isEmpty || targetSpots.isEmpty) {
      return Card(
        color: Color(Constants.cardColor),
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: const Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'No of children vaccinated',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                ),
              ),
              SizedBox(height: 16),
              SizedBox(
                height: 200,
                child: Center(
                  child: Text(
                    'No chart data available',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Debug: Log data points
    logg.i('📊 CHART V2: BCG Vaccine found: ${bcgVaccine.vaccineName}');
    logg.i('📊 CHART V2: BCG Total Target: ${bcgVaccine.totalTarget}');
    logg.i('📊 CHART V2: Coverage spots count: ${coverageSpots.length}');
    logg.i('📊 CHART V2: Target spots count: ${targetSpots.length}');
    if (coverageSpots.isNotEmpty) {
      logg.i(
        '📊 CHART V2: Coverage spots: ${coverageSpots.map((s) => '(${s.x}, ${s.y})').join(', ')}',
      );
    }
    if (targetSpots.isNotEmpty) {
      logg.i(
        '📊 CHART V2: Target spots: ${targetSpots.map((s) => '(${s.x}, ${s.y})').join(', ')}',
      );
    }

    return Card(
      color: Color(Constants.cardColor),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'No. of children vaccinated - (${_getFormattedAreaName(summaryState.currentAreaName)})',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),

            // Legend
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Monthly Target legend item
                Row(
                  children: [
                    Container(
                      width: 20,
                      height: 3,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(1),
                      ),
                      child: CustomPaint(
                        painter: _DashedLinePainter(Colors.red),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(1),
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      'Monthly Target',
                      style: TextStyle(fontSize: 12, color: Colors.black87),
                    ),
                  ],
                ),
                const SizedBox(width: 24),
                // Actual Coverage legend item
                Row(
                  children: [
                    Container(width: 20, height: 3, color: Colors.blue),
                    const SizedBox(width: 8),
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      vaccineName,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Chart with Y-axis title
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Y-axis title (rotated text on the left)
                SizedBox(
                  width: 30,
                  child: RotatedBox(
                    quarterTurns: 3,
                    child: const Center(
                      child: Text(
                        'Number of Vaccinations',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                // Chart
                Expanded(
                  child: SizedBox(
                    height: 300,
                    child: ClipRect(
                      child: LineChart(
                        LineChartData(
                          clipData: FlClipData.all(),
                          borderData: FlBorderData(show: true),
                          gridData: FlGridData(
                            show: true,
                            drawVerticalLine: false,
                            horizontalInterval: 200000,
                          ),
                          maxY: maxY,
                          minY: 0,
                          titlesData: FlTitlesData(
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 80,
                                getTitlesWidget: (value, _) {
                                  // Don't show label for maxY to prevent overlap
                                  if (value >= maxY) {
                                    return const SizedBox.shrink();
                                  }
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: Text(
                                      _formatYAxisLabel(value),
                                      style: const TextStyle(
                                        fontSize: 10,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  );
                                },
                                interval: 200000,
                              ),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 40,
                                getTitlesWidget: (value, _) {
                                  const months = [
                                    'Jan',
                                    'Feb',
                                    'Mar',
                                    'Apr',
                                    'May',
                                    'Jun',
                                    'Jul',
                                    'Aug',
                                    'Sep',
                                    'Oct',
                                    'Nov',
                                  ];
                                  final monthIndex = value.toInt();
                                  // Show only every other month: Jan, Mar, May, Jul, Sep, Nov (0, 2, 4, 6, 8, 10)
                                  if (monthIndex >= 0 &&
                                      monthIndex < months.length) {
                                    if (monthIndex == 0 ||
                                        monthIndex == 2 ||
                                        monthIndex == 4 ||
                                        monthIndex == 6 ||
                                        monthIndex == 8 ||
                                        monthIndex == 10) {
                                      return Text(
                                        months[monthIndex],
                                        style: const TextStyle(
                                          fontSize: 10,
                                          color: Colors.black87,
                                        ),
                                      );
                                    }
                                  }
                                  return const Text('');
                                },
                                interval: 1,
                              ),
                            ),
                            rightTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            topTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                          ),
                          lineBarsData: [
                            // Monthly Target line (red, dotted, square markers)
                            LineChartBarData(
                              spots: targetSpots,
                              isCurved: false,
                              barWidth: 2.5,
                              color: Colors.red,
                              dotData: FlDotData(
                                show: true,
                                getDotPainter: (spot, percent, barData, index) {
                                  return _SquareDotPainter(
                                    radius: 5,
                                    color: Colors.red,
                                    strokeWidth: 2,
                                  );
                                },
                              ),
                              dashArray: [8, 4],
                              belowBarData: BarAreaData(show: false),
                            ),
                            // Actual Coverage line (blue, solid, circular markers) - CURVED
                            LineChartBarData(
                              spots: coverageSpots,
                              isCurved: true,
                              curveSmoothness: 0.35,
                              barWidth: 2.5,
                              color: Colors.blue,
                              dotData: FlDotData(
                                show: true,
                                getDotPainter: (spot, percent, barData, index) {
                                  return _CircleDotPainter(
                                    radius: 5,
                                    color: Colors.blue,
                                    strokeWidth: 2,
                                  );
                                },
                              ),
                              preventCurveOverShooting: true,
                              preventCurveOvershootingThreshold: 0.1,
                              belowBarData: BarAreaData(show: false),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // View Details button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Add navigation or action when needed
                  // For now, just a placeholder
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'View Details',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Custom painter for dashed line in legend
class _DashedLinePainter extends CustomPainter {
  final Color color;

  _DashedLinePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    const dashWidth = 3.0;
    const dashSpace = 2.0;
    double startX = 0;

    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, size.height / 2),
        Offset((startX + dashWidth).clamp(0, size.width), size.height / 2),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Custom square dot painter for monthly target line
class _SquareDotPainter extends FlDotPainter {
  final double radius;
  final Color color;
  final double strokeWidth;

  _SquareDotPainter({
    required this.radius,
    required this.color,
    required this.strokeWidth,
  });

  @override
  void draw(Canvas canvas, FlSpot spot, Offset offset) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final strokePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    // Draw square
    final rect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: offset, width: radius * 2, height: radius * 2),
      Radius.circular(2),
    );

    canvas.drawRRect(rect, paint);
    canvas.drawRRect(rect, strokePaint);
  }

  @override
  Size getSize(FlSpot spot) {
    return Size(radius * 2, radius * 2);
  }

  @override
  Color get mainColor => color;

  @override
  FlDotPainter lerp(FlDotPainter a, FlDotPainter b, double t) {
    if (a is _SquareDotPainter && b is _SquareDotPainter) {
      return _SquareDotPainter(
        radius: (a.radius + (b.radius - a.radius) * t),
        color: Color.lerp(a.color, b.color, t) ?? a.color,
        strokeWidth: (a.strokeWidth + (b.strokeWidth - a.strokeWidth) * t),
      );
    }
    return a;
  }

  @override
  List<Object?> get props => [radius, color, strokeWidth];
}

// Custom circle dot painter for actual coverage line
class _CircleDotPainter extends FlDotPainter {
  final double radius;
  final Color color;
  final double strokeWidth;

  _CircleDotPainter({
    required this.radius,
    required this.color,
    required this.strokeWidth,
  });

  @override
  void draw(Canvas canvas, FlSpot spot, Offset offset) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final strokePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    // Draw circle
    canvas.drawCircle(offset, radius, paint);
    canvas.drawCircle(offset, radius, strokePaint);
  }

  @override
  Size getSize(FlSpot spot) {
    return Size(radius * 2, radius * 2);
  }

  @override
  Color get mainColor => color;

  @override
  FlDotPainter lerp(FlDotPainter a, FlDotPainter b, double t) {
    if (a is _CircleDotPainter && b is _CircleDotPainter) {
      return _CircleDotPainter(
        radius: (a.radius + (b.radius - a.radius) * t),
        color: Color.lerp(a.color, b.color, t) ?? a.color,
        strokeWidth: (a.strokeWidth + (b.strokeWidth - a.strokeWidth) * t),
      );
    }
    return a;
  }

  @override
  List<Object?> get props => [radius, color, strokeWidth];
}
