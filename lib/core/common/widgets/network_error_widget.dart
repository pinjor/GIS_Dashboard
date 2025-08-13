import 'package:flutter/material.dart';

class NetworkErrorWidget extends StatelessWidget {
  final String error;
  final VoidCallback? onRetry;
  final bool showRetryButton;

  const NetworkErrorWidget({
    super.key,
    required this.error,
    this.onRetry,
    this.showRetryButton = true,
  });

  @override
  Widget build(BuildContext context) {
    final isNetworkError = _isNetworkRelatedError(error);

    return Container(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isNetworkError ? Icons.wifi_off : Icons.error_outline,
            size: 64,
            color: isNetworkError ? Colors.orange : Colors.red,
          ),
          const SizedBox(height: 16),
          Text(
            isNetworkError ? 'Connection Error' : 'Error',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Text(
            _getErrorMessage(error),
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
          if (isNetworkError) ...[
            const SizedBox(height: 16),
            const Text(
              'Please check:\n• Your internet connection\n• WiFi or mobile data is enabled\n• Network settings are correct',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
          if (showRetryButton && onRetry != null) ...[
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  bool _isNetworkRelatedError(String error) {
    final errorLower = error.toLowerCase();
    return errorLower.contains('internet') ||
        errorLower.contains('connection') ||
        errorLower.contains('network') ||
        errorLower.contains('timeout') ||
        error.contains('NetworkException');
  }

  String _getErrorMessage(String error) {
    // If it's already a user-friendly message, return it
    if (!error.contains('Exception:') && !error.contains('DioException')) {
      return error;
    }

    // Extract user-friendly message from exception
    if (error.contains(':')) {
      final parts = error.split(':');
      if (parts.length > 1) {
        return parts.sublist(1).join(':').trim();
      }
    }

    // Fallback to generic message
    if (_isNetworkRelatedError(error)) {
      return 'Unable to connect to the internet. Please check your connection and try again.';
    }

    return 'An unexpected error occurred. Please try again.';
  }
}

/// Compact error widget for smaller spaces
class CompactNetworkErrorWidget extends StatelessWidget {
  final String error;
  final VoidCallback? onRetry;

  const CompactNetworkErrorWidget({
    super.key,
    required this.error,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final isNetworkError =
        error.toLowerCase().contains('internet') ||
        error.toLowerCase().contains('connection') ||
        error.toLowerCase().contains('network');

    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        border: Border.all(color: Colors.red.shade200),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        children: [
          Icon(
            isNetworkError ? Icons.wifi_off : Icons.error_outline,
            color: isNetworkError ? Colors.orange : Colors.red,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  isNetworkError ? 'No Internet Connection' : 'Error',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isNetworkError
                      ? 'Please check your network connection'
                      : 'Something went wrong',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          if (onRetry != null) ...[
            const SizedBox(width: 8),
            IconButton(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              iconSize: 20,
            ),
          ],
        ],
      ),
    );
  }
}
