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

      logg.i("Session Plan Repository: 🔍🔍🔍 Fetching from FULL URL: $urlPath");
      logg.i("Session Plan Repository: 🔍 Making GET request...");
      final response = await _fetchWithAdaptiveLimit(urlPath);
      logg.i("Session Plan Repository: ✅ Response received - Status: ${response.statusCode}");
      
      // ✅ CRITICAL: Log response size to check if we got data
      if (response.data != null) {
        if (response.data is Map) {
          final dataMap = response.data as Map;
          logg.i("Session Plan Repository: 🔍 Response data type: Map with ${dataMap.length} keys");
          logg.i("Session Plan Repository: 🔍 Response keys: ${dataMap.keys.toList()}");
        } else {
          logg.w("Session Plan Repository: ⚠️ Response data is not a Map: ${response.data.runtimeType}");
        }
      } else {
        logg.e("Session Plan Repository: ❌❌❌ Response data is NULL!");
      }

      // ✅ CRITICAL DEBUG: Log raw API response to verify session_count field exists
      if (response.data is Map<String, dynamic>) {
        final rawData = response.data as Map<String, dynamic>;
        logg.i("Session Plan API: 🔍🔍🔍 Raw response keys: ${rawData.keys.toList()}");
        if (rawData.containsKey('session_count')) {
          final sessionCountValue = rawData['session_count'];
          logg.i("Session Plan API: ✅✅✅ session_count field found: $sessionCountValue (type: ${sessionCountValue.runtimeType})");
          if (sessionCountValue == 0) {
            logg.e("Session Plan API: ❌❌❌ session_count is 0 - API returned no sessions!");
            logg.e("Session Plan API: ❌ This means either:");
            logg.e("Session Plan API: ❌   1. The area parameter is wrong");
            logg.e("Session Plan API: ❌   2. The date range has no sessions");
            logg.e("Session Plan API: ❌   3. The API endpoint is incorrect");
          }
        } else {
          logg.e("Session Plan API: ❌❌❌ session_count field NOT found in response!");
          logg.e("Session Plan API: Available fields: ${rawData.keys.toList()}");
        }
        if (rawData.containsKey('features')) {
          final features = rawData['features'];
          if (features is List) {
            logg.i("Session Plan API: features count: ${features.length}");
            if (features.isEmpty) {
              logg.w("Session Plan API: ⚠️ features array is empty - no session plan markers to display");
            }
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

  Future<Response<dynamic>> _fetchWithAdaptiveLimit(String urlPath) async {
    try {
      return await _client.get(urlPath);
    } on DioException catch (e) {
      if (!_isRecoverableConnectionClose(e) || !urlPath.contains('limit=')) {
        rethrow;
      }

      // Some backend responses fail for very large limits with:
      // "Connection closed before full header was received".
      // Retry with smaller limits to keep data loading reliable.
      const fallbackLimits = <int>[20000, 10000, 5000];
      for (final fallbackLimit in fallbackLimits) {
        final retryUrl = urlPath.replaceAll(RegExp(r'limit=\d+'), 'limit=$fallbackLimit');
        logg.w('Session Plan Repository: Retrying with reduced limit=$fallbackLimit');
        try {
          return await _client.get(retryUrl);
        } on DioException catch (retryError) {
          if (!_isRecoverableConnectionClose(retryError)) {
            rethrow;
          }
        }
      }
      rethrow;
    }
  }

  bool _isRecoverableConnectionClose(DioException e) {
    final msg = (e.message ?? '').toLowerCase();
    return msg.contains('connection closed before full header was received') ||
        msg.contains('connection closed') ||
        msg.contains('httpexception');
  }
}
