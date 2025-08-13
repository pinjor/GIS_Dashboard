import 'package:dio/dio.dart';

/// Custom exception for network-related errors
class NetworkException implements Exception {
  final String message;
  final NetworkErrorType type;
  final String? technicalDetails;

  NetworkException({
    required this.message,
    required this.type,
    this.technicalDetails,
  });

  @override
  String toString() => message;
}

/// Types of network errors
enum NetworkErrorType {
  noInternet,
  timeout,
  serverError,
  notFound,
  badRequest,
  unauthorized,
  forbidden,
  unknown,
}

/// Network error handler that converts Dio errors to user-friendly messages
class NetworkErrorHandler {
  static NetworkException handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkException(
          message:
              'Connection timeout. Please check your internet connection and try again.',
          type: NetworkErrorType.timeout,
          technicalDetails: error.message,
        );

      case DioExceptionType.connectionError:
        return NetworkException(
          message:
              'No internet connection. Please check your network settings and try again.',
          type: NetworkErrorType.noInternet,
          technicalDetails: error.message,
        );

      case DioExceptionType.badResponse:
        return _handleStatusCodeError(error);

      case DioExceptionType.cancel:
        return NetworkException(
          message: 'Request was cancelled.',
          type: NetworkErrorType.unknown,
          technicalDetails: error.message,
        );

      case DioExceptionType.unknown:
        // Check if it's a socket exception (no internet)
        if (error.message?.contains('SocketException') == true ||
            error.message?.contains('Network is unreachable') == true ||
            error.message?.contains('No address associated with hostname') ==
                true ||
            error.message?.contains('Failed host lookup') == true) {
          return NetworkException(
            message:
                'No internet connection. Please check your network settings and try again.',
            type: NetworkErrorType.noInternet,
            technicalDetails: error.message,
          );
        }
        return NetworkException(
          message: 'An unexpected error occurred. Please try again.',
          type: NetworkErrorType.unknown,
          technicalDetails: error.message,
        );

      default:
        return NetworkException(
          message: 'An unexpected error occurred. Please try again.',
          type: NetworkErrorType.unknown,
          technicalDetails: error.message,
        );
    }
  }

  static NetworkException _handleStatusCodeError(DioException error) {
    final statusCode = error.response?.statusCode;

    switch (statusCode) {
      case 400:
        return NetworkException(
          message: 'Invalid request. Please try again.',
          type: NetworkErrorType.badRequest,
          technicalDetails: 'HTTP 400: ${error.response?.data}',
        );

      case 401:
        return NetworkException(
          message: 'Authentication failed. Please check your credentials.',
          type: NetworkErrorType.unauthorized,
          technicalDetails: 'HTTP 401: ${error.response?.data}',
        );

      case 403:
        return NetworkException(
          message:
              'Access denied. You don\'t have permission to access this resource.',
          type: NetworkErrorType.forbidden,
          technicalDetails: 'HTTP 403: ${error.response?.data}',
        );

      case 404:
        return NetworkException(
          message: 'The requested data was not found. Please try again later.',
          type: NetworkErrorType.notFound,
          technicalDetails: 'HTTP 404: ${error.response?.data}',
        );

      case 500:
      case 502:
      case 503:
      case 504:
        return NetworkException(
          message: 'Server error. Please try again later.',
          type: NetworkErrorType.serverError,
          technicalDetails: 'HTTP $statusCode: ${error.response?.data}',
        );

      default:
        return NetworkException(
          message: 'An error occurred while fetching data. Please try again.',
          type: NetworkErrorType.unknown,
          technicalDetails: 'HTTP $statusCode: ${error.response?.data}',
        );
    }
  }

  /// Handle generic exceptions that are not Dio errors
  static NetworkException handleGenericError(dynamic error) {
    if (error is NetworkException) {
      return error;
    }

    final errorString = error.toString().toLowerCase();

    // Check for common network-related error patterns
    if (errorString.contains('socket') ||
        errorString.contains('network') ||
        errorString.contains('connection') ||
        errorString.contains('host lookup failed') ||
        errorString.contains('no address associated with hostname')) {
      return NetworkException(
        message:
            'No internet connection. Please check your network settings and try again.',
        type: NetworkErrorType.noInternet,
        technicalDetails: error.toString(),
      );
    }

    return NetworkException(
      message: 'An unexpected error occurred. Please try again.',
      type: NetworkErrorType.unknown,
      technicalDetails: error.toString(),
    );
  }
}
