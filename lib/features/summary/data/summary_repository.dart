import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gis_dashboard/core/network/dio_client_provider.dart';

import '../../../core/network/connectivity_service.dart';
import '../../../core/network/network_error_handler.dart';
import '../../../core/utils/utils.dart';
import '../domain/vaccine_coverage_response.dart';

final summaryRepositoryProvider = Provider(
  (ref) => SummaryRepository(
    dioClient: ref.watch(dioClientProvider),
    connectivityService: ref.watch(connectivityServiceProvider),
  ),
);

class SummaryRepository {
  final Dio _client;
  final ConnectivityService _connectivityService;

  SummaryRepository({
    required Dio dioClient,
    required ConnectivityService connectivityService,
  }) : _client = dioClient,
       _connectivityService = connectivityService;

  Future<VaccineCoverageResponse> fetchVaccinationCoverageSummary({
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

      // logg.i("Fetching vaccination coverage from $urlPath");
      final response = await _client.get(
        urlPath,
        options: Options(
          receiveTimeout: const Duration(
            seconds: 40,
          ), // Reasonable timeout for JSON
        ),
      );
      final vaccineCoverageData = response.data as Map<String, dynamic>;
      // logg.i('Successfully received vaccination coverage data');

      return VaccineCoverageResponse.fromJson(vaccineCoverageData);
    } on DioException catch (e) {
      logg.e("Dio error fetching vaccination coverage: $e");
      throw NetworkErrorHandler.handleDioError(e);
    } catch (e) {
      logg.e("Error fetching vaccination coverage: $e");
      throw NetworkErrorHandler.handleGenericError(e);
    }
  }
}
