import 'package:gis_dashboard/features/summary/domain/vaccine_coverage_response.dart';
import 'package:gis_dashboard/core/utils/utils.dart';

/// Result structure for target or coverage data
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

/// Utility class to extract "Total Children (0-11 m)" and coverage stats
/// from VaccineCoverageResponse consistently across Summary and EPI Details.
class TargetCalculator {
  /// Find a matching area entry without falling back to the first item.
  static Area? findMatchingArea(
    List<Area> areas, {
    String? areaUid,
    String? areaName,
  }) {
    if (areas.isEmpty) return null;

    if (areaUid != null && areaUid.isNotEmpty) {
      for (final area in areas) {
        if (area.uid == areaUid) return area;
      }
      final lowerUid = areaUid.toLowerCase();
      for (final area in areas) {
        if (area.uid?.toLowerCase() == lowerUid) return area;
      }
    }

    if (areaName != null && areaName.isNotEmpty) {
      final lowerName = areaName.toLowerCase();
      for (final area in areas) {
        if (area.name?.toLowerCase() == lowerName) return area;
      }
      for (final area in areas) {
        final name = area.name?.toLowerCase() ?? '';
        if (name.contains(lowerName) || lowerName.contains(name)) {
          return area;
        }
      }
    }

    return null;
  }

  static Vaccine? _selectVaccine(
    VaccineCoverageResponse? coverageData,
    String? vaccineUid,
  ) {
    if (coverageData == null || coverageData.vaccines == null) {
      return null;
    }

    try {
      return coverageData.vaccines!.firstWhere(
        (vaccine) => vaccine.vaccineUid == vaccineUid,
      );
    } catch (_) {
      if (coverageData.vaccines!.isNotEmpty) {
        logg.w(
          'TargetCalculator: Vaccine UID $vaccineUid not found, using first vaccine',
        );
        return coverageData.vaccines!.first;
      }
    }
    return null;
  }

  static TargetData _fromArea(Area area, {required bool isCoverage}) {
    if (isCoverage) {
      final male = area.coverageMale ?? 0;
      final female = area.coverageFemale ?? 0;
      return TargetData(total: male + female, male: male, female: female);
    }

    final male = area.targetMale ?? 0;
    final female = area.targetFemale ?? 0;
    return TargetData(total: male + female, male: male, female: female);
  }

  static TargetData _fromVaccineTopLevel(
    Vaccine vaccine, {
    required bool isCoverage,
  }) {
    if (isCoverage) {
      final male = vaccine.totalCoverageMale ?? 0;
      final female = vaccine.totalCoverageFemale ?? 0;
      return TargetData(total: male + female, male: male, female: female);
    }

    final male = vaccine.totalTargetMale ?? 0;
    final female = vaccine.totalTargetFemale ?? 0;
    return TargetData(total: male + female, male: male, female: female);
  }

  static TargetData? _resolveStats(
    VaccineCoverageResponse? coverageData,
    String? vaccineUid, {
    String? areaUid,
    String? areaName,
    required bool isCoverage,
  }) {
    final selectedVaccine = _selectVaccine(coverageData, vaccineUid);
    if (selectedVaccine == null) return null;

    final hasAreaFilter =
        (areaUid != null && areaUid.isNotEmpty) ||
        (areaName != null && areaName.isNotEmpty);

    if (hasAreaFilter &&
        selectedVaccine.areas != null &&
        selectedVaccine.areas!.isNotEmpty) {
      final match = findMatchingArea(
        selectedVaccine.areas!,
        areaUid: areaUid,
        areaName: areaName,
      );
      if (match != null) {
        logg.i(
          'TargetCalculator: Using matched area ${match.name ?? match.uid} '
          'for ${isCoverage ? "coverage" : "target"}',
        );
        return _fromArea(match, isCoverage: isCoverage);
      }

      logg.w(
        'TargetCalculator: No area match for uid=$areaUid name=$areaName — '
        'using top-level ${isCoverage ? "coverage" : "target"} values',
      );
    }

    final topLevel = _fromVaccineTopLevel(
      selectedVaccine,
      isCoverage: isCoverage,
    );

    if ((topLevel.male > 0 || topLevel.female > 0) || !hasAreaFilter) {
      return topLevel;
    }

    // Only sum child areas when top-level is empty and no specific area filter.
    if (selectedVaccine.areas != null && selectedVaccine.areas!.isNotEmpty) {
      final male = selectedVaccine.areas!
          .map((area) => isCoverage ? (area.coverageMale ?? 0) : (area.targetMale ?? 0))
          .fold(0, (sum, value) => sum + value);
      final female = selectedVaccine.areas!
          .map((area) => isCoverage ? (area.coverageFemale ?? 0) : (area.targetFemale ?? 0))
          .fold(0, (sum, value) => sum + value);
      return TargetData(total: male + female, male: male, female: female);
    }

    return topLevel;
  }

  /// Extract target (0-11 m children) from coverage response.
  static TargetData? getTargetData(
    VaccineCoverageResponse? coverageData,
    String? vaccineUid, {
    String? areaUid,
    String? areaName,
  }) {
    return _resolveStats(
      coverageData,
      vaccineUid,
      areaUid: areaUid,
      areaName: areaName,
      isCoverage: false,
    );
  }

  /// Extract vaccinated children stats using the same area resolution as targets.
  static TargetData? getCoverageData(
    VaccineCoverageResponse? coverageData,
    String? vaccineUid, {
    String? areaUid,
    String? areaName,
  }) {
    return _resolveStats(
      coverageData,
      vaccineUid,
      areaUid: areaUid,
      areaName: areaName,
      isCoverage: true,
    );
  }

  static TargetData? getTargetDataFromFirstVaccine(
    VaccineCoverageResponse? coverageData,
  ) {
    if (coverageData == null ||
        coverageData.vaccines == null ||
        coverageData.vaccines!.isEmpty) {
      return null;
    }

    return getTargetData(coverageData, coverageData.vaccines!.first.vaccineUid);
  }
}
