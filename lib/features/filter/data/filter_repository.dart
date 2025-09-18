import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gis_dashboard/core/common/constants/api_constants.dart';
import 'package:gis_dashboard/core/network/dio_client_provider.dart';
import 'package:gis_dashboard/features/filter/domain/area_response_model.dart';

import '../../../core/network/connectivity_service.dart';
import '../../../core/network/network_error_handler.dart';

final filterRepositoryProvider = Provider<FilterRepository>((ref) {
  final dio = ref.watch(dioClientProvider);
  final connectivityService = ref.watch(connectivityServiceProvider);
  return FilterRepository(
    client: dio,
    connectivityService: connectivityService,
  );
});

class FilterRepository {
  final Dio _client;
  final ConnectivityService _connectivityService;

  FilterRepository({
    required Dio client,
    required ConnectivityService connectivityService,
  }) : _client = client,
       _connectivityService = connectivityService;

  /// Fetches all divisions from the API
  Future<List<AreaResponseModel>> fetchAllDivisions() async {
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

      final uri = Uri(
        scheme: ApiConstants.urlScheme,
        host: ApiConstants.stagingHost,
        path: ApiConstants.filterByArea,
        queryParameters: {'type': 'division'},
      ).toString();
      print('FilterRepository: Fetching divisions from: $uri');
      final response = await _client.get(uri);
      print(
        'FilterRepository: Divisions API response status: ${response.statusCode}',
      );
      return (response.data['data'] as List)
          .map((e) => AreaResponseModel.fromJson(e))
          .toList();
    } catch (e) {
      print('FilterRepository: Error fetching divisions: $e');
      return Future.error('Failed to fetch divisions: $e');
    }
  }

  /// Fetches all districts from the API
  Future<List<AreaResponseModel>> fetchAllDistricts() async {
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

      final uri = Uri(
        scheme: ApiConstants.urlScheme,
        host: ApiConstants.stagingHost,
        path: ApiConstants.filterByArea,
        queryParameters: {'type': 'district'},
      ).toString();
      print('FilterRepository: Fetching districts from: $uri');
      final response = await _client.get(uri);
      print(
        'FilterRepository: Districts API response status: ${response.statusCode}',
      );
      return (response.data['data'] as List)
          .map((e) => AreaResponseModel.fromJson(e))
          .toList();
    } catch (e) {
      print('FilterRepository: Error fetching districts: $e');
      return Future.error('Failed to fetch districts: $e');
    }
  }

  /// Fetches all city corporations from the API
  Future<List<AreaResponseModel>> fetchAllCityCorporations() async {
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
      final uri = Uri(
        scheme: ApiConstants.urlScheme,
        host: ApiConstants.stagingHost,
        path: ApiConstants.filterByArea,
        queryParameters: {'type': 'city-corporation'},
      ).toString();
      final response = await _client.get(uri);
      return (response.data['data'] as List)
          .map((e) => AreaResponseModel.fromJson(e))
          .toList();
    } catch (e) {
      return Future.error('Failed to fetch city corporations');
    }
  }

  /// Fetches districts based on a given division ID: All districts under that division
  Future<List<AreaResponseModel>> fetchDistrictsByDivisionId(
    String divisionId,
  ) async {
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

      final uri = Uri(
        scheme: ApiConstants.urlScheme,
        host: ApiConstants.stagingHost,
        path: ApiConstants.filterByArea,
        queryParameters: {'parent_uid': divisionId},
      ).toString();
      final response = await _client.get(uri);
      return (response.data['data'] as List)
          .map((e) => AreaResponseModel.fromJson(e))
          .toList();
    } catch (e) {
      return Future.error('Failed to fetch districts');
    }
  }

  /// Fetch specific district by its UID

  /// Fetch specific city corporation by its UID
}
