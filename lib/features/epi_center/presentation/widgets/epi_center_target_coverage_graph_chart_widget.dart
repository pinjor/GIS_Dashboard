import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math' as math;
import '../../domain/epi_center_details_response.dart';

/// Collection of chart widgets for EPI Center Details
class EpiCenterTargetCoverageGraphChartWidget extends StatelessWidget {
  final ChartData? chartData;
  final String selectedYear;

  const EpiCenterTargetCoverageGraphChartWidget({
    super.key,
    required this.chartData,
    required this.selectedYear,
  });

  Color _colorFromHex(String? hexColor) {
    final hex = (hexColor ?? '#000000').replaceAll('#', '');
    return Color(int.parse('ff$hex', radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    if (chartData == null || (chartData?.datasets.isEmpty ?? true)) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text('No chart data available'),
        ),
      );
    }

    final labels = chartData!.labels;
    final datasets = chartData!.datasets;

    if (labels.isEmpty || datasets.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text('No chart data available'),
        ),
      );
    }

    // Compute cumulative data and maxY for each dataset
    double maxY = 0;
    final List<LineChartBarData> lineBars = [];
    for (final dataset in datasets) {
      final rawData = dataset.data;
      final List<double> cumData = [];
      double sum = 0;
      for (final num? d in rawData) {
        sum += (d?.toDouble() ?? 0);
        cumData.add(sum);
      }
      maxY = math.max(maxY, sum);

      final spots = cumData
          .asMap()
          .entries
          .map((e) => FlSpot(e.key.toDouble(), e.value))
          .toList();

      final color = _colorFromHex(dataset.borderColor);
      final bool isCurved = (dataset.tension ?? 0) > 0;
      final bool showDots = (dataset.pointRadius ?? 0) > 0;
      final List<int>? dashArray = (dataset.borderDash.isNotEmpty)
          ? dataset.borderDash
          : null;

      lineBars.add(
        LineChartBarData(
          spots: spots,
          color: color,
          barWidth: (dataset.borderWidth ?? 2).toDouble(),
          isCurved: isCurved,
          curveSmoothness: dataset.tension ?? 0.1,
          dotData: FlDotData(
            show: showDots,
            getDotPainter: (spot, percent, barData, index) {
              return FlDotCirclePainter(
                radius: 4, // Increased from default 3 for better visibility
                color: color,
                strokeWidth: 2,
                strokeColor: Colors.white,
              );
            },
          ),
          dashArray: dashArray,
          belowBarData: BarAreaData(show: false), // No fill
        ),
      );
    }

    // Calculate a reasonable interval for y-axis
    double interval = math.max(1, (maxY / 5).ceil().toDouble());
    final double chartMaxY = maxY + interval;

    // LineChartData configuration
    final lineChartData = LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: interval,
        getDrawingHorizontalLine: (value) => const FlLine(
          color: Colors.grey,
          strokeWidth: 0.5,
          dashArray: [2, 2],
        ),
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            reservedSize: 50, // Increased from 40 for better spacing
            getTitlesWidget: (value, meta) {
              final int index = value.toInt();
              if (index < 0 || index >= labels.length) {
                return const SizedBox.shrink();
              }
              return SideTitleWidget(
                meta: meta,
                fitInside: SideTitleFitInsideData.fromTitleMeta(meta),
                space: 12, // Increased from 8 for better spacing
                angle: 45 * (math.pi / 180), // Rotate for better fit on mobile
                child: Text(
                  labels[index],
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              );
            },
          ),
        ),
        leftTitles: AxisTitles(
          axisNameWidget: const Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Text(
              'Coverage Count',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
          axisNameSize: 20,
          sideTitles: SideTitles(
            showTitles: true,
            interval: interval,
            reservedSize:
                50, // Increased from 40 to give more space from Y-axis line
            getTitlesWidget: (value, meta) {
              return Padding(
                padding: const EdgeInsets.only(
                  right: 8.0,
                ), // Add space from Y-axis line
                child: Text(
                  value.toInt().toString(),
                  style: const TextStyle(fontSize: 12),
                  textAlign: TextAlign.right,
                ),
              );
            },
          ),
        ),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: Colors.grey.withValues(alpha: 0.5)),
      ),
      minX: -0.5, // Add padding on left side to prevent congestion
      maxX: (labels.length - 1).toDouble() + 0.5, // Add padding on right side
      minY: 0,
      maxY: chartMaxY,
      lineBarsData: lineBars,
      lineTouchData: LineTouchData(
        enabled: true,
        touchTooltipData: LineTouchTooltipData(
          getTooltipColor: (touchedSpot) =>
              Colors.blueGrey.withValues(alpha: 0.9),
          tooltipPadding: const EdgeInsets.all(8),
          getTooltipItems: (touchedSpots) {
            return touchedSpots.map((spot) {
              final datasetIndex = spot.barIndex;
              final month = labels[spot.x.toInt()];
              final value = spot.y.toInt();
              final dataset = datasets[datasetIndex];

              return LineTooltipItem(
                '$month\n${dataset.label}: $value',
                const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                ),
              );
            }).toList();
          },
        ),
        touchSpotThreshold: 15, // Increased touch area for better UX
      ),
    );

    // Custom legend
    final legend = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Wrap(
        spacing: 16,
        runSpacing: 8,
        children: datasets.map((dataset) {
          final color = _colorFromHex(dataset.borderColor);
          final isDashed = (dataset.borderDash.isNotEmpty);
          final lineIndicator = isDashed
              ? Row(
                  children: List.generate(
                    4,
                    (index) => index % 2 == 0
                        ? Container(width: 4, height: 2, color: color)
                        : const SizedBox(width: 2),
                  ),
                )
              : Container(width: 16, height: 2, color: color);
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              lineIndicator,
              const SizedBox(width: 4),
              Text(dataset.label ?? 'Unknown'),
            ],
          );
        }).toList(),
      ),
    );

    return Card(
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Monthly Cumulative Target vs Coverage ($selectedYear)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          legend,
          SizedBox(
            height: 320, // Increased from 300 for better proportions
            child: Padding(
              padding: const EdgeInsets.only(
                right: 20.0, // Increased padding for better spacing
                bottom: 20.0, // Increased padding for better spacing
                left: 16.0, // Increased from 8.0 for Y-axis title
                top: 8.0, // Added top padding
              ),
              child: LineChart(lineChartData),
            ),
          ),
        ],
      ),
    );
  }
}
