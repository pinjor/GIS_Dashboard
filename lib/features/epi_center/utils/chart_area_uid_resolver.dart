import '../../filter/domain/filter_state.dart';
import '../../filter/presentation/controllers/filter_controller.dart';
import '../../map/utils/map_enums.dart';
import '../domain/epi_center_details_response.dart';

/// Resolves a single area UID for the `/chart/{uid}` API from filter state.
///
/// The chart endpoint requires one UID, not slash-separated paths. Filter selection
/// takes priority over path segment count so a 5-segment ward slug path is not
/// mistaken for a subblock path.
class ChartAreaUidResolver {
  ChartAreaUidResolver._();

  /// Resolve chart UID after filter lists are loaded. Never falls back to a
  /// shallow parent UID when a deeper filter level is selected.
  static String? resolveChartUid({
    required FilterState filterState,
    required FilterControllerNotifier filterNotifier,
    String? orgUid,
    EpiCenterDetailsResponse? currentEpiData,
  }) {
    final fromFilter = resolveFromFilterState(
      filterState: filterState,
      filterNotifier: filterNotifier,
    );
    if (fromFilter != null && fromFilter.isNotEmpty) {
      return fromFilter;
    }

    if (orgUid != null && orgUid.isNotEmpty) {
      final resolved = resolve(
        filterState: filterState,
        filterNotifier: filterNotifier,
        orgUid: orgUid,
      );
      if (resolved != 'null') {
        return resolved;
      }
    }

    return _fallbackFromEpiData(filterState, currentEpiData);
  }

  static String? _fallbackFromEpiData(
    FilterState filterState,
    EpiCenterDetailsResponse? currentEpiData,
  ) {
    if (currentEpiData == null) return null;

    if (!isPlaceholder(filterState.selectedSubblock)) {
      return currentEpiData.subblockId;
    }
    if (!isPlaceholder(filterState.selectedWard)) {
      return currentEpiData.wardId;
    }
    if (!isPlaceholder(filterState.selectedUnion)) {
      return currentEpiData.unionId;
    }
    if (!isPlaceholder(filterState.selectedUpazila)) {
      return currentEpiData.upazilaId;
    }
    if (filterState.selectedDistrict != null &&
        filterState.selectedDistrict != 'All') {
      return currentEpiData.districtId;
    }
    if (filterState.selectedDivision != 'All') {
      return currentEpiData.divisionId;
    }

    return currentEpiData.uid ?? currentEpiData.wardId;
  }

  /// Resolve chart UID from filter state alone (no parent-level fallback).
  static String? resolveFromFilterState({
    required FilterState filterState,
    required FilterControllerNotifier filterNotifier,
  }) {
    if (filterState.selectedAreaType == AreaType.cityCorporation) {
      if (!isPlaceholder(filterState.selectedSubblock)) {
        return filterNotifier.getSubblockUid(filterState.selectedSubblock!);
      }
      if (!isPlaceholder(filterState.selectedWard)) {
        return filterNotifier.getWardUid(filterState.selectedWard!);
      }
      if (!isPlaceholder(filterState.selectedZone)) {
        return filterNotifier.getZoneUid(filterState.selectedZone!);
      }
      if (filterState.selectedCityCorporation != null) {
        return filterNotifier.getCityCorporationUid(
          filterState.selectedCityCorporation!,
        );
      }
      return null;
    }

    if (!isPlaceholder(filterState.selectedSubblock)) {
      return filterNotifier.getSubblockUid(filterState.selectedSubblock!);
    }
    if (!isPlaceholder(filterState.selectedWard)) {
      return filterNotifier.getWardUid(filterState.selectedWard!);
    }
    if (!isPlaceholder(filterState.selectedUnion)) {
      return filterNotifier.getUnionUid(filterState.selectedUnion!);
    }
    if (!isPlaceholder(filterState.selectedUpazila)) {
      return filterNotifier.getUpazilaUid(filterState.selectedUpazila!);
    }
    if (filterState.selectedDistrict != null &&
        filterState.selectedDistrict != 'All') {
      return filterNotifier.getDistrictUid(filterState.selectedDistrict!);
    }
    if (filterState.selectedDivision != 'All') {
      return filterNotifier.getDivisionUid(filterState.selectedDivision);
    }

    return null;
  }

  static bool isPlaceholder(String? value) {
    if (value == null || value.isEmpty) return true;
    return value == 'All' || value.startsWith('Select ');
  }

  static String resolve({
    required FilterState filterState,
    required FilterControllerNotifier filterNotifier,
    required String? orgUid,
  }) {
    if (orgUid == null || orgUid.isEmpty) {
      return 'null';
    }

    if (filterState.selectedAreaType == AreaType.cityCorporation) {
      return _resolveCityCorporation(filterState, filterNotifier, orgUid);
    }

    return _resolveDistrictHierarchy(filterState, filterNotifier, orgUid);
  }

  static String _lastSegment(String path) => path.split('/').last;

  static String _resolveCityCorporation(
    FilterState filterState,
    FilterControllerNotifier filterNotifier,
    String orgUid,
  ) {
    final pathSegments = orgUid.contains('/') ? orgUid.split('/').length : 1;

    if (!isPlaceholder(filterState.selectedSubblock)) {
      return filterNotifier.getSubblockUid(filterState.selectedSubblock!) ??
          (pathSegments >= 4 ? _lastSegment(orgUid) : 'null');
    }

    if (!isPlaceholder(filterState.selectedWard)) {
      return filterNotifier.getWardUid(filterState.selectedWard!) ??
          (pathSegments >= 3 ? _lastSegment(orgUid) : 'null');
    }

    if (!isPlaceholder(filterState.selectedZone)) {
      return filterNotifier.getZoneUid(filterState.selectedZone!) ??
          (pathSegments == 2 ? _lastSegment(orgUid) : 'null');
    }

    return orgUid.contains('/') ? _lastSegment(orgUid) : orgUid;
  }

  static String _resolveDistrictHierarchy(
    FilterState filterState,
    FilterControllerNotifier filterNotifier,
    String orgUid,
  ) {
    final pathSegments = orgUid.contains('/') ? orgUid.split('/').length : 1;

    if (!isPlaceholder(filterState.selectedSubblock)) {
      return filterNotifier.getSubblockUid(filterState.selectedSubblock!) ??
          (pathSegments >= 5 ? _lastSegment(orgUid) : 'null');
    }

    if (!isPlaceholder(filterState.selectedWard)) {
      return filterNotifier.getWardUid(filterState.selectedWard!) ??
          (pathSegments >= 4 ? _lastSegment(orgUid) : 'null');
    }

    if (!isPlaceholder(filterState.selectedUnion)) {
      return filterNotifier.getUnionUid(filterState.selectedUnion!) ??
          (pathSegments >= 3 ? _lastSegment(orgUid) : 'null');
    }

    if (!isPlaceholder(filterState.selectedUpazila)) {
      return filterNotifier.getUpazilaUid(filterState.selectedUpazila!) ??
          (pathSegments >= 2 ? _lastSegment(orgUid) : 'null');
    }

    if (!isPlaceholder(filterState.selectedDistrict)) {
      return filterNotifier.getDistrictUid(filterState.selectedDistrict!) ??
          orgUid;
    }

    if (filterState.selectedDivision != 'All') {
      return filterNotifier.getDivisionUid(filterState.selectedDivision) ??
          orgUid;
    }

    return orgUid.contains('/') ? _lastSegment(orgUid) : orgUid;
  }
}
