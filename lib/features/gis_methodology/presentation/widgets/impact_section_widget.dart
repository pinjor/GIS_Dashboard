import 'package:flutter/material.dart';

class ImpactSectionWidget extends StatelessWidget {
  const ImpactSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF0061FF), Color(0xFF00C2CB)],
        ),
      ),
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 40),

          // Main Text
          const Text(
            'Incorporating geo-mapping technologies significantly enhances immunization coverage and addresses accessibility challenges, contributing to the overall health of the target population.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              height: 1.6,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 60),

          // Three Impact Cards – Stacked on Mobile
          const ImpactCard(
            icon: Icons.check_circle_outline_rounded,
            title: 'Enhanced Coverage',
            subtitle: 'Improved immunization reach through accurate mapping',
          ),
          const SizedBox(height: 20),
          const ImpactCard(
            icon: Icons.location_on_outlined,
            title: 'Better Accessibility',
            subtitle: 'Address geographic and logistic challenges effectively',
          ),
          const SizedBox(height: 20),
          const ImpactCard(
            icon: Icons.trending_up_rounded,
            title: 'Improved Health Outcomes',
            subtitle: 'Contributing to overall population health',
          ),

          const SizedBox(height: 60),
        ],
      ),
    );
  }
}

class ImpactCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const ImpactCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.18),
        borderRadius: BorderRadius.circular(24),
        // backdropFilter: const BlurFilter(12), // Glassmorphism
        border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
      ),
      child: Column(
        children: [
          Icon(icon, size: 64, color: Colors.white),
          const SizedBox(height: 24),
          Text(
            title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white70,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
