import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../core/common/widgets/custom_loading_widget.dart';
import '../../../../config/coverage_colors.dart';
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
      ),
      body: epiState.isLoading
          ? const Center(child: CustomLoadingWidget())
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

          const SizedBox(height: 24),

          // Retry Actions
          _buildRetrySection(),
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
                Icon(Icons.groups, color: Colors.grey[600], size: 20),
                const SizedBox(width: 8),
                Text(
                  'Population Microplan',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Empty population overview cards
            Row(
              children: [
                Expanded(
                  child: _buildEmptyPopulationCard(
                    'Total Population',
                    Icons.people,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildEmptyPopulationCard(
                    'Target Children',
                    Icons.child_care,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Empty category cards
            ...[
              'Total Population',
              'Child (0-11)',
              'Child (0-15)',
              'Women 15-49 years',
            ].map((category) => _buildEmptyPopulationDetailCard(category)),

            const SizedBox(height: 12),
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Population data will appear here when available',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyPopulationCard(String title, IconData icon) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [Colors.grey[300]!, Colors.grey[200]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.grey[500], size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '-',
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'No data available',
              style: TextStyle(color: Colors.grey[500], fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyPopulationDetailCard(String category) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              width: 4,
              height: 16,
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                category,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '-',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[500],
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

  Widget _buildRetrySection() {
    final filterState = ref.watch(filterControllerProvider);

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Need help?',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Try selecting a different year or refresh the data. If the problem persists, contact your system administrator.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                height: 1.4,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton.icon(
                  onPressed: () {
                    ref
                        .read(epiCenterControllerProvider.notifier)
                        .fetchEpiCenterData(
                          epiUid: widget.epiUid,
                          year: int.tryParse(filterState.selectedYear) ?? 2025,
                          ccUid: widget.ccUid,
                        );
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Refresh Data'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.blue[600],
                    side: BorderSide(color: Colors.blue[200]!),
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Go Back'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[600],
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
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

          // Coverage tables - always show, use available data or zeros
          _buildCoverageTables(
            epiCenterData.coverageTableData ?? {},
            epiCenterData,
          ),

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
            _buildMicroplanTable(epiData),
          ],
        ),
      ),
    );
  }

  Widget _buildMicroplanTable(dynamic epiData) {
    // Extract target data from area.parsedVaccineTarget
    Map<String, dynamic>? targetData;
    if (epiData?.area?.parsedVaccineTarget != null) {
      targetData = epiData.area.parsedVaccineTarget;
    }

    // Get the current year from filter
    final filterState = ref.read(filterControllerProvider);
    final currentYear = filterState.selectedYear;

    // Extract child data for current year from the complex JSON structure
    Map<String, dynamic>? childData;
    if (targetData != null &&
        targetData['child_0_to_11_month'] != null &&
        targetData['child_0_to_11_month'][currentYear] != null) {
      childData = targetData['child_0_to_11_month'][currentYear];
    }

    // Parse population data from API or use empty values
    final populationData = [
      {
        'category': 'Total Population',
        'male': _getPopulationValue(epiData, 'total', 'male') ?? '-',
        'female': _getPopulationValue(epiData, 'total', 'female') ?? '-',
        'total': _getPopulationValue(epiData, 'total', 'total') ?? '-',
      },
      {
        'category': 'Child (0-11)',
        'male': childData?['male']?.toString() ?? '-',
        'female': childData?['female']?.toString() ?? '-',
        'total': _calculateChildTotal(childData) ?? '-',
      },
      {
        'category': 'Child (0-15)',
        'male': _getPopulationValue(epiData, 'child_0_15', 'male') ?? '-',
        'female': _getPopulationValue(epiData, 'child_0_15', 'female') ?? '-',
        'total': _getPopulationValue(epiData, 'child_0_15', 'total') ?? '-',
      },
      {
        'category': 'Women 15-49 years',
        'male': '-', // Always '-' for women category
        'female': _getPopulationValue(epiData, 'women_15_49', 'female') ?? '-',
        'total': _getPopulationValue(epiData, 'women_15_49', 'total') ?? '-',
      },
    ];

    // Calculate totals from available data
    final totalPopulation = _calculateTotal(populationData[0]);
    final targetChildren = _calculateTotal(populationData[1]);

    return Column(
      children: [
        // Population overview cards with proper constraints
        Row(
          children: [
            Expanded(
              child: _buildPopulationSummaryCard(
                totalPopulation,
                populationData[0]['male']!,
                populationData[0]['female']!,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(child: _buildTargetGroupCard(targetChildren)),
          ],
        ),

        const SizedBox(height: 16),

        // Detailed population breakdown
        ...populationData.map(
          (data) => _buildPopulationCard(
            category: data['category']!,
            male: data['male']!,
            female: data['female']!,
            total: data['total']!,
            totalPopulation: totalPopulation,
          ),
        ),
      ],
    );
  }

  // Helper method to get population values from the API response
  String? _getPopulationValue(dynamic epiData, String category, String field) {
    // Since the API doesn't provide total population breakdown by gender,
    // we'll try to extract from various possible sources
    if (epiData?.area?.parent?.parsedVaccineTarget != null) {
      var parentData = epiData.area.parent.parsedVaccineTarget;
      // Check for population data in parent area
      var categoryData = parentData[category];
      if (categoryData is Map<String, dynamic>) {
        final filterState = ref.read(filterControllerProvider);
        final currentYear = filterState.selectedYear;
        var yearData = categoryData[currentYear];
        if (yearData is Map<String, dynamic>) {
          return yearData[field]?.toString();
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
        final male = int.tryParse(maleStr) ?? 0;
        final female = int.tryParse(femaleStr) ?? 0;
        return male + female;
      }
      return 0;
    }
    return int.tryParse(totalStr) ?? 0;
  }

  Widget _buildPopulationSummaryCard(int totalPop, String male, String female) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [Colors.blue[600]!, Colors.blue[400]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Icon(Icons.people, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Total Population',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              totalPop > 0 ? '$totalPop' : '-',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              (male != '-' && female != '-')
                  ? '$male Male • $female Female'
                  : 'No data available',
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 10,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTargetGroupCard(int targetCount) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [Colors.green[600]!, Colors.green[400]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Icon(Icons.child_care, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Target Children',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              targetCount > 0 ? '$targetCount' : '-',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Children (0-11 years)',
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 10,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPopulationCard({
    required String category,
    required String male,
    required String female,
    required String total,
    required int totalPopulation,
  }) {
    // Calculate progress percentage for visual indicator
    double progress = 0.0;
    if (total != '-' && total.isNotEmpty && totalPopulation > 0) {
      int totalNum = int.tryParse(total) ?? 0;
      progress = (totalNum / totalPopulation.toDouble()).clamp(0.0, 1.0);
    }

    Color categoryColor = _getCategoryColor(category);

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 4,
                  height: 20,
                  decoration: BoxDecoration(
                    color: categoryColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    category,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: categoryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    total,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: categoryColor,
                    ),
                  ),
                ),
              ],
            ),
            if (total != '-' && male != '-' && female != '-') ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildGenderInfo('Male', male, Colors.blue[600]!),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildGenderInfo(
                      'Female',
                      female,
                      Colors.pink[600]!,
                    ),
                  ),
                ],
              ),
              if (progress > 0 && totalPopulation > 0) ...[
                const SizedBox(height: 12),
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation<Color>(categoryColor),
                  minHeight: 4,
                ),
                const SizedBox(height: 4),
                Text(
                  '${(progress * 100).toStringAsFixed(1)}% of total population',
                  style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                ),
              ],
            ] else ...[
              const SizedBox(height: 8),
              Text(
                'Data not available',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[500],
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildGenderInfo(String gender, String count, Color color) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Text(gender, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        const Spacer(),
        Text(
          count,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'total population':
        return Colors.blue[600]!;
      case 'child (0-11)':
        return Colors.green[600]!;
      case 'child (0-15)':
        return Colors.orange[600]!;
      case 'women 15-49 years':
        return Colors.purple[600]!;
      default:
        return Colors.grey[600]!;
    }
  }

  Widget _buildCoverageTables(dynamic coverageData, dynamic epiCenterData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Coverage section with horizontal cards
        _buildCoverageSection(coverageData, false, epiCenterData),

        const SizedBox(height: 24),

        // Dropout section with horizontal cards
        _buildCoverageSection(coverageData, true, epiCenterData),
      ],
    );
  }

  Widget _buildCoverageSection(
    dynamic coverageData,
    bool isDropout,
    dynamic epiCenterData,
  ) {
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
                  isDropout
                      ? Icons.trending_down_outlined
                      : Icons.analytics_outlined,
                  color: isDropout ? Colors.red[600] : Colors.green[600],
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  isDropout ? 'Cumulative Dropouts' : 'Cumulative Coverage (%)',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDropout ? Colors.red[800] : Colors.green[800],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 235,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 12,
                itemBuilder: (context, index) {
                  return _buildMonthlyCard(epiCenterData, index, isDropout);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthlyCard(
    dynamic coverageData,
    int monthIndex,
    bool isDropout,
  ) {
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

    // If no coverage data available from coverageTableData, extract from area's parsed vaccine coverage
    if (values == null && !isDropout) {
      // Get current year from filter
      final filterState = ref.read(filterControllerProvider);
      final currentYear = filterState.selectedYear;

      // Try to get coverage data from epiCenterData.area.parsedVaccineCoverage
      final epiCenterData =
          coverageData; // This is the full epiCenterData object
      if (epiCenterData?.area?.parsedVaccineCoverage != null) {
        final coverageByYear = epiCenterData.area.parsedVaccineCoverage;

        // Navigate to the monthly data structure
        if (coverageByYear is Map<String, dynamic> &&
            coverageByYear['child_0_to_11_month'] != null &&
            coverageByYear['child_0_to_11_month'][currentYear] != null) {
          final yearData = coverageByYear['child_0_to_11_month'][currentYear];

          // First try to get monthly data
          if (yearData['months'] != null) {
            final monthsData = yearData['months'];
            final monthNumber = (monthIndex + 1)
                .toString(); // Convert 0-based index to 1-based month

            if (monthsData[monthNumber] != null &&
                monthsData[monthNumber]['vaccine'] != null) {
              final vaccineArray =
                  monthsData[monthNumber]['vaccine'] as List<dynamic>;

              // Convert vaccine array to a map for easier access
              values = {};
              for (var vaccineData in vaccineArray) {
                if (vaccineData is Map<String, dynamic>) {
                  final vaccineName = vaccineData['vaccine_name']?.toString();
                  final male = vaccineData['male'];
                  final female = vaccineData['female'];

                  if (vaccineName != null) {
                    // Calculate total from male + female (handle null values)
                    int total = 0;
                    if (male != null && male is! bool) {
                      total += (male is int
                          ? male
                          : int.tryParse(male.toString()) ?? 0);
                    }
                    if (female != null && female is! bool) {
                      total += (female is int
                          ? female
                          : int.tryParse(female.toString()) ?? 0);
                    }

                    values[vaccineName] = total;
                  }
                }
              }
            }
          }

          // If no monthly data, try to get cumulative data up to this month
          if ((values == null || values.isEmpty)) {
            // Get cumulative data for better representation
            values = _calculateCumulativeDataUpToMonth(
              epiCenterData,
              monthIndex,
              currentYear,
            );
          }

          // If still no data, try to get total data from the year as last resort
          if ((values == null || values.isEmpty) &&
              yearData['vaccine'] != null) {
            final vaccineArray = yearData['vaccine'] as List<dynamic>;

            // Convert vaccine array to a map for easier access
            values = {};
            for (var vaccineData in vaccineArray) {
              if (vaccineData is Map<String, dynamic>) {
                final vaccineName = vaccineData['vaccine_name']?.toString();
                final male = vaccineData['male'];
                final female = vaccineData['female'];

                if (vaccineName != null) {
                  // Calculate total from male + female (handle null values)
                  int total = 0;
                  if (male != null && male is! bool) {
                    total += (male is int
                        ? male
                        : int.tryParse(male.toString()) ?? 0);
                  }
                  if (female != null && female is! bool) {
                    total += (female is int
                        ? female
                        : int.tryParse(female.toString()) ?? 0);
                  }

                  // For annual display, show the total divided by 12 months as an approximation
                  // This is not ideal, but gives us some data to show
                  values[vaccineName] = (total / 12).round();
                }
              }
            }
          }
        }
      }
    }

    // Use actual data if available, otherwise show zeros
    final vaccines = {
      'Penta - 1st':
          values?['Penta - 1st']?.toString() ??
          values?['penta_1']?.toString() ??
          values?['penta1']?.toString() ??
          '0',
      'Penta - 2nd':
          values?['Penta - 2nd']?.toString() ??
          values?['penta_2']?.toString() ??
          values?['penta2']?.toString() ??
          '0',
      'Penta - 3rd':
          values?['Penta - 3rd']?.toString() ??
          values?['penta_3']?.toString() ??
          values?['penta3']?.toString() ??
          '0',
      'MR - 1st':
          values?['MR - 1st']?.toString() ??
          values?['mr_1']?.toString() ??
          values?['mr1']?.toString() ??
          '0',
      'MR - 2nd':
          values?['MR - 2nd']?.toString() ??
          values?['mr_2']?.toString() ??
          values?['mr2']?.toString() ??
          '0',
      'BCG': values?['BCG']?.toString() ?? values?['bcg']?.toString() ?? '0',
    };

    final total = _calculateMonthTotal(values);
    final averagePerformance = _calculateAveragePerformance(vaccines);

    return Container(
      width: 280,
      margin: const EdgeInsets.only(right: 12),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Month header with performance indicator
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    month.substring(0, 3),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getPerformanceColor(
                        averagePerformance,
                      ).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      isDropout
                          ? '$total'
                          : '${averagePerformance.toStringAsFixed(1)}%',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: _getPerformanceColor(averagePerformance),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Vaccine list
              Expanded(
                child: Column(
                  children: vaccines.entries.map((entry) {
                    final value = double.tryParse(entry.value) ?? 0;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Text(
                              entry.key.replaceAll(' - ', '-'),
                              style: const TextStyle(fontSize: 11),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              isDropout
                                  ? '${value.toInt()}'
                                  : '${value.toInt()}%',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: _getPerformanceColor(value),
                              ),
                              textAlign: TextAlign.right,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: _getPerformanceColor(value),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),

              // Total summary
              const Divider(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                    ),
                  ),
                  Text(
                    isDropout
                        ? '$total children'
                        : '${averagePerformance.toStringAsFixed(1)}% avg',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Calculate cumulative data up to the current month by summing monthly data
  Map<String, dynamic>? _calculateCumulativeDataUpToMonth(
    dynamic epiCenterData,
    int monthIndex,
    String currentYear,
  ) {
    if (epiCenterData?.area?.parsedVaccineCoverage == null) return null;

    final coverageByYear = epiCenterData.area.parsedVaccineCoverage;

    if (coverageByYear is Map<String, dynamic> &&
        coverageByYear['child_0_to_11_month'] != null &&
        coverageByYear['child_0_to_11_month'][currentYear] != null &&
        coverageByYear['child_0_to_11_month'][currentYear]['months'] != null) {
      final monthsData =
          coverageByYear['child_0_to_11_month'][currentYear]['months'];

      // Sum up data from month 1 to current month (monthIndex + 1)
      Map<String, int> cumulativeTotals = {};

      for (int i = 1; i <= (monthIndex + 1); i++) {
        final monthNumber = i.toString();

        if (monthsData[monthNumber] != null &&
            monthsData[monthNumber]['vaccine'] != null) {
          final vaccineArray =
              monthsData[monthNumber]['vaccine'] as List<dynamic>;

          for (var vaccineData in vaccineArray) {
            if (vaccineData is Map<String, dynamic>) {
              final vaccineName = vaccineData['vaccine_name']?.toString();
              final male = vaccineData['male'];
              final female = vaccineData['female'];

              if (vaccineName != null) {
                // Calculate total from male + female (handle null values)
                int monthTotal = 0;
                if (male != null && male is! bool) {
                  monthTotal += (male is int
                      ? male
                      : int.tryParse(male.toString()) ?? 0);
                }
                if (female != null && female is! bool) {
                  monthTotal += (female is int
                      ? female
                      : int.tryParse(female.toString()) ?? 0);
                }

                cumulativeTotals[vaccineName] =
                    (cumulativeTotals[vaccineName] ?? 0) + monthTotal;
              }
            }
          }
        }
      }

      // Convert to Map<String, dynamic> for compatibility
      return cumulativeTotals.map((key, value) => MapEntry(key, value));
    }

    return null;
  }

  Color _getPerformanceColor(double value) {
    return CoverageColors.getCoverageColor(value);
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(
                  Icons.local_hospital_outlined,
                  color: Colors.blue[600],
                  size: 24,
                ),
                const SizedBox(width: 8),
                const Text(
                  'EPI Center Information',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Information cards in a grid
        _buildEpiInfoCards(),
      ],
    );
  }

  Widget _buildEpiInfoCards() {
    return Column(
      children: [
        // First row of cards
        Row(
          children: [
            Expanded(child: _buildLocationInfoCard()),
            const SizedBox(width: 12),
            Expanded(child: _buildContactInfoCard()),
          ],
        ),

        const SizedBox(height: 12),

        // Second row of cards
        Row(
          children: [
            Expanded(child: _buildTransportInfoCard()),
            const SizedBox(width: 12),
            Expanded(child: _buildCenterTypeCard()),
          ],
        ),
      ],
    );
  }

  Widget _buildLocationInfoCard() {
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
                  Icons.location_on_outlined,
                  color: Colors.green[600],
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Location',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[700],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildInfoItem('Name', 'Dr. khalak,Tangggtipara'),
            _buildInfoItem('Distance', 'Not specified'),
            _buildInfoItem('Implementer', 'Not available'),
          ],
        ),
      ),
    );
  }

  Widget _buildContactInfoCard() {
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
                  Icons.contact_phone_outlined,
                  color: Colors.blue[600],
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Contact',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[700],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildInfoItem('Porter', 'Abdul Alim'),
            _buildInfoItem('Phone', 'Not provided'),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: Text(
                'Available',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue[700],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransportInfoCard() {
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
                  Icons.directions_outlined,
                  color: Colors.orange[600],
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Transport',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange[700],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildInfoItem('Type', 'রিকশা (Rickshaw)'),
            _buildInfoItem('Time', '60 minutes'),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.access_time_outlined,
                  size: 16,
                  color: Colors.orange[600],
                ),
                const SizedBox(width: 4),
                Text(
                  'Accessible',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Colors.orange[600],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCenterTypeCard() {
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
                  Icons.medical_services_outlined,
                  color: Colors.purple[600],
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Center Type',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple[700],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.purple[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.purple[200]!),
              ),
              child: Column(
                children: [
                  Text(
                    'Outreach Center',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple[700],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Community Service',
                    style: TextStyle(fontSize: 11, color: Colors.purple[600]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
        ],
      ),
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
