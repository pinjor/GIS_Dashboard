import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/common/constants/constants.dart';
import '../../../map/presentation/screen/map_screen.dart';
import '../../../summary/presentation/screen/summary_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static final List<Widget> _screens = [MapScreen(), SummaryScreen()];

  @override
  Widget build(BuildContext context) {
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
      body: _screens[_selectedIndex],

      /* 

        bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: Row(
          children: [
            _buildNavItem(0, Constants.mapLocationIconPath, 'Map'),
            _buildNavItem(1, Constants.lineGraphIconPath, 'Summary'),
          ],
        ),
      ),
      
      */
      bottomNavigationBar: SizedBox(
        height: 56, // Standard height
        child: Row(
          children: [
            _buildNavItem(
              0,
              Constants.mapLocationIconPath,
              'Map',
              primaryColor,
            ),
            // 👉 Vertical divider between tabs
            Container(
              width: 1,
              height: double.infinity,
              color: Colors.grey.shade300, // subtle light gray line
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

  // Widget _buildNavItem(int index, String iconPath, String label) {
  //   final isSelected = _selectedIndex == index;
  //   final primaryColor = Color(Constants.primaryColor);

  //   return Expanded(
  //     child: GestureDetector(
  //       onTap: () {
  //         setState(() {
  //           _selectedIndex = index;
  //         });
  //       },
  //       child: Container(
  //         padding: const EdgeInsets.symmetric(vertical: 10),
  //         decoration: BoxDecoration(
  //           border: Border(
  //             top: BorderSide(
  //               color: isSelected ? primaryColor : Colors.transparent,
  //               width: 2.0,
  //             ),
  //           ),
  //         ),
  //         child: Center(
  //           child: Row(
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               SvgPicture.asset(
  //                 iconPath,
  //                 width: 24,
  //                 height: 24,
  //                 colorFilter: ColorFilter.mode(
  //                   isSelected ? primaryColor : Colors.grey.shade400,
  //                   BlendMode.srcIn,
  //                 ),
  //               ),
  //               8.w,
  //               Text(
  //                 label,
  //                 style: TextStyle(
  //                   color: isSelected ? primaryColor : Colors.grey.shade400,
  //                   fontWeight: FontWeight.w500,
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
