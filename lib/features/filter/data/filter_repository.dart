import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gis_dashboard/core/common/constants/api_constants.dart';
import 'package:gis_dashboard/core/network/dio_client_provider.dart';
import 'package:gis_dashboard/features/filter/domain/area_response_model.dart';

final filterRepositoryProvider = Provider<FilterRepository>((ref) {
  final dio = ref.watch(dioClientProvider);
  return FilterRepository(client: dio);
});

class FilterRepository {
  final Dio _client;

  FilterRepository({required Dio client}) : _client = client;

  Future<List<AreaResponseModel>> fetchAllDivisions() async {
    try {
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

  Future<List<AreaResponseModel>> fetchAllDistricts() async {
    try {
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

  Future<List<AreaResponseModel>> fetchAllCityCorporations() async {
    try {
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

  Future<List<AreaResponseModel>> fetchDistrictsByDivisionId(
    String divisionId,
  ) async {
    try {
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
}
