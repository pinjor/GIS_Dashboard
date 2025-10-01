import 'dart:convert';

import 'package:archive/archive.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gis_dashboard/core/network/connectivity_service.dart';
import 'package:gis_dashboard/core/network/dio_client_provider.dart';
import 'package:gis_dashboard/core/network/network_error_handler.dart';
import 'package:gis_dashboard/features/map/domain/area_coords_geo_json_response.dart';

import '../../../core/utils/utils.dart';

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

  /// Fetch and decompress GeoJSON data from the given URL, it is the
  /// universal method to fetch GeoJSON for any area level map data.
  Future<AreaCoordsGeoJsonResponse> fetchAreaGeoJsonCoordsData({
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
      // 💡 The only optional improvements are around progress reporting, utf8 decoding, and edge-case checks.
      logg.i("Fetching GeoJSON from $urlPath");
      final response = await _client.get(
        urlPath,
        options: Options(
          responseType: ResponseType.bytes,
          receiveTimeout: const Duration(
            seconds: 300, // as the file can be large
          ), // Allow time for large files
        ),
      );
      logg.i('Response received with status: ${response.statusCode}');
      // final bytes = response.data as List<int>;
      final archive = GZipDecoder().decodeBytes(response.data as List<int>);
      final areaCoordsGeoJsonData = String.fromCharCodes(archive);
      // logg.i('Successfully decompressed GeoJSON data');
      return AreaCoordsGeoJsonResponse.fromJson(
        jsonDecode(areaCoordsGeoJsonData) as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      logg.e("Dio error fetching GeoJSON: $e");
      throw NetworkErrorHandler.handleDioError(e);
    } catch (e) {
      logg.e("Error fetching GeoJSON: $e");
      throw NetworkErrorHandler.handleGenericError(e);
    }
  }
}
