import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gis_dashboard/core/utils/utils.dart';

/// Service to check internet connectivity using connectivity_plus
class ConnectivityService {
  final Connectivity _connectivity = Connectivity();

  /// Check if device has internet connection
  ///
  /// Uses a two-tier approach for optimal performance:
  /// 1. Quick instant check with connectivity_plus (detects airplane mode, no WiFi/data)
  /// 2. Actual internet verification with 5s timeout + retry (more reliable for slow networks)
  Future<bool> hasInternetConnection() async {
    try {
      // TIER 1: Instant connectivity check (no network latency)
      final connectivityResult = await _connectivity.checkConnectivity();
      logg.d('Connectivity status: $connectivityResult');

      // If no connectivity detected, return false immediately (saves timeout)
      if (connectivityResult.contains(ConnectivityResult.none)) {
        logg.w('No connectivity detected - skipping internet verification');
        return false;
      }

      // TIER 2: Verify actual internet access with retry for reliability
      // This catches cases where WiFi/mobile is connected but no actual internet
      // Try up to 2 times with 5s timeout each (handles slow DNS/network)
      for (int attempt = 1; attempt <= 2; attempt++) {
        try {
          final result = await InternetAddress.lookup('google.com').timeout(
            const Duration(seconds: 5),
          ); // Increased back to 5s for reliability

          final hasConnection =
              result.isNotEmpty && result[0].rawAddress.isNotEmpty;

          if (hasConnection) {
            logg.i('Internet connection verified on attempt $attempt');
            return true;
          }
        } on TimeoutException catch (e) {
          logg.w('Internet check timeout on attempt $attempt: $e');
          if (attempt == 2) {
            // On second timeout, assume we have internet (fail-open for staging SSL bypass)
            logg.w(
              '⚠️ DNS timeout - assuming internet available (fail-open for staging)',
            );
            return true; // Fail-open to prevent false negatives
          }
          // Wait 500ms before retry
          await Future.delayed(const Duration(milliseconds: 500));
        }
      }

      logg.i('Internet connection verified: false');
      return false;
    } catch (e) {
      logg.e('Error checking internet connection: $e');
      // Fail-open: assume internet is available on unexpected errors
      logg.w(
        '⚠️ Connectivity check error - assuming internet available (fail-open)',
      );
      return true;
    }
  }

  /// Check connectivity with a custom host
  /// Uses 3s timeout for custom hosts (may be slower than google.com)
  Future<bool> canReachHost(String host) async {
    try {
      final result = await InternetAddress.lookup(
        host,
      ).timeout(const Duration(seconds: 3)); // Reduced from 5s to 3s

      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (e) {
      logg.e('Error reaching host $host: $e');
      return false;
    }
  }

  /// Get current connectivity status
  Future<List<ConnectivityResult>> getConnectivityStatus() async {
    return await _connectivity.checkConnectivity();
  }

  /// Stream to listen for connectivity changes
  Stream<List<ConnectivityResult>> get connectivityStream =>
      _connectivity.onConnectivityChanged;
}

/// Provider for connectivity service
final connectivityServiceProvider = Provider<ConnectivityService>((ref) {
  return ConnectivityService();
});

/// State notifier to track connectivity status
class ConnectivityNotifier extends StateNotifier<ConnectivityState> {
  final ConnectivityService _connectivityService;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  ConnectivityNotifier(this._connectivityService)
    : super(ConnectivityState(isConnected: true, isChecking: false)) {
    _initializeConnectivity();
    _listenToConnectivityChanges();
  }

  void _initializeConnectivity() async {
    state = state.copyWith(isChecking: true);
    final isConnected = await _connectivityService.hasInternetConnection();
    state = state.copyWith(isConnected: isConnected, isChecking: false);
  }

  void _listenToConnectivityChanges() {
    _connectivitySubscription = _connectivityService.connectivityStream.listen((
      List<ConnectivityResult> results,
    ) {
      _handleConnectivityChange(results);
    });
  }

  void _handleConnectivityChange(List<ConnectivityResult> results) async {
    if (results.contains(ConnectivityResult.none)) {
      state = state.copyWith(isConnected: false, isChecking: false);
    } else {
      // Even if connectivity is available, verify with actual network call
      state = state.copyWith(isChecking: true);
      final actuallyConnected = await _connectivityService
          .hasInternetConnection();
      state = state.copyWith(isConnected: actuallyConnected, isChecking: false);
    }
  }

  Future<void> checkConnectivity() async {
    state = state.copyWith(isChecking: true);
    final isConnected = await _connectivityService.hasInternetConnection();
    state = state.copyWith(isConnected: isConnected, isChecking: false);
  }

  void setConnectivity(bool isConnected) {
    state = state.copyWith(isConnected: isConnected);
  }

  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    super.dispose();
  }
}

/// Connectivity state model
class ConnectivityState {
  final bool isConnected;
  final bool isChecking;

  ConnectivityState({required this.isConnected, required this.isChecking});

  ConnectivityState copyWith({bool? isConnected, bool? isChecking}) {
    return ConnectivityState(
      isConnected: isConnected ?? this.isConnected,
      isChecking: isChecking ?? this.isChecking,
    );
  }
}

/// Provider for connectivity state
final connectivityProvider =
    StateNotifierProvider<ConnectivityNotifier, ConnectivityState>((ref) {
      return ConnectivityNotifier(ref.read(connectivityServiceProvider));
    });
