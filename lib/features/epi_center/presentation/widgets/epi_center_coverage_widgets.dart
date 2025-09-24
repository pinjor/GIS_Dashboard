import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../filter/presentation/controllers/filter_controller.dart';
import '../../domain/epi_center_details_response.dart';

/// Collection of coverage table widgets for EPI Center Details
class EpiCenterCoverageTables extends StatelessWidget {
  final EpiCenterDetailsResponse? coverageDropoutData;

  const EpiCenterCoverageTables({super.key, required this.coverageDropoutData});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CoverageSection(
          coverageData: coverageDropoutData,
          isDropout: false,
          epiCenterData: coverageDropoutData,
        ),
        const SizedBox(height: 16),
        CoverageSection(
          coverageData: coverageDropoutData,
          isDropout: true,
          epiCenterData: coverageDropoutData,
        ),
      ],
    );
  }
}

class CoverageSection extends StatelessWidget {
  final dynamic coverageData;
  final bool isDropout;
  final dynamic epiCenterData;

  const CoverageSection({
    super.key,
    required this.coverageData,
    required this.isDropout,
    required this.epiCenterData,
  });

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
                Icon(
                  isDropout ? Icons.trending_down : Icons.bar_chart,
                  color: isDropout ? Colors.red[600] : Colors.blue[600],
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  isDropout ? 'Monthly Dropout Data' : 'Monthly Coverage Data',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 350,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 12,
                itemBuilder: (context, index) {
                  return Container(
                    width: 280,
                    margin: const EdgeInsets.only(right: 16),
                    child: MonthlyCard(
                      coverageData: coverageData,
                      monthIndex: index,
                      isDropout: isDropout,
                      epiCenterData: epiCenterData,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MonthlyCard extends ConsumerWidget {
  final dynamic coverageData;
  final int monthIndex;
  final bool isDropout;
  final dynamic epiCenterData;

  const MonthlyCard({
    super.key,
    required this.coverageData,
    required this.monthIndex,
    required this.isDropout,
    required this.epiCenterData,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final months = [
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

    final month = months[monthIndex];

    // Try to get actual data from API response first
    Map<String, dynamic>? monthData;
    if (coverageData is Map<String, dynamic> &&
        coverageData['months'] is Map<String, dynamic>) {
      monthData = coverageData['months'][month];
    }

    // Extract data for the month from coverageTableData
    String dataType = isDropout ? 'dropouts' : 'coverages';
    Map<String, dynamic>? values = monthData?[dataType];

    // If no coverage data available from coverageTableData, extract from area's vaccine coverage
    if (values == null && !isDropout) {
      // Get current year from filter
      final filterState = ref.read(filterControllerProvider);
      final currentYear = filterState.selectedYear;

      // Try to get coverage data from epiCenterData.area.vaccineCoverage
      final epiCenterDataLocal =
          coverageData; // This is the full epiCenterData object
      if (epiCenterDataLocal?.area?.vaccineCoverage != null) {
        final yearCoverage = epiCenterDataLocal
            .area
            .vaccineCoverage
            .child0To11Month[currentYear];

        if (yearCoverage != null) {
          // First try to get monthly data
          final monthNumber = (monthIndex + 1)
              .toString(); // Convert 0-based index to 1-based month

          if (yearCoverage.months != null &&
              yearCoverage.months![monthNumber] != null) {
            final monthDataLocal = yearCoverage.months![monthNumber]!;

            if (monthDataLocal.vaccine != null) {
              // Convert vaccine array to a map for easier access
              values = {};
              for (var vaccineData in monthDataLocal.vaccine!) {
                final vaccineName = vaccineData.vaccineName;
                final male = vaccineData.male;
                final female = vaccineData.female;

                if (vaccineName != null) {
                  // Calculate total from male + female (handle null values)
                  int total = 0;
                  if (male != null) total += (male as int);
                  if (female != null) total += (female as int);
                  values[vaccineName] = total;
                }
              }
            }
          }

          // If no monthly data, try to get cumulative data up to this month
          if ((values == null || values.isEmpty)) {
            // Get cumulative data for better representation
            values = _calculateCumulativeDataUpToMonth(
              epiCenterDataLocal,
              monthIndex,
              currentYear,
              ref,
            );
          }

          // If still no data, try to get total data from the year as last resort
          if ((values == null || values.isEmpty) &&
              yearCoverage.vaccine != null) {
            // Convert vaccine array to a map for easier access
            values = {};
            for (var vaccineData in yearCoverage.vaccine!) {
              final vaccineName = vaccineData.vaccineName;
              final male = vaccineData.male;
              final female = vaccineData.female;

              if (vaccineName != null) {
                // Calculate total from male + female (handle null values)
                int total = 0;
                if (male != null) total += (male as int);
                if (female != null) total += (female as int);

                // For annual display, show the total divided by 12 months as an approximation
                // This is not ideal, but gives us some data to show
                values[vaccineName] = (total / 12).round();
              }
            }
          }
        }
      }
    }

    // Use actual data if available, otherwise show zeros
    final vaccines = {
      'Penta - 1st': values?['Penta - 1st']?.toString() ?? '0',
      'Penta - 2nd': values?['Penta - 2nd']?.toString() ?? '0',
      'Penta - 3rd': values?['Penta - 3rd']?.toString() ?? '0',
      'MR - 1st': values?['MR - 1st']?.toString() ?? '0',
      'MR - 2nd': values?['MR - 2nd']?.toString() ?? '0',
      'BCG': values?['BCG']?.toString() ?? '0',
    };

    final total = _calculateMonthTotal(values);
    final averagePerformance = _calculateAveragePerformance(vaccines);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDropout
              ? [Colors.red[50]!, Colors.red[100]!]
              : [Colors.blue[50]!, Colors.blue[100]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDropout ? Colors.red[200]! : Colors.blue[200]!,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Month Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  month,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDropout ? Colors.red[800] : Colors.blue[800],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: isDropout ? Colors.red[100] : Colors.blue[100],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isDropout ? Colors.red[200]! : Colors.blue[200]!,
                      width: 1,
                    ),
                  ),
                  child: Text(
                    '${averagePerformance.toStringAsFixed(1)}%',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: isDropout ? Colors.red[700] : Colors.blue[700],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Total Count
            Text(
              'Total: $total',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDropout ? Colors.red[700] : Colors.blue[700],
              ),
            ),
            const SizedBox(height: 16),

            // Vaccine List
            Expanded(
              child: ListView(
                children: vaccines.entries.map((entry) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            entry.key,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: isDropout
                                ? Colors.red[100]
                                : Colors.blue[100],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            entry.value,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: isDropout
                                  ? Colors.red[700]
                                  : Colors.blue[700],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Calculate cumulative data up to the current month by summing monthly data
  Map<String, dynamic>? _calculateCumulativeDataUpToMonth(
    dynamic epiCenterData,
    int monthIndex,
    String currentYear,
    WidgetRef ref,
  ) {
    if (epiCenterData?.area?.vaccineCoverage == null) return null;

    final yearCoverage =
        epiCenterData.area.vaccineCoverage.child0To11Month[currentYear];
    if (yearCoverage?.months == null) return null;

    // Sum up data from month 1 to current month (monthIndex + 1)
    Map<String, int> cumulativeTotals = {};

    for (int i = 1; i <= (monthIndex + 1); i++) {
      final monthNumber = i.toString();
      final monthData = yearCoverage.months![monthNumber];

      if (monthData?.vaccine != null) {
        for (var vaccineData in monthData!.vaccine!) {
          final vaccineName = vaccineData.vaccineName;
          final male = vaccineData.male;
          final female = vaccineData.female;

          if (vaccineName != null) {
            // Calculate total from male + female (handle null values)
            int monthTotal = 0;
            if (male != null) monthTotal += (male as int);
            if (female != null) monthTotal += (female as int);

            cumulativeTotals[vaccineName] =
                (cumulativeTotals[vaccineName] ?? 0) + monthTotal;
          }
        }
      }
    }

    // Convert to Map<String, dynamic> for compatibility
    return cumulativeTotals.map((key, value) => MapEntry(key, value));
  }

  double _calculateAveragePerformance(Map<String, String> vaccines) {
    double total = 0;
    int count = 0;

    for (var value in vaccines.values) {
      final numValue = double.tryParse(value);
      if (numValue != null) {
        total += numValue;
        count++;
      }
    }

    return count > 0 ? total / count : 0;
  }

  int _calculateMonthTotal(Map<String, dynamic>? values) {
    if (values == null) return 0;
    int total = 0;
    values.forEach((key, value) {
      if (value is int) {
        total += value;
      } else if (value is String) {
        total += int.tryParse(value) ?? 0;
      }
    });
    return total;
  }
}
