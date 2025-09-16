import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gis_dashboard/core/network/dio_client_provider.dart';

import '../../../core/network/connectivity_service.dart';
import '../../../core/network/network_error_handler.dart';
import '../../../core/utils/utils.dart';
import '../../map/utils/epi_utils.dart';
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
  Future<String> fetchEpiCoordsData({required String urlPath}) async {
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
  Future<EpiCenterDetailsResponse> fetchEpiCenterData({
    required String urlPath,
  }) async {
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

      // Check if response is successful
      if (response.statusCode != 200) {
        throw Exception('Server returned status code: ${response.statusCode}');
      }

      final rawData = response.data;
      final contentType = response.headers.value('content-type') ?? '';

      // Check if response contains HTML (indicates no data available)
      if (contentType.contains('text/html') ||
          (rawData is String && rawData.trim().startsWith('<'))) {
        logg.w('EPI center returned HTML response - no data available');
        throw Exception('EPI_CENTER_NO_DATA');
      }
      logg.i('successful step: 1');
      // final rawData = epiCenterData is String
      //     ? jsonEncode(epiCenterData)
      //     : epiCenterData;
      // logg.d('Raw EPI center data string length: ${rawData.length}');
      logg.i('successful step: 2');
      final epiCenterDetailedJsonObject = decodeEpiCenterDetailsNestedJson(
        rawData,
      );
      logg.i('successful step: 3');
      // log(
      //   'Parsed EPI center detailed json response:\n\n\n $epiCenterDetailedJsonObject',
      // );
      logg.i('Parsed EPI center detailed data Successfully!!!');
      log(
        'Parsed EPI center detailed json response:\n\n\n $epiCenterDetailedJsonObject',
      );
      final epiCenterDetailedData = EpiCenterDetailsResponse.fromJson(
        epiCenterDetailedJsonObject as Map<String, dynamic>,
      );
      logg.i('successful step: 4');
      logg.i('Parsed EPI center detailed data :) lets go!!!');
      return epiCenterDetailedData;

      // Convert to JSON string if it's a Map
      // String epiCenterJsonString;
      // if (epiCenterData is Map<String, dynamic>) {
      //   epiCenterJsonString = jsonEncode(epiCenterData);

      //   // Additional validation: check if the JSON response actually contains data
      //   if (epiCenterData.isEmpty ||
      //       (epiCenterData.containsKey('error') &&
      //           epiCenterData['error'] != null)) {
      //     logg.w('EPI center returned empty or error JSON response');
      //     throw Exception('EPI_CENTER_NO_DATA');
      //   }
      // } else if (epiCenterData is String) {
      //   // Check if string response is HTML
      //   if (epiCenterData.trim().startsWith('<')) {
      //     logg.w(
      //       'EPI center returned HTML string response - no data available',
      //     );
      //     throw Exception('EPI_CENTER_NO_DATA');
      //   }

      //   // Try to parse as JSON to validate
      //   try {
      //     final parsed = jsonDecode(epiCenterData);
      //     if (parsed is Map<String, dynamic>) {
      //       if (parsed.isEmpty ||
      //           (parsed.containsKey('error') && parsed['error'] != null)) {
      //         throw Exception('EPI_CENTER_NO_DATA');
      //       }
      //     }

      //     // now it is surely a valid JSON string of some sort
      //     epiCenterJsonString = epiCenterData;
      //   } catch (e) {
      //     logg.w('EPI center returned invalid JSON string response');
      //     throw Exception('EPI_CENTER_NO_DATA');
      //   }
      // } else {
      //   logg.w(
      //     'EPI center returned unexpected response type: ${epiCenterData.runtimeType}',
      //   );
      //   throw Exception('EPI_CENTER_NO_DATA');
      // }

      // logg.i('Successfully received valid EPI center JSON data');
      // final epiCenterDetailedJsonObject = decodeEpiCenterDetailsNestedJson(
      //   jsonDecode(epiCenterData),
      // );
      // final epiCenterDetailedData = EpiCenterDetailsResponse.fromJson(
      //   epiCenterDetailedJsonObject,
      // );
      // logg.d('Parsed EPI center detailed data');
      // log(
      //   'Parsed EPI center detailed json response:\n\n\n $epiCenterDetailedData',
      // );

      // return epiCenterDetailedData;
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
