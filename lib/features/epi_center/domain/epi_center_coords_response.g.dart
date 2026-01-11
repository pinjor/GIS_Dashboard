// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'epi_center_coords_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_EpiCenterCoordsResponse _$EpiCenterCoordsResponseFromJson(
  Map<String, dynamic> json,
) => _EpiCenterCoordsResponse(
  type: json['type'] as String?,
  features: (json['features'] as List<dynamic>?)
      ?.map((e) => EpiFeature.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$EpiCenterCoordsResponseToJson(
  _EpiCenterCoordsResponse instance,
) => <String, dynamic>{'type': instance.type, 'features': instance.features};

_EpiFeature _$EpiFeatureFromJson(Map<String, dynamic> json) => _EpiFeature(
  type: json['type'] as String?,
  info: json['info'] == null
      ? null
      : EpiInfo.fromJson(json['info'] as Map<String, dynamic>),
  geometry: json['geometry'] == null
      ? null
      : EpiGeometry.fromJson(json['geometry'] as Map<String, dynamic>),
);

Map<String, dynamic> _$EpiFeatureToJson(_EpiFeature instance) =>
    <String, dynamic>{
      'type': instance.type,
      'info': instance.info,
      'geometry': instance.geometry,
    };

_EpiInfo _$EpiInfoFromJson(Map<String, dynamic> json) => _EpiInfo(
  type: json['type'] as String?,
  isFixedCenter: json['is_fixed_center'] as bool?,
  name: json['name'] as String?,
  orgUid: json['org_uid'] as String?,
);

Map<String, dynamic> _$EpiInfoToJson(_EpiInfo instance) => <String, dynamic>{
  'type': instance.type,
  'is_fixed_center': instance.isFixedCenter,
  'name': instance.name,
  'org_uid': instance.orgUid,
};

_EpiGeometry _$EpiGeometryFromJson(Map<String, dynamic> json) => _EpiGeometry(
  type: json['type'] as String?,
  coordinates: (json['coordinates'] as List<dynamic>?)
      ?.map((e) => (e as num).toDouble())
      .toList(),
);

Map<String, dynamic> _$EpiGeometryToJson(_EpiGeometry instance) =>
    <String, dynamic>{
      'type': instance.type,
      'coordinates': instance.coordinates,
    };
