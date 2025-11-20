import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gis_dashboard/features/epi_center/data/epi_center_repository.dart';
import 'package:gis_dashboard/features/epi_center/domain/epi_center_coords_response.dart';
import 'package:gis_dashboard/features/epi_center/domain/epi_center_details_response.dart';
import 'package:gis_dashboard/features/map/data/map_repository.dart';
import 'package:gis_dashboard/features/summary/domain/vaccine_coverage_response.dart';

import '../../features/map/domain/area_coords_geo_json_response.dart';
import '../../features/summary/data/summary_repository.dart';
import '../utils/utils.dart';

/// Data service for caching and managing vaccine coverage data
/// This helps avoid duplicate API calls when both map and summary screens need the same data
final dataServiceProvider = Provider<DataService>((ref) {
  return DataService(
    mapRepository: ref.read(mapRepositoryProvider),
    summaryRepository: ref.read(summaryRepositoryProvider),
    epiCenterRepository: ref.read(epiCenterRepositoryProvider),
  );
});

class DataService {
  final MapRepository _mapRepository;
  final SummaryRepository _summaryRepository;
  final EpiCenterRepository _epiCenterRepository;

  // In-memory cache
  // VaccineCoverageResponse? _cachedCoverageData;
  // String? _cachedGeoJson;
  // DateTime? _lastFetchTime;

  // // Cache duration - 5 minutes
  // static const _cacheDuration = Duration(minutes: 5);

  DataService({
    required MapRepository mapRepository,
    required SummaryRepository summaryRepository,
    required EpiCenterRepository epiCenterRepository,
  }) : _mapRepository = mapRepository,
       _summaryRepository = summaryRepository,
       _epiCenterRepository = epiCenterRepository;

  /// Get vaccination coverage data with caching and retry logic
  Future<VaccineCoverageResponse> getVaccinationCoverage({
    required String urlPath,
    bool forceRefresh = false,
  }) async {
    // if (!forceRefresh && _isCacheValid() && _cachedCoverageData != null) {
    //   return _cachedCoverageData!;
    // }

    // Retry logic for vaccination coverage
    VaccineCoverageResponse? data;
    Exception? lastError;

    for (int attempt = 1; attempt <= 3; attempt++) {
      try {
        data = await _summaryRepository.fetchVaccinationCoverageSummary(
          urlPath: urlPath,
        );
        // _cachedCoverageData = data;
        // _lastFetchTime = DateTime.now();
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
  Future<AreaCoordsGeoJsonResponse> fetchAreaGeoJsonCoordsData({
    required String urlPath,
    bool forceRefresh = false,
  }) async {
    // if (!forceRefresh && _isCacheValid() && _cachedGeoJson != null) {
    //   return _cachedGeoJson!;
    // }

    // Retry logic for GeoJSON
    AreaCoordsGeoJsonResponse? areaCoordsData;
    Exception? lastError;

    for (int attempt = 1; attempt <= 3; attempt++) {
      try {
        areaCoordsData = await _mapRepository.fetchAreaGeoJsonCoordsData(
          urlPath: urlPath,
        );
        // _cachedGeoJson = data;
        // _lastFetchTime = DateTime.now();
        return areaCoordsData;
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
  Future<EpiCenterCoordsResponse> getEpiCenterCoordsData({
    required String urlPath,
    bool forceRefresh = false,
  }) async {
    // EPI data doesn't need caching as it's specific to each drill-down level
    // and changes frequently based on area, but we'll add retry logic

    // String? data;
    Exception? lastError;

    for (int attempt = 1; attempt <= 2; attempt++) {
      // Fewer retries for EPI
      try {
        final data = await _epiCenterRepository.fetchEpiCenterCoordsData(
          urlPath: urlPath,
        );
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
  // bool _isCacheValid() {
  //   if (_lastFetchTime == null) return false;
  //   return DateTime.now().difference(_lastFetchTime!) < _cacheDuration;
  // }

  /// Clear cache manually
  // void clearCache() {
  //   _cachedCoverageData = null;
  //   _cachedGeoJson = null;
  //   _lastFetchTime = null;
  // }

  /// Get cached coverage data without making API call
  // VaccineCoverageResponse? getCachedCoverageData() {
  //   return _isCacheValid() ? _cachedCoverageData : null;
  // }

  /// Get EPI Center details data with retry logic
  Future<EpiCenterDetailsResponse> getEpiCenterDetailsData({
    required String urlPath,
    bool forceRefresh = false,
  }) async {
    Exception? lastError;

    // Try multiple times for EPI center data
    for (int attempt = 1; attempt <= 3; attempt++) {
      try {
        // logg.i("Fetching EPI center data (attempt $attempt): $urlPath");

        final data = await _epiCenterRepository.fetchEpiCenterDetailsData(
          urlPath: urlPath,
        );
        logg.i("Successfully fetched EPI center data on attempt $attempt");

        // logg.i("Successfully fetched EPI center data on attempt $attempt");
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

  /// Fetch GeoJSON data with fallback URLs (for city corporations)
  Future<AreaCoordsGeoJsonResponse> fetchAreaGeoJsonCoordsDataWithFallback({
    required List<String> urlPaths,
    bool forceRefresh = false,
  }) async {
    Exception? lastError;

    for (int i = 0; i < urlPaths.length; i++) {
      final urlPath = urlPaths[i];

      try {
        // logg.i(
        //   "Trying ${i == 0 ? 'UID-based' : 'name-based'} URL: $urlPath",
        // );

        final result = await fetchAreaGeoJsonCoordsData(
          urlPath: urlPath,
          forceRefresh: forceRefresh,
        );

        // logg.i(
        //   "✅ Success with ${i == 0 ? 'UID-based' : 'name-based'} URL",
        // );
        return result;
      } catch (e) {
        lastError = e is Exception ? e : Exception(e.toString());
        // logg.w(
        //   "❌ Failed with ${i == 0 ? 'UID-based' : 'name-based'} URL: $e",
        // );

        if (i < urlPaths.length - 1) {
          logg.i("🔄 Trying next URL strategy...");
          continue;
        }
      }
    }

    // logg.e("💥 All URL strategies failed for city corporation");
    throw lastError ?? Exception('All city corporation URL strategies failed');
  }

  /// Fetch coverage data with fallback URLs (for city corporations)
  Future<VaccineCoverageResponse> getVaccinationCoverageWithFallback({
    required List<String> urlPaths,
    bool forceRefresh = false,
  }) async {
    Exception? lastError;

    for (int i = 0; i < urlPaths.length; i++) {
      final urlPath = urlPaths[i];

      try {
        // logg.i(
        //   "Trying ${i == 0 ? 'UID-based' : 'name-based'} coverage URL: $urlPath",
        // );

        final result = await getVaccinationCoverage(
          urlPath: urlPath,
          forceRefresh: forceRefresh,
        );

        // logg.i(
        //   "✅ Success with ${isFirstAttempt ? 'UID-based' : 'name-based'} coverage URL",
        // );
        return result;
      } catch (e) {
        lastError = e is Exception ? e : Exception(e.toString());
        // logg.w(
        //   "❌ Failed with ${isFirstAttempt ? 'UID-based' : 'name-based'} coverage URL: $e",
        // );

        if (i < urlPaths.length - 1) {
          // logg.i("🔄 Trying next coverage URL strategy...");
          continue;
        }
      }
    }

    // logg.e("💥 All coverage URL strategies failed for city corporation");
    throw lastError ??
        Exception('All city corporation coverage URL strategies failed');
  }

  /// Fetch EPI data with fallback URLs (for city corporations)
  Future<EpiCenterCoordsResponse> getEpiCenterCoordsDataWithFallback({
    required List<String> urlPaths,
    bool forceRefresh = false,
  }) async {
    Exception? lastError;

    for (int i = 0; i < urlPaths.length; i++) {
      final urlPath = urlPaths[i];

      try {
        // logg.i(
        //   "Trying ${i == 0 ? 'UID-based' : 'name-based'} EPI URL: $urlPath",
        // );

        final result = await getEpiCenterCoordsData(
          urlPath: urlPath,
          forceRefresh: forceRefresh,
        );

        // logg.i(
        //   "✅ Success with ${i == 0 ? 'UID-based' : 'name-based'} EPI URL",
        // );
        return result;
      } catch (e) {
        lastError = e is Exception ? e : Exception(e.toString());
        // logg.w(
        //   "❌ Failed with ${i == 0 ? 'UID-based' : 'name-based'} EPI URL: $e",
        // );

        if (i < urlPaths.length - 1) {
          // logg.i("🔄 Trying next EPI URL strategy...");
          continue;
        }
      }
    }

    // logg.e("💥 All EPI URL strategies failed for city corporation");
    throw lastError ??
        Exception('All city corporation EPI URL strategies failed');
  }

  /// Get EPI Center details data by org_uid (for city corporation wards)
  Future<EpiCenterDetailsResponse> getEpiCenterDetailsByOrgUid({
    required String orgUid,
    required String year,
    bool forceRefresh = false,
  }) async {
    try {
      // logg.i('Fetching EPI center details by org_uid: $orgUid, year: $year');
      return await _epiCenterRepository.fetchEpiCenterDetailsByOrgUid(
        orgUid: orgUid,
        year: year,
      );
    } catch (e) {
      // logg.e('Error fetching EPI center details by org_uid: $e');
      rethrow;
    }
  }
}

// future plans (detailed)

// ✅ Summary: Key Improvements
// Improvement	Why It Matters	Status
// 🔁 Separate timestamps per cache entry	Prevents stale/invalidated data from affecting others	✅ Do this
// 🗺️ Multi-URL cache using Maps	Prevents data from being overwritten	✅ Do this
// 🧾 Log cache hits and misses	Debug visibility	✅ Do this
// 💾 Persistent cache (e.g., Hive, files)	Makes cache survive app restarts	Optional
// 🧪 Unit tests	Ensures correctness	Recommended
// 🧹 Fine-grained cache clearing	More control	Optional

// concise list
// 🔧 Caching Improvements – Concise List

// Use separate timestamps for each cached data type (GeoJSON, coverage, etc.).

// Cache data per URL using a Map<String, T> to prevent overwrites.

// Add logs for cache hits/misses to help debugging and visibility.

// Support persistent caching (e.g., with Hive or file storage) to survive app restarts.

// Implement unit tests to validate caching behavior under different conditions.

// Allow fine-grained cache clearing (per URL or per data type).
