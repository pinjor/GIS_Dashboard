import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gis_dashboard/core/common/widgets/connectivity_status_widget.dart';
import 'package:gis_dashboard/features/map/presentation/controllers/map_controller.dart';

import '../../../../core/common/constants/constants.dart';
import '../../../map/presentation/screen/map_screen.dart';
import '../../../summary/presentation/screen/summary_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedIndex = 0;

  // Create screens once and reuse them
  static final List<Widget> _screens = [
    const MapScreen(),
    const SummaryScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final primaryColor = Color(Constants.primaryColor);
    final isMapLoading = ref.watch(mapControllerProvider).isLoading;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(Constants.primaryColor),
        title: Row(
          children: [
            Image.asset(Constants.bdMapLogoPath, height: 40),
            const SizedBox(width: 10),
            const Text(
              'Geo-enabled Microplanning - EPI',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Connectivity status bar
          const ConnectivityStatusWidget(),
          // Main content
          Expanded(
            child: IndexedStack(index: _selectedIndex, children: _screens),
          ),
        ],
      ),
      bottomNavigationBar: isMapLoading
          ? const SizedBox.shrink()
          : SizedBox(
              height: 56,
              child: Row(
                children: [
                  _buildNavItem(
                    0,
                    Constants.mapLocationIconPath,
                    'Map',
                    primaryColor,
                  ),
                  Container(
                    width: 1,
                    height: double.infinity,
                    color: Colors.grey.shade300,
                  ),
                  _buildNavItem(
                    1,
                    Constants.lineGraphIconPath,
                    'Summary',
                    primaryColor,
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildNavItem(
    int index,
    String iconPath,
    String label,
    Color primaryColor,
  ) {
    final isSelected = _selectedIndex == index;

    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _selectedIndex = index),
        child: Container(
          height: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              top: BorderSide(
                color: isSelected ? primaryColor : Colors.transparent,
                width: 1.5,
              ),
            ),
          ),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  iconPath,
                  width: index == 0 ? 24 : 22,
                  height: index == 0 ? 24 : 22,
                  colorFilter: ColorFilter.mode(
                    isSelected ? primaryColor : Colors.grey.shade400,
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: TextStyle(
                    color: isSelected ? primaryColor : Colors.grey.shade400,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
