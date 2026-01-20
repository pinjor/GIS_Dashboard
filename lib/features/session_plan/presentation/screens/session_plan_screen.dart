import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:latlong2/latlong.dart';
import 'package:gis_dashboard/features/map/domain/area_polygon.dart';
import 'package:gis_dashboard/features/map/presentation/widget/map_tile_layer.dart';
import 'package:gis_dashboard/features/map/utils/map_utils.dart';
import 'package:gis_dashboard/features/map/utils/map_enums.dart';
import 'package:gis_dashboard/features/session_plan/domain/session_plan_coords_response.dart';
import 'package:gis_dashboard/features/session_plan/presentation/controllers/session_plan_controller.dart';
import 'package:gis_dashboard/features/filter/filter.dart';
import 'package:gis_dashboard/features/map/presentation/controllers/map_controller.dart';
import 'package:gis_dashboard/core/utils/utils.dart';
import '../../../../core/common/constants/constants.dart';
import '../../../../core/common/widgets/custom_loading_widget.dart';

class SessionPlanScreen extends ConsumerStatefulWidget {
  const SessionPlanScreen({super.key});

  @override
  ConsumerState<SessionPlanScreen> createState() => _SessionPlanScreenState();
}

class _SessionPlanScreenState extends ConsumerState<SessionPlanScreen> {
  final MapController _mapController = MapController();
  final double _initialZoom = 6.6;
  Timer? _autoZoomTimer;
  DateTime? _lastAutoZoom;

  @override
  void initState() {
    super.initState();
    // ✅ OPTIMIZATION: Check if filters are already applied and load accordingly
    Future.delayed(Duration.zero, () {
      final filterState = ref.read(filterControllerProvider);
      
      // Check if any filters are applied (not just default country view)
      final hasFiltersApplied = (filterState.selectedDistrict != null &&
              filterState.selectedDistrict != 'All') ||
          (filterState.selectedCityCorporation != null &&
              filterState.selectedCityCorporation != 'All') ||
          (filterState.selectedUpazila != null &&
              filterState.selectedUpazila != 'All') ||
          (filterState.selectedUnion != null &&
              filterState.selectedUnion != 'All') ||
          (filterState.selectedWard != null &&
              filterState.selectedWard != 'All') ||
          (filterState.selectedSubblock != null &&
              filterState.selectedSubblock != 'All') ||
          (filterState.selectedZone != null &&
              filterState.selectedZone != 'All');
      
      if (hasFiltersApplied) {
        // Filters are already applied - load with current filter state
        logg.i("Session Plan: Filters detected on init - loading with filter state");
        ref.read(sessionPlanControllerProvider.notifier).loadDataWithFilter();
      } else {
        // No filters applied - load country level data
        logg.i("Session Plan: No filters detected on init - loading country level data");
        ref.read(sessionPlanControllerProvider.notifier).loadInitialData();
      }
    });
  }

  @override
  void dispose() {
    _autoZoomTimer?.cancel();
    super.dispose();
  }

  /// Auto-zoom to fit all polygons with padding
  void _autoZoomToPolygons(List<AreaPolygon> areaPolygons) {
    if (areaPolygons.isEmpty) return;

    // Get current map state to determine geographic level
    // This ensures we use the same level that map controller determined
    final mapState = ref.read(mapControllerProvider);
    GeographicLevel currentLevel = mapState.currentLevel;
    
    // If map state doesn't have a valid level, determine from filter state
    if (currentLevel == GeographicLevel.country) {
      final filterState = ref.read(filterControllerProvider);
      
      // Check from deepest to shallowest level (same logic as map controller)
      if (filterState.selectedSubblock != null &&
          filterState.selectedSubblock != 'All') {
        currentLevel = GeographicLevel.subblock;
      } else if (filterState.selectedWard != null &&
          filterState.selectedWard != 'All') {
        currentLevel = GeographicLevel.ward;
      } else if (filterState.selectedUnion != null &&
          filterState.selectedUnion != 'All') {
        currentLevel = GeographicLevel.union;
      } else if (filterState.selectedUpazila != null &&
          filterState.selectedUpazila != 'All') {
        currentLevel = GeographicLevel.upazila;
      } else if (filterState.selectedZone != null &&
          filterState.selectedZone != 'All') {
        currentLevel = GeographicLevel.zone;
      } else if (filterState.selectedCityCorporation != null &&
          filterState.selectedCityCorporation != 'All') {
        currentLevel = GeographicLevel.cityCorporation;
      } else if (filterState.selectedDistrict != null &&
          filterState.selectedDistrict != 'All') {
        currentLevel = GeographicLevel.district;
      }
    }

    logg.i("Session Plan: Auto-zooming to level: ${currentLevel.value}");
    autoZoomToPolygons(areaPolygons, currentLevel, _mapController);
  }

  /// Show filter dialog
  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Color(Constants.cardColor),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
        insetPadding: const EdgeInsets.symmetric(horizontal: 16),
        child: const FilterDialogBoxWidget(isEpiContext: false),
      ),
    );
  }

  // void _onBack() {
  //   Navigator.pop(context);
  // }

  Future<void> _launchMapsUrl(double lat, double lng) async {
    final googleMapsUrl = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$lat,$lng',
    );
    if (await canLaunchUrl(googleMapsUrl)) {
      await launchUrl(googleMapsUrl, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Could not open map.')));
      }
    }
  }

  List<Marker> _buildSessionPlanMarkers(SessionPlanCoordsResponse data) {
    if (data.features == null) return [];

    final markers = <Marker>[];

    for (final feature in data.features!) {
      final geometry = feature.geometry;
      final info = feature.info;

      if (geometry?.type == 'Point' && geometry?.coordinates != null) {
        final coords = geometry!.coordinates!;
        if (coords.length >= 2) {
          final lng = (coords[0] as num).toDouble();
          final lat = (coords[1] as num).toDouble();
          final centerName = info?.name ?? 'Session Plan Center';
          final isFixedCenter = info?.isFixedCenter ?? false;

          markers.add(
            Marker(
              point: LatLng(lat, lng),
              width: 19,
              height: 19,
              child: GestureDetector(
                onTap: () => _launchMapsUrl(lat, lng),
                child: Tooltip(
                  message: centerName,
                  child: SizedBox(
                    width: 14,
                    height: 14,
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
            ),
          );
        }
      }
    }
    return markers;
  }

  @override
  Widget build(BuildContext context) {
    final sessionPlanState = ref.watch(sessionPlanControllerProvider);

    // ✅ Listen to filter state changes and reload session plan data
    ref.listen<FilterState>(filterControllerProvider, (previous, current) {
      if (previous != null &&
          current.lastAppliedTimestamp != null &&
          previous.lastAppliedTimestamp != current.lastAppliedTimestamp) {
        logg.i("Session Plan: Filter applied - reloading session plan data");
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            ref.read(sessionPlanControllerProvider.notifier).loadDataWithFilter();
          }
        });
      }
    });

    // ✅ Listen to session plan state changes to trigger auto-zoom after data loads
    ref.listen<SessionPlanState>(sessionPlanControllerProvider, (previous, current) {
      // Check if we just finished loading after a filter application
      if (previous?.isLoading == true &&
          current.isLoading == false &&
          current.error == null &&
          current.areaCoordsGeoJsonData != null) {
        // Throttle auto-zoom to prevent rapid calls
        final now = DateTime.now();
        if (_lastAutoZoom != null &&
            now.difference(_lastAutoZoom!).inMilliseconds < 800) {
          logg.i("Session Plan: Auto-zoom throttled - too recent");
          return;
        }
        _lastAutoZoom = now;

        // Cancel any existing timer
        _autoZoomTimer?.cancel();

        // Schedule auto-zoom after tiles load
        _autoZoomTimer = Timer(const Duration(milliseconds: 1500), () {
          try {
            if (mounted && current.areaCoordsGeoJsonData != null) {
              // Parse fresh polygons for auto-zoom
              final freshPolygons = parseGeoJsonToPolygonsSimple(
                current.areaCoordsGeoJsonData!,
              );

              if (freshPolygons.isNotEmpty) {
                logg.i(
                  "Session Plan: Auto-zooming to ${freshPolygons.length} polygons",
                );
                _autoZoomToPolygons(freshPolygons);
              } else {
                logg.w("Session Plan: No polygons available for auto-zoom");
              }
            }
          } catch (e) {
            logg.w("Session Plan: Auto-zoom failed: $e");
          }
        });
      }
    });

    // Parse polygons
    List<AreaPolygon> areaPolygons = [];
    if (sessionPlanState.areaCoordsGeoJsonData != null) {
      areaPolygons = parseGeoJsonToPolygonsSimple(
        sessionPlanState.areaCoordsGeoJsonData!,
      );
    }

    // Auto-zoom if markers are available?
    // For now we stick to country view unless user wants specific behavior,
    // but the MapScreen logic to auto-zoom to polygon bounds is good.
    // However, since we are showing country map initially, default zoom is fine.

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(Constants.primaryColor),
        title: const Text(
          'Session Plans',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          // ✅ Add filter button to AppBar
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.white),
            onPressed: _showFilterDialog,
            tooltip: 'Filter',
          ),
        ],
      ),
      body: Stack(
        children: [
          if (sessionPlanState.isLoading)
            Container(
              color: Colors.black.withOpacity(0.1),
              child: const Center(child: CustomLoadingWidget()),
            ),

          if (!sessionPlanState.isLoading &&
              sessionPlanState.areaCoordsGeoJsonData != null)
            FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: const LatLng(23.6850, 90.3563),
                initialZoom: _initialZoom,
                minZoom: 3.5,
                maxZoom: 18.0,
              ),
              children: [
                MapTileLayer(),
                PolygonLayer(
                  polygons: areaPolygons.map((e) => e.polygon).toList(),
                ),
                if (sessionPlanState.sessionPlanCoordsData != null)
                  MarkerLayer(
                    markers: _buildSessionPlanMarkers(
                      sessionPlanState.sessionPlanCoordsData!,
                    ),
                  ),
              ],
            ),

          if (sessionPlanState.error != null)
            Center(child: Text("Error: ${sessionPlanState.error}")),
        ],
      ),
    );
  }
}
