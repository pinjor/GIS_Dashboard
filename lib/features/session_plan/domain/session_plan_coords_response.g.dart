// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_plan_coords_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SessionPlanCoordsResponse _$SessionPlanCoordsResponseFromJson(
  Map<String, dynamic> json,
) => _SessionPlanCoordsResponse(
  type: json['type'] as String?,
  features: (json['features'] as List<dynamic>?)
      ?.map((e) => Feature.fromJson(e as Map<String, dynamic>))
      .toList(),
  sessionCount: (json['session_count'] as num?)?.toInt(),
  metadata: json['metadata'] == null
      ? null
      : Metadata.fromJson(json['metadata'] as Map<String, dynamic>),
);

Map<String, dynamic> _$SessionPlanCoordsResponseToJson(
  _SessionPlanCoordsResponse instance,
) => <String, dynamic>{
  'type': instance.type,
  'features': instance.features,
  'session_count': instance.sessionCount,
  'metadata': instance.metadata,
};

_Feature _$FeatureFromJson(Map<String, dynamic> json) => _Feature(
  info: json['info'] == null
      ? null
      : Info.fromJson(json['info'] as Map<String, dynamic>),
  type: json['type'] as String?,
  geometry: json['geometry'] == null
      ? null
      : Geometry.fromJson(json['geometry'] as Map<String, dynamic>),
  sessionDates: json['session_dates'] as String?,
);

Map<String, dynamic> _$FeatureToJson(_Feature instance) => <String, dynamic>{
  'info': instance.info,
  'type': instance.type,
  'geometry': instance.geometry,
  'session_dates': instance.sessionDates,
};

_Info _$InfoFromJson(Map<String, dynamic> json) => _Info(
  name: json['name'] as String?,
  type: json['type'] as String?,
  orgUid: json['org_uid'] as String?,
  typeName: json['type_name'] as String?,
  isFixedCenter: json['is_fixed_center'] as bool?,
);

Map<String, dynamic> _$InfoToJson(_Info instance) => <String, dynamic>{
  'name': instance.name,
  'type': instance.type,
  'org_uid': instance.orgUid,
  'type_name': instance.typeName,
  'is_fixed_center': instance.isFixedCenter,
};

_Geometry _$GeometryFromJson(Map<String, dynamic> json) => _Geometry(
  type: json['type'] as String?,
  coordinates: (json['coordinates'] as List<dynamic>?)
      ?.map((e) => (e as num).toDouble())
      .toList(),
);

Map<String, dynamic> _$GeometryToJson(_Geometry instance) => <String, dynamic>{
  'type': instance.type,
  'coordinates': instance.coordinates,
};

_Metadata _$MetadataFromJson(Map<String, dynamic> json) => _Metadata(
  generatedAt: json['generated_at'] as String?,
  dataStructure: json['data_structure'] as String?,
);

Map<String, dynamic> _$MetadataToJson(_Metadata instance) => <String, dynamic>{
  'generated_at': instance.generatedAt,
  'data_structure': instance.dataStructure,
};
