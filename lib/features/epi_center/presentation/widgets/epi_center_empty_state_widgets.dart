import 'package:flutter/material.dart';

/// Collection of empty state widgets for EPI Center Details screen
class EpiCenterEmptyStateWidget extends StatelessWidget {
  const EpiCenterEmptyStateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Empty Coverage Tables
          _buildEmptyStateMessage('No coverage data available'),

          _buildEmptyCoverageTables(),
          const SizedBox(height: 24),

          // Empty Chart Section
          _buildEmptyChartSection(),
          const SizedBox(height: 24),
          _buildEmptyMicroplanSection(),
        ],
      ),
    );
  }
}

// empty state teller widget (like no data available for this epi center)

Widget _buildEmptyStateMessage(String message) {
  return Card(
    elevation: 1,
    margin: const EdgeInsets.symmetric(vertical: 12),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: Colors.blue[600], size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
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
              Icon(Icons.table_chart, color: Colors.blue[600], size: 24),
              const SizedBox(width: 8),
              const Text(
                'Microplan Data',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Column(
              children: [
                Icon(Icons.table_view, color: Colors.grey[400], size: 48),
                const SizedBox(height: 12),
                Text(
                  'No microplan data available',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Population breakdown data is not available for this EPI center',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey[500], fontSize: 14),
                ),
              ],
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
      _buildEmptyCoverageSection(
        title: 'Monthly Coverage Data',
        icon: Icons.bar_chart,
        description: 'Monthly vaccination coverage data is not available',
      ),
      const SizedBox(height: 16),
      _buildEmptyCoverageSection(
        title: 'Monthly Dropout Data',
        icon: Icons.trending_down,
        description: 'Monthly vaccination dropout data is not available',
      ),
    ],
  );
}

Widget _buildEmptyCoverageSection({
  required String title,
  required IconData icon,
  required String description,
}) {
  return Card(
    elevation: 2,
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.blue[600], size: 24),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.grid_off, color: Colors.grey[400], size: 48),
                const SizedBox(height: 12),
                Text(
                  'No coverage data',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Text(
                    description,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[500], fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
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
              Icon(Icons.show_chart, color: Colors.blue[600], size: 24),
              const SizedBox(width: 8),
              const Text(
                'Coverage Trends',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            height: 250,
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.timeline, color: Colors.grey[400], size: 48),
                const SizedBox(height: 12),
                Text(
                  'No chart data available',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Coverage trend charts will appear here when data is available',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey[500], fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
