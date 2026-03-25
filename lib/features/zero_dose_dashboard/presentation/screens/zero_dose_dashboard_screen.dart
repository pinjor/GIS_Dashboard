import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gis_dashboard/core/common/enums/vaccine_type.dart';
import 'package:latlong2/latlong.dart';
import '../../../../core/common/constants/constants.dart';
import '../../../../core/common/widgets/custom_loading_widget.dart';
import '../../../../core/utils/utils.dart';
import '../../../summary/presentation/controllers/summary_controller.dart';
import '../../../summary/domain/vaccine_coverage_response.dart';
import '../../../filter/filter.dart';
import '../../../map/presentation/controllers/map_controller.dart';
import '../../../map/presentation/widget/map_tile_layer.dart';
import '../../../map/utils/map_enums.dart';
import '../../../map/utils/map_utils.dart';
import '../../../map/domain/area_polygon.dart';
import '../widgets/zero_dose_bar_chart_widget.dart';

class ZeroDoseDashboardScreen extends ConsumerStatefulWidget {
  const ZeroDoseDashboardScreen({super.key});

  @override
  ConsumerState<ZeroDoseDashboardScreen> createState() =>
      _ZeroDoseDashboardScreenState();
}

class _ZeroDoseDashboardScreenState
    extends ConsumerState<ZeroDoseDashboardScreen> {
  bool _showChartTab = true;
  final MapController _embeddedMapController = MapController();
  DateTime? _lastFilterSyncAt;
  String? _lastAutoFitKey;

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
        child: const FilterDialogBoxWidget(
          isEpiContext: false,
          hideSubblock: true, // Hide subblock field in Zero Dose Dashboard
        ),
      ),
    );
  }

  String _getLocationName(String locationName) {
    if (locationName.isEmpty) return 'Bangladesh';
    return locationName.replaceAll(RegExp(r'\s*\(.*?\)'), '').trim();
  }

  @override
  Widget build(BuildContext context) {
    final summaryState = ref.watch(summaryControllerProvider);
    // ✅ Watch map controller and filter state to track changes
    final mapState = ref.watch(mapControllerProvider);
    final filterState = ref.watch(filterControllerProvider);
    final mapNotifier = ref.read(mapControllerProvider.notifier);

    // Use map-backed filtered data for consistent Chart+Map rendering
    final effectiveCoverageData = mapState.coverageData ?? summaryState.coverageData;
    final mapAreaName = mapState.currentAreaName ?? '';
    final locationName = _getLocationName(
      mapAreaName.isNotEmpty
          ? mapAreaName
          : summaryState.currentAreaName,
    );

    // Extract Penta-1 vaccine data and calculate top 5 zero dose areas
    List<Area> topZeroDoseAreas = [];

    if (effectiveCoverageData?.vaccines != null) {
      final pentaVaccine = effectiveCoverageData!.vaccines!.firstWhere(
        (vaccine) => vaccine.vaccineUid == VaccineType.penta1.uid,
        orElse: () => const Vaccine(),
      );

      if (pentaVaccine.areas != null && pentaVaccine.areas!.isNotEmpty) {
        final areasWithZeroDose = pentaVaccine.areas!.toList();
        areasWithZeroDose.sort((a, b) {
          final zeroDoseA = (a.target ?? 0) - (a.coverage ?? 0);
          final zeroDoseB = (b.target ?? 0) - (b.coverage ?? 0);
          return zeroDoseB.compareTo(zeroDoseA);
        });
        topZeroDoseAreas = areasWithZeroDose.take(5).toList();
      }
    }

    // ✅ Auto-load map data when user opens the Map tab (no extra click)
    if (!_showChartTab &&
        !mapState.isLoading &&
        (mapState.areaCoordsGeoJsonData == null || mapState.coverageData == null)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        mapNotifier.loadInitialData();
      });
    }

    // ✅ Listen to filter state changes - data will automatically update via summary controller
    // Also ensure map controller is aware of filter changes (it listens independently)
    ref.listen<FilterState>(filterControllerProvider, (previous, current) {
      if (previous != null &&
          current.lastAppliedTimestamp != null &&
          previous.lastAppliedTimestamp != current.lastAppliedTimestamp) {
        logg.i("Zero Dose Dashboard: Filter applied - data will update via summary controller");
        logg.i("Zero Dose Dashboard: Map will reflect new filters automatically when on Map tab");
        logg.i("Zero Dose Dashboard: Current filters - Division: ${current.selectedDivision}, District: ${current.selectedDistrict}, Upazila: ${current.selectedUpazila}");

        // ✅ CRITICAL: Summary chart data is derived from MapController updates.
        // So on any filter-apply, we *always* reload map data to the correct level.
        // This ensures BOTH Chart and Map tabs render the filtered result.
        if (_lastFilterSyncAt != current.lastAppliedTimestamp) {
          _lastFilterSyncAt = current.lastAppliedTimestamp;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _loadMapForFilters(mapNotifier, current);
          });
        }
      }
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(Constants.primaryColor),
        title: const Text(
          'Zero Dose Dashboard',
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
      body: Column(
        children: [
          _buildTabSwitcher(),
          Expanded(
            child: summaryState.isLoading
                ? const Center(child: CircularProgressIndicator())
                : summaryState.error != null
                    ? Center(
                        child: Text(
                          'Error: ${summaryState.error}',
                          style: const TextStyle(color: Colors.red),
                        ),
                      )
                    : _showChartTab
                        ? _buildChartTab(
                            coverageData: effectiveCoverageData,
                            topZeroDoseAreas: topZeroDoseAreas,
                            locationName: locationName,
                          )
                        : _buildMapTab(
                            mapState: mapState,
                            filterState: filterState,
                          ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabSwitcher() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildTabButton(
              label: 'Chart',
              selected: _showChartTab,
              onTap: () => setState(() => _showChartTab = true),
            ),
          ),
          Expanded(
            child: _buildTabButton(
              label: 'Map',
              selected: !_showChartTab,
              onTap: () => setState(() => _showChartTab = false),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: selected ? Color(Constants.primaryColor) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: selected ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildChartTab({
    required VaccineCoverageResponse? coverageData,
    required List<Area> topZeroDoseAreas,
    required String locationName,
  }) {
    if (topZeroDoseAreas.isEmpty) {
      return const Center(
        child: Text(
          'No Penta-1 data available',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return Column(
      children: [
        _buildTotalZeroDoseCard(coverageData),
        Expanded(
          child: ZeroDoseBarChartWidget(
            topAreas: topZeroDoseAreas,
            locationName: locationName,
            filterState: ref.read(filterControllerProvider),
          ),
        ),
      ],
    );
  }

  Widget _buildMapTab({
    required dynamic mapState,
    required FilterState filterState,
  }) {
    final List<AreaPolygon> areaPolygons =
        (mapState.areaCoordsGeoJsonData != null && mapState.coverageData != null)
            ? parseGeoJsonToPolygons(
                mapState.areaCoordsGeoJsonData!,
                mapState.coverageData!,
                filterState.selectedVaccine,
                mapState.currentLevel.value,
              )
            : <AreaPolygon>[];

    // ✅ Auto-fit map to the filtered polygons (so it expands/zooms like MapScreen)
    final autoFitKey =
        '${mapState.currentLevel.value}|${mapState.currentAreaName}|${filterState.lastAppliedTimestamp?.millisecondsSinceEpoch ?? 0}|${filterState.selectedYear}';
    if (!mapState.isLoading &&
        areaPolygons.isNotEmpty &&
        _lastAutoFitKey != autoFitKey) {
      _lastAutoFitKey = autoFitKey;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _fitMapToPolygons(areaPolygons);
      });
    }

    return Container(
      margin: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.grey[100],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: mapState.isLoading
            ? const Center(child: CustomLoadingWidget())
            : (mapState.areaCoordsGeoJsonData != null &&
                    mapState.coverageData != null)
                ? FlutterMap(
                    mapController: _embeddedMapController,
                    options: MapOptions(
                      initialCenter: const LatLng(23.6850, 90.3563),
                      initialZoom: 6.6,
                      minZoom: 3.5,
                      maxZoom: 18.0,
                    ),
                    children: [
                      const MapTileLayer(),
                      PolygonLayer(
                        polygons: areaPolygons.map((p) => p.polygon).toList(),
                      ),
                      MarkerLayer(markers: _buildAreaNameMarkers(areaPolygons)),
                    ],
                  )
                : Center(
                    child: Text(
                      'Map data not available yet',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ),
      ),
    );
  }

  List<Marker> _buildAreaNameMarkers(List<AreaPolygon> areaPolygons) {
    final mainAreaPolygons = areaPolygons
        .where(
          (polygon) =>
              !polygon.areaName.contains('(Part ') ||
              polygon.areaName.endsWith('(Part 1)'),
        )
        .toList();

    if (mainAreaPolygons.length > 150) return [];

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
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(3),
              border: Border.all(color: Colors.black38, width: 0.3),
            ),
            child: Text(
              displayName,
              style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w500),
            ),
          ),
        ),
      );
    }).toList();
  }

  void _fitMapToPolygons(List<AreaPolygon> polygons) {
    if (polygons.isEmpty) return;

    LatLngBounds? bounds;
    for (final ap in polygons) {
      for (final p in ap.polygon.points) {
        bounds = bounds == null ? LatLngBounds(p, p) : (bounds..extend(p));
      }
    }

    if (bounds == null) return;

    try {
      _embeddedMapController.fitCamera(
        CameraFit.bounds(
          bounds: bounds,
          padding: const EdgeInsets.all(28),
        ),
      );
    } catch (_) {
      // No-op: controller may not be ready yet
    }
  }

  void _loadMapForFilters(
    MapControllerNotifier mapNotifier,
    FilterState filterState,
  ) {
    final isCityCorporation =
        filterState.selectedAreaType == AreaType.cityCorporation;

    // Deepest → shallowest (subblock is hidden in Zero Dose Dashboard)
    if (isCityCorporation) {
      if (filterState.selectedZone != null && filterState.selectedZone != 'All') {
        mapNotifier.loadZoneData(zoneName: filterState.selectedZone!);
        return;
      }

      // If CC selected but no zone, show all CCs view (best available without extra selections)
      if (filterState.selectedCityCorporation != null &&
          filterState.selectedCityCorporation != 'All') {
        mapNotifier.loadAllCityCorporationsData(forceRefresh: true);
        return;
      }
    } else {
      if (filterState.selectedWard != null && filterState.selectedWard != 'All') {
        mapNotifier.loadWardData(wardName: filterState.selectedWard!);
        return;
      }
      if (filterState.selectedUnion != null && filterState.selectedUnion != 'All') {
        mapNotifier.loadUnionData(unionName: filterState.selectedUnion!);
        return;
      }
      if (filterState.selectedUpazila != null &&
          filterState.selectedUpazila != 'All') {
        mapNotifier.loadUpazilaData(upazilaName: filterState.selectedUpazila!);
        return;
      }
      if (filterState.selectedDistrict != null &&
          filterState.selectedDistrict != 'All') {
        mapNotifier.loadDistrictData(districtName: filterState.selectedDistrict!);
        return;
      }
      if (filterState.selectedDivision != 'All' &&
          filterState.selectedDivision.isNotEmpty) {
        mapNotifier.loadDivisionData(divisionName: filterState.selectedDivision);
        return;
      }
    }

    mapNotifier.loadInitialData(forceRefresh: false);
  }

  /// Build the total zero dose children summary card
  Widget _buildTotalZeroDoseCard(VaccineCoverageResponse? coverageData) {
    int totalZeroDoseCount = 0;

    if (coverageData?.vaccines != null) {
      // Find Penta-1 vaccine
      final pentaVaccine = coverageData!.vaccines!.firstWhere(
        (vaccine) => vaccine.vaccineUid == VaccineType.penta1.uid,
        orElse: () => const Vaccine(),
      );

      // Calculate total zero dose: totalTarget - totalCoverage
      // ✅ Allow negative values to show when coverage exceeds target
      if (pentaVaccine.totalTarget != null && pentaVaccine.totalCoverage != null) {
        totalZeroDoseCount = (pentaVaccine.totalTarget ?? 0) - (pentaVaccine.totalCoverage ?? 0);
        // Negative values are allowed - they indicate coverage exceeded target
      }
    }

    return Container(
      margin: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color(0xFF2196F3), // Blue color matching the bar chart
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Text section
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Total Zero Dose Children',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    totalZeroDoseCount.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            // Icon section (use shared children icon from assets)
            SvgPicture.asset(
              'assets/icons/children.svg',
              width: 36,
              height: 36,
              colorFilter: const ColorFilter.mode(
                Colors.white,
                BlendMode.srcIn,
              ),
            ),
          ],
        ),
      ),
    );
  }

}
