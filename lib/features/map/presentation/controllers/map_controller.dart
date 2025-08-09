import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gis_dashboard/core/common/constants/api_constants.dart';

import '../../../../core/utils/utils.dart';
import '../../data/map_repository.dart';
import '../../domain/map_state.dart';
import '../../domain/vaccine_coverage.dart';

final mapControllerProvider =
    StateNotifierProvider<MapControllerNotifier, MapState>((ref) {
      return MapControllerNotifier(
        mapRepository: ref.read(mapRepositoryProvider),
      );
    });

class MapControllerNotifier extends StateNotifier<MapState> {
  final MapRepository _mapRepository;
  MapControllerNotifier({required MapRepository mapRepository})
    : _mapRepository = mapRepository,
      super(MapState());

  Future<void> loadInitialData() async {
    state = state.copyWith(isLoading: true);
    try {
      logg.i("Loading initial map data...");

      final results = await Future.wait([
        _mapRepository.fetchGeoJson(urlPath: ApiConstants.districtJsonPath),
        _mapRepository.fetchVaccinationCoverage(
          urlPath: ApiConstants.districtCoveragePath25,
        ),
      ]);

      final geoJson = results[0] as String;
      final coverageData = results[1] as List<VaccineCoverage>;

      logg.i("Loaded GeoJSON and ${coverageData.length} coverage areas");

      state = state.copyWith(
        geoJson: geoJson,
        coverageData: coverageData,
        isLoading: false,
      );
    } catch (e) {
      logg.e("Error loading initial data: $e");
      state = state.copyWith(isLoading: false);
      throw Exception('Failed to load map data: $e');
    }
  }

  // Add drill-down method later if needed
}
