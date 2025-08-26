import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gis_dashboard/config/coverage_colors.dart';
import 'package:gis_dashboard/core/common/widgets/header_title_icon_filter_widget.dart';
import 'package:gis_dashboard/features/filter/filter.dart';
import 'package:gis_dashboard/core/utils/utils.dart';
import 'package:gis_dashboard/features/map/presentation/widget/vaccine_center_info_overlay_widget.dart';
import 'package:latlong2/latlong.dart';

import '../../../../core/common/widgets/custom_loading_widget.dart';
import '../../domain/area_polygon.dart';
import '../../utils/map_utils.dart';
import '../controllers/map_controller.dart';
import '../widget/map_legend_item.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  final mapController = MapController();
  Timer? _autoZoomTimer;
  DateTime? _lastAutoZoom;
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
    // Filter out "Part X" polygons to avoid duplicate labels
    final mainAreaPolygons = areaPolygons
        .where(
          (polygon) =>
              !polygon.areaName.contains('(Part ') ||
              polygon.areaName.endsWith('(Part 1)'),
        )
        .toList();

    // With comprehensive polygon rendering, we might have many more polygons now
    if (mainAreaPolygons.length > 150) {
      logg.w(
        "Too many areas (${mainAreaPolygons.length}) for name markers, skipping labels",
      );
      return [];
    }

    logg.i(
      "Building ${mainAreaPolygons.length} area name markers from ${areaPolygons.length} total polygons",
    );

    return mainAreaPolygons.map((areaPolygon) {
      // Calculate centroid of the polygon
      LatLng centroid = _calculatePolygonCentroid(areaPolygon.polygon.points);

      // Clean up the area name (remove "Part X" suffix for display)
      String displayName = areaPolygon.areaName;
      if (displayName.contains('(Part 1)')) {
        displayName = displayName.replaceFirst(' (Part 1)', '');
      }

      return Marker(
        point: centroid,
        child: FittedBox(
          fit: BoxFit.none,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: Colors.black38, width: 0.5),
            ),
            child: Text(
              displayName,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
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

  /// Build EPI markers (vaccination centers) from EPI data
  List<Marker> _buildEpiMarkers(String? epiData) {
    if (epiData == null || epiData.isEmpty) return [];

    try {
      final decoded = jsonDecode(epiData) as Map<String, dynamic>;
      final features = decoded['features'] as List<dynamic>?;

      if (features == null || features.isEmpty) return [];

      logg.i("Building ${features.length} EPI markers");

      return features
          .map<Marker>((feature) {
            final geometry = feature['geometry'];
            final info = feature['info'];

            if (geometry?['type'] == 'Point' &&
                geometry?['coordinates'] != null) {
              final coords = geometry['coordinates'] as List;
              final lng = (coords[0] as num).toDouble();
              final lat = (coords[1] as num).toDouble();
              final centerName = info?['name'] ?? 'EPI Center';
              final isFixedCenter = info?['is_fixed_center'] ?? false;

              return Marker(
                point: LatLng(lat, lng),
                child: Tooltip(
                  message: centerName,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: isFixedCenter
                          ? Colors.blueAccent
                          : Colors.deepPurple,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.3),
                          blurRadius: 3,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Center(
                      child: !isFixedCenter
                          ? FaIcon(
                              FontAwesomeIcons.syringe,
                              size: 12,
                              color: Colors.white,
                            )
                          : Icon(Icons.home, color: Colors.white, size: 12),
                    ),
                  ),
                ),
              );
            }

            // Return empty marker for invalid geometry
            return Marker(
              point: const LatLng(0, 0),
              child: const SizedBox.shrink(),
            );
          })
          .where(
            (marker) =>
                marker.point.latitude != 0 || marker.point.longitude != 0,
          )
          .toList();
    } catch (e) {
      logg.e("Error parsing EPI data: $e");
      return [];
    }
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

  void _resetToCountryView({required String currentLevel}) {
    // Reset to country level first
    if (currentLevel != 'district') {
      // Already at country level
      logg.i("Resetting to country level view");
      ref.read(mapControllerProvider.notifier).resetToCountryLevel();
    } else {
      logg.i("Already at country level, just resetting zoom");
    }

    // Reset map view to initial position and zoom
    mapController.moveAndRotate(LatLng(23.6850, 90.3563), _initialZoom, 0);
  }

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

    // Clear any existing error state before drilldown
    mapNotifier.clearError();

    // Determine the next level based on current level
    String nextLevel = _getNextLevel(
      ref.read(mapControllerProvider).currentLevel,
    );

    // Show a subtle loading indicator and perform the drilldown
    _showLoadingSnackBar(tappedPolygon.areaName);

    // Perform the drilldown
    mapNotifier.drillDownToArea(
      areaName: tappedPolygon.areaName,
      slug: tappedPolygon.slug!,
      newLevel: nextLevel,
      parentSlug: tappedPolygon.parentSlug,
    );
  }

  /// Show a subtle loading indicator during drilldown
  void _showLoadingSnackBar(String areaName) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
            const SizedBox(width: 12),
            Text('Loading $areaName...'),
          ],
        ),
        backgroundColor: Colors.blue.shade600,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  /// Show success indicator after successful drilldown
  void _showSuccessSnackBar(String areaName) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white, size: 16),
            const SizedBox(width: 12),
            Text('Loaded $areaName successfully'),
          ],
        ),
        backgroundColor: Colors.green.shade600,
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
      ),
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
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
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
    final mapNotifier = ref.read(mapControllerProvider.notifier);

    // Clear any existing error state before going back
    mapNotifier.clearError();

    // If going back to country level, also reset map zoom
    if (currentState.navigationStack.length == 1) {
      // This will be the last level, so next will be country
      Future.delayed(const Duration(milliseconds: 500), () {
        logg.i("Resetting zoom to country view after going back");
        mapController.moveAndRotate(LatLng(23.6850, 90.3563), _initialZoom, 0);
      });
    }

    mapNotifier.goBack();
  }

  @override
  void dispose() {
    _autoZoomTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mapState = ref.watch(mapControllerProvider);
    final filterState = ref.watch(filterProvider);

    // Listen for state changes to trigger auto-zoom after drilldown
    ref.listen<dynamic>(mapControllerProvider, (previous, current) {
      // Hide any loading snackbars when state changes
      if (previous?.isLoading == true && current.isLoading == false) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
      }

      // Check if we just finished loading after a drilldown (not initial load)
      if (previous?.isLoading == true &&
          current.isLoading == false &&
          current.error == null &&
          current.currentLevel != 'district' && // Only for drilled-down levels
          current.geoJson != null &&
          current.coverageData != null) {
        // Throttle auto-zoom to prevent rapid calls
        final now = DateTime.now();
        if (_lastAutoZoom != null &&
            now.difference(_lastAutoZoom!).inMilliseconds < 2000) {
          logg.i("Auto-zoom throttled - too recent");
          return;
        }
        _lastAutoZoom = now;

        // Cancel any existing timer
        _autoZoomTimer?.cancel();

        // Show success indicator
        _showSuccessSnackBar(current.currentAreaName ?? 'Area');

        // Trigger auto-zoom after a longer delay to allow tiles to load
        _autoZoomTimer = Timer(const Duration(milliseconds: 1500), () {
          try {
            final newPolygons = parseGeoJsonToPolygons(
              current.geoJson!,
              current.coverageData!,
              filterState.selectedVaccine,
              current.currentLevel,
            );

            if (newPolygons.isNotEmpty && mounted) {
              logg.i(
                "Auto-zooming to ${newPolygons.length} polygons at level: ${current.currentLevel}",
              );
              _autoZoomToPolygons(newPolygons);
            }
          } catch (e) {
            logg.w("Auto-zoom failed: $e");
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
          mapState.currentLevel,
        );
        logg.i("Successfully parsed ${areaPolygons.length} polygons");

        // Clear any existing errors when data is successfully loaded and parsed
        if (mapState.error != null && !mapState.isLoading) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ref.read(mapControllerProvider.notifier).clearError();
          });
        }
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
                      'Home > ${mapState.displayPath}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 4,
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
                      child: const Center(child: CustomLoadingWidget()),
                    ),
                  // REMOVED ERROR SCREEN - No more blocking error displays
                  // Errors are now handled gracefully with silent degradation

                  // Show map when data is loaded successfully (even if polygons are empty)
                  if (!mapState.isLoading &&
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
                        // Enhanced tile layer with error handling and network resilience
                        TileLayer(
                          urlTemplate:
                              'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                          subdomains: const ['a', 'b', 'c'],
                          // Add fallback URL for better reliability
                          fallbackUrl:
                              'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                          // Silence network exceptions to prevent error flooding
                          tileProvider: NetworkTileProvider(
                            silenceExceptions: true,
                          ),
                          // Add user agent to comply with OSM usage policy
                          userAgentPackageName: 'com.example.gis_dashboard',
                          // Error handling configuration
                          errorTileCallback: (tile, error, stackTrace) {
                            // Log the error but don't show UI errors
                            logg.w(
                              'Tile loading error for ${tile.coordinates}: $error',
                            );
                          },
                          // Keep tiles in memory longer to reduce reloads
                          keepBuffer: 3,
                          // Reduce tile loading during panning
                          panBuffer: 1,
                          // Limit max zoom to reduce tile requests
                          maxZoom: 15,
                        ),
                        // Area polygons
                        PolygonLayer(polygons: _buildPolygons(areaPolygons)),
                        // Area name labels - ONLY show when drilled down (not on initial district view)
                        if (mapState.currentLevel != 'district')
                          MarkerLayer(
                            markers: _buildAreaNameMarkers(areaPolygons),
                          ),
                        // EPI markers (vaccination centers) - ONLY show for union and deeper levels
                        if ((mapState.currentLevel == 'union' ||
                                mapState.currentLevel == 'ward' ||
                                mapState.currentLevel == 'subblock') &&
                            mapState.epiData != null)
                          MarkerLayer(
                            markers: _buildEpiMarkers(mapState.epiData),
                          ),
                      ],
                    ),

                  // Show message when data loaded but no polygons found (less intrusive)
                  if (!mapState.isLoading &&
                      mapState.geoJson != null &&
                      mapState.coverageData != null &&
                      areaPolygons.isEmpty)
                    Positioned(
                      bottom: 100,
                      left: 20,
                      right: 20,
                      child: Card(
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                size: 24,
                                color: Colors.blue.shade600,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'No map data available for this area',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.blue.shade800,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                  // Show message when app is starting and no data yet (initial state)
                  if (!mapState.isLoading &&
                      mapState.geoJson == null &&
                      mapState.coverageData == null)
                    Positioned(
                      bottom: 100,
                      left: 20,
                      right: 20,
                      child: Card(
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Expanded(
                                child: Text(
                                  'Initializing map data...',
                                  style: TextStyle(fontSize: 14),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  ref
                                      .read(mapControllerProvider.notifier)
                                      .loadInitialData(forceRefresh: true);
                                },
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                  // // Reset Button
                  if (!mapState.isLoading)
                    Positioned(
                      top: 5,
                      left: 5,
                      child: FloatingActionButton(
                        mini: true,
                        backgroundColor: Colors.white.withValues(alpha: 0.8),
                        onPressed: () => _resetToCountryView(
                          currentLevel: mapState.currentLevel,
                        ),
                        child: const Icon(Icons.home, color: Colors.grey),
                      ),
                    ),
                  // Legend
                  if (!mapState.isLoading &&
                      mapState.geoJson != null &&
                      mapState.coverageData != null)
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
                              if (mapState.currentLevel == 'union' ||
                                  mapState.currentLevel == 'ward' ||
                                  mapState.currentLevel == 'subblock')
                                const VaccineCenterInfoOverlayWidget(),
                              const Text(
                                'Coverage %',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              MapLegendItem(
                                color: CoverageColors.veryLow,
                                label: '<80%',
                              ),
                              MapLegendItem(
                                color: CoverageColors.low,
                                label: '80-85%',
                              ),
                              MapLegendItem(
                                color: CoverageColors.medium,
                                label: '85-90%',
                              ),
                              MapLegendItem(
                                color: CoverageColors.high,
                                label: '90-95%',
                              ),
                              MapLegendItem(
                                color: CoverageColors.veryHigh,
                                label: '>95%',
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
    );
  }
}
