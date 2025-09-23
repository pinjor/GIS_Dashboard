// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'area_response_model.freezed.dart';
part 'area_response_model.g.dart';

@freezed
abstract class AreaResponseModel with _$AreaResponseModel {
  const factory AreaResponseModel({
    @JsonKey(name: 'uid') String? uid,
    @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'type') String? type,
    @JsonKey(name: 'parent_uid') String? parentUid,
  }) = _AreaResponseModel;

  factory AreaResponseModel.fromJson(Map<String, dynamic> json) =>
      _$AreaResponseModelFromJson(json);
}
