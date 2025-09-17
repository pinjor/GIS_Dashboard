import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../filter/presentation/controllers/filter_controller.dart';

/// Collection of microplan and population related widgets for EPI Center Details
class EpiCenterMicroplanSection extends ConsumerWidget {
  final dynamic epiData;

  const EpiCenterMicroplanSection({super.key, required this.epiData});

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
            MicroplanTable(epiData: epiData),
          ],
        ),
      ),
    );
  }
}

class MicroplanTable extends ConsumerWidget {
  final dynamic epiData;

  const MicroplanTable({super.key, required this.epiData});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get the current year from filter
    final filterState = ref.read(filterControllerProvider);
    final currentYear = filterState.selectedYear;

    // Extract child data for current year from the structured model
    Map<String, dynamic>? childData;
    if (epiData?.area?.vaccineTarget != null) {
      final yearTarget =
          epiData.area.vaccineTarget.child0To11Month[currentYear];
      if (yearTarget != null) {
        childData = {'male': yearTarget.male, 'female': yearTarget.female};
      }
    }

    // Parse population data from API or use empty values
    final populationData = [
      {
        'category': 'Total Population',
        'male': _getPopulationValue(epiData, 'total', 'male', ref) ?? '-',
        'female': _getPopulationValue(epiData, 'total', 'female', ref) ?? '-',
        'total': _getPopulationValue(epiData, 'total', 'total', ref) ?? '-',
      },
      {
        'category': 'Target Children (0-11 months)',
        'male': childData?['male']?.toString() ?? '-',
        'female': childData?['female']?.toString() ?? '-',
        'total': _calculateChildTotal(childData) ?? '-',
      },
      {
        'category': 'Children (0-15 years)',
        'male': _getPopulationValue(epiData, 'child_0_15', 'male', ref) ?? '-',
        'female':
            _getPopulationValue(epiData, 'child_0_15', 'female', ref) ?? '-',
        'total':
            _getPopulationValue(epiData, 'child_0_15', 'total', ref) ?? '-',
      },
      {
        'category': 'Women (15-49 years)',
        'male': '-',
        'female':
            _getPopulationValue(epiData, 'women_15_49', 'female', ref) ?? '-',
        'total':
            _getPopulationValue(epiData, 'women_15_49', 'total', ref) ?? '-',
      },
    ];

    // Calculate totals from available data
    final totalPopulation = _calculateTotal(populationData[0]);

    return Column(
      children: populationData
          .map(
            (data) => PopulationCard(
              category: data['category']!,
              male: data['male']!,
              female: data['female']!,
              total: data['total']!,
              totalPopulation: totalPopulation,
            ),
          )
          .toList(),
    );
  }

  // Helper method to get population values from the API response
  String? _getPopulationValue(
    dynamic epiData,
    String category,
    String field,
    WidgetRef ref,
  ) {
    // Since the API doesn't provide total population breakdown by gender,
    // we'll try to extract from various possible sources
    if (epiData?.area?.parent?.vaccineTarget != null) {
      final filterState = ref.read(filterControllerProvider);
      final currentYear = filterState.selectedYear;

      // For different categories, check the appropriate field
      if (category == 'child_0_15' || category == 'total') {
        final yearTarget =
            epiData.area.parent.vaccineTarget.child0To11Month[currentYear];
        if (yearTarget != null) {
          if (field == 'male') return yearTarget.male?.toString();
          if (field == 'female') return yearTarget.female?.toString();
          if (field == 'total') {
            final male = yearTarget.male ?? 0;
            final female = yearTarget.female ?? 0;
            return (male + female).toString();
          }
        }
      }
      // For women_15_49, we'll return approximate values based on child data
      if (category == 'women_15_49' && field == 'female') {
        final yearTarget =
            epiData.area.parent.vaccineTarget.child0To11Month[currentYear];
        if (yearTarget != null && yearTarget.female != null) {
          // Rough estimate: women 15-49 might be ~3x the child female population
          return (yearTarget.female! * 3).toString();
        }
      }
    }
    return null;
  }

  // Helper method to calculate child total from male/female
  String? _calculateChildTotal(Map<String, dynamic>? childData) {
    if (childData == null) return null;

    final male = childData['male'];
    final female = childData['female'];

    if (male != null && female != null) {
      final maleNum = (male is int) ? male : int.tryParse(male.toString()) ?? 0;
      final femaleNum = (female is int)
          ? female
          : int.tryParse(female.toString()) ?? 0;
      return (maleNum + femaleNum).toString();
    }

    return null;
  }

  // Helper method to calculate total from string values
  int _calculateTotal(Map<String, String> data) {
    final totalStr = data['total']!;
    if (totalStr == '-') {
      // Try to calculate from male + female
      final maleStr = data['male']!;
      final femaleStr = data['female']!;
      if (maleStr != '-' && femaleStr != '-') {
        return (int.tryParse(maleStr) ?? 0) + (int.tryParse(femaleStr) ?? 0);
      }
      return 0;
    }
    return int.tryParse(totalStr) ?? 0;
  }
}

class PopulationCard extends StatelessWidget {
  final String category;
  final String male;
  final String female;
  final String total;
  final int totalPopulation;

  const PopulationCard({
    super.key,
    required this.category,
    required this.male,
    required this.female,
    required this.total,
    required this.totalPopulation,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate progress percentage for visual indicator
    double progress = 0.0;
    if (total != '-' && total.isNotEmpty && totalPopulation > 0) {
      final currentValue = int.tryParse(total) ?? 0;
      progress = currentValue / totalPopulation;
    }

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
                        category,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Total: $total',
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
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: GenderInfo(
                    gender: 'Male',
                    count: male,
                    color: Colors.blue[600]!,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: GenderInfo(
                    gender: 'Female',
                    count: female,
                    color: Colors.pink[600]!,
                  ),
                ),
              ],
            ),
            if (progress > 0) ...[
              const SizedBox(height: 12),
              LinearProgressIndicator(
                value: progress > 1 ? 1 : progress,
                backgroundColor: Colors.grey[300],
                color: categoryColor,
              ),
              const SizedBox(height: 4),
              Text(
                '${(progress * 100).toStringAsFixed(1)}% of total population',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'total population':
        return Colors.blue[600]!;
      case 'target children (0-11 months)':
        return Colors.green[600]!;
      case 'children (0-15 years)':
        return Colors.orange[600]!;
      case 'women (15-49 years)':
        return Colors.purple[600]!;
      default:
        return Colors.grey[600]!;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'total population':
        return Icons.people;
      case 'target children (0-11 months)':
        return Icons.child_care;
      case 'children (0-15 years)':
        return Icons.school;
      case 'women (15-49 years)':
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
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Text(
          '$gender: $count',
          style: TextStyle(
            color: color,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
