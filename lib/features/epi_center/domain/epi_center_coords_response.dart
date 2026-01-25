// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'epi_center_coords_response.freezed.dart';
part 'epi_center_coords_response.g.dart';

/// Root response model for EPI coordinates GeoJSON data
@freezed
abstract class EpiCenterCoordsResponse with _$EpiCenterCoordsResponse {
  const factory EpiCenterCoordsResponse({
    @JsonKey(name: 'type') String? type,
    @JsonKey(name: 'features') List<EpiFeature>? features,
    @JsonKey(name: 'epi_center_count') int? epiCenterCount,
    @JsonKey(name: 'total_count') int? totalCount,
  }) = _EpiCenterCoordsResponse;

  factory EpiCenterCoordsResponse.fromJson(Map<String, dynamic> json) =>
      _$EpiCenterCoordsResponseFromJson(json);
}

/// Individual feature in the GeoJSON response
@freezed
abstract class EpiFeature with _$EpiFeature {
  const factory EpiFeature({
    @JsonKey(name: 'type') String? type,
    @JsonKey(name: 'info') EpiInfo? info,
    @JsonKey(name: 'geometry') EpiGeometry? geometry,
  }) = _EpiFeature;

  factory EpiFeature.fromJson(Map<String, dynamic> json) =>
      _$EpiFeatureFromJson(json);
}

/// Information about the EPI center
@freezed
abstract class EpiInfo with _$EpiInfo {
  const factory EpiInfo({
    @JsonKey(name: 'type') String? type,
    @JsonKey(name: 'is_fixed_center') bool? isFixedCenter,
    @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'org_uid') String? orgUid,
  }) = _EpiInfo;

  factory EpiInfo.fromJson(Map<String, dynamic> json) =>
      _$EpiInfoFromJson(json);
}

/// Geometry information for the EPI center location
@freezed
abstract class EpiGeometry with _$EpiGeometry {
  const factory EpiGeometry({
    @JsonKey(name: 'type') String? type,
    @JsonKey(name: 'coordinates') List<double>? coordinates,
  }) = _EpiGeometry;

  factory EpiGeometry.fromJson(Map<String, dynamic> json) =>
      _$EpiGeometryFromJson(json);
}
