import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gis_dashboard/features/map/data/map_repository.dart';
import 'package:gis_dashboard/features/map/domain/vaccine_coverage_response.dart';

/// Data service for caching and managing vaccine coverage data
/// This helps avoid duplicate API calls when both map and summary screens need the same data
final dataServiceProvider = Provider<DataService>((ref) {
  return DataService(repository: ref.read(mapRepositoryProvider));
});

class DataService {
  final MapRepository _repository;

  // In-memory cache
  VaccineCoverageResponse? _cachedCoverageData;
  String? _cachedGeoJson;
  DateTime? _lastFetchTime;

  // Cache duration - 5 minutes
  static const _cacheDuration = Duration(minutes: 5);

  DataService({required MapRepository repository}) : _repository = repository;

  /// Get vaccination coverage data with caching
  Future<VaccineCoverageResponse> getVaccinationCoverage({
    required String urlPath,
    bool forceRefresh = false,
  }) async {
    if (!forceRefresh && _isCacheValid() && _cachedCoverageData != null) {
      return _cachedCoverageData!;
    }

    final data = await _repository.fetchVaccinationCoverage(urlPath: urlPath);
    _cachedCoverageData = data;
    _lastFetchTime = DateTime.now();
    return data;
  }

  /// Get GeoJSON data with caching
  Future<String> getGeoJson({
    required String urlPath,
    bool forceRefresh = false,
  }) async {
    if (!forceRefresh && _isCacheValid() && _cachedGeoJson != null) {
      return _cachedGeoJson!;
    }

    final data = await _repository.fetchGeoJson(urlPath: urlPath);
    _cachedGeoJson = data;
    _lastFetchTime = DateTime.now();
    return data;
  }

  /// Check if cached data is still valid
  bool _isCacheValid() {
    if (_lastFetchTime == null) return false;
    return DateTime.now().difference(_lastFetchTime!) < _cacheDuration;
  }

  /// Clear cache manually
  void clearCache() {
    _cachedCoverageData = null;
    _cachedGeoJson = null;
    _lastFetchTime = null;
  }

  /// Get cached coverage data without making API call
  VaccineCoverageResponse? getCachedCoverageData() {
    return _isCacheValid() ? _cachedCoverageData : null;
  }
}
