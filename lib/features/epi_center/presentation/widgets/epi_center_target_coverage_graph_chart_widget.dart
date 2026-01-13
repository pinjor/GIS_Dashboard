import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../domain/epi_center_details_response.dart';

/// Chart widget using Syncfusion Flutter Charts with interactive legend
class EpiCenterTargetCoverageGraphChartWidget extends StatefulWidget {
  final ChartData? chartData;
  final String selectedYear;

  const EpiCenterTargetCoverageGraphChartWidget({
    super.key,
    required this.chartData,
    required this.selectedYear,
  });

  @override
  State<EpiCenterTargetCoverageGraphChartWidget> createState() =>
      _EpiCenterTargetCoverageGraphChartWidgetState();
}

class _EpiCenterTargetCoverageGraphChartWidgetState
    extends State<EpiCenterTargetCoverageGraphChartWidget> {
  // Track visibility of each series
  late Map<String, bool> _seriesVisibility;

  @override
  void initState() {
    super.initState();
    _initializeSeriesVisibility();
  }

  @override
  void didUpdateWidget(EpiCenterTargetCoverageGraphChartWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.chartData != widget.chartData) {
      _initializeSeriesVisibility();
    }
  }

  void _initializeSeriesVisibility() {
    _seriesVisibility = {};
    if (widget.chartData != null) {
      for (var dataset in widget.chartData!.datasets) {
        final seriesName = dataset.label ?? 'Series';
        _seriesVisibility[seriesName] = true; // All series visible by default
      }
    }
  }

  void _toggleSeriesVisibility(String seriesName) {
    setState(() {
      _seriesVisibility[seriesName] = !(_seriesVisibility[seriesName] ?? true);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Early return if chartData is null or empty
    if (widget.chartData == null || widget.chartData!.datasets.isEmpty) {
      return Card(
        margin: const EdgeInsets.all(8),
        elevation: 2,
        child: Container(
          height: 450,
          padding: const EdgeInsets.all(16),
          child: const Center(
            child: Text(
              'No chart data available',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ),
        ),
      );
    }

    final List<CartesianSeries<_ChartPoint, String>> seriesList = [];

    // Build datasets as Syncfusion LineSeries/SplineSeries
    for (var dataset in widget.chartData!.datasets) {
      // Skip datasets with null or empty data
      if (dataset.data.isEmpty || widget.chartData!.labels.isEmpty) continue;

      final seriesName = dataset.label ?? 'Series';

      // Skip if series is hidden
      if (_seriesVisibility[seriesName] == false) continue;

      final List<_ChartPoint> points = [];

      // Ensure we don't exceed available labels
      final dataLength = dataset.data.length;
      final labelsLength = widget.chartData!.labels.length;
      final maxLength = dataLength < labelsLength ? dataLength : labelsLength;

      // Use raw data values directly without any cumulative calculation
      for (int i = 0; i < maxLength; i++) {
        final rawValue = dataset.data[i];
        final value = (rawValue ?? 0).toDouble(); // Handle null values safely
        final label = _getShortMonthName(widget.chartData!.labels[i]);
        points.add(_ChartPoint(label, value)); // No cumulation
      }

      // Skip if no valid points
      if (points.isEmpty) continue;

      final color = _colorFromHex(dataset.borderColor ?? '#000000');
      final isDashed = dataset.borderDash.isNotEmpty;
      final borderWidth = (dataset.borderWidth ?? 2).toDouble();
      final pointRadius = (dataset.pointRadius ?? 3).toDouble();

      if (dataset.tension != null && dataset.tension! > 0) {
        // Smooth curve
        seriesList.add(
          SplineSeries<_ChartPoint, String>(
            name: seriesName,
            dataSource: points,
            xValueMapper: (point, _) => point.month,
            yValueMapper: (point, _) => point.value,
            color: color,
            width: borderWidth,
            dashArray: isDashed ? <double>[3, 2] : <double>[3, 2],
            markerSettings: MarkerSettings(
              isVisible: pointRadius > 0,
              width: pointRadius,
              height: pointRadius,
            ),
          ),
        );
      } else {
        // Straight line
        seriesList.add(
          LineSeries<_ChartPoint, String>(
            name: seriesName,
            dataSource: points,
            xValueMapper: (point, _) => point.month,
            yValueMapper: (point, _) => point.value,
            color: color,
            width: borderWidth,
            dashArray: isDashed ? <double>[3, 2] : <double>[3, 2],
            markerSettings: MarkerSettings(
              isVisible: pointRadius > 0,
              width: pointRadius,
              height: pointRadius,
            ),
          ),
        );
      }
    }

    return Card(
      margin: const EdgeInsets.all(8),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'Monthly Target vs Coverage (${widget.selectedYear})',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            // Interactive Custom Legend with rectangular tap targets
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: widget.chartData!.datasets.map((dataset) {
                final seriesName = dataset.label ?? 'Series';
                final color = _colorFromHex(dataset.borderColor ?? '#000000');
                final isDashed = dataset.borderDash.isNotEmpty;
                final isVisible = _seriesVisibility[seriesName] ?? true;

                return GestureDetector(
                  onTap: () => _toggleSeriesVisibility(seriesName),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isVisible
                          ? Colors.transparent
                          : Colors.grey.shade200,
                      border: Border.all(
                        color: isVisible
                            ? Colors.grey.shade300
                            : Colors.grey.shade400,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Rectangular color indicator (better tap target)
                        Container(
                          width: 24,
                          height: 12,
                          decoration: BoxDecoration(
                            color: isVisible ? color : Colors.grey.shade400,
                            borderRadius: BorderRadius.circular(2),
                          ),
                          child: isDashed
                              ? CustomPaint(
                                  painter: _LegendRectanglePainter(
                                    isVisible ? color : Colors.grey.shade400,
                                    true,
                                  ),
                                )
                              : null,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          seriesName,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: isVisible ? null : Colors.grey.shade600,
                                decoration: isVisible
                                    ? null
                                    : TextDecoration.lineThrough,
                              ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),

            // Chart area with fixed height and tooltip
            SizedBox(
              height: 450,
              child: SfCartesianChart(
                // Remove default margins around the chart
                margin: const EdgeInsets.all(0),
                // Add crosshair for better interaction
                crosshairBehavior: CrosshairBehavior(
                  enable: true,
                  activationMode: ActivationMode.singleTap,
                  lineType: CrosshairLineType.vertical,
                  lineDashArray: [4, 3],
                  lineColor: Colors.grey.shade400,
                  lineWidth: 1,
                ),
                tooltipBehavior: TooltipBehavior(
                  enable: true,
                  canShowMarker: true,
                  // Enhanced tooltip format showing series name and value
                  format: 'series.name: point.y',
                  // Show month as header
                  header: 'point.x',
                  tooltipPosition: TooltipPosition.auto,
                  // Enable shared tooltip to show all series at the point
                  shared: true,
                  // Better styling
                  color: Colors.black87,
                  textStyle: const TextStyle(color: Colors.white, fontSize: 12),
                  // Add some padding and border radius
                  borderWidth: 1,
                  borderColor: Colors.grey.shade300,
                  duration: 200, // Animation duration
                ),
                // Add trackball for enhanced interaction - shows all values at cursor position
                trackballBehavior: TrackballBehavior(
                  enable: true,
                  activationMode: ActivationMode.singleTap,
                  lineType: TrackballLineType.vertical,
                  lineDashArray: [4, 3],
                  lineColor: Colors.blue.shade300,
                  lineWidth: 1.5,
                  // Customize trackball tooltip
                  tooltipSettings: const InteractiveTooltip(
                    enable: true,
                    color: Colors.black87,
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                    borderColor: Colors.transparent,
                    borderWidth: 0,
                    format: 'point.x\nseries.name: point.y',
                  ),
                  // Show marker at each data point
                  markerSettings: const TrackballMarkerSettings(
                    markerVisibility: TrackballVisibilityMode.visible,
                    width: 6,
                    height: 6,
                    borderWidth: 2,
                    borderColor: Colors.white,
                  ),
                ),
                primaryXAxis: CategoryAxis(
                  // how to make the x axis values smaller
                  labelStyle: const TextStyle(fontSize: 9),
                  labelRotation: 45,
                  majorGridLines: const MajorGridLines(width: 0),
                  // Force all months to be displayed
                  maximumLabels: 12,
                  labelIntersectAction: AxisLabelIntersectAction.rotate45,
                  // Remove spacing/padding between axis and first point
                  labelPlacement: LabelPlacement.onTicks,
                  edgeLabelPlacement: EdgeLabelPlacement.shift,
                ),
                primaryYAxis: NumericAxis(
                  // y axis label
                  title: AxisTitle(
                    text: 'Number of Vaccinations',
                    textStyle: const TextStyle(fontSize: 10),
                  ),
                  axisLine: const AxisLine(width: 0),
                  majorTickLines: const MajorTickLines(size: 0),
                  labelFormat: '{value}',
                  numberFormat: NumberFormat.compact(),
                ),
                // Remove plot area borders and padding
                plotAreaBorderWidth: 0,
                series: seriesList,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Chart data point for Syncfusion series
class _ChartPoint {
  final String month;
  final double value;
  _ChartPoint(this.month, this.value);
}

/// Custom rectangular legend painter for dashed patterns
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

/// Convert color hex string to Flutter Color with null safety
Color _colorFromHex(String? hex) {
  // Default to black if hex is null or empty
  if (hex == null || hex.isEmpty) return Colors.black;

  try {
    final cleanHex = hex.replaceFirst('#', '');
    final buffer = StringBuffer();

    // Add alpha channel if not present
    if (cleanHex.length == 6) {
      buffer.write('ff');
    }
    buffer.write(cleanHex);

    return Color(int.parse(buffer.toString(), radix: 16));
  } catch (e) {
    // Return black if parsing fails
    return Colors.black;
  }
}

/// Convert full month to short form with null safety
String _getShortMonthName(String? fullMonth) {
  if (fullMonth == null || fullMonth.isEmpty) return 'N/A';

  final months = {
    'January': 'Jan',
    'February': 'Feb',
    'March': 'Mar',
    'April': 'Apr',
    'May': 'May',
    'June': 'Jun',
    'July': 'Jul',
    'August': 'Aug',
    'September': 'Sep',
    'October': 'Oct',
    'November': 'Nov',
    'December': 'Dec',
  };
  return months[fullMonth] ?? fullMonth;
}
