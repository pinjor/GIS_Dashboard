import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:gis_dashboard/core/utils/utils.dart';
import 'package:latlong2/latlong.dart';

import '../../../../core/common/constants/constants.dart';
import '../../../../core/common/widgets/header_title_icon_filter_widget.dart';
import '../../../../core/service/geo_data_service.dart';
import '../widget/map_legend_item.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  String currentLevel = 'district';
  MapController mapController = MapController();
  List<AreaPolygon> areaPolygons = [];
  Map<String, dynamic> currentCoverageData = {};
  bool isLoading = true;
  String? selectedAreaId;
  final double _initialZoom = 6.60;
  @override
  void initState() {
    super.initState();
    loadInitialData();
  }

  Future<void> loadInitialData() async {
    try {
      setState(() {
        isLoading = true;
      });

      // Load district coverage data
      currentCoverageData = await GeoDataService.loadCoverageData('district');

      // Create district polygons with coverage data
      areaPolygons = GeoDataService.createDistrictPolygons(currentCoverageData);

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      log('Error loading initial data: $e');
      setState(() {
        isLoading = false;
      });
      _showError('Failed to load map data: $e');
    }
  }

  Future<void> handleAreaTap(String areaId, String areaName) async {
    log('Tapped on area: $areaName (ID: $areaId)');

    try {
      setState(() {
        selectedAreaId = areaId;
        isLoading = true;
      });

      final nextLevel = GeoDataService.levelHierarchy[currentLevel];
      if (nextLevel == null) {
        _showInfo('Maximum drill-down level reached for $areaName');
        setState(() {
          isLoading = false;
        });
        return;
      }

      // Load next level data
      currentCoverageData = await GeoDataService.loadCoverageData(nextLevel);

      // Create sub-level polygons
      areaPolygons = GeoDataService.createSubLevelPolygons(
        areaId,
        nextLevel,
        currentCoverageData,
      );

      setState(() {
        currentLevel = nextLevel;
        isLoading = false;
      });

      // Zoom to the selected area
      _zoomToArea();
    } catch (e) {
      log('Error handling area tap: $e');
      setState(() {
        isLoading = false;
      });
      _showError(
        'Failed to load ${GeoDataService.levelHierarchy[currentLevel]} data: $e',
      );
    }
  }

  void _zoomToArea() {
    final currentZoom = mapController.camera.zoom;
    final newZoom = (currentZoom + 1.5).clamp(1.0, 18.0);

    mapController.move(
      LatLng(23.6850, 90.3563), // Bangladesh center
      newZoom,
    );
  }

  void _resetToCountryView() {
    setState(() {
      currentLevel = 'district';
      selectedAreaId = null;
    });
    loadInitialData();
    mapController.moveAndRotate(LatLng(23.6850, 90.3563), _initialZoom, 0);
  }

  void _handleMapTap(LatLng point) {
    // Check if tap is within any polygon bounds
    for (final areaPolygon in areaPolygons) {
      if (GeoDataService.isPointInPolygon(point, areaPolygon.polygon.points)) {
        handleAreaTap(areaPolygon.areaId, areaPolygon.areaName);
        break;
      }
    }
  }

  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 4),
        ),
      );
    }
  }

  void _showInfo(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.blue,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(Constants.scaffoldBackgroundColor),
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
              12.h,
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Stack(
                    children: [
                      FlutterMap(
                        mapController: mapController,
                        options: MapOptions(
                          initialCenter: LatLng(
                            23.6850,
                            90.3563,
                          ), // Center of Bangladesh
                          initialZoom: _initialZoom,
                          minZoom: 3.5,
                          maxZoom: 18.0,
                          onTap: (tapPosition, point) => _handleMapTap(point),
                        ),
                        children: [
                          TileLayer(
                            urlTemplate:
                                "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                            subdomains: const ['a', 'b', 'c'],
                            userAgentPackageName: 'com.example.gis_dashboard',
                          ),
                          if (!isLoading)
                            PolygonLayer(
                              polygons: areaPolygons
                                  .map((ap) => ap.polygon)
                                  .toList(),
                            ),
                        ],
                      ),

                      // Loading indicator
                      if (isLoading)
                        Container(
                          color: Colors.black.withOpacity(0.3),
                          child: Center(
                            child: Card(
                              child: Padding(
                                padding: EdgeInsets.all(20),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    CircularProgressIndicator(),
                                    SizedBox(height: 16),
                                    Text('Loading $currentLevel data...'),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),

                      // Control buttons
                      Positioned(
                        top: 10,
                        left: 10,
                        child: Column(
                          children: [
                            FloatingActionButton(
                              backgroundColor: Colors.white.withOpacity(0.3),
                              heroTag: "reset",
                              mini: true,
                              onPressed: _resetToCountryView,
                              child: Icon(Icons.home, color: Colors.grey[700]),
                            ),
                          ],
                        ),
                      ),

                      // Level indicator
                      Positioned(
                        bottom: 20,
                        left: 20,
                        child: Card(
                          color: Colors.white.withOpacity(0.4),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            child: Text(
                              'Current Level: ${currentLevel.toUpperCase()}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Legend
                      Positioned(
                        top: 5,
                        right: 5,
                        child: Card(
                          color: Colors.white.withOpacity(0.4),
                          child: Padding(
                            padding: EdgeInsets.all(12),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Coverage %',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                                SizedBox(height: 4),
                                MapLegendItem(
                                  color: Color(0xFFFB6A4A),
                                  label: '<80%',
                                ),
                                MapLegendItem(
                                  color: Color(0xFFFDAE61),
                                  label: '80-85%',
                                ),
                                MapLegendItem(
                                  color: Color(0xFFEDED9D),
                                  label: '85-90%',
                                ),
                                MapLegendItem(
                                  color: Color(0xFFA6D96A),
                                  label: '90-95%',
                                ),
                                MapLegendItem(
                                  color: Color(0xFF2CA25F),
                                  label: '>95%',
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // Area info panel (when area is selected)
                      if (selectedAreaId != null && !isLoading)
                        Positioned(
                          top: 10,
                          left: 10,
                          child: Card(
                            child: Container(
                              width: 200,
                              padding: EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Selected Area',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text('Level: ${currentLevel.toUpperCase()}'),
                                  Text('ID: $selectedAreaId'),
                                  SizedBox(height: 8),
                                  ElevatedButton(
                                    onPressed: () =>
                                        setState(() => selectedAreaId = null),
                                    child: Text('Clear Selection'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
