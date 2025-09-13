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

        // If coverageTableData is empty, build it from the area's vaccine coverage data
        if (epiCenterData.coverageTableData == null ||
            (epiCenterData.coverageTableData!['months'] as Map?)?.isEmpty ==
                true) {
          final processedData = _processCoverageData(epiCenterData, year);
          if (processedData != null) {
            // Create a new response with the processed data
            final updatedJson = Map<String, dynamic>.from(parsedJson);
            updatedJson['coverageTableData'] = processedData;
            epiCenterData = EpiCenterResponse.fromJson(updatedJson);
          }
        }
      } else {
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

  /// Process vaccine coverage data to create coverageTableData structure
  Map<String, dynamic>? _processCoverageData(
    EpiCenterResponse epiData,
    int year,
  ) {
    if (epiData.area?.parsedVaccineCoverage == null) return null;

    final coverageByYear = epiData.area!.parsedVaccineCoverage!;

    if (coverageByYear['child_0_to_11_month'] == null ||
        coverageByYear['child_0_to_11_month'][year.toString()] == null) {
      return null;
    }

    final yearData = coverageByYear['child_0_to_11_month'][year.toString()];

    // Process monthly data
    Map<String, dynamic> processedMonths = {};

    if (yearData['months'] != null) {
      final monthsData = yearData['months'] as Map<String, dynamic>;

      for (var monthEntry in monthsData.entries) {
        final monthNumber = monthEntry.key;
        final monthData = monthEntry.value;

        if (monthData['vaccine'] != null) {
          final vaccineArray = monthData['vaccine'] as List<dynamic>;

          // Convert vaccine array to structured data
          Map<String, dynamic> coverages = {};
          Map<String, dynamic> dropouts = {};

          for (var vaccineData in vaccineArray) {
            if (vaccineData is Map<String, dynamic>) {
              final vaccineName = vaccineData['vaccine_name']?.toString();
              final male = vaccineData['male'];
              final female = vaccineData['female'];

              if (vaccineName != null) {
                // Calculate total from male + female (handle null values)
                int total = 0;
                if (male != null && male is! bool)
                  total += (male is int
                      ? male
                      : int.tryParse(male.toString()) ?? 0);
                if (female != null && female is! bool)
                  total += (female is int
                      ? female
                      : int.tryParse(female.toString()) ?? 0);

                coverages[vaccineName] = total;
                // For now, we don't have dropout data, so we'll set it to 0
                dropouts[vaccineName] = 0;
              }
            }
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
      }
    }

    return {
      'months': processedMonths,
      'totals': {},
      'vaccine_names': [
        'Penta - 1st',
        'Penta - 2nd',
        'Penta - 3rd',
        'MR - 1st',
        'MR - 2nd',
        'BCG',
      ],
      'targets': {'month': processedMonths.length},
      'coverage_percentages': {},
    };
  }
}
