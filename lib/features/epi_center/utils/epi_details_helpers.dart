import '../../../core/utils/target_calculator.dart';
import '../../../core/utils/utils.dart';
import '../../filter/domain/filter_state.dart';
import '../../filter/presentation/controllers/filter_controller.dart';
import '../../map/utils/map_enums.dart';
import '../../summary/domain/vaccine_coverage_response.dart';
import '../domain/epi_center_details_response.dart';
import 'chart_area_uid_resolver.dart';

/// Shared helpers for View Details (EPI Center Details screen).
class EpiDetailsHelpers {
  EpiDetailsHelpers._();

  static bool _hasSubblock(FilterState filterState) {
    final subblock = filterState.selectedSubblock;
    return subblock != null &&
        subblock.isNotEmpty &&
        subblock != 'All' &&
        !subblock.startsWith('Select ');
  }

  static bool _hasWard(FilterState filterState) {
    final ward = filterState.selectedWard;
    return ward != null &&
        ward.isNotEmpty &&
        ward != 'All' &&
        !ward.startsWith('Select ');
  }

  /// Whether sub-block-only sections (EPI about details, yearly sessions) should show.
  static bool shouldShowSubblockOnlySections(FilterState filterState) {
    return _hasSubblock(filterState);
  }

  /// Resolve the area UID/name used when filtering summary coverage for the target card.
  /// When a ward is selected without a sub-block, the web uses the parent union target.
  static ({String? uid, String? name}) resolveTargetAreaFilter(
    FilterState filterState,
    FilterControllerNotifier filterNotifier,
  ) {
    if (_hasSubblock(filterState)) {
      final name = filterState.selectedSubblock!;
      return (uid: filterNotifier.getSubblockUid(name), name: name);
    }

    if (_hasWard(filterState)) {
      final unionName = filterState.selectedUnion;
      if (unionName != null && unionName != 'All') {
        return (uid: filterNotifier.getUnionUid(unionName), name: unionName);
      }
    }

    if (filterState.selectedUnion != null &&
        filterState.selectedUnion != 'All') {
      final name = filterState.selectedUnion!;
      return (uid: filterNotifier.getUnionUid(name), name: name);
    }

    if (filterState.selectedUpazila != null &&
        filterState.selectedUpazila != 'All') {
      final name = filterState.selectedUpazila!;
      return (uid: filterNotifier.getUpazilaUid(name), name: name);
    }

    if (filterState.selectedDistrict != null &&
        filterState.selectedDistrict != 'All') {
      final name = filterState.selectedDistrict!;
      return (uid: filterNotifier.getDistrictUid(name), name: name);
    }

    return (uid: null, name: null);
  }

  /// Resolve coverage area using loaded map context first (matches coverage JSON scope),
  /// then fall back to filter selections.
  static ({String? uid, String? name}) resolveCoverageAreaFilter(
    FilterState filterState,
    FilterControllerNotifier filterNotifier, {
    GeographicLevel? currentLevel,
    String? currentAreaName,
  }) {
    if (currentLevel != null &&
        currentAreaName != null &&
        currentAreaName.isNotEmpty &&
        currentAreaName != 'Bangladesh' &&
        currentAreaName != 'All City Corporations') {
      switch (currentLevel) {
        case GeographicLevel.subblock:
          return (
            uid: filterNotifier.getSubblockUid(currentAreaName),
            name: currentAreaName,
          );
        case GeographicLevel.ward:
          return (
            uid: filterNotifier.getWardUid(currentAreaName),
            name: currentAreaName,
          );
        case GeographicLevel.union:
          return (
            uid: filterNotifier.getUnionUid(currentAreaName),
            name: currentAreaName,
          );
        case GeographicLevel.upazila:
          return (
            uid: filterNotifier.getUpazilaUid(currentAreaName),
            name: currentAreaName,
          );
        case GeographicLevel.district:
          return (
            uid: filterNotifier.getDistrictUid(currentAreaName),
            name: currentAreaName,
          );
        case GeographicLevel.division:
          return (
            uid: filterNotifier.getDivisionUid(currentAreaName),
            name: currentAreaName,
          );
        default:
          return (uid: null, name: currentAreaName);
      }
    }

    return resolveTargetAreaFilter(filterState, filterNotifier);
  }

  /// Child 0-11 counts from chart demographics (matches web microplan table).
  static TargetData? getChild0To11FromDemographics(
    EpiCenterDetailsResponse? epiData,
    String selectedYear,
  ) {
    final childData = epiData?.getDemographicsForYear(selectedYear)?.child0To11Month;
    if (childData == null) return null;

    final male = childData.male ?? 0;
    final female = childData.female ?? 0;
    if (male == 0 && female == 0) return null;

    return TargetData(total: male + female, male: male, female: female);
  }

  /// Resolve target value shown at the top of View Details.
  static int? resolveTargetValue({
    required EpiCenterDetailsResponse? epiData,
    required FilterState filterState,
    required FilterControllerNotifier filterNotifier,
    required VaccineCoverageResponse? coverageData,
    required String? selectedVaccineUid,
    required String selectedYear,
  }) {
    final demographicsTarget = getChild0To11FromDemographics(epiData, selectedYear);
    if (demographicsTarget != null) {
      logg.i(
        'EpiDetailsHelpers: Using demographics child 0-11 → ${demographicsTarget.total}',
      );
      return demographicsTarget.total;
    }

    final areaFilter = resolveTargetAreaFilter(filterState, filterNotifier);

    if (coverageData != null) {
      final targetData = TargetCalculator.getTargetData(
        coverageData,
        selectedVaccineUid,
        areaUid: areaFilter.uid,
        areaName: areaFilter.uid == null ? areaFilter.name : null,
      );
      if (targetData != null && targetData.total > 0) {
        logg.i(
          'EpiDetailsHelpers: Using summary coverage target '
          '(area=${areaFilter.name ?? areaFilter.uid}) → ${targetData.total}',
        );
        return targetData.total;
      }
    }

    final chartTarget = epiData?.coverageTableData?.targets?.year;
    if (chartTarget != null && chartTarget > 0) {
      logg.i('EpiDetailsHelpers: Using chart API targets.year → $chartTarget');
      return chartTarget;
    }

    return null;
  }

  /// Resolve chart UID for reloading EPI data from filter selections.
  static Future<String?> resolveChartUidAsync({
    required FilterControllerNotifier filterNotifier,
    required FilterState Function() getFilterState,
    EpiCenterDetailsResponse? currentEpiData,
    String? orgUid,
  }) async {
    await filterNotifier.ensureHierarchyListsLoaded();

    return ChartAreaUidResolver.resolveChartUid(
      filterState: getFilterState(),
      filterNotifier: filterNotifier,
      orgUid: orgUid,
      currentEpiData: currentEpiData,
    );
  }

  /// Resolve chart UID for reloading EPI data from filter selections.
  static String? resolveChartUidFromFilter({
    required FilterState filterState,
    required FilterControllerNotifier filterNotifier,
    EpiCenterDetailsResponse? currentEpiData,
  }) {
    if (filterState.selectedAreaType == AreaType.cityCorporation) {
      if (_hasSubblock(filterState)) {
        return filterNotifier.getSubblockUid(filterState.selectedSubblock!) ??
            currentEpiData?.subblockId;
      }
      if (_hasWard(filterState)) {
        return filterNotifier.getWardUid(filterState.selectedWard!) ??
            currentEpiData?.wardId;
      }
      if (!ChartAreaUidResolver.isPlaceholder(filterState.selectedZone)) {
        return filterNotifier.getZoneUid(filterState.selectedZone!) ??
            currentEpiData?.uid;
      }
      if (filterState.selectedCityCorporation != null) {
        return filterNotifier.getCityCorporationUid(
              filterState.selectedCityCorporation!,
            ) ??
            currentEpiData?.uid;
      }
      return currentEpiData?.uid;
    }

    if (_hasSubblock(filterState)) {
      return filterNotifier.getSubblockUid(filterState.selectedSubblock!) ??
          currentEpiData?.subblockId;
    }
    if (_hasWard(filterState)) {
      return filterNotifier.getWardUid(filterState.selectedWard!) ??
          currentEpiData?.wardId;
    }
    if (filterState.selectedUnion != null &&
        filterState.selectedUnion != 'All') {
      return filterNotifier.getUnionUid(filterState.selectedUnion!) ??
          currentEpiData?.unionId;
    }
    if (filterState.selectedUpazila != null &&
        filterState.selectedUpazila != 'All') {
      return filterNotifier.getUpazilaUid(filterState.selectedUpazila!) ??
          currentEpiData?.upazilaId;
    }
    if (filterState.selectedDistrict != null &&
        filterState.selectedDistrict != 'All') {
      return filterNotifier.getDistrictUid(filterState.selectedDistrict!) ??
          currentEpiData?.districtId;
    }
    if (filterState.selectedDivision != 'All') {
      return filterNotifier.getDivisionUid(filterState.selectedDivision) ??
          currentEpiData?.divisionId;
    }

    return currentEpiData?.uid ?? currentEpiData?.wardId;
  }
}
