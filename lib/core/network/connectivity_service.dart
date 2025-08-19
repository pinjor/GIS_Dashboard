import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gis_dashboard/core/utils/utils.dart';

/// Service to check internet connectivity using connectivity_plus
class ConnectivityService {
  final Connectivity _connectivity = Connectivity();

  /// Check if device has internet connection
  Future<bool> hasInternetConnection() async {
    try {
      // First check connectivity state
      final connectivityResult = await _connectivity.checkConnectivity();
      print(connectivityResult);

      // If no connectivity, return false immediately
      if (connectivityResult.contains(ConnectivityResult.none)) {
        logg.w('No connectivity detected');
        return false;
      }

      // Even if connectivity shows available, verify with actual network call
      final result = await InternetAddress.lookup(
        'google.com',
      ).timeout(const Duration(seconds: 5));

      final hasConnection =
          result.isNotEmpty && result[0].rawAddress.isNotEmpty;
      logg.i('Internet connection status: $hasConnection');
      return hasConnection;
    } catch (e) {
      logg.e('Error checking internet connection: $e');
      return false;
    }
  }

  /// Check connectivity with a custom host
  Future<bool> canReachHost(String host) async {
    try {
      final result = await InternetAddress.lookup(
        host,
      ).timeout(const Duration(seconds: 5));

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
