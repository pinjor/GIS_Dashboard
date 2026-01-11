// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'area_coords_geo_json_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AreaCoordsGeoJsonResponse {

@JsonKey(name: 'type') String? get type;@JsonKey(name: 'info') GeoJsonInfo? get info;@JsonKey(name: 'features') List<GeoJsonFeature>? get features;
/// Create a copy of AreaCoordsGeoJsonResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AreaCoordsGeoJsonResponseCopyWith<AreaCoordsGeoJsonResponse> get copyWith => _$AreaCoordsGeoJsonResponseCopyWithImpl<AreaCoordsGeoJsonResponse>(this as AreaCoordsGeoJsonResponse, _$identity);

  /// Serializes this AreaCoordsGeoJsonResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AreaCoordsGeoJsonResponse&&(identical(other.type, type) || other.type == type)&&(identical(other.info, info) || other.info == info)&&const DeepCollectionEquality().equals(other.features, features));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,info,const DeepCollectionEquality().hash(features));

@override
String toString() {
  return 'AreaCoordsGeoJsonResponse(type: $type, info: $info, features: $features)';
}


}

/// @nodoc
abstract mixin class $AreaCoordsGeoJsonResponseCopyWith<$Res>  {
  factory $AreaCoordsGeoJsonResponseCopyWith(AreaCoordsGeoJsonResponse value, $Res Function(AreaCoordsGeoJsonResponse) _then) = _$AreaCoordsGeoJsonResponseCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'type') String? type,@JsonKey(name: 'info') GeoJsonInfo? info,@JsonKey(name: 'features') List<GeoJsonFeature>? features
});


$GeoJsonInfoCopyWith<$Res>? get info;

}
/// @nodoc
class _$AreaCoordsGeoJsonResponseCopyWithImpl<$Res>
    implements $AreaCoordsGeoJsonResponseCopyWith<$Res> {
  _$AreaCoordsGeoJsonResponseCopyWithImpl(this._self, this._then);

  final AreaCoordsGeoJsonResponse _self;
  final $Res Function(AreaCoordsGeoJsonResponse) _then;

/// Create a copy of AreaCoordsGeoJsonResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = freezed,Object? info = freezed,Object? features = freezed,}) {
  return _then(_self.copyWith(
type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,info: freezed == info ? _self.info : info // ignore: cast_nullable_to_non_nullable
as GeoJsonInfo?,features: freezed == features ? _self.features : features // ignore: cast_nullable_to_non_nullable
as List<GeoJsonFeature>?,
  ));
}
/// Create a copy of AreaCoordsGeoJsonResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GeoJsonInfoCopyWith<$Res>? get info {
    if (_self.info == null) {
    return null;
  }

  return $GeoJsonInfoCopyWith<$Res>(_self.info!, (value) {
    return _then(_self.copyWith(info: value));
  });
}
}


/// Adds pattern-matching-related methods to [AreaCoordsGeoJsonResponse].
extension AreaCoordsGeoJsonResponsePatterns on AreaCoordsGeoJsonResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AreaCoordsGeoJsonResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AreaCoordsGeoJsonResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AreaCoordsGeoJsonResponse value)  $default,){
final _that = this;
switch (_that) {
case _AreaCoordsGeoJsonResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AreaCoordsGeoJsonResponse value)?  $default,){
final _that = this;
switch (_that) {
case _AreaCoordsGeoJsonResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'type')  String? type, @JsonKey(name: 'info')  GeoJsonInfo? info, @JsonKey(name: 'features')  List<GeoJsonFeature>? features)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AreaCoordsGeoJsonResponse() when $default != null:
return $default(_that.type,_that.info,_that.features);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'type')  String? type, @JsonKey(name: 'info')  GeoJsonInfo? info, @JsonKey(name: 'features')  List<GeoJsonFeature>? features)  $default,) {final _that = this;
switch (_that) {
case _AreaCoordsGeoJsonResponse():
return $default(_that.type,_that.info,_that.features);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'type')  String? type, @JsonKey(name: 'info')  GeoJsonInfo? info, @JsonKey(name: 'features')  List<GeoJsonFeature>? features)?  $default,) {final _that = this;
switch (_that) {
case _AreaCoordsGeoJsonResponse() when $default != null:
return $default(_that.type,_that.info,_that.features);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AreaCoordsGeoJsonResponse implements AreaCoordsGeoJsonResponse {
  const _AreaCoordsGeoJsonResponse({@JsonKey(name: 'type') this.type, @JsonKey(name: 'info') this.info, @JsonKey(name: 'features') final  List<GeoJsonFeature>? features}): _features = features;
  factory _AreaCoordsGeoJsonResponse.fromJson(Map<String, dynamic> json) => _$AreaCoordsGeoJsonResponseFromJson(json);

@override@JsonKey(name: 'type') final  String? type;
@override@JsonKey(name: 'info') final  GeoJsonInfo? info;
 final  List<GeoJsonFeature>? _features;
@override@JsonKey(name: 'features') List<GeoJsonFeature>? get features {
  final value = _features;
  if (value == null) return null;
  if (_features is EqualUnmodifiableListView) return _features;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of AreaCoordsGeoJsonResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AreaCoordsGeoJsonResponseCopyWith<_AreaCoordsGeoJsonResponse> get copyWith => __$AreaCoordsGeoJsonResponseCopyWithImpl<_AreaCoordsGeoJsonResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AreaCoordsGeoJsonResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AreaCoordsGeoJsonResponse&&(identical(other.type, type) || other.type == type)&&(identical(other.info, info) || other.info == info)&&const DeepCollectionEquality().equals(other._features, _features));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,info,const DeepCollectionEquality().hash(_features));

@override
String toString() {
  return 'AreaCoordsGeoJsonResponse(type: $type, info: $info, features: $features)';
}


}

/// @nodoc
abstract mixin class _$AreaCoordsGeoJsonResponseCopyWith<$Res> implements $AreaCoordsGeoJsonResponseCopyWith<$Res> {
  factory _$AreaCoordsGeoJsonResponseCopyWith(_AreaCoordsGeoJsonResponse value, $Res Function(_AreaCoordsGeoJsonResponse) _then) = __$AreaCoordsGeoJsonResponseCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'type') String? type,@JsonKey(name: 'info') GeoJsonInfo? info,@JsonKey(name: 'features') List<GeoJsonFeature>? features
});


@override $GeoJsonInfoCopyWith<$Res>? get info;

}
/// @nodoc
class __$AreaCoordsGeoJsonResponseCopyWithImpl<$Res>
    implements _$AreaCoordsGeoJsonResponseCopyWith<$Res> {
  __$AreaCoordsGeoJsonResponseCopyWithImpl(this._self, this._then);

  final _AreaCoordsGeoJsonResponse _self;
  final $Res Function(_AreaCoordsGeoJsonResponse) _then;

/// Create a copy of AreaCoordsGeoJsonResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = freezed,Object? info = freezed,Object? features = freezed,}) {
  return _then(_AreaCoordsGeoJsonResponse(
type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,info: freezed == info ? _self.info : info // ignore: cast_nullable_to_non_nullable
as GeoJsonInfo?,features: freezed == features ? _self._features : features // ignore: cast_nullable_to_non_nullable
as List<GeoJsonFeature>?,
  ));
}

/// Create a copy of AreaCoordsGeoJsonResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GeoJsonInfoCopyWith<$Res>? get info {
    if (_self.info == null) {
    return null;
  }

  return $GeoJsonInfoCopyWith<$Res>(_self.info!, (value) {
    return _then(_self.copyWith(info: value));
  });
}
}


/// @nodoc
mixin _$GeoJsonInfo {

@JsonKey(name: 'type') String? get type;@JsonKey(name: 'created_at') String? get createdAt;
/// Create a copy of GeoJsonInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GeoJsonInfoCopyWith<GeoJsonInfo> get copyWith => _$GeoJsonInfoCopyWithImpl<GeoJsonInfo>(this as GeoJsonInfo, _$identity);

  /// Serializes this GeoJsonInfo to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GeoJsonInfo&&(identical(other.type, type) || other.type == type)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,createdAt);

@override
String toString() {
  return 'GeoJsonInfo(type: $type, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $GeoJsonInfoCopyWith<$Res>  {
  factory $GeoJsonInfoCopyWith(GeoJsonInfo value, $Res Function(GeoJsonInfo) _then) = _$GeoJsonInfoCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'type') String? type,@JsonKey(name: 'created_at') String? createdAt
});




}
/// @nodoc
class _$GeoJsonInfoCopyWithImpl<$Res>
    implements $GeoJsonInfoCopyWith<$Res> {
  _$GeoJsonInfoCopyWithImpl(this._self, this._then);

  final GeoJsonInfo _self;
  final $Res Function(GeoJsonInfo) _then;

/// Create a copy of GeoJsonInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = freezed,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [GeoJsonInfo].
extension GeoJsonInfoPatterns on GeoJsonInfo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GeoJsonInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GeoJsonInfo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GeoJsonInfo value)  $default,){
final _that = this;
switch (_that) {
case _GeoJsonInfo():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GeoJsonInfo value)?  $default,){
final _that = this;
switch (_that) {
case _GeoJsonInfo() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'type')  String? type, @JsonKey(name: 'created_at')  String? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GeoJsonInfo() when $default != null:
return $default(_that.type,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'type')  String? type, @JsonKey(name: 'created_at')  String? createdAt)  $default,) {final _that = this;
switch (_that) {
case _GeoJsonInfo():
return $default(_that.type,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'type')  String? type, @JsonKey(name: 'created_at')  String? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _GeoJsonInfo() when $default != null:
return $default(_that.type,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GeoJsonInfo implements GeoJsonInfo {
  const _GeoJsonInfo({@JsonKey(name: 'type') this.type, @JsonKey(name: 'created_at') this.createdAt});
  factory _GeoJsonInfo.fromJson(Map<String, dynamic> json) => _$GeoJsonInfoFromJson(json);

@override@JsonKey(name: 'type') final  String? type;
@override@JsonKey(name: 'created_at') final  String? createdAt;

/// Create a copy of GeoJsonInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GeoJsonInfoCopyWith<_GeoJsonInfo> get copyWith => __$GeoJsonInfoCopyWithImpl<_GeoJsonInfo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GeoJsonInfoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GeoJsonInfo&&(identical(other.type, type) || other.type == type)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,createdAt);

@override
String toString() {
  return 'GeoJsonInfo(type: $type, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$GeoJsonInfoCopyWith<$Res> implements $GeoJsonInfoCopyWith<$Res> {
  factory _$GeoJsonInfoCopyWith(_GeoJsonInfo value, $Res Function(_GeoJsonInfo) _then) = __$GeoJsonInfoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'type') String? type,@JsonKey(name: 'created_at') String? createdAt
});




}
/// @nodoc
class __$GeoJsonInfoCopyWithImpl<$Res>
    implements _$GeoJsonInfoCopyWith<$Res> {
  __$GeoJsonInfoCopyWithImpl(this._self, this._then);

  final _GeoJsonInfo _self;
  final $Res Function(_GeoJsonInfo) _then;

/// Create a copy of GeoJsonInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = freezed,Object? createdAt = freezed,}) {
  return _then(_GeoJsonInfo(
type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$GeoJsonFeature {

@JsonKey(name: 'type') String? get type;@JsonKey(name: 'geometry') GeoJsonGeometry? get geometry;@JsonKey(name: 'info') FeatureInfo? get info;
/// Create a copy of GeoJsonFeature
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GeoJsonFeatureCopyWith<GeoJsonFeature> get copyWith => _$GeoJsonFeatureCopyWithImpl<GeoJsonFeature>(this as GeoJsonFeature, _$identity);

  /// Serializes this GeoJsonFeature to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GeoJsonFeature&&(identical(other.type, type) || other.type == type)&&(identical(other.geometry, geometry) || other.geometry == geometry)&&(identical(other.info, info) || other.info == info));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,geometry,info);

@override
String toString() {
  return 'GeoJsonFeature(type: $type, geometry: $geometry, info: $info)';
}


}

/// @nodoc
abstract mixin class $GeoJsonFeatureCopyWith<$Res>  {
  factory $GeoJsonFeatureCopyWith(GeoJsonFeature value, $Res Function(GeoJsonFeature) _then) = _$GeoJsonFeatureCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'type') String? type,@JsonKey(name: 'geometry') GeoJsonGeometry? geometry,@JsonKey(name: 'info') FeatureInfo? info
});


$GeoJsonGeometryCopyWith<$Res>? get geometry;$FeatureInfoCopyWith<$Res>? get info;

}
/// @nodoc
class _$GeoJsonFeatureCopyWithImpl<$Res>
    implements $GeoJsonFeatureCopyWith<$Res> {
  _$GeoJsonFeatureCopyWithImpl(this._self, this._then);

  final GeoJsonFeature _self;
  final $Res Function(GeoJsonFeature) _then;

/// Create a copy of GeoJsonFeature
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = freezed,Object? geometry = freezed,Object? info = freezed,}) {
  return _then(_self.copyWith(
type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,geometry: freezed == geometry ? _self.geometry : geometry // ignore: cast_nullable_to_non_nullable
as GeoJsonGeometry?,info: freezed == info ? _self.info : info // ignore: cast_nullable_to_non_nullable
as FeatureInfo?,
  ));
}
/// Create a copy of GeoJsonFeature
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GeoJsonGeometryCopyWith<$Res>? get geometry {
    if (_self.geometry == null) {
    return null;
  }

  return $GeoJsonGeometryCopyWith<$Res>(_self.geometry!, (value) {
    return _then(_self.copyWith(geometry: value));
  });
}/// Create a copy of GeoJsonFeature
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FeatureInfoCopyWith<$Res>? get info {
    if (_self.info == null) {
    return null;
  }

  return $FeatureInfoCopyWith<$Res>(_self.info!, (value) {
    return _then(_self.copyWith(info: value));
  });
}
}


/// Adds pattern-matching-related methods to [GeoJsonFeature].
extension GeoJsonFeaturePatterns on GeoJsonFeature {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GeoJsonFeature value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GeoJsonFeature() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GeoJsonFeature value)  $default,){
final _that = this;
switch (_that) {
case _GeoJsonFeature():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GeoJsonFeature value)?  $default,){
final _that = this;
switch (_that) {
case _GeoJsonFeature() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'type')  String? type, @JsonKey(name: 'geometry')  GeoJsonGeometry? geometry, @JsonKey(name: 'info')  FeatureInfo? info)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GeoJsonFeature() when $default != null:
return $default(_that.type,_that.geometry,_that.info);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'type')  String? type, @JsonKey(name: 'geometry')  GeoJsonGeometry? geometry, @JsonKey(name: 'info')  FeatureInfo? info)  $default,) {final _that = this;
switch (_that) {
case _GeoJsonFeature():
return $default(_that.type,_that.geometry,_that.info);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'type')  String? type, @JsonKey(name: 'geometry')  GeoJsonGeometry? geometry, @JsonKey(name: 'info')  FeatureInfo? info)?  $default,) {final _that = this;
switch (_that) {
case _GeoJsonFeature() when $default != null:
return $default(_that.type,_that.geometry,_that.info);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GeoJsonFeature implements GeoJsonFeature {
  const _GeoJsonFeature({@JsonKey(name: 'type') this.type, @JsonKey(name: 'geometry') this.geometry, @JsonKey(name: 'info') this.info});
  factory _GeoJsonFeature.fromJson(Map<String, dynamic> json) => _$GeoJsonFeatureFromJson(json);

@override@JsonKey(name: 'type') final  String? type;
@override@JsonKey(name: 'geometry') final  GeoJsonGeometry? geometry;
@override@JsonKey(name: 'info') final  FeatureInfo? info;

/// Create a copy of GeoJsonFeature
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GeoJsonFeatureCopyWith<_GeoJsonFeature> get copyWith => __$GeoJsonFeatureCopyWithImpl<_GeoJsonFeature>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GeoJsonFeatureToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GeoJsonFeature&&(identical(other.type, type) || other.type == type)&&(identical(other.geometry, geometry) || other.geometry == geometry)&&(identical(other.info, info) || other.info == info));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,geometry,info);

@override
String toString() {
  return 'GeoJsonFeature(type: $type, geometry: $geometry, info: $info)';
}


}

/// @nodoc
abstract mixin class _$GeoJsonFeatureCopyWith<$Res> implements $GeoJsonFeatureCopyWith<$Res> {
  factory _$GeoJsonFeatureCopyWith(_GeoJsonFeature value, $Res Function(_GeoJsonFeature) _then) = __$GeoJsonFeatureCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'type') String? type,@JsonKey(name: 'geometry') GeoJsonGeometry? geometry,@JsonKey(name: 'info') FeatureInfo? info
});


@override $GeoJsonGeometryCopyWith<$Res>? get geometry;@override $FeatureInfoCopyWith<$Res>? get info;

}
/// @nodoc
class __$GeoJsonFeatureCopyWithImpl<$Res>
    implements _$GeoJsonFeatureCopyWith<$Res> {
  __$GeoJsonFeatureCopyWithImpl(this._self, this._then);

  final _GeoJsonFeature _self;
  final $Res Function(_GeoJsonFeature) _then;

/// Create a copy of GeoJsonFeature
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = freezed,Object? geometry = freezed,Object? info = freezed,}) {
  return _then(_GeoJsonFeature(
type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,geometry: freezed == geometry ? _self.geometry : geometry // ignore: cast_nullable_to_non_nullable
as GeoJsonGeometry?,info: freezed == info ? _self.info : info // ignore: cast_nullable_to_non_nullable
as FeatureInfo?,
  ));
}

/// Create a copy of GeoJsonFeature
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GeoJsonGeometryCopyWith<$Res>? get geometry {
    if (_self.geometry == null) {
    return null;
  }

  return $GeoJsonGeometryCopyWith<$Res>(_self.geometry!, (value) {
    return _then(_self.copyWith(geometry: value));
  });
}/// Create a copy of GeoJsonFeature
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FeatureInfoCopyWith<$Res>? get info {
    if (_self.info == null) {
    return null;
  }

  return $FeatureInfoCopyWith<$Res>(_self.info!, (value) {
    return _then(_self.copyWith(info: value));
  });
}
}


/// @nodoc
mixin _$GeoJsonGeometry {

@JsonKey(name: 'type') String? get type;@JsonKey(name: 'coordinates') List<dynamic>? get coordinates;
/// Create a copy of GeoJsonGeometry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GeoJsonGeometryCopyWith<GeoJsonGeometry> get copyWith => _$GeoJsonGeometryCopyWithImpl<GeoJsonGeometry>(this as GeoJsonGeometry, _$identity);

  /// Serializes this GeoJsonGeometry to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GeoJsonGeometry&&(identical(other.type, type) || other.type == type)&&const DeepCollectionEquality().equals(other.coordinates, coordinates));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,const DeepCollectionEquality().hash(coordinates));

@override
String toString() {
  return 'GeoJsonGeometry(type: $type, coordinates: $coordinates)';
}


}

/// @nodoc
abstract mixin class $GeoJsonGeometryCopyWith<$Res>  {
  factory $GeoJsonGeometryCopyWith(GeoJsonGeometry value, $Res Function(GeoJsonGeometry) _then) = _$GeoJsonGeometryCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'type') String? type,@JsonKey(name: 'coordinates') List<dynamic>? coordinates
});




}
/// @nodoc
class _$GeoJsonGeometryCopyWithImpl<$Res>
    implements $GeoJsonGeometryCopyWith<$Res> {
  _$GeoJsonGeometryCopyWithImpl(this._self, this._then);

  final GeoJsonGeometry _self;
  final $Res Function(GeoJsonGeometry) _then;

/// Create a copy of GeoJsonGeometry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = freezed,Object? coordinates = freezed,}) {
  return _then(_self.copyWith(
type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,coordinates: freezed == coordinates ? _self.coordinates : coordinates // ignore: cast_nullable_to_non_nullable
as List<dynamic>?,
  ));
}

}


/// Adds pattern-matching-related methods to [GeoJsonGeometry].
extension GeoJsonGeometryPatterns on GeoJsonGeometry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GeoJsonGeometry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GeoJsonGeometry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GeoJsonGeometry value)  $default,){
final _that = this;
switch (_that) {
case _GeoJsonGeometry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GeoJsonGeometry value)?  $default,){
final _that = this;
switch (_that) {
case _GeoJsonGeometry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'type')  String? type, @JsonKey(name: 'coordinates')  List<dynamic>? coordinates)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GeoJsonGeometry() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'type')  String? type, @JsonKey(name: 'coordinates')  List<dynamic>? coordinates)  $default,) {final _that = this;
switch (_that) {
case _GeoJsonGeometry():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'type')  String? type, @JsonKey(name: 'coordinates')  List<dynamic>? coordinates)?  $default,) {final _that = this;
switch (_that) {
case _GeoJsonGeometry() when $default != null:
return $default(_that.type,_that.coordinates);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GeoJsonGeometry implements GeoJsonGeometry {
  const _GeoJsonGeometry({@JsonKey(name: 'type') this.type, @JsonKey(name: 'coordinates') final  List<dynamic>? coordinates}): _coordinates = coordinates;
  factory _GeoJsonGeometry.fromJson(Map<String, dynamic> json) => _$GeoJsonGeometryFromJson(json);

@override@JsonKey(name: 'type') final  String? type;
 final  List<dynamic>? _coordinates;
@override@JsonKey(name: 'coordinates') List<dynamic>? get coordinates {
  final value = _coordinates;
  if (value == null) return null;
  if (_coordinates is EqualUnmodifiableListView) return _coordinates;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of GeoJsonGeometry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GeoJsonGeometryCopyWith<_GeoJsonGeometry> get copyWith => __$GeoJsonGeometryCopyWithImpl<_GeoJsonGeometry>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GeoJsonGeometryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GeoJsonGeometry&&(identical(other.type, type) || other.type == type)&&const DeepCollectionEquality().equals(other._coordinates, _coordinates));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,const DeepCollectionEquality().hash(_coordinates));

@override
String toString() {
  return 'GeoJsonGeometry(type: $type, coordinates: $coordinates)';
}


}

/// @nodoc
abstract mixin class _$GeoJsonGeometryCopyWith<$Res> implements $GeoJsonGeometryCopyWith<$Res> {
  factory _$GeoJsonGeometryCopyWith(_GeoJsonGeometry value, $Res Function(_GeoJsonGeometry) _then) = __$GeoJsonGeometryCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'type') String? type,@JsonKey(name: 'coordinates') List<dynamic>? coordinates
});




}
/// @nodoc
class __$GeoJsonGeometryCopyWithImpl<$Res>
    implements _$GeoJsonGeometryCopyWith<$Res> {
  __$GeoJsonGeometryCopyWithImpl(this._self, this._then);

  final _GeoJsonGeometry _self;
  final $Res Function(_GeoJsonGeometry) _then;

/// Create a copy of GeoJsonGeometry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = freezed,Object? coordinates = freezed,}) {
  return _then(_GeoJsonGeometry(
type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,coordinates: freezed == coordinates ? _self._coordinates : coordinates // ignore: cast_nullable_to_non_nullable
as List<dynamic>?,
  ));
}


}


/// @nodoc
mixin _$FeatureInfo {

@JsonKey(name: 'type') String? get type;@JsonKey(name: 'name') String? get name;@JsonKey(name: 'slug') String? get slug;@JsonKey(name: 'org_uid') String? get orgUid;@JsonKey(name: 'parent_slug') String? get parentSlug;
/// Create a copy of FeatureInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FeatureInfoCopyWith<FeatureInfo> get copyWith => _$FeatureInfoCopyWithImpl<FeatureInfo>(this as FeatureInfo, _$identity);

  /// Serializes this FeatureInfo to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FeatureInfo&&(identical(other.type, type) || other.type == type)&&(identical(other.name, name) || other.name == name)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.orgUid, orgUid) || other.orgUid == orgUid)&&(identical(other.parentSlug, parentSlug) || other.parentSlug == parentSlug));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,name,slug,orgUid,parentSlug);

@override
String toString() {
  return 'FeatureInfo(type: $type, name: $name, slug: $slug, orgUid: $orgUid, parentSlug: $parentSlug)';
}


}

/// @nodoc
abstract mixin class $FeatureInfoCopyWith<$Res>  {
  factory $FeatureInfoCopyWith(FeatureInfo value, $Res Function(FeatureInfo) _then) = _$FeatureInfoCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'type') String? type,@JsonKey(name: 'name') String? name,@JsonKey(name: 'slug') String? slug,@JsonKey(name: 'org_uid') String? orgUid,@JsonKey(name: 'parent_slug') String? parentSlug
});




}
/// @nodoc
class _$FeatureInfoCopyWithImpl<$Res>
    implements $FeatureInfoCopyWith<$Res> {
  _$FeatureInfoCopyWithImpl(this._self, this._then);

  final FeatureInfo _self;
  final $Res Function(FeatureInfo) _then;

/// Create a copy of FeatureInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = freezed,Object? name = freezed,Object? slug = freezed,Object? orgUid = freezed,Object? parentSlug = freezed,}) {
  return _then(_self.copyWith(
type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,slug: freezed == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String?,orgUid: freezed == orgUid ? _self.orgUid : orgUid // ignore: cast_nullable_to_non_nullable
as String?,parentSlug: freezed == parentSlug ? _self.parentSlug : parentSlug // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [FeatureInfo].
extension FeatureInfoPatterns on FeatureInfo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FeatureInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FeatureInfo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FeatureInfo value)  $default,){
final _that = this;
switch (_that) {
case _FeatureInfo():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FeatureInfo value)?  $default,){
final _that = this;
switch (_that) {
case _FeatureInfo() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'type')  String? type, @JsonKey(name: 'name')  String? name, @JsonKey(name: 'slug')  String? slug, @JsonKey(name: 'org_uid')  String? orgUid, @JsonKey(name: 'parent_slug')  String? parentSlug)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FeatureInfo() when $default != null:
return $default(_that.type,_that.name,_that.slug,_that.orgUid,_that.parentSlug);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'type')  String? type, @JsonKey(name: 'name')  String? name, @JsonKey(name: 'slug')  String? slug, @JsonKey(name: 'org_uid')  String? orgUid, @JsonKey(name: 'parent_slug')  String? parentSlug)  $default,) {final _that = this;
switch (_that) {
case _FeatureInfo():
return $default(_that.type,_that.name,_that.slug,_that.orgUid,_that.parentSlug);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'type')  String? type, @JsonKey(name: 'name')  String? name, @JsonKey(name: 'slug')  String? slug, @JsonKey(name: 'org_uid')  String? orgUid, @JsonKey(name: 'parent_slug')  String? parentSlug)?  $default,) {final _that = this;
switch (_that) {
case _FeatureInfo() when $default != null:
return $default(_that.type,_that.name,_that.slug,_that.orgUid,_that.parentSlug);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FeatureInfo implements FeatureInfo {
  const _FeatureInfo({@JsonKey(name: 'type') this.type, @JsonKey(name: 'name') this.name, @JsonKey(name: 'slug') this.slug, @JsonKey(name: 'org_uid') this.orgUid, @JsonKey(name: 'parent_slug') this.parentSlug});
  factory _FeatureInfo.fromJson(Map<String, dynamic> json) => _$FeatureInfoFromJson(json);

@override@JsonKey(name: 'type') final  String? type;
@override@JsonKey(name: 'name') final  String? name;
@override@JsonKey(name: 'slug') final  String? slug;
@override@JsonKey(name: 'org_uid') final  String? orgUid;
@override@JsonKey(name: 'parent_slug') final  String? parentSlug;

/// Create a copy of FeatureInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FeatureInfoCopyWith<_FeatureInfo> get copyWith => __$FeatureInfoCopyWithImpl<_FeatureInfo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FeatureInfoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FeatureInfo&&(identical(other.type, type) || other.type == type)&&(identical(other.name, name) || other.name == name)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.orgUid, orgUid) || other.orgUid == orgUid)&&(identical(other.parentSlug, parentSlug) || other.parentSlug == parentSlug));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,name,slug,orgUid,parentSlug);

@override
String toString() {
  return 'FeatureInfo(type: $type, name: $name, slug: $slug, orgUid: $orgUid, parentSlug: $parentSlug)';
}


}

/// @nodoc
abstract mixin class _$FeatureInfoCopyWith<$Res> implements $FeatureInfoCopyWith<$Res> {
  factory _$FeatureInfoCopyWith(_FeatureInfo value, $Res Function(_FeatureInfo) _then) = __$FeatureInfoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'type') String? type,@JsonKey(name: 'name') String? name,@JsonKey(name: 'slug') String? slug,@JsonKey(name: 'org_uid') String? orgUid,@JsonKey(name: 'parent_slug') String? parentSlug
});




}
/// @nodoc
class __$FeatureInfoCopyWithImpl<$Res>
    implements _$FeatureInfoCopyWith<$Res> {
  __$FeatureInfoCopyWithImpl(this._self, this._then);

  final _FeatureInfo _self;
  final $Res Function(_FeatureInfo) _then;

/// Create a copy of FeatureInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = freezed,Object? name = freezed,Object? slug = freezed,Object? orgUid = freezed,Object? parentSlug = freezed,}) {
  return _then(_FeatureInfo(
type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,slug: freezed == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String?,orgUid: freezed == orgUid ? _self.orgUid : orgUid // ignore: cast_nullable_to_non_nullable
as String?,parentSlug: freezed == parentSlug ? _self.parentSlug : parentSlug // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
