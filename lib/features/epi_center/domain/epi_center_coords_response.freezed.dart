// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'epi_center_coords_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$EpiCenterCoordsResponse {

@JsonKey(name: 'type') String? get type;@JsonKey(name: 'features') List<EpiFeature>? get features;
/// Create a copy of EpiCenterCoordsResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EpiCenterCoordsResponseCopyWith<EpiCenterCoordsResponse> get copyWith => _$EpiCenterCoordsResponseCopyWithImpl<EpiCenterCoordsResponse>(this as EpiCenterCoordsResponse, _$identity);

  /// Serializes this EpiCenterCoordsResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EpiCenterCoordsResponse&&(identical(other.type, type) || other.type == type)&&const DeepCollectionEquality().equals(other.features, features));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,const DeepCollectionEquality().hash(features));

@override
String toString() {
  return 'EpiCenterCoordsResponse(type: $type, features: $features)';
}


}

/// @nodoc
abstract mixin class $EpiCenterCoordsResponseCopyWith<$Res>  {
  factory $EpiCenterCoordsResponseCopyWith(EpiCenterCoordsResponse value, $Res Function(EpiCenterCoordsResponse) _then) = _$EpiCenterCoordsResponseCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'type') String? type,@JsonKey(name: 'features') List<EpiFeature>? features
});




}
/// @nodoc
class _$EpiCenterCoordsResponseCopyWithImpl<$Res>
    implements $EpiCenterCoordsResponseCopyWith<$Res> {
  _$EpiCenterCoordsResponseCopyWithImpl(this._self, this._then);

  final EpiCenterCoordsResponse _self;
  final $Res Function(EpiCenterCoordsResponse) _then;

/// Create a copy of EpiCenterCoordsResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = freezed,Object? features = freezed,}) {
  return _then(_self.copyWith(
type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,features: freezed == features ? _self.features : features // ignore: cast_nullable_to_non_nullable
as List<EpiFeature>?,
  ));
}

}


/// Adds pattern-matching-related methods to [EpiCenterCoordsResponse].
extension EpiCenterCoordsResponsePatterns on EpiCenterCoordsResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EpiCenterCoordsResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EpiCenterCoordsResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EpiCenterCoordsResponse value)  $default,){
final _that = this;
switch (_that) {
case _EpiCenterCoordsResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EpiCenterCoordsResponse value)?  $default,){
final _that = this;
switch (_that) {
case _EpiCenterCoordsResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'type')  String? type, @JsonKey(name: 'features')  List<EpiFeature>? features)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EpiCenterCoordsResponse() when $default != null:
return $default(_that.type,_that.features);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'type')  String? type, @JsonKey(name: 'features')  List<EpiFeature>? features)  $default,) {final _that = this;
switch (_that) {
case _EpiCenterCoordsResponse():
return $default(_that.type,_that.features);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'type')  String? type, @JsonKey(name: 'features')  List<EpiFeature>? features)?  $default,) {final _that = this;
switch (_that) {
case _EpiCenterCoordsResponse() when $default != null:
return $default(_that.type,_that.features);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EpiCenterCoordsResponse implements EpiCenterCoordsResponse {
  const _EpiCenterCoordsResponse({@JsonKey(name: 'type') this.type, @JsonKey(name: 'features') final  List<EpiFeature>? features}): _features = features;
  factory _EpiCenterCoordsResponse.fromJson(Map<String, dynamic> json) => _$EpiCenterCoordsResponseFromJson(json);

@override@JsonKey(name: 'type') final  String? type;
 final  List<EpiFeature>? _features;
@override@JsonKey(name: 'features') List<EpiFeature>? get features {
  final value = _features;
  if (value == null) return null;
  if (_features is EqualUnmodifiableListView) return _features;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of EpiCenterCoordsResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EpiCenterCoordsResponseCopyWith<_EpiCenterCoordsResponse> get copyWith => __$EpiCenterCoordsResponseCopyWithImpl<_EpiCenterCoordsResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EpiCenterCoordsResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EpiCenterCoordsResponse&&(identical(other.type, type) || other.type == type)&&const DeepCollectionEquality().equals(other._features, _features));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,const DeepCollectionEquality().hash(_features));

@override
String toString() {
  return 'EpiCenterCoordsResponse(type: $type, features: $features)';
}


}

/// @nodoc
abstract mixin class _$EpiCenterCoordsResponseCopyWith<$Res> implements $EpiCenterCoordsResponseCopyWith<$Res> {
  factory _$EpiCenterCoordsResponseCopyWith(_EpiCenterCoordsResponse value, $Res Function(_EpiCenterCoordsResponse) _then) = __$EpiCenterCoordsResponseCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'type') String? type,@JsonKey(name: 'features') List<EpiFeature>? features
});




}
/// @nodoc
class __$EpiCenterCoordsResponseCopyWithImpl<$Res>
    implements _$EpiCenterCoordsResponseCopyWith<$Res> {
  __$EpiCenterCoordsResponseCopyWithImpl(this._self, this._then);

  final _EpiCenterCoordsResponse _self;
  final $Res Function(_EpiCenterCoordsResponse) _then;

/// Create a copy of EpiCenterCoordsResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = freezed,Object? features = freezed,}) {
  return _then(_EpiCenterCoordsResponse(
type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,features: freezed == features ? _self._features : features // ignore: cast_nullable_to_non_nullable
as List<EpiFeature>?,
  ));
}


}


/// @nodoc
mixin _$EpiFeature {

@JsonKey(name: 'type') String? get type;@JsonKey(name: 'info') EpiInfo? get info;@JsonKey(name: 'geometry') EpiGeometry? get geometry;
/// Create a copy of EpiFeature
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EpiFeatureCopyWith<EpiFeature> get copyWith => _$EpiFeatureCopyWithImpl<EpiFeature>(this as EpiFeature, _$identity);

  /// Serializes this EpiFeature to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EpiFeature&&(identical(other.type, type) || other.type == type)&&(identical(other.info, info) || other.info == info)&&(identical(other.geometry, geometry) || other.geometry == geometry));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,info,geometry);

@override
String toString() {
  return 'EpiFeature(type: $type, info: $info, geometry: $geometry)';
}


}

/// @nodoc
abstract mixin class $EpiFeatureCopyWith<$Res>  {
  factory $EpiFeatureCopyWith(EpiFeature value, $Res Function(EpiFeature) _then) = _$EpiFeatureCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'type') String? type,@JsonKey(name: 'info') EpiInfo? info,@JsonKey(name: 'geometry') EpiGeometry? geometry
});


$EpiInfoCopyWith<$Res>? get info;$EpiGeometryCopyWith<$Res>? get geometry;

}
/// @nodoc
class _$EpiFeatureCopyWithImpl<$Res>
    implements $EpiFeatureCopyWith<$Res> {
  _$EpiFeatureCopyWithImpl(this._self, this._then);

  final EpiFeature _self;
  final $Res Function(EpiFeature) _then;

/// Create a copy of EpiFeature
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = freezed,Object? info = freezed,Object? geometry = freezed,}) {
  return _then(_self.copyWith(
type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,info: freezed == info ? _self.info : info // ignore: cast_nullable_to_non_nullable
as EpiInfo?,geometry: freezed == geometry ? _self.geometry : geometry // ignore: cast_nullable_to_non_nullable
as EpiGeometry?,
  ));
}
/// Create a copy of EpiFeature
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EpiInfoCopyWith<$Res>? get info {
    if (_self.info == null) {
    return null;
  }

  return $EpiInfoCopyWith<$Res>(_self.info!, (value) {
    return _then(_self.copyWith(info: value));
  });
}/// Create a copy of EpiFeature
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EpiGeometryCopyWith<$Res>? get geometry {
    if (_self.geometry == null) {
    return null;
  }

  return $EpiGeometryCopyWith<$Res>(_self.geometry!, (value) {
    return _then(_self.copyWith(geometry: value));
  });
}
}


/// Adds pattern-matching-related methods to [EpiFeature].
extension EpiFeaturePatterns on EpiFeature {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EpiFeature value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EpiFeature() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EpiFeature value)  $default,){
final _that = this;
switch (_that) {
case _EpiFeature():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EpiFeature value)?  $default,){
final _that = this;
switch (_that) {
case _EpiFeature() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'type')  String? type, @JsonKey(name: 'info')  EpiInfo? info, @JsonKey(name: 'geometry')  EpiGeometry? geometry)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EpiFeature() when $default != null:
return $default(_that.type,_that.info,_that.geometry);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'type')  String? type, @JsonKey(name: 'info')  EpiInfo? info, @JsonKey(name: 'geometry')  EpiGeometry? geometry)  $default,) {final _that = this;
switch (_that) {
case _EpiFeature():
return $default(_that.type,_that.info,_that.geometry);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'type')  String? type, @JsonKey(name: 'info')  EpiInfo? info, @JsonKey(name: 'geometry')  EpiGeometry? geometry)?  $default,) {final _that = this;
switch (_that) {
case _EpiFeature() when $default != null:
return $default(_that.type,_that.info,_that.geometry);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EpiFeature implements EpiFeature {
  const _EpiFeature({@JsonKey(name: 'type') this.type, @JsonKey(name: 'info') this.info, @JsonKey(name: 'geometry') this.geometry});
  factory _EpiFeature.fromJson(Map<String, dynamic> json) => _$EpiFeatureFromJson(json);

@override@JsonKey(name: 'type') final  String? type;
@override@JsonKey(name: 'info') final  EpiInfo? info;
@override@JsonKey(name: 'geometry') final  EpiGeometry? geometry;

/// Create a copy of EpiFeature
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EpiFeatureCopyWith<_EpiFeature> get copyWith => __$EpiFeatureCopyWithImpl<_EpiFeature>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EpiFeatureToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EpiFeature&&(identical(other.type, type) || other.type == type)&&(identical(other.info, info) || other.info == info)&&(identical(other.geometry, geometry) || other.geometry == geometry));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,info,geometry);

@override
String toString() {
  return 'EpiFeature(type: $type, info: $info, geometry: $geometry)';
}


}

/// @nodoc
abstract mixin class _$EpiFeatureCopyWith<$Res> implements $EpiFeatureCopyWith<$Res> {
  factory _$EpiFeatureCopyWith(_EpiFeature value, $Res Function(_EpiFeature) _then) = __$EpiFeatureCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'type') String? type,@JsonKey(name: 'info') EpiInfo? info,@JsonKey(name: 'geometry') EpiGeometry? geometry
});


@override $EpiInfoCopyWith<$Res>? get info;@override $EpiGeometryCopyWith<$Res>? get geometry;

}
/// @nodoc
class __$EpiFeatureCopyWithImpl<$Res>
    implements _$EpiFeatureCopyWith<$Res> {
  __$EpiFeatureCopyWithImpl(this._self, this._then);

  final _EpiFeature _self;
  final $Res Function(_EpiFeature) _then;

/// Create a copy of EpiFeature
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = freezed,Object? info = freezed,Object? geometry = freezed,}) {
  return _then(_EpiFeature(
type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,info: freezed == info ? _self.info : info // ignore: cast_nullable_to_non_nullable
as EpiInfo?,geometry: freezed == geometry ? _self.geometry : geometry // ignore: cast_nullable_to_non_nullable
as EpiGeometry?,
  ));
}

/// Create a copy of EpiFeature
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EpiInfoCopyWith<$Res>? get info {
    if (_self.info == null) {
    return null;
  }

  return $EpiInfoCopyWith<$Res>(_self.info!, (value) {
    return _then(_self.copyWith(info: value));
  });
}/// Create a copy of EpiFeature
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EpiGeometryCopyWith<$Res>? get geometry {
    if (_self.geometry == null) {
    return null;
  }

  return $EpiGeometryCopyWith<$Res>(_self.geometry!, (value) {
    return _then(_self.copyWith(geometry: value));
  });
}
}


/// @nodoc
mixin _$EpiInfo {

@JsonKey(name: 'type') String? get type;@JsonKey(name: 'is_fixed_center') bool? get isFixedCenter;@JsonKey(name: 'name') String? get name;@JsonKey(name: 'org_uid') String? get orgUid;
/// Create a copy of EpiInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EpiInfoCopyWith<EpiInfo> get copyWith => _$EpiInfoCopyWithImpl<EpiInfo>(this as EpiInfo, _$identity);

  /// Serializes this EpiInfo to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EpiInfo&&(identical(other.type, type) || other.type == type)&&(identical(other.isFixedCenter, isFixedCenter) || other.isFixedCenter == isFixedCenter)&&(identical(other.name, name) || other.name == name)&&(identical(other.orgUid, orgUid) || other.orgUid == orgUid));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,isFixedCenter,name,orgUid);

@override
String toString() {
  return 'EpiInfo(type: $type, isFixedCenter: $isFixedCenter, name: $name, orgUid: $orgUid)';
}


}

/// @nodoc
abstract mixin class $EpiInfoCopyWith<$Res>  {
  factory $EpiInfoCopyWith(EpiInfo value, $Res Function(EpiInfo) _then) = _$EpiInfoCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'type') String? type,@JsonKey(name: 'is_fixed_center') bool? isFixedCenter,@JsonKey(name: 'name') String? name,@JsonKey(name: 'org_uid') String? orgUid
});




}
/// @nodoc
class _$EpiInfoCopyWithImpl<$Res>
    implements $EpiInfoCopyWith<$Res> {
  _$EpiInfoCopyWithImpl(this._self, this._then);

  final EpiInfo _self;
  final $Res Function(EpiInfo) _then;

/// Create a copy of EpiInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = freezed,Object? isFixedCenter = freezed,Object? name = freezed,Object? orgUid = freezed,}) {
  return _then(_self.copyWith(
type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,isFixedCenter: freezed == isFixedCenter ? _self.isFixedCenter : isFixedCenter // ignore: cast_nullable_to_non_nullable
as bool?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,orgUid: freezed == orgUid ? _self.orgUid : orgUid // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [EpiInfo].
extension EpiInfoPatterns on EpiInfo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EpiInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EpiInfo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EpiInfo value)  $default,){
final _that = this;
switch (_that) {
case _EpiInfo():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EpiInfo value)?  $default,){
final _that = this;
switch (_that) {
case _EpiInfo() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'type')  String? type, @JsonKey(name: 'is_fixed_center')  bool? isFixedCenter, @JsonKey(name: 'name')  String? name, @JsonKey(name: 'org_uid')  String? orgUid)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EpiInfo() when $default != null:
return $default(_that.type,_that.isFixedCenter,_that.name,_that.orgUid);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'type')  String? type, @JsonKey(name: 'is_fixed_center')  bool? isFixedCenter, @JsonKey(name: 'name')  String? name, @JsonKey(name: 'org_uid')  String? orgUid)  $default,) {final _that = this;
switch (_that) {
case _EpiInfo():
return $default(_that.type,_that.isFixedCenter,_that.name,_that.orgUid);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'type')  String? type, @JsonKey(name: 'is_fixed_center')  bool? isFixedCenter, @JsonKey(name: 'name')  String? name, @JsonKey(name: 'org_uid')  String? orgUid)?  $default,) {final _that = this;
switch (_that) {
case _EpiInfo() when $default != null:
return $default(_that.type,_that.isFixedCenter,_that.name,_that.orgUid);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EpiInfo implements EpiInfo {
  const _EpiInfo({@JsonKey(name: 'type') this.type, @JsonKey(name: 'is_fixed_center') this.isFixedCenter, @JsonKey(name: 'name') this.name, @JsonKey(name: 'org_uid') this.orgUid});
  factory _EpiInfo.fromJson(Map<String, dynamic> json) => _$EpiInfoFromJson(json);

@override@JsonKey(name: 'type') final  String? type;
@override@JsonKey(name: 'is_fixed_center') final  bool? isFixedCenter;
@override@JsonKey(name: 'name') final  String? name;
@override@JsonKey(name: 'org_uid') final  String? orgUid;

/// Create a copy of EpiInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EpiInfoCopyWith<_EpiInfo> get copyWith => __$EpiInfoCopyWithImpl<_EpiInfo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EpiInfoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EpiInfo&&(identical(other.type, type) || other.type == type)&&(identical(other.isFixedCenter, isFixedCenter) || other.isFixedCenter == isFixedCenter)&&(identical(other.name, name) || other.name == name)&&(identical(other.orgUid, orgUid) || other.orgUid == orgUid));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,isFixedCenter,name,orgUid);

@override
String toString() {
  return 'EpiInfo(type: $type, isFixedCenter: $isFixedCenter, name: $name, orgUid: $orgUid)';
}


}

/// @nodoc
abstract mixin class _$EpiInfoCopyWith<$Res> implements $EpiInfoCopyWith<$Res> {
  factory _$EpiInfoCopyWith(_EpiInfo value, $Res Function(_EpiInfo) _then) = __$EpiInfoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'type') String? type,@JsonKey(name: 'is_fixed_center') bool? isFixedCenter,@JsonKey(name: 'name') String? name,@JsonKey(name: 'org_uid') String? orgUid
});




}
/// @nodoc
class __$EpiInfoCopyWithImpl<$Res>
    implements _$EpiInfoCopyWith<$Res> {
  __$EpiInfoCopyWithImpl(this._self, this._then);

  final _EpiInfo _self;
  final $Res Function(_EpiInfo) _then;

/// Create a copy of EpiInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = freezed,Object? isFixedCenter = freezed,Object? name = freezed,Object? orgUid = freezed,}) {
  return _then(_EpiInfo(
type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,isFixedCenter: freezed == isFixedCenter ? _self.isFixedCenter : isFixedCenter // ignore: cast_nullable_to_non_nullable
as bool?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,orgUid: freezed == orgUid ? _self.orgUid : orgUid // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$EpiGeometry {

@JsonKey(name: 'type') String? get type;@JsonKey(name: 'coordinates') List<double>? get coordinates;
/// Create a copy of EpiGeometry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EpiGeometryCopyWith<EpiGeometry> get copyWith => _$EpiGeometryCopyWithImpl<EpiGeometry>(this as EpiGeometry, _$identity);

  /// Serializes this EpiGeometry to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EpiGeometry&&(identical(other.type, type) || other.type == type)&&const DeepCollectionEquality().equals(other.coordinates, coordinates));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,const DeepCollectionEquality().hash(coordinates));

@override
String toString() {
  return 'EpiGeometry(type: $type, coordinates: $coordinates)';
}


}

/// @nodoc
abstract mixin class $EpiGeometryCopyWith<$Res>  {
  factory $EpiGeometryCopyWith(EpiGeometry value, $Res Function(EpiGeometry) _then) = _$EpiGeometryCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'type') String? type,@JsonKey(name: 'coordinates') List<double>? coordinates
});




}
/// @nodoc
class _$EpiGeometryCopyWithImpl<$Res>
    implements $EpiGeometryCopyWith<$Res> {
  _$EpiGeometryCopyWithImpl(this._self, this._then);

  final EpiGeometry _self;
  final $Res Function(EpiGeometry) _then;

/// Create a copy of EpiGeometry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = freezed,Object? coordinates = freezed,}) {
  return _then(_self.copyWith(
type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,coordinates: freezed == coordinates ? _self.coordinates : coordinates // ignore: cast_nullable_to_non_nullable
as List<double>?,
  ));
}

}


/// Adds pattern-matching-related methods to [EpiGeometry].
extension EpiGeometryPatterns on EpiGeometry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EpiGeometry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EpiGeometry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EpiGeometry value)  $default,){
final _that = this;
switch (_that) {
case _EpiGeometry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EpiGeometry value)?  $default,){
final _that = this;
switch (_that) {
case _EpiGeometry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'type')  String? type, @JsonKey(name: 'coordinates')  List<double>? coordinates)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EpiGeometry() when $default != null:
return $default(_that.type,_that.coordinates);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'type')  String? type, @JsonKey(name: 'coordinates')  List<double>? coordinates)  $default,) {final _that = this;
switch (_that) {
case _EpiGeometry():
return $default(_that.type,_that.coordinates);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'type')  String? type, @JsonKey(name: 'coordinates')  List<double>? coordinates)?  $default,) {final _that = this;
switch (_that) {
case _EpiGeometry() when $default != null:
return $default(_that.type,_that.coordinates);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EpiGeometry implements EpiGeometry {
  const _EpiGeometry({@JsonKey(name: 'type') this.type, @JsonKey(name: 'coordinates') final  List<double>? coordinates}): _coordinates = coordinates;
  factory _EpiGeometry.fromJson(Map<String, dynamic> json) => _$EpiGeometryFromJson(json);

@override@JsonKey(name: 'type') final  String? type;
 final  List<double>? _coordinates;
@override@JsonKey(name: 'coordinates') List<double>? get coordinates {
  final value = _coordinates;
  if (value == null) return null;
  if (_coordinates is EqualUnmodifiableListView) return _coordinates;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of EpiGeometry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EpiGeometryCopyWith<_EpiGeometry> get copyWith => __$EpiGeometryCopyWithImpl<_EpiGeometry>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EpiGeometryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EpiGeometry&&(identical(other.type, type) || other.type == type)&&const DeepCollectionEquality().equals(other._coordinates, _coordinates));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,const DeepCollectionEquality().hash(_coordinates));

@override
String toString() {
  return 'EpiGeometry(type: $type, coordinates: $coordinates)';
}


}

/// @nodoc
abstract mixin class _$EpiGeometryCopyWith<$Res> implements $EpiGeometryCopyWith<$Res> {
  factory _$EpiGeometryCopyWith(_EpiGeometry value, $Res Function(_EpiGeometry) _then) = __$EpiGeometryCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'type') String? type,@JsonKey(name: 'coordinates') List<double>? coordinates
});




}
/// @nodoc
class __$EpiGeometryCopyWithImpl<$Res>
    implements _$EpiGeometryCopyWith<$Res> {
  __$EpiGeometryCopyWithImpl(this._self, this._then);

  final _EpiGeometry _self;
  final $Res Function(_EpiGeometry) _then;

/// Create a copy of EpiGeometry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = freezed,Object? coordinates = freezed,}) {
  return _then(_EpiGeometry(
type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,coordinates: freezed == coordinates ? _self._coordinates : coordinates // ignore: cast_nullable_to_non_nullable
as List<double>?,
  ));
}


}

// dart format on
