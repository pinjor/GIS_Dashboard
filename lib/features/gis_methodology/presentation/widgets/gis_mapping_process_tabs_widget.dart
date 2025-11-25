import 'package:flutter/material.dart';

import '../../../../core/common/constants/constants.dart';

class GisMappingProcessTabsWidget extends StatefulWidget {
  const GisMappingProcessTabsWidget({super.key});

  @override
  State<GisMappingProcessTabsWidget> createState() =>
      _GisMappingProcessTabsWidgetState();
}

class _GisMappingProcessTabsWidgetState
    extends State<GisMappingProcessTabsWidget>
    with SingleTickerProviderStateMixin {
  int _selectedTab = 0;

  final List<String> _tabTitles = [
    "Map Preparation",
    "Map Verification",
    "Hands on Mapping",
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // ─────── Tab Bar ───────
          Container(
            margin: const EdgeInsets.all(16),
            height: 50,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _tabTitles.asMap().entries.map((entry) {
                  int idx = entry.key;
                  String title = entry.value;
                  bool isSelected = _selectedTab == idx;

                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedTab = idx),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.blue
                              : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: isSelected
                                ? Colors.blue
                                : Colors.grey.shade300,
                            width: 2,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            title,
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.blue,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          // ─────── Tab Content ───────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: _buildTabContent(),
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildTabContent() {
    switch (_selectedTab) {
      case 0:
        return const MapPreparationTab();
      case 1:
        return const MapVerificationTab();
      case 2:
        return const HandsOnMappingTab();
      default:
        return const SizedBox();
    }
  }
}

// ─────────────────────── TAB 1 – Map Preparation ───────────────────────
class MapPreparationTab extends StatelessWidget {
  const MapPreparationTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Two Cards Side-by-Side (stacked on very small screens)
        LayoutBuilder(
          builder: (context, constraints) {
            // bool isWide = constraints.maxWidth > 600;
            return Wrap(
              spacing: 20,
              runSpacing: 20,
              alignment: WrapAlignment.center,
              children: [
                _mapCard(
                  icon: Icons.map_outlined,
                  title: "Union Wise Map Preparation",
                  subtitle: "For Districts",
                  description:
                      "Detailed map preparation at Union level for rural areas, ensuring all geographic features are accurately represented.",
                  imagePath: Constants.unionWiseMapPrepImgPath,
                ),
                _mapCard(
                  icon: Icons.location_city,
                  title: "Zone Wise Map Preparation",
                  subtitle: "For City Corporations",
                  description:
                      "Specialized map preparation for urban areas, focusing on zone-based divisions in city corporation areas.",
                  imagePath: Constants.zoneWiseMapPrepImgPath,
                ),
              ],
            );
          },
        ),

        const SizedBox(height: 40),

        // Bottom Info Bar - Redesigned for mobile
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A1A),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _infoSection(
                "Tools used for Mapping & Data Collection:",
                "QGIS\nODK\nKML/KMZ\nPrinted Map and Marker",
                Icons.build_circle_outlined,
              ),
              const SizedBox(height: 20),
              const Divider(color: Colors.white24, height: 1),
              const SizedBox(height: 20),
              _infoSection(
                "Data Source of Map:",
                "Administrative Boundary: Bangladesh Bureau of Statistics (BBS 2011)\nBasemap: Google Hybrid\nEPI Geolocation: Field Survey",
                Icons.source_outlined,
              ),
              const SizedBox(height: 20),
              const Divider(color: Colors.white24, height: 1),
              const SizedBox(height: 20),
              _infoSection(
                "Coordinate System Used:",
                "Projection: GCS WGS 1984\nDatum: WGS 1984\nUnit: Degree",
                Icons.map_outlined,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _mapCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required String description,
    required String imagePath,
  }) {
    return Container(
      width: 380,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.blue, size: 28),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          Text(
            subtitle,
            style: TextStyle(
              color: Colors.blue.shade700,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              imagePath,
              height: 220,
              width: double.infinity,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            description,
            style: const TextStyle(color: Colors.black87, height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _infoSection(String title, String content, IconData icon) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Colors.blue.shade300, size: 24),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                content,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─────────────────────── TAB 2 – Map Verification (Flowchart) ───────────────────────
class MapVerificationTab extends StatelessWidget {
  const MapVerificationTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const Text(
            "Verification Process Flow",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 20),

          // Simple Flowchart using Rows & Columns
          Image.asset(Constants.mapVerificationFlowChartImgPath),
          const SizedBox(height: 30),

          // Output
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Output of Map Verification",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 16),
                _buildOutputItem(
                  Icons.check_circle,
                  "Finalized Union Boundaries",
                ),
                const SizedBox(height: 10),
                _buildOutputItem(
                  Icons.location_on,
                  "Verified EPI Center GPS Coordinates",
                ),
                const SizedBox(height: 10),
                _buildOutputItem(
                  Icons.bar_chart,
                  "Final Count of Outreach Center in a Union/Ward",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOutputItem(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.green, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────── TAB 3 – Hands on Mapping ───────────────────────
class HandsOnMappingTab extends StatelessWidget {
  const HandsOnMappingTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.asset(
            Constants.handsOnMappingTabImgPath, // replace with your real image
            height: 260,
            width: double.infinity,
            fit: BoxFit.contain,
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          "Map Description: Bold black lines indicate ward boundaries, and each ward is divided into 8 sub-blocks denoted by narrow black lines.",
          style: TextStyle(fontStyle: FontStyle.italic),
        ),

        const SizedBox(height: 30),

        // Numbered Steps
        _stepItem(
          "1",
          "Start with Union",
          "Begin the mapping process at the Union administrative level.",
        ),
        _stepItem(
          "2",
          "Divide Each Union into 3 Wards",
          "A Ward boundary in EPI refers to a subdivision of a Union, created for the purpose of health service delivery management...",
        ),
        _stepItem(
          "3",
          "Demarcate Each Ward into 8 Sub-blocks",
          "A Sub-block is the smallest operational geographic unit used in the EPI microplanning system...",
        ),

        const SizedBox(height: 30),

        // Key Considerations Box
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.cyan.shade50,
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Key Considerations",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              SizedBox(height: 12),
              Text("• Major rivers have not been included in service areas"),
              Text(
                "• All other areas including vacant land, agricultural land, forest land, and haor areas have been considered",
              ),
              Text("• No sub-blocks exist in City Corporation areas"),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // Final Result
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Row(
            children: [
              Icon(Icons.info, color: Colors.blue),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  "Final Result: Each Union contains 3 Wards, with each Ward divided into 8 Sub-blocks, creating a total of 24 sub-blocks per Union for comprehensive micro-planning coverage.",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _stepItem(String number, String title, String desc) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.teal,
            child: Text(
              number,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
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
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(desc, style: const TextStyle(color: Colors.black87)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
