import 'package:flutter/material.dart';

class ProcessingHeaderSection extends StatelessWidget {
  const ProcessingHeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 700,
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF0066FF), Color(0xFF00C2CB)],
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 40),

          // Title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Progress and process GIS Based Online Micro plan',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                height: 1.2,
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Subtitle
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Geo-spatial Data Collection And The Transition From Manual To Digital Mapping In EPI',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white70,
                height: 1.4,
              ),
            ),
          ),

          const SizedBox(height: 40),

          // Stacked Cards - Mobile Friendly
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              children: const [
                FeatureCard(
                  icon: Icons.location_on_outlined,
                  title: 'EPI Center Geo-data\nCollection',
                ),
                SizedBox(height: 20),
                FeatureCard(icon: Icons.map_outlined, title: 'Crowd Mapping'),
                SizedBox(height: 20),
                FeatureCard(
                  icon: Icons.storage_rounded,
                  title: 'GIS Data Preparation',
                ),
                SizedBox(height: 20),
                FeatureCard(
                  icon: Icons.bar_chart_rounded,
                  title: 'Dashboard\nDevelopment',
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;

  const FeatureCard({super.key, required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.18),
        borderRadius: BorderRadius.circular(20),
        // backdropFilter:  ImageFilter.blur(sigmaX: 10, sigmaY: 10), // Glassmorphism effect
      ),
      child: Column(
        children: [
          Icon(icon, size: 56, color: Colors.white),
          const SizedBox(height: 20),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}
