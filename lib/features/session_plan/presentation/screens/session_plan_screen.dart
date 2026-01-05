import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:latlong2/latlong.dart';
import 'package:gis_dashboard/features/map/domain/area_polygon.dart';
import 'package:gis_dashboard/features/map/presentation/widget/map_tile_layer.dart';
import 'package:gis_dashboard/features/map/utils/map_utils.dart';
import 'package:gis_dashboard/features/session_plan/domain/session_plan_coords_response.dart';
import 'package:gis_dashboard/features/session_plan/presentation/controllers/session_plan_controller.dart';
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

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      ref.read(sessionPlanControllerProvider.notifier).loadInitialData();
    });
  }

  void _onBack() {
    Navigator.pop(context);
  }

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
