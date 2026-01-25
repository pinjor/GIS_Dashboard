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

      // ✅ DEBUG: Log raw API response to verify session_count field exists
      if (response.data is Map<String, dynamic>) {
        final rawData = response.data as Map<String, dynamic>;
        logg.i("Session Plan API: Raw response keys: ${rawData.keys.toList()}");
        if (rawData.containsKey('session_count')) {
          logg.i("Session Plan API: ✅ session_count field found: ${rawData['session_count']} (type: ${rawData['session_count'].runtimeType})");
        } else {
          logg.w("Session Plan API: ⚠️ session_count field NOT found in response!");
          logg.w("Session Plan API: Available fields: ${rawData.keys.toList()}");
        }
        if (rawData.containsKey('features')) {
          final features = rawData['features'];
          if (features is List) {
            logg.i("Session Plan API: features count: ${features.length}");
          }
        }
      }

      final parsedResponse = SessionPlanCoordsResponse.fromJson(response.data);
      
      // ✅ DEBUG: Log parsed response to verify sessionCount is correctly parsed
      logg.i("Session Plan API: Parsed response - sessionCount: ${parsedResponse.sessionCount}, features: ${parsedResponse.features?.length ?? 0}");
      
      return parsedResponse;
    } on DioException catch (e) {
      logg.e("Dio error fetching session plans: $e");
      throw NetworkErrorHandler.handleDioError(e);
    } catch (e) {
      logg.e("Error fetching session plans: $e");
      throw NetworkErrorHandler.handleGenericError(e);
    }
  }
}
