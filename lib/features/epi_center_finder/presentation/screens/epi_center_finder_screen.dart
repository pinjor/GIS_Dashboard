import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:latlong2/latlong.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/common/constants/constants.dart';
import '../../../../core/common/widgets/custom_loading_widget.dart';
import '../../../map/presentation/widget/map_tile_layer.dart';
import '../../../map/domain/area_polygon.dart';
import '../../../map/utils/map_enums.dart';
import '../../../map/utils/map_utils.dart';
import '../../../filter/domain/filter_state.dart';
import '../../../session_plan/utils/session_plan_area_param_builder.dart';
import '../../domain/epi_center_result.dart';
import '../../../filter/presentation/controllers/filter_controller.dart';
import '../../../filter/presentation/widgets/geographic_filter_form.dart';
import '../widgets/epi_center_finder_filter_dialog.dart';
import '../widgets/epi_center_finder_details_panel.dart';
import '../../domain/epi_center_finder_state.dart';
import '../controllers/epi_center_finder_controller.dart';

class EpiCenterFinderScreen extends ConsumerStatefulWidget {
  const EpiCenterFinderScreen({super.key});

  @override
  ConsumerState<EpiCenterFinderScreen> createState() =>
      _EpiCenterFinderScreenState();
}

class _EpiCenterFinderScreenState
    extends ConsumerState<EpiCenterFinderScreen> {
  final MapController _mapController = MapController();
  final double _initialZoom = 13.0;
  int _selectedTabIndex = 0; // 0 = Map, 1 = Table

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _runSearch();
    });
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  Future<void> _runSearch() async {
    await ref
        .read(epiCenterFinderControllerProvider.notifier)
        .searchWithCurrentFilters();

    if (mounted) {
      _fitMapToContent();
    }
  }

  void _showFilterDialog() {
    showDialog<void>(
      context: context,
      builder: (_) => EpiCenterFinderFilterDialog(
        onApplied: _runSearch,
        onReset: _runSearch,
      ),
    );
  }

  String _buildFilterSummary(EpiCenterFinderState state, String areaSummary) {
    final start = state.startDate;
    final end = state.endDate;
    if (start == null || end == null) {
      return areaSummary;
    }

    final dateFormat = DateFormat('MM/dd/yyyy');
    final startStr = dateFormat.format(start);
    final endStr = dateFormat.format(end);
    final dateSummary =
        startStr == endStr ? startStr : '$startStr – $endStr';

    return '$dateSummary · $areaSummary';
  }

  GeographicLevel _getCurrentGeographicLevel(FilterState filterState) {
    if (!SessionPlanAreaParamBuilder.isPlaceholder(filterState.selectedSubblock)) {
      return GeographicLevel.subblock;
    }
    if (!SessionPlanAreaParamBuilder.isPlaceholder(filterState.selectedWard)) {
      return GeographicLevel.ward;
    }
    if (!SessionPlanAreaParamBuilder.isPlaceholder(filterState.selectedUnion)) {
      return GeographicLevel.union;
    }
    if (!SessionPlanAreaParamBuilder.isPlaceholder(filterState.selectedUpazila)) {
      return GeographicLevel.upazila;
    }
    if (!SessionPlanAreaParamBuilder.isPlaceholder(filterState.selectedDistrict)) {
      return GeographicLevel.district;
    }
    if (filterState.selectedDivision != 'All') {
      return GeographicLevel.division;
    }
    if (filterState.selectedAreaType == AreaType.cityCorporation) {
      if (!SessionPlanAreaParamBuilder.isPlaceholder(filterState.selectedZone)) {
        return GeographicLevel.zone;
      }
      if (!SessionPlanAreaParamBuilder.isCityCorporationUnselected(filterState)) {
        return GeographicLevel.cityCorporation;
      }
    }
    return GeographicLevel.country;
  }

  List<AreaPolygon> _parseAreaPolygons(EpiCenterFinderState state) {
    final geoJsonData = state.areaCoordsGeoJsonData;
    if (geoJsonData == null) return const [];
    return parseGeoJsonToPolygonsSimple(geoJsonData);
  }

  List<Marker> _buildAreaNameMarkers(List<AreaPolygon> areaPolygons) {
    final mainAreaPolygons = areaPolygons
        .where((polygon) => !polygon.areaName.contains('(Part '))
        .toList();

    if (mainAreaPolygons.length > 150) {
      return const [];
    }

    return mainAreaPolygons.map((areaPolygon) {
      final centroid = calculatePolygonCentroid(areaPolygon.polygon.points);
      var displayName = areaPolygon.areaName;
      if (displayName.contains('(Part 1)')) {
        displayName = displayName.replaceFirst(' (Part 1)', '');
      }

      return Marker(
        point: centroid,
        child: FittedBox(
          fit: BoxFit.none,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 1),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(3),
              border: Border.all(color: Colors.black38, width: 0.3),
            ),
            child: Text(
              displayName,
              style: const TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      );
    }).toList();
  }

  void _fitBoundsToResults() {
    final state = ref.read(epiCenterFinderControllerProvider);
    if (state.results.isEmpty) return;

    double minLat = state.results.first.lat;
    double maxLat = state.results.first.lat;
    double minLng = state.results.first.lng;
    double maxLng = state.results.first.lng;

    if (state.userLat != null && state.userLng != null) {
      minLat = minLat < state.userLat! ? minLat : state.userLat!;
      maxLat = maxLat > state.userLat! ? maxLat : state.userLat!;
      minLng = minLng < state.userLng! ? minLng : state.userLng!;
      maxLng = maxLng > state.userLng! ? maxLng : state.userLng!;
    }

    for (final result in state.results) {
      minLat = minLat < result.lat ? minLat : result.lat;
      maxLat = maxLat > result.lat ? maxLat : result.lat;
      minLng = minLng < result.lng ? minLng : result.lng;
      maxLng = maxLng > result.lng ? maxLng : result.lng;
    }

    final latSpan = (maxLat - minLat).abs();
    final lngSpan = (maxLng - minLng).abs();
    final latPadding = latSpan > 0.01 ? latSpan * 0.15 : 0.05;
    final lngPadding = lngSpan > 0.01 ? lngSpan * 0.15 : 0.05;

    final bounds = LatLngBounds(
      LatLng(minLat - latPadding, minLng - lngPadding),
      LatLng(maxLat + latPadding, maxLng + lngPadding),
    );

    _mapController.fitCamera(
      CameraFit.bounds(bounds: bounds, padding: const EdgeInsets.all(50)),
    );
  }

  void _fitMapToContent() {
    final state = ref.read(epiCenterFinderControllerProvider);
    final filterState = ref.read(filterControllerProvider);
    final areaPolygons = _parseAreaPolygons(state);

    if (areaPolygons.isNotEmpty) {
      final currentLevel = _getCurrentGeographicLevel(filterState);
      autoZoomToPolygons(areaPolygons, currentLevel, _mapController);
      return;
    }

    _fitBoundsToResults();
  }

  Future<void> _launchGoogleMapsNavigation(double lat, double lng) async {
    final googleMapsUrl = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng&travelmode=driving',
    );

    try {
      final launched = await launchUrl(
        googleMapsUrl,
        mode: LaunchMode.externalApplication,
      );
      if (!launched && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open Google Maps.')),
        );
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open Google Maps.')),
        );
      }
    }
  }

  void _onMarkerTap(EpiCenterResult result) {
    ref
        .read(epiCenterFinderControllerProvider.notifier)
        .loadCenterDetails(result);

    _launchGoogleMapsNavigation(result.lat, result.lng);
  }

  void _ensureDetailsForTableTab() {
    final state = ref.read(epiCenterFinderControllerProvider);
    if (state.results.isEmpty) return;

    final notifier = ref.read(epiCenterFinderControllerProvider.notifier);
    final selectedId = state.selectedCenterId ?? state.results.first.id;
    final selectedResult =
        notifier.resultById(selectedId) ?? state.results.first;

    if (state.selectedCenterDetails == null && !state.isLoadingDetails) {
      notifier.loadCenterDetails(selectedResult);
    }
  }

  List<Marker> _buildMarkers(List<EpiCenterResult> results, String? selectedId) {
    final markers = <Marker>[];
    
    // Add user location marker
    final state = ref.read(epiCenterFinderControllerProvider);
    if (state.userLat != null && state.userLng != null) {
      markers.add(
        Marker(
          point: LatLng(state.userLat!, state.userLng!),
          width: 30,
          height: 30,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(Icons.person_pin_circle, color: Colors.white, size: 20),
          ),
        ),
      );
    }

    // Add EPI center markers
    for (final result in results) {
      final isSelected = result.id == selectedId;
      final isFixedCenter = result.isFixedCenter ?? false;

      markers.add(
        Marker(
          point: LatLng(result.lat, result.lng),
          width: isSelected ? 25 : 19,
          height: isSelected ? 25 : 19,
          child: GestureDetector(
            onTap: () => _onMarkerTap(result),
            child: Tooltip(
              message: result.name,
              child: Container(
                width: isSelected ? 20 : 14,
                height: isSelected ? 20 : 14,
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.orange
                      : (isFixedCenter ? Colors.blueAccent : Colors.deepPurple),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: isSelected ? 2 : 0.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      blurRadius: isSelected ? 3 : 1,
                      offset: const Offset(0, 0.5),
                    ),
                  ],
                ),
                child: Center(
                  child: !isFixedCenter
                      ? FaIcon(
                          FontAwesomeIcons.syringe,
                          size: isSelected ? 12 : 10,
                          color: Colors.white,
                        )
                      : Icon(
                          Icons.home,
                          color: Colors.white,
                          size: isSelected ? 12 : 10,
                        ),
                ),
              ),
            ),
          ),
        ),
      );
    }

    return markers;
  }

  String _emptyStateMessage(EpiCenterFinderState state) {
    final start = state.startDate;
    final end = state.endDate;
    if (start == null || end == null) {
      return 'No EPI centers found for the selected date range and area.';
    }

    final dateFormat = DateFormat('MM/dd/yyyy');
    final startStr = dateFormat.format(start);
    final endStr = dateFormat.format(end);
    if (startStr == endStr) {
      return 'No EPI centers found for sessions on $startStr in the selected area.';
    }
    return 'No EPI centers found for sessions from $startStr to $endStr in the selected area.';
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(epiCenterFinderControllerProvider);
    final filterState = ref.watch(filterControllerProvider);
    final primaryColor = Color(Constants.primaryColor);
    final filterSummary = _buildFilterSummary(
      state,
      buildGeographicFilterSummary(filterState),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text(
          'EPI Center Finder',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.white),
            tooltip: 'Filter',
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: Colors.grey.shade100,
            child: Row(
              children: [
                Icon(Icons.place_outlined, color: primaryColor, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    filterSummary,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                TextButton(
                  onPressed: _showFilterDialog,
                  child: Text(
                    'Change',
                    style: TextStyle(color: primaryColor),
                  ),
                ),
              ],
            ),
          ),

          // Location error message
          if (state.locationError != null)
            Container(
              padding: const EdgeInsets.all(12),
              color: Colors.orange.shade50,
              child: Row(
                children: [
                  Icon(Icons.warning_amber, color: Colors.orange.shade700),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      state.locationError!,
                      style: TextStyle(color: Colors.orange.shade900),
                    ),
                  ),
                  if (state.locationError!.contains('permanently denied'))
                    TextButton(
                      onPressed: () async {
                        await openAppSettings();
                      },
                      child: const Text('Open Settings'),
                    ),
                ],
              ),
            ),

          // Tab bar (Map / Table)
          Container(
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: _buildTabButton(
                    0,
                    'Map',
                    Icons.map,
                    _selectedTabIndex == 0,
                    primaryColor,
                  ),
                ),
                Expanded(
                  child: _buildTabButton(
                    1,
                    'Table',
                    Icons.table_chart,
                    _selectedTabIndex == 1,
                    primaryColor,
                  ),
                ),
              ],
            ),
          ),

          // Content area
          Expanded(
            child: state.isLoading
                ? const Center(child: CustomLoadingWidget())
                : state.error != null
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.error_outline,
                                  size: 64, color: Colors.red[600]),
                              const SizedBox(height: 16),
                              Text(
                                state.error!,
                                style: const TextStyle(fontSize: 16),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 24),
                              ElevatedButton.icon(
                                onPressed: _runSearch,
                                icon: const Icon(Icons.refresh),
                                label: const Text('Retry'),
                              ),
                            ],
                          ),
                        ),
                      )
                    : state.results.isEmpty &&
                            state.areaCoordsGeoJsonData == null
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.location_off,
                                      size: 64, color: Colors.grey[400]),
                                  const SizedBox(height: 16),
                                  Text(
                                    _emptyStateMessage(state),
                                    style: const TextStyle(fontSize: 16),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          )
                        : _selectedTabIndex == 0
                            ? _buildMapView(state)
                            : _buildTableView(state),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(
    int index,
    String label,
    IconData icon,
    bool isSelected,
    Color primaryColor,
  ) {
    return InkWell(
      onTap: () {
        setState(() => _selectedTabIndex = index);
        if (index == 1) {
          _ensureDetailsForTableTab();
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? primaryColor.withOpacity(0.1) : Colors.transparent,
          border: Border(
            bottom: BorderSide(
              color: isSelected ? primaryColor : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: isSelected ? primaryColor : Colors.grey),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? primaryColor : Colors.grey,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMapView(EpiCenterFinderState state) {
    final userLocation = state.userLat != null && state.userLng != null
        ? LatLng(state.userLat!, state.userLng!)
        : const LatLng(23.6850, 90.3563);
    final filterState = ref.watch(filterControllerProvider);
    final areaPolygons = _parseAreaPolygons(state);
    final currentLevel = _getCurrentGeographicLevel(filterState);

    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: userLocation,
        initialZoom: _initialZoom,
        minZoom: 3.5,
        maxZoom: 18.0,
      ),
      children: [
        MapTileLayer(),
        if (areaPolygons.isNotEmpty)
          PolygonLayer(
            polygons: areaPolygons.map((polygon) => polygon.polygon).toList(),
          ),
        MarkerLayer(
          markers: _buildMarkers(state.results, state.selectedCenterId),
        ),
        if (areaPolygons.isNotEmpty && currentLevel.shouldShowAreaLabels)
          MarkerLayer(
            markers: _buildAreaNameMarkers(areaPolygons),
          ),
      ],
    );
  }

  Widget _buildTableView(EpiCenterFinderState state) {
    if (state.results.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            _emptyStateMessage(state),
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      );
    }

    final notifier = ref.read(epiCenterFinderControllerProvider.notifier);
    final selectedId = state.selectedCenterId ?? state.results.first.id;
    final selectedResult =
        notifier.resultById(selectedId) ?? state.results.first;
    final primaryColor = Color(Constants.primaryColor);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (state.results.length > 1)
          SizedBox(
            height: 52,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              scrollDirection: Axis.horizontal,
              itemCount: state.results.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final result = state.results[index];
                final isSelected = result.id == selectedId;
                return ChoiceChip(
                  label: Text(
                    result.name,
                    overflow: TextOverflow.ellipsis,
                  ),
                  selected: isSelected,
                  selectedColor: primaryColor.withValues(alpha: 0.15),
                  labelStyle: TextStyle(
                    color: isSelected ? primaryColor : Colors.black87,
                    fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                  onSelected: (_) {
                    notifier.loadCenterDetails(result);
                  },
                );
              },
            ),
          ),
        Expanded(
          child: EpiCenterFinderDetailsPanel(
            state: state,
            selectedResult: selectedResult,
          ),
        ),
      ],
    );
  }
}
