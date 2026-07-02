import 'package:gis_dashboard/core/common/constants/api_constants.dart';
import 'package:gis_dashboard/features/filter/domain/filter_state.dart';
import 'package:gis_dashboard/features/filter/presentation/controllers/filter_controller.dart';
import 'package:gis_dashboard/features/map/utils/map_enums.dart';

/// Builds the `area` query parameter for the session-plans API.
///
/// The web dashboard uses name-based slugs (not raw UIDs) for division and
/// district filters. Using UIDs at those levels returns inflated counts.
/// Upazila and deeper levels require a slash-separated slug path that includes
/// the selected division (e.g. `rangpur-division/dinajpur/biral/farakkabad`).
/// District-only filters use `{division}/{district}` when a division is selected.
class SessionPlanAreaParamBuilder {
  SessionPlanAreaParamBuilder._();

  static bool isPlaceholder(String? value) {
    if (value == null || value.isEmpty) return true;
    return value == 'All' || value.startsWith('Select ');
  }

  static bool isCityCorporationUnselected(FilterState state) {
    return isPlaceholder(state.selectedCityCorporation);
  }

  static bool isCountryLevel(FilterState state) {
    if (state.selectedAreaType == AreaType.cityCorporation) {
      return isCityCorporationUnselected(state);
    }

    return state.selectedDivision == 'All' &&
        isPlaceholder(state.selectedDistrict) &&
        isPlaceholder(state.selectedUpazila) &&
        isPlaceholder(state.selectedUnion) &&
        isPlaceholder(state.selectedWard) &&
        isPlaceholder(state.selectedSubblock);
  }

  /// Returns the session-plans `area` parameter, or null for country-level.
  static String? build(
    FilterState state,
    FilterControllerNotifier filterNotifier,
  ) {
    if (isCountryLevel(state)) {
      return null;
    }

    if (state.selectedAreaType == AreaType.cityCorporation) {
      return _buildCityCorporationParam(state, filterNotifier);
    }

    return _buildDistrictHierarchyParam(state, filterNotifier);
  }

  static String? _buildCityCorporationParam(
    FilterState state,
    FilterControllerNotifier filterNotifier,
  ) {
    final ccName = state.selectedCityCorporation;
    if (isPlaceholder(ccName)) {
      return null;
    }

    final ccSlug = ApiConstants.cityCorporationNameToSlug(ccName!);

    if (!isPlaceholder(state.selectedZone)) {
      final zoneUid = filterNotifier.getZoneUid(state.selectedZone!);
      if (zoneUid != null && zoneUid.isNotEmpty) {
        return '$ccSlug/${zoneUid.toLowerCase()}';
      }
    }

    return ccSlug;
  }

  static String? _buildDistrictHierarchyParam(
    FilterState state,
    FilterControllerNotifier filterNotifier,
  ) {
    final hasWard = !isPlaceholder(state.selectedWard);
    final hasUnion = !isPlaceholder(state.selectedUnion);
    final hasUpazila = !isPlaceholder(state.selectedUpazila);
    final hasDistrict = !isPlaceholder(state.selectedDistrict);
    final hasDivision = state.selectedDivision != 'All';
    final divisionName = hasDivision ? state.selectedDivision : null;

    if (hasWard) {
      final wardPath = _slugPath(
        division: divisionName,
        district: state.selectedDistrict,
        upazila: state.selectedUpazila,
        union: state.selectedUnion,
        ward: state.selectedWard,
      );
      if (wardPath != null) return wardPath;

      final wardUid = filterNotifier.getWardUid(state.selectedWard!);
      if (wardUid != null && wardUid.isNotEmpty) {
        return wardUid.toLowerCase();
      }
    }

    if (hasUnion) {
      final unionPath = _slugPath(
        division: divisionName,
        district: state.selectedDistrict,
        upazila: state.selectedUpazila,
        union: state.selectedUnion,
      );
      if (unionPath != null) return unionPath;

      final unionUid = filterNotifier.getUnionUid(state.selectedUnion!);
      if (unionUid != null && unionUid.isNotEmpty) {
        return unionUid.toLowerCase();
      }
    }

    if (hasUpazila) {
      final upazilaPath = _slugPath(
        division: divisionName,
        district: state.selectedDistrict,
        upazila: state.selectedUpazila,
      );
      if (upazilaPath != null) return upazilaPath;

      final upazilaUid = filterNotifier.getUpazilaUid(state.selectedUpazila!);
      if (upazilaUid != null && upazilaUid.isNotEmpty) {
        return upazilaUid.toLowerCase();
      }
    }

    if (hasDistrict) {
      final districtSlug = ApiConstants.areaNameToSlug(state.selectedDistrict!);
      if (hasDivision) {
        return '${ApiConstants.divisionNameToSlug(state.selectedDivision)}/$districtSlug';
      }
      return districtSlug;
    }

    if (hasDivision) {
      return ApiConstants.divisionNameToSlug(state.selectedDivision);
    }

    return null;
  }

  static String? _slugPath({
    String? division,
    String? district,
    String? upazila,
    String? union,
    String? ward,
  }) {
    final segments = <String>[];

    if (!isPlaceholder(division)) {
      segments.add(ApiConstants.divisionNameToSlug(division!));
    }
    if (!isPlaceholder(district)) {
      segments.add(ApiConstants.areaNameToSlug(district!));
    }
    if (!isPlaceholder(upazila)) {
      segments.add(ApiConstants.areaNameToSlug(upazila!));
    }
    if (!isPlaceholder(union)) {
      segments.add(ApiConstants.areaNameToSlug(union!));
    }
    if (!isPlaceholder(ward)) {
      segments.add(ApiConstants.areaNameToSlug(ward!));
    }

    if (segments.isEmpty) return null;
    return segments.join('/');
  }
}
