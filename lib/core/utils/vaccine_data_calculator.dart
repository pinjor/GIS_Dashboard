import 'package:gis_dashboard/features/summary/domain/vaccine_coverage_response.dart';

class VaccineDataCalculator {
  static const Map<String, String> _monthToIdMap = {
    'January': '1',
    'February': '2',
    'March': '3',
    'April': '4',
    'May': '5',
    'June': '6',
    'July': '7',
    'August': '8',
    'September': '9',
    'October': '10',
    'November': '11',
    'December': '12',
  };

  static VaccineCoverageResponse? recalculateCoverageData(
    VaccineCoverageResponse? data,
    List<String> selectedMonths,
  ) {
    if (data == null) return null;
    if (selectedMonths.isEmpty) return data;

    final monthIds = selectedMonths
        .map((m) => _monthToIdMap[m])
        .whereType<String>()
        .toSet();

    if (monthIds.isEmpty) return data;

    // Recalculate vaccines
    final newVaccines = data.vaccines?.map((vaccine) {
      return _recalculateVaccine(vaccine, monthIds, selectedMonths.length);
    }).toList();

    return data.copyWith(vaccines: newVaccines);
  }

  static Vaccine _recalculateVaccine(
    Vaccine vaccine,
    Set<String> monthIds,
    int numberOfMonths,
  ) {
    int totalCov = 0;
    int totalCovMale = 0;
    int totalCovFemale = 0;
    Map<String, MonthlyCoverage> newMonthWiseMap = {};

    // Sum selected months for national/total level and filter the map
    if (vaccine.monthWiseTotalCoverages != null) {
      vaccine.monthWiseTotalCoverages!.forEach((key, value) {
        if (monthIds.contains(key)) {
          newMonthWiseMap[key] = value;
          totalCov += value.coverage ?? 0;
          totalCovMale += value.coverageMale ?? 0;
          totalCovFemale += value.coverageFemale ?? 0;
        }
      });
    }

    // Scale targets based on number of selected months (Proportional Target)
    // Formula: (Annual Target / 12) * Number of Selected Months
    // This allows the percentage to reflect "Performance against Target for Selected Period"
    final double monthFactor = numberOfMonths / 12.0;

    final int totalTarget = ((vaccine.totalTarget ?? 0) * monthFactor).round();
    final int totalTargetMale = ((vaccine.totalTargetMale ?? 0) * monthFactor)
        .round();
    final int totalTargetFemale =
        ((vaccine.totalTargetFemale ?? 0) * monthFactor).round();

    // Prevent division by zero if target becomes 0
    final safeTotalTarget = totalTarget > 0 ? totalTarget : 1;
    final safeTotalTargetMale = totalTargetMale > 0 ? totalTargetMale : 1;
    final safeTotalTargetFemale = totalTargetFemale > 0 ? totalTargetFemale : 1;

    // Recalculate areas first, so we can use them to find highest/lowest
    final newAreas = vaccine.areas?.map((area) {
      return _recalculateArea(area, monthIds, monthFactor);
    }).toList();

    // Recalculate performance by sorting the NEW areas
    final newPerformance = _recalculatePerformance(
      newAreas ?? [],
      vaccine.performance,
    );

    return vaccine.copyWith(
      totalCoverage: totalCov,
      totalCoverageMale: totalCovMale,
      totalCoverageFemale: totalCovFemale,
      totalTarget: totalTarget,
      totalTargetMale: totalTargetMale,
      totalTargetFemale: totalTargetFemale,
      // Filter the map so graph widgets only see selected months
      monthWiseTotalCoverages: newMonthWiseMap,
      totalCoveragePercentage: _calculatePercentage(totalCov, safeTotalTarget),
      totalCoveragePercentageMale: _calculatePercentage(
        totalCovMale,
        safeTotalTargetMale,
      ),
      totalCoveragePercentageFemale: _calculatePercentage(
        totalCovFemale,
        safeTotalTargetFemale,
      ),
      areas: newAreas,
      performance: newPerformance,
    );
  }

  static Area _recalculateArea(
    Area area,
    Set<String> monthIds,
    double monthFactor,
  ) {
    int cov = 0;
    int covMale = 0;
    int covFemale = 0;
    Map<String, MonthlyCoverage> newMonthlyCoverages = {};

    if (area.monthlyCoverages != null) {
      area.monthlyCoverages!.forEach((key, value) {
        if (monthIds.contains(key)) {
          newMonthlyCoverages[key] = value;
          cov += value.coverage ?? 0;
          covMale += value.coverageMale ?? 0;
          covFemale += value.coverageFemale ?? 0;
        }
      });
    }

    // Scale area targets
    final int target = ((area.target ?? 0) * monthFactor).round();
    final int targetMale = ((area.targetMale ?? 0) * monthFactor).round();
    final int targetFemale = ((area.targetFemale ?? 0) * monthFactor).round();

    final safeTarget = target > 0 ? target : 1;
    final safeTargetMale = targetMale > 0 ? targetMale : 1;
    final safeTargetFemale = targetFemale > 0 ? targetFemale : 1;

    final dropout = (safeTarget) - cov;
    final dropoutMale = (safeTargetMale) - covMale;
    final dropoutFemale = (safeTargetFemale) - covFemale;

    return area.copyWith(
      coverage: cov,
      coverageMale: covMale,
      coverageFemale: covFemale,
      target: target,
      targetMale: targetMale,
      targetFemale: targetFemale,
      monthlyCoverages: newMonthlyCoverages,
      coveragePercentage: _calculatePercentage(cov, safeTarget),
      coveragePercentageMale: _calculatePercentage(covMale, safeTargetMale),
      coveragePercentageFemale: _calculatePercentage(
        covFemale,
        safeTargetFemale,
      ),
      dropout: dropout.toDouble(),
      dropoutMale: dropoutMale.toDouble(),
      dropoutFemale: dropoutFemale.toDouble(),
    );
  }

  static Performance _recalculatePerformance(
    List<Area> recalculatedAreas,
    Performance? originalPerformance,
  ) {
    if (recalculatedAreas.isEmpty) {
      return originalPerformance?.copyWith(highest: [], lowest: []) ??
          const Performance(highest: [], lowest: []);
    }

    // Sort areas by coverage percentage descending
    final sortedAreas = List<Area>.from(recalculatedAreas);
    sortedAreas.sort((a, b) {
      final p1 = a.coveragePercentage ?? 0.0;
      final p2 = b.coveragePercentage ?? 0.0;
      return p2.compareTo(p1); // Descending
    });

    // Take top 5 and bottom 5 (or less if not enough areas)
    final top5 = sortedAreas.take(5).toList();
    final bottom5 = sortedAreas.reversed.take(5).toList();

    return Performance(highest: top5, lowest: bottom5);
  }

  static double _calculatePercentage(int value, int target) {
    if (target == 0) return 0.0;
    // Format to 2 decimal places to match API style likely
    return double.parse(((value / target) * 100).toStringAsFixed(2));
  }
}
