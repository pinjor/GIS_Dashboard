import 'package:flutter/material.dart';
import 'package:gis_dashboard/core/common/constants/constants.dart';

class GisProcessingDataCollectionWidget extends StatelessWidget {
  const GisProcessingDataCollectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[50],
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title Section
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF0066FF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.location_on_outlined,
                  color: Colors.white,
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'EPI Center Geo-data Collection',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Digital transformation of immunization data collection',
                      style: TextStyle(fontSize: 15, color: Colors.black54),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Training Person Image
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              Constants.koboToolboxImgPath,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),

          const SizedBox(height: 24),

          // 6 Step List Tiles
          _buildStepTile(
            number: '1',
            title: 'Design Forms',
            description:
                'Create data collection forms using KoBo Toolbox/ODK for EPI geolocation',
          ),
          const SizedBox(height: 16),

          _buildStepTile(
            number: '2',
            title: 'Conduct Training',
            description:
                'Train front line staff on mobile data collection tools and procedures',
          ),
          const SizedBox(height: 16),

          _buildStepTile(
            number: '3',
            title: 'Field Data Collection',
            description:
                'Collect data using mobile apps (KoBo Toolbox/ODK Survey)',
          ),
          const SizedBox(height: 16),
          const SizedBox(height: 24),

          // KoboToolbox Image
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              Constants.trainingPersonImgPath,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 16),

          _buildStepTile(
            number: '4',
            title: 'GPS Coordinate Integration',
            description:
                'Capture and integrate GPS coordinates to accurately identify and map locations',
          ),
          const SizedBox(height: 16),

          _buildStepTile(
            number: '5',
            title: 'Prepare Data from DHIS2',
            description:
                'Extract and prepare EPI microplan data from DHIS2 server for integration',
          ),
          const SizedBox(height: 16),

          _buildStepTile(
            number: '6',
            title: 'Data Preparation',
            description:
                'Clean, compile to CSV and SHP, and integrate with DHIS2 orgunit UID',
          ),
        ],
      ),
    );
  }

  Widget _buildStepTile({
    required String number,
    required String title,
    required String description,
  }) {
    final int stepNum = int.parse(number);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Number Circle
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: stepNum <= 3
                  ? const Color(0xFF00C2CB).withOpacity(0.1)
                  : const Color(0xFF0066FF).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: stepNum <= 3
                      ? const Color(0xFF00C2CB)
                      : const Color(0xFF0066FF),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Text Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
