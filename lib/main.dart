import 'package:flutter/material.dart';
import 'package:gis_dashboard/features/home/presentation/screen/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity, 
      ),
      title: 'GIS Dashboard',
      home: const HomeScreen(),
      
    );
  }
}
