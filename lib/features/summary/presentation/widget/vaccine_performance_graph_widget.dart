import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gis_dashboard/core/common/enums/vaccine_type.dart';
import 'package:gis_dashboard/core/utils/utils.dart';
import 'package:gis_dashboard/features/summary/presentation/controllers/summary_controller.dart';
import 'package:gis_dashboard/features/filter/presentation/controllers/filter_controller.dart';
import 'package:intl/intl.dart';

import '../../../../core/common/constants/constants.dart';

class VaccinePerformanceGraphWidget extends ConsumerStatefulWidget {
  const VaccinePerformanceGraphWidget({super.key});

  @override
  ConsumerState<VaccinePerformanceGraphWidget> createState() =>
      _VaccinePerformanceGraphWidgetState();
}

class _VaccinePerformanceGraphWidgetState
    extends ConsumerState<VaccinePerformanceGraphWidget> {
  // Track visibility of each series
  bool _isMonthlyTargetVisible = true;
  bool _isVaccineVisible = true;

  String _getFormattedAreaName(String area) {
    // Bogura (Part ..) should return just: Bogura
    return area.split(' (')[0];
  }

  // Format number for Y-axis (no abbreviations, just numbers)
  String _formatYAxisLabel(double value) {
    final formatter = NumberFormat('#,###');
    return formatter.format(value.toInt());
  }

  // Calculate dynamic maxY based on data values
  double _calculateMaxY(List<double> allValues) {
    if (allValues.isEmpty) {
      return 100000.0; // Default fallback
    }

    // Find maximum value
    final maxValue = allValues.reduce((a, b) => a > b ? a : b);

    // If all values are zero or very small, use minimum scale
    if (maxValue <= 0) {
      return 10000.0;
    }

    // Add 15% padding above max value
    final paddedMax = maxValue * 1.15;

    // Round to nice number based on magnitude
    if (paddedMax < 10000) {
      // For values < 10K, round to nearest 1K
      return (paddedMax / 1000).ceil() * 1000.0;
    } else if (paddedMax < 100000) {
      // For values < 100K, round to nearest 10K
      return (paddedMax / 10000).ceil() * 10000.0;
    } else if (paddedMax < 500000) {
      // For values < 500K, round to nearest 50K
      return (paddedMax / 50000).ceil() * 50000.0;
    } else if (paddedMax < 1000000) {
      // For values < 1M, round to nearest 100K
      return (paddedMax / 100000).ceil() * 100000.0;
    } else {
      // For values >= 1M, round to nearest 200K
      return (paddedMax / 200000).ceil() * 200000.0;
    }
  }

  // Calculate dynamic interval based on maxY
  double _calculateInterval(double maxY) {
    if (maxY < 10000) {
      return 1000.0; // 1K intervals for small values
    } else if (maxY < 100000) {
      return 10000.0; // 10K intervals
    } else if (maxY < 500000) {
      return 50000.0; // 50K intervals
    } else if (maxY < 1000000) {
      return 100000.0; // 100K intervals
    } else {
      return 200000.0; // 200K intervals for large values
    }
  }

  @override
  Widget build(BuildContext context) {
    final summaryState = ref.watch(summaryControllerProvider);
    final filterState = ref.watch(filterControllerProvider);

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

    // Find selected vaccine from the coverage data based on filter
    final vaccines = summaryState.coverageData?.vaccines ?? [];

    final selectedVaccine = vaccines.isNotEmpty
        ? vaccines.firstWhere(
            (vaccine) => vaccine.vaccineUid == filterState.selectedVaccine,
            orElse: () {
              // If selected vaccine not found, try to use first available vaccine
              logg.w(
                'Selected vaccine (by UID) not found, returning first available vaccine.',
              );
              return vaccines.first;
            },
          )
        : null;

    if (selectedVaccine == null) {
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
                    'Vaccine data not available',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Get total target for calculating monthly targets - use selected vaccine's target
    final totalTarget = selectedVaccine.totalTarget ?? 0;
    final monthlyTargetPerMonth = totalTarget > 0 ? (totalTarget / 12) : 0.0;

    // Extract monthly coverage data and calculate monthly targets
    List<FlSpot> coverageSpots = [];
    List<FlSpot> targetSpots = [];
    List<double> allValues = [];

    // Show only 11 months (Jan to Nov) as per the reference image
    // Use selected vaccine's monthly coverage data
    if (selectedVaccine.monthWiseTotalCoverages != null) {
      final monthlyData = selectedVaccine.monthWiseTotalCoverages!;

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

    // Calculate dynamic maxY based on actual data values
    final maxY = _calculateMaxY(allValues);
    final horizontalInterval = _calculateInterval(maxY);

    // Ensure spots don't contain invalid values (remove clamping to show all data)
    coverageSpots = coverageSpots.map((spot) {
      if (!spot.y.isFinite || spot.y.isNaN) {
        return FlSpot(spot.x, 0.0);
      }
      // No clamping - show actual values
      return FlSpot(spot.x, spot.y);
    }).toList();

    targetSpots = targetSpots.map((spot) {
      if (!spot.y.isFinite || spot.y.isNaN) {
        return FlSpot(spot.x, 0.0);
      }
      // No clamping - show actual values
      return FlSpot(spot.x, spot.y);
    }).toList();

    // Get dynamic vaccine name from filter selection
    final selectedVaccineType = VaccineType.fromUid(
      filterState.selectedVaccine,
    );
    final vaccineName =
        selectedVaccineType?.displayName ?? VaccineType.bcg.displayName;

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
    logg.i('''
📊 GRAPH DEBUG:
Vaccine: ${selectedVaccine.vaccineName}
Total Target: ${selectedVaccine.totalTarget}
MonthWise Data Present: ${selectedVaccine.monthWiseTotalCoverages != null}
MonthWise Keys: ${selectedVaccine.monthWiseTotalCoverages?.keys.toList()}
Coverage Spots: ${coverageSpots.length}
Target Spots: ${targetSpots.length}
First Spot: ${coverageSpots.isNotEmpty ? '(${coverageSpots.first.x}, ${coverageSpots.first.y})' : 'N/A'}
Last Spot: ${coverageSpots.isNotEmpty ? '(${coverageSpots.last.x}, ${coverageSpots.last.y})' : 'N/A'}
-------------------
''');

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

            // Interactive Legend with clickable items
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Monthly Target legend item
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _isMonthlyTargetVisible = !_isMonthlyTargetVisible;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: _isMonthlyTargetVisible
                          ? Colors.transparent
                          : Colors.grey.shade200,
                      border: Border.all(
                        color: _isMonthlyTargetVisible
                            ? Colors.grey.shade300
                            : Colors.grey.shade400,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Rectangular color indicator (24x12) with dashed pattern
                        Container(
                          width: 24,
                          height: 12,
                          decoration: BoxDecoration(
                            color: _isMonthlyTargetVisible
                                ? Colors.red
                                : Colors.grey.shade400,
                            borderRadius: BorderRadius.circular(2),
                          ),
                          child: CustomPaint(
                            painter: _LegendRectanglePainter(
                              _isMonthlyTargetVisible
                                  ? Colors.red
                                  : Colors.grey.shade400,
                              true,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Monthly Target',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: _isMonthlyTargetVisible
                                    ? null
                                    : Colors.grey.shade600,
                                decoration: _isMonthlyTargetVisible
                                    ? null
                                    : TextDecoration.lineThrough,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Actual Coverage legend item
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _isVaccineVisible = !_isVaccineVisible;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: _isVaccineVisible
                          ? Colors.transparent
                          : Colors.grey.shade200,
                      border: Border.all(
                        color: _isVaccineVisible
                            ? Colors.grey.shade300
                            : Colors.grey.shade400,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Rectangular color indicator (24x12) with solid color
                        Container(
                          width: 24,
                          height: 12,
                          decoration: BoxDecoration(
                            color: _isVaccineVisible
                                ? Colors.blue
                                : Colors.grey.shade400,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          vaccineName,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: _isVaccineVisible
                                    ? null
                                    : Colors.grey.shade600,
                                decoration: _isVaccineVisible
                                    ? null
                                    : TextDecoration.lineThrough,
                              ),
                        ),
                      ],
                    ),
                  ),
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
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ClipRect(
                        child: LineChart(
                          LineChartData(
                            clipData: FlClipData.all(),
                            borderData: FlBorderData(show: true),
                            gridData: FlGridData(
                              show: true,
                              drawVerticalLine: false,
                              horizontalInterval: horizontalInterval,
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
                                      padding: const EdgeInsets.only(
                                        right: 8.0,
                                      ),
                                      child: Text(
                                        _formatYAxisLabel(value),
                                        style: const TextStyle(
                                          fontSize: 10,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    );
                                  },
                                  interval: horizontalInterval,
                                ),
                              ),
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 60,
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
                                        return Padding(
                                          padding: EdgeInsets.only(
                                            top: 4.0,
                                            right: monthIndex == 10 ? 4.0 : 0.0,
                                          ),
                                          child: Text(
                                            months[monthIndex],
                                            style: const TextStyle(
                                              fontSize: 10,
                                              color: Colors.black87,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        );
                                      }
                                    }
                                    return const SizedBox.shrink();
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
                              // Monthly Target line (red, dotted, square markers) - conditionally visible
                              if (_isMonthlyTargetVisible)
                                LineChartBarData(
                                  spots: targetSpots,
                                  isCurved: false,
                                  barWidth: 2.5,
                                  color: Colors.red,
                                  dotData: FlDotData(
                                    show: true,
                                    getDotPainter:
                                        (spot, percent, barData, index) {
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
                              // Actual Coverage line (blue, solid, circular markers) - CURVED - conditionally visible
                              if (_isVaccineVisible)
                                LineChartBarData(
                                  spots: coverageSpots,
                                  isCurved: true,
                                  curveSmoothness: 0.35,
                                  barWidth: 2.5,
                                  color: Colors.blue,
                                  dotData: FlDotData(
                                    show: true,
                                    getDotPainter:
                                        (spot, percent, barData, index) {
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
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Custom painter for dashed rectangle in legend (for Monthly Target)
class _LegendRectanglePainter extends CustomPainter {
  final Color color;
  final bool dashed;

  _LegendRectanglePainter(this.color, this.dashed);

  @override
  void paint(Canvas canvas, Size size) {
    if (!dashed) return; // Only paint for dashed patterns

    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5;

    // Draw dashed pattern across the rectangle
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
