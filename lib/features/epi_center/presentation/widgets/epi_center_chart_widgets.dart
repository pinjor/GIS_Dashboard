import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

/// Collection of chart widgets for EPI Center Details
class EpiCenterChartSection extends StatelessWidget {
  final dynamic chartData;

  const EpiCenterChartSection({super.key, required this.chartData});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.show_chart, color: Colors.blue[600], size: 24),
                const SizedBox(width: 8),
                const Text(
                  'Coverage Trends',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 300,
              child: chartData != null
                  ? CoverageLineChart(chartData: chartData)
                  : const EmptyChart(),
            ),
            const SizedBox(height: 20),
            const ChartLegend(),
          ],
        ),
      ),
    );
  }
}

class CoverageLineChart extends StatelessWidget {
  final dynamic chartData;

  const CoverageLineChart({super.key, required this.chartData});

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          horizontalInterval: 20,
          verticalInterval: 1,
          getDrawingHorizontalLine: (value) {
            return FlLine(color: Colors.grey[300]!, strokeWidth: 1);
          },
          getDrawingVerticalLine: (value) {
            return FlLine(color: Colors.grey[300]!, strokeWidth: 1);
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
              reservedSize: 30,
              interval: 1,
              getTitlesWidget: (double value, TitleMeta meta) {
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
                  'Dec',
                ];
                int index = value.toInt();
                if (index >= 0 && index < months.length) {
                  return SideTitleWidget(
                    meta: meta,
                    child: Text(
                      months[index],
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
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
              interval: 20,
              reservedSize: 42,
              getTitlesWidget: (double value, TitleMeta meta) {
                return Text(
                  value.toInt().toString(),
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: Colors.grey[300]!, width: 1),
        ),
        minX: 0,
        maxX: 11,
        minY: 0,
        maxY: 100,
        lineBarsData: _buildChartLines(),
      ),
    );
  }

  List<LineChartBarData> _buildChartLines() {
    // Sample chart data - should be from API response
    return [
      LineChartBarData(
        spots: List.generate(
          12,
          (index) =>
              FlSpot(index.toDouble(), (60 + (index * 2) % 20).toDouble()),
        ),
        isCurved: true,
        color: Colors.blue[600]!,
        dotData: const FlDotData(show: true),
        belowBarData: BarAreaData(
          show: true,
          color: Colors.blue[600]!.withOpacity(0.1),
        ),
      ),
      LineChartBarData(
        spots: List.generate(
          12,
          (index) =>
              FlSpot(index.toDouble(), (50 + (index * 3) % 25).toDouble()),
        ),
        isCurved: true,
        color: Colors.green[600]!,
        dotData: const FlDotData(show: true),
        belowBarData: BarAreaData(show: false),
      ),
      LineChartBarData(
        spots: List.generate(
          12,
          (index) =>
              FlSpot(index.toDouble(), (40 + (index * 4) % 30).toDouble()),
        ),
        isCurved: true,
        color: Colors.orange[600]!,
        dotData: const FlDotData(show: true),
        belowBarData: BarAreaData(show: false),
      ),
      LineChartBarData(
        spots: List.generate(
          12,
          (index) =>
              FlSpot(index.toDouble(), (45 + (index * 2) % 20).toDouble()),
        ),
        isCurved: true,
        color: Colors.purple[600]!,
        dotData: const FlDotData(show: true),
        belowBarData: BarAreaData(show: false),
      ),
      LineChartBarData(
        spots: List.generate(
          12,
          (index) =>
              FlSpot(index.toDouble(), (55 + (index * 3) % 15).toDouble()),
        ),
        isCurved: true,
        color: Colors.red[600]!,
        dotData: const FlDotData(show: true),
        belowBarData: BarAreaData(show: false),
      ),
      LineChartBarData(
        spots: List.generate(
          12,
          (index) =>
              FlSpot(index.toDouble(), (65 + (index * 1) % 10).toDouble()),
        ),
        isCurved: true,
        color: Colors.teal[600]!,

        dashArray: [5, 5],
        dotData: const FlDotData(show: true),
        belowBarData: BarAreaData(show: false),
      ),
      LineChartBarData(
        spots: List.generate(
          12,
          (index) =>
              FlSpot(index.toDouble(), (70 + (index * 2) % 12).toDouble()),
        ),
        isCurved: true,
        color: Colors.brown[600]!,

        dashArray: [5, 5],
        dotData: const FlDotData(show: true),
        belowBarData: BarAreaData(show: false),
      ),
    ];
  }
}

class EmptyChart extends StatelessWidget {
  const EmptyChart({super.key});

  @override
  Widget build(BuildContext context) {
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
          Icon(Icons.timeline, color: Colors.grey[400], size: 48),
          const SizedBox(height: 12),
          Text(
            'No chart data available',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Coverage trend charts will appear here when data is available',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey[500], fontSize: 14),
          ),
        ],
      ),
    );
  }
}

class ChartLegend extends StatelessWidget {
  const ChartLegend({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: [
        LegendItem(
          label: 'Monthly Target',
          color: Colors.teal[600]!,
          isDashed: true,
        ),
        LegendItem(label: 'Penta - 1st', color: Colors.blue[600]!),
        LegendItem(label: 'Penta - 2nd', color: Colors.green[600]!),
        LegendItem(label: 'Penta - 3rd', color: Colors.orange[600]!),
        LegendItem(label: 'MR - 1st', color: Colors.purple[600]!),
        LegendItem(label: 'MR - 2nd', color: Colors.red[600]!),
        LegendItem(label: 'BCG', color: Colors.brown[600]!, isDashed: true),
      ],
    );
  }
}

class LegendItem extends StatelessWidget {
  final String label;
  final Color color;
  final bool isDashed;

  const LegendItem({
    super.key,
    required this.label,
    required this.color,
    this.isDashed = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 20,
          height: 3,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
          child: isDashed
              ? CustomPaint(
                  painter: DashedLinePainter(color: color),
                  size: const Size(20, 3),
                )
              : null,
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
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
