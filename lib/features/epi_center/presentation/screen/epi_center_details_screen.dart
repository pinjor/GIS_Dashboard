import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../core/common/widgets/custom_loading_widget.dart';
import '../controllers/epi_center_controller.dart';
import '../../../filter/presentation/controllers/filter_controller.dart';

class EpiCenterDetailsScreen extends ConsumerStatefulWidget {
  final String epiUid;
  final String epiCenterName;
  final String? ccUid; // City Corporation UID - optional
  final String? currentLevel; // Current map level context

  const EpiCenterDetailsScreen({
    super.key,
    required this.epiUid,
    required this.epiCenterName,
    this.ccUid,
    this.currentLevel,
  });

  @override
  ConsumerState<EpiCenterDetailsScreen> createState() =>
      _EpiCenterDetailsScreenState();
}

class _EpiCenterDetailsScreenState
    extends ConsumerState<EpiCenterDetailsScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch data when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final currentFilter = ref.read(filterControllerProvider);
      ref
          .read(epiCenterControllerProvider.notifier)
          .fetchEpiCenterData(
            epiUid: widget.epiUid,
            year: int.tryParse(currentFilter.selectedYear) ?? 2025,
            ccUid: widget.ccUid,
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    final epiState = ref.watch(epiCenterControllerProvider);
    // final filterState = ref.watch(filterControllerProvider);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.epiCenterName,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            if (widget.currentLevel != null)
              Text(
                'EPI Center Details',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.normal,
                ),
              ),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 2,
        // actions: [
        //   // Year selector
        //   Container(
        //     margin: const EdgeInsets.only(right: 16),
        //     child: Center(
        //       child: Container(
        //         padding: const EdgeInsets.symmetric(
        //           horizontal: 12,
        //           vertical: 6,
        //         ),
        //         decoration: BoxDecoration(
        //           color: Colors.blue[50],
        //           borderRadius: BorderRadius.circular(20),
        //           border: Border.all(color: Colors.blue[200]!),
        //         ),
        //         child: DropdownButtonHideUnderline(
        //           child: DropdownButton<int>(
        //             value: int.tryParse(filterState.selectedYear) ?? 2025,
        //             isDense: true,
        //             style: TextStyle(
        //               color: Colors.blue[700],
        //               fontWeight: FontWeight.w600,
        //               fontSize: 14,
        //             ),
        //             items: [2024, 2025].map((year) {
        //               return DropdownMenuItem<int>(
        //                 value: year,
        //                 child: Text(year.toString()),
        //               );
        //             }).toList(),
        //             onChanged: (newYear) {
        //               if (newYear != null) {
        //                 ref
        //                     .read(filterControllerProvider.notifier)
        //                     .updateYear(newYear.toString());
        //                 ref
        //                     .read(epiCenterControllerProvider.notifier)
        //                     .updateYear(newYear);
        //               }
        //             },
        //           ),
        //         ),
        //       ),
        //     ),
        //   ),
        // ],
      ),
      body: epiState.isLoading
          ? const Center(child: CustomLoadingWidget(
            loadingText: 'Loading EPI Center data...',
          ))
          : epiState.hasError || epiState.epiCenterData == null
          ? _buildNoDataState()
          : _buildContent(epiState.epiCenterData!),
    );
  }

  /// Build beautiful no-data state with empty tables and charts
  Widget _buildNoDataState() {
    final epiState = ref.watch(epiCenterControllerProvider);
    final filterState = ref.watch(filterControllerProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Info banner about no data
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.amber[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.amber[200]!),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Colors.amber[700], size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'No Data Available',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.amber[800],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        epiState.errorMessage ??
                            'No vaccination data is available for this EPI center in ${filterState.selectedYear}. This may be due to ongoing data collection or the center being newly established.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.amber[700],
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // EPI Center Information Card
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.local_hospital_outlined,
                        color: Colors.blue[600],
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'EPI Center Information',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildInfoRow('Center ID', widget.epiUid),
                  _buildInfoRow('Center Name', widget.epiCenterName),
                  _buildInfoRow('Year', filterState.selectedYear),
                  if (widget.ccUid != null)
                    _buildInfoRow('Context', 'City Corporation'),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Empty Microplan Section
          _buildEmptyMicroplanSection(),

          const SizedBox(height: 24),

          // Empty Coverage Tables
          _buildEmptyCoverageTables(),

          const SizedBox(height: 24),

          // Empty Chart Section
          _buildEmptyChartSection(),

        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyMicroplanSection() {
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
                  Icons.table_chart_outlined,
                  color: Colors.grey[600],
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Microplan',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildEmptyTable(
              headers: ['Category', 'Male', 'Female', 'Total'],
              rows: [
                ['Total Population', '-', '-', '-'],
                ['Child (0-11)', '-', '-', '-'],
                ['Child (0-15)', '-', '-', '-'],
                ['Women 15-49 years', '-', '-', '-'],
              ],
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                'Population data will appear here when available',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[500],
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyCoverageTables() {
    return Column(
      children: [
        // Coverage table
        Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.analytics_outlined,
                      color: Colors.grey[600],
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Cumulative Coverage (%)',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildEmptyDataTable(),
                const SizedBox(height: 8),
                Center(
                  child: Text(
                    'Vaccination coverage data will appear here when available',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[500],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Dropout table
        Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.trending_down_outlined,
                      color: Colors.grey[600],
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Cumulative Dropouts',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildEmptyDataTable(),
                const SizedBox(height: 8),
                Center(
                  child: Text(
                    'Dropout data will appear here when available',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[500],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyChartSection() {
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
                  Icons.show_chart_outlined,
                  color: Colors.grey[600],
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Monthly Vaccine Coverage vs Target',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Container(
              height: 300,
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.timeline_outlined,
                      size: 64,
                      color: Colors.grey[300],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Chart will appear here',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[500],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Vaccination trends and targets will be visualized when data is available',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12, color: Colors.grey[400]),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildEmptyChartLegend(),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyTable({
    required List<String> headers,
    required List<List<String>> rows,
  }) {
    return Table(
      border: TableBorder.all(color: Colors.grey[300]!),
      children: [
        // Header
        TableRow(
          decoration: BoxDecoration(color: Colors.grey[100]),
          children: headers.map((header) {
            return Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                header,
                style: const TextStyle(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            );
          }).toList(),
        ),
        // Rows
        ...rows.map((row) {
          return TableRow(
            children: row.map((cell) {
              return Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  cell,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey[500]),
                ),
              );
            }).toList(),
          );
        }),
      ],
    );
  }

  Widget _buildEmptyDataTable() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        headingRowColor: WidgetStateProperty.all(Colors.grey[100]),
        columns:
            [
              'Month',
              'Penta - 1st',
              'Penta - 2nd',
              'Penta - 3rd',
              'MR - 1st',
              'MR - 2nd',
              'BCG',
              'Total',
            ].map((header) {
              return DataColumn(
                label: Text(
                  header,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              );
            }).toList(),
        rows:
            [
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
            ].map((month) {
              return DataRow(
                cells: [
                  DataCell(Text(month)),
                  ...List.generate(
                    7,
                    (index) => DataCell(
                      Text('-', style: TextStyle(color: Colors.grey[400])),
                    ),
                  ),
                ],
              );
            }).toList(),
      ),
    );
  }

  Widget _buildEmptyChartLegend() {
    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children:
          [
            'Monthly Target',
            'Penta - 1st',
            'Penta - 2nd',
            'Penta - 3rd',
            'MR - 1st',
            'MR - 2nd',
            'BCG',
          ].map((label) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(width: 20, height: 2, color: Colors.grey[300]),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                ),
              ],
            );
          }).toList(),
    );
  }


  Widget _buildContent(dynamic epiCenterData) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Location breadcrumb (if available)
          if (epiCenterData.divisionName != null ||
              epiCenterData.districtName != null ||
              epiCenterData.upazilaName != null)
            _buildLocationBreadcrumb(epiCenterData),

          const SizedBox(height: 16),

          // Filter information (for city corporation context)
          if (widget.ccUid != null) _buildCityCorporationInfo(epiCenterData),

          // Microplan section
          _buildMicroplanSection(epiCenterData),

          const SizedBox(height: 24),

          // Coverage tables
          if (epiCenterData.coverageTableData != null)
            _buildCoverageTables(epiCenterData.coverageTableData),

          const SizedBox(height: 24),

          // Chart section
          if (epiCenterData.chartData != null)
            _buildChartSection(epiCenterData.chartData),

          const SizedBox(height: 24),

          // EPI Center Information
          _buildEpiCenterInfo(epiCenterData),
        ],
      ),
    );
  }

  Widget _buildLocationBreadcrumb(dynamic epiData) {
    final breadcrumbs = <String>[];

    if (epiData.divisionName != null && epiData.divisionName.isNotEmpty) {
      breadcrumbs.add(epiData.divisionName);
    }
    if (epiData.districtName != null && epiData.districtName.isNotEmpty) {
      breadcrumbs.add(epiData.districtName);
    }
    if (epiData.upazilaName != null && epiData.upazilaName.isNotEmpty) {
      breadcrumbs.add(epiData.upazilaName);
    }
    if (epiData.unionName != null && epiData.unionName.isNotEmpty) {
      breadcrumbs.add(epiData.unionName);
    }
    if (epiData.wardName != null && epiData.wardName.isNotEmpty) {
      breadcrumbs.add(epiData.wardName);
    }

    if (breadcrumbs.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: Row(
        children: [
          Icon(Icons.location_on, color: Colors.blue[600], size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              breadcrumbs.join(' / '),
              style: TextStyle(
                color: Colors.blue[700],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCityCorporationInfo(dynamic epiData) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.orange[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.location_city, color: Colors.orange[600]),
              const SizedBox(width: 8),
              Text(
                'City Corporation Context',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange[700],
                ),
              ),
            ],
          ),
          if (epiData.cityCorporationName != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                epiData.cityCorporationName,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMicroplanSection(dynamic epiData) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Microplan',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildMicroplanTable(),
          ],
        ),
      ),
    );
  }

  Widget _buildMicroplanTable() {
    // TODO: Parse the actual microplan data from API response
    // For now, using sample data structure
    return Table(
      border: TableBorder.all(color: Colors.grey[300]!),
      columnWidths: const {
        0: FlexColumnWidth(2),
        1: FlexColumnWidth(1),
        2: FlexColumnWidth(1),
        3: FlexColumnWidth(1),
      },
      children: [
        // Header
        TableRow(
          decoration: BoxDecoration(color: Colors.grey[100]),
          children: const [
            Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                'Category',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                'Male',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                'Female',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                'Total',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        // Data rows from API response (when available)
        _buildTableRow('Total Population', '415', '413', '828'),
        _buildTableRow('Child (0-11)', '13', '10', '23'),
        _buildTableRow('Child (0-15)', '-', '-', '-'),
        _buildTableRow('Women 15-49 years', '-', '254', '254'),
      ],
    );
  }

  TableRow _buildTableRow(
    String category,
    String male,
    String female,
    String total,
  ) {
    return TableRow(
      children: [
        Padding(padding: const EdgeInsets.all(8), child: Text(category)),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Text(male, textAlign: TextAlign.center),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Text(female, textAlign: TextAlign.center),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Text(total, textAlign: TextAlign.center),
        ),
      ],
    );
  }

  Widget _buildCoverageTables(dynamic coverageData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Coverage table
        Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Cumulative Coverage (%)',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                _buildCoverageTable(coverageData, false),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Dropout table
        Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Cumulative Dropouts',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                _buildCoverageTable(coverageData, true),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCoverageTable(dynamic coverageData, bool isDropout) {
    // This should parse the actual coverage data structure
    // For now, creating a sample table based on web interface
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const [
          DataColumn(
            label: Text('Month', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          DataColumn(
            label: Text(
              'Penta - 1st',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          DataColumn(
            label: Text(
              'Penta - 2nd',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          DataColumn(
            label: Text(
              'Penta - 3rd',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          DataColumn(
            label: Text(
              'MR - 1st',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          DataColumn(
            label: Text(
              'MR - 2nd',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          DataColumn(
            label: Text('BCG', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          DataColumn(
            label: Text('Total', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
        rows: _buildCoverageRows(coverageData, isDropout),
      ),
    );
  }

  List<DataRow> _buildCoverageRows(dynamic coverageData, bool isDropout) {
    // Parse actual data from API response
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

    return months.map((month) {
      // Try to get actual data from API response
      Map<String, dynamic>? monthData;
      if (coverageData is Map<String, dynamic> &&
          coverageData['months'] is Map<String, dynamic>) {
        monthData = coverageData['months'][month];
      }

      // Extract data for the month
      String dataType = isDropout ? 'dropouts' : 'coverages';
      Map<String, dynamic>? values = monthData?[dataType];

      return DataRow(
        cells: [
          DataCell(Text(month)),
          DataCell(Text(values?['Penta - 1st']?.toString() ?? '0')),
          DataCell(Text(values?['Penta - 2nd']?.toString() ?? '0')),
          DataCell(Text(values?['Penta - 3rd']?.toString() ?? '0')),
          DataCell(Text(values?['MR - 1st']?.toString() ?? '0')),
          DataCell(Text(values?['MR - 2nd']?.toString() ?? '0')),
          DataCell(Text(values?['BCG']?.toString() ?? '0')),
          DataCell(Text(_calculateMonthTotal(values).toString())),
        ],
      );
    }).toList();
  }

  int _calculateMonthTotal(Map<String, dynamic>? values) {
    if (values == null) return 0;
    int total = 0;
    values.forEach((key, value) {
      if (value is int) total += value;
      if (value is String) {
        int? parsed = int.tryParse(value);
        if (parsed != null) total += parsed;
      }
    });
    return total;
  }

  Widget _buildChartSection(dynamic chartData) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Monthly Vaccine Coverage vs Target',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 300,
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(show: true),
                  titlesData: FlTitlesData(
                    leftTitles: const AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
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
                          if (value.toInt() >= 0 &&
                              value.toInt() < months.length) {
                            return Text(months[value.toInt()]);
                          }
                          return const Text('');
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: true),
                  lineBarsData: _buildChartLines(),
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildChartLegend(),
          ],
        ),
      ),
    );
  }

  List<LineChartBarData> _buildChartLines() {
    // Sample chart data - should be from API response
    return [
      // Monthly Target (dashed line)
      LineChartBarData(
        spots: List.generate(12, (index) => FlSpot(index.toDouble(), 8)),
        isCurved: false,
        color: Colors.red,
        barWidth: 2,
        dashArray: [5, 5],
        dotData: const FlDotData(show: false),
      ),
      // Penta - 1st
      LineChartBarData(
        spots: [
          const FlSpot(0, 0),
          const FlSpot(1, 14),
          const FlSpot(2, 0),
          const FlSpot(3, 15),
          const FlSpot(4, 10),
          const FlSpot(5, 0),
          const FlSpot(6, 0),
          const FlSpot(7, 0),
          const FlSpot(8, 0),
          const FlSpot(9, 0),
          const FlSpot(10, 0),
          const FlSpot(11, 0),
        ],
        isCurved: true,
        color: Colors.blue,
        barWidth: 2,
        dotData: const FlDotData(show: true),
      ),
      // Add more lines for other vaccines...
    ];
  }

  Widget _buildChartLegend() {
    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: [
        _buildLegendItem('Monthly Target', Colors.red, isDashed: true),
        _buildLegendItem('Penta - 1st', Colors.blue),
        _buildLegendItem('Penta - 2nd', Colors.green),
        _buildLegendItem('Penta - 3rd', Colors.cyan),
        _buildLegendItem('MR - 1st', Colors.orange),
        _buildLegendItem('MR - 2nd', Colors.red),
        _buildLegendItem('BCG', Colors.grey),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color, {bool isDashed = false}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 20,
          height: 2,
          decoration: BoxDecoration(
            color: color,
            border: isDashed ? Border.all(color: color) : null,
          ),
          child: isDashed
              ? SizedBox(
                  width: 20,
                  height: 2,
                  child: CustomPaint(painter: DashedLinePainter(color: color)),
                )
              : null,
        ),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildEpiCenterInfo(dynamic epiData) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Name and Address of EPI Center',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildInfoTable(),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTable() {
    return Table(
      border: TableBorder.all(color: Colors.grey[300]!),
      columnWidths: const {
        0: FlexColumnWidth(2),
        1: FlexColumnWidth(2),
        2: FlexColumnWidth(1),
        3: FlexColumnWidth(1),
        4: FlexColumnWidth(1),
        5: FlexColumnWidth(1),
        6: FlexColumnWidth(1),
        7: FlexColumnWidth(1),
      },
      children: [
        // Header
        TableRow(
          decoration: BoxDecoration(color: Colors.grey[100]),
          children: const [
            Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                'Name and Address',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                'Implementer',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                'Distance',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                'Transport',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                'Time',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                'Porter Name',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                'Phone',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                'Type',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        // Sample data row
        TableRow(
          children: [
            const Padding(
              padding: EdgeInsets.all(8),
              child: Text('Dr. khalak,Tangggtipara'),
            ),
            const Padding(padding: EdgeInsets.all(8), child: Text('-')),
            const Padding(padding: EdgeInsets.all(8), child: Text('-')),
            const Padding(
              padding: EdgeInsets.all(8),
              child: Text('রিকশা (Rickshaw)'),
            ),
            const Padding(padding: EdgeInsets.all(8), child: Text('60')),
            const Padding(
              padding: EdgeInsets.all(8),
              child: Text('Abdul Alim'),
            ),
            const Padding(padding: EdgeInsets.all(8), child: Text('-')),
            const Padding(
              padding: EdgeInsets.all(8),
              child: Text('Outreach Center'),
            ),
          ],
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
