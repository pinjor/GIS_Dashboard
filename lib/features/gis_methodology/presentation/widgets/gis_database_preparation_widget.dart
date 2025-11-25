import 'package:flutter/material.dart';

import '../../../../core/common/constants/constants.dart';

class GisDatabasePreparationWidget extends StatelessWidget {
  const GisDatabasePreparationWidget({super.key});

  // 6 Steps Data
  final List<Map<String, dynamic>> steps = const [
    {
      "icon": Icons.photo_camera_front,
      "title": "Step 1: Scanning of Lined Maping",
      "desc":
          "Digitize hand-drawn maps from community mapping sessions into scanned format for GIS processing.",
    },
    {
      "icon": Icons.gps_fixed,
      "title": "Step 2: Georeferencing Scanned Map in GIS Platform",
      "desc":
          "Align scanned maps with real-world coordinates using control points in GIS software.",
    },
    {
      "icon": Icons.edit_location_alt,
      "title": "Step 3: Digitization of Ward and Sub-block Boundary",
      "desc":
          "Create digital vector boundaries for administrative divisions with proper topology and attributes.",
    },
    {
      "icon": Icons.verified_user,
      "title": "Step 4: Cross Check with Microplan",
      "desc":
          "Validate digitized data against existing microplanning records for accuracy and completeness.",
    },
    {
      "icon": Icons.merge_type,
      "title": "Step 5: Integrate BBS Geocode to the GIS Data",
      "desc":
          "Add Bangladesh Bureau of Statistics geocodes to enable administrative data integration.",
    },
    {
      "icon": Icons.link,
      "title": "Step 6: Integrate orgunit UID with GIS Database",
      "desc":
          "Link DHIS2 organization unit identifiers to GIS features for seamless data synchronization.",
    },
  ];

  // 4 Database Components
  final List<Map<String, dynamic>> components = const [
    {
      "icon": Icons.book_outlined,
      "color": Color(0xFFE8F5E9),
      "title": "Updated Union Boundary",
      "desc": "Verified administrative boundaries",
    },
    {
      "icon": Icons.storage_rounded,
      "color": Color(0xFFE3F2FD),
      "title": "Ward Boundary",
      "desc": "Supervisory divisions",
    },
    {
      "icon": Icons.dataset,
      "color": Color(0xFFFFF3E0),
      "title": "Sub-blocks Boundary",
      "desc": "Service delivery areas",
    },
    {
      "icon": Icons.location_on,
      "color": Color(0xFFE0F7FA),
      "title": "Accurate EPI Locations",
      "desc": "GPS coordinates of EPI centers",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFF00A86B),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.storage_rounded,
                  color: Colors.white,
                  size: 34,
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'GIS Database Preparation',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Converting field data into digital Geographic Information System',
                      style: TextStyle(fontSize: 15, color: Colors.black54),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 40),

          // 6-Step Timeline
          ...steps.asMap().entries.map((entry) {
            int idx = entry.key;
            var step = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 28),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Timeline Circle + Line
                  Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade600,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.blue.shade100,
                            width: 4,
                          ),
                        ),
                        child: Icon(
                          step["icon"],
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      if (idx < steps.length - 1)
                        Container(
                          width: 3,
                          height: 80,
                          color: Colors.blue.shade200,
                        ),
                    ],
                  ),
                  const SizedBox(width: 20),
                  // Content Card
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            step["title"],
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            step["desc"],
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.black87,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),

          const SizedBox(height: 50),

          SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Section 1: Georeferencing Process
                _buildSection(
                  icon: Icons.gps_fixed_rounded,
                  iconColor: const Color(0xFF00A86B),
                  title: "Georeferencing Process",
                  subtitle:
                      "Scanned maps from crowd mapping sessions are georeferenced in GIS software, ensuring spatial accuracy and alignment with actual geographic coordinates.",
                  imagePath: Constants.geoRefScanMapImgPath,
                  caption: "Georeferencing Scan Map on GIS Interface",
                ),

                const SizedBox(height: 50),

                // Section 2: GIS Based Digitization of Field Data
                _buildSection(
                  icon: Icons.edit_location_alt_rounded,
                  iconColor: const Color(0xFF00A86B),
                  title: "GIS Based Digitization of Field Data",
                  subtitle:
                      "Field data is digitized into distinct layers, creating a comprehensive multi-layered geographic database for analysis and visualization.",
                  imagePath: Constants.mappingTheLayerOfFieldDataImgPath,
                  caption: "Mapping the Layer of Field Data",
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),

          const SizedBox(height: 40),

          // Database Components Section
          const Text(
            'GIS Database Components',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Four primary layers in the geodatabase',
            style: TextStyle(fontSize: 16, color: Colors.black54),
          ),
          const SizedBox(height: 24),

          // 2x2 Grid → Stacked on very small screens, but 2-column on normal phones
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.55,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: components.length,
            itemBuilder: (context, index) {
              var item = components[index];
              return Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: item["color"],
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(item["icon"], size: 48, color: Colors.teal.shade700),
                    const SizedBox(height: 16),
                    Text(
                      item["title"],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item["desc"],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildSection({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required String imagePath,
    required String caption,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with Icon
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: iconColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: Colors.white, size: 32),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 15.5,
                      height: 1.6,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 28),

        // Image with rounded corners and caption
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.asset(
            imagePath,
            height: 260,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),

        const SizedBox(height: 14),

        // Image Caption
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            caption,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              fontStyle: FontStyle.italic,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
