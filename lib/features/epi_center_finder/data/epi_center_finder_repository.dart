import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/network/connectivity_service.dart';
import '../../../../core/network/dio_client_provider.dart';
import '../../../../core/network/network_error_handler.dart';
import '../../../../core/utils/utils.dart';
import '../../session_plan/domain/session_plan_coords_response.dart';
import '../../../../core/common/constants/api_constants.dart';

final epiCenterFinderRepositoryProvider =
    Provider<EpiCenterFinderRepository>((ref) {
  return EpiCenterFinderRepository(
    client: ref.watch(apiClientProvider),
    connectivityService: ref.watch(connectivityServiceProvider),
  );
});

class EpiCenterFinderRepository {
  final Dio _client;
  final ConnectivityService _connectivityService;

  EpiCenterFinderRepository({
    required Dio client,
    required ConnectivityService connectivityService,
  })  : _client = client,
        _connectivityService = connectivityService;

  /// Fetch session plans for a date range (country-wide, no area filter)
  Future<SessionPlanCoordsResponse> fetchSessionPlansByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final hasInternet = await _connectivityService.hasInternetConnection();
      if (!hasInternet) {
        throw NetworkException(
          message: 'No internet connection',
          type: NetworkErrorType.noInternet,
        );
      }

      // Format dates as YYYY-MM-DD
      final startDateStr = DateFormat('yyyy-MM-dd').format(startDate);
      final endDateStr = DateFormat('yyyy-MM-dd').format(endDate);

      // Build URL: /session-plans?start_date=YYYY-MM-DD&end_date=YYYY-MM-DD
      // No area parameter = country-wide search
      final urlPath = '${ApiConstants.sessionPlans}?start_date=$startDateStr&end_date=$endDateStr&limit=50000';

      logg.i("EPI Center Finder: Fetching session plans for date range: $startDateStr to $endDateStr");
      logg.i("EPI Center Finder: URL: $urlPath");

      final response = await _client.get(urlPath);

      logg.i("EPI Center Finder: Response received - Status: ${response.statusCode}");

      if (response.data != null && response.data is Map<String, dynamic>) {
        final rawData = response.data as Map<String, dynamic>;
        final sessionCount = rawData['session_count'] ?? 0;
        final features = rawData['features'] as List?;
        logg.i(
          "EPI Center Finder: session_count: $sessionCount, features: ${features?.length ?? 0}",
        );
        
        // Log sample feature structure to see what fields are available
        if (features != null && features.isNotEmpty) {
          final sampleFeature = features.first;
          if (sampleFeature is Map) {
            logg.i("EPI Center Finder: Sample feature keys: ${sampleFeature.keys.toList()}");
            final sampleInfo = sampleFeature['info'];
            if (sampleInfo is Map) {
              logg.i("EPI Center Finder: Sample info keys: ${sampleInfo.keys.toList()}");
              // Check for zone/ward fields
              if (sampleInfo.containsKey('zone_name') || 
                  sampleInfo.containsKey('zoneName') ||
                  sampleInfo.containsKey('cc_zone_name') ||
                  sampleInfo.containsKey('ward_name') ||
                  sampleInfo.containsKey('wardName') ||
                  sampleInfo.containsKey('cc_ward_name')) {
                logg.i("EPI Center Finder: ✅ Zone/Ward fields found in API response");
              } else {
                logg.w("EPI Center Finder: ⚠️ Zone/Ward fields not found in API response");
              }
            }
          }
        }
      }

      final parsedResponse = SessionPlanCoordsResponse.fromJson(response.data);

      logg.i(
        "EPI Center Finder: Parsed response - sessionCount: ${parsedResponse.sessionCount}, features: ${parsedResponse.features?.length ?? 0}",
      );

      return parsedResponse;
    } on DioException catch (e) {
      logg.e("EPI Center Finder: Dio error fetching session plans: $e");
      throw NetworkErrorHandler.handleDioError(e);
    } catch (e) {
      logg.e("EPI Center Finder: Error fetching session plans: $e");
      throw NetworkErrorHandler.handleGenericError(e);
    }
  }
}
