import 'package:flutter/material.dart';

import '../../../../core/common/widgets/header_title_icon_filter_widget.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          child: Column(
            children: [
              HeaderTitleIconFilterWidget(
                region: 'Bangladesh',
                year: '2015',
                vaccine: 'Penta-1',
              
              ),
            ],
          ),
        ),
      ),
    );
  }
}
