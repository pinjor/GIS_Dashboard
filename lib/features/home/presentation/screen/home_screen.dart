import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gis_dashboard/core/common/widgets/connectivity_status_widget.dart';
import 'package:gis_dashboard/features/map/presentation/controllers/map_controller.dart';
import 'package:gis_dashboard/features/filter/filter.dart';
import 'package:gis_dashboard/features/gis_methodology/presentation/screens/gis_methodology_screen.dart';

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
  String _currentScreen =
      'Home'; // Track current screen: 'Home' or 'Methodology'

  // Create screens once and reuse them
  static final List<Widget> _screens = [
    const MapScreen(),
    const SummaryScreen(),
  ];

  void _navigateToMethodology() {
    Navigator.pop(context); // Close drawer
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const GisMethodologyScreen()),
    ).then((_) {
      // When returning from methodology, ensure we're back on Home
      setState(() {
        _currentScreen = 'Home';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final isMapLoading = ref.watch(mapControllerProvider).isLoading;
    final primaryColor = Color(Constants.primaryColor);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(Constants.primaryColor),
        leading: isMapLoading
            ? const SizedBox.shrink()
            : Builder(
                builder: (context) => IconButton(
                  icon: const Icon(Icons.menu, color: Colors.white),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                ),
              ),
        title: Row(
          children: [
            // Image.asset(Constants.bdMapLogoPath, height: 40),
            const Expanded(
              child: Text(
                'Geo-enabled Microplanning - EPI',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
      drawer: isMapLoading
          ? null
          : Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  DrawerHeader(
                    decoration: BoxDecoration(color: primaryColor),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          Constants.bdMapLogoPath,
                          height: 60,
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'GIS Dashboard',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.dashboard,
                      color: _currentScreen == 'Home'
                          ? primaryColor
                          : Colors.grey,
                    ),
                    title: Text(
                      'Home',
                      style: TextStyle(
                        fontWeight: _currentScreen == 'Home'
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: _currentScreen == 'Home'
                            ? primaryColor
                            : Colors.black87,
                      ),
                    ),
                    selected: _currentScreen == 'Home',
                    selectedTileColor: primaryColor.withOpacity(0.1),
                    onTap: () {
                      Navigator.pop(context); // Close drawer
                      setState(() {
                        _currentScreen = 'Home';
                      });
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.menu_book,
                      color: _currentScreen == 'Methodology'
                          ? primaryColor
                          : Colors.grey,
                    ),
                    title: Text(
                      'Methodology',
                      style: TextStyle(
                        fontWeight: _currentScreen == 'Methodology'
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: _currentScreen == 'Methodology'
                            ? primaryColor
                            : Colors.black87,
                      ),
                    ),
                    selected: _currentScreen == 'Methodology',
                    selectedTileColor: primaryColor.withOpacity(0.1),
                    onTap: () {
                      setState(() {
                        _currentScreen = 'Methodology';
                      });
                      _navigateToMethodology();
                    },
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
