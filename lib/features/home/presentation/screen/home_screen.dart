import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gis_dashboard/core/common/widgets/connectivity_status_widget.dart';
import 'package:gis_dashboard/features/map/presentation/controllers/map_controller.dart';
import 'package:gis_dashboard/features/filter/filter.dart';

import '../../../../core/common/constants/constants.dart';
import '../../../../core/utils/utils.dart';
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
    final isMapLoading = ref.watch(mapControllerProvider).isLoading;
    final primaryColor = Color(Constants.primaryColor);
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
          ? SizedBox.shrink()
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
    final isMapLoading = ref.watch(mapControllerProvider).isLoading;

    return Expanded(
      child: InkWell(
        onTap: () {
          // make it somewhat unresponsive or kind of inactive/disabled when map is loading
          // fallback logic,if map is loading, do not allow navigation
          if (!isMapLoading) {
            // 🧹 SAFETY: Clear EPI context when navigating between main tabs
            // This ensures clean state when switching from Map to Summary or vice versa
            final filterController = ref.read(
              filterControllerProvider.notifier,
            );
            final filterState = ref.read(filterControllerProvider);
            if (filterState.isEpiDetailsContext) {
              logg.i('🧹 Home: Clearing EPI context on tab switch');
              filterController.clearEpiDetailsContext();
            }

            setState(() {
              _selectedIndex = index;
            });
          } else {
            logg.i('Map is loading, navigation disabled.');
          }
        },
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
