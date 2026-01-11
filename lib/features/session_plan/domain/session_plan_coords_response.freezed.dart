// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'session_plan_coords_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SessionPlanCoordsResponse {

 String? get type; List<Feature>? get features;@JsonKey(name: 'session_count') int? get sessionCount; Metadata? get metadata;
/// Create a copy of SessionPlanCoordsResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SessionPlanCoordsResponseCopyWith<SessionPlanCoordsResponse> get copyWith => _$SessionPlanCoordsResponseCopyWithImpl<SessionPlanCoordsResponse>(this as SessionPlanCoordsResponse, _$identity);

  /// Serializes this SessionPlanCoordsResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SessionPlanCoordsResponse&&(identical(other.type, type) || other.type == type)&&const DeepCollectionEquality().equals(other.features, features)&&(identical(other.sessionCount, sessionCount) || other.sessionCount == sessionCount)&&(identical(other.metadata, metadata) || other.metadata == metadata));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,const DeepCollectionEquality().hash(features),sessionCount,metadata);

@override
String toString() {
  return 'SessionPlanCoordsResponse(type: $type, features: $features, sessionCount: $sessionCount, metadata: $metadata)';
}


}

/// @nodoc
abstract mixin class $SessionPlanCoordsResponseCopyWith<$Res>  {
  factory $SessionPlanCoordsResponseCopyWith(SessionPlanCoordsResponse value, $Res Function(SessionPlanCoordsResponse) _then) = _$SessionPlanCoordsResponseCopyWithImpl;
@useResult
$Res call({
 String? type, List<Feature>? features,@JsonKey(name: 'session_count') int? sessionCount, Metadata? metadata
});


$MetadataCopyWith<$Res>? get metadata;

}
/// @nodoc
class _$SessionPlanCoordsResponseCopyWithImpl<$Res>
    implements $SessionPlanCoordsResponseCopyWith<$Res> {
  _$SessionPlanCoordsResponseCopyWithImpl(this._self, this._then);

  final SessionPlanCoordsResponse _self;
  final $Res Function(SessionPlanCoordsResponse) _then;

/// Create a copy of SessionPlanCoordsResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = freezed,Object? features = freezed,Object? sessionCount = freezed,Object? metadata = freezed,}) {
  return _then(_self.copyWith(
type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,features: freezed == features ? _self.features : features // ignore: cast_nullable_to_non_nullable
as List<Feature>?,sessionCount: freezed == sessionCount ? _self.sessionCount : sessionCount // ignore: cast_nullable_to_non_nullable
as int?,metadata: freezed == metadata ? _self.metadata : metadata // ignore: cast_nullable_to_non_nullable
as Metadata?,
  ));
}
/// Create a copy of SessionPlanCoordsResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MetadataCopyWith<$Res>? get metadata {
    if (_self.metadata == null) {
    return null;
  }

  return $MetadataCopyWith<$Res>(_self.metadata!, (value) {
    return _then(_self.copyWith(metadata: value));
  });
}
}


/// Adds pattern-matching-related methods to [SessionPlanCoordsResponse].
extension SessionPlanCoordsResponsePatterns on SessionPlanCoordsResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SessionPlanCoordsResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SessionPlanCoordsResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SessionPlanCoordsResponse value)  $default,){
final _that = this;
switch (_that) {
case _SessionPlanCoordsResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SessionPlanCoordsResponse value)?  $default,){
final _that = this;
switch (_that) {
case _SessionPlanCoordsResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? type,  List<Feature>? features, @JsonKey(name: 'session_count')  int? sessionCount,  Metadata? metadata)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SessionPlanCoordsResponse() when $default != null:
return $default(_that.type,_that.features,_that.sessionCount,_that.metadata);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? type,  List<Feature>? features, @JsonKey(name: 'session_count')  int? sessionCount,  Metadata? metadata)  $default,) {final _that = this;
switch (_that) {
case _SessionPlanCoordsResponse():
return $default(_that.type,_that.features,_that.sessionCount,_that.metadata);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? type,  List<Feature>? features, @JsonKey(name: 'session_count')  int? sessionCount,  Metadata? metadata)?  $default,) {final _that = this;
switch (_that) {
case _SessionPlanCoordsResponse() when $default != null:
return $default(_that.type,_that.features,_that.sessionCount,_that.metadata);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SessionPlanCoordsResponse implements SessionPlanCoordsResponse {
   _SessionPlanCoordsResponse({this.type, final  List<Feature>? features, @JsonKey(name: 'session_count') this.sessionCount, this.metadata}): _features = features;
  factory _SessionPlanCoordsResponse.fromJson(Map<String, dynamic> json) => _$SessionPlanCoordsResponseFromJson(json);

@override final  String? type;
 final  List<Feature>? _features;
@override List<Feature>? get features {
  final value = _features;
  if (value == null) return null;
  if (_features is EqualUnmodifiableListView) return _features;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override@JsonKey(name: 'session_count') final  int? sessionCount;
@override final  Metadata? metadata;

/// Create a copy of SessionPlanCoordsResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SessionPlanCoordsResponseCopyWith<_SessionPlanCoordsResponse> get copyWith => __$SessionPlanCoordsResponseCopyWithImpl<_SessionPlanCoordsResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SessionPlanCoordsResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SessionPlanCoordsResponse&&(identical(other.type, type) || other.type == type)&&const DeepCollectionEquality().equals(other._features, _features)&&(identical(other.sessionCount, sessionCount) || other.sessionCount == sessionCount)&&(identical(other.metadata, metadata) || other.metadata == metadata));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,const DeepCollectionEquality().hash(_features),sessionCount,metadata);

@override
String toString() {
  return 'SessionPlanCoordsResponse(type: $type, features: $features, sessionCount: $sessionCount, metadata: $metadata)';
}


}

/// @nodoc
abstract mixin class _$SessionPlanCoordsResponseCopyWith<$Res> implements $SessionPlanCoordsResponseCopyWith<$Res> {
  factory _$SessionPlanCoordsResponseCopyWith(_SessionPlanCoordsResponse value, $Res Function(_SessionPlanCoordsResponse) _then) = __$SessionPlanCoordsResponseCopyWithImpl;
@override @useResult
$Res call({
 String? type, List<Feature>? features,@JsonKey(name: 'session_count') int? sessionCount, Metadata? metadata
});


@override $MetadataCopyWith<$Res>? get metadata;

}
/// @nodoc
class __$SessionPlanCoordsResponseCopyWithImpl<$Res>
    implements _$SessionPlanCoordsResponseCopyWith<$Res> {
  __$SessionPlanCoordsResponseCopyWithImpl(this._self, this._then);

  final _SessionPlanCoordsResponse _self;
  final $Res Function(_SessionPlanCoordsResponse) _then;

/// Create a copy of SessionPlanCoordsResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = freezed,Object? features = freezed,Object? sessionCount = freezed,Object? metadata = freezed,}) {
  return _then(_SessionPlanCoordsResponse(
type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,features: freezed == features ? _self._features : features // ignore: cast_nullable_to_non_nullable
as List<Feature>?,sessionCount: freezed == sessionCount ? _self.sessionCount : sessionCount // ignore: cast_nullable_to_non_nullable
as int?,metadata: freezed == metadata ? _self.metadata : metadata // ignore: cast_nullable_to_non_nullable
as Metadata?,
  ));
}

/// Create a copy of SessionPlanCoordsResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MetadataCopyWith<$Res>? get metadata {
    if (_self.metadata == null) {
    return null;
  }

  return $MetadataCopyWith<$Res>(_self.metadata!, (value) {
    return _then(_self.copyWith(metadata: value));
  });
}
}


/// @nodoc
mixin _$Feature {

 Info? get info; String? get type; Geometry? get geometry;@JsonKey(name: 'session_dates') String? get sessionDates;
/// Create a copy of Feature
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FeatureCopyWith<Feature> get copyWith => _$FeatureCopyWithImpl<Feature>(this as Feature, _$identity);

  /// Serializes this Feature to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Feature&&(identical(other.info, info) || other.info == info)&&(identical(other.type, type) || other.type == type)&&(identical(other.geometry, geometry) || other.geometry == geometry)&&(identical(other.sessionDates, sessionDates) || other.sessionDates == sessionDates));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,info,type,geometry,sessionDates);

@override
String toString() {
  return 'Feature(info: $info, type: $type, geometry: $geometry, sessionDates: $sessionDates)';
}


}

/// @nodoc
abstract mixin class $FeatureCopyWith<$Res>  {
  factory $FeatureCopyWith(Feature value, $Res Function(Feature) _then) = _$FeatureCopyWithImpl;
@useResult
$Res call({
 Info? info, String? type, Geometry? geometry,@JsonKey(name: 'session_dates') String? sessionDates
});


$InfoCopyWith<$Res>? get info;$GeometryCopyWith<$Res>? get geometry;

}
/// @nodoc
class _$FeatureCopyWithImpl<$Res>
    implements $FeatureCopyWith<$Res> {
  _$FeatureCopyWithImpl(this._self, this._then);

  final Feature _self;
  final $Res Function(Feature) _then;

/// Create a copy of Feature
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? info = freezed,Object? type = freezed,Object? geometry = freezed,Object? sessionDates = freezed,}) {
  return _then(_self.copyWith(
info: freezed == info ? _self.info : info // ignore: cast_nullable_to_non_nullable
as Info?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,geometry: freezed == geometry ? _self.geometry : geometry // ignore: cast_nullable_to_non_nullable
as Geometry?,sessionDates: freezed == sessionDates ? _self.sessionDates : sessionDates // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of Feature
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$InfoCopyWith<$Res>? get info {
    if (_self.info == null) {
    return null;
  }

  return $InfoCopyWith<$Res>(_self.info!, (value) {
    return _then(_self.copyWith(info: value));
  });
}/// Create a copy of Feature
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GeometryCopyWith<$Res>? get geometry {
    if (_self.geometry == null) {
    return null;
  }

  return $GeometryCopyWith<$Res>(_self.geometry!, (value) {
    return _then(_self.copyWith(geometry: value));
  });
}
}


/// Adds pattern-matching-related methods to [Feature].
extension FeaturePatterns on Feature {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Feature value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Feature() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Feature value)  $default,){
final _that = this;
switch (_that) {
case _Feature():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Feature value)?  $default,){
final _that = this;
switch (_that) {
case _Feature() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Info? info,  String? type,  Geometry? geometry, @JsonKey(name: 'session_dates')  String? sessionDates)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Feature() when $default != null:
return $default(_that.info,_that.type,_that.geometry,_that.sessionDates);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Info? info,  String? type,  Geometry? geometry, @JsonKey(name: 'session_dates')  String? sessionDates)  $default,) {final _that = this;
switch (_that) {
case _Feature():
return $default(_that.info,_that.type,_that.geometry,_that.sessionDates);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Info? info,  String? type,  Geometry? geometry, @JsonKey(name: 'session_dates')  String? sessionDates)?  $default,) {final _that = this;
switch (_that) {
case _Feature() when $default != null:
return $default(_that.info,_that.type,_that.geometry,_that.sessionDates);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Feature implements Feature {
   _Feature({this.info, this.type, this.geometry, @JsonKey(name: 'session_dates') this.sessionDates});
  factory _Feature.fromJson(Map<String, dynamic> json) => _$FeatureFromJson(json);

@override final  Info? info;
@override final  String? type;
@override final  Geometry? geometry;
@override@JsonKey(name: 'session_dates') final  String? sessionDates;

/// Create a copy of Feature
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FeatureCopyWith<_Feature> get copyWith => __$FeatureCopyWithImpl<_Feature>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FeatureToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Feature&&(identical(other.info, info) || other.info == info)&&(identical(other.type, type) || other.type == type)&&(identical(other.geometry, geometry) || other.geometry == geometry)&&(identical(other.sessionDates, sessionDates) || other.sessionDates == sessionDates));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,info,type,geometry,sessionDates);

@override
String toString() {
  return 'Feature(info: $info, type: $type, geometry: $geometry, sessionDates: $sessionDates)';
}


}

/// @nodoc
abstract mixin class _$FeatureCopyWith<$Res> implements $FeatureCopyWith<$Res> {
  factory _$FeatureCopyWith(_Feature value, $Res Function(_Feature) _then) = __$FeatureCopyWithImpl;
@override @useResult
$Res call({
 Info? info, String? type, Geometry? geometry,@JsonKey(name: 'session_dates') String? sessionDates
});


@override $InfoCopyWith<$Res>? get info;@override $GeometryCopyWith<$Res>? get geometry;

}
/// @nodoc
class __$FeatureCopyWithImpl<$Res>
    implements _$FeatureCopyWith<$Res> {
  __$FeatureCopyWithImpl(this._self, this._then);

  final _Feature _self;
  final $Res Function(_Feature) _then;

/// Create a copy of Feature
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? info = freezed,Object? type = freezed,Object? geometry = freezed,Object? sessionDates = freezed,}) {
  return _then(_Feature(
info: freezed == info ? _self.info : info // ignore: cast_nullable_to_non_nullable
as Info?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,geometry: freezed == geometry ? _self.geometry : geometry // ignore: cast_nullable_to_non_nullable
as Geometry?,sessionDates: freezed == sessionDates ? _self.sessionDates : sessionDates // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of Feature
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$InfoCopyWith<$Res>? get info {
    if (_self.info == null) {
    return null;
  }

  return $InfoCopyWith<$Res>(_self.info!, (value) {
    return _then(_self.copyWith(info: value));
  });
}/// Create a copy of Feature
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GeometryCopyWith<$Res>? get geometry {
    if (_self.geometry == null) {
    return null;
  }

  return $GeometryCopyWith<$Res>(_self.geometry!, (value) {
    return _then(_self.copyWith(geometry: value));
  });
}
}


/// @nodoc
mixin _$Info {

 String? get name; String? get type;@JsonKey(name: 'org_uid') String? get orgUid;@JsonKey(name: 'type_name') String? get typeName;@JsonKey(name: 'is_fixed_center') bool? get isFixedCenter;
/// Create a copy of Info
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InfoCopyWith<Info> get copyWith => _$InfoCopyWithImpl<Info>(this as Info, _$identity);

  /// Serializes this Info to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Info&&(identical(other.name, name) || other.name == name)&&(identical(other.type, type) || other.type == type)&&(identical(other.orgUid, orgUid) || other.orgUid == orgUid)&&(identical(other.typeName, typeName) || other.typeName == typeName)&&(identical(other.isFixedCenter, isFixedCenter) || other.isFixedCenter == isFixedCenter));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,type,orgUid,typeName,isFixedCenter);

@override
String toString() {
  return 'Info(name: $name, type: $type, orgUid: $orgUid, typeName: $typeName, isFixedCenter: $isFixedCenter)';
}


}

/// @nodoc
abstract mixin class $InfoCopyWith<$Res>  {
  factory $InfoCopyWith(Info value, $Res Function(Info) _then) = _$InfoCopyWithImpl;
@useResult
$Res call({
 String? name, String? type,@JsonKey(name: 'org_uid') String? orgUid,@JsonKey(name: 'type_name') String? typeName,@JsonKey(name: 'is_fixed_center') bool? isFixedCenter
});




}
/// @nodoc
class _$InfoCopyWithImpl<$Res>
    implements $InfoCopyWith<$Res> {
  _$InfoCopyWithImpl(this._self, this._then);

  final Info _self;
  final $Res Function(Info) _then;

/// Create a copy of Info
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = freezed,Object? type = freezed,Object? orgUid = freezed,Object? typeName = freezed,Object? isFixedCenter = freezed,}) {
  return _then(_self.copyWith(
name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,orgUid: freezed == orgUid ? _self.orgUid : orgUid // ignore: cast_nullable_to_non_nullable
as String?,typeName: freezed == typeName ? _self.typeName : typeName // ignore: cast_nullable_to_non_nullable
as String?,isFixedCenter: freezed == isFixedCenter ? _self.isFixedCenter : isFixedCenter // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [Info].
extension InfoPatterns on Info {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Info value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Info() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Info value)  $default,){
final _that = this;
switch (_that) {
case _Info():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Info value)?  $default,){
final _that = this;
switch (_that) {
case _Info() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? name,  String? type, @JsonKey(name: 'org_uid')  String? orgUid, @JsonKey(name: 'type_name')  String? typeName, @JsonKey(name: 'is_fixed_center')  bool? isFixedCenter)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Info() when $default != null:
return $default(_that.name,_that.type,_that.orgUid,_that.typeName,_that.isFixedCenter);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? name,  String? type, @JsonKey(name: 'org_uid')  String? orgUid, @JsonKey(name: 'type_name')  String? typeName, @JsonKey(name: 'is_fixed_center')  bool? isFixedCenter)  $default,) {final _that = this;
switch (_that) {
case _Info():
return $default(_that.name,_that.type,_that.orgUid,_that.typeName,_that.isFixedCenter);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? name,  String? type, @JsonKey(name: 'org_uid')  String? orgUid, @JsonKey(name: 'type_name')  String? typeName, @JsonKey(name: 'is_fixed_center')  bool? isFixedCenter)?  $default,) {final _that = this;
switch (_that) {
case _Info() when $default != null:
return $default(_that.name,_that.type,_that.orgUid,_that.typeName,_that.isFixedCenter);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Info implements Info {
   _Info({this.name, this.type, @JsonKey(name: 'org_uid') this.orgUid, @JsonKey(name: 'type_name') this.typeName, @JsonKey(name: 'is_fixed_center') this.isFixedCenter});
  factory _Info.fromJson(Map<String, dynamic> json) => _$InfoFromJson(json);

@override final  String? name;
@override final  String? type;
@override@JsonKey(name: 'org_uid') final  String? orgUid;
@override@JsonKey(name: 'type_name') final  String? typeName;
@override@JsonKey(name: 'is_fixed_center') final  bool? isFixedCenter;

/// Create a copy of Info
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InfoCopyWith<_Info> get copyWith => __$InfoCopyWithImpl<_Info>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InfoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Info&&(identical(other.name, name) || other.name == name)&&(identical(other.type, type) || other.type == type)&&(identical(other.orgUid, orgUid) || other.orgUid == orgUid)&&(identical(other.typeName, typeName) || other.typeName == typeName)&&(identical(other.isFixedCenter, isFixedCenter) || other.isFixedCenter == isFixedCenter));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,type,orgUid,typeName,isFixedCenter);

@override
String toString() {
  return 'Info(name: $name, type: $type, orgUid: $orgUid, typeName: $typeName, isFixedCenter: $isFixedCenter)';
}


}

/// @nodoc
abstract mixin class _$InfoCopyWith<$Res> implements $InfoCopyWith<$Res> {
  factory _$InfoCopyWith(_Info value, $Res Function(_Info) _then) = __$InfoCopyWithImpl;
@override @useResult
$Res call({
 String? name, String? type,@JsonKey(name: 'org_uid') String? orgUid,@JsonKey(name: 'type_name') String? typeName,@JsonKey(name: 'is_fixed_center') bool? isFixedCenter
});




}
/// @nodoc
class __$InfoCopyWithImpl<$Res>
    implements _$InfoCopyWith<$Res> {
  __$InfoCopyWithImpl(this._self, this._then);

  final _Info _self;
  final $Res Function(_Info) _then;

/// Create a copy of Info
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = freezed,Object? type = freezed,Object? orgUid = freezed,Object? typeName = freezed,Object? isFixedCenter = freezed,}) {
  return _then(_Info(
name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,orgUid: freezed == orgUid ? _self.orgUid : orgUid // ignore: cast_nullable_to_non_nullable
as String?,typeName: freezed == typeName ? _self.typeName : typeName // ignore: cast_nullable_to_non_nullable
as String?,isFixedCenter: freezed == isFixedCenter ? _self.isFixedCenter : isFixedCenter // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}


/// @nodoc
mixin _$Geometry {

 String? get type; List<double>? get coordinates;
/// Create a copy of Geometry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GeometryCopyWith<Geometry> get copyWith => _$GeometryCopyWithImpl<Geometry>(this as Geometry, _$identity);

  /// Serializes this Geometry to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Geometry&&(identical(other.type, type) || other.type == type)&&const DeepCollectionEquality().equals(other.coordinates, coordinates));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,const DeepCollectionEquality().hash(coordinates));

@override
String toString() {
  return 'Geometry(type: $type, coordinates: $coordinates)';
}


}

/// @nodoc
abstract mixin class $GeometryCopyWith<$Res>  {
  factory $GeometryCopyWith(Geometry value, $Res Function(Geometry) _then) = _$GeometryCopyWithImpl;
@useResult
$Res call({
 String? type, List<double>? coordinates
});




}
/// @nodoc
class _$GeometryCopyWithImpl<$Res>
    implements $GeometryCopyWith<$Res> {
  _$GeometryCopyWithImpl(this._self, this._then);

  final Geometry _self;
  final $Res Function(Geometry) _then;

/// Create a copy of Geometry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = freezed,Object? coordinates = freezed,}) {
  return _then(_self.copyWith(
type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,coordinates: freezed == coordinates ? _self.coordinates : coordinates // ignore: cast_nullable_to_non_nullable
as List<double>?,
  ));
}

}


/// Adds pattern-matching-related methods to [Geometry].
extension GeometryPatterns on Geometry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Geometry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Geometry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Geometry value)  $default,){
final _that = this;
switch (_that) {
case _Geometry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Geometry value)?  $default,){
final _that = this;
switch (_that) {
case _Geometry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? type,  List<double>? coordinates)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Geometry() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? type,  List<double>? coordinates)  $default,) {final _that = this;
switch (_that) {
case _Geometry():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? type,  List<double>? coordinates)?  $default,) {final _that = this;
switch (_that) {
case _Geometry() when $default != null:
return $default(_that.type,_that.coordinates);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Geometry implements Geometry {
   _Geometry({this.type, final  List<double>? coordinates}): _coordinates = coordinates;
  factory _Geometry.fromJson(Map<String, dynamic> json) => _$GeometryFromJson(json);

@override final  String? type;
 final  List<double>? _coordinates;
@override List<double>? get coordinates {
  final value = _coordinates;
  if (value == null) return null;
  if (_coordinates is EqualUnmodifiableListView) return _coordinates;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of Geometry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GeometryCopyWith<_Geometry> get copyWith => __$GeometryCopyWithImpl<_Geometry>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GeometryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Geometry&&(identical(other.type, type) || other.type == type)&&const DeepCollectionEquality().equals(other._coordinates, _coordinates));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,const DeepCollectionEquality().hash(_coordinates));

@override
String toString() {
  return 'Geometry(type: $type, coordinates: $coordinates)';
}


}

/// @nodoc
abstract mixin class _$GeometryCopyWith<$Res> implements $GeometryCopyWith<$Res> {
  factory _$GeometryCopyWith(_Geometry value, $Res Function(_Geometry) _then) = __$GeometryCopyWithImpl;
@override @useResult
$Res call({
 String? type, List<double>? coordinates
});




}
/// @nodoc
class __$GeometryCopyWithImpl<$Res>
    implements _$GeometryCopyWith<$Res> {
  __$GeometryCopyWithImpl(this._self, this._then);

  final _Geometry _self;
  final $Res Function(_Geometry) _then;

/// Create a copy of Geometry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = freezed,Object? coordinates = freezed,}) {
  return _then(_Geometry(
type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,coordinates: freezed == coordinates ? _self._coordinates : coordinates // ignore: cast_nullable_to_non_nullable
as List<double>?,
  ));
}


}


/// @nodoc
mixin _$Metadata {

@JsonKey(name: 'generated_at') String? get generatedAt;@JsonKey(name: 'data_structure') String? get dataStructure;
/// Create a copy of Metadata
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MetadataCopyWith<Metadata> get copyWith => _$MetadataCopyWithImpl<Metadata>(this as Metadata, _$identity);

  /// Serializes this Metadata to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Metadata&&(identical(other.generatedAt, generatedAt) || other.generatedAt == generatedAt)&&(identical(other.dataStructure, dataStructure) || other.dataStructure == dataStructure));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,generatedAt,dataStructure);

@override
String toString() {
  return 'Metadata(generatedAt: $generatedAt, dataStructure: $dataStructure)';
}


}

/// @nodoc
abstract mixin class $MetadataCopyWith<$Res>  {
  factory $MetadataCopyWith(Metadata value, $Res Function(Metadata) _then) = _$MetadataCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'generated_at') String? generatedAt,@JsonKey(name: 'data_structure') String? dataStructure
});




}
/// @nodoc
class _$MetadataCopyWithImpl<$Res>
    implements $MetadataCopyWith<$Res> {
  _$MetadataCopyWithImpl(this._self, this._then);

  final Metadata _self;
  final $Res Function(Metadata) _then;

/// Create a copy of Metadata
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? generatedAt = freezed,Object? dataStructure = freezed,}) {
  return _then(_self.copyWith(
generatedAt: freezed == generatedAt ? _self.generatedAt : generatedAt // ignore: cast_nullable_to_non_nullable
as String?,dataStructure: freezed == dataStructure ? _self.dataStructure : dataStructure // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Metadata].
extension MetadataPatterns on Metadata {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Metadata value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Metadata() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Metadata value)  $default,){
final _that = this;
switch (_that) {
case _Metadata():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Metadata value)?  $default,){
final _that = this;
switch (_that) {
case _Metadata() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'generated_at')  String? generatedAt, @JsonKey(name: 'data_structure')  String? dataStructure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Metadata() when $default != null:
return $default(_that.generatedAt,_that.dataStructure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'generated_at')  String? generatedAt, @JsonKey(name: 'data_structure')  String? dataStructure)  $default,) {final _that = this;
switch (_that) {
case _Metadata():
return $default(_that.generatedAt,_that.dataStructure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'generated_at')  String? generatedAt, @JsonKey(name: 'data_structure')  String? dataStructure)?  $default,) {final _that = this;
switch (_that) {
case _Metadata() when $default != null:
return $default(_that.generatedAt,_that.dataStructure);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Metadata implements Metadata {
   _Metadata({@JsonKey(name: 'generated_at') this.generatedAt, @JsonKey(name: 'data_structure') this.dataStructure});
  factory _Metadata.fromJson(Map<String, dynamic> json) => _$MetadataFromJson(json);

@override@JsonKey(name: 'generated_at') final  String? generatedAt;
@override@JsonKey(name: 'data_structure') final  String? dataStructure;

/// Create a copy of Metadata
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MetadataCopyWith<_Metadata> get copyWith => __$MetadataCopyWithImpl<_Metadata>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MetadataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Metadata&&(identical(other.generatedAt, generatedAt) || other.generatedAt == generatedAt)&&(identical(other.dataStructure, dataStructure) || other.dataStructure == dataStructure));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,generatedAt,dataStructure);

@override
String toString() {
  return 'Metadata(generatedAt: $generatedAt, dataStructure: $dataStructure)';
}


}

/// @nodoc
abstract mixin class _$MetadataCopyWith<$Res> implements $MetadataCopyWith<$Res> {
  factory _$MetadataCopyWith(_Metadata value, $Res Function(_Metadata) _then) = __$MetadataCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'generated_at') String? generatedAt,@JsonKey(name: 'data_structure') String? dataStructure
});




}
/// @nodoc
class __$MetadataCopyWithImpl<$Res>
    implements _$MetadataCopyWith<$Res> {
  __$MetadataCopyWithImpl(this._self, this._then);

  final _Metadata _self;
  final $Res Function(_Metadata) _then;

/// Create a copy of Metadata
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? generatedAt = freezed,Object? dataStructure = freezed,}) {
  return _then(_Metadata(
generatedAt: freezed == generatedAt ? _self.generatedAt : generatedAt // ignore: cast_nullable_to_non_nullable
as String?,dataStructure: freezed == dataStructure ? _self.dataStructure : dataStructure // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
