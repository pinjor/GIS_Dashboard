import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DashboardFeatureOverview extends StatelessWidget {
  const DashboardFeatureOverview({super.key});

  final List<Map<String, dynamic>> features = const [
    {
      "icon": Icons.public,
      "color": Color(0xFFF3E8FF),
      "title": "Geographic Coverage",
      "desc": "District and City Corporation data included",
    },
    {
      "icon": Icons.people_alt_outlined,
      "color": Color(0xFFE8F5E9),
      "title": "Target Population",
      "desc": "Total targeted children displayed based on filter selection",
    },
    {
      "icon": Icons.calendar_month,
      "color": Color(0xFFE3F2FD),
      "title": "Time Period Selection",
      "desc": "Year and month can be changed interactively",
    },
    {
      "icon": Icons.check_circle_outline,
      "color": Color(0xFFE8F5E9),
      "title": "Vaccination Status",
      "desc": "Vaccinated children count updates dynamically",
    },
    {
      "icon": Icons.filter_list,
      "color": Color(0xFFE3F2FD),
      "title": "Dynamic Filtering",
      "desc": "From Division to Sub-block level filter options",
    },
    {
      "icon": Icons.pie_chart_outline,
      "color": Color(0xFFFFF3E0),
      "title": "Performance Analysis",
      "desc":
          "Administrative unit-wise performance table showing top and low performers (<90% coverage)",
    },
    {
      // "icon": Icons.syringe_outlined,
      "color": Color.fromARGB(255, 239, 153, 182),
      "title": "Vaccine Selection",
      "desc": "Filter between BCG, Penta-1/2/3, MR-1, and MR-2",
    },
    {
      "icon": Icons.bar_chart_rounded,
      "color": Color(0xFFE3F2FD),
      "title": "Visual Analytics",
      "desc":
          "Target vs. vaccinated cumulative graph by filter and vaccine, month-wise",
    },
    {
      "icon": Icons.map_outlined,
      "color": Color(0xFFE3F2FD),
      "title": "Map Visualization",
      "desc":
          "Multi-layer interactive mapping with various view options:\n• OpenStreet Map • Hybrid View • Satellite Imagery",
    },
    {
      "icon": Icons.show_chart,
      "color": Color(0xFFE0F7FA),
      "title": "Coverage Monitoring",
      "desc": "Vaccine coverage and dropout monitoring by administrative unit",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF9333EA), Color(0xFF7C3AED)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.bar_chart_rounded,
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
                      'Geo-enabled Dashboard Development',
                      style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Real-time data visualization and decision-making platform',
                      style: TextStyle(fontSize: 15, color: Colors.black54),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 32),

          const Text(
            'GIS Dashboard Features Overview',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 32),

          // Feature Cards Grid → Stacked on Mobile
          ...features.map(
            (feature) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _buildFeatureCard(feature),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(Map<String, dynamic> data) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: data["color"],
              borderRadius: BorderRadius.circular(16),
            ),
            child: data["icon"] == null
                ? FaIcon(
                    FontAwesomeIcons.syringe,
                    size: 10,
                    color: Colors.white,
                  )
                : Icon(data["icon"], size: 30, color: Colors.blue[700]),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data["title"],
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  data["desc"],
                  style: const TextStyle(
                    fontSize: 14.5,
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
