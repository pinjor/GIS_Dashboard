import 'package:flutter/material.dart';
import 'package:gis_dashboard/core/common/constants/constants.dart';

class GisDataPreparationWidget extends StatelessWidget {
  const GisDataPreparationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Colors.lightBlueAccent.withOpacity(0.12),
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
                      Icons.storage_rounded,
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
                          'Training on EPI Data Collection Tool',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // Process Steps
              SizedBox(
                height: 260,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    _buildDataCollectionToolStep(
                      icon: Icons.menu_book_rounded,
                      title: "Platform Introduction",
                      description:
                          "Basic introduction to KoboToolbox platform and functions",
                    ),
                    _buildDataCollectionToolStep(
                      icon: Icons.navigation_rounded,
                      title: "GPS Fundamentals",
                      description:
                          "Knowledge on point data, GPS coordinates, and survey forms",
                    ),
                    _buildDataCollectionToolStep(
                      icon: Icons.play_circle_filled_rounded,
                      title: "Live Examples",
                      description:
                          "Real-time form creation,\ndeployment, and data submission",
                    ),
                    _buildDataCollectionToolStep(
                      icon: Icons.pan_tool_rounded,
                      title: "Hands-on Session",
                      description:
                          "Practical field data collection for EPI centers",
                    ),
                    _buildDataCollectionToolStep(
                      icon: Icons.chat_bubble_outline_rounded,
                      title: "Conclusion",
                      description:
                          "Group discussion, challenge identification, and Q&A",
                      isLast: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 32),

        // Logo Cards Section
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              _buildLogoCard(
                Constants.koboToolboxLogoImgPath,
                content:
                    "From DHIS2 orgunit UID & orgname extracted and stored in the database for integration with geo-database",
              ),
              const SizedBox(height: 16),
              _buildLogoCard(
                Constants.dhis2LogoImgPath,
                content:
                    "Outreach Center Geodata Collected from field as per detail microplan and session plan.",
              ),
              const SizedBox(height: 16),
              _buildLogoCard(
                Constants.shapeCsvImgPath,
                content:
                    "After integration DHIS2 and Kobo Data, Outreach center Geodata Preparation is complete",
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildLogoCard(String imagePath, {required String content}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Image.asset(imagePath, height: 60, width: 80, fit: BoxFit.contain),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              content,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataCollectionToolStep({
    required IconData icon,
    required String title,
    required String description,
    bool isLast = false,
  }) {
    return Row(
      children: [
        Container(
          width: 260,
          margin: const EdgeInsets.only(right: 16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Icon
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [Color(0xFF3A84F7), Color(0xFF00AEEF)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Icon(icon, color: Colors.white, size: 32),
              ),

              const SizedBox(height: 16),

              // Title
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Color(0xFF173B65),
                ),
              ),

              const SizedBox(height: 12),

              // Description
              Text(
                description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  height: 1.4,
                  fontSize: 15,
                  color: Colors.grey.shade700,
                ),
              ),
            ],
          ),
        ),
        if (!isLast)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Icon(
              Icons.arrow_forward,
              color: Colors.lightBlueAccent.shade200,
              size: 20,
            ),
          ),
      ],
    );
  }
}
