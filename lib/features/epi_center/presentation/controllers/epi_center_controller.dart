import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/common/constants/api_constants.dart';
import '../../../../core/network/network_error_handler.dart';
import '../../../../core/service/data_service.dart';
import '../../../../core/utils/utils.dart';
import '../../domain/epi_center_state.dart';

final epiCenterControllerProvider =
    StateNotifierProvider<EpiCenterController, EpiCenterState>(
      (ref) => EpiCenterController(ref.read(dataServiceProvider)),
    );

class EpiCenterController extends StateNotifier<EpiCenterState> {
  final DataService _dataService;

  EpiCenterController(this._dataService) : super(const EpiCenterState());

  /// Fetch EPI center details data using org_uid (for city corporation wards)
  Future<void> fetchEpiCenterDataByOrgUid({
    required String orgUid,
    required String year,
  }) async {
    logg.i(
      "🔄 Fetching EPI center data by org_uid (orgUid: $orgUid, year: $year)",
    );

    state = state.copyWith(
      isLoading: true,
      hasError: false,
      errorMessage: null,
      currentEpiUid: orgUid,
      currentCcUid: null, // Not applicable for org_uid requests
      selectedYear: int.tryParse(year) ?? DateTime.now().year,
    );

    try {
      final epiCenterData = await _dataService.getEpiCenterDetailsByOrgUid(
        orgUid: orgUid,
        year: year,
      );

      state = state.copyWith(
        isLoading: false,
        hasError: false,
        epiCenterData: epiCenterData,
      );

      logg.i(
        "✅ Successfully fetched EPI center data by org_uid (orgUid: $orgUid)",
      );
    } catch (e) {
      logg.e("❌ Error fetching EPI center data by org_uid: $e");

      String errorMessage = 'Failed to load EPI center data';
      
      // ✅ Check for NetworkException first (from NetworkErrorHandler)
      if (e is NetworkException) {
        if (e.type == NetworkErrorType.notFound) {
          // ✅ Better error message for subblock-level 404s
          if (orgUid.length > 20 && !orgUid.contains('/')) {
            // Likely a subblock UID (single UID, not a path)
            errorMessage = 'Subblock data not available. The EPI center data may not exist for this subblock.';
          } else {
            errorMessage = 'EPI center data not available for this area.';
          }
        } else if (e.type == NetworkErrorType.timeout) {
          if (orgUid.length < 20) {
            errorMessage = 'Microplan data is not available at division level. Please select a district or lower level.';
          } else {
            errorMessage = 'Request timeout. The server may be slow or the data may not be available. Please try again or select a more specific area.';
          }
        } else if (e.type == NetworkErrorType.noInternet) {
          errorMessage = 'No internet connection. Please check your network.';
        } else {
          errorMessage = e.message;
        }
      } else if (e.toString().contains('EPI_CENTER_NO_DATA')) {
        errorMessage = 'No data available for this area';
      } else if (e.toString().contains('EPI_DATA_TOO_LARGE')) {
        // ✅ Handle data too large errors (prevents memory exhaustion)
        errorMessage = 'Data is too large to load. Please select a more specific area (district, upazila, union, ward, or subblock).';
      } else if (e.toString().contains('SSL_CERTIFICATE_ERROR')) {
        errorMessage = 'Connection security error. Please try again.';
      } else if (e.toString().contains('404') || e.toString().contains('not found')) {
        // ✅ Better error message for subblock-level 404s
        if (orgUid.length > 20 && !orgUid.contains('/')) {
          errorMessage = 'Subblock data not available. The EPI center data may not exist for this subblock.';
        } else {
          errorMessage = 'EPI center data not available for this area.';
        }
      } else if (e.toString().contains('timeout')) {
        // ✅ Better error message for division-level timeouts
        if (orgUid.length < 20) { // Division UIDs are typically shorter
          errorMessage = 'Microplan data is not available at division level. Please select a district or lower level.';
        } else {
          errorMessage = 'Request timeout. The server may be slow or the data may not be available. Please try again or select a more specific area.';
        }
      } else if (e.toString().contains('Exhausted heap') || 
                 e.toString().contains('Out of Memory') ||
                 e.toString().contains('heap space')) {
        // ✅ Handle memory exhaustion errors
        errorMessage = 'Data is too large to load. Please select a more specific area (district, upazila, union, ward, or subblock).';
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

  /// Fetch EPI center details data
  Future<void> fetchEpiCenterData({
    required String epiUid,
    required int year,
    String? ccUid, // optional
  }) async {
    logg.i(
      "🔄 Fetching EPI center data (epiUid: $epiUid, year: $year, ccUid: $ccUid)",
    );

    state = state.copyWith(
      isLoading: true,
      hasError: false,
      errorMessage: null,
      currentEpiUid: epiUid,
      currentCcUid: ccUid,
      selectedYear: year,
    );

    try {
      // Build API URL
      final queryParams = ccUid != null && ccUid.isNotEmpty
          ? 'year=$year&ccuid=$ccUid&request-from=app'
          : 'year=$year&request-from=app';
      final apiUrl =
          '${ApiConstants.stagingServerFullUrl}/chart/$epiUid?$queryParams';

      final epiCenterData = await _dataService.getEpiCenterDetailsData(
        urlPath: apiUrl,
      );

      state = state.copyWith(
        isLoading: false,
        hasError: false,
        epiCenterData: epiCenterData,
      );

      logg.i("✅ Successfully fetched EPI center data (epiUid: $epiUid)");
    } catch (e) {
      logg.e("❌ Error fetching EPI center data: $e");

      String errorMessage = 'Failed to load EPI center data';
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

  /// Set error state (useful for preventing unnecessary API calls)
  void setErrorState(String errorMessage) {
    state = state.copyWith(
      isLoading: false,
      hasError: true,
      errorMessage: errorMessage,
      epiCenterData: null,
    );
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
