// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'vaccine_coverage_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$VaccineCoverageResponse {

@JsonKey(name: 'metadata') Metadata? get metadata;@JsonKey(name: 'vaccines') List<Vaccine>? get vaccines;
/// Create a copy of VaccineCoverageResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VaccineCoverageResponseCopyWith<VaccineCoverageResponse> get copyWith => _$VaccineCoverageResponseCopyWithImpl<VaccineCoverageResponse>(this as VaccineCoverageResponse, _$identity);

  /// Serializes this VaccineCoverageResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VaccineCoverageResponse&&(identical(other.metadata, metadata) || other.metadata == metadata)&&const DeepCollectionEquality().equals(other.vaccines, vaccines));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,metadata,const DeepCollectionEquality().hash(vaccines));

@override
String toString() {
  return 'VaccineCoverageResponse(metadata: $metadata, vaccines: $vaccines)';
}


}

/// @nodoc
abstract mixin class $VaccineCoverageResponseCopyWith<$Res>  {
  factory $VaccineCoverageResponseCopyWith(VaccineCoverageResponse value, $Res Function(VaccineCoverageResponse) _then) = _$VaccineCoverageResponseCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'metadata') Metadata? metadata,@JsonKey(name: 'vaccines') List<Vaccine>? vaccines
});


$MetadataCopyWith<$Res>? get metadata;

}
/// @nodoc
class _$VaccineCoverageResponseCopyWithImpl<$Res>
    implements $VaccineCoverageResponseCopyWith<$Res> {
  _$VaccineCoverageResponseCopyWithImpl(this._self, this._then);

  final VaccineCoverageResponse _self;
  final $Res Function(VaccineCoverageResponse) _then;

/// Create a copy of VaccineCoverageResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? metadata = freezed,Object? vaccines = freezed,}) {
  return _then(_self.copyWith(
metadata: freezed == metadata ? _self.metadata : metadata // ignore: cast_nullable_to_non_nullable
as Metadata?,vaccines: freezed == vaccines ? _self.vaccines : vaccines // ignore: cast_nullable_to_non_nullable
as List<Vaccine>?,
  ));
}
/// Create a copy of VaccineCoverageResponse
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


/// Adds pattern-matching-related methods to [VaccineCoverageResponse].
extension VaccineCoverageResponsePatterns on VaccineCoverageResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VaccineCoverageResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VaccineCoverageResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VaccineCoverageResponse value)  $default,){
final _that = this;
switch (_that) {
case _VaccineCoverageResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VaccineCoverageResponse value)?  $default,){
final _that = this;
switch (_that) {
case _VaccineCoverageResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'metadata')  Metadata? metadata, @JsonKey(name: 'vaccines')  List<Vaccine>? vaccines)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VaccineCoverageResponse() when $default != null:
return $default(_that.metadata,_that.vaccines);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'metadata')  Metadata? metadata, @JsonKey(name: 'vaccines')  List<Vaccine>? vaccines)  $default,) {final _that = this;
switch (_that) {
case _VaccineCoverageResponse():
return $default(_that.metadata,_that.vaccines);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'metadata')  Metadata? metadata, @JsonKey(name: 'vaccines')  List<Vaccine>? vaccines)?  $default,) {final _that = this;
switch (_that) {
case _VaccineCoverageResponse() when $default != null:
return $default(_that.metadata,_that.vaccines);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _VaccineCoverageResponse implements VaccineCoverageResponse {
  const _VaccineCoverageResponse({@JsonKey(name: 'metadata') this.metadata, @JsonKey(name: 'vaccines') final  List<Vaccine>? vaccines}): _vaccines = vaccines;
  factory _VaccineCoverageResponse.fromJson(Map<String, dynamic> json) => _$VaccineCoverageResponseFromJson(json);

@override@JsonKey(name: 'metadata') final  Metadata? metadata;
 final  List<Vaccine>? _vaccines;
@override@JsonKey(name: 'vaccines') List<Vaccine>? get vaccines {
  final value = _vaccines;
  if (value == null) return null;
  if (_vaccines is EqualUnmodifiableListView) return _vaccines;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of VaccineCoverageResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VaccineCoverageResponseCopyWith<_VaccineCoverageResponse> get copyWith => __$VaccineCoverageResponseCopyWithImpl<_VaccineCoverageResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VaccineCoverageResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VaccineCoverageResponse&&(identical(other.metadata, metadata) || other.metadata == metadata)&&const DeepCollectionEquality().equals(other._vaccines, _vaccines));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,metadata,const DeepCollectionEquality().hash(_vaccines));

@override
String toString() {
  return 'VaccineCoverageResponse(metadata: $metadata, vaccines: $vaccines)';
}


}

/// @nodoc
abstract mixin class _$VaccineCoverageResponseCopyWith<$Res> implements $VaccineCoverageResponseCopyWith<$Res> {
  factory _$VaccineCoverageResponseCopyWith(_VaccineCoverageResponse value, $Res Function(_VaccineCoverageResponse) _then) = __$VaccineCoverageResponseCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'metadata') Metadata? metadata,@JsonKey(name: 'vaccines') List<Vaccine>? vaccines
});


@override $MetadataCopyWith<$Res>? get metadata;

}
/// @nodoc
class __$VaccineCoverageResponseCopyWithImpl<$Res>
    implements _$VaccineCoverageResponseCopyWith<$Res> {
  __$VaccineCoverageResponseCopyWithImpl(this._self, this._then);

  final _VaccineCoverageResponse _self;
  final $Res Function(_VaccineCoverageResponse) _then;

/// Create a copy of VaccineCoverageResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? metadata = freezed,Object? vaccines = freezed,}) {
  return _then(_VaccineCoverageResponse(
metadata: freezed == metadata ? _self.metadata : metadata // ignore: cast_nullable_to_non_nullable
as Metadata?,vaccines: freezed == vaccines ? _self._vaccines : vaccines // ignore: cast_nullable_to_non_nullable
as List<Vaccine>?,
  ));
}

/// Create a copy of VaccineCoverageResponse
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
mixin _$Metadata {

@JsonKey(name: 'year') int? get year;@JsonKey(name: 'area_type') String? get areaType;@JsonKey(name: 'generated_at') String? get generatedAt;@JsonKey(name: 'data_structure') String? get dataStructure;
/// Create a copy of Metadata
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MetadataCopyWith<Metadata> get copyWith => _$MetadataCopyWithImpl<Metadata>(this as Metadata, _$identity);

  /// Serializes this Metadata to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Metadata&&(identical(other.year, year) || other.year == year)&&(identical(other.areaType, areaType) || other.areaType == areaType)&&(identical(other.generatedAt, generatedAt) || other.generatedAt == generatedAt)&&(identical(other.dataStructure, dataStructure) || other.dataStructure == dataStructure));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,year,areaType,generatedAt,dataStructure);

@override
String toString() {
  return 'Metadata(year: $year, areaType: $areaType, generatedAt: $generatedAt, dataStructure: $dataStructure)';
}


}

/// @nodoc
abstract mixin class $MetadataCopyWith<$Res>  {
  factory $MetadataCopyWith(Metadata value, $Res Function(Metadata) _then) = _$MetadataCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'year') int? year,@JsonKey(name: 'area_type') String? areaType,@JsonKey(name: 'generated_at') String? generatedAt,@JsonKey(name: 'data_structure') String? dataStructure
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
@pragma('vm:prefer-inline') @override $Res call({Object? year = freezed,Object? areaType = freezed,Object? generatedAt = freezed,Object? dataStructure = freezed,}) {
  return _then(_self.copyWith(
year: freezed == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int?,areaType: freezed == areaType ? _self.areaType : areaType // ignore: cast_nullable_to_non_nullable
as String?,generatedAt: freezed == generatedAt ? _self.generatedAt : generatedAt // ignore: cast_nullable_to_non_nullable
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'year')  int? year, @JsonKey(name: 'area_type')  String? areaType, @JsonKey(name: 'generated_at')  String? generatedAt, @JsonKey(name: 'data_structure')  String? dataStructure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Metadata() when $default != null:
return $default(_that.year,_that.areaType,_that.generatedAt,_that.dataStructure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'year')  int? year, @JsonKey(name: 'area_type')  String? areaType, @JsonKey(name: 'generated_at')  String? generatedAt, @JsonKey(name: 'data_structure')  String? dataStructure)  $default,) {final _that = this;
switch (_that) {
case _Metadata():
return $default(_that.year,_that.areaType,_that.generatedAt,_that.dataStructure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'year')  int? year, @JsonKey(name: 'area_type')  String? areaType, @JsonKey(name: 'generated_at')  String? generatedAt, @JsonKey(name: 'data_structure')  String? dataStructure)?  $default,) {final _that = this;
switch (_that) {
case _Metadata() when $default != null:
return $default(_that.year,_that.areaType,_that.generatedAt,_that.dataStructure);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Metadata implements Metadata {
  const _Metadata({@JsonKey(name: 'year') this.year, @JsonKey(name: 'area_type') this.areaType, @JsonKey(name: 'generated_at') this.generatedAt, @JsonKey(name: 'data_structure') this.dataStructure});
  factory _Metadata.fromJson(Map<String, dynamic> json) => _$MetadataFromJson(json);

@override@JsonKey(name: 'year') final  int? year;
@override@JsonKey(name: 'area_type') final  String? areaType;
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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Metadata&&(identical(other.year, year) || other.year == year)&&(identical(other.areaType, areaType) || other.areaType == areaType)&&(identical(other.generatedAt, generatedAt) || other.generatedAt == generatedAt)&&(identical(other.dataStructure, dataStructure) || other.dataStructure == dataStructure));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,year,areaType,generatedAt,dataStructure);

@override
String toString() {
  return 'Metadata(year: $year, areaType: $areaType, generatedAt: $generatedAt, dataStructure: $dataStructure)';
}


}

/// @nodoc
abstract mixin class _$MetadataCopyWith<$Res> implements $MetadataCopyWith<$Res> {
  factory _$MetadataCopyWith(_Metadata value, $Res Function(_Metadata) _then) = __$MetadataCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'year') int? year,@JsonKey(name: 'area_type') String? areaType,@JsonKey(name: 'generated_at') String? generatedAt,@JsonKey(name: 'data_structure') String? dataStructure
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
@override @pragma('vm:prefer-inline') $Res call({Object? year = freezed,Object? areaType = freezed,Object? generatedAt = freezed,Object? dataStructure = freezed,}) {
  return _then(_Metadata(
year: freezed == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int?,areaType: freezed == areaType ? _self.areaType : areaType // ignore: cast_nullable_to_non_nullable
as String?,generatedAt: freezed == generatedAt ? _self.generatedAt : generatedAt // ignore: cast_nullable_to_non_nullable
as String?,dataStructure: freezed == dataStructure ? _self.dataStructure : dataStructure // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$Vaccine {

@JsonKey(name: 'vaccine_uid') String? get vaccineUid;@JsonKey(name: 'vaccine_name') String? get vaccineName;@JsonKey(name: 'total_target') int? get totalTarget;@JsonKey(name: 'total_target_male') int? get totalTargetMale;@JsonKey(name: 'total_target_female') int? get totalTargetFemale;@JsonKey(name: 'total_coverage') int? get totalCoverage;@JsonKey(name: 'total_coverage_male') int? get totalCoverageMale;@JsonKey(name: 'total_coverage_female') int? get totalCoverageFemale;@JsonKey(name: 'total_coverage_percentage') double? get totalCoveragePercentage;@JsonKey(name: 'total_coverage_percentage_male') double? get totalCoveragePercentageMale;@JsonKey(name: 'total_coverage_percentage_female') double? get totalCoveragePercentageFemale;@JsonKey(name: 'areas') List<Area>? get areas;@JsonKey(name: 'month_wise_total_coverages') Map<String, MonthlyCoverage>? get monthWiseTotalCoverages;@JsonKey(name: 'performance') Performance? get performance;
/// Create a copy of Vaccine
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VaccineCopyWith<Vaccine> get copyWith => _$VaccineCopyWithImpl<Vaccine>(this as Vaccine, _$identity);

  /// Serializes this Vaccine to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Vaccine&&(identical(other.vaccineUid, vaccineUid) || other.vaccineUid == vaccineUid)&&(identical(other.vaccineName, vaccineName) || other.vaccineName == vaccineName)&&(identical(other.totalTarget, totalTarget) || other.totalTarget == totalTarget)&&(identical(other.totalTargetMale, totalTargetMale) || other.totalTargetMale == totalTargetMale)&&(identical(other.totalTargetFemale, totalTargetFemale) || other.totalTargetFemale == totalTargetFemale)&&(identical(other.totalCoverage, totalCoverage) || other.totalCoverage == totalCoverage)&&(identical(other.totalCoverageMale, totalCoverageMale) || other.totalCoverageMale == totalCoverageMale)&&(identical(other.totalCoverageFemale, totalCoverageFemale) || other.totalCoverageFemale == totalCoverageFemale)&&(identical(other.totalCoveragePercentage, totalCoveragePercentage) || other.totalCoveragePercentage == totalCoveragePercentage)&&(identical(other.totalCoveragePercentageMale, totalCoveragePercentageMale) || other.totalCoveragePercentageMale == totalCoveragePercentageMale)&&(identical(other.totalCoveragePercentageFemale, totalCoveragePercentageFemale) || other.totalCoveragePercentageFemale == totalCoveragePercentageFemale)&&const DeepCollectionEquality().equals(other.areas, areas)&&const DeepCollectionEquality().equals(other.monthWiseTotalCoverages, monthWiseTotalCoverages)&&(identical(other.performance, performance) || other.performance == performance));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,vaccineUid,vaccineName,totalTarget,totalTargetMale,totalTargetFemale,totalCoverage,totalCoverageMale,totalCoverageFemale,totalCoveragePercentage,totalCoveragePercentageMale,totalCoveragePercentageFemale,const DeepCollectionEquality().hash(areas),const DeepCollectionEquality().hash(monthWiseTotalCoverages),performance);

@override
String toString() {
  return 'Vaccine(vaccineUid: $vaccineUid, vaccineName: $vaccineName, totalTarget: $totalTarget, totalTargetMale: $totalTargetMale, totalTargetFemale: $totalTargetFemale, totalCoverage: $totalCoverage, totalCoverageMale: $totalCoverageMale, totalCoverageFemale: $totalCoverageFemale, totalCoveragePercentage: $totalCoveragePercentage, totalCoveragePercentageMale: $totalCoveragePercentageMale, totalCoveragePercentageFemale: $totalCoveragePercentageFemale, areas: $areas, monthWiseTotalCoverages: $monthWiseTotalCoverages, performance: $performance)';
}


}

/// @nodoc
abstract mixin class $VaccineCopyWith<$Res>  {
  factory $VaccineCopyWith(Vaccine value, $Res Function(Vaccine) _then) = _$VaccineCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'vaccine_uid') String? vaccineUid,@JsonKey(name: 'vaccine_name') String? vaccineName,@JsonKey(name: 'total_target') int? totalTarget,@JsonKey(name: 'total_target_male') int? totalTargetMale,@JsonKey(name: 'total_target_female') int? totalTargetFemale,@JsonKey(name: 'total_coverage') int? totalCoverage,@JsonKey(name: 'total_coverage_male') int? totalCoverageMale,@JsonKey(name: 'total_coverage_female') int? totalCoverageFemale,@JsonKey(name: 'total_coverage_percentage') double? totalCoveragePercentage,@JsonKey(name: 'total_coverage_percentage_male') double? totalCoveragePercentageMale,@JsonKey(name: 'total_coverage_percentage_female') double? totalCoveragePercentageFemale,@JsonKey(name: 'areas') List<Area>? areas,@JsonKey(name: 'month_wise_total_coverages') Map<String, MonthlyCoverage>? monthWiseTotalCoverages,@JsonKey(name: 'performance') Performance? performance
});


$PerformanceCopyWith<$Res>? get performance;

}
/// @nodoc
class _$VaccineCopyWithImpl<$Res>
    implements $VaccineCopyWith<$Res> {
  _$VaccineCopyWithImpl(this._self, this._then);

  final Vaccine _self;
  final $Res Function(Vaccine) _then;

/// Create a copy of Vaccine
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? vaccineUid = freezed,Object? vaccineName = freezed,Object? totalTarget = freezed,Object? totalTargetMale = freezed,Object? totalTargetFemale = freezed,Object? totalCoverage = freezed,Object? totalCoverageMale = freezed,Object? totalCoverageFemale = freezed,Object? totalCoveragePercentage = freezed,Object? totalCoveragePercentageMale = freezed,Object? totalCoveragePercentageFemale = freezed,Object? areas = freezed,Object? monthWiseTotalCoverages = freezed,Object? performance = freezed,}) {
  return _then(_self.copyWith(
vaccineUid: freezed == vaccineUid ? _self.vaccineUid : vaccineUid // ignore: cast_nullable_to_non_nullable
as String?,vaccineName: freezed == vaccineName ? _self.vaccineName : vaccineName // ignore: cast_nullable_to_non_nullable
as String?,totalTarget: freezed == totalTarget ? _self.totalTarget : totalTarget // ignore: cast_nullable_to_non_nullable
as int?,totalTargetMale: freezed == totalTargetMale ? _self.totalTargetMale : totalTargetMale // ignore: cast_nullable_to_non_nullable
as int?,totalTargetFemale: freezed == totalTargetFemale ? _self.totalTargetFemale : totalTargetFemale // ignore: cast_nullable_to_non_nullable
as int?,totalCoverage: freezed == totalCoverage ? _self.totalCoverage : totalCoverage // ignore: cast_nullable_to_non_nullable
as int?,totalCoverageMale: freezed == totalCoverageMale ? _self.totalCoverageMale : totalCoverageMale // ignore: cast_nullable_to_non_nullable
as int?,totalCoverageFemale: freezed == totalCoverageFemale ? _self.totalCoverageFemale : totalCoverageFemale // ignore: cast_nullable_to_non_nullable
as int?,totalCoveragePercentage: freezed == totalCoveragePercentage ? _self.totalCoveragePercentage : totalCoveragePercentage // ignore: cast_nullable_to_non_nullable
as double?,totalCoveragePercentageMale: freezed == totalCoveragePercentageMale ? _self.totalCoveragePercentageMale : totalCoveragePercentageMale // ignore: cast_nullable_to_non_nullable
as double?,totalCoveragePercentageFemale: freezed == totalCoveragePercentageFemale ? _self.totalCoveragePercentageFemale : totalCoveragePercentageFemale // ignore: cast_nullable_to_non_nullable
as double?,areas: freezed == areas ? _self.areas : areas // ignore: cast_nullable_to_non_nullable
as List<Area>?,monthWiseTotalCoverages: freezed == monthWiseTotalCoverages ? _self.monthWiseTotalCoverages : monthWiseTotalCoverages // ignore: cast_nullable_to_non_nullable
as Map<String, MonthlyCoverage>?,performance: freezed == performance ? _self.performance : performance // ignore: cast_nullable_to_non_nullable
as Performance?,
  ));
}
/// Create a copy of Vaccine
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PerformanceCopyWith<$Res>? get performance {
    if (_self.performance == null) {
    return null;
  }

  return $PerformanceCopyWith<$Res>(_self.performance!, (value) {
    return _then(_self.copyWith(performance: value));
  });
}
}


/// Adds pattern-matching-related methods to [Vaccine].
extension VaccinePatterns on Vaccine {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Vaccine value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Vaccine() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Vaccine value)  $default,){
final _that = this;
switch (_that) {
case _Vaccine():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Vaccine value)?  $default,){
final _that = this;
switch (_that) {
case _Vaccine() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'vaccine_uid')  String? vaccineUid, @JsonKey(name: 'vaccine_name')  String? vaccineName, @JsonKey(name: 'total_target')  int? totalTarget, @JsonKey(name: 'total_target_male')  int? totalTargetMale, @JsonKey(name: 'total_target_female')  int? totalTargetFemale, @JsonKey(name: 'total_coverage')  int? totalCoverage, @JsonKey(name: 'total_coverage_male')  int? totalCoverageMale, @JsonKey(name: 'total_coverage_female')  int? totalCoverageFemale, @JsonKey(name: 'total_coverage_percentage')  double? totalCoveragePercentage, @JsonKey(name: 'total_coverage_percentage_male')  double? totalCoveragePercentageMale, @JsonKey(name: 'total_coverage_percentage_female')  double? totalCoveragePercentageFemale, @JsonKey(name: 'areas')  List<Area>? areas, @JsonKey(name: 'month_wise_total_coverages')  Map<String, MonthlyCoverage>? monthWiseTotalCoverages, @JsonKey(name: 'performance')  Performance? performance)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Vaccine() when $default != null:
return $default(_that.vaccineUid,_that.vaccineName,_that.totalTarget,_that.totalTargetMale,_that.totalTargetFemale,_that.totalCoverage,_that.totalCoverageMale,_that.totalCoverageFemale,_that.totalCoveragePercentage,_that.totalCoveragePercentageMale,_that.totalCoveragePercentageFemale,_that.areas,_that.monthWiseTotalCoverages,_that.performance);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'vaccine_uid')  String? vaccineUid, @JsonKey(name: 'vaccine_name')  String? vaccineName, @JsonKey(name: 'total_target')  int? totalTarget, @JsonKey(name: 'total_target_male')  int? totalTargetMale, @JsonKey(name: 'total_target_female')  int? totalTargetFemale, @JsonKey(name: 'total_coverage')  int? totalCoverage, @JsonKey(name: 'total_coverage_male')  int? totalCoverageMale, @JsonKey(name: 'total_coverage_female')  int? totalCoverageFemale, @JsonKey(name: 'total_coverage_percentage')  double? totalCoveragePercentage, @JsonKey(name: 'total_coverage_percentage_male')  double? totalCoveragePercentageMale, @JsonKey(name: 'total_coverage_percentage_female')  double? totalCoveragePercentageFemale, @JsonKey(name: 'areas')  List<Area>? areas, @JsonKey(name: 'month_wise_total_coverages')  Map<String, MonthlyCoverage>? monthWiseTotalCoverages, @JsonKey(name: 'performance')  Performance? performance)  $default,) {final _that = this;
switch (_that) {
case _Vaccine():
return $default(_that.vaccineUid,_that.vaccineName,_that.totalTarget,_that.totalTargetMale,_that.totalTargetFemale,_that.totalCoverage,_that.totalCoverageMale,_that.totalCoverageFemale,_that.totalCoveragePercentage,_that.totalCoveragePercentageMale,_that.totalCoveragePercentageFemale,_that.areas,_that.monthWiseTotalCoverages,_that.performance);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'vaccine_uid')  String? vaccineUid, @JsonKey(name: 'vaccine_name')  String? vaccineName, @JsonKey(name: 'total_target')  int? totalTarget, @JsonKey(name: 'total_target_male')  int? totalTargetMale, @JsonKey(name: 'total_target_female')  int? totalTargetFemale, @JsonKey(name: 'total_coverage')  int? totalCoverage, @JsonKey(name: 'total_coverage_male')  int? totalCoverageMale, @JsonKey(name: 'total_coverage_female')  int? totalCoverageFemale, @JsonKey(name: 'total_coverage_percentage')  double? totalCoveragePercentage, @JsonKey(name: 'total_coverage_percentage_male')  double? totalCoveragePercentageMale, @JsonKey(name: 'total_coverage_percentage_female')  double? totalCoveragePercentageFemale, @JsonKey(name: 'areas')  List<Area>? areas, @JsonKey(name: 'month_wise_total_coverages')  Map<String, MonthlyCoverage>? monthWiseTotalCoverages, @JsonKey(name: 'performance')  Performance? performance)?  $default,) {final _that = this;
switch (_that) {
case _Vaccine() when $default != null:
return $default(_that.vaccineUid,_that.vaccineName,_that.totalTarget,_that.totalTargetMale,_that.totalTargetFemale,_that.totalCoverage,_that.totalCoverageMale,_that.totalCoverageFemale,_that.totalCoveragePercentage,_that.totalCoveragePercentageMale,_that.totalCoveragePercentageFemale,_that.areas,_that.monthWiseTotalCoverages,_that.performance);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Vaccine implements Vaccine {
  const _Vaccine({@JsonKey(name: 'vaccine_uid') this.vaccineUid, @JsonKey(name: 'vaccine_name') this.vaccineName, @JsonKey(name: 'total_target') this.totalTarget, @JsonKey(name: 'total_target_male') this.totalTargetMale, @JsonKey(name: 'total_target_female') this.totalTargetFemale, @JsonKey(name: 'total_coverage') this.totalCoverage, @JsonKey(name: 'total_coverage_male') this.totalCoverageMale, @JsonKey(name: 'total_coverage_female') this.totalCoverageFemale, @JsonKey(name: 'total_coverage_percentage') this.totalCoveragePercentage, @JsonKey(name: 'total_coverage_percentage_male') this.totalCoveragePercentageMale, @JsonKey(name: 'total_coverage_percentage_female') this.totalCoveragePercentageFemale, @JsonKey(name: 'areas') final  List<Area>? areas, @JsonKey(name: 'month_wise_total_coverages') final  Map<String, MonthlyCoverage>? monthWiseTotalCoverages, @JsonKey(name: 'performance') this.performance}): _areas = areas,_monthWiseTotalCoverages = monthWiseTotalCoverages;
  factory _Vaccine.fromJson(Map<String, dynamic> json) => _$VaccineFromJson(json);

@override@JsonKey(name: 'vaccine_uid') final  String? vaccineUid;
@override@JsonKey(name: 'vaccine_name') final  String? vaccineName;
@override@JsonKey(name: 'total_target') final  int? totalTarget;
@override@JsonKey(name: 'total_target_male') final  int? totalTargetMale;
@override@JsonKey(name: 'total_target_female') final  int? totalTargetFemale;
@override@JsonKey(name: 'total_coverage') final  int? totalCoverage;
@override@JsonKey(name: 'total_coverage_male') final  int? totalCoverageMale;
@override@JsonKey(name: 'total_coverage_female') final  int? totalCoverageFemale;
@override@JsonKey(name: 'total_coverage_percentage') final  double? totalCoveragePercentage;
@override@JsonKey(name: 'total_coverage_percentage_male') final  double? totalCoveragePercentageMale;
@override@JsonKey(name: 'total_coverage_percentage_female') final  double? totalCoveragePercentageFemale;
 final  List<Area>? _areas;
@override@JsonKey(name: 'areas') List<Area>? get areas {
  final value = _areas;
  if (value == null) return null;
  if (_areas is EqualUnmodifiableListView) return _areas;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  Map<String, MonthlyCoverage>? _monthWiseTotalCoverages;
@override@JsonKey(name: 'month_wise_total_coverages') Map<String, MonthlyCoverage>? get monthWiseTotalCoverages {
  final value = _monthWiseTotalCoverages;
  if (value == null) return null;
  if (_monthWiseTotalCoverages is EqualUnmodifiableMapView) return _monthWiseTotalCoverages;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

@override@JsonKey(name: 'performance') final  Performance? performance;

/// Create a copy of Vaccine
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VaccineCopyWith<_Vaccine> get copyWith => __$VaccineCopyWithImpl<_Vaccine>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VaccineToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Vaccine&&(identical(other.vaccineUid, vaccineUid) || other.vaccineUid == vaccineUid)&&(identical(other.vaccineName, vaccineName) || other.vaccineName == vaccineName)&&(identical(other.totalTarget, totalTarget) || other.totalTarget == totalTarget)&&(identical(other.totalTargetMale, totalTargetMale) || other.totalTargetMale == totalTargetMale)&&(identical(other.totalTargetFemale, totalTargetFemale) || other.totalTargetFemale == totalTargetFemale)&&(identical(other.totalCoverage, totalCoverage) || other.totalCoverage == totalCoverage)&&(identical(other.totalCoverageMale, totalCoverageMale) || other.totalCoverageMale == totalCoverageMale)&&(identical(other.totalCoverageFemale, totalCoverageFemale) || other.totalCoverageFemale == totalCoverageFemale)&&(identical(other.totalCoveragePercentage, totalCoveragePercentage) || other.totalCoveragePercentage == totalCoveragePercentage)&&(identical(other.totalCoveragePercentageMale, totalCoveragePercentageMale) || other.totalCoveragePercentageMale == totalCoveragePercentageMale)&&(identical(other.totalCoveragePercentageFemale, totalCoveragePercentageFemale) || other.totalCoveragePercentageFemale == totalCoveragePercentageFemale)&&const DeepCollectionEquality().equals(other._areas, _areas)&&const DeepCollectionEquality().equals(other._monthWiseTotalCoverages, _monthWiseTotalCoverages)&&(identical(other.performance, performance) || other.performance == performance));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,vaccineUid,vaccineName,totalTarget,totalTargetMale,totalTargetFemale,totalCoverage,totalCoverageMale,totalCoverageFemale,totalCoveragePercentage,totalCoveragePercentageMale,totalCoveragePercentageFemale,const DeepCollectionEquality().hash(_areas),const DeepCollectionEquality().hash(_monthWiseTotalCoverages),performance);

@override
String toString() {
  return 'Vaccine(vaccineUid: $vaccineUid, vaccineName: $vaccineName, totalTarget: $totalTarget, totalTargetMale: $totalTargetMale, totalTargetFemale: $totalTargetFemale, totalCoverage: $totalCoverage, totalCoverageMale: $totalCoverageMale, totalCoverageFemale: $totalCoverageFemale, totalCoveragePercentage: $totalCoveragePercentage, totalCoveragePercentageMale: $totalCoveragePercentageMale, totalCoveragePercentageFemale: $totalCoveragePercentageFemale, areas: $areas, monthWiseTotalCoverages: $monthWiseTotalCoverages, performance: $performance)';
}


}

/// @nodoc
abstract mixin class _$VaccineCopyWith<$Res> implements $VaccineCopyWith<$Res> {
  factory _$VaccineCopyWith(_Vaccine value, $Res Function(_Vaccine) _then) = __$VaccineCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'vaccine_uid') String? vaccineUid,@JsonKey(name: 'vaccine_name') String? vaccineName,@JsonKey(name: 'total_target') int? totalTarget,@JsonKey(name: 'total_target_male') int? totalTargetMale,@JsonKey(name: 'total_target_female') int? totalTargetFemale,@JsonKey(name: 'total_coverage') int? totalCoverage,@JsonKey(name: 'total_coverage_male') int? totalCoverageMale,@JsonKey(name: 'total_coverage_female') int? totalCoverageFemale,@JsonKey(name: 'total_coverage_percentage') double? totalCoveragePercentage,@JsonKey(name: 'total_coverage_percentage_male') double? totalCoveragePercentageMale,@JsonKey(name: 'total_coverage_percentage_female') double? totalCoveragePercentageFemale,@JsonKey(name: 'areas') List<Area>? areas,@JsonKey(name: 'month_wise_total_coverages') Map<String, MonthlyCoverage>? monthWiseTotalCoverages,@JsonKey(name: 'performance') Performance? performance
});


@override $PerformanceCopyWith<$Res>? get performance;

}
/// @nodoc
class __$VaccineCopyWithImpl<$Res>
    implements _$VaccineCopyWith<$Res> {
  __$VaccineCopyWithImpl(this._self, this._then);

  final _Vaccine _self;
  final $Res Function(_Vaccine) _then;

/// Create a copy of Vaccine
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? vaccineUid = freezed,Object? vaccineName = freezed,Object? totalTarget = freezed,Object? totalTargetMale = freezed,Object? totalTargetFemale = freezed,Object? totalCoverage = freezed,Object? totalCoverageMale = freezed,Object? totalCoverageFemale = freezed,Object? totalCoveragePercentage = freezed,Object? totalCoveragePercentageMale = freezed,Object? totalCoveragePercentageFemale = freezed,Object? areas = freezed,Object? monthWiseTotalCoverages = freezed,Object? performance = freezed,}) {
  return _then(_Vaccine(
vaccineUid: freezed == vaccineUid ? _self.vaccineUid : vaccineUid // ignore: cast_nullable_to_non_nullable
as String?,vaccineName: freezed == vaccineName ? _self.vaccineName : vaccineName // ignore: cast_nullable_to_non_nullable
as String?,totalTarget: freezed == totalTarget ? _self.totalTarget : totalTarget // ignore: cast_nullable_to_non_nullable
as int?,totalTargetMale: freezed == totalTargetMale ? _self.totalTargetMale : totalTargetMale // ignore: cast_nullable_to_non_nullable
as int?,totalTargetFemale: freezed == totalTargetFemale ? _self.totalTargetFemale : totalTargetFemale // ignore: cast_nullable_to_non_nullable
as int?,totalCoverage: freezed == totalCoverage ? _self.totalCoverage : totalCoverage // ignore: cast_nullable_to_non_nullable
as int?,totalCoverageMale: freezed == totalCoverageMale ? _self.totalCoverageMale : totalCoverageMale // ignore: cast_nullable_to_non_nullable
as int?,totalCoverageFemale: freezed == totalCoverageFemale ? _self.totalCoverageFemale : totalCoverageFemale // ignore: cast_nullable_to_non_nullable
as int?,totalCoveragePercentage: freezed == totalCoveragePercentage ? _self.totalCoveragePercentage : totalCoveragePercentage // ignore: cast_nullable_to_non_nullable
as double?,totalCoveragePercentageMale: freezed == totalCoveragePercentageMale ? _self.totalCoveragePercentageMale : totalCoveragePercentageMale // ignore: cast_nullable_to_non_nullable
as double?,totalCoveragePercentageFemale: freezed == totalCoveragePercentageFemale ? _self.totalCoveragePercentageFemale : totalCoveragePercentageFemale // ignore: cast_nullable_to_non_nullable
as double?,areas: freezed == areas ? _self._areas : areas // ignore: cast_nullable_to_non_nullable
as List<Area>?,monthWiseTotalCoverages: freezed == monthWiseTotalCoverages ? _self._monthWiseTotalCoverages : monthWiseTotalCoverages // ignore: cast_nullable_to_non_nullable
as Map<String, MonthlyCoverage>?,performance: freezed == performance ? _self.performance : performance // ignore: cast_nullable_to_non_nullable
as Performance?,
  ));
}

/// Create a copy of Vaccine
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PerformanceCopyWith<$Res>? get performance {
    if (_self.performance == null) {
    return null;
  }

  return $PerformanceCopyWith<$Res>(_self.performance!, (value) {
    return _then(_self.copyWith(performance: value));
  });
}
}


/// @nodoc
mixin _$Area {

@JsonKey(name: 'name') String? get name;@JsonKey(name: 'uid') String? get uid;@JsonKey(name: 'target') int? get target;@JsonKey(name: 'target_male') int? get targetMale;@JsonKey(name: 'target_female') int? get targetFemale;@JsonKey(name: 'coverage') int? get coverage;@JsonKey(name: 'coverage_male') int? get coverageMale;@JsonKey(name: 'coverage_female') int? get coverageFemale;@JsonKey(name: 'coverage_percentage') double? get coveragePercentage;@JsonKey(name: 'coverage_percentage_male') double? get coveragePercentageMale;@JsonKey(name: 'coverage_percentage_female') double? get coveragePercentageFemale;@JsonKey(name: 'dropout') double? get dropout;@JsonKey(name: 'dropout_male') double? get dropoutMale;@JsonKey(name: 'dropout_female') double? get dropoutFemale;@JsonKey(name: 'monthly_coverages') Map<String, MonthlyCoverage>? get monthlyCoverages;
/// Create a copy of Area
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AreaCopyWith<Area> get copyWith => _$AreaCopyWithImpl<Area>(this as Area, _$identity);

  /// Serializes this Area to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Area&&(identical(other.name, name) || other.name == name)&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.target, target) || other.target == target)&&(identical(other.targetMale, targetMale) || other.targetMale == targetMale)&&(identical(other.targetFemale, targetFemale) || other.targetFemale == targetFemale)&&(identical(other.coverage, coverage) || other.coverage == coverage)&&(identical(other.coverageMale, coverageMale) || other.coverageMale == coverageMale)&&(identical(other.coverageFemale, coverageFemale) || other.coverageFemale == coverageFemale)&&(identical(other.coveragePercentage, coveragePercentage) || other.coveragePercentage == coveragePercentage)&&(identical(other.coveragePercentageMale, coveragePercentageMale) || other.coveragePercentageMale == coveragePercentageMale)&&(identical(other.coveragePercentageFemale, coveragePercentageFemale) || other.coveragePercentageFemale == coveragePercentageFemale)&&(identical(other.dropout, dropout) || other.dropout == dropout)&&(identical(other.dropoutMale, dropoutMale) || other.dropoutMale == dropoutMale)&&(identical(other.dropoutFemale, dropoutFemale) || other.dropoutFemale == dropoutFemale)&&const DeepCollectionEquality().equals(other.monthlyCoverages, monthlyCoverages));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,uid,target,targetMale,targetFemale,coverage,coverageMale,coverageFemale,coveragePercentage,coveragePercentageMale,coveragePercentageFemale,dropout,dropoutMale,dropoutFemale,const DeepCollectionEquality().hash(monthlyCoverages));

@override
String toString() {
  return 'Area(name: $name, uid: $uid, target: $target, targetMale: $targetMale, targetFemale: $targetFemale, coverage: $coverage, coverageMale: $coverageMale, coverageFemale: $coverageFemale, coveragePercentage: $coveragePercentage, coveragePercentageMale: $coveragePercentageMale, coveragePercentageFemale: $coveragePercentageFemale, dropout: $dropout, dropoutMale: $dropoutMale, dropoutFemale: $dropoutFemale, monthlyCoverages: $monthlyCoverages)';
}


}

/// @nodoc
abstract mixin class $AreaCopyWith<$Res>  {
  factory $AreaCopyWith(Area value, $Res Function(Area) _then) = _$AreaCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'name') String? name,@JsonKey(name: 'uid') String? uid,@JsonKey(name: 'target') int? target,@JsonKey(name: 'target_male') int? targetMale,@JsonKey(name: 'target_female') int? targetFemale,@JsonKey(name: 'coverage') int? coverage,@JsonKey(name: 'coverage_male') int? coverageMale,@JsonKey(name: 'coverage_female') int? coverageFemale,@JsonKey(name: 'coverage_percentage') double? coveragePercentage,@JsonKey(name: 'coverage_percentage_male') double? coveragePercentageMale,@JsonKey(name: 'coverage_percentage_female') double? coveragePercentageFemale,@JsonKey(name: 'dropout') double? dropout,@JsonKey(name: 'dropout_male') double? dropoutMale,@JsonKey(name: 'dropout_female') double? dropoutFemale,@JsonKey(name: 'monthly_coverages') Map<String, MonthlyCoverage>? monthlyCoverages
});




}
/// @nodoc
class _$AreaCopyWithImpl<$Res>
    implements $AreaCopyWith<$Res> {
  _$AreaCopyWithImpl(this._self, this._then);

  final Area _self;
  final $Res Function(Area) _then;

/// Create a copy of Area
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = freezed,Object? uid = freezed,Object? target = freezed,Object? targetMale = freezed,Object? targetFemale = freezed,Object? coverage = freezed,Object? coverageMale = freezed,Object? coverageFemale = freezed,Object? coveragePercentage = freezed,Object? coveragePercentageMale = freezed,Object? coveragePercentageFemale = freezed,Object? dropout = freezed,Object? dropoutMale = freezed,Object? dropoutFemale = freezed,Object? monthlyCoverages = freezed,}) {
  return _then(_self.copyWith(
name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,uid: freezed == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String?,target: freezed == target ? _self.target : target // ignore: cast_nullable_to_non_nullable
as int?,targetMale: freezed == targetMale ? _self.targetMale : targetMale // ignore: cast_nullable_to_non_nullable
as int?,targetFemale: freezed == targetFemale ? _self.targetFemale : targetFemale // ignore: cast_nullable_to_non_nullable
as int?,coverage: freezed == coverage ? _self.coverage : coverage // ignore: cast_nullable_to_non_nullable
as int?,coverageMale: freezed == coverageMale ? _self.coverageMale : coverageMale // ignore: cast_nullable_to_non_nullable
as int?,coverageFemale: freezed == coverageFemale ? _self.coverageFemale : coverageFemale // ignore: cast_nullable_to_non_nullable
as int?,coveragePercentage: freezed == coveragePercentage ? _self.coveragePercentage : coveragePercentage // ignore: cast_nullable_to_non_nullable
as double?,coveragePercentageMale: freezed == coveragePercentageMale ? _self.coveragePercentageMale : coveragePercentageMale // ignore: cast_nullable_to_non_nullable
as double?,coveragePercentageFemale: freezed == coveragePercentageFemale ? _self.coveragePercentageFemale : coveragePercentageFemale // ignore: cast_nullable_to_non_nullable
as double?,dropout: freezed == dropout ? _self.dropout : dropout // ignore: cast_nullable_to_non_nullable
as double?,dropoutMale: freezed == dropoutMale ? _self.dropoutMale : dropoutMale // ignore: cast_nullable_to_non_nullable
as double?,dropoutFemale: freezed == dropoutFemale ? _self.dropoutFemale : dropoutFemale // ignore: cast_nullable_to_non_nullable
as double?,monthlyCoverages: freezed == monthlyCoverages ? _self.monthlyCoverages : monthlyCoverages // ignore: cast_nullable_to_non_nullable
as Map<String, MonthlyCoverage>?,
  ));
}

}


/// Adds pattern-matching-related methods to [Area].
extension AreaPatterns on Area {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Area value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Area() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Area value)  $default,){
final _that = this;
switch (_that) {
case _Area():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Area value)?  $default,){
final _that = this;
switch (_that) {
case _Area() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'name')  String? name, @JsonKey(name: 'uid')  String? uid, @JsonKey(name: 'target')  int? target, @JsonKey(name: 'target_male')  int? targetMale, @JsonKey(name: 'target_female')  int? targetFemale, @JsonKey(name: 'coverage')  int? coverage, @JsonKey(name: 'coverage_male')  int? coverageMale, @JsonKey(name: 'coverage_female')  int? coverageFemale, @JsonKey(name: 'coverage_percentage')  double? coveragePercentage, @JsonKey(name: 'coverage_percentage_male')  double? coveragePercentageMale, @JsonKey(name: 'coverage_percentage_female')  double? coveragePercentageFemale, @JsonKey(name: 'dropout')  double? dropout, @JsonKey(name: 'dropout_male')  double? dropoutMale, @JsonKey(name: 'dropout_female')  double? dropoutFemale, @JsonKey(name: 'monthly_coverages')  Map<String, MonthlyCoverage>? monthlyCoverages)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Area() when $default != null:
return $default(_that.name,_that.uid,_that.target,_that.targetMale,_that.targetFemale,_that.coverage,_that.coverageMale,_that.coverageFemale,_that.coveragePercentage,_that.coveragePercentageMale,_that.coveragePercentageFemale,_that.dropout,_that.dropoutMale,_that.dropoutFemale,_that.monthlyCoverages);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'name')  String? name, @JsonKey(name: 'uid')  String? uid, @JsonKey(name: 'target')  int? target, @JsonKey(name: 'target_male')  int? targetMale, @JsonKey(name: 'target_female')  int? targetFemale, @JsonKey(name: 'coverage')  int? coverage, @JsonKey(name: 'coverage_male')  int? coverageMale, @JsonKey(name: 'coverage_female')  int? coverageFemale, @JsonKey(name: 'coverage_percentage')  double? coveragePercentage, @JsonKey(name: 'coverage_percentage_male')  double? coveragePercentageMale, @JsonKey(name: 'coverage_percentage_female')  double? coveragePercentageFemale, @JsonKey(name: 'dropout')  double? dropout, @JsonKey(name: 'dropout_male')  double? dropoutMale, @JsonKey(name: 'dropout_female')  double? dropoutFemale, @JsonKey(name: 'monthly_coverages')  Map<String, MonthlyCoverage>? monthlyCoverages)  $default,) {final _that = this;
switch (_that) {
case _Area():
return $default(_that.name,_that.uid,_that.target,_that.targetMale,_that.targetFemale,_that.coverage,_that.coverageMale,_that.coverageFemale,_that.coveragePercentage,_that.coveragePercentageMale,_that.coveragePercentageFemale,_that.dropout,_that.dropoutMale,_that.dropoutFemale,_that.monthlyCoverages);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'name')  String? name, @JsonKey(name: 'uid')  String? uid, @JsonKey(name: 'target')  int? target, @JsonKey(name: 'target_male')  int? targetMale, @JsonKey(name: 'target_female')  int? targetFemale, @JsonKey(name: 'coverage')  int? coverage, @JsonKey(name: 'coverage_male')  int? coverageMale, @JsonKey(name: 'coverage_female')  int? coverageFemale, @JsonKey(name: 'coverage_percentage')  double? coveragePercentage, @JsonKey(name: 'coverage_percentage_male')  double? coveragePercentageMale, @JsonKey(name: 'coverage_percentage_female')  double? coveragePercentageFemale, @JsonKey(name: 'dropout')  double? dropout, @JsonKey(name: 'dropout_male')  double? dropoutMale, @JsonKey(name: 'dropout_female')  double? dropoutFemale, @JsonKey(name: 'monthly_coverages')  Map<String, MonthlyCoverage>? monthlyCoverages)?  $default,) {final _that = this;
switch (_that) {
case _Area() when $default != null:
return $default(_that.name,_that.uid,_that.target,_that.targetMale,_that.targetFemale,_that.coverage,_that.coverageMale,_that.coverageFemale,_that.coveragePercentage,_that.coveragePercentageMale,_that.coveragePercentageFemale,_that.dropout,_that.dropoutMale,_that.dropoutFemale,_that.monthlyCoverages);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Area implements Area {
  const _Area({@JsonKey(name: 'name') this.name, @JsonKey(name: 'uid') this.uid, @JsonKey(name: 'target') this.target, @JsonKey(name: 'target_male') this.targetMale, @JsonKey(name: 'target_female') this.targetFemale, @JsonKey(name: 'coverage') this.coverage, @JsonKey(name: 'coverage_male') this.coverageMale, @JsonKey(name: 'coverage_female') this.coverageFemale, @JsonKey(name: 'coverage_percentage') this.coveragePercentage, @JsonKey(name: 'coverage_percentage_male') this.coveragePercentageMale, @JsonKey(name: 'coverage_percentage_female') this.coveragePercentageFemale, @JsonKey(name: 'dropout') this.dropout, @JsonKey(name: 'dropout_male') this.dropoutMale, @JsonKey(name: 'dropout_female') this.dropoutFemale, @JsonKey(name: 'monthly_coverages') final  Map<String, MonthlyCoverage>? monthlyCoverages}): _monthlyCoverages = monthlyCoverages;
  factory _Area.fromJson(Map<String, dynamic> json) => _$AreaFromJson(json);

@override@JsonKey(name: 'name') final  String? name;
@override@JsonKey(name: 'uid') final  String? uid;
@override@JsonKey(name: 'target') final  int? target;
@override@JsonKey(name: 'target_male') final  int? targetMale;
@override@JsonKey(name: 'target_female') final  int? targetFemale;
@override@JsonKey(name: 'coverage') final  int? coverage;
@override@JsonKey(name: 'coverage_male') final  int? coverageMale;
@override@JsonKey(name: 'coverage_female') final  int? coverageFemale;
@override@JsonKey(name: 'coverage_percentage') final  double? coveragePercentage;
@override@JsonKey(name: 'coverage_percentage_male') final  double? coveragePercentageMale;
@override@JsonKey(name: 'coverage_percentage_female') final  double? coveragePercentageFemale;
@override@JsonKey(name: 'dropout') final  double? dropout;
@override@JsonKey(name: 'dropout_male') final  double? dropoutMale;
@override@JsonKey(name: 'dropout_female') final  double? dropoutFemale;
 final  Map<String, MonthlyCoverage>? _monthlyCoverages;
@override@JsonKey(name: 'monthly_coverages') Map<String, MonthlyCoverage>? get monthlyCoverages {
  final value = _monthlyCoverages;
  if (value == null) return null;
  if (_monthlyCoverages is EqualUnmodifiableMapView) return _monthlyCoverages;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}


/// Create a copy of Area
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AreaCopyWith<_Area> get copyWith => __$AreaCopyWithImpl<_Area>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AreaToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Area&&(identical(other.name, name) || other.name == name)&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.target, target) || other.target == target)&&(identical(other.targetMale, targetMale) || other.targetMale == targetMale)&&(identical(other.targetFemale, targetFemale) || other.targetFemale == targetFemale)&&(identical(other.coverage, coverage) || other.coverage == coverage)&&(identical(other.coverageMale, coverageMale) || other.coverageMale == coverageMale)&&(identical(other.coverageFemale, coverageFemale) || other.coverageFemale == coverageFemale)&&(identical(other.coveragePercentage, coveragePercentage) || other.coveragePercentage == coveragePercentage)&&(identical(other.coveragePercentageMale, coveragePercentageMale) || other.coveragePercentageMale == coveragePercentageMale)&&(identical(other.coveragePercentageFemale, coveragePercentageFemale) || other.coveragePercentageFemale == coveragePercentageFemale)&&(identical(other.dropout, dropout) || other.dropout == dropout)&&(identical(other.dropoutMale, dropoutMale) || other.dropoutMale == dropoutMale)&&(identical(other.dropoutFemale, dropoutFemale) || other.dropoutFemale == dropoutFemale)&&const DeepCollectionEquality().equals(other._monthlyCoverages, _monthlyCoverages));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,uid,target,targetMale,targetFemale,coverage,coverageMale,coverageFemale,coveragePercentage,coveragePercentageMale,coveragePercentageFemale,dropout,dropoutMale,dropoutFemale,const DeepCollectionEquality().hash(_monthlyCoverages));

@override
String toString() {
  return 'Area(name: $name, uid: $uid, target: $target, targetMale: $targetMale, targetFemale: $targetFemale, coverage: $coverage, coverageMale: $coverageMale, coverageFemale: $coverageFemale, coveragePercentage: $coveragePercentage, coveragePercentageMale: $coveragePercentageMale, coveragePercentageFemale: $coveragePercentageFemale, dropout: $dropout, dropoutMale: $dropoutMale, dropoutFemale: $dropoutFemale, monthlyCoverages: $monthlyCoverages)';
}


}

/// @nodoc
abstract mixin class _$AreaCopyWith<$Res> implements $AreaCopyWith<$Res> {
  factory _$AreaCopyWith(_Area value, $Res Function(_Area) _then) = __$AreaCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'name') String? name,@JsonKey(name: 'uid') String? uid,@JsonKey(name: 'target') int? target,@JsonKey(name: 'target_male') int? targetMale,@JsonKey(name: 'target_female') int? targetFemale,@JsonKey(name: 'coverage') int? coverage,@JsonKey(name: 'coverage_male') int? coverageMale,@JsonKey(name: 'coverage_female') int? coverageFemale,@JsonKey(name: 'coverage_percentage') double? coveragePercentage,@JsonKey(name: 'coverage_percentage_male') double? coveragePercentageMale,@JsonKey(name: 'coverage_percentage_female') double? coveragePercentageFemale,@JsonKey(name: 'dropout') double? dropout,@JsonKey(name: 'dropout_male') double? dropoutMale,@JsonKey(name: 'dropout_female') double? dropoutFemale,@JsonKey(name: 'monthly_coverages') Map<String, MonthlyCoverage>? monthlyCoverages
});




}
/// @nodoc
class __$AreaCopyWithImpl<$Res>
    implements _$AreaCopyWith<$Res> {
  __$AreaCopyWithImpl(this._self, this._then);

  final _Area _self;
  final $Res Function(_Area) _then;

/// Create a copy of Area
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = freezed,Object? uid = freezed,Object? target = freezed,Object? targetMale = freezed,Object? targetFemale = freezed,Object? coverage = freezed,Object? coverageMale = freezed,Object? coverageFemale = freezed,Object? coveragePercentage = freezed,Object? coveragePercentageMale = freezed,Object? coveragePercentageFemale = freezed,Object? dropout = freezed,Object? dropoutMale = freezed,Object? dropoutFemale = freezed,Object? monthlyCoverages = freezed,}) {
  return _then(_Area(
name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,uid: freezed == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String?,target: freezed == target ? _self.target : target // ignore: cast_nullable_to_non_nullable
as int?,targetMale: freezed == targetMale ? _self.targetMale : targetMale // ignore: cast_nullable_to_non_nullable
as int?,targetFemale: freezed == targetFemale ? _self.targetFemale : targetFemale // ignore: cast_nullable_to_non_nullable
as int?,coverage: freezed == coverage ? _self.coverage : coverage // ignore: cast_nullable_to_non_nullable
as int?,coverageMale: freezed == coverageMale ? _self.coverageMale : coverageMale // ignore: cast_nullable_to_non_nullable
as int?,coverageFemale: freezed == coverageFemale ? _self.coverageFemale : coverageFemale // ignore: cast_nullable_to_non_nullable
as int?,coveragePercentage: freezed == coveragePercentage ? _self.coveragePercentage : coveragePercentage // ignore: cast_nullable_to_non_nullable
as double?,coveragePercentageMale: freezed == coveragePercentageMale ? _self.coveragePercentageMale : coveragePercentageMale // ignore: cast_nullable_to_non_nullable
as double?,coveragePercentageFemale: freezed == coveragePercentageFemale ? _self.coveragePercentageFemale : coveragePercentageFemale // ignore: cast_nullable_to_non_nullable
as double?,dropout: freezed == dropout ? _self.dropout : dropout // ignore: cast_nullable_to_non_nullable
as double?,dropoutMale: freezed == dropoutMale ? _self.dropoutMale : dropoutMale // ignore: cast_nullable_to_non_nullable
as double?,dropoutFemale: freezed == dropoutFemale ? _self.dropoutFemale : dropoutFemale // ignore: cast_nullable_to_non_nullable
as double?,monthlyCoverages: freezed == monthlyCoverages ? _self._monthlyCoverages : monthlyCoverages // ignore: cast_nullable_to_non_nullable
as Map<String, MonthlyCoverage>?,
  ));
}


}


/// @nodoc
mixin _$MonthlyCoverage {

@JsonKey(name: 'coverage') int? get coverage;@JsonKey(name: 'coverage_male') int? get coverageMale;@JsonKey(name: 'coverage_female') int? get coverageFemale;@JsonKey(name: 'coverage_percentage') double? get coveragePercentage;@JsonKey(name: 'coverage_percentage_male') double? get coveragePercentageMale;@JsonKey(name: 'coverage_percentage_female') double? get coveragePercentageFemale;
/// Create a copy of MonthlyCoverage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MonthlyCoverageCopyWith<MonthlyCoverage> get copyWith => _$MonthlyCoverageCopyWithImpl<MonthlyCoverage>(this as MonthlyCoverage, _$identity);

  /// Serializes this MonthlyCoverage to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MonthlyCoverage&&(identical(other.coverage, coverage) || other.coverage == coverage)&&(identical(other.coverageMale, coverageMale) || other.coverageMale == coverageMale)&&(identical(other.coverageFemale, coverageFemale) || other.coverageFemale == coverageFemale)&&(identical(other.coveragePercentage, coveragePercentage) || other.coveragePercentage == coveragePercentage)&&(identical(other.coveragePercentageMale, coveragePercentageMale) || other.coveragePercentageMale == coveragePercentageMale)&&(identical(other.coveragePercentageFemale, coveragePercentageFemale) || other.coveragePercentageFemale == coveragePercentageFemale));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,coverage,coverageMale,coverageFemale,coveragePercentage,coveragePercentageMale,coveragePercentageFemale);

@override
String toString() {
  return 'MonthlyCoverage(coverage: $coverage, coverageMale: $coverageMale, coverageFemale: $coverageFemale, coveragePercentage: $coveragePercentage, coveragePercentageMale: $coveragePercentageMale, coveragePercentageFemale: $coveragePercentageFemale)';
}


}

/// @nodoc
abstract mixin class $MonthlyCoverageCopyWith<$Res>  {
  factory $MonthlyCoverageCopyWith(MonthlyCoverage value, $Res Function(MonthlyCoverage) _then) = _$MonthlyCoverageCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'coverage') int? coverage,@JsonKey(name: 'coverage_male') int? coverageMale,@JsonKey(name: 'coverage_female') int? coverageFemale,@JsonKey(name: 'coverage_percentage') double? coveragePercentage,@JsonKey(name: 'coverage_percentage_male') double? coveragePercentageMale,@JsonKey(name: 'coverage_percentage_female') double? coveragePercentageFemale
});




}
/// @nodoc
class _$MonthlyCoverageCopyWithImpl<$Res>
    implements $MonthlyCoverageCopyWith<$Res> {
  _$MonthlyCoverageCopyWithImpl(this._self, this._then);

  final MonthlyCoverage _self;
  final $Res Function(MonthlyCoverage) _then;

/// Create a copy of MonthlyCoverage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? coverage = freezed,Object? coverageMale = freezed,Object? coverageFemale = freezed,Object? coveragePercentage = freezed,Object? coveragePercentageMale = freezed,Object? coveragePercentageFemale = freezed,}) {
  return _then(_self.copyWith(
coverage: freezed == coverage ? _self.coverage : coverage // ignore: cast_nullable_to_non_nullable
as int?,coverageMale: freezed == coverageMale ? _self.coverageMale : coverageMale // ignore: cast_nullable_to_non_nullable
as int?,coverageFemale: freezed == coverageFemale ? _self.coverageFemale : coverageFemale // ignore: cast_nullable_to_non_nullable
as int?,coveragePercentage: freezed == coveragePercentage ? _self.coveragePercentage : coveragePercentage // ignore: cast_nullable_to_non_nullable
as double?,coveragePercentageMale: freezed == coveragePercentageMale ? _self.coveragePercentageMale : coveragePercentageMale // ignore: cast_nullable_to_non_nullable
as double?,coveragePercentageFemale: freezed == coveragePercentageFemale ? _self.coveragePercentageFemale : coveragePercentageFemale // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [MonthlyCoverage].
extension MonthlyCoveragePatterns on MonthlyCoverage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MonthlyCoverage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MonthlyCoverage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MonthlyCoverage value)  $default,){
final _that = this;
switch (_that) {
case _MonthlyCoverage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MonthlyCoverage value)?  $default,){
final _that = this;
switch (_that) {
case _MonthlyCoverage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'coverage')  int? coverage, @JsonKey(name: 'coverage_male')  int? coverageMale, @JsonKey(name: 'coverage_female')  int? coverageFemale, @JsonKey(name: 'coverage_percentage')  double? coveragePercentage, @JsonKey(name: 'coverage_percentage_male')  double? coveragePercentageMale, @JsonKey(name: 'coverage_percentage_female')  double? coveragePercentageFemale)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MonthlyCoverage() when $default != null:
return $default(_that.coverage,_that.coverageMale,_that.coverageFemale,_that.coveragePercentage,_that.coveragePercentageMale,_that.coveragePercentageFemale);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'coverage')  int? coverage, @JsonKey(name: 'coverage_male')  int? coverageMale, @JsonKey(name: 'coverage_female')  int? coverageFemale, @JsonKey(name: 'coverage_percentage')  double? coveragePercentage, @JsonKey(name: 'coverage_percentage_male')  double? coveragePercentageMale, @JsonKey(name: 'coverage_percentage_female')  double? coveragePercentageFemale)  $default,) {final _that = this;
switch (_that) {
case _MonthlyCoverage():
return $default(_that.coverage,_that.coverageMale,_that.coverageFemale,_that.coveragePercentage,_that.coveragePercentageMale,_that.coveragePercentageFemale);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'coverage')  int? coverage, @JsonKey(name: 'coverage_male')  int? coverageMale, @JsonKey(name: 'coverage_female')  int? coverageFemale, @JsonKey(name: 'coverage_percentage')  double? coveragePercentage, @JsonKey(name: 'coverage_percentage_male')  double? coveragePercentageMale, @JsonKey(name: 'coverage_percentage_female')  double? coveragePercentageFemale)?  $default,) {final _that = this;
switch (_that) {
case _MonthlyCoverage() when $default != null:
return $default(_that.coverage,_that.coverageMale,_that.coverageFemale,_that.coveragePercentage,_that.coveragePercentageMale,_that.coveragePercentageFemale);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MonthlyCoverage implements MonthlyCoverage {
  const _MonthlyCoverage({@JsonKey(name: 'coverage') this.coverage, @JsonKey(name: 'coverage_male') this.coverageMale, @JsonKey(name: 'coverage_female') this.coverageFemale, @JsonKey(name: 'coverage_percentage') this.coveragePercentage, @JsonKey(name: 'coverage_percentage_male') this.coveragePercentageMale, @JsonKey(name: 'coverage_percentage_female') this.coveragePercentageFemale});
  factory _MonthlyCoverage.fromJson(Map<String, dynamic> json) => _$MonthlyCoverageFromJson(json);

@override@JsonKey(name: 'coverage') final  int? coverage;
@override@JsonKey(name: 'coverage_male') final  int? coverageMale;
@override@JsonKey(name: 'coverage_female') final  int? coverageFemale;
@override@JsonKey(name: 'coverage_percentage') final  double? coveragePercentage;
@override@JsonKey(name: 'coverage_percentage_male') final  double? coveragePercentageMale;
@override@JsonKey(name: 'coverage_percentage_female') final  double? coveragePercentageFemale;

/// Create a copy of MonthlyCoverage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MonthlyCoverageCopyWith<_MonthlyCoverage> get copyWith => __$MonthlyCoverageCopyWithImpl<_MonthlyCoverage>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MonthlyCoverageToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MonthlyCoverage&&(identical(other.coverage, coverage) || other.coverage == coverage)&&(identical(other.coverageMale, coverageMale) || other.coverageMale == coverageMale)&&(identical(other.coverageFemale, coverageFemale) || other.coverageFemale == coverageFemale)&&(identical(other.coveragePercentage, coveragePercentage) || other.coveragePercentage == coveragePercentage)&&(identical(other.coveragePercentageMale, coveragePercentageMale) || other.coveragePercentageMale == coveragePercentageMale)&&(identical(other.coveragePercentageFemale, coveragePercentageFemale) || other.coveragePercentageFemale == coveragePercentageFemale));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,coverage,coverageMale,coverageFemale,coveragePercentage,coveragePercentageMale,coveragePercentageFemale);

@override
String toString() {
  return 'MonthlyCoverage(coverage: $coverage, coverageMale: $coverageMale, coverageFemale: $coverageFemale, coveragePercentage: $coveragePercentage, coveragePercentageMale: $coveragePercentageMale, coveragePercentageFemale: $coveragePercentageFemale)';
}


}

/// @nodoc
abstract mixin class _$MonthlyCoverageCopyWith<$Res> implements $MonthlyCoverageCopyWith<$Res> {
  factory _$MonthlyCoverageCopyWith(_MonthlyCoverage value, $Res Function(_MonthlyCoverage) _then) = __$MonthlyCoverageCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'coverage') int? coverage,@JsonKey(name: 'coverage_male') int? coverageMale,@JsonKey(name: 'coverage_female') int? coverageFemale,@JsonKey(name: 'coverage_percentage') double? coveragePercentage,@JsonKey(name: 'coverage_percentage_male') double? coveragePercentageMale,@JsonKey(name: 'coverage_percentage_female') double? coveragePercentageFemale
});




}
/// @nodoc
class __$MonthlyCoverageCopyWithImpl<$Res>
    implements _$MonthlyCoverageCopyWith<$Res> {
  __$MonthlyCoverageCopyWithImpl(this._self, this._then);

  final _MonthlyCoverage _self;
  final $Res Function(_MonthlyCoverage) _then;

/// Create a copy of MonthlyCoverage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? coverage = freezed,Object? coverageMale = freezed,Object? coverageFemale = freezed,Object? coveragePercentage = freezed,Object? coveragePercentageMale = freezed,Object? coveragePercentageFemale = freezed,}) {
  return _then(_MonthlyCoverage(
coverage: freezed == coverage ? _self.coverage : coverage // ignore: cast_nullable_to_non_nullable
as int?,coverageMale: freezed == coverageMale ? _self.coverageMale : coverageMale // ignore: cast_nullable_to_non_nullable
as int?,coverageFemale: freezed == coverageFemale ? _self.coverageFemale : coverageFemale // ignore: cast_nullable_to_non_nullable
as int?,coveragePercentage: freezed == coveragePercentage ? _self.coveragePercentage : coveragePercentage // ignore: cast_nullable_to_non_nullable
as double?,coveragePercentageMale: freezed == coveragePercentageMale ? _self.coveragePercentageMale : coveragePercentageMale // ignore: cast_nullable_to_non_nullable
as double?,coveragePercentageFemale: freezed == coveragePercentageFemale ? _self.coveragePercentageFemale : coveragePercentageFemale // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}


/// @nodoc
mixin _$Performance {

@JsonKey(name: 'highest') List<Area>? get highest;@JsonKey(name: 'lowest') List<Area>? get lowest;
/// Create a copy of Performance
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PerformanceCopyWith<Performance> get copyWith => _$PerformanceCopyWithImpl<Performance>(this as Performance, _$identity);

  /// Serializes this Performance to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Performance&&const DeepCollectionEquality().equals(other.highest, highest)&&const DeepCollectionEquality().equals(other.lowest, lowest));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(highest),const DeepCollectionEquality().hash(lowest));

@override
String toString() {
  return 'Performance(highest: $highest, lowest: $lowest)';
}


}

/// @nodoc
abstract mixin class $PerformanceCopyWith<$Res>  {
  factory $PerformanceCopyWith(Performance value, $Res Function(Performance) _then) = _$PerformanceCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'highest') List<Area>? highest,@JsonKey(name: 'lowest') List<Area>? lowest
});




}
/// @nodoc
class _$PerformanceCopyWithImpl<$Res>
    implements $PerformanceCopyWith<$Res> {
  _$PerformanceCopyWithImpl(this._self, this._then);

  final Performance _self;
  final $Res Function(Performance) _then;

/// Create a copy of Performance
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? highest = freezed,Object? lowest = freezed,}) {
  return _then(_self.copyWith(
highest: freezed == highest ? _self.highest : highest // ignore: cast_nullable_to_non_nullable
as List<Area>?,lowest: freezed == lowest ? _self.lowest : lowest // ignore: cast_nullable_to_non_nullable
as List<Area>?,
  ));
}

}


/// Adds pattern-matching-related methods to [Performance].
extension PerformancePatterns on Performance {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Performance value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Performance() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Performance value)  $default,){
final _that = this;
switch (_that) {
case _Performance():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Performance value)?  $default,){
final _that = this;
switch (_that) {
case _Performance() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'highest')  List<Area>? highest, @JsonKey(name: 'lowest')  List<Area>? lowest)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Performance() when $default != null:
return $default(_that.highest,_that.lowest);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'highest')  List<Area>? highest, @JsonKey(name: 'lowest')  List<Area>? lowest)  $default,) {final _that = this;
switch (_that) {
case _Performance():
return $default(_that.highest,_that.lowest);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'highest')  List<Area>? highest, @JsonKey(name: 'lowest')  List<Area>? lowest)?  $default,) {final _that = this;
switch (_that) {
case _Performance() when $default != null:
return $default(_that.highest,_that.lowest);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Performance implements Performance {
  const _Performance({@JsonKey(name: 'highest') final  List<Area>? highest, @JsonKey(name: 'lowest') final  List<Area>? lowest}): _highest = highest,_lowest = lowest;
  factory _Performance.fromJson(Map<String, dynamic> json) => _$PerformanceFromJson(json);

 final  List<Area>? _highest;
@override@JsonKey(name: 'highest') List<Area>? get highest {
  final value = _highest;
  if (value == null) return null;
  if (_highest is EqualUnmodifiableListView) return _highest;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<Area>? _lowest;
@override@JsonKey(name: 'lowest') List<Area>? get lowest {
  final value = _lowest;
  if (value == null) return null;
  if (_lowest is EqualUnmodifiableListView) return _lowest;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of Performance
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PerformanceCopyWith<_Performance> get copyWith => __$PerformanceCopyWithImpl<_Performance>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PerformanceToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Performance&&const DeepCollectionEquality().equals(other._highest, _highest)&&const DeepCollectionEquality().equals(other._lowest, _lowest));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_highest),const DeepCollectionEquality().hash(_lowest));

@override
String toString() {
  return 'Performance(highest: $highest, lowest: $lowest)';
}


}

/// @nodoc
abstract mixin class _$PerformanceCopyWith<$Res> implements $PerformanceCopyWith<$Res> {
  factory _$PerformanceCopyWith(_Performance value, $Res Function(_Performance) _then) = __$PerformanceCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'highest') List<Area>? highest,@JsonKey(name: 'lowest') List<Area>? lowest
});




}
/// @nodoc
class __$PerformanceCopyWithImpl<$Res>
    implements _$PerformanceCopyWith<$Res> {
  __$PerformanceCopyWithImpl(this._self, this._then);

  final _Performance _self;
  final $Res Function(_Performance) _then;

/// Create a copy of Performance
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? highest = freezed,Object? lowest = freezed,}) {
  return _then(_Performance(
highest: freezed == highest ? _self._highest : highest // ignore: cast_nullable_to_non_nullable
as List<Area>?,lowest: freezed == lowest ? _self._lowest : lowest // ignore: cast_nullable_to_non_nullable
as List<Area>?,
  ));
}


}

// dart format on
