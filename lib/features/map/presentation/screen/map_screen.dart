import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gis_dashboard/config/coverage_colors.dart';
import 'package:gis_dashboard/core/common/widgets/header_title_icon_filter_widget.dart';
import 'package:gis_dashboard/core/providers/filter_provider.dart';
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

  void _resetToCountryView() {
    mapController.moveAndRotate(LatLng(23.6850, 90.3563), _initialZoom, 0);
  }

  @override
  Widget build(BuildContext context) {
    final mapState = ref.watch(mapControllerProvider);
    final filterState = ref.watch(filterProvider);

    // Parse polygons when we have both GeoJSON and coverage data
    List<AreaPolygon> areaPolygons = [];
    if (mapState.geoJson != null && mapState.coverageData != null) {
      areaPolygons = parseGeoJsonToPolygons(
        mapState.geoJson!,
        mapState.coverageData!,
        filterState.selectedVaccine,
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
                    Container(
                      color: Colors.white,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.error,
                              size: 64,
                              color: Colors.red,
                            ),
                            const SizedBox(height: 16),
                            Text('Error: ${mapState.error}'),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                ref
                                    .read(mapControllerProvider.notifier)
                                    .refreshMapData();
                              },
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  if (areaPolygons.isNotEmpty &&
                      !mapState.isLoading &&
                      mapState.error == null)
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
                      ),
                      children: [
                        // maybe the url needs an update
                        TileLayer(
                          urlTemplate:
                              'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                          subdomains: const ['a', 'b', 'c'],
                        ),
                        // District polygons only
                        PolygonLayer(polygons: _buildPolygons(areaPolygons)),
                      ],
                    ),

                  // Reset Button
                  Positioned(
                    top: 5,
                    left: 5,
                    child: FloatingActionButton(
                      mini: true,
                      backgroundColor: Colors.white.withValues(alpha: 0.8),
                      onPressed: _resetToCountryView,
                      child: const Icon(Icons.home, color: Colors.grey),
                    ),
                  ),
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
                  // Level Indicator
                  // Positioned(
                  //   bottom: 20,
                  //   left: 20,
                  //   child: Card(
                  //     child: Padding(
                  //       padding: const EdgeInsets.all(8.0),
                  //       child: Text(
                  //         'Level: ${mapState.currentLevel.toUpperCase()}',
                  //       ),
                  //     ),
                  //   ),
                  // ),
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
  final Color color;
  final String label;

  const _LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(width: 16, height: 16, color: color),
        const SizedBox(width: 4),
        Text(label),
      ],
    );
  }
}
