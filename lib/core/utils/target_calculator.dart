import 'package:gis_dashboard/features/summary/domain/vaccine_coverage_response.dart';
import 'package:gis_dashboard/core/utils/utils.dart';

/// Result structure for target data
class TargetData {
  final int total;
  final int male;
  final int female;

  const TargetData({
    required this.total,
    required this.male,
    required this.female,
  });
}

/// Utility class to extract "Total Children (0-11 m)" target data from VaccineCoverageResponse
/// This ensures consistency across Summary, EPI Details, and Microplan sections
class TargetCalculator {

  /// Extract target data from VaccineCoverageResponse for a specific vaccine
  /// Returns null if no data is available
  static TargetData? getTargetData(
    VaccineCoverageResponse? coverageData,
    String? vaccineUid,
  ) {
    if (coverageData == null || coverageData.vaccines == null) {
      logg.w('TargetCalculator: Coverage data is null or has no vaccines');
      return null;
    }

    // Find the selected vaccine
    Vaccine? selectedVaccine;
    try {
      selectedVaccine = coverageData.vaccines!.firstWhere(
        (vaccine) => vaccine.vaccineUid == vaccineUid,
      );
    } catch (e) {
      // If not found, use first available vaccine
      if (coverageData.vaccines!.isNotEmpty) {
        selectedVaccine = coverageData.vaccines!.first;
        logg.w('TargetCalculator: Vaccine UID $vaccineUid not found, using first available vaccine');
      } else {
        logg.w('TargetCalculator: No vaccines available in coverage data');
        return null;
      }
    }

    // Try top-level fields first
    int targetMale = selectedVaccine.totalTargetMale ?? 0;
    int targetFemale = selectedVaccine.totalTargetFemale ?? 0;

    // If top-level fields are 0 or null, try to sum from areas array
    if ((targetMale == 0 && targetFemale == 0) &&
        selectedVaccine.areas != null &&
        selectedVaccine.areas!.isNotEmpty) {
      logg.i(
        'TargetCalculator: Top-level target fields are 0, calculating from areas array '
        '(${selectedVaccine.areas!.length} areas)',
      );
      targetMale = selectedVaccine.areas!
          .map((area) => area.targetMale ?? 0)
          .fold(0, (sum, value) => sum + value);
      targetFemale = selectedVaccine.areas!
          .map((area) => area.targetFemale ?? 0)
          .fold(0, (sum, value) => sum + value);
    }

    final total = targetMale + targetFemale;

    logg.i(
      'TargetCalculator: Extracted target data - '
      'total: $total, male: $targetMale, female: $targetFemale',
    );

    return TargetData(
      total: total,
      male: targetMale,
      female: targetFemale,
    );
  }

  /// Extract target data using the first available vaccine (for cases where vaccine UID is not specified)
  static TargetData? getTargetDataFromFirstVaccine(
    VaccineCoverageResponse? coverageData,
  ) {
    if (coverageData == null || coverageData.vaccines == null || coverageData.vaccines!.isEmpty) {
      logg.w('TargetCalculator: No vaccines available in coverage data');
      return null;
    }

    return getTargetData(coverageData, coverageData.vaccines!.first.vaccineUid);
  }
}
