import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gis_dashboard/core/common/constants/constants.dart';
import 'package:gis_dashboard/features/gis_methodology/presentation/screens/gis_methodology_screen.dart';
import 'package:gis_dashboard/features/micro_plan/presentation/screens/micro_plan_screen.dart';
import 'package:gis_dashboard/features/session_plan/presentation/screens/session_plan_screen.dart';
import 'package:gis_dashboard/features/zero_dose_dashboard/presentation/screens/zero_dose_dashboard_screen.dart';

class DrawerWidget extends ConsumerStatefulWidget {
  const DrawerWidget({super.key});

  @override
  ConsumerState<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends ConsumerState<DrawerWidget> {
  // Since the drawer is closed after navigation, resetting to 'Home' happens automatically on rebuild.
  // We can track a local selection if we want to show it before closing, but it's not strictly necessary if we close immediately.
  // However, if the user navigates back, they might expect the drawer to reset (which it does).
  final String _currentScreen = 'Home';

  void _navigateToScreen(Widget screen) {
    Navigator.pop(context); // Close drawer
    Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Color(Constants.primaryColor);

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: primaryColor),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(Constants.bdMapLogoPath, height: 60),
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
          _buildDrawerItem(
            icon: Icons.dashboard,
            title: 'Home',
            isSelected: _currentScreen == 'Home',
            primaryColor: primaryColor,
            onTap: () {
              Navigator.pop(context); // Close drawer
              // Already on Home
            },
          ),
          _buildDrawerItem(
            icon: Icons.menu_book,
            title: 'Methodology',
            isSelected:
                _currentScreen ==
                'Methodology', // Will effectively be false unless we change state logic
            primaryColor: primaryColor,
            onTap: () => _navigateToScreen(const GisMethodologyScreen()),
          ),
          _buildDrawerItem(
            icon: Icons.map_outlined,
            title: 'Micro Plan',
            isSelected: _currentScreen == 'Micro Plan',
            primaryColor: primaryColor,
            onTap: () => _navigateToScreen(const MicroPlanScreen()),
          ),
          _buildDrawerItem(
            icon: Icons.calendar_month,
            title: 'Session Plan',
            isSelected: _currentScreen == 'Session Plan',
            primaryColor: primaryColor,
            onTap: () => _navigateToScreen(const SessionPlanScreen()),
          ),
          _buildDrawerItem(
            icon: Icons.analytics,
            title: 'Zero Dose Dashboard',
            isSelected: _currentScreen == 'Zero Dose Dashboard',
            primaryColor: primaryColor,
            onTap: () => _navigateToScreen(const ZeroDoseDashboardScreen()),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required bool isSelected,
    required Color primaryColor,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: isSelected ? primaryColor : Colors.grey),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? primaryColor : Colors.black87,
        ),
      ),
      selected: isSelected,
      selectedTileColor: primaryColor.withOpacity(0.1),
      onTap: onTap,
    );
  }
}
