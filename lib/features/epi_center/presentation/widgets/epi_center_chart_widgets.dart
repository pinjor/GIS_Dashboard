import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../domain/epi_center_details_response.dart';

/// Collection of chart widgets for EPI Center Details
class EpiCenterChartSection extends StatelessWidget {
  final EpiCenterDetailsResponse? chartData;

  const EpiCenterChartSection({super.key, required this.chartData});

  @override
  Widget build(BuildContext context) {
    // Get 2024 specific chart data
    final chart2024Data = _get2024ChartData();
    final showEmpty = _shouldShowEmptyState();
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(isMobile ? 12 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.show_chart,
                  color: Colors.blue[600],
                  size: isMobile ? 20 : 24,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Monthly Vaccine Coverage vs Target (2024)',
                    style: TextStyle(
                      fontSize: isMobile ? 14 : 18,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: isMobile ? 2 : 1,
                  ),
                ),
              ],
            ),
            SizedBox(height: isMobile ? 16 : 20),
            SizedBox(
              height: isMobile ? 320 : 400,
              child: (!showEmpty && chart2024Data != null)
                  ? CoverageLineChart(chartData: chart2024Data)
                  : const EmptyChart(),
            ),
            SizedBox(height: isMobile ? 16 : 20),
            ChartLegend(chartData: (!showEmpty) ? chart2024Data : null),
          ],
        ),
      ),
    );
  }

  /// Get 2024 specific chart data or return null if not available
  ChartData? _get2024ChartData() {
    if (chartData?.chartData == null) return null;

    // Check if we have any 2024 data in the vaccination coverage
    final area = chartData?.area;
    final hasData2024 = area?.vaccineCoverage?.child0To11Month['2024'] != null;

    // Also check if chart data has meaningful values (not all zeros)
    final hasNonZeroData = chartData!.chartData!.datasets.any(
      (dataset) => dataset.data.any((value) => value > 0),
    );

    if (!hasData2024 && !hasNonZeroData) {
      return null; // Return null to show empty chart
    }

    // Return the existing chart data as it should represent 2024 data
    return chartData!.chartData!;
  }

  /// Check if we should show empty state based on data availability
  bool _shouldShowEmptyState() {
    final chart2024Data = _get2024ChartData();
    if (chart2024Data == null) return true;

    // Check if all data points are zero
    final allZero = chart2024Data.datasets.every(
      (dataset) => dataset.data.every((value) => value == 0),
    );

    return allZero;
  }
}

class CoverageLineChart extends StatelessWidget {
  final ChartData chartData;

  const CoverageLineChart({super.key, required this.chartData});

  @override
  Widget build(BuildContext context) {
    final maxY = _getMaxYValue();
    final interval = maxY <= 20 ? 5.0 : (maxY / 4).ceilToDouble();
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          horizontalInterval: interval,
          verticalInterval: isMobile
              ? 2
              : 1, // Less crowded vertical lines on mobile
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Colors.grey[300]!,
              strokeWidth: value == 0 ? 1.5 : 0.8,
            );
          },
          getDrawingVerticalLine: (value) {
            return FlLine(color: Colors.grey[200]!, strokeWidth: 0.8);
          },
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: isMobile ? 25 : 35,
              interval: isMobile ? 2 : 1, // Show every other month on mobile
              getTitlesWidget: (double value, TitleMeta meta) {
                // Use shorter month names for mobile
                final months = isMobile
                    ? [
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
                        'Dec',
                      ]
                    : [
                        'January',
                        'February',
                        'March',
                        'April',
                        'May',
                        'June',
                        'July',
                        'August',
                        'September',
                        'October',
                        'November',
                        'December',
                      ];

                int index = value.toInt();
                if (index >= 0 && index < months.length) {
                  return SideTitleWidget(
                    meta: meta,
                    child: Text(
                      months[index],
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w500,
                        fontSize: isMobile ? 9 : 10,
                      ),
                    ),
                  );
                }
                return const Text('');
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: interval,
              reservedSize: isMobile ? 35 : 45,
              getTitlesWidget: (double value, TitleMeta meta) {
                return Text(
                  value.toInt().toString(),
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w500,
                    fontSize: isMobile ? 10 : 12,
                  ),
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: Colors.grey[400]!, width: 1),
        ),
        minX: 0,
        maxX: 11,
        minY: 0,
        maxY: maxY,
        lineBarsData: _buildChartLines(isMobile),
      ),
    );
  }

  double _getMaxYValue() {
    // Find the maximum value in all datasets for proper scaling
    double maxValue = 10; // Start with a reasonable minimum

    for (final dataset in chartData.datasets) {
      final dataMax = dataset.data.isNotEmpty
          ? dataset.data.reduce((a, b) => a > b ? a : b).toDouble()
          : 0.0;
      if (dataMax > maxValue) {
        maxValue = dataMax;
      }
    }

    // If all values are 0, show a range of 0-20 for better visualization
    if (maxValue <= 0) {
      return 20;
    }

    // Add some padding (20%) and round up to nearest 5
    final paddedMax = maxValue * 1.2;
    final roundedMax = (paddedMax / 5).ceil() * 5;

    // Ensure minimum of 20 for better chart appearance
    return roundedMax < 20 ? 20 : roundedMax.toDouble();
  }

  List<LineChartBarData> _buildChartLines([bool isMobile = false]) {
    List<LineChartBarData> lines = [];

    for (final dataset in chartData.datasets) {
      final spots = <FlSpot>[];

      // Convert data points to spots
      for (int i = 0; i < dataset.data.length && i < 12; i++) {
        spots.add(FlSpot(i.toDouble(), dataset.data[i].toDouble()));
      }

      // Parse color from hex string
      Color lineColor = _parseHexColor(dataset.borderColor ?? '#4e73df');

      lines.add(
        LineChartBarData(
          spots: spots,
          isCurved: dataset.tension != null && dataset.tension! > 0,
          curveSmoothness: dataset.tension ?? 0.0,
          color: lineColor,
          barWidth:
              (dataset.borderWidth?.toDouble() ?? 2.0) * (isMobile ? 0.8 : 1.0),
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: dataset.pointRadius != null && dataset.pointRadius! > 0,
            getDotPainter: (spot, percent, barData, index) {
              return FlDotCirclePainter(
                radius:
                    ((dataset.pointRadius ?? 3).toDouble()) *
                    (isMobile ? 0.8 : 1.0),
                color: lineColor,
                strokeWidth: 0,
              );
            },
          ),
          dashArray: dataset.borderDash.isNotEmpty
              ? [
                  dataset.borderDash[0],
                  dataset.borderDash.length > 1
                      ? dataset.borderDash[1]
                      : dataset.borderDash[0],
                ]
              : null,
          belowBarData: BarAreaData(show: false),
        ),
      );
    }

    return lines;
  }

  Color _parseHexColor(String hexColor) {
    try {
      String hex = hexColor.replaceAll('#', '');
      if (hex.length == 6) {
        return Color(int.parse('FF$hex', radix: 16));
      }
      return Colors.blue; // Fallback color
    } catch (e) {
      return Colors.blue; // Fallback color
    }
  }
}

class EmptyChart extends StatelessWidget {
  const EmptyChart({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.timeline,
            color: Colors.grey[400],
            size: isMobile ? 40 : 48,
          ),
          SizedBox(height: isMobile ? 8 : 12),
          Text(
            'No 2024 chart data available',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: isMobile ? 14 : 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: isMobile ? 6 : 8),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 24),
            child: Text(
              'Monthly vaccination coverage vs target chart will appear here when 2024 data is available',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: isMobile ? 12 : 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ChartLegend extends StatelessWidget {
  final ChartData? chartData;

  const ChartLegend({super.key, this.chartData});

  @override
  Widget build(BuildContext context) {
    if (chartData == null || chartData!.datasets.isEmpty) {
      return const SizedBox.shrink();
    }

    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    // Group legend items for better mobile layout
    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // First row - Target and main vaccines
          Wrap(
            spacing: 12,
            runSpacing: 6,
            children: chartData!.datasets.take(4).map((dataset) {
              Color lineColor = _parseHexColor(
                dataset.borderColor ?? '#4e73df',
              );
              bool isDashed = dataset.borderDash.isNotEmpty;

              return LegendItem(
                label: dataset.label ?? 'Unknown',
                color: lineColor,
                isDashed: isDashed,
                isMobile: true,
              );
            }).toList(),
          ),
          if (chartData!.datasets.length > 4) ...[
            const SizedBox(height: 8),
            // Second row - remaining vaccines
            Wrap(
              spacing: 12,
              runSpacing: 6,
              children: chartData!.datasets.skip(4).map((dataset) {
                Color lineColor = _parseHexColor(
                  dataset.borderColor ?? '#4e73df',
                );
                bool isDashed = dataset.borderDash.isNotEmpty;

                return LegendItem(
                  label: dataset.label ?? 'Unknown',
                  color: lineColor,
                  isDashed: isDashed,
                  isMobile: true,
                );
              }).toList(),
            ),
          ],
        ],
      );
    }

    // Desktop layout
    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: chartData!.datasets.map((dataset) {
        Color lineColor = _parseHexColor(dataset.borderColor ?? '#4e73df');
        bool isDashed = dataset.borderDash.isNotEmpty;

        return LegendItem(
          label: dataset.label ?? 'Unknown',
          color: lineColor,
          isDashed: isDashed,
          isMobile: false,
        );
      }).toList(),
    );
  }

  Color _parseHexColor(String hexColor) {
    try {
      String hex = hexColor.replaceAll('#', '');
      if (hex.length == 6) {
        return Color(int.parse('FF$hex', radix: 16));
      }
      return Colors.blue; // Fallback color
    } catch (e) {
      return Colors.blue; // Fallback color
    }
  }
}

class LegendItem extends StatelessWidget {
  final String label;
  final Color color;
  final bool isDashed;
  final bool isMobile;

  const LegendItem({
    super.key,
    required this.label,
    required this.color,
    this.isDashed = false,
    this.isMobile = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: isMobile ? 16 : 20,
          height: isMobile ? 2.5 : 3,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
          child: isDashed
              ? CustomPaint(
                  painter: DashedLinePainter(color: color),
                  size: Size(isMobile ? 16 : 20, isMobile ? 2.5 : 3),
                )
              : null,
        ),
        SizedBox(width: isMobile ? 6 : 8),
        Flexible(
          child: Text(
            label,
            style: TextStyle(
              fontSize: isMobile ? 10 : 12,
              fontWeight: FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

// Custom painter for dashed lines
class DashedLinePainter extends CustomPainter {
  final Color color;

  DashedLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    const dashWidth = 3.0;
    const dashSpace = 3.0;
    double startX = 0;

    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, size.height / 2),
        Offset(startX + dashWidth, size.height / 2),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
