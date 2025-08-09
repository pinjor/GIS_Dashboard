import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gis_dashboard/core/common/constants/api_constants.dart';
import 'package:gis_dashboard/core/network/interceptors/logging_interceptor.dart';

final dioClientProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: '${ApiConstants.baseUrlStaging}${ApiConstants.urlCommonPath}',
    ),
  );

  dio.interceptors.add(LoggingInterceptor());

  return dio;
});
