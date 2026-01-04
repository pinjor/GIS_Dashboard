// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'session_plan_coords_response.freezed.dart';
part 'session_plan_coords_response.g.dart';

@freezed
abstract class SessionPlanCoordsResponse with _$SessionPlanCoordsResponse {
  factory SessionPlanCoordsResponse({
    String? type,
    List<Feature>? features,
    @JsonKey(name: 'session_count') int? sessionCount,
    Metadata? metadata,
  }) = _SessionPlanCoordsResponse;

  factory SessionPlanCoordsResponse.fromJson(Map<String, dynamic> json) =>
      _$SessionPlanCoordsResponseFromJson(json);
}

@freezed
abstract class Feature with _$Feature {
  factory Feature({
    Info? info,
    String? type,
    Geometry? geometry,
    @JsonKey(name: 'session_dates') String? sessionDates,
  }) = _Feature;

  factory Feature.fromJson(Map<String, dynamic> json) =>
      _$FeatureFromJson(json);
}

@freezed
abstract class Info with _$Info {
  factory Info({
    String? name,
    String? type,
    @JsonKey(name: 'org_uid') String? orgUid,
    @JsonKey(name: 'type_name') String? typeName,
    @JsonKey(name: 'is_fixed_center') bool? isFixedCenter,
  }) = _Info;

  factory Info.fromJson(Map<String, dynamic> json) => _$InfoFromJson(json);
}

@freezed
abstract class Geometry with _$Geometry {
  factory Geometry({
    String? type,
    List<double>? coordinates,
  }) = _Geometry;

  factory Geometry.fromJson(Map<String, dynamic> json) =>
      _$GeometryFromJson(json);
}

@freezed
abstract class Metadata with _$Metadata {
  factory Metadata({
    @JsonKey(name: 'generated_at') String? generatedAt,
    @JsonKey(name: 'data_structure') String? dataStructure,
  }) = _Metadata;

  factory Metadata.fromJson(Map<String, dynamic> json) =>
      _$MetadataFromJson(json);
}
