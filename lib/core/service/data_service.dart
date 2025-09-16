import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gis_dashboard/features/epi_center/domain/epi_center_details_response.dart';
import 'package:gis_dashboard/features/map/data/map_repository.dart';
import 'package:gis_dashboard/features/map/domain/vaccine_coverage_response.dart';

import '../utils/utils.dart';

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

  /// Get vaccination coverage data with caching and retry logic
  Future<VaccineCoverageResponse> getVaccinationCoverage({
    required String urlPath,
    bool forceRefresh = false,
  }) async {
    if (!forceRefresh && _isCacheValid() && _cachedCoverageData != null) {
      return _cachedCoverageData!;
    }

    // Retry logic for vaccination coverage
    VaccineCoverageResponse? data;
    Exception? lastError;

    for (int attempt = 1; attempt <= 3; attempt++) {
      try {
        data = await _repository.fetchVaccinationCoverage(urlPath: urlPath);
        _cachedCoverageData = data;
        _lastFetchTime = DateTime.now();
        return data;
      } catch (e) {
        lastError = e is Exception ? e : Exception(e.toString());
        if (attempt < 3) {
          // Wait before retry (exponential backoff)
          await Future.delayed(Duration(milliseconds: 500 * attempt));
          continue;
        }
      }
    }

    // If all retries failed, throw the last error
    throw lastError ?? Exception('Unknown error occurred');
  }

  /// Get GeoJSON data with caching and retry logic
  Future<String> getGeoJson({
    required String urlPath,
    bool forceRefresh = false,
  }) async {
    if (!forceRefresh && _isCacheValid() && _cachedGeoJson != null) {
      return _cachedGeoJson!;
    }

    // Retry logic for GeoJSON
    String? data;
    Exception? lastError;

    for (int attempt = 1; attempt <= 3; attempt++) {
      try {
        data = await _repository.fetchGeoJson(urlPath: urlPath);
        _cachedGeoJson = data;
        _lastFetchTime = DateTime.now();
        return data;
      } catch (e) {
        lastError = e is Exception ? e : Exception(e.toString());
        if (attempt < 3) {
          // Wait before retry (exponential backoff)
          await Future.delayed(
            Duration(milliseconds: 1000 * attempt),
          ); // Longer delay for GeoJSON
          continue;
        }
      }
    }

    // If all retries failed, throw the last error
    throw lastError ?? Exception('Unknown error occurred');
  }

  /// Get EPI data (vaccination centers) with retry logic
  Future<String> getEpiData({
    required String urlPath,
    bool forceRefresh = false,
  }) async {
    // EPI data doesn't need caching as it's specific to each drill-down level
    // and changes frequently based on area, but we'll add retry logic

    String? data;
    Exception? lastError;

    for (int attempt = 1; attempt <= 2; attempt++) {
      // Fewer retries for EPI
      try {
        data = await _repository.fetchEpiData(urlPath: urlPath);
        return data;
      } catch (e) {
        lastError = e is Exception ? e : Exception(e.toString());
        if (attempt < 2) {
          // Shorter delay for EPI data
          await Future.delayed(Duration(milliseconds: 500 * attempt));
          continue;
        }
      }
    }

    // If all retries failed, throw the last error
    throw lastError ?? Exception('EPI data unavailable');
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

  /// Get EPI Center details data with retry logic
  Future<EpiCenterDetailsResponse> getEpiCenterData({
    required String urlPath,
    bool forceRefresh = false,
  }) async {
    Exception? lastError;

    // Try multiple times for EPI center data
    for (int attempt = 1; attempt <= 3; attempt++) {
      try {
        logg.i("Fetching EPI center data (attempt $attempt): $urlPath");

        final data = await _repository.fetchEpiCenterData(urlPath: urlPath);

        logg.i("Successfully fetched EPI center data on attempt $attempt");
        return data;
      } catch (e) {
        lastError = e as Exception;
        logg.w("EPI center data fetch attempt $attempt failed: $e");

        // Don't retry for certain errors that won't benefit from retries
        if (e.toString().contains('EPI_CENTER_NO_DATA') ||
            e.toString().contains('SSL_CERTIFICATE_ERROR') ||
            e.toString().contains('No internet connection')) {
          logg.i("Not retrying for error type: ${e.toString()}");
          rethrow;
        }

        if (attempt < 3) {
          // Wait before retry for other errors
          await Future.delayed(Duration(milliseconds: 1000 * attempt));
          continue;
        }
      }
    }

    // If all retries failed, throw the last error
    throw lastError ?? Exception('EPI center data unavailable');
  }
}
