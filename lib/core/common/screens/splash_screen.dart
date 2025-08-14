import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gis_dashboard/core/utils/utils.dart';
import '../../../features/home/presentation/screen/home_screen.dart';
import '../constants/constants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Add post frame callback for image preloading
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Preload all images
      _preloadImages().then((_) {
        // Navigate to home after 2.5 seconds (or after loading if longer)
        Timer(const Duration(milliseconds: 2500), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        });
      });
    });
  }

  // Function to preload images
  Future<void> _preloadImages() async {
    await precacheImage(AssetImage(Constants.bdMapLogoPath), context);
    await precacheImage(AssetImage(Constants.unicefLogoPath), context);
    await precacheImage(AssetImage(Constants.poweredByLeftLogosPath), context);
    await precacheImage(AssetImage(Constants.eqmsLogoPath), context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              150.h,
              Image.asset(Constants.bdMapLogoPath, width: 120),
              10.h,
              const Text(
                'Geo-enabled\nMicroplanning - EPI',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF424242),
                ),
              ),
              const Spacer(flex: 2),
              const Text(
                'Supported by',
                style: TextStyle(fontSize: 16, color: Color(0xFF757575)),
              ),
              1.h,
              Image.asset(Constants.unicefLogoPath, width: 140, height: 50),
              const Spacer(flex: 3),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        const Text(
                          'Powered by',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF757575),
                          ),
                        ),
                        8.w,
                        Image.asset(
                          Constants.poweredByLeftLogosPath,
                          width: 80,
                          height: 30,
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        const Text(
                          'Powered by',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF757575),
                          ),
                        ),
                        8.w,
                        Image.asset(
                          Constants.eqmsLogoPath,
                          width: 80,
                          height: 30,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              20.h,
            ],
          ),
        ),
      ),
    );
  }
}
