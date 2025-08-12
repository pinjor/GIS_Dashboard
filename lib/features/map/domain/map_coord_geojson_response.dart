// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'map_coord_geojson_response.freezed.dart';
part 'map_coord_geojson_response.g.dart';

@freezed
abstract class MapCoordGeojsonResponse with _$MapCoordGeojsonResponse {
  const factory MapCoordGeojsonResponse({
    @JsonKey(name: 'type') String? type,
    @JsonKey(name: 'info') GeoJsonInfo? info,
    @JsonKey(name: 'features') List<GeoJsonFeature>? features,
  }) = _MapCoordGeojsonResponse;

  factory MapCoordGeojsonResponse.fromJson(Map<String, dynamic> json) =>
      _$MapCoordGeojsonResponseFromJson(json);
}

@freezed
abstract class GeoJsonInfo with _$GeoJsonInfo {
  const factory GeoJsonInfo({
    @JsonKey(name: 'type') String? type,
    @JsonKey(name: 'created_at') String? createdAt,
  }) = _GeoJsonInfo;

  factory GeoJsonInfo.fromJson(Map<String, dynamic> json) =>
      _$GeoJsonInfoFromJson(json);
}

@freezed
abstract class GeoJsonFeature with _$GeoJsonFeature {
  const factory GeoJsonFeature({
    @JsonKey(name: 'type') String? type,
    @JsonKey(name: 'geometry') GeoJsonGeometry? geometry,
    @JsonKey(name: 'info') FeatureInfo? info,
    @JsonKey(name: 'properties') Map<String, dynamic>? properties,
  }) = _GeoJsonFeature;

  factory GeoJsonFeature.fromJson(Map<String, dynamic> json) =>
      _$GeoJsonFeatureFromJson(json);
}

@freezed
abstract class GeoJsonGeometry with _$GeoJsonGeometry {
  const factory GeoJsonGeometry({
    @JsonKey(name: 'type') String? type,
    @JsonKey(name: 'coordinates') List<dynamic>? coordinates,
  }) = _GeoJsonGeometry;

  factory GeoJsonGeometry.fromJson(Map<String, dynamic> json) =>
      _$GeoJsonGeometryFromJson(json);
}

@freezed
abstract class FeatureInfo with _$FeatureInfo {
  const factory FeatureInfo({
    @JsonKey(name: 'type') String? type,
    @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'slug') String? slug,
    @JsonKey(name: 'org_uid') String? orgUid,
    @JsonKey(name: 'parent_slug') String? parentSlug,
  }) = _FeatureInfo;

  factory FeatureInfo.fromJson(Map<String, dynamic> json) =>
      _$FeatureInfoFromJson(json);
}
