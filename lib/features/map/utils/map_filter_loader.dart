import '../../filter/domain/filter_state.dart';
import '../../filter/presentation/controllers/filter_controller.dart';
import '../../epi_center/utils/chart_area_uid_resolver.dart';
import '../presentation/controllers/map_controller.dart';
import 'map_enums.dart';
import '../../../core/utils/utils.dart';

/// Centralized map reload logic when geographic filters are applied.
class MapFilterLoader {
  MapFilterLoader._();

  static bool onlyVaccineChanged(FilterState previous, FilterState current) {
    return previous.selectedAreaType == current.selectedAreaType &&
        previous.selectedDivision == current.selectedDivision &&
        previous.selectedDistrict == current.selectedDistrict &&
        previous.selectedCityCorporation == current.selectedCityCorporation &&
        previous.selectedUpazila == current.selectedUpazila &&
        previous.selectedUnion == current.selectedUnion &&
        previous.selectedWard == current.selectedWard &&
        previous.selectedSubblock == current.selectedSubblock &&
        previous.selectedZone == current.selectedZone &&
        previous.selectedYear == current.selectedYear &&
        previous.selectedMonths.length == current.selectedMonths.length &&
        previous.selectedMonths.toSet().containsAll(current.selectedMonths) &&
        current.selectedMonths.toSet().containsAll(previous.selectedMonths) &&
        previous.selectedVaccine != current.selectedVaccine;
  }

  static Future<void> reloadForFilters({
    required MapControllerNotifier mapNotifier,
    required FilterControllerNotifier filterNotifier,
    required FilterState filterState,
  }) async {
    if (filterState.isEpiDetailsContext) {
      logg.i('MapFilterLoader: Skipping — EPI details context active');
      return;
    }

    logg.i(
      'MapFilterLoader: Reloading map for filters — '
      'division=${filterState.selectedDivision}, '
      'district=${filterState.selectedDistrict}, '
      'upazila=${filterState.selectedUpazila}, '
      'union=${filterState.selectedUnion}, '
      'ward=${filterState.selectedWard}, '
      'subblock=${filterState.selectedSubblock}',
    );

    await filterNotifier.ensureHierarchyListsLoaded();

    if (filterState.selectedAreaType == AreaType.cityCorporation) {
      await _reloadCityCorporation(mapNotifier, filterState);
      return;
    }

    await _reloadDistrictHierarchy(mapNotifier, filterState);
  }

  static Future<void> _reloadCityCorporation(
    MapControllerNotifier mapNotifier,
    FilterState filterState,
  ) async {
    if (!ChartAreaUidResolver.isPlaceholder(filterState.selectedSubblock)) {
      await mapNotifier.loadSubblockData(
        subblockName: filterState.selectedSubblock!,
      );
      return;
    }
    if (!ChartAreaUidResolver.isPlaceholder(filterState.selectedWard)) {
      await mapNotifier.loadWardData(wardName: filterState.selectedWard!);
      return;
    }
    if (!ChartAreaUidResolver.isPlaceholder(filterState.selectedZone)) {
      await mapNotifier.loadZoneData(zoneName: filterState.selectedZone!);
      return;
    }
    if (filterState.selectedCityCorporation != null &&
        filterState.selectedCityCorporation != 'All') {
      await mapNotifier.loadCityCorporationData(
        cityCorporationName: filterState.selectedCityCorporation!,
      );
      return;
    }
    await mapNotifier.loadAllCityCorporationsData();
  }

  static Future<void> _reloadDistrictHierarchy(
    MapControllerNotifier mapNotifier,
    FilterState filterState,
  ) async {
    if (!ChartAreaUidResolver.isPlaceholder(filterState.selectedSubblock)) {
      await mapNotifier.loadSubblockData(
        subblockName: filterState.selectedSubblock!,
      );
      return;
    }
    if (!ChartAreaUidResolver.isPlaceholder(filterState.selectedWard)) {
      await mapNotifier.loadWardData(wardName: filterState.selectedWard!);
      return;
    }
    if (!ChartAreaUidResolver.isPlaceholder(filterState.selectedUnion)) {
      await mapNotifier.loadUnionData(unionName: filterState.selectedUnion!);
      return;
    }
    if (!ChartAreaUidResolver.isPlaceholder(filterState.selectedUpazila)) {
      await mapNotifier.loadUpazilaData(upazilaName: filterState.selectedUpazila!);
      return;
    }
    if (filterState.selectedDistrict != null &&
        filterState.selectedDistrict != 'All') {
      await mapNotifier.loadDistrictData(
        districtName: filterState.selectedDistrict!,
      );
      return;
    }
    if (filterState.selectedDivision != 'All') {
      await mapNotifier.loadDivisionData(
        divisionName: filterState.selectedDivision,
      );
      return;
    }

    await mapNotifier.resetToCountryLevel();
  }
}
