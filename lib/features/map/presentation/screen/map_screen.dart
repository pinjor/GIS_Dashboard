import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gis_dashboard/config/coverage_colors.dart';
import 'package:gis_dashboard/core/common/widgets/header_title_icon_filter_widget.dart';
import 'package:gis_dashboard/core/common/widgets/network_error_widget.dart';
import 'package:gis_dashboard/features/filter/filter.dart';
import 'package:gis_dashboard/core/utils/utils.dart';
import 'package:gis_dashboard/features/map/presentation/widget/custom_loading_map_widget.dart';
import 'package:latlong2/latlong.dart';

import '../../domain/area_polygon.dart';
import '../../utils/map_utils.dart';
import '../controllers/map_controller.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  final mapController = MapController();
  final double _initialZoom = 6.60;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      ref.read(mapControllerProvider.notifier).loadInitialData();
    });
  }

  List<Polygon> _buildPolygons(List<AreaPolygon> areaPolygons) {
    return areaPolygons.map((areaPolygon) => areaPolygon.polygon).toList();
  }

  /// Build markers for area names (only for drilled-down areas)
  List<Marker> _buildAreaNameMarkers(List<AreaPolygon> areaPolygons) {
    // Don't build too many markers to avoid performance issues
    if (areaPolygons.length > 50) {
      logg.w(
        "Too many polygons (${areaPolygons.length}) for area name markers, skipping labels",
      );
      return [];
    }

    return areaPolygons.map((areaPolygon) {
      // Calculate centroid of the polygon
      LatLng centroid = _calculatePolygonCentroid(areaPolygon.polygon.points);

      return Marker(
        point: centroid,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: Colors.black38, width: 0.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 2,
                offset: const Offset(1, 1),
              ),
            ],
          ),
          child: Text(
            areaPolygon.areaName,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      );
    }).toList();
  }

  /// Calculate the centroid (center point) of a polygon
  LatLng _calculatePolygonCentroid(List<LatLng> points) {
    if (points.isEmpty) return const LatLng(0, 0);

    double centroidLat = 0;
    double centroidLng = 0;

    for (final point in points) {
      centroidLat += point.latitude;
      centroidLng += point.longitude;
    }

    return LatLng(centroidLat / points.length, centroidLng / points.length);
  }

  /// Calculate bounds of all polygons for auto-zoom
  LatLngBounds _calculatePolygonsBounds(List<AreaPolygon> areaPolygons) {
    if (areaPolygons.isEmpty) {
      return LatLngBounds(
        const LatLng(23.6850, 90.3563), // Default Bangladesh center
        const LatLng(23.6850, 90.3563),
      );
    }

    double minLat = double.infinity;
    double maxLat = double.negativeInfinity;
    double minLng = double.infinity;
    double maxLng = double.negativeInfinity;

    for (final areaPolygon in areaPolygons) {
      for (final point in areaPolygon.polygon.points) {
        minLat = minLat < point.latitude ? minLat : point.latitude;
        maxLat = maxLat > point.latitude ? maxLat : point.latitude;
        minLng = minLng < point.longitude ? minLng : point.longitude;
        maxLng = maxLng > point.longitude ? maxLng : point.longitude;
      }
    }

    return LatLngBounds(LatLng(minLat, minLng), LatLng(maxLat, maxLng));
  }

  /// Auto-zoom to fit all polygons with padding
  void _autoZoomToPolygons(List<AreaPolygon> areaPolygons) {
    if (areaPolygons.isEmpty) return;

    final bounds = _calculatePolygonsBounds(areaPolygons);

    // Add some padding around the bounds
    final paddedBounds = LatLngBounds(
      LatLng(
        bounds.south - 0.02, // Smaller padding for better fit
        bounds.west - 0.02,
      ),
      LatLng(
        bounds.north + 0.02, // Smaller padding for better fit
        bounds.east + 0.02,
      ),
    );

    // Fit the map to show all polygons with proper bounds
    try {
      mapController.fitCamera(
        CameraFit.bounds(
          bounds: paddedBounds,
          padding: const EdgeInsets.all(
            50,
          ), // Increased padding for UI elements
          maxZoom: 12.0, // Limit maximum zoom for readability
        ),
      );
      logg.i(
        "Auto-zoomed to bounds: ${paddedBounds.south}, ${paddedBounds.west} to ${paddedBounds.north}, ${paddedBounds.east}",
      );
    } catch (e) {
      logg.e("Error auto-zooming: $e");
      // Fallback to center point zoom
      final center = LatLng(
        (bounds.north + bounds.south) / 2,
        (bounds.east + bounds.west) / 2,
      );
      mapController.moveAndRotate(center, 8.0, 0);
    }
  }

  // void _resetToCountryView() {
  //   // Reset to country level first
  //   // ref.read(mapControllerProvider.notifier).resetToCountryLevel();

  //   // Reset map view to initial position and zoom
  //   mapController.moveAndRotate(LatLng(23.6850, 90.3563), _initialZoom, 0);
  // }

  /// Handle polygon tap for drilldown
  void _onPolygonTap(LatLng tappedPoint, List<AreaPolygon> areaPolygons) {
    logg.i("Map tapped at: ${tappedPoint.latitude}, ${tappedPoint.longitude}");

    // Find which polygon was tapped
    AreaPolygon? tappedPolygon;
    for (final areaPolygon in areaPolygons) {
      if (_isPointInPolygon(tappedPoint, areaPolygon.polygon.points)) {
        tappedPolygon = areaPolygon;
        break;
      }
    }

    if (tappedPolygon != null) {
      logg.i("Tapped on: ${tappedPolygon.areaName}");

      if (tappedPolygon.canDrillDown) {
        logg.i("Drilling down to: ${tappedPolygon.areaName}");
        _performDrillDown(tappedPolygon);
      } else {
        logg.i(
          "Cannot drill down to ${tappedPolygon.areaName} - no detailed data available",
        );
        _showNoDataSnackBar(tappedPolygon.areaName);
      }
    } else {
      logg.i("No polygon found at tapped location");
    }
  }

  /// Check if a point is inside a polygon using ray casting algorithm
  bool _isPointInPolygon(LatLng point, List<LatLng> polygon) {
    int intersections = 0;
    for (int i = 0; i < polygon.length; i++) {
      int j = (i + 1) % polygon.length;

      if ((polygon[i].longitude > point.longitude) !=
              (polygon[j].longitude > point.longitude) &&
          (point.latitude <
              (polygon[j].latitude - polygon[i].latitude) *
                      (point.longitude - polygon[i].longitude) /
                      (polygon[j].longitude - polygon[i].longitude) +
                  polygon[i].latitude)) {
        intersections++;
      }
    }
    return intersections % 2 == 1;
  }

  /// Perform drilldown to the selected area
  void _performDrillDown(AreaPolygon tappedPolygon) {
    final mapNotifier = ref.read(mapControllerProvider.notifier);

    // Determine the next level based on current level
    String nextLevel = _getNextLevel(
      ref.read(mapControllerProvider).currentLevel,
    );

    // Perform the drilldown
    mapNotifier.drillDownToArea(
      areaName: tappedPolygon.areaName,
      slug: tappedPolygon.slug!,
      newLevel: nextLevel,
      parentSlug: tappedPolygon.parentSlug,
    );
  }

  /// Get the next hierarchical level for drilldown
  String _getNextLevel(String currentLevel) {
    switch (currentLevel) {
      case 'district':
        return 'upazila';
      case 'upazila':
        return 'union';
      case 'union':
        return 'ward';
      case 'ward':
        return 'subblock';
      default:
        return 'upazila'; // Default fallback
    }
  }

  /// Show snackbar when no drilldown data is available
  void _showNoDataSnackBar(String areaName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('No detailed data available for $areaName'),
        backgroundColor: Colors.orange,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  /// Go back one level in navigation
  void _goBack() {
    final currentState = ref.read(mapControllerProvider);

    // If going back to country level, also reset map zoom
    if (currentState.navigationStack.length == 1) {
      // This will be the last level, so next will be country
      Future.delayed(const Duration(milliseconds: 500), () {
        logg.i("Resetting zoom to country view after going back");
        mapController.moveAndRotate(LatLng(23.6850, 90.3563), _initialZoom, 0);
      });
    }

    ref.read(mapControllerProvider.notifier).goBack();
  }

  @override
  Widget build(BuildContext context) {
    final mapState = ref.watch(mapControllerProvider);
    final filterState = ref.watch(filterProvider);

    // Listen for state changes to trigger auto-zoom after drilldown
    ref.listen<dynamic>(mapControllerProvider, (previous, current) {
      // Check if we just finished loading after a drilldown (not initial load)
      if (previous?.isLoading == true &&
          current.isLoading == false &&
          current.error == null &&
          current.currentLevel != 'district' && // Only for drilled-down levels
          current.geoJson != null &&
          current.coverageData != null) {
        // Trigger auto-zoom after a short delay
        Future.delayed(const Duration(milliseconds: 1000), () {
          final newPolygons = parseGeoJsonToPolygons(
            current.geoJson!,
            current.coverageData!,
            filterState.selectedVaccine,
          );

          if (newPolygons.isNotEmpty) {
            logg.i(
              "Auto-zooming to ${newPolygons.length} polygons at level: ${current.currentLevel}",
            );
            _autoZoomToPolygons(newPolygons);
          }
        });
      }
    });

    // Parse polygons when we have both GeoJSON and coverage data
    List<AreaPolygon> areaPolygons = [];
    if (mapState.geoJson != null && mapState.coverageData != null) {
      try {
        areaPolygons = parseGeoJsonToPolygons(
          mapState.geoJson!,
          mapState.coverageData!,
          filterState.selectedVaccine,
        );
        logg.i("Successfully parsed ${areaPolygons.length} polygons");
      } catch (e) {
        logg.e("Error parsing polygons: $e");
        // Don't set error state here, just log it
      }

      // Debug logging
      logg.i(
        "Map render state: loading=${mapState.isLoading}, error=${mapState.error ?? 'none'}, polygons=${areaPolygons.length}, level=${mapState.currentLevel}",
      );
    }

    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: HeaderTitleIconFilterWidget(),
          ),
          10.h,
          // Breadcrumb Navigation
          if (mapState.canGoBack)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  IconButton(
                    onPressed: _goBack,
                    icon: const Icon(Icons.arrow_back),
                    tooltip: 'Go Back',
                  ),
                  Expanded(
                    child: Text(
                      mapState.displayPath,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    'Level: ${mapState.currentLevel.toUpperCase()}',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12.0),
              child: Stack(
                children: [
                  if (mapState.isLoading)
                    Container(
                      color: Colors.black.withValues(alpha: 0.3),
                      child: const Center(child: CustomLoadingMapWidget()),
                    ),
                  if (mapState.error != null && !mapState.isLoading)
                    Column(
                      children: [
                        NetworkErrorWidget(
                          error: mapState.error!,
                          onRetry: () {
                            ref
                                .read(mapControllerProvider.notifier)
                                .refreshMapData();
                          },
                        ),
                        // Debug info
                        if (true) // Set to false in production
                          Container(
                            margin: const EdgeInsets.all(8),
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.red.shade50,
                              border: Border.all(color: Colors.red.shade200),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'Debug: Error="${mapState.error}", Loading=${mapState.isLoading}, Level=${mapState.currentLevel}, HasGeoJson=${mapState.geoJson != null}, HasCoverage=${mapState.coverageData != null}',
                              style: const TextStyle(fontSize: 10),
                            ),
                          ),
                      ],
                    ),
                  // Show map when data is loaded successfully (even if polygons are empty)
                  if (!mapState.isLoading &&
                      mapState.error == null &&
                      mapState.geoJson != null &&
                      mapState.coverageData != null)
                    FlutterMap(
                      mapController: mapController,
                      options: MapOptions(
                        initialCenter: const LatLng(
                          23.6850,
                          90.3563,
                        ), // Center of Bangladesh
                        initialZoom: _initialZoom,
                        minZoom: 3.5,
                        maxZoom: 18.0,
                        onTap: (tapPosition, point) {
                          _onPolygonTap(point, areaPolygons);
                        },
                      ),
                      children: [
                        // maybe the url needs an update
                        TileLayer(
                          urlTemplate:
                              'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                          subdomains: const ['a', 'b', 'c'],
                        ),
                        // Area polygons
                        PolygonLayer(polygons: _buildPolygons(areaPolygons)),
                        // Area name labels - ONLY show when drilled down (not on initial district view)
                        if (mapState.currentLevel != 'district')
                          MarkerLayer(
                            markers: _buildAreaNameMarkers(areaPolygons),
                          ),
                      ],
                    ),

                  // Show message when data loaded but no polygons found
                  if (!mapState.isLoading &&
                      mapState.error == null &&
                      mapState.geoJson != null &&
                      mapState.coverageData != null &&
                      areaPolygons.isEmpty)
                    Center(
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.info_outline,
                                size: 48,
                                color: Colors.blue.shade600,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'No map data available',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.blue.shade800,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Data loaded successfully but no geographical boundaries found for this area.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                  // // Reset Button
                  // Positioned(
                  //   top: 5,
                  //   left: 5,
                  //   child: FloatingActionButton(
                  //     mini: true,
                  //     backgroundColor: Colors.white.withValues(alpha: 0.8),
                  //     onPressed: _resetToCountryView,
                  //     child: const Icon(Icons.home, color: Colors.grey),
                  //   ),
                  // ),
                  // Legend
                  Positioned(
                    top: 5,
                    right: 5,
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Coverage %',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            _LegendItem(
                              color: CoverageColors.veryLow,
                              label: '<80%',
                            ),
                            _LegendItem(
                              color: CoverageColors.low,
                              label: '80-85%',
                            ),
                            _LegendItem(
                              color: CoverageColors.medium,
                              label: '85-90%',
                            ),
                            _LegendItem(
                              color: CoverageColors.high,
                              label: '90-95%',
                            ),
                            _LegendItem(
                              color: CoverageColors.veryHigh,
                              label: '>95%',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // // Drilldown hint
                  // if (areaPolygons.any((polygon) => polygon.canDrillDown))
                  //   Positioned(
                  //     bottom: 20,
                  //     left: 20,
                  //     child: Card(
                  //       color: Colors.blue.shade50,
                  //       child: Padding(
                  //         padding: const EdgeInsets.all(8.0),
                  //         child: Row(
                  //           mainAxisSize: MainAxisSize.min,
                  //           children: [
                  //             Icon(
                  //               Icons.touch_app,
                  //               size: 16,
                  //               color: Colors.blue.shade700,
                  //             ),
                  //           ],
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: color,
              border: Border.all(color: Colors.grey),
            ),
          ),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
