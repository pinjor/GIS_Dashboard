// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'epi_coords_response.freezed.dart';
part 'epi_coords_response.g.dart';

/// Root response model for EPI coordinates GeoJSON data
@freezed
abstract class EpiCoordsResponse with _$EpiCoordsResponse {
  const factory EpiCoordsResponse({
    @JsonKey(name: 'type') String? type,
    @JsonKey(name: 'features') List<EpiFeature>? features,
  }) = _EpiCoordsResponse;

  factory EpiCoordsResponse.fromJson(Map<String, dynamic> json) =>
      _$EpiCoordsResponseFromJson(json);
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
