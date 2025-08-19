// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'area_response_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AreaResponseModel {

@JsonKey(name: 'uid') String? get uid;@JsonKey(name: 'name') String? get name;@JsonKey(name: 'type') String? get type;@JsonKey(name: 'parent_uid') String? get parentUid;
/// Create a copy of AreaResponseModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AreaResponseModelCopyWith<AreaResponseModel> get copyWith => _$AreaResponseModelCopyWithImpl<AreaResponseModel>(this as AreaResponseModel, _$identity);

  /// Serializes this AreaResponseModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AreaResponseModel&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.name, name) || other.name == name)&&(identical(other.type, type) || other.type == type)&&(identical(other.parentUid, parentUid) || other.parentUid == parentUid));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,uid,name,type,parentUid);

@override
String toString() {
  return 'AreaResponseModel(uid: $uid, name: $name, type: $type, parentUid: $parentUid)';
}


}

/// @nodoc
abstract mixin class $AreaResponseModelCopyWith<$Res>  {
  factory $AreaResponseModelCopyWith(AreaResponseModel value, $Res Function(AreaResponseModel) _then) = _$AreaResponseModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'uid') String? uid,@JsonKey(name: 'name') String? name,@JsonKey(name: 'type') String? type,@JsonKey(name: 'parent_uid') String? parentUid
});




}
/// @nodoc
class _$AreaResponseModelCopyWithImpl<$Res>
    implements $AreaResponseModelCopyWith<$Res> {
  _$AreaResponseModelCopyWithImpl(this._self, this._then);

  final AreaResponseModel _self;
  final $Res Function(AreaResponseModel) _then;

/// Create a copy of AreaResponseModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? uid = freezed,Object? name = freezed,Object? type = freezed,Object? parentUid = freezed,}) {
  return _then(_self.copyWith(
uid: freezed == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,parentUid: freezed == parentUid ? _self.parentUid : parentUid // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AreaResponseModel].
extension AreaResponseModelPatterns on AreaResponseModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AreaResponseModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AreaResponseModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AreaResponseModel value)  $default,){
final _that = this;
switch (_that) {
case _AreaResponseModel():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AreaResponseModel value)?  $default,){
final _that = this;
switch (_that) {
case _AreaResponseModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'uid')  String? uid, @JsonKey(name: 'name')  String? name, @JsonKey(name: 'type')  String? type, @JsonKey(name: 'parent_uid')  String? parentUid)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AreaResponseModel() when $default != null:
return $default(_that.uid,_that.name,_that.type,_that.parentUid);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'uid')  String? uid, @JsonKey(name: 'name')  String? name, @JsonKey(name: 'type')  String? type, @JsonKey(name: 'parent_uid')  String? parentUid)  $default,) {final _that = this;
switch (_that) {
case _AreaResponseModel():
return $default(_that.uid,_that.name,_that.type,_that.parentUid);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'uid')  String? uid, @JsonKey(name: 'name')  String? name, @JsonKey(name: 'type')  String? type, @JsonKey(name: 'parent_uid')  String? parentUid)?  $default,) {final _that = this;
switch (_that) {
case _AreaResponseModel() when $default != null:
return $default(_that.uid,_that.name,_that.type,_that.parentUid);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AreaResponseModel implements AreaResponseModel {
  const _AreaResponseModel({@JsonKey(name: 'uid') this.uid, @JsonKey(name: 'name') this.name, @JsonKey(name: 'type') this.type, @JsonKey(name: 'parent_uid') this.parentUid});
  factory _AreaResponseModel.fromJson(Map<String, dynamic> json) => _$AreaResponseModelFromJson(json);

@override@JsonKey(name: 'uid') final  String? uid;
@override@JsonKey(name: 'name') final  String? name;
@override@JsonKey(name: 'type') final  String? type;
@override@JsonKey(name: 'parent_uid') final  String? parentUid;

/// Create a copy of AreaResponseModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AreaResponseModelCopyWith<_AreaResponseModel> get copyWith => __$AreaResponseModelCopyWithImpl<_AreaResponseModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AreaResponseModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AreaResponseModel&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.name, name) || other.name == name)&&(identical(other.type, type) || other.type == type)&&(identical(other.parentUid, parentUid) || other.parentUid == parentUid));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,uid,name,type,parentUid);

@override
String toString() {
  return 'AreaResponseModel(uid: $uid, name: $name, type: $type, parentUid: $parentUid)';
}


}

/// @nodoc
abstract mixin class _$AreaResponseModelCopyWith<$Res> implements $AreaResponseModelCopyWith<$Res> {
  factory _$AreaResponseModelCopyWith(_AreaResponseModel value, $Res Function(_AreaResponseModel) _then) = __$AreaResponseModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'uid') String? uid,@JsonKey(name: 'name') String? name,@JsonKey(name: 'type') String? type,@JsonKey(name: 'parent_uid') String? parentUid
});




}
/// @nodoc
class __$AreaResponseModelCopyWithImpl<$Res>
    implements _$AreaResponseModelCopyWith<$Res> {
  __$AreaResponseModelCopyWithImpl(this._self, this._then);

  final _AreaResponseModel _self;
  final $Res Function(_AreaResponseModel) _then;

/// Create a copy of AreaResponseModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? uid = freezed,Object? name = freezed,Object? type = freezed,Object? parentUid = freezed,}) {
  return _then(_AreaResponseModel(
uid: freezed == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,parentUid: freezed == parentUid ? _self.parentUid : parentUid // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
