import 'package:flutter/material.dart';

class OutputGisDashboardWidget extends StatelessWidget {
  const OutputGisDashboardWidget({super.key});

  final List<Map<String, dynamic>> features = const [
    {
      "icon": Icons.hexagon_outlined,
      "color": Color(0x00fff0f8),
      "title": "Defined Ward and Sub-block Boundary",
      "desc":
          "Precise administrative boundaries mapped for effective micro-planning and resource allocation",
    },
    {
      "icon": Icons.trending_up,
      "color": Color(0xFFE3F7FF),
      "title": "Way to Identify EPI Performance Across Country",
      "desc":
          "Comprehensive performance tracking and analysis across all administrative levels nationwide",
    },
    {
      "icon": Icons.location_on_outlined,
      "color": Color(0xFFE8F5FF),
      "title": "Identification of Outreach and Fixed Center Location",
      "desc":
          "Strategic mapping of vaccination centers and outreach points for optimal service delivery",
    },
    {
      "icon": Icons.calendar_today_rounded,
      "color": Color(0xFFE8F5E9),
      "title": "Scheduling Vaccination Plan According to Session Plan for All",
      "desc":
          "Coordinated scheduling and planning for comprehensive vaccination coverage",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header
        Container(
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFF5F0FF),
                ),
                child: const Icon(
                  Icons.bar_chart_rounded,
                  size: 48,
                  color: Color(0xFF8B5CF6),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Output GIS Dashboard',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Major Outputs & Capabilities',
                style: TextStyle(
                  fontSize: 17,
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // Feature Cards - Stacked Vertically (Mobile First)
        ...features.map(
          (feature) => Padding(
            padding: const EdgeInsets.only(bottom: 16, right: 16, left: 16),
            child: _buildFeatureCard(feature),
          ),
        ),

        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildFeatureCard(Map<String, dynamic> data) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon Circle
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: data["color"],
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(data["icon"], size: 32, color: Colors.blue[700]),
          ),
          const SizedBox(width: 18),
          // Text Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data["title"],
                  style: const TextStyle(
                    fontSize: 17.5,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  data["desc"],
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.black87,
                    height: 1.5,
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
