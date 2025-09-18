import 'package:flutter/material.dart';

import '../../../../config/coverage_colors.dart';
import 'map_legend_item.dart';
import 'vaccine_center_info_overlay_widget.dart';

class MapCoverageVisualizerCardWidget extends StatefulWidget {
  final String currentLevel;

  const MapCoverageVisualizerCardWidget({
    super.key,
    required this.currentLevel,
  });

  @override
  State createState() => _MapCoverageVisualizerCardState();
}

class _MapCoverageVisualizerCardState
    extends State<MapCoverageVisualizerCardWidget> {
  bool _isCoverageDataExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header row (tap to expand/collapse)
          InkWell(
            onTap: () {
              setState(() {
                _isCoverageDataExpanded = !_isCoverageDataExpanded;
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Coverage",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    _isCoverageDataExpanded
                        ? Icons.arrow_drop_up_sharp
                        : Icons.arrow_drop_down_sharp,
                    size: 15,
                  ),
                ],
              ),
            ),
          ),

          // Expandable content
          if (_isCoverageDataExpanded)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Conditionally show this widget based on the currentLevel
                  if (widget.currentLevel == 'city_corporation' ||
                      widget.currentLevel == 'union' ||
                      widget.currentLevel == 'ward' ||
                      widget.currentLevel == 'subblock')
                    const VaccineCenterInfoOverlayWidget(),

                  // Map legend items
                  MapLegendItem(color: CoverageColors.veryLow, label: '<80%'),
                  MapLegendItem(color: CoverageColors.low, label: '80-85%'),
                  MapLegendItem(color: CoverageColors.medium, label: '85-90%'),
                  MapLegendItem(color: CoverageColors.high, label: '90-95%'),
                  MapLegendItem(color: CoverageColors.veryHigh, label: '>95%'),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
