import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gis_dashboard/core/common/widgets/header_title_icon_filter_widget.dart';
import 'package:gis_dashboard/features/filter/filter.dart';
import 'package:gis_dashboard/core/utils/utils.dart';
import 'package:gis_dashboard/features/map/presentation/widget/map_coverage_visualizer_card_widget.dart';
import 'package:gis_dashboard/features/map/presentation/widget/map_tile_layer.dart';
import 'package:gis_dashboard/features/map/presentation/widget/static_compass_direction_indicator_widget.dart';
import 'package:latlong2/latlong.dart';

import '../../../../core/common/widgets/custom_loading_widget.dart';
import '../../domain/area_polygon.dart';
import '../../domain/center_info.dart';
import '../../utils/map_utils.dart';
import '../controllers/map_controller.dart';
import '../../../epi_center/presentation/screen/epi_center_details_screen.dart';

// Helper class to store center point and zoom information

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
      // Dynamic sync service is now initialized through Riverpod providers
      // No manual initialization needed - uses live FilterController state
    });
  }

  // List<Polygon> _buildPolygons(List<AreaPolygon> areaPolygons) {
  //   return areaPolygons.map((areaPolygon) => areaPolygon.polygon).toList();
  // }

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
            padding: const EdgeInsets.symmetric(
              horizontal: 3,
              vertical: 1,
            ), // Reduced padding significantly
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(3), // Smaller border radius
              border: Border.all(
                color: Colors.black38,
                width: 0.3,
              ), // Thinner border
            ),
            child: Text(
              displayName,
              style: const TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w500,
              ), // Smaller font size and lighter weight
            ),
          ),
        ),
      );
    }).toList();
  }

  /// Calculate the centroid (center point) of a polygon - OPTIMIZED to prevent freezing
  LatLng _calculatePolygonCentroid(List<LatLng> points) {
    if (points.isEmpty) return const LatLng(0, 0);

    // Prevent freezing with very large polygon data
    if (points.length > 1000) {
      logg.w(
        "Large polygon with ${points.length} points - using sampling for performance",
      );
      // Sample every 10th point for very large polygons to prevent freezing
      final sampledPoints = <LatLng>[];
      for (int i = 0; i < points.length; i += 10) {
        sampledPoints.add(points[i]);
      }
      points = sampledPoints;
    }

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
                width: 19,
                height: 19,
                child: GestureDetector(
                  onTap: () =>
                      _onEpiMarkerTap(centerName, info?['org_uid'] ?? '', info),
                  child: Tooltip(
                    message: centerName,
                    child: SizedBox(
                      width: 14, // Force container size with SizedBox
                      height: 14, // Force container size with SizedBox
                      child: Container(
                        decoration: BoxDecoration(
                          color: isFixedCenter
                              ? Colors.blueAccent
                              : Colors.deepPurple,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 0.5),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.3),
                              blurRadius: 1,
                              offset: const Offset(0, 0.5),
                            ),
                          ],
                        ),
                        child: Center(
                          child: !isFixedCenter
                              ? FaIcon(
                                  FontAwesomeIcons.syringe,
                                  size: 10,
                                  color: Colors.white,
                                )
                              : Icon(Icons.home, color: Colors.white, size: 10),
                        ),
                      ),
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

  /// Calculate center point and appropriate zoom level for current level polygons
  CenterInfo _calculateCurrentLevelCenterAndZoom(
    List<AreaPolygon> polygons,
    String currentLevel,
  ) {
    if (polygons.isEmpty) {
      // Fallback to Bangladesh center
      logg.w(
        "No polygons available for centering, using default Bangladesh center",
      );
      return CenterInfo(
        center: const LatLng(23.6850, 90.3563),
        zoom: _initialZoom,
      );
    }

    // Calculate the bounding box of all polygons
    final bounds = _calculatePolygonsBounds(polygons);

    // Calculate center point using weighted centroid for better accuracy
    LatLng center = _calculateWeightedCentroid(polygons, bounds);

    // Calculate appropriate zoom level based on bounds size, level, and polygon density
    double zoom = _calculateZoomForBounds(
      bounds,
      currentLevel,
      polygons.length,
    );

    return CenterInfo(center: center, zoom: zoom);
  }

  /// Calculate weighted centroid for more accurate center point
  LatLng _calculateWeightedCentroid(
    List<AreaPolygon> polygons,
    LatLngBounds bounds,
  ) {
    if (polygons.length == 1) {
      // For single polygon, use its actual centroid
      return _calculatePolygonCentroid(polygons.first.polygon.points);
    }

    // For multiple polygons, calculate weighted centroid based on polygon area
    double totalWeightedLat = 0;
    double totalWeightedLng = 0;
    double totalWeight = 0;

    for (final polygon in polygons) {
      final polygonCenter = _calculatePolygonCentroid(polygon.polygon.points);
      final polygonArea = _calculatePolygonArea(polygon.polygon.points);

      // Use area as weight, with minimum weight of 1 to avoid zero weights
      final weight = math.max(polygonArea, 1.0);

      totalWeightedLat += polygonCenter.latitude * weight;
      totalWeightedLng += polygonCenter.longitude * weight;
      totalWeight += weight;
    }

    if (totalWeight > 0) {
      return LatLng(
        totalWeightedLat / totalWeight,
        totalWeightedLng / totalWeight,
      );
    } else {
      // Fallback to bounds center
      return LatLng(
        (bounds.north + bounds.south) / 2,
        (bounds.east + bounds.west) / 2,
      );
    }
  }

  /// Calculate approximate area of a polygon (for weighting purposes) - OPTIMIZED to prevent freezing
  double _calculatePolygonArea(List<LatLng> points) {
    if (points.length < 3) return 0.0;

    // Prevent freezing with very large polygon data
    if (points.length > 500) {
      logg.d(
        "Large polygon with ${points.length} points - using sampling for area calculation",
      );
      // Sample every 5th point for very large polygons to prevent freezing
      final sampledPoints = <LatLng>[];
      for (int i = 0; i < points.length; i += 5) {
        sampledPoints.add(points[i]);
      }
      points = sampledPoints;
    }

    double area = 0.0;
    for (int i = 0; i < points.length; i++) {
      final j = (i + 1) % points.length;
      area += points[i].longitude * points[j].latitude;
      area -= points[j].longitude * points[i].latitude;
    }
    return area.abs() / 2.0;
  }

  /// Calculate appropriate zoom level based on bounds size, current level, and polygon count
  double _calculateZoomForBounds(
    LatLngBounds bounds,
    String currentLevel,
    int polygonCount,
  ) {
    // Calculate the span of the bounds
    final latSpan = bounds.north - bounds.south;
    final lngSpan = bounds.east - bounds.west;
    final maxSpan = math.max(latSpan, lngSpan);

    // Base zoom calculation based on span size
    double baseZoom;
    if (maxSpan > 5.0) {
      baseZoom = 6.0; // Very large area (country level)
    } else if (maxSpan > 2.0) {
      baseZoom = 7.5; // Large area (multiple districts)
    } else if (maxSpan > 1.0) {
      baseZoom = 8.5; // Medium area (district level)
    } else if (maxSpan > 0.5) {
      baseZoom = 9.5; // Smaller area (upazila level)
    } else if (maxSpan > 0.2) {
      baseZoom = 11.0; // Small area (union level)
    } else if (maxSpan > 0.1) {
      baseZoom = 12.0; // Very small area (ward level)
    } else {
      baseZoom = 13.0; // Tiny area (subblock level)
    }

    // Adjust zoom based on polygon density (more polygons = zoom out a bit for overview)
    if (polygonCount > 50) {
      baseZoom -= 0.5; // Zoom out for many polygons
    } else if (polygonCount > 20) {
      baseZoom -= 0.3; // Slight zoom out for moderate polygon count
    } else if (polygonCount == 1) {
      baseZoom += 0.5; // Zoom in for single polygon
    }

    // Adjust zoom based on current level for optimal viewing
    switch (currentLevel) {
      case 'district':
        return math.max(baseZoom, 6.5); // Ensure minimum zoom for districts
      case 'upazila':
        return math.max(baseZoom, 8.0); // Ensure minimum zoom for upazilas
      case 'union':
        return math.max(baseZoom, 10.0); // Ensure minimum zoom for unions
      case 'ward':
        return math.max(baseZoom, 11.5); // Ensure minimum zoom for wards
      case 'subblock':
        return math.max(baseZoom, 12.5); // Ensure minimum zoom for subblocks
      default:
        return math.min(
          math.max(baseZoom, 6.0),
          15.0,
        ); // Clamp to reasonable range
    }
  }

  /// Auto-zoom to fit all polygons with padding
  void _autoZoomToPolygons(List<AreaPolygon> areaPolygons) {
    if (areaPolygons.isEmpty) return;

    final bounds = _calculatePolygonsBounds(areaPolygons);

    logg.i(
      "Auto-zooming to fit polygons: bounds from ${bounds.south}, ${bounds.west} to ${bounds.north}, ${bounds.east}",
    );

    // Calculate center of bounds
    final center = LatLng(
      (bounds.north + bounds.south) / 2,
      (bounds.east + bounds.west) / 2,
    );

    // Calculate appropriate zoom level based on bounds size
    final latSpan = bounds.north - bounds.south;
    final lngSpan = bounds.east - bounds.west;
    final maxSpan = math.max(latSpan, lngSpan);

    double zoom;
    if (maxSpan > 4.0) {
      zoom = 6.0;
    } else if (maxSpan > 2.0) {
      zoom = 7.0;
    } else if (maxSpan > 1.0) {
      zoom = 8.0;
    } else if (maxSpan > 0.5) {
      zoom = 9.0;
    } else if (maxSpan > 0.2) {
      zoom = 10.0;
    } else if (maxSpan > 0.1) {
      zoom = 11.0;
    } else {
      zoom = 12.0;
    }

    // Ensure zoom is within reasonable bounds
    zoom = math.min(math.max(zoom, 6.0), 15.0);

    try {
      mapController.moveAndRotate(center, zoom, 0);
      logg.i("Auto-zoom completed successfully to zoom level $zoom");
    } catch (e) {
      logg.e("Error auto-zooming: $e");
      // Fallback to center bounds with default zoom
      mapController.moveAndRotate(center, 8.0, 0);
    }
  }

  void _resetToCountryView({required String currentLevel}) {
    // Reset to country level first
    if (currentLevel != 'district') {
      ref.read(mapControllerProvider.notifier).resetToCountryLevel();
    }

    // Reset map view to initial position and zoom
    mapController.moveAndRotate(LatLng(23.6850, 90.3563), _initialZoom, 0);
  }

  void _centerViewForCurrentLevelPolygonMap({required String currentLevel}) {
    final mapState = ref.read(mapControllerProvider);

    // Parse current polygons to get the bounds
    List<AreaPolygon> currentPolygons = [];
    if (mapState.geoJson != null && mapState.coverageData != null) {
      final filterState = ref.read(filterControllerProvider);
      currentPolygons = parseGeoJsonToPolygons(
        mapState.geoJson!,
        mapState.coverageData!,
        filterState.selectedVaccine,
        currentLevel,
      );
    }

    if (currentPolygons.isEmpty) {
      logg.w("No polygons available to center view for level: $currentLevel");
      return;
    }

    // Calculate the center point and appropriate zoom for current level polygons
    final centerInfo = _calculateCurrentLevelCenterAndZoom(
      currentPolygons,
      currentLevel,
    );

    logg.i(
      "Centering view for $currentLevel: center=${centerInfo.center.latitude}, ${centerInfo.center.longitude}, zoom=${centerInfo.zoom}",
    );

    // Move map to calculated center with appropriate zoom
    mapController.moveAndRotate(centerInfo.center, centerInfo.zoom, 0);
  }

  /// Handle polygon tap for drilldown and filter sync
  void _onPolygonTap(LatLng tappedPoint, List<AreaPolygon> areaPolygons) {
    logg.i("Map tapped at: ${tappedPoint.latitude}, ${tappedPoint.longitude}");

    // Find which polygon was tapped
    AreaPolygon? tappedPolygon;
    for (final areaPolygon in areaPolygons) {
      if (isTappedPointInPolygon(tappedPoint, areaPolygon.polygon.points)) {
        tappedPolygon = areaPolygon;
        break;
      }
    }

    if (tappedPolygon != null) {
      logg.i("Tapped on: ${tappedPolygon.areaName}");
      // IMPORTANT: Perform filter sync BEFORE drilldown
      // This ensures the filter state is updated to match the tapped area
      _syncFiltersWithTappedArea(tappedPolygon);

      if (tappedPolygon.canDrillDown) {
        logg.i("Drilling down to: ${tappedPolygon.areaName}");
        _performDrillDown(tappedPolygon);
      } else {
        logg.i(
          "Cannot drill down to ${tappedPolygon.areaName} - no detailed data available",
        );
        showCustomSnackBar(
          context: context,
          message: 'No more detailed data available',
          color: Colors.orangeAccent.shade200,
        );
      }
    } else {
      logg.i("No polygon found at tapped location");
    }
  }

  /// Sync filter selections with the tapped area using DYNAMIC backend data
  void _syncFiltersWithTappedArea(AreaPolygon tappedPolygon) {
    try {
      // Get the map controller which now contains the sync functionality
      final mapController = ref.read(mapControllerProvider.notifier);

      // Check if filter data is ready
      if (!mapController.isFilterSyncReady) {
        logg.w('🔄 Filter data not ready yet - skipping sync');
        return;
      }

      final String areaId = tappedPolygon.areaId;
      final String areaName = tappedPolygon.areaName;

      logg.i("🎯 DYNAMIC SYNC: Starting for area '$areaName' (ID: '$areaId')");

      if (areaId.isEmpty || areaId == areaName) {
        logg.w("❓ No valid area ID for sync - skipping");
        return;
      }

      // Check if this area ID corresponds to a district
      if (mapController.isDistrictUid(areaId)) {
        logg.d("✅ Found district UID '$areaId' - proceeding with sync");

        // Perform the sync using the map controller's integrated functionality
        mapController.syncFiltersWithDistrict(areaId);
        //  .then((success) {
        //   if (success) {
        //     // Get the names for user feedback
        //     final districtName = mapController.getDistrictName(areaId);
        //     final divisionName = mapController.getDivisionNameForDistrict(
        //       areaId,
        //     );

        //     if (districtName != null && divisionName != null) {
        //       _showFilterSyncSuccessSnackBar(divisionName, districtName);
        //     }
        //   }
        // });
      } else {
        logg.d("ℹ️ Area ID '$areaId' is not a district - no sync needed");
        // This is expected for divisions, upazilas, etc.
      }
    } catch (e) {
      logg.e("❌ Error during dynamic filter sync: $e");
      // Don't show error to user - this is a supplementary feature
    }
  }

  /// Show success feedback when filter sync completes
  // void _showFilterSyncSuccessSnackBar(
  //   String divisionName,
  //   String districtName,
  // ) {
  //   ScaffoldMessenger.of(context).hideCurrentSnackBar();
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(
  //       content: Row(
  //         children: [
  //           const Icon(Icons.sync, color: Colors.white, size: 18),
  //           const SizedBox(width: 8),
  //           Expanded(
  //             child: Text(
  //               'Filters synced: $divisionName → $districtName',
  //               style: const TextStyle(fontSize: 14),
  //             ),
  //           ),
  //         ],
  //       ),
  //       backgroundColor: Colors.green.shade600,
  //       duration: const Duration(seconds: 2),
  //       behavior: SnackBarBehavior.floating,
  //       margin: const EdgeInsets.all(16),
  //     ),
  //   );
  // }

  /// Perform drilldown to the selected area
  void _performDrillDown(AreaPolygon tappedPolygon) {
    final mapNotifier = ref.read(mapControllerProvider.notifier);

    // Clear any existing error state before drilldown
    mapNotifier.clearError();

    // Determine the next level based on current level
    String nextLevel = getNextMapViewLevel(
      ref.read(mapControllerProvider).currentLevel,
    );

    // Show a subtle loading indicator and perform the drilldown
    showCustomSnackBar(
      context: context,
      message: 'Loading ${tappedPolygon.areaName}...',
      color: Colors.blue.shade600,
      isLoading: true,
    );

    // Perform the drilldown
    mapNotifier.drillDownToArea(
      areaName: tappedPolygon.areaName,
      slug: tappedPolygon.slug!,
      newLevel: nextLevel,
      parentSlug: tappedPolygon.parentSlug,
    );
  }

  /// Handle EPI marker tap - navigate to EPI center details screen
  void _onEpiMarkerTap(
    String centerName,
    String epiUid,
    Map<String, dynamic>? info,
  ) {
    logg.i("EPI marker tapped: $centerName (UID: $epiUid)");

    if (epiUid.isEmpty) {
      logg.w("EPI marker has no UID, cannot navigate to details");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('EPI center details not available'),
          backgroundColor: Colors.orangeAccent.shade200,
        ),
      );
      return;
    }

    // Get current context for navigation
    final currentState = ref.read(mapControllerProvider);
    final filterState = ref.read(filterControllerProvider);

    // Determine if we're in city corporation context
    String? ccUid;
    if (currentState.currentLevel == 'city_corporation') {
      // Extract city corporation UID from current navigation or filter
      ccUid = filterState.selectedCityCorporation;
    }

    // Navigate to EPI center details screen
    logg.i("🚀 Navigating to EPI center details:");
    logg.i("   EPI UID: $epiUid");
    logg.i("   Center Name: $centerName");
    logg.i("   CC UID: $ccUid");
    logg.i("   Current Level: ${currentState.currentLevel}");

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EpiCenterDetailsScreen(
          epiUid: epiUid,
          epiCenterName: centerName,
          ccUid: ccUid,
          currentLevel: int.tryParse(currentState.currentLevel),
        ),
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
    final filterState = ref.watch(filterControllerProvider);

    // Parse polygons when we have both GeoJSON and coverage data - MOVE BEFORE LISTENER
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
        areaPolygons = [];
      }
    }

    // Listen for state changes to trigger auto-zoom after drilldown
    // ! needs modifications, maybe responsible for not working auto-zoom when district filter applied
    ref.listen<dynamic>(mapControllerProvider, (previous, current) {
      // Hide any loading snackbars when state changes
      if (previous?.isLoading == true && current.isLoading == false) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
      }

      // Check if we just finished loading after a drilldown or filter application
      if (previous?.isLoading == true &&
          current.isLoading == false &&
          current.error == null &&
          // Allow auto-zoom for:
          // 1. All drilled-down levels (upazila, union, ward, subblock)
          // 2. Division level from filter
          // 3. District level from filter (navigationStack will have district entry)
          // 4. City corporation level from filter
          (current.currentLevel != 'district' || // All non-district levels
              (current.currentLevel ==
                      'district' && //? may cause issue, needs testing
                  current.navigationStack.isNotEmpty) || // District from filter
              current.currentLevel == 'division' || // Division from filter
              current.currentLevel ==
                  'city_corporation') && // City corporation from filter
          current.geoJson != null &&
          current.coverageData != null) {
        // Throttle auto-zoom to prevent rapid calls and freezing
        final now = DateTime.now();
        if (_lastAutoZoom != null &&
            now.difference(_lastAutoZoom!).inMilliseconds < 800) {
          logg.i("Auto-zoom throttled - too recent");
          return;
        }
        _lastAutoZoom = now;

        // Cancel any existing timer to prevent overlapping operations
        _autoZoomTimer?.cancel();

        // Show success indicator
        // _showSuccessSnackBar(current.currentAreaName ?? 'Area');

        // Schedule auto-zoom after tiles load
        _autoZoomTimer = Timer(const Duration(milliseconds: 1500), () {
          try {
            if (mounted) {
              // Parse fresh polygons for auto-zoom
              final filterState = ref.read(filterControllerProvider);
              final freshPolygons = parseGeoJsonToPolygons(
                current.geoJson!,
                current.coverageData!,
                filterState.selectedVaccine,
                current.currentLevel,
              );

              if (freshPolygons.isNotEmpty) {
                logg.i(
                  "Auto-zooming to ${freshPolygons.length} polygons at level: ${current.currentLevel}",
                );
                _autoZoomToPolygons(
                  freshPolygons,
                ); //? what if we try with old polygons e.g. areaPolygons?
              } else {
                logg.w("No polygons available for auto-zoom");
              }
            } else {
              logg.w("Skipping auto-zoom - widget unmounted");
            }
          } catch (e) {
            logg.w("Auto-zoom failed: $e");
          }
        });
      }
    });

    // Listen for filter year changes to refresh coverage data
    //! IMPORTANT: Move this listener AFTER polygon parsing to prevent premature triggers
    // This ensures we have the latest filter state when polygons are parsed
    //! ALSO IMPORTANT: This listener must be AFTER polygon parsing to ensure
    //! we have the latest filter state when polygons are parsed
    // this reloads coverage data when year changes
    ref.listen<FilterState>(filterControllerProvider, (previous, current) {
      if (previous != null && (previous.selectedYear != current.selectedYear)) {
        logg.i(
          "Filter year changed from ${previous.selectedYear} to ${current.selectedYear}",
        );

        // Refresh coverage data for the new year
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            ref
                .read(mapControllerProvider.notifier)
                .refreshCoverageForYearChange();
          }
        });
      }

      // Only trigger map loading when filters are actually applied (filter button pressed)
      if (previous != null &&
          current.lastAppliedTimestamp != null &&
          previous.lastAppliedTimestamp != current.lastAppliedTimestamp) {
        logg.i("Filter applied - triggering map data load");

        final bool divisionFilterApplied =
            current.selectedAreaType == 'district' &&
            current.selectedDivision != 'All' &&
            current.selectedDistrict == null;
        final bool districtFilterApplied =
            current.selectedAreaType == 'district' &&
            current.selectedDivision == 'All' &&
            current.selectedDistrict != null;
        final bool cityCorporationFilterApplied =
            current.selectedAreaType == 'city_corporation' &&
            current.selectedCityCorporation != null;
        final bool shouldResetToCountry =
            (current.selectedAreaType == 'district' &&
                current.selectedDivision == 'All' &&
                current.selectedDistrict == null) ||
            (current.selectedAreaType == 'city_corporation' &&
                current.selectedCityCorporation == null);

        if (divisionFilterApplied) {
          logg.i("Division filter applied: ${current.selectedDivision}");
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              ref
                  .read(mapControllerProvider.notifier)
                  .loadDivisionData(divisionName: current.selectedDivision);
            }
          });
        } else if (districtFilterApplied) {
          logg.i("District filter applied: ${current.selectedDistrict}");
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              ref
                  .read(mapControllerProvider.notifier)
                  .loadDistrictData(districtName: current.selectedDistrict!);
            }
          });
        } else if (cityCorporationFilterApplied) {
          logg.i(
            "City corporation filter applied: ${current.selectedCityCorporation}",
          );
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              ref
                  .read(mapControllerProvider.notifier)
                  .loadCityCorporationData(
                    cityCorporationName: current.selectedCityCorporation!,
                  );
            }
          });
        } else if (shouldResetToCountry) {
          logg.i("Resetting to country level view");
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              ref.read(mapControllerProvider.notifier).resetToCountryLevel();
            }
          });
        }
      }
    });

    // if (mapState.geoJson != null && mapState.coverageData != null) {
    //   try {
    //     areaPolygons = parseGeoJsonToPolygons(
    //       mapState.geoJson!,
    //       mapState.coverageData!,
    //       filterState.selectedVaccine,
    //       mapState.currentLevel,
    //     );
    //     logg.i("Successfully parsed ${areaPolygons.length} polygons");

    //     // Clear any existing errors when data is successfully loaded and parsed
    //     if (mapState.error != null && !mapState.isLoading) {
    //       WidgetsBinding.instance.addPostFrameCallback((_) {
    //         ref.read(mapControllerProvider.notifier).clearError();
    //       });
    //     }
    //   } catch (e) {
    //     logg.e("Error parsing polygons: $e");
    //     // Don't set error state here, just log it
    //     areaPolygons = [];
    //   }

    //   // Debug logging
    //   logg.i(
    //     "Map render state: loading=${mapState.isLoading}, error=${mapState.error ?? 'none'}, polygons=${areaPolygons.length}, level=${mapState.currentLevel}",
    //   );
    // }

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
                    onPressed:
                        _goBack, //! doesn't perform go back when upazila -> district is attempted! :( unfortunately
                    icon: const Icon(Icons.arrow_back),
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
                        MapTileLayer(),
                        // Area polygons
                        PolygonLayer(
                          polygons: areaPolygons
                              .map((areaPolygon) => areaPolygon.polygon)
                              .toList(),
                        ),

                        // EPI markers (vaccination centers) - Show for city corporations, upazila, union and deeper levels
                        if ((mapState.currentLevel == 'city_corporation' ||
                                mapState.currentLevel == 'upazila' ||
                                mapState.currentLevel == 'union' ||
                                mapState.currentLevel == 'ward' ||
                                mapState.currentLevel == 'subblock') &&
                            mapState.epiData != null)
                          MarkerLayer(
                            markers: _buildEpiMarkers(mapState.epiData),
                          ),

                        // Area name labels - ONLY show when drilled down (not on initial district view)
                        if (mapState.currentLevel != 'district')
                          MarkerLayer(
                            markers: _buildAreaNameMarkers(areaPolygons),
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
                  if (!mapState.isLoading) ...[
                    Positioned(
                      top: 5,
                      left: 5,
                      child: FloatingActionButton(
                        heroTag: null,
                        mini: true,
                        backgroundColor: Colors.white.withValues(alpha: 0.8),
                        onPressed: () => _resetToCountryView(
                          currentLevel: mapState.currentLevel,
                        ),
                        child: const Icon(Icons.home, color: Colors.grey),
                      ),
                    ),

                    // Static 4-direction indicator (N, E, S, W)
                    if (mapState.geoJson != null &&
                        mapState.coverageData != null)
                      StaticCompassDirectionIndicatorWidget(),

                    // Compass Icon button which centers current level polygon map
                    if (mapState.currentLevel != 'district')
                      Positioned(
                        bottom: 5,
                        left: 5,
                        child: FloatingActionButton(
                          heroTag: null,
                          mini: true,
                          backgroundColor: Colors.white.withValues(alpha: 0.9),
                          onPressed: () {
                            _centerViewForCurrentLevelPolygonMap(
                              currentLevel: mapState.currentLevel,
                            );
                            logg.d(
                              'Centered view to ${mapState.currentLevel} level',
                            );
                          },
                          child: const Icon(
                            Icons.center_focus_strong,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                  ],

                  // inside your build
                  if (!mapState.isLoading &&
                      mapState.geoJson != null &&
                      mapState.coverageData != null)
                    Positioned(
                      top: 5,
                      right: 5,
                      child: MapCoverageVisualizerCardWidget(
                        currentLevel: mapState.currentLevel,
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
