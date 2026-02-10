import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../filter/presentation/controllers/filter_controller.dart';
import '../../domain/epi_center_details_response.dart';

/// Collection of coverage table widgets for EPI Center Details
class EpiCenterCoverageTablesWidget extends StatelessWidget {
  final EpiCenterDetailsResponse? epiCenterDetailsData;

  const EpiCenterCoverageTablesWidget({
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
            CoverageTableWidget(
              epiCenterDetailsData: epiCenterDetailsData,
              isDropout: isDropout,
            ),
          ],
        ),
      ),
    );
  }
}

class CoverageTableWidget extends ConsumerWidget {
  final EpiCenterDetailsResponse? epiCenterDetailsData;
  final bool isDropout;

  const CoverageTableWidget({
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

    final currentMonth = DateTime.now().month;

    // Prepare table data: List of rows, each row is a map of vaccine name to value
    List<Map<String, dynamic>> tableRows = [];

    // Calculate totals for each vaccine across all months
    Map<String, int> totalVaccines = {};
    for (final vaccineName in vaccineNames) {
      totalVaccines[vaccineName] = 0;
    }

    // Process each month
    for (int monthIndex = 0; monthIndex < 12; monthIndex++) {
      final month = months[monthIndex];
      final monthNumber = monthIndex + 1;
      final isFutureMonth = monthNumber > currentMonth;

      Map<String, int> monthData = {};

      if (isDropout) {
        // ✅ FIX: Use API dropout data directly instead of calculating
        if (isFutureMonth) {
          // Future months: show 0 for all dropouts
          for (final vaccineName in vaccineNames) {
            monthData[vaccineName] = 0;
          }
        } else {
          // Current & past months: use API dropout data
          final dropoutData =
              epiCenterDetailsData?.coverageTableData?.months[month]?.dropouts ??
              {};

          for (final vaccineName in vaccineNames) {
            final rawValue = dropoutData[vaccineName];
            int value = 0;
            if (rawValue is num) {
              value = rawValue.toInt();
            } else if (rawValue is String) {
              value = int.tryParse(rawValue) ?? 0;
            }

            monthData[vaccineName] = value;
            totalVaccines[vaccineName] =
                (totalVaccines[vaccineName] ?? 0) + value;
          }
        }
      } else {
        // For coverage: always show API data regardless of month
        final coverageData =
            epiCenterDetailsData?.coverageTableData?.months[month]?.coverages ??
            {};

        for (final vaccineName in vaccineNames) {
          final rawValue = coverageData[vaccineName];
          int value = 0;
          if (rawValue is num) {
            value = rawValue.toInt();
          } else if (rawValue is String) {
            value = int.tryParse(rawValue) ?? 0;
          }
          monthData[vaccineName] = value;
          totalVaccines[vaccineName] =
              (totalVaccines[vaccineName] ?? 0) + value;
        }
      }

      // Calculate row total
      final rowTotal = monthData.values.fold(0, (sum, value) => sum + value);
      monthData['_total'] = rowTotal;

      tableRows.add({
        'month': month,
        'data': monthData,
      });
    }

    // Calculate grand total (sum of all row totals)
    final grandTotal = tableRows.fold<int>(
      0,
      (sum, row) => sum + (row['data'] as Map<String, int>)['_total']!,
    );

    // Calculate total row
    final totalRowTotal = totalVaccines.values.fold(0, (sum, value) => sum + value);
    totalVaccines['_total'] = totalRowTotal;

    // Calculate cumulative coverage percentages (only for coverage, not dropout)
    Map<String, double> cumulativeCoverage = {};
    if (!isDropout && yearlyTarget > 0) {
      for (final vaccineName in vaccineNames) {
        final total = totalVaccines[vaccineName] ?? 0;
        cumulativeCoverage[vaccineName] = (total / yearlyTarget * 100);
      }
      // Calculate total percentage (grand total / yearly target * 100)
      cumulativeCoverage['_total'] = (grandTotal / yearlyTarget * 100);
    }

    // Build table using DataTable
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        headingRowColor: WidgetStateProperty.all<Color>(Colors.blue[600]!),
        dataRowMinHeight: 40,
        dataRowMaxHeight: 40,
        columnSpacing: 80,
        columns: [
          const DataColumn(
            label: Text(
              'Month',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          ...vaccineNames.map((vaccineName) => DataColumn(
                label: Text(
                  vaccineName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              )),
          const DataColumn(
            label: Text(
              'Total',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
        rows: [
          // Monthly data rows
          ...tableRows.map((row) {
            final month = row['month'] as String;
            final data = row['data'] as Map<String, int>;
            return DataRow(
              cells: [
                DataCell(
                  Text(
                    month,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
                ...vaccineNames.map((vaccineName) => DataCell(
                      Text(
                        (data[vaccineName] ?? 0).toString(),
                        textAlign: TextAlign.center,
                      ),
                    )),
                DataCell(
                  Text(
                    (data['_total'] ?? 0).toString(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            );
          }),
          // Total row
          DataRow(
            color: WidgetStateProperty.all<Color>(Colors.grey[100]!),
            cells: [
              const DataCell(
                Text(
                  'Total',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              ...vaccineNames.map((vaccineName) => DataCell(
                    Text(
                      (totalVaccines[vaccineName] ?? 0).toString(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  )),
              DataCell(
                Text(
                  totalRowTotal.toString(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          // Cumulative Coverage (%) row (only for coverage, not dropout)
          if (!isDropout && yearlyTarget > 0)
            DataRow(
              color: WidgetStateProperty.all<Color>(Colors.grey[50]!),
              cells: [
                const DataCell(
                  Text(
                    'Cumulative Coverage (%)',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
                ...vaccineNames.map((vaccineName) => DataCell(
                      Text(
                        cumulativeCoverage[vaccineName] != null
                            ? cumulativeCoverage[vaccineName]!
                                .toStringAsFixed(2)
                            : '0.00',
                        textAlign: TextAlign.center,
                      ),
                    )),
                DataCell(
                  Text(
                    cumulativeCoverage['_total'] != null
                        ? cumulativeCoverage['_total']!.toStringAsFixed(2)
                        : '',
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
