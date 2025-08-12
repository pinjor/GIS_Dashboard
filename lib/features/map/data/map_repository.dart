import 'package:archive/archive.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gis_dashboard/core/network/dio_client_provider.dart';

import '../../../core/utils/utils.dart';
import '../domain/vaccine_coverage_response.dart';

final mapRepositoryProvider = Provider<MapRepository>((ref) {
  return MapRepository(client: ref.watch(dioClientProvider));
});

class MapRepository {
  final Dio _client;

  MapRepository({required Dio client}) : _client = client;

  Future<String> fetchGeoJson({required String urlPath}) async {
    try {
      logg.i("Fetching GeoJSON from $urlPath");
      final response = await _client.get(
        urlPath,
        options: Options(responseType: ResponseType.bytes),
      );
      logg.i('Response received: $response');
      final bytes = response.data as List<int>;
      final archive = GZipDecoder().decodeBytes(bytes);
      final geoJson = String.fromCharCodes(archive);
      logg.t('Decompressed geoJson: $geoJson');
      return geoJson;
    } catch (e) {
      throw Exception('Failed to fetch GeoJSON: $e');
    }
  }

  Future<VaccineCoverageResponse> fetchVaccinationCoverage({
    required String urlPath,
  }) async {
    try {
      logg.i("Fetching vaccination coverage from $urlPath");
      final response = await _client.get(urlPath);
      final vaccineCoverageData = response.data as Map<String, dynamic>;
      logg.i('Vaccination coverage data: $vaccineCoverageData');

      logg.i('Parsed vaccination coverage data: ${vaccineCoverageData.toString()}');
      return VaccineCoverageResponse.fromJson(vaccineCoverageData);
    } catch (e) {
      logg.e("Error fetching vaccination coverage: $e");
      throw Exception('Failed to fetch vaccination coverage: $e');
    }
  }
}
