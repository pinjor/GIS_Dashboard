import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gis_dashboard/features/filter/filter.dart';
import 'package:gis_dashboard/core/utils/utils.dart';
import 'package:gis_dashboard/features/summary/presentation/controllers/summary_controller.dart';
import 'package:gis_dashboard/features/summary/domain/vaccine_coverage_response.dart';

import '../../../../core/common/constants/constants.dart';

class VaccineCoveragePerformanceTableWidget extends ConsumerWidget {
  const VaccineCoveragePerformanceTableWidget({super.key});

  // Calculate dropout percentage from target and dropout fields
  double _calculateDropoutPercentage(int? target, double? dropout) {
    if (target == null || dropout == null || target == 0) return 0.0;
    final dropoutPercentage = (dropout / target) * 100;
    return dropoutPercentage < 0 ? 0.0 : dropoutPercentage;
  }

  // Create performance areas with indicators
  List<Map<String, dynamic>> _createPerformanceData(Vaccine selectedVaccine) {
    List<Map<String, dynamic>> performanceData = [];

    // Get highest performers
    List<Area> highestAreas = [];
    if (selectedVaccine.performance?.highest?.isNotEmpty == true) {
      // only add the areas to highestAreas if there coverage percentage is above 90%

      highestAreas = selectedVaccine.performance!.highest!
          .where((area) => (area.coveragePercentage?.round() ?? 0) >= 90)
          .toList();
    } else {
      return performanceData; // No highest performers to add
    }

    // Add highest performers with upward indicator
    for (Area area in highestAreas) {
      performanceData.add({
        'area': area,
        'isHighest': true,
        'icon': Icons.trending_up,
        'iconColor': Colors.green,
      });
    }

    // Get lowest performers
    List<Area> lowestAreas = [];
    if (selectedVaccine.performance?.lowest?.isNotEmpty == true) {
      lowestAreas = selectedVaccine.performance!.lowest!;
    } else {
      return performanceData; // No lowest performers to add
    }

    // Add lowest performers with downward indicator
    for (Area area in lowestAreas) {
      performanceData.add({
        'area': area,
        'isHighest': false,
        'icon': Icons.trending_down,
        'iconColor': Colors.red,
      });
    }

    return performanceData;
  }

  String _getLocationName(String locationName) {
    if (locationName.isEmpty) return 'Bangladesh';
    return locationName.replaceAll(RegExp(r'\s*\(.*?\)'), '').trim();
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
                  'Performance Table',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
                  'Performance Table',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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

    // Find the selected vaccine from the coverage data
    final vaccines = summaryState.coverageData?.vaccines ?? [];
    final selectedVaccine = vaccines.isNotEmpty
        ? vaccines.firstWhere(
            (vaccine) => vaccine.vaccineName == filterState.selectedVaccine,
            orElse: () => vaccines.first,
          )
        : null;

    if (selectedVaccine == null) {
      return Card(
        color: Color(Constants.cardColor),
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: const Padding(
          padding: EdgeInsets.all(16),
          child: Text('No vaccine data available'),
        ),
      );
    }

    // Get performance data - use performance section if available, otherwise create from areas
    final performanceData = _createPerformanceData(selectedVaccine);

    // Use dynamic location name based on current area
    final locationName = _getLocationName(summaryState.currentAreaName);

    if (performanceData.isEmpty) {
      return Card(
        color: Color(Constants.cardColor),
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: const Padding(
          padding: EdgeInsets.all(16),
          child: Text('No performance data available'),
        ),
      );
    }

    // Split performanceData into top and low performers based on the 'isHighest' flag
    final topPerformers = performanceData
        .where((data) => data['isHighest'] == true)
        .toList();
    final lowPerformers = performanceData
        .where((data) => data['isHighest'] != true)
        .toList();

    return Card(
      color: Color(Constants.cardColor),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(5),
              child: Text(
                '$locationName Performance',
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  // Header row
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            '#',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        4.w,
                        Expanded(
                          flex: 3,
                          child: Text(
                            locationName,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            'Coverage',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            'Dropout',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Top Performing section
                  if (topPerformers.isNotEmpty)
                    _buildDistinctPerformersRows(
                      performer: topPerformers,
                      isHighPerformer: true,
                    ),

                  // Low Performing section
                  if (lowPerformers.isNotEmpty)
                    _buildDistinctPerformersRows(
                      performer: lowPerformers,
                      isHighPerformer: false,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDistinctPerformersRows({
    required List<Map<String, dynamic>> performer,
    bool isHighPerformer = true,
  }) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,

          child: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              isHighPerformer
                  ? 'High Performing (${performer.length} area)'
                  : 'Low Performing (${performer.length} area)',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
        ...performer.asMap().entries.map((entry) {
          final index = entry.key;
          final data = entry.value;
          final area = data['area'] as Area;
          final isEven = index % 2 == 0;
          final dropoutPercentage = _calculateDropoutPercentage(
            area.target,
            area.dropout,
          );

          return Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 2),
            decoration: BoxDecoration(
              color: isEven ? Colors.white : Colors.grey.shade50,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Icon(
                    data['icon'] as IconData,
                    color: data['iconColor'] as Color,
                    size: 20,
                  ),
                ),
                4.w,
                Expanded(
                  flex: 3,
                  child: Text(
                    area.name ?? 'Unknown',
                    style: const TextStyle(fontSize: 13),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    '${(area.coveragePercentage ?? 0).round().toStringAsFixed(2)}%',
                    style: const TextStyle(fontSize: 13),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    '${dropoutPercentage.round().toStringAsFixed(2)}%',
                    style: const TextStyle(fontSize: 13),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}
