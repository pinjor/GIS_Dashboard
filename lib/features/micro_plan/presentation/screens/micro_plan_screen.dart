import 'package:flutter/material.dart';
import '../../../../core/common/constants/constants.dart';

class MicroPlanScreen extends StatelessWidget {
  const MicroPlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(Constants.primaryColor),
        title: const Text('Micro Plan', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: const Center(child: Text('Micro Plan Feature - Coming Soon')),
    );
  }
}
