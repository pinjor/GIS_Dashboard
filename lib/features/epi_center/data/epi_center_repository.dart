import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gis_dashboard/core/network/dio_client_provider.dart';
import 'package:gis_dashboard/features/epi_center/domain/epi_center_coords_response.dart';

import '../../../core/common/constants/api_constants.dart';
import '../../../core/network/connectivity_service.dart';
import '../../../core/network/network_error_handler.dart';
import '../../../core/utils/utils.dart';
import '../utils/epi_utils.dart';
import '../domain/epi_center_details_response.dart';

final epiCenterRepositoryProvider = Provider((ref) {
  return EpiCenterRepository(
    dioClient: ref.watch(dioClientProvider),
    connectivityService: ref.watch(connectivityServiceProvider),
  );
});

class EpiCenterRepository {
  final Dio _client;
  final ConnectivityService _connectivityService;

  EpiCenterRepository({
    required Dio dioClient,
    required ConnectivityService connectivityService,
  }) : _client = dioClient,
       _connectivityService = connectivityService;

  /// Fetch EPI center coordinates data from the API
  Future<EpiCenterCoordsResponse> fetchEpiCenterCoordsData({
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

      logg.i("Fetching EPI data from $urlPath");
      final response = await _client.get(
        urlPath,
        options: Options(
          receiveTimeout: const Duration(seconds: 15), // Timeout for EPI data
        ),
      );
      final epiData = response.data;

      // Convert to JSON string if it's a Map
      // String epiJsonString;
      // if (epiData is Map<String, dynamic>) {
      //   epiJsonString = jsonEncode(epiData);
      // } else if (epiData is String) {
      //   epiJsonString = epiData;
      // } else {
      //   epiJsonString = epiData.toString();
      // }

      // logg.i('Successfully received EPI data');
      return EpiCenterCoordsResponse.fromJson(epiData as Map<String, dynamic>);
    } on DioException catch (e) {
      logg.e("Dio error fetching EPI data: $e");
      throw NetworkErrorHandler.handleDioError(e);
    } catch (e) {
      logg.e("Error fetching EPI data: $e");
      throw NetworkErrorHandler.handleGenericError(e);
    }
  }

  /// Fetch EPI Center details data from the API
  Future<EpiCenterDetailsResponse> fetchEpiCenterDetailsData({
    required String urlPath,
  }) async {
    try {
      // Optional: skip if you trust Dio's error handling
      if (!await _connectivityService.hasInternetConnection()) {
        throw Exception('No internet connection');
      }

      final epiDio = Dio(
        BaseOptions(
          connectTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(seconds: 20),
          sendTimeout: const Duration(seconds: 15),
        ),
      );

      // Allow all SSL certs for this specific API
      if (epiDio.httpClientAdapter is IOHttpClientAdapter) {
        (epiDio.httpClientAdapter as IOHttpClientAdapter).createHttpClient =
            () {
              final client = HttpClient();
              client.badCertificateCallback = (_, _, _) => true;
              return client;
            };
      }

      final response = await epiDio.get(urlPath);

      if (response.statusCode != 200) {
        throw Exception('Server returned status code: ${response.statusCode}');
      }

      final rawData = response.data;
      final contentType = response.headers.value('content-type') ?? '';

      // Reject HTML responses
      if (contentType.contains('text/html') ||
          (rawData is String && rawData.trim().startsWith('<'))) {
        throw Exception('EPI_CENTER_NO_DATA');
      }

      // Decode and parse
      final parsedJson = decodeEpiCenterDetailsNestedJson(rawData);
      return EpiCenterDetailsResponse.fromJson(
        parsedJson as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      // SSL specific handling
      if (e.error.toString().contains('CERTIFICATE_VERIFY_FAILED') ||
          e.error.toString().contains('HandshakeException')) {
        throw Exception('SSL_CERTIFICATE_ERROR');
      }
      throw NetworkErrorHandler.handleDioError(e);
    } catch (e) {
      if (e.toString().contains('EPI_CENTER_NO_DATA') ||
          e.toString().contains('SSL_CERTIFICATE_ERROR')) {
        rethrow;
      }
      throw NetworkErrorHandler.handleGenericError(e);
    }
  }

  /// Fetch EPI center details data using org_uid (for city corporation wards)
  Future<EpiCenterDetailsResponse> fetchEpiCenterDetailsByOrgUid({
    required String orgUid,
    required String year,
  }) async {
    try {
      // Check internet connectivity first
      if (!await _connectivityService.hasInternetConnection()) {
        throw Exception('No internet connection');
      }

      // Generate the API URL
      final urlPath = ApiConstants.getEpiDetailsUrlByOrgUid(
        orgUid: orgUid,
        year: year,
      );

      logg.i("Fetching EPI details by org_uid from $urlPath");

      final epiDio = Dio(
        BaseOptions(
          connectTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(seconds: 20),
          sendTimeout: const Duration(seconds: 15),
        ),
      );

      // Allow all SSL certs for this specific API
      if (epiDio.httpClientAdapter is IOHttpClientAdapter) {
        (epiDio.httpClientAdapter as IOHttpClientAdapter).createHttpClient =
            () {
              final client = HttpClient();
              client.badCertificateCallback = (_, _, _) => true;
              return client;
            };
      }

      final response = await epiDio.get(urlPath);

      if (response.statusCode != 200) {
        throw Exception('Server returned status code: ${response.statusCode}');
      }

      final rawData = response.data;
      final contentType = response.headers.value('content-type') ?? '';

      // Reject HTML responses
      if (contentType.contains('text/html') ||
          (rawData is String && rawData.trim().startsWith('<'))) {
        throw Exception('EPI_CENTER_NO_DATA');
      }

      // Decode and parse
      final parsedJson = decodeEpiCenterDetailsNestedJson(rawData);
      return EpiCenterDetailsResponse.fromJson(
        parsedJson as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      // SSL specific handling
      if (e.error.toString().contains('CERTIFICATE_VERIFY_FAILED') ||
          e.error.toString().contains('HandshakeException')) {
        throw Exception('SSL_CERTIFICATE_ERROR');
      }
      throw NetworkErrorHandler.handleDioError(e);
    } catch (e) {
      if (e.toString().contains('EPI_CENTER_NO_DATA') ||
          e.toString().contains('SSL_CERTIFICATE_ERROR')) {
        rethrow;
      }
      throw NetworkErrorHandler.handleGenericError(e);
    }
  }
}
