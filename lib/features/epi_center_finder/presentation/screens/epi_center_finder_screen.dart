import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:latlong2/latlong.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../core/common/constants/constants.dart';
import '../../../../core/common/widgets/custom_loading_widget.dart';
import '../../../map/presentation/widget/map_tile_layer.dart';
import '../../domain/epi_center_result.dart';
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
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final state = ref.read(epiCenterFinderControllerProvider);
    final initialDate = state.startDate ?? DateTime.now();
    final endDate = state.endDate ?? DateTime.now();
    
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: endDate, // Can't be after end date
    );

    if (pickedDate != null) {
      // Ensure start date is not after end date
      final finalEndDate = endDate.isBefore(pickedDate) ? pickedDate : endDate;
      ref.read(epiCenterFinderControllerProvider.notifier).updateDateRange(
        pickedDate,
        finalEndDate,
      );
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final state = ref.read(epiCenterFinderControllerProvider);
    final startDate = state.startDate ?? DateTime.now();
    final initialDate = state.endDate ?? DateTime.now();
    
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: startDate, // Can't be before start date
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (pickedDate != null) {
      // Ensure end date is not before start date
      final finalStartDate = startDate.isAfter(pickedDate) ? pickedDate : startDate;
      ref.read(epiCenterFinderControllerProvider.notifier).updateDateRange(
        finalStartDate,
        pickedDate,
      );
    }
  }

  Future<void> _searchCenters() async {
    final state = ref.read(epiCenterFinderControllerProvider);
    final startDate = state.startDate ?? DateTime.now();
    final endDate = state.endDate ?? DateTime.now();
    
    // Validate date range
    if (startDate.isAfter(endDate)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Start date cannot be after end date.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    
    await ref
        .read(epiCenterFinderControllerProvider.notifier)
        .requestLocationAndSearch(startDate, endDate);
    
    // Auto-zoom to show user location and markers after search
    if (mounted) {
      _fitBoundsToResults();
    }
  }

  void _fitBoundsToResults() {
    final state = ref.read(epiCenterFinderControllerProvider);
    
    if (state.userLat == null || state.userLng == null) return;
    if (state.results.isEmpty) return;

    // Calculate bounds to include user location and all markers
    double minLat = state.userLat!;
    double maxLat = state.userLat!;
    double minLng = state.userLng!;
    double maxLng = state.userLng!;

    for (final result in state.results) {
      minLat = minLat < result.lat ? minLat : result.lat;
      maxLat = maxLat > result.lat ? maxLat : result.lat;
      minLng = minLng < result.lng ? minLng : result.lng;
      maxLng = maxLng > result.lng ? maxLng : result.lng;
    }

    // Add padding
    final latPadding = (maxLat - minLat) * 0.2;
    final lngPadding = (maxLng - minLng) * 0.2;

    final bounds = LatLngBounds(
      LatLng(minLat - latPadding, minLng - lngPadding),
      LatLng(maxLat + latPadding, maxLng + lngPadding),
    );

    // Fit bounds with animation
    _mapController.fitCamera(
      CameraFit.bounds(bounds: bounds, padding: const EdgeInsets.all(50)),
    );
  }

  Future<void> _launchGoogleMapsNavigation(double lat, double lng) async {
    final googleMapsUrl = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng&travelmode=driving',
    );
    
    if (await canLaunchUrl(googleMapsUrl)) {
      await launchUrl(googleMapsUrl, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open Google Maps.')),
        );
      }
    }
  }

  void _onMarkerTap(EpiCenterResult result) {
    // Select center and sync with table
    ref.read(epiCenterFinderControllerProvider.notifier).selectCenter(result.id);
    
    // Switch to table view if on map view
    if (_selectedTabIndex == 0) {
      setState(() {
        _selectedTabIndex = 1;
      });
    }
  }

  void _onTableRowTap(EpiCenterResult result) {
    // Select center and sync with map
    ref.read(epiCenterFinderControllerProvider.notifier).selectCenter(result.id);
    
    // Center map on selected marker
    _mapController.move(LatLng(result.lat, result.lng), _mapController.camera.zoom);
    
    // Switch to map view if on table view
    if (_selectedTabIndex == 1) {
      setState(() {
        _selectedTabIndex = 0;
      });
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

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(epiCenterFinderControllerProvider);
    final primaryColor = Color(Constants.primaryColor);

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
      ),
      body: Column(
        children: [
          // Date range pickers and search button
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey.shade100,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () => _selectStartDate(context),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.calendar_today, size: 20),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Start Date',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      state.startDate != null
                                          ? DateFormat('yyyy-MM-dd').format(state.startDate!)
                                          : 'Select Start Date',
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: InkWell(
                        onTap: () => _selectEndDate(context),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.calendar_today, size: 20),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'End Date',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      state.endDate != null
                                          ? DateFormat('yyyy-MM-dd').format(state.endDate!)
                                          : 'Select End Date',
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: state.isLoading ? null : _searchCenters,
                    icon: const Icon(Icons.search),
                    label: const Text('Search'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
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
                                onPressed: _searchCenters,
                                icon: const Icon(Icons.refresh),
                                label: const Text('Retry'),
                              ),
                            ],
                          ),
                        ),
                      )
                    : state.results.isEmpty
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
                                    state.startDate != null && state.endDate != null
                                        ? 'No EPI centers found within 5 km for the selected date range.'
                                        : 'No EPI centers found within 5 km for this date range.',
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
      onTap: () => setState(() => _selectedTabIndex = index),
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
        : const LatLng(23.6850, 90.3563); // Default to Bangladesh center

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
        MarkerLayer(
          markers: _buildMarkers(state.results, state.selectedCenterId),
        ),
      ],
    );
  }

  Widget _buildTableView(EpiCenterFinderState state) {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: state.results.length,
      itemBuilder: (context, index) {
        final result = state.results[index];
        final isSelected = result.id == state.selectedCenterId;

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          elevation: isSelected ? 4 : 1,
          color: isSelected ? Colors.blue.shade50 : Colors.white,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: (result.isFixedCenter ?? false)
                  ? Colors.blueAccent
                  : Colors.deepPurple,
              child: Icon(
                (result.isFixedCenter ?? false) ? Icons.home : Icons.local_hospital,
                color: Colors.white,
                size: 20,
              ),
            ),
            title: Text(
              result.name,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                // Show zone/ward information prominently if available
                if (result.cityCorporationName != null || result.zoneName != null || result.wardName != null) ...[
                  if (result.cityCorporationName != null)
                    Row(
                      children: [
                        Icon(Icons.location_city, size: 14, color: Colors.blue.shade700),
                        const SizedBox(width: 4),
                        Text(
                          result.cityCorporationName!,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.blue.shade700,
                          ),
                        ),
                      ],
                    ),
                  if (result.zoneName != null)
                    Row(
                      children: [
                        Icon(Icons.map, size: 14, color: Colors.orange.shade700),
                        const SizedBox(width: 4),
                        Text(
                          'Zone: ${result.zoneName}',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Colors.orange.shade700,
                          ),
                        ),
                      ],
                    ),
                  if (result.wardName != null)
                    Row(
                      children: [
                        Icon(Icons.location_on, size: 14, color: Colors.green.shade700),
                        const SizedBox(width: 4),
                        Text(
                          'Ward: ${result.wardName}',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Colors.green.shade700,
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 6),
                ],
                Text('Date: ${DateFormat('yyyy-MM-dd').format(result.sessionDate)}'),
                Text('Distance: ${result.distanceKm.toStringAsFixed(2)} km'),
                if (result.typeName != null) 
                  Text(
                    'Type: ${result.typeName}',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
              ],
            ),
            trailing: IconButton(
              icon: const Icon(Icons.navigation),
              color: Color(Constants.primaryColor),
              onPressed: () => _launchGoogleMapsNavigation(result.lat, result.lng),
              tooltip: 'Navigate',
            ),
            onTap: () => _onTableRowTap(result),
          ),
        );
      },
    );
  }
}
