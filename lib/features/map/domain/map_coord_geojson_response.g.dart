// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'map_coord_geojson_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MapCoordGeojsonResponse _$MapCoordGeojsonResponseFromJson(
  Map<String, dynamic> json,
) => _MapCoordGeojsonResponse(
  type: json['type'] as String?,
  info: json['info'] == null
      ? null
      : GeoJsonInfo.fromJson(json['info'] as Map<String, dynamic>),
  features: (json['features'] as List<dynamic>?)
      ?.map((e) => GeoJsonFeature.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$MapCoordGeojsonResponseToJson(
  _MapCoordGeojsonResponse instance,
) => <String, dynamic>{
  'type': instance.type,
  'info': instance.info,
  'features': instance.features,
};

_GeoJsonInfo _$GeoJsonInfoFromJson(Map<String, dynamic> json) => _GeoJsonInfo(
  type: json['type'] as String?,
  createdAt: json['created_at'] as String?,
);

Map<String, dynamic> _$GeoJsonInfoToJson(_GeoJsonInfo instance) =>
    <String, dynamic>{'type': instance.type, 'created_at': instance.createdAt};

_GeoJsonFeature _$GeoJsonFeatureFromJson(Map<String, dynamic> json) =>
    _GeoJsonFeature(
      type: json['type'] as String?,
      geometry: json['geometry'] == null
          ? null
          : GeoJsonGeometry.fromJson(json['geometry'] as Map<String, dynamic>),
      info: json['info'] == null
          ? null
          : FeatureInfo.fromJson(json['info'] as Map<String, dynamic>),
      properties: json['properties'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$GeoJsonFeatureToJson(_GeoJsonFeature instance) =>
    <String, dynamic>{
      'type': instance.type,
      'geometry': instance.geometry,
      'info': instance.info,
      'properties': instance.properties,
    };

_GeoJsonGeometry _$GeoJsonGeometryFromJson(Map<String, dynamic> json) =>
    _GeoJsonGeometry(
      type: json['type'] as String?,
      coordinates: json['coordinates'] as List<dynamic>?,
    );

Map<String, dynamic> _$GeoJsonGeometryToJson(_GeoJsonGeometry instance) =>
    <String, dynamic>{
      'type': instance.type,
      'coordinates': instance.coordinates,
    };

_FeatureInfo _$FeatureInfoFromJson(Map<String, dynamic> json) => _FeatureInfo(
  type: json['type'] as String?,
  name: json['name'] as String?,
  slug: json['slug'] as String?,
  orgUid: json['org_uid'] as String?,
  parentSlug: json['parent_slug'] as String?,
);

Map<String, dynamic> _$FeatureInfoToJson(_FeatureInfo instance) =>
    <String, dynamic>{
      'type': instance.type,
      'name': instance.name,
      'slug': instance.slug,
      'org_uid': instance.orgUid,
      'parent_slug': instance.parentSlug,
    };
