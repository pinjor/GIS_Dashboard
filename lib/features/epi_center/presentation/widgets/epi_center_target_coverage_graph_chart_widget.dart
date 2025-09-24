import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math' as math;
import '../../../../core/utils/utils.dart';
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

  String _getShortMonthName(String month) {
    return monthAbbrevName[month] ?? month;
  }

  String formatCompactNumber(String number) {
    if (number.isEmpty) return 'N/A';
    final parsed = double.tryParse(number);
    if (parsed == null) return 'N/A';
    final realNum = parsed;
    String formatted;
    if (realNum >= 1e9) {
      formatted = (realNum / 1e9).toStringAsFixed(2);
      return '${_trimTrailingZeros(formatted)}B';
    } else if (realNum >= 1e6) {
      formatted = (realNum / 1e6).toStringAsFixed(2);
      return '${_trimTrailingZeros(formatted)}M';
    } else if (realNum >= 1e3) {
      formatted = (realNum / 1e3).toStringAsFixed(2);
      return '${_trimTrailingZeros(formatted)}K';
    } else {
      return realNum.toStringAsFixed(0);
    }
  }

  String _trimTrailingZeros(String value) {
    return value
        .replaceAll(RegExp(r'\.00$'), '') // removes .00
        .replaceAll(RegExp(r'(\.\d)0$'), r'\1'); // keeps 1 decimal if needed
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
          dotData: FlDotData(show: showDots),
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
            reservedSize: 40,
            getTitlesWidget: (value, meta) {
              final int index = value.toInt();
              if (index < 0 || index >= labels.length) {
                return const SizedBox.shrink();
              }
              return SideTitleWidget(
                meta: meta,
                space: 8,
                angle: 45 * (math.pi / 180), // Rotate for better fit on mobile
                child: Text(
                  _getShortMonthName(labels[index]),
                  style: const TextStyle(fontSize: 10),
                ),
              );
            },
          ),
        ),
        leftTitles: AxisTitles(
          axisNameWidget: const Text(
            'Number of vaccinations',
            style: TextStyle(fontSize: 9),
          ),
          sideTitles: SideTitles(
            showTitles: true,
            interval: interval,
            reservedSize: 35,
            getTitlesWidget: (value, meta) {
              return Padding(
                padding: const EdgeInsets.only(right: 3.0),
                child: Text(
                  formatCompactNumber(value.toInt().toString()),
                  style: const TextStyle(fontSize: 10),
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
        border: Border.all(color: Colors.grey.withOpacity(0.5)),
      ),
      minX: 0,
      maxX: (labels.length - 1).toDouble(),
      minY: 0,
      maxY: chartMaxY,
      lineBarsData: lineBars,
      lineTouchData: LineTouchData(
        enabled: true,
        touchTooltipData: LineTouchTooltipData(
          getTooltipColor: (touchedSpot) => Colors.blueGrey.withOpacity(0.8),
        ),
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
          12.h,
          SizedBox(
            height: 450,
            child: Padding(
              padding: const EdgeInsets.only(
                right: 10,
                bottom: 10.0,
                left: 0.0,
              ),
              child: LineChart(lineChartData),
            ),
          ),
        ],
      ),
    );
  }
}
