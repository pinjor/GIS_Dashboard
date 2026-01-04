import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/connectivity_service.dart';
import '../../../../core/network/dio_client_provider.dart';
import '../../../../core/network/network_error_handler.dart';
import '../../../../core/utils/utils.dart';
import '../domain/session_plan_coords_response.dart';

final sessionPlanRepositoryProvider = Provider<SessionPlanRepository>((ref) {
  return SessionPlanRepository(
    client: ref.watch(apiClientProvider),
    connectivityService: ref.watch(connectivityServiceProvider),
  );
});

class SessionPlanRepository {
  final Dio _client;
  final ConnectivityService _connectivityService;

  SessionPlanRepository({
    required Dio client,
    required ConnectivityService connectivityService,
  }) : _client = client,
       _connectivityService = connectivityService;

  Future<SessionPlanCoordsResponse> fetchSessionPlanCoords({
    required String urlPath,
  }) async {
    try {
      final hasInternet = await _connectivityService.hasInternetConnection();
      if (!hasInternet) {
        throw NetworkException(
          message: 'No internet connection',
          type: NetworkErrorType.noInternet,
        );
      }

      logg.i("Fetching session plan coords from $urlPath");
      final response = await _client.get(urlPath);

      return SessionPlanCoordsResponse.fromJson(response.data);
    } on DioException catch (e) {
      logg.e("Dio error fetching session plans: $e");
      throw NetworkErrorHandler.handleDioError(e);
    } catch (e) {
      logg.e("Error fetching session plans: $e");
      throw NetworkErrorHandler.handleGenericError(e);
    }
  }
}
