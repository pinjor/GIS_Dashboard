import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math' as math;
import '../../../filter/presentation/controllers/filter_controller.dart';
import '../../domain/epi_center_details_response.dart';

/// Collection of coverage table widgets for EPI Center Details
class EpiCenterCoverageTables extends StatelessWidget {
  final EpiCenterDetailsResponse? epiCenterDetailsData;

  const EpiCenterCoverageTables({
    super.key,
    required this.epiCenterDetailsData,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CoverageSection(
          epiCenterDetailsData: epiCenterDetailsData,
          isDropout: false,
        ),
        const SizedBox(height: 16),
        CoverageSection(
          epiCenterDetailsData: epiCenterDetailsData,
          isDropout: true,
        ),
      ],
    );
  }
}

class CoverageSection extends StatelessWidget {
  final EpiCenterDetailsResponse? epiCenterDetailsData;
  final bool isDropout;

  const CoverageSection({
    super.key,
    required this.epiCenterDetailsData,
    required this.isDropout,
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
                itemCount: 13, // 12 months + 1 summary card
                itemBuilder: (context, index) {
                  if (index == 12) {
                    // Summary card as the last item
                    return Container(
                      width: 300,
                      margin: const EdgeInsets.only(right: 16),
                      child: SummaryCard(
                        epiCenterDetailsData: epiCenterDetailsData,
                        isDropout: isDropout,
                      ),
                    );
                  }
                  return Container(
                    width: 280,
                    margin: const EdgeInsets.only(right: 16),
                    child: MonthlyCard(
                      epiCenterDetailsData: epiCenterDetailsData,
                      monthIndex: index,
                      isDropout: isDropout,
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
  final EpiCenterDetailsResponse? epiCenterDetailsData;
  final int monthIndex;
  final bool isDropout;

  const MonthlyCard({
    super.key,
    required this.epiCenterDetailsData,
    required this.monthIndex,
    required this.isDropout,
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
    final currentMonth = DateTime.now().month; // Get current system month
    final monthNumber = monthIndex + 1; // Convert to 1-based month number
    final isFutureMonth = monthNumber > currentMonth;

    // Get filter state for selected year
    final filterState = ref.read(filterControllerProvider);
    final selectedYear = filterState.selectedYear;

    // Get yearly target from area.vaccineTarget
    final vaccineTarget = epiCenterDetailsData
        ?.area
        ?.vaccineTarget
        ?.child0To11Month[selectedYear];
    final yearlyTarget = vaccineTarget != null
        ? ((vaccineTarget.male?.toInt() ?? 0) +
              (vaccineTarget.female?.toInt() ?? 0))
        : 0;

    // Get dynamic vaccine names from API
    final vaccineNames =
        epiCenterDetailsData?.coverageTableData?.vaccineNames ?? [];

    Map<String, int> vaccines = {};

    if (isDropout) {
      // For dropout calculation: use ceil(yearlyTarget/12) - coverage
      if (isFutureMonth) {
        // Future months: show 0 for all dropouts
        for (final vaccineName in vaccineNames) {
          vaccines[vaccineName] = 0;
        }
      } else {
        // Current & past months: calculate dropout
        final monthlyTarget = yearlyTarget > 0
            ? (yearlyTarget / 12).round()
            : 0;
        final coverageData =
            epiCenterDetailsData?.coverageTableData?.months[month]?.coverages ??
            {};

        for (final vaccineName in vaccineNames) {
          vaccines[vaccineName] = math.max(
            0,
            monthlyTarget - (coverageData[vaccineName] ?? 0),
          );
        }
      }
    } else {
      // For coverage: always show API data regardless of month
      final coverageData =
          epiCenterDetailsData?.coverageTableData?.months[month]?.coverages ??
          {};

      for (final vaccineName in vaccineNames) {
        vaccines[vaccineName] = coverageData[vaccineName] ?? 0;
      }
    }

    final total = vaccines.values.fold(0, (sum, value) => sum + value);
    // final averagePerformance = vaccines.isNotEmpty
    //     ? vaccines.values.fold(0, (sum, value) => sum + value) /
    //           vaccines.length.toDouble()
    //     : 0.0;

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
            Text(
              month,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDropout ? Colors.red[800] : Colors.blue[800],
              ),
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
                            entry.value.toString(),
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
}

class SummaryCard extends ConsumerWidget {
  final EpiCenterDetailsResponse? epiCenterDetailsData;
  final bool isDropout;

  const SummaryCard({
    super.key,
    required this.epiCenterDetailsData,
    required this.isDropout,
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

    // Get filter state for selected year
    final filterState = ref.read(filterControllerProvider);
    final selectedYear = filterState.selectedYear;

    // Get yearly target from area.vaccineTarget
    final vaccineTarget = epiCenterDetailsData
        ?.area
        ?.vaccineTarget
        ?.child0To11Month[selectedYear];
    final yearlyTarget = vaccineTarget != null
        ? ((vaccineTarget.male?.toInt() ?? 0) +
              (vaccineTarget.female?.toInt() ?? 0))
        : 0;

    // Get dynamic vaccine names from API
    final vaccineNames =
        epiCenterDetailsData?.coverageTableData?.vaccineNames ?? [];

    // Calculate accumulated totals for all months
    Map<String, int> accumulatedVaccines = {};
    for (final vaccineName in vaccineNames) {
      accumulatedVaccines[vaccineName] = 0;
    }

    final currentMonth = DateTime.now().month;

    for (int monthIndex = 0; monthIndex < 12; monthIndex++) {
      final month = months[monthIndex];
      final monthNumber = monthIndex + 1;
      final isFutureMonth = monthNumber > currentMonth;

      if (isDropout) {
        // For dropout: calculate accumulated dropout
        if (!isFutureMonth) {
          final monthlyTarget = yearlyTarget > 0
              ? (yearlyTarget / 12).round()
              : 0;
          final coverageData =
              epiCenterDetailsData
                  ?.coverageTableData
                  ?.months[month]
                  ?.coverages ??
              {};

          for (final vaccineName in vaccineNames) {
            final dropout = math.max(
              0,
              monthlyTarget - (coverageData[vaccineName] ?? 0),
            );
            accumulatedVaccines[vaccineName] =
                (accumulatedVaccines[vaccineName] ?? 0) + dropout;
          }
        }
      } else {
        // For coverage: accumulate actual coverage
        final coverageData =
            epiCenterDetailsData?.coverageTableData?.months[month]?.coverages ??
            {};

        for (final vaccineName in vaccineNames) {
          accumulatedVaccines[vaccineName] =
              (accumulatedVaccines[vaccineName] ?? 0) +
              (coverageData[vaccineName] ?? 0);
        }
      }
    }

    final grandTotal = accumulatedVaccines.values.fold(
      0,
      (sum, value) => sum + value,
    );

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDropout
              ? [Colors.orange[50]!, Colors.orange[100]!]
              : [Colors.green[50]!, Colors.green[100]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDropout ? Colors.orange[300]! : Colors.green[300]!,
          width: 2,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Summary Header
            Row(
              children: [
                Icon(
                  isDropout ? Icons.summarize : Icons.analytics,
                  color: isDropout ? Colors.orange[800] : Colors.green[800],
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    isDropout
                        ? 'Total Dropout\n(All Months)'
                        : 'Total Coverage\n(All Months)',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: isDropout ? Colors.orange[800] : Colors.green[800],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Grand Total
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDropout ? Colors.orange[200] : Colors.green[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Text(
                    'Grand Total',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isDropout ? Colors.orange[800] : Colors.green[800],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    grandTotal.toString(),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isDropout ? Colors.orange[900] : Colors.green[900],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Vaccine Totals List
            Expanded(
              child: ListView(
                children: accumulatedVaccines.entries.map((entry) {
                  // Calculate percentage for coverage (not for dropout)
                  final percentage = !isDropout && yearlyTarget > 0
                      ? (entry.value / yearlyTarget * 100).toStringAsFixed(2)
                      : null;

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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Vaccine name
                        Text(
                          entry.key,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        // Total and percentage row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Total value
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: isDropout
                                    ? Colors.orange[100]
                                    : Colors.green[100],
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                entry.value.toString(),
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: isDropout
                                      ? Colors.orange[700]
                                      : Colors.green[700],
                                ),
                              ),
                            ),
                            // Percentage (only for coverage)
                            if (percentage != null)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.blue[100],
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  '$percentage%',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.blue[700],
                                  ),
                                ),
                              ),
                          ],
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
}
