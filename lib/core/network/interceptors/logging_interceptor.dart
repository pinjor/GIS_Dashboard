import 'package:dio/dio.dart';
import 'package:gis_dashboard/core/network/network_error_handler.dart';
import 'package:gis_dashboard/core/utils/utils.dart';

class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    logg.i('REQUEST: ${options.method} ${options.uri}');
    logg.d('Headers: ${options.headers}');
    if (options.data != null) {
      logg.d('Body: ${options.data}');
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    logg.i('RESPONSE: ${response.statusCode} ${response.requestOptions.uri}');
    logg.d('Response data type: ${response.data.runtimeType}');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    logg.e('ERROR: ${err.requestOptions.method} ${err.requestOptions.uri}');
    logg.e('Error type: ${err.type}');
    logg.e('Error message: ${err.message}');

    // Convert to user-friendly error
    final networkError = NetworkErrorHandler.handleDioError(err);
    logg.e('User-friendly error: ${networkError.message}');

    super.onError(err, handler);
  }
}
