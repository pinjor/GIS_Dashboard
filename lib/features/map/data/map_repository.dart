import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:archive/archive.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gis_dashboard/core/network/connectivity_service.dart';
import 'package:gis_dashboard/core/network/dio_client_provider.dart';
import 'package:gis_dashboard/core/network/network_error_handler.dart';

import '../../../core/utils/utils.dart';
import '../domain/vaccine_coverage_response.dart';

final mapRepositoryProvider = Provider<MapRepository>((ref) {
  return MapRepository(
    client: ref.watch(dioClientProvider),
    connectivityService: ref.watch(connectivityServiceProvider),
  );
});

class MapRepository {
  final Dio _client;
  final ConnectivityService _connectivityService;

  MapRepository({
    required Dio client,
    required ConnectivityService connectivityService,
  }) : _client = client,
       _connectivityService = connectivityService;

  Future<String> fetchGeoJson({required String urlPath}) async {
    try {
      // Check internet connectivity first
      final hasInternet = await _connectivityService.hasInternetConnection();
      if (!hasInternet) {
        throw NetworkException(
          message:
              'No internet connection. Please check your network settings and try again.',
          type: NetworkErrorType.noInternet,
        );
      }

      logg.i("Fetching GeoJSON from $urlPath");
      final response = await _client.get(
        urlPath,
        options: Options(
          responseType: ResponseType.bytes,
          receiveTimeout: const Duration(
            seconds: 30,
          ), // Allow time for large files
        ),
      );
      logg.i('Response received with status: ${response.statusCode}');
      final bytes = response.data as List<int>;
      final archive = GZipDecoder().decodeBytes(bytes);
      final geoJson = String.fromCharCodes(archive);
      logg.i('Successfully decompressed GeoJSON data');
      return geoJson;
    } on DioException catch (e) {
      logg.e("Dio error fetching GeoJSON: $e");
      throw NetworkErrorHandler.handleDioError(e);
    } catch (e) {
      logg.e("Error fetching GeoJSON: $e");
      throw NetworkErrorHandler.handleGenericError(e);
    }
  }

  Future<VaccineCoverageResponse> fetchVaccinationCoverage({
    required String urlPath,
  }) async {
    try {
      // Check internet connectivity first
      final hasInternet = await _connectivityService.hasInternetConnection();
      if (!hasInternet) {
        throw NetworkException(
          message:
              'No internet connection. Please check your network settings and try again.',
          type: NetworkErrorType.noInternet,
        );
      }

      logg.i("Fetching vaccination coverage from $urlPath");
      final response = await _client.get(
        urlPath,
        options: Options(
          receiveTimeout: const Duration(
            seconds: 20,
          ), // Reasonable timeout for JSON
        ),
      );
      final vaccineCoverageData = response.data as Map<String, dynamic>;
      logg.i('Successfully received vaccination coverage data');

      return VaccineCoverageResponse.fromJson(vaccineCoverageData);
    } on DioException catch (e) {
      logg.e("Dio error fetching vaccination coverage: $e");
      throw NetworkErrorHandler.handleDioError(e);
    } catch (e) {
      logg.e("Error fetching vaccination coverage: $e");
      throw NetworkErrorHandler.handleGenericError(e);
    }
  }

  Future<String> fetchEpiData({required String urlPath}) async {
    try {
      // Check internet connectivity first
      final hasInternet = await _connectivityService.hasInternetConnection();
      if (!hasInternet) {
        throw NetworkException(
          message:
              'No internet connection. Please check your network settings and try again.',
          type: NetworkErrorType.noInternet,
        );
      }

      logg.i("Fetching EPI data from $urlPath");
      final response = await _client.get(
        urlPath,
        options: Options(
          receiveTimeout: const Duration(seconds: 15), // Timeout for EPI data
        ),
      );
      final epiData = response.data;

      // Convert to JSON string if it's a Map
      String epiJsonString;
      if (epiData is Map<String, dynamic>) {
        epiJsonString = jsonEncode(epiData);
      } else if (epiData is String) {
        epiJsonString = epiData;
      } else {
        epiJsonString = epiData.toString();
      }

      logg.i('Successfully received EPI data');
      return epiJsonString;
    } on DioException catch (e) {
      logg.e("Dio error fetching EPI data: $e");
      throw NetworkErrorHandler.handleDioError(e);
    } catch (e) {
      logg.e("Error fetching EPI data: $e");
      throw NetworkErrorHandler.handleGenericError(e);
    }
  }

  /// Fetch EPI Center details data from the API
  Future<String> fetchEpiCenterData({required String urlPath}) async {
    try {
      // Check internet connectivity first
      if (!await _connectivityService.hasInternetConnection()) {
        throw Exception('No internet connection');
      }

      logg.i("Fetching EPI center data from $urlPath");

      // Create a separate Dio instance for EPI center calls with no base URL
      // since we're making calls to a different server
      final epiDio = Dio(
        BaseOptions(
          connectTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(seconds: 20),
          sendTimeout: const Duration(seconds: 15),
        ),
      );

      // Configure HTTP client to allow all certificates for this specific API
      if (epiDio.httpClientAdapter is IOHttpClientAdapter) {
        (epiDio.httpClientAdapter as IOHttpClientAdapter).createHttpClient =
            () {
              final client = HttpClient();
              client.badCertificateCallback = (cert, host, port) {
                // Allow all certificates for this specific API
                return true;
              };
              return client;
            };
      }
      logg.w('urlPath for epi center!!!!!!!!!!!!!!: $urlPath');
      final response = await epiDio.get(urlPath);
      log('Response received for epi center data!!!!!!!!!!!!!!!!!: $response');
      logg.i('Response details response $response');

      // Check if response is successful
      if (response.statusCode != 200) {
        throw Exception('Server returned status code: ${response.statusCode}');
      }

      final epiCenterData = response.data;
      final contentType = response.headers.value('content-type') ?? '';

      // Check if response contains HTML (indicates no data available)
      if (contentType.contains('text/html') ||
          (epiCenterData is String && epiCenterData.trim().startsWith('<'))) {
        logg.w('EPI center returned HTML response - no data available');
        throw Exception('EPI_CENTER_NO_DATA');
      }

      // Convert to JSON string if it's a Map
      String epiCenterJsonString;
      if (epiCenterData is Map<String, dynamic>) {
        epiCenterJsonString = jsonEncode(epiCenterData);

        // Additional validation: check if the JSON response actually contains data
        if (epiCenterData.isEmpty ||
            (epiCenterData.containsKey('error') &&
                epiCenterData['error'] != null)) {
          logg.w('EPI center returned empty or error JSON response');
          throw Exception('EPI_CENTER_NO_DATA');
        }
      } else if (epiCenterData is String) {
        // Check if string response is HTML
        if (epiCenterData.trim().startsWith('<')) {
          logg.w(
            'EPI center returned HTML string response - no data available',
          );
          throw Exception('EPI_CENTER_NO_DATA');
        }

        // Try to parse as JSON to validate
        try {
          final parsed = jsonDecode(epiCenterData);
          if (parsed is Map<String, dynamic>) {
            if (parsed.isEmpty ||
                (parsed.containsKey('error') && parsed['error'] != null)) {
              throw Exception('EPI_CENTER_NO_DATA');
            }
          }
          epiCenterJsonString = epiCenterData;
        } catch (e) {
          logg.w('EPI center returned invalid JSON string response');
          throw Exception('EPI_CENTER_NO_DATA');
        }
      } else {
        logg.w(
          'EPI center returned unexpected response type: ${epiCenterData.runtimeType}',
        );
        throw Exception('EPI_CENTER_NO_DATA');
      }

      logg.i('Successfully received valid EPI center JSON data');
      return epiCenterJsonString;
    } on DioException catch (e) {
      logg.e("Dio error fetching EPI center data: $e");
      logg.e("Error: ${e.error}");

      // Handle specific SSL certificate errors
      if (e.error.toString().contains('CERTIFICATE_VERIFY_FAILED') ||
          e.error.toString().contains('HandshakeException')) {
        throw Exception('SSL_CERTIFICATE_ERROR');
      }

      throw NetworkErrorHandler.handleDioError(e);
    } catch (e) {
      // Pass through our custom exceptions
      if (e.toString().contains('EPI_CENTER_NO_DATA') ||
          e.toString().contains('SSL_CERTIFICATE_ERROR')) {
        rethrow;
      }

      logg.e("Error fetching EPI center data: $e");
      throw NetworkErrorHandler.handleGenericError(e);
    }
  }
}
