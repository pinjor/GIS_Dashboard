import 'package:gis_dashboard/core/common/constants/api_constants.dart';
import 'package:gis_dashboard/features/filter/domain/filter_state.dart';
import 'package:gis_dashboard/features/filter/presentation/controllers/filter_controller.dart';
import 'package:gis_dashboard/features/map/utils/map_enums.dart';

/// Builds the `area` query parameter for the session-plans API.
///
/// Production API format (matches web dashboard):
/// - Division → `{division-slug}` (e.g. `rangpur-division`)
/// - District → `{district-slug}` (e.g. `rangpur`) — NOT `division/district`
/// - Upazila → `{upazila-slug}` (e.g. `mitha-pukur`) — NOT `district/upazila`
/// - Union → `{upazila-slug}/{union-slug}` (e.g. `mitha-pukur/balarhat`)
/// - Ward → `{upazila-slug}/{union-slug}/{ward-slug}`
/// - Subblock → `{upazila-slug}/{union-slug}/{ward-slug}/{subblock-slug}`
///
/// UID fallbacks use the same shape starting from upazila UID, not district UID.
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
    final hasSubblock = !isPlaceholder(state.selectedSubblock);
    final hasWard = !isPlaceholder(state.selectedWard);
    final hasUnion = !isPlaceholder(state.selectedUnion);
    final hasUpazila = !isPlaceholder(state.selectedUpazila);
    final hasDistrict = !isPlaceholder(state.selectedDistrict);
    final hasDivision = state.selectedDivision != 'All';

    // From upazila downward, paths start at upazila — never prefix district.
    if (hasUpazila) {
      final slugPath = _upazilaBasedSlugPath(
        upazila: state.selectedUpazila,
        union: hasUnion ? state.selectedUnion : null,
        ward: hasWard ? state.selectedWard : null,
        subblock: hasSubblock ? state.selectedSubblock : null,
      );
      if (slugPath != null) return slugPath;

      final uidPath = _upazilaBasedUidPath(
        filterNotifier,
        upazila: state.selectedUpazila,
        union: hasUnion ? state.selectedUnion : null,
        ward: hasWard ? state.selectedWard : null,
        subblock: hasSubblock ? state.selectedSubblock : null,
      );
      if (uidPath != null) return uidPath;
    }

    if (hasDistrict) {
      return ApiConstants.areaNameToSlug(state.selectedDistrict!);
    }

    if (hasDivision) {
      return ApiConstants.divisionNameToSlug(state.selectedDivision);
    }

    return null;
  }

  static String? _upazilaBasedSlugPath({
    String? upazila,
    String? union,
    String? ward,
    String? subblock,
  }) {
    if (isPlaceholder(upazila)) return null;

    final segments = <String>[ApiConstants.areaNameToSlug(upazila!)];

    if (!isPlaceholder(union)) {
      segments.add(ApiConstants.areaNameToSlug(union!));

      if (!isPlaceholder(ward)) {
        segments.add(ApiConstants.areaNameToSlug(ward!));

        if (!isPlaceholder(subblock)) {
          segments.add(ApiConstants.areaNameToSlug(subblock!));
        }
      }
    }

    return segments.join('/');
  }

  static String? _upazilaBasedUidPath(
    FilterControllerNotifier filterNotifier, {
    String? upazila,
    String? union,
    String? ward,
    String? subblock,
  }) {
    if (isPlaceholder(upazila)) return null;

    final upazilaUid = filterNotifier.getUpazilaUid(upazila!);
    if (upazilaUid == null || upazilaUid.isEmpty) return null;

    final segments = <String>[upazilaUid.toLowerCase()];

    if (!isPlaceholder(union)) {
      final unionUid = filterNotifier.getUnionUid(union!);
      if (unionUid == null || unionUid.isEmpty) return null;
      segments.add(unionUid.toLowerCase());

      if (!isPlaceholder(ward)) {
        final wardUid = filterNotifier.getWardUid(ward!);
        if (wardUid == null || wardUid.isEmpty) return null;
        segments.add(wardUid.toLowerCase());

        if (!isPlaceholder(subblock)) {
          final subblockUid = filterNotifier.getSubblockUid(subblock!);
          if (subblockUid == null || subblockUid.isEmpty) return null;
          segments.add(subblockUid.toLowerCase());
        }
      }
    }

    return segments.join('/');
  }
}
