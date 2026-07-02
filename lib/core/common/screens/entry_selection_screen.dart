import 'package:flutter/material.dart';
import 'package:gis_dashboard/core/utils/utils.dart';
import 'package:gis_dashboard/features/epi_center_finder/presentation/screens/epi_center_finder_screen.dart';
import 'package:gis_dashboard/features/home/presentation/screen/home_screen.dart';

import '../constants/constants.dart';

class EntrySelectionScreen extends StatelessWidget {
  const EntrySelectionScreen({super.key});

  void _openFullDashboard(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }

  void _openEpiCenterFinder(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const EpiCenterFinderScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Color(Constants.primaryColor);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const Spacer(flex: 2),
              Image.asset(Constants.bdMapLogoPath, width: 120),
              16.h,
              const Text(
                'Geo-enabled\nMicroplanning - EPI',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF424242),
                ),
              ),
              12.h,
              const Text(
                'Choose how you want to continue',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Color(0xFF757575)),
              ),
              const Spacer(flex: 2),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: () => _openFullDashboard(context),
                  icon: const Icon(Icons.dashboard_outlined, color: Colors.white),
                  label: const Text(
                    'Full Dashboard',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              16.h,
              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton.icon(
                  onPressed: () => _openEpiCenterFinder(context),
                  icon: Icon(Icons.search, color: primaryColor),
                  label: Text(
                    'Find EPI Center',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: primaryColor,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: primaryColor, width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const Spacer(flex: 3),
              const Text(
                'Supported by',
                style: TextStyle(fontSize: 16, color: Color(0xFF757575)),
              ),
              8.h,
              Image.asset(Constants.unicefLogoPath, width: 140, height: 50),
              24.h,
            ],
          ),
        ),
      ),
    );
  }
}
