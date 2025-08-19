// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'area_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AreaResponseModel _$AreaResponseModelFromJson(Map<String, dynamic> json) =>
    _AreaResponseModel(
      uid: json['uid'] as String?,
      name: json['name'] as String?,
      type: json['type'] as String?,
      parentUid: json['parent_uid'] as String?,
    );

Map<String, dynamic> _$AreaResponseModelToJson(_AreaResponseModel instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'name': instance.name,
      'type': instance.type,
      'parent_uid': instance.parentUid,
    };
