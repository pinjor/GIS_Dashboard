import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gis_dashboard/core/common/constants/api_constants.dart';
import 'package:gis_dashboard/core/service/data_service.dart';

import '../../../../core/utils/utils.dart';
import 'map_state.dart';
import '../../domain/vaccine_coverage_response.dart';

final mapControllerProvider =
    StateNotifierProvider<MapControllerNotifier, MapState>((ref) {
      return MapControllerNotifier(dataService: ref.read(dataServiceProvider));
    });

class MapControllerNotifier extends StateNotifier<MapState> {
  final DataService _dataService;
  MapControllerNotifier({required DataService dataService})
    : _dataService = dataService,
      super(MapState());

  Future<void> loadInitialData({bool forceRefresh = false}) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      logg.i("Loading initial map data...");

      // Try to get cached data first
      final cachedCoverageData = _dataService.getCachedCoverageData();
      if (cachedCoverageData != null && !forceRefresh) {
        logg.i("Using cached map data");
        // Still need to load GeoJSON for map rendering
        final geoJson = await _dataService.getGeoJson(
          urlPath: ApiConstants.districtJsonPath,
          forceRefresh: forceRefresh,
        );

        state = state.copyWith(
          geoJson: geoJson,
          coverageData: cachedCoverageData,
          isLoading: false,
          error: null, // Clear any previous error
        );
        return;
      }

      final results = await Future.wait([
        _dataService.getGeoJson(
          urlPath: ApiConstants.districtJsonPath,
          forceRefresh: forceRefresh,
        ),
        _dataService.getVaccinationCoverage(
          urlPath: ApiConstants.districtCoveragePath25,
          forceRefresh: forceRefresh,
        ),
      ]);

      final geoJson = results[0] as String;
      final coverageData = results[1] as VaccineCoverageResponse;
      logg.i(
        'metadata: ${coverageData.metadata} year: ${coverageData.metadata?.year}',
      );
      logg.i(
        "Loaded Coverage data for ${coverageData.vaccines?.first.vaccineName} and ${coverageData.vaccines?.first.areas?.length} coverage areas",
      );

      state = state.copyWith(
        geoJson: geoJson,
        coverageData: coverageData,
        isLoading: false,
        error: null, // Clear any previous error
      );
    } catch (e) {
      logg.e("Error loading initial data: $e");
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load map data: $e',
      );
    }
  }

  Future<void> refreshMapData() async {
    await loadInitialData(forceRefresh: true);
  }

  // Add drill-down method later if needed
  Future<void> drillDown(String areaType, String? parentId) async {
    // Implementation for drilling down to different levels
    // This will be map-specific functionality
  }
}
