import 'package:flutter/material.dart';
import '../../../../core/common/constants/constants.dart';

class SessionPlanScreen extends StatelessWidget {
  const SessionPlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(Constants.primaryColor),
        title: const Text(
          'Session Plan',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: const Center(child: Text('Session Plan Feature - Coming Soon')),
    );
  }
}
