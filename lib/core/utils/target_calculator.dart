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
  /// Optionally filter by a specific area UID or name (for ward/subblock level filtering)
  /// Returns null if no data is available
  static TargetData? getTargetData(
    VaccineCoverageResponse? coverageData,
    String? vaccineUid, {
    String? areaUid,
    String? areaName,
  }) {
    logg.i('🔍 [0-11m DEBUG] TargetCalculator.getTargetData called');
    logg.i('   > Coverage data: ${coverageData != null ? "present" : "null"}');
    logg.i('   > Vaccine UID: $vaccineUid');
    
    if (coverageData == null || coverageData.vaccines == null) {
      logg.w('TargetCalculator: Coverage data is null or has no vaccines');
      return null;
    }

    logg.i('   > Available vaccines: ${coverageData.vaccines!.length}');
    for (var i = 0; i < coverageData.vaccines!.length; i++) {
      final v = coverageData.vaccines![i];
      logg.i('      [$i] ${v.vaccineName} (UID: ${v.vaccineUid}) - targets: M=${v.totalTargetMale ?? 0}, F=${v.totalTargetFemale ?? 0}, areas=${v.areas?.length ?? 0}');
    }

    // Find the selected vaccine
    Vaccine? selectedVaccine;
    try {
      selectedVaccine = coverageData.vaccines!.firstWhere(
        (vaccine) => vaccine.vaccineUid == vaccineUid,
      );
      logg.i('   ✅ Found selected vaccine: ${selectedVaccine.vaccineName} (UID: ${selectedVaccine.vaccineUid})');
    } catch (e) {
      // If not found, use first available vaccine
      if (coverageData.vaccines!.isNotEmpty) {
        selectedVaccine = coverageData.vaccines!.first;
        logg.w('TargetCalculator: Vaccine UID $vaccineUid not found, using first available vaccine: ${selectedVaccine.vaccineName}');
      } else {
        logg.w('TargetCalculator: No vaccines available in coverage data');
        return null;
      }
    }

    // Try top-level fields first
    int targetMale = selectedVaccine.totalTargetMale ?? 0;
    int targetFemale = selectedVaccine.totalTargetFemale ?? 0;
    
    logg.i('   > Top-level target fields: male=$targetMale, female=$targetFemale');
    logg.i('   > Areas array: ${selectedVaccine.areas != null ? "${selectedVaccine.areas!.length} areas" : "null"}');
    logg.i('   > Filter by area: ${areaUid != null ? "UID=$areaUid" : areaName != null ? "Name=$areaName" : "none"}');

    // ✅ FIX: If filtering by specific area (ward/subblock), find and use that area's data
    if ((areaUid != null || areaName != null) &&
        selectedVaccine.areas != null &&
        selectedVaccine.areas!.isNotEmpty) {
      logg.i('   > Filtering to specific area (ward/subblock level)');
      
      Area? matchingArea;
      final areas = selectedVaccine.areas!;
      
      if (areaUid != null) {
        try {
          matchingArea = areas.firstWhere(
            (area) => area.uid == areaUid,
          );
          logg.i('   > Found area by UID (exact match): ${matchingArea.name ?? matchingArea.uid}');
        } catch (e) {
          try {
            matchingArea = areas.firstWhere(
              (area) => area.uid?.toLowerCase() == areaUid.toLowerCase(),
            );
            logg.i('   > Found area by UID (case-insensitive): ${matchingArea.name ?? matchingArea.uid}');
          } catch (e2) {
            logg.w('   > Could not find area by UID: $areaUid');
            if (areas.isNotEmpty) {
              matchingArea = areas.first; // Fallback to first if not found
              logg.w('   > Using first area as fallback: ${matchingArea.name ?? matchingArea.uid}');
            }
          }
        }
      } else if (areaName != null) {
        try {
          matchingArea = areas.firstWhere(
            (area) => area.name?.toLowerCase() == areaName.toLowerCase(),
          );
          logg.i('   > Found area by name (exact match): ${matchingArea.name ?? matchingArea.uid}');
        } catch (e) {
          try {
            matchingArea = areas.firstWhere(
              (area) => area.name?.toLowerCase().contains(areaName.toLowerCase()) == true,
            );
            logg.i('   > Found area by name (contains match): ${matchingArea.name ?? matchingArea.uid}');
          } catch (e2) {
            logg.w('   > Could not find area by name: $areaName');
            if (areas.isNotEmpty) {
              matchingArea = areas.first; // Fallback to first if not found
              logg.w('   > Using first area as fallback: ${matchingArea.name ?? matchingArea.uid}');
            }
          }
        }
      }
      
      if (matchingArea != null) {
        targetMale = matchingArea.targetMale ?? 0;
        targetFemale = matchingArea.targetFemale ?? 0;
        logg.i('   ✅ Using filtered area data: male=$targetMale, female=$targetFemale');
      } else {
        logg.w('   ⚠️ Could not find matching area, using top-level or sum of all areas');
      }
    }
    
    // If top-level fields are 0 or null, and we haven't found a specific area, try to sum from areas array
    if ((targetMale == 0 && targetFemale == 0) &&
        selectedVaccine.areas != null &&
        selectedVaccine.areas!.isNotEmpty &&
        areaUid == null && areaName == null) {
      logg.i(
        'TargetCalculator: Top-level target fields are 0, calculating from areas array '
        '(${selectedVaccine.areas!.length} areas)',
      );
      
      // ✅ DEBUG: Log each area's contribution
      int areaIndex = 0;
      for (var area in selectedVaccine.areas!) {
        final areaMale = area.targetMale ?? 0;
        final areaFemale = area.targetFemale ?? 0;
        logg.d('      Area[$areaIndex]: ${area.name ?? area.uid ?? "unnamed"} - M=$areaMale, F=$areaFemale');
        areaIndex++;
      }
      
      targetMale = selectedVaccine.areas!
          .map((area) => area.targetMale ?? 0)
          .fold(0, (sum, value) => sum + value);
      targetFemale = selectedVaccine.areas!
          .map((area) => area.targetFemale ?? 0)
          .fold(0, (sum, value) => sum + value);
      
      logg.i('   > Calculated from areas: male=$targetMale, female=$targetFemale');
    } else if (targetMale > 0 || targetFemale > 0) {
      if (areaUid == null && areaName == null) {
        logg.i('   ✅ Using top-level target fields (not summing from areas)');
      }
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
