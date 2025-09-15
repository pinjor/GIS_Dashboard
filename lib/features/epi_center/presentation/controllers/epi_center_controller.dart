import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'dart:convert';

import '../../../../core/common/constants/api_constants.dart';
import '../../../../core/service/data_service.dart';
import '../../../../core/utils/utils.dart';
import '../../domain/epi_center_details_response.dart';
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
    logg.i(
      "🔄 Starting EPI center data fetch for UID: $epiUid, year: $year, ccUid: $ccUid",
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

      logg.i("🌐 Fetching EPI center data from: $apiUrl");

      final response = await _dataService.getEpiCenterData(urlPath: apiUrl);

      logg.i("✅ Received response from API (length: ${response.length})");

      // Parse JSON with better error handling
      dynamic parsedJson;
      try {
        parsedJson = jsonDecode(response);
        logg.i("✅ Successfully parsed JSON response");
      } catch (e) {
        logg.e("❌ JSON parsing error: $e");
        throw Exception('Invalid response format');
      }

      // Handle different response types
      EpiCenterDetailsResponse epiCenterData;
      if (parsedJson is Map<String, dynamic>) {
        logg.i("✅ Parsing JSON as Map<String, dynamic>");
        epiCenterData = EpiCenterDetailsResponse.fromJson(parsedJson);

        // If coverageTableData months are empty, build them from the area's vaccine coverage data
        if (epiCenterData.coverageTableData!.months.isEmpty) {
          logg.i(
            "🔄 Coverage table data is empty, processing from vaccine coverage data",
          );
          final processedData = _processCoverageData(epiCenterData, year);
          if (processedData != null) {
            logg.i("✅ Successfully processed coverage data");
            // Create a new response with the processed data
            final updatedJson = Map<String, dynamic>.from(parsedJson);
            updatedJson['coverageTableData'] = processedData;
            epiCenterData = EpiCenterDetailsResponse.fromJson(updatedJson);
          } else {
            logg.w("⚠️ No processed coverage data available");
          }
        } else {
          logg.i(
            "✅ Coverage table data already available (${epiCenterData.coverageTableData!.months.length} months)",
          );
        }
      } else {
        logg.e("❌ Unexpected response type: ${parsedJson.runtimeType}");
        throw Exception('Unexpected response format');
      }

      state = state.copyWith(
        isLoading: false,
        hasError: false,
        epiCenterData: epiCenterData,
      );

      logg.i(
        "🎉 Successfully fetched and processed EPI center data for UID: $epiUid",
      );
    } catch (e) {
      logg.e("❌ Error fetching EPI center data: $e");

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

      logg.e("❌ Setting error state: $errorMessage");

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

  /// Process vaccine coverage data to create coverageTableData structure
  Map<String, dynamic>? _processCoverageData(
    EpiCenterDetailsResponse epiData,
    int year,
  ) {
    // Use the structured VaccineCoverage data from the new model
    final yearCoverage =
        epiData.area!.vaccineCoverage!.child0To11Month[year.toString()];

    if (yearCoverage == null) {
      return null;
    }

    // Process monthly data
    Map<String, dynamic> processedMonths = {};

    // Convert month coverage data
    for (var monthEntry in yearCoverage.months.entries) {
      final monthNumber = monthEntry.key;
      final monthCoverage = monthEntry.value;

      // Convert vaccine array to structured data
      Map<String, dynamic> coverages = {};
      Map<String, dynamic> dropouts = {};

      for (var vaccineItem in monthCoverage.vaccine) {
        final vaccineName = vaccineItem.vaccineName;

        // Calculate total from male + female (handle null values)
        int total = 0;
        if (vaccineItem.male != null) total += vaccineItem.male!;
        if (vaccineItem.female != null) total += vaccineItem.female!;

        coverages[vaccineName ?? ''] = total;
        // For now, we don't have dropout data, so we'll set it to 0
        dropouts[vaccineName ?? ''] = 0;
      }

      // Map month number to month name
      final monthNames = [
        '',
        'January',
        'February',
        'March',
        'April',
        'May',
        'June',
        'July',
        'August',
        'September',
        'October',
        'November',
        'December',
      ];

      final monthIndex = int.tryParse(monthNumber) ?? 0;
      if (monthIndex > 0 && monthIndex < monthNames.length) {
        processedMonths[monthNames[monthIndex]] = {
          'coverages': coverages,
          'dropouts': dropouts,
        };
      }
    }

    // Extract vaccine names from the year data
    Set<String> vaccineNames = {};
    for (var vaccineItem in yearCoverage.vaccine) {
      vaccineNames.add(vaccineItem.vaccineName ?? '');
    }

    return {
      'months': processedMonths,
      'totals': {},
      'vaccine_names': vaccineNames.toList(),
      'targets': {'month': processedMonths.length},
      'coverage_percentages': {},
    };
  }
}
