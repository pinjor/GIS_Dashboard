import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gis_dashboard/features/epi_center/domain/epi_center_details_response.dart';
import 'package:gis_dashboard/features/summary/domain/vaccine_coverage_response.dart';
import 'package:gis_dashboard/core/utils/target_calculator.dart';
import 'package:gis_dashboard/core/utils/utils.dart';
import '../../../filter/presentation/controllers/filter_controller.dart';

/// Collection of microplan and population related widgets for EPI Center Details
class EpiCenterMicroplanSection extends ConsumerWidget {
  final EpiCenterDetailsResponse? epiCenterDetailsData;
  final VaccineCoverageResponse? coverageData; // ✅ Coverage data for consistent calculation
  final String? selectedVaccineUid; // ✅ Selected vaccine UID

  const EpiCenterMicroplanSection({
    super.key,
    required this.epiCenterDetailsData,
    this.coverageData, // ✅ Optional coverage data
    this.selectedVaccineUid, // ✅ Optional selected vaccine UID
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.table_chart, color: Colors.blue[600], size: 24),
                const SizedBox(width: 8),
                const Text(
                  'Microplan Data',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            MicroplanTable(
              epiData: epiCenterDetailsData,
              coverageData: coverageData, // ✅ Pass coverage data
              selectedVaccineUid: selectedVaccineUid, // ✅ Pass selected vaccine
            ),
          ],
        ),
      ),
    );
  }
}

class MicroplanTable extends ConsumerWidget {
  final EpiCenterDetailsResponse? epiData;
  final VaccineCoverageResponse? coverageData; // ✅ Coverage data for consistent calculation
  final String? selectedVaccineUid; // ✅ Selected vaccine UID

  const MicroplanTable({
    super.key,
    required this.epiData,
    this.coverageData, // ✅ Optional coverage data
    this.selectedVaccineUid, // ✅ Optional selected vaccine UID
  });

  String formatCount(dynamic value) {
    if (value is int || value is double) {
      return value.toString();
    }
    return '-';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get the current year from filter
    final filterState = ref.read(filterControllerProvider);
    final currentYear = filterState.selectedYear;
    if (currentYear == "") {
      return const Text('No year selected in filter.');
    }
    // ✅ Use helper method that handles both country-level and EPI-level data
    final yearDemographics = epiData?.getDemographicsForYear(currentYear);
    final population = yearDemographics?.population;
    final child0To15Month = yearDemographics?.child0To15Month;
    final women15To49 = yearDemographics?.women15To49;
    
    // ✅ PRIORITY: Use coverage data for "Child (0-11)" to match Summary card
    String child0To11Male = '-';
    String child0To11Female = '-';
    
    logg.i('🔍 [0-11m DEBUG] EpiCenterMicroplanSection: Calculating Child (0-11) values');
    logg.i('   > Coverage data: ${coverageData != null ? "present" : "null"}');
    logg.i('   > Selected vaccine UID: $selectedVaccineUid');
    logg.i('   > Year demographics: ${yearDemographics != null ? "present" : "null"}');
    logg.i('   > Filter state: Ward=${filterState.selectedWard}, Subblock=${filterState.selectedSubblock}');
    
    // ✅ FIX: Get area UID/name for ward/subblock level filtering
    String? areaUid;
    String? areaName;
    final filterController = ref.read(filterControllerProvider.notifier);
    
    if (filterState.selectedSubblock != null && filterState.selectedSubblock != 'All') {
      // For subblock level, use subblock UID
      areaUid = filterController.getSubblockUid(filterState.selectedSubblock!);
      areaName = filterState.selectedSubblock;
      logg.i('   > Filtering by subblock: $areaName (UID: $areaUid)');
    } else if (filterState.selectedWard != null && filterState.selectedWard != 'All') {
      // For ward level, use ward UID
      areaUid = filterController.getWardUid(filterState.selectedWard!);
      areaName = filterState.selectedWard;
      logg.i('   > Filtering by ward: $areaName (UID: $areaUid)');
    }
    
    if (coverageData != null) {
      final targetData = TargetCalculator.getTargetData(
        coverageData,
        selectedVaccineUid,
        areaUid: areaUid,
        areaName: areaName,
      );
      if (targetData != null && targetData.total > 0) {
        child0To11Male = formatCount(targetData.male);
        child0To11Female = formatCount(targetData.female);
        logg.i(
          'Microplan Table: ✅ Using coverage data for Child (0-11) - '
          'total: ${targetData.total}, male: ${targetData.male} (displayed: $child0To11Male), female: ${targetData.female} (displayed: $child0To11Female)',
        );
      } else {
        // Fallback to demographics if coverage data is not available
        final child0To11Month = yearDemographics?.child0To11Month;
        child0To11Male = formatCount(child0To11Month?.male);
        child0To11Female = formatCount(child0To11Month?.female);
        logg.w('Microplan Table: ⚠️ TargetCalculator returned null/zero, using demographics fallback for Child (0-11)');
        logg.w('   > Demographics - male: ${child0To11Month?.male}, female: ${child0To11Month?.female}');
        logg.w('   > Displayed - male: $child0To11Male, female: $child0To11Female');
      }
    } else {
      // Fallback to demographics if coverage data is not provided
      final child0To11Month = yearDemographics?.child0To11Month;
      child0To11Male = formatCount(child0To11Month?.male);
      child0To11Female = formatCount(child0To11Month?.female);
      logg.w('Microplan Table: ⚠️ Coverage data not available, using demographics for Child (0-11)');
      logg.w('   > Demographics - male: ${child0To11Month?.male}, female: ${child0To11Month?.female}');
      logg.w('   > Displayed - male: $child0To11Male, female: $child0To11Female');
    }
    
    logg.i('🔍 [0-11m DEBUG] Final Child (0-11) values: male=$child0To11Male, female=$child0To11Female');
    
    return Column(
      children: [
        PopulationCard(
          category: "totalpopulation",
          title: "Total Population",
          male: formatCount(population?.male),
          female: formatCount(population?.female),
        ),

        PopulationCard(
          category: "0-11",
          title: "Child (0-11)",
          male: child0To11Male, // ✅ Use coverage data
          female: child0To11Female, // ✅ Use coverage data
        ),
        PopulationCard(
          category: "0-15",
          title: "Child (0-15)",
          male: formatCount(child0To15Month?.male),
          female: formatCount(child0To15Month?.female),
        ),
        PopulationCard(
          category: "women",
          title: "Women 15-49 years",
          male: '-',
          female: formatCount(women15To49),
        ),
      ],
    );
  }
}

class PopulationCard extends StatelessWidget {
  final String category;
  final String title;
  final String male;
  final String female;

  const PopulationCard({
    super.key,
    required this.category,
    required this.title,
    required this.male,
    required this.female,
  });

  @override
  Widget build(BuildContext context) {
    Color categoryColor = _getCategoryColor(category);

    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: categoryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _getCategoryIcon(category),
                    color: categoryColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Total: ${(int.tryParse(male) ?? 0) + (int.tryParse(female) ?? 0)}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: categoryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (category != "women") ...[
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 1,
                    child: GenderInfo(
                      gender: 'Male',
                      count: male,
                      color: Colors.blue[600]!,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Flexible(
                    flex: 1,
                    child: GenderInfo(
                      gender: 'Female',
                      count: female,
                      color: Colors.pink[600]!,
                    ),
                  ),
                ],
              ),
            ],
          ],

          // if (progress > 0) ...[
          //   const SizedBox(height: 12),
          //   LinearProgressIndicator(
          //     value: progress > 1 ? 1 : progress,
          //     backgroundColor: Colors.grey[300],
          //     color: categoryColor,
          //   ),
          //   const SizedBox(height: 4),
          //   Text(
          //     '${(progress * 100).toStringAsFixed(1)}% of total population',
          //     style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          //   ),
          // ],
        ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'totalpopulation':
        return Colors.blue[600]!;
      case '0-11':
        return Colors.green[600]!;
      case '0-15':
        return Colors.orange[600]!;
      case 'women':
        return Colors.purple[600]!;
      default:
        return Colors.grey[600]!;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'totalpopulation':
        return Icons.people;
      case '0-11':
        return Icons.child_care;
      case '0-15':
        return Icons.school;
      case 'women':
        return Icons.woman;
      default:
        return Icons.person;
    }
  }
}

class GenderInfo extends StatelessWidget {
  final String gender;
  final String count;
  final Color color;

  const GenderInfo({
    super.key,
    required this.gender,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          gender,
          style: TextStyle(
            color: color,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          maxLines: 1,
        ),
        const SizedBox(height: 4),
        Text(
          count,
          style: TextStyle(
            color: color,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          maxLines: 1,
        ),
      ],
    );
  }
}
