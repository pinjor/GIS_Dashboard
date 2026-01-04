import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gis_dashboard/core/common/constants/api_constants.dart';
import 'package:gis_dashboard/core/network/interceptors/logging_interceptor.dart';
import 'package:gis_dashboard/core/network/staging_ssl_adapter.dart';

// ===========================================================================
// Dio HTTP Client Provider
// ===========================================================================
//
// This provider creates a configured Dio instance for making HTTP requests.
//
// CURRENT CONFIGURATION:
// - Base URL: Staging server with common API path
// - Timeouts: Standard timeouts for mobile network conditions
// - Interceptors: Logging for debugging
// - SSL: Bypasses certificate validation for staging (debug mode only)
//
// TODO: Remove StagingSslAdapter configuration once staging SSL is fixed.
//
// ===========================================================================

final dioClientProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl:
          '${ApiConstants.stagingServerFullUrl}${ApiConstants.urlCommonPath}',
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 15),
    ),
  );

  // ---------------------------------------------------------------------------
  // ⚠️ STAGING SSL BYPASS (DEBUG MODE ONLY)
  // ---------------------------------------------------------------------------
  // The staging server (staging.gisdashboard.online) currently has an expired
  // SSL certificate. This adapter bypasses SSL validation ONLY for this host
  // and ONLY in debug mode. Production builds are not affected.
  //
  // TODO: Remove this line once the staging SSL certificate is renewed.
  // ---------------------------------------------------------------------------
  StagingSslAdapter.configureForDio(dio);

  // Add logging interceptor for request/response debugging
  dio.interceptors.add(LoggingInterceptor());

  return dio;
});

// Provider for dynamic API calls (not storage/static files)
// Base URL: staging.gisdashboard.online
final apiClientProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.stagingServerFullUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 15),
    ),
  );

  StagingSslAdapter.configureForDio(dio);
  dio.interceptors.add(LoggingInterceptor());

  return dio;
});
