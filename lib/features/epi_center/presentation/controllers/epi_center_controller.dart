import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'dart:convert';

import '../../../../core/common/constants/api_constants.dart';
import '../../../../core/service/data_service.dart';
import '../../../../core/utils/utils.dart';
import '../../domain/epi_center_response.dart';
import '../../domain/epi_center_state.dart';


final epiCenterControllerProvider =
    StateNotifierProvider<EpiCenterController, EpiCenterState>(
      (ref) => EpiCenterController(ref.read(dataServiceProvider)),
    );

class EpiCenterController extends StateNotifier<EpiCenterState> {
  final DataService _dataService;

  EpiCenterController(this._dataService) : super(const EpiCenterState());

  /// Fetch EPI center details data
  Future<void> fetchEpiCenterData({
    required String epiUid,
    required int year,
    String? ccUid, // City Corporation UID - optional
  }) async {
    state = state.copyWith(
      isLoading: true,
      hasError: false,
      errorMessage: null,
      currentEpiUid: epiUid,
      currentCcUid: ccUid,
      selectedYear: year,
    );

    try {
      // Construct the API URL based on whether we have city corporation context
      String apiUrl;
      if (ccUid != null && ccUid.isNotEmpty) {
        // City Corporation context
        apiUrl =
            '${ApiConstants.epiCenterDataBaseUrl}/chart/$epiUid?year=$year&ccuid=$ccUid&request-from=app';
      } else {
        // Regular context (no city corporation)
        apiUrl =
            '${ApiConstants.epiCenterDataBaseUrl}/chart/$epiUid?year=$year&request-from=app';
      }

      logg.i("Fetching EPI center data from: $apiUrl");

      final response = await _dataService.getEpiCenterData(urlPath: apiUrl);

      // Parse JSON with better error handling
      dynamic parsedJson;
      try {
        parsedJson = jsonDecode(response);
      } catch (e) {
        logg.e("JSON parsing error: $e");
        throw Exception('Invalid response format');
      }

      // Handle different response types
      EpiCenterResponse epiCenterData;
      if (parsedJson is Map<String, dynamic>) {
        epiCenterData = EpiCenterResponse.fromJson(parsedJson);
      } 
      // else if (parsedJson is List) {
      //   // If response is a list, wrap it in a map structure
      //   logg.w("Received List response, wrapping in Map structure");
      //   epiCenterData = EpiCenterResponse.fromJson({
      //     'data': parsedJson,
      //     'uid': epiUid,
      //     'type': 'list_response',
      //   });
      // }
       else {
        logg.e("Unexpected response type: ${parsedJson.runtimeType}");
        throw Exception('Unexpected response format');
      }

      state = state.copyWith(
        isLoading: false,
        hasError: false,
        epiCenterData: epiCenterData,
      );

      logg.i("Successfully fetched EPI center data for UID: $epiUid");
    } catch (e) {
      logg.e("Error fetching EPI center data: $e");

      String errorMessage = 'Failed to load EPI center data';

      // Handle specific error cases
      if (e.toString().contains('EPI_CENTER_NO_DATA')) {
        errorMessage = 'No data available for this EPI center';
      } else if (e.toString().contains('SSL_CERTIFICATE_ERROR')) {
        errorMessage = 'Connection security error. Please try again.';
      } else if (e.toString().contains('404')) {
        errorMessage = 'EPI center data not available';
      } else if (e.toString().contains('timeout')) {
        errorMessage = 'Request timeout. Please try again.';
      } else if (e.toString().contains('No internet connection')) {
        errorMessage = 'No internet connection. Please check your network.';
      }

      state = state.copyWith(
        isLoading: false,
        hasError: true,
        errorMessage: errorMessage,
        epiCenterData: null,
      );
    }
  }

  /// Update selected year and refetch data
  Future<void> updateYear(int year) async {
    if (state.currentEpiUid != null) {
      await fetchEpiCenterData(
        epiUid: state.currentEpiUid!,
        year: year,
        ccUid: state.currentCcUid,
      );
    }
  }

  /// Clear error state
  void clearError() {
    state = state.copyWith(hasError: false, errorMessage: null);
  }

  /// Reset state
  void reset() {
    state = const EpiCenterState();
  }
}
