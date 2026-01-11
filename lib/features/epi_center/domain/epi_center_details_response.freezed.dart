// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'epi_center_details_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$EpiCenterDetailsResponse {

 List<CityCorporation> get cityCorporations; List<District> get districts; List<Division> get divisions; Area? get area; CoverageTableData? get coverageTableData; ChartData? get chartData; String? get uid; String? get nameList; List<Subblock> get subblocks; List<Ward> get wards; List<Union> get unions; List<Upazila> get upazilas; String? get subblockId; String? get wardId; String? get unionId; String? get upazilaId; String? get districtId; String? get divisionId; String? get type; String? get subBlockName; String? get wardName; String? get unionName; String? get upazilaName; String? get districtName; String? get divisionName; String? get cityCorporationName; String? get ccZoneName; String? get ccWardName; String? get ccUid; int? get selectedYear;// ✅ NEW: Root-level additionalData for country-level responses
 AdditionalData? get additionalData;
/// Create a copy of EpiCenterDetailsResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EpiCenterDetailsResponseCopyWith<EpiCenterDetailsResponse> get copyWith => _$EpiCenterDetailsResponseCopyWithImpl<EpiCenterDetailsResponse>(this as EpiCenterDetailsResponse, _$identity);

  /// Serializes this EpiCenterDetailsResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EpiCenterDetailsResponse&&const DeepCollectionEquality().equals(other.cityCorporations, cityCorporations)&&const DeepCollectionEquality().equals(other.districts, districts)&&const DeepCollectionEquality().equals(other.divisions, divisions)&&(identical(other.area, area) || other.area == area)&&(identical(other.coverageTableData, coverageTableData) || other.coverageTableData == coverageTableData)&&(identical(other.chartData, chartData) || other.chartData == chartData)&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.nameList, nameList) || other.nameList == nameList)&&const DeepCollectionEquality().equals(other.subblocks, subblocks)&&const DeepCollectionEquality().equals(other.wards, wards)&&const DeepCollectionEquality().equals(other.unions, unions)&&const DeepCollectionEquality().equals(other.upazilas, upazilas)&&(identical(other.subblockId, subblockId) || other.subblockId == subblockId)&&(identical(other.wardId, wardId) || other.wardId == wardId)&&(identical(other.unionId, unionId) || other.unionId == unionId)&&(identical(other.upazilaId, upazilaId) || other.upazilaId == upazilaId)&&(identical(other.districtId, districtId) || other.districtId == districtId)&&(identical(other.divisionId, divisionId) || other.divisionId == divisionId)&&(identical(other.type, type) || other.type == type)&&(identical(other.subBlockName, subBlockName) || other.subBlockName == subBlockName)&&(identical(other.wardName, wardName) || other.wardName == wardName)&&(identical(other.unionName, unionName) || other.unionName == unionName)&&(identical(other.upazilaName, upazilaName) || other.upazilaName == upazilaName)&&(identical(other.districtName, districtName) || other.districtName == districtName)&&(identical(other.divisionName, divisionName) || other.divisionName == divisionName)&&(identical(other.cityCorporationName, cityCorporationName) || other.cityCorporationName == cityCorporationName)&&(identical(other.ccZoneName, ccZoneName) || other.ccZoneName == ccZoneName)&&(identical(other.ccWardName, ccWardName) || other.ccWardName == ccWardName)&&(identical(other.ccUid, ccUid) || other.ccUid == ccUid)&&(identical(other.selectedYear, selectedYear) || other.selectedYear == selectedYear)&&(identical(other.additionalData, additionalData) || other.additionalData == additionalData));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,const DeepCollectionEquality().hash(cityCorporations),const DeepCollectionEquality().hash(districts),const DeepCollectionEquality().hash(divisions),area,coverageTableData,chartData,uid,nameList,const DeepCollectionEquality().hash(subblocks),const DeepCollectionEquality().hash(wards),const DeepCollectionEquality().hash(unions),const DeepCollectionEquality().hash(upazilas),subblockId,wardId,unionId,upazilaId,districtId,divisionId,type,subBlockName,wardName,unionName,upazilaName,districtName,divisionName,cityCorporationName,ccZoneName,ccWardName,ccUid,selectedYear,additionalData]);

@override
String toString() {
  return 'EpiCenterDetailsResponse(cityCorporations: $cityCorporations, districts: $districts, divisions: $divisions, area: $area, coverageTableData: $coverageTableData, chartData: $chartData, uid: $uid, nameList: $nameList, subblocks: $subblocks, wards: $wards, unions: $unions, upazilas: $upazilas, subblockId: $subblockId, wardId: $wardId, unionId: $unionId, upazilaId: $upazilaId, districtId: $districtId, divisionId: $divisionId, type: $type, subBlockName: $subBlockName, wardName: $wardName, unionName: $unionName, upazilaName: $upazilaName, districtName: $districtName, divisionName: $divisionName, cityCorporationName: $cityCorporationName, ccZoneName: $ccZoneName, ccWardName: $ccWardName, ccUid: $ccUid, selectedYear: $selectedYear, additionalData: $additionalData)';
}


}

/// @nodoc
abstract mixin class $EpiCenterDetailsResponseCopyWith<$Res>  {
  factory $EpiCenterDetailsResponseCopyWith(EpiCenterDetailsResponse value, $Res Function(EpiCenterDetailsResponse) _then) = _$EpiCenterDetailsResponseCopyWithImpl;
@useResult
$Res call({
 List<CityCorporation> cityCorporations, List<District> districts, List<Division> divisions, Area? area, CoverageTableData? coverageTableData, ChartData? chartData, String? uid, String? nameList, List<Subblock> subblocks, List<Ward> wards, List<Union> unions, List<Upazila> upazilas, String? subblockId, String? wardId, String? unionId, String? upazilaId, String? districtId, String? divisionId, String? type, String? subBlockName, String? wardName, String? unionName, String? upazilaName, String? districtName, String? divisionName, String? cityCorporationName, String? ccZoneName, String? ccWardName, String? ccUid, int? selectedYear, AdditionalData? additionalData
});


$AreaCopyWith<$Res>? get area;$CoverageTableDataCopyWith<$Res>? get coverageTableData;$ChartDataCopyWith<$Res>? get chartData;$AdditionalDataCopyWith<$Res>? get additionalData;

}
/// @nodoc
class _$EpiCenterDetailsResponseCopyWithImpl<$Res>
    implements $EpiCenterDetailsResponseCopyWith<$Res> {
  _$EpiCenterDetailsResponseCopyWithImpl(this._self, this._then);

  final EpiCenterDetailsResponse _self;
  final $Res Function(EpiCenterDetailsResponse) _then;

/// Create a copy of EpiCenterDetailsResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? cityCorporations = null,Object? districts = null,Object? divisions = null,Object? area = freezed,Object? coverageTableData = freezed,Object? chartData = freezed,Object? uid = freezed,Object? nameList = freezed,Object? subblocks = null,Object? wards = null,Object? unions = null,Object? upazilas = null,Object? subblockId = freezed,Object? wardId = freezed,Object? unionId = freezed,Object? upazilaId = freezed,Object? districtId = freezed,Object? divisionId = freezed,Object? type = freezed,Object? subBlockName = freezed,Object? wardName = freezed,Object? unionName = freezed,Object? upazilaName = freezed,Object? districtName = freezed,Object? divisionName = freezed,Object? cityCorporationName = freezed,Object? ccZoneName = freezed,Object? ccWardName = freezed,Object? ccUid = freezed,Object? selectedYear = freezed,Object? additionalData = freezed,}) {
  return _then(_self.copyWith(
cityCorporations: null == cityCorporations ? _self.cityCorporations : cityCorporations // ignore: cast_nullable_to_non_nullable
as List<CityCorporation>,districts: null == districts ? _self.districts : districts // ignore: cast_nullable_to_non_nullable
as List<District>,divisions: null == divisions ? _self.divisions : divisions // ignore: cast_nullable_to_non_nullable
as List<Division>,area: freezed == area ? _self.area : area // ignore: cast_nullable_to_non_nullable
as Area?,coverageTableData: freezed == coverageTableData ? _self.coverageTableData : coverageTableData // ignore: cast_nullable_to_non_nullable
as CoverageTableData?,chartData: freezed == chartData ? _self.chartData : chartData // ignore: cast_nullable_to_non_nullable
as ChartData?,uid: freezed == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String?,nameList: freezed == nameList ? _self.nameList : nameList // ignore: cast_nullable_to_non_nullable
as String?,subblocks: null == subblocks ? _self.subblocks : subblocks // ignore: cast_nullable_to_non_nullable
as List<Subblock>,wards: null == wards ? _self.wards : wards // ignore: cast_nullable_to_non_nullable
as List<Ward>,unions: null == unions ? _self.unions : unions // ignore: cast_nullable_to_non_nullable
as List<Union>,upazilas: null == upazilas ? _self.upazilas : upazilas // ignore: cast_nullable_to_non_nullable
as List<Upazila>,subblockId: freezed == subblockId ? _self.subblockId : subblockId // ignore: cast_nullable_to_non_nullable
as String?,wardId: freezed == wardId ? _self.wardId : wardId // ignore: cast_nullable_to_non_nullable
as String?,unionId: freezed == unionId ? _self.unionId : unionId // ignore: cast_nullable_to_non_nullable
as String?,upazilaId: freezed == upazilaId ? _self.upazilaId : upazilaId // ignore: cast_nullable_to_non_nullable
as String?,districtId: freezed == districtId ? _self.districtId : districtId // ignore: cast_nullable_to_non_nullable
as String?,divisionId: freezed == divisionId ? _self.divisionId : divisionId // ignore: cast_nullable_to_non_nullable
as String?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,subBlockName: freezed == subBlockName ? _self.subBlockName : subBlockName // ignore: cast_nullable_to_non_nullable
as String?,wardName: freezed == wardName ? _self.wardName : wardName // ignore: cast_nullable_to_non_nullable
as String?,unionName: freezed == unionName ? _self.unionName : unionName // ignore: cast_nullable_to_non_nullable
as String?,upazilaName: freezed == upazilaName ? _self.upazilaName : upazilaName // ignore: cast_nullable_to_non_nullable
as String?,districtName: freezed == districtName ? _self.districtName : districtName // ignore: cast_nullable_to_non_nullable
as String?,divisionName: freezed == divisionName ? _self.divisionName : divisionName // ignore: cast_nullable_to_non_nullable
as String?,cityCorporationName: freezed == cityCorporationName ? _self.cityCorporationName : cityCorporationName // ignore: cast_nullable_to_non_nullable
as String?,ccZoneName: freezed == ccZoneName ? _self.ccZoneName : ccZoneName // ignore: cast_nullable_to_non_nullable
as String?,ccWardName: freezed == ccWardName ? _self.ccWardName : ccWardName // ignore: cast_nullable_to_non_nullable
as String?,ccUid: freezed == ccUid ? _self.ccUid : ccUid // ignore: cast_nullable_to_non_nullable
as String?,selectedYear: freezed == selectedYear ? _self.selectedYear : selectedYear // ignore: cast_nullable_to_non_nullable
as int?,additionalData: freezed == additionalData ? _self.additionalData : additionalData // ignore: cast_nullable_to_non_nullable
as AdditionalData?,
  ));
}
/// Create a copy of EpiCenterDetailsResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AreaCopyWith<$Res>? get area {
    if (_self.area == null) {
    return null;
  }

  return $AreaCopyWith<$Res>(_self.area!, (value) {
    return _then(_self.copyWith(area: value));
  });
}/// Create a copy of EpiCenterDetailsResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CoverageTableDataCopyWith<$Res>? get coverageTableData {
    if (_self.coverageTableData == null) {
    return null;
  }

  return $CoverageTableDataCopyWith<$Res>(_self.coverageTableData!, (value) {
    return _then(_self.copyWith(coverageTableData: value));
  });
}/// Create a copy of EpiCenterDetailsResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ChartDataCopyWith<$Res>? get chartData {
    if (_self.chartData == null) {
    return null;
  }

  return $ChartDataCopyWith<$Res>(_self.chartData!, (value) {
    return _then(_self.copyWith(chartData: value));
  });
}/// Create a copy of EpiCenterDetailsResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AdditionalDataCopyWith<$Res>? get additionalData {
    if (_self.additionalData == null) {
    return null;
  }

  return $AdditionalDataCopyWith<$Res>(_self.additionalData!, (value) {
    return _then(_self.copyWith(additionalData: value));
  });
}
}


/// Adds pattern-matching-related methods to [EpiCenterDetailsResponse].
extension EpiCenterDetailsResponsePatterns on EpiCenterDetailsResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EpiCenterDetailsResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EpiCenterDetailsResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EpiCenterDetailsResponse value)  $default,){
final _that = this;
switch (_that) {
case _EpiCenterDetailsResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EpiCenterDetailsResponse value)?  $default,){
final _that = this;
switch (_that) {
case _EpiCenterDetailsResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<CityCorporation> cityCorporations,  List<District> districts,  List<Division> divisions,  Area? area,  CoverageTableData? coverageTableData,  ChartData? chartData,  String? uid,  String? nameList,  List<Subblock> subblocks,  List<Ward> wards,  List<Union> unions,  List<Upazila> upazilas,  String? subblockId,  String? wardId,  String? unionId,  String? upazilaId,  String? districtId,  String? divisionId,  String? type,  String? subBlockName,  String? wardName,  String? unionName,  String? upazilaName,  String? districtName,  String? divisionName,  String? cityCorporationName,  String? ccZoneName,  String? ccWardName,  String? ccUid,  int? selectedYear,  AdditionalData? additionalData)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EpiCenterDetailsResponse() when $default != null:
return $default(_that.cityCorporations,_that.districts,_that.divisions,_that.area,_that.coverageTableData,_that.chartData,_that.uid,_that.nameList,_that.subblocks,_that.wards,_that.unions,_that.upazilas,_that.subblockId,_that.wardId,_that.unionId,_that.upazilaId,_that.districtId,_that.divisionId,_that.type,_that.subBlockName,_that.wardName,_that.unionName,_that.upazilaName,_that.districtName,_that.divisionName,_that.cityCorporationName,_that.ccZoneName,_that.ccWardName,_that.ccUid,_that.selectedYear,_that.additionalData);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<CityCorporation> cityCorporations,  List<District> districts,  List<Division> divisions,  Area? area,  CoverageTableData? coverageTableData,  ChartData? chartData,  String? uid,  String? nameList,  List<Subblock> subblocks,  List<Ward> wards,  List<Union> unions,  List<Upazila> upazilas,  String? subblockId,  String? wardId,  String? unionId,  String? upazilaId,  String? districtId,  String? divisionId,  String? type,  String? subBlockName,  String? wardName,  String? unionName,  String? upazilaName,  String? districtName,  String? divisionName,  String? cityCorporationName,  String? ccZoneName,  String? ccWardName,  String? ccUid,  int? selectedYear,  AdditionalData? additionalData)  $default,) {final _that = this;
switch (_that) {
case _EpiCenterDetailsResponse():
return $default(_that.cityCorporations,_that.districts,_that.divisions,_that.area,_that.coverageTableData,_that.chartData,_that.uid,_that.nameList,_that.subblocks,_that.wards,_that.unions,_that.upazilas,_that.subblockId,_that.wardId,_that.unionId,_that.upazilaId,_that.districtId,_that.divisionId,_that.type,_that.subBlockName,_that.wardName,_that.unionName,_that.upazilaName,_that.districtName,_that.divisionName,_that.cityCorporationName,_that.ccZoneName,_that.ccWardName,_that.ccUid,_that.selectedYear,_that.additionalData);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<CityCorporation> cityCorporations,  List<District> districts,  List<Division> divisions,  Area? area,  CoverageTableData? coverageTableData,  ChartData? chartData,  String? uid,  String? nameList,  List<Subblock> subblocks,  List<Ward> wards,  List<Union> unions,  List<Upazila> upazilas,  String? subblockId,  String? wardId,  String? unionId,  String? upazilaId,  String? districtId,  String? divisionId,  String? type,  String? subBlockName,  String? wardName,  String? unionName,  String? upazilaName,  String? districtName,  String? divisionName,  String? cityCorporationName,  String? ccZoneName,  String? ccWardName,  String? ccUid,  int? selectedYear,  AdditionalData? additionalData)?  $default,) {final _that = this;
switch (_that) {
case _EpiCenterDetailsResponse() when $default != null:
return $default(_that.cityCorporations,_that.districts,_that.divisions,_that.area,_that.coverageTableData,_that.chartData,_that.uid,_that.nameList,_that.subblocks,_that.wards,_that.unions,_that.upazilas,_that.subblockId,_that.wardId,_that.unionId,_that.upazilaId,_that.districtId,_that.divisionId,_that.type,_that.subBlockName,_that.wardName,_that.unionName,_that.upazilaName,_that.districtName,_that.divisionName,_that.cityCorporationName,_that.ccZoneName,_that.ccWardName,_that.ccUid,_that.selectedYear,_that.additionalData);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EpiCenterDetailsResponse extends EpiCenterDetailsResponse {
  const _EpiCenterDetailsResponse({final  List<CityCorporation> cityCorporations = const [], final  List<District> districts = const [], final  List<Division> divisions = const [], this.area, this.coverageTableData, this.chartData, this.uid, this.nameList, final  List<Subblock> subblocks = const [], final  List<Ward> wards = const [], final  List<Union> unions = const [], final  List<Upazila> upazilas = const [], this.subblockId, this.wardId, this.unionId, this.upazilaId, this.districtId, this.divisionId, this.type, this.subBlockName, this.wardName, this.unionName, this.upazilaName, this.districtName, this.divisionName, this.cityCorporationName, this.ccZoneName, this.ccWardName, this.ccUid, this.selectedYear, this.additionalData}): _cityCorporations = cityCorporations,_districts = districts,_divisions = divisions,_subblocks = subblocks,_wards = wards,_unions = unions,_upazilas = upazilas,super._();
  factory _EpiCenterDetailsResponse.fromJson(Map<String, dynamic> json) => _$EpiCenterDetailsResponseFromJson(json);

 final  List<CityCorporation> _cityCorporations;
@override@JsonKey() List<CityCorporation> get cityCorporations {
  if (_cityCorporations is EqualUnmodifiableListView) return _cityCorporations;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_cityCorporations);
}

 final  List<District> _districts;
@override@JsonKey() List<District> get districts {
  if (_districts is EqualUnmodifiableListView) return _districts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_districts);
}

 final  List<Division> _divisions;
@override@JsonKey() List<Division> get divisions {
  if (_divisions is EqualUnmodifiableListView) return _divisions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_divisions);
}

@override final  Area? area;
@override final  CoverageTableData? coverageTableData;
@override final  ChartData? chartData;
@override final  String? uid;
@override final  String? nameList;
 final  List<Subblock> _subblocks;
@override@JsonKey() List<Subblock> get subblocks {
  if (_subblocks is EqualUnmodifiableListView) return _subblocks;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_subblocks);
}

 final  List<Ward> _wards;
@override@JsonKey() List<Ward> get wards {
  if (_wards is EqualUnmodifiableListView) return _wards;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_wards);
}

 final  List<Union> _unions;
@override@JsonKey() List<Union> get unions {
  if (_unions is EqualUnmodifiableListView) return _unions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_unions);
}

 final  List<Upazila> _upazilas;
@override@JsonKey() List<Upazila> get upazilas {
  if (_upazilas is EqualUnmodifiableListView) return _upazilas;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_upazilas);
}

@override final  String? subblockId;
@override final  String? wardId;
@override final  String? unionId;
@override final  String? upazilaId;
@override final  String? districtId;
@override final  String? divisionId;
@override final  String? type;
@override final  String? subBlockName;
@override final  String? wardName;
@override final  String? unionName;
@override final  String? upazilaName;
@override final  String? districtName;
@override final  String? divisionName;
@override final  String? cityCorporationName;
@override final  String? ccZoneName;
@override final  String? ccWardName;
@override final  String? ccUid;
@override final  int? selectedYear;
// ✅ NEW: Root-level additionalData for country-level responses
@override final  AdditionalData? additionalData;

/// Create a copy of EpiCenterDetailsResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EpiCenterDetailsResponseCopyWith<_EpiCenterDetailsResponse> get copyWith => __$EpiCenterDetailsResponseCopyWithImpl<_EpiCenterDetailsResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EpiCenterDetailsResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EpiCenterDetailsResponse&&const DeepCollectionEquality().equals(other._cityCorporations, _cityCorporations)&&const DeepCollectionEquality().equals(other._districts, _districts)&&const DeepCollectionEquality().equals(other._divisions, _divisions)&&(identical(other.area, area) || other.area == area)&&(identical(other.coverageTableData, coverageTableData) || other.coverageTableData == coverageTableData)&&(identical(other.chartData, chartData) || other.chartData == chartData)&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.nameList, nameList) || other.nameList == nameList)&&const DeepCollectionEquality().equals(other._subblocks, _subblocks)&&const DeepCollectionEquality().equals(other._wards, _wards)&&const DeepCollectionEquality().equals(other._unions, _unions)&&const DeepCollectionEquality().equals(other._upazilas, _upazilas)&&(identical(other.subblockId, subblockId) || other.subblockId == subblockId)&&(identical(other.wardId, wardId) || other.wardId == wardId)&&(identical(other.unionId, unionId) || other.unionId == unionId)&&(identical(other.upazilaId, upazilaId) || other.upazilaId == upazilaId)&&(identical(other.districtId, districtId) || other.districtId == districtId)&&(identical(other.divisionId, divisionId) || other.divisionId == divisionId)&&(identical(other.type, type) || other.type == type)&&(identical(other.subBlockName, subBlockName) || other.subBlockName == subBlockName)&&(identical(other.wardName, wardName) || other.wardName == wardName)&&(identical(other.unionName, unionName) || other.unionName == unionName)&&(identical(other.upazilaName, upazilaName) || other.upazilaName == upazilaName)&&(identical(other.districtName, districtName) || other.districtName == districtName)&&(identical(other.divisionName, divisionName) || other.divisionName == divisionName)&&(identical(other.cityCorporationName, cityCorporationName) || other.cityCorporationName == cityCorporationName)&&(identical(other.ccZoneName, ccZoneName) || other.ccZoneName == ccZoneName)&&(identical(other.ccWardName, ccWardName) || other.ccWardName == ccWardName)&&(identical(other.ccUid, ccUid) || other.ccUid == ccUid)&&(identical(other.selectedYear, selectedYear) || other.selectedYear == selectedYear)&&(identical(other.additionalData, additionalData) || other.additionalData == additionalData));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,const DeepCollectionEquality().hash(_cityCorporations),const DeepCollectionEquality().hash(_districts),const DeepCollectionEquality().hash(_divisions),area,coverageTableData,chartData,uid,nameList,const DeepCollectionEquality().hash(_subblocks),const DeepCollectionEquality().hash(_wards),const DeepCollectionEquality().hash(_unions),const DeepCollectionEquality().hash(_upazilas),subblockId,wardId,unionId,upazilaId,districtId,divisionId,type,subBlockName,wardName,unionName,upazilaName,districtName,divisionName,cityCorporationName,ccZoneName,ccWardName,ccUid,selectedYear,additionalData]);

@override
String toString() {
  return 'EpiCenterDetailsResponse(cityCorporations: $cityCorporations, districts: $districts, divisions: $divisions, area: $area, coverageTableData: $coverageTableData, chartData: $chartData, uid: $uid, nameList: $nameList, subblocks: $subblocks, wards: $wards, unions: $unions, upazilas: $upazilas, subblockId: $subblockId, wardId: $wardId, unionId: $unionId, upazilaId: $upazilaId, districtId: $districtId, divisionId: $divisionId, type: $type, subBlockName: $subBlockName, wardName: $wardName, unionName: $unionName, upazilaName: $upazilaName, districtName: $districtName, divisionName: $divisionName, cityCorporationName: $cityCorporationName, ccZoneName: $ccZoneName, ccWardName: $ccWardName, ccUid: $ccUid, selectedYear: $selectedYear, additionalData: $additionalData)';
}


}

/// @nodoc
abstract mixin class _$EpiCenterDetailsResponseCopyWith<$Res> implements $EpiCenterDetailsResponseCopyWith<$Res> {
  factory _$EpiCenterDetailsResponseCopyWith(_EpiCenterDetailsResponse value, $Res Function(_EpiCenterDetailsResponse) _then) = __$EpiCenterDetailsResponseCopyWithImpl;
@override @useResult
$Res call({
 List<CityCorporation> cityCorporations, List<District> districts, List<Division> divisions, Area? area, CoverageTableData? coverageTableData, ChartData? chartData, String? uid, String? nameList, List<Subblock> subblocks, List<Ward> wards, List<Union> unions, List<Upazila> upazilas, String? subblockId, String? wardId, String? unionId, String? upazilaId, String? districtId, String? divisionId, String? type, String? subBlockName, String? wardName, String? unionName, String? upazilaName, String? districtName, String? divisionName, String? cityCorporationName, String? ccZoneName, String? ccWardName, String? ccUid, int? selectedYear, AdditionalData? additionalData
});


@override $AreaCopyWith<$Res>? get area;@override $CoverageTableDataCopyWith<$Res>? get coverageTableData;@override $ChartDataCopyWith<$Res>? get chartData;@override $AdditionalDataCopyWith<$Res>? get additionalData;

}
/// @nodoc
class __$EpiCenterDetailsResponseCopyWithImpl<$Res>
    implements _$EpiCenterDetailsResponseCopyWith<$Res> {
  __$EpiCenterDetailsResponseCopyWithImpl(this._self, this._then);

  final _EpiCenterDetailsResponse _self;
  final $Res Function(_EpiCenterDetailsResponse) _then;

/// Create a copy of EpiCenterDetailsResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? cityCorporations = null,Object? districts = null,Object? divisions = null,Object? area = freezed,Object? coverageTableData = freezed,Object? chartData = freezed,Object? uid = freezed,Object? nameList = freezed,Object? subblocks = null,Object? wards = null,Object? unions = null,Object? upazilas = null,Object? subblockId = freezed,Object? wardId = freezed,Object? unionId = freezed,Object? upazilaId = freezed,Object? districtId = freezed,Object? divisionId = freezed,Object? type = freezed,Object? subBlockName = freezed,Object? wardName = freezed,Object? unionName = freezed,Object? upazilaName = freezed,Object? districtName = freezed,Object? divisionName = freezed,Object? cityCorporationName = freezed,Object? ccZoneName = freezed,Object? ccWardName = freezed,Object? ccUid = freezed,Object? selectedYear = freezed,Object? additionalData = freezed,}) {
  return _then(_EpiCenterDetailsResponse(
cityCorporations: null == cityCorporations ? _self._cityCorporations : cityCorporations // ignore: cast_nullable_to_non_nullable
as List<CityCorporation>,districts: null == districts ? _self._districts : districts // ignore: cast_nullable_to_non_nullable
as List<District>,divisions: null == divisions ? _self._divisions : divisions // ignore: cast_nullable_to_non_nullable
as List<Division>,area: freezed == area ? _self.area : area // ignore: cast_nullable_to_non_nullable
as Area?,coverageTableData: freezed == coverageTableData ? _self.coverageTableData : coverageTableData // ignore: cast_nullable_to_non_nullable
as CoverageTableData?,chartData: freezed == chartData ? _self.chartData : chartData // ignore: cast_nullable_to_non_nullable
as ChartData?,uid: freezed == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String?,nameList: freezed == nameList ? _self.nameList : nameList // ignore: cast_nullable_to_non_nullable
as String?,subblocks: null == subblocks ? _self._subblocks : subblocks // ignore: cast_nullable_to_non_nullable
as List<Subblock>,wards: null == wards ? _self._wards : wards // ignore: cast_nullable_to_non_nullable
as List<Ward>,unions: null == unions ? _self._unions : unions // ignore: cast_nullable_to_non_nullable
as List<Union>,upazilas: null == upazilas ? _self._upazilas : upazilas // ignore: cast_nullable_to_non_nullable
as List<Upazila>,subblockId: freezed == subblockId ? _self.subblockId : subblockId // ignore: cast_nullable_to_non_nullable
as String?,wardId: freezed == wardId ? _self.wardId : wardId // ignore: cast_nullable_to_non_nullable
as String?,unionId: freezed == unionId ? _self.unionId : unionId // ignore: cast_nullable_to_non_nullable
as String?,upazilaId: freezed == upazilaId ? _self.upazilaId : upazilaId // ignore: cast_nullable_to_non_nullable
as String?,districtId: freezed == districtId ? _self.districtId : districtId // ignore: cast_nullable_to_non_nullable
as String?,divisionId: freezed == divisionId ? _self.divisionId : divisionId // ignore: cast_nullable_to_non_nullable
as String?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,subBlockName: freezed == subBlockName ? _self.subBlockName : subBlockName // ignore: cast_nullable_to_non_nullable
as String?,wardName: freezed == wardName ? _self.wardName : wardName // ignore: cast_nullable_to_non_nullable
as String?,unionName: freezed == unionName ? _self.unionName : unionName // ignore: cast_nullable_to_non_nullable
as String?,upazilaName: freezed == upazilaName ? _self.upazilaName : upazilaName // ignore: cast_nullable_to_non_nullable
as String?,districtName: freezed == districtName ? _self.districtName : districtName // ignore: cast_nullable_to_non_nullable
as String?,divisionName: freezed == divisionName ? _self.divisionName : divisionName // ignore: cast_nullable_to_non_nullable
as String?,cityCorporationName: freezed == cityCorporationName ? _self.cityCorporationName : cityCorporationName // ignore: cast_nullable_to_non_nullable
as String?,ccZoneName: freezed == ccZoneName ? _self.ccZoneName : ccZoneName // ignore: cast_nullable_to_non_nullable
as String?,ccWardName: freezed == ccWardName ? _self.ccWardName : ccWardName // ignore: cast_nullable_to_non_nullable
as String?,ccUid: freezed == ccUid ? _self.ccUid : ccUid // ignore: cast_nullable_to_non_nullable
as String?,selectedYear: freezed == selectedYear ? _self.selectedYear : selectedYear // ignore: cast_nullable_to_non_nullable
as int?,additionalData: freezed == additionalData ? _self.additionalData : additionalData // ignore: cast_nullable_to_non_nullable
as AdditionalData?,
  ));
}

/// Create a copy of EpiCenterDetailsResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AreaCopyWith<$Res>? get area {
    if (_self.area == null) {
    return null;
  }

  return $AreaCopyWith<$Res>(_self.area!, (value) {
    return _then(_self.copyWith(area: value));
  });
}/// Create a copy of EpiCenterDetailsResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CoverageTableDataCopyWith<$Res>? get coverageTableData {
    if (_self.coverageTableData == null) {
    return null;
  }

  return $CoverageTableDataCopyWith<$Res>(_self.coverageTableData!, (value) {
    return _then(_self.copyWith(coverageTableData: value));
  });
}/// Create a copy of EpiCenterDetailsResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ChartDataCopyWith<$Res>? get chartData {
    if (_self.chartData == null) {
    return null;
  }

  return $ChartDataCopyWith<$Res>(_self.chartData!, (value) {
    return _then(_self.copyWith(chartData: value));
  });
}/// Create a copy of EpiCenterDetailsResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AdditionalDataCopyWith<$Res>? get additionalData {
    if (_self.additionalData == null) {
    return null;
  }

  return $AdditionalDataCopyWith<$Res>(_self.additionalData!, (value) {
    return _then(_self.copyWith(additionalData: value));
  });
}
}


/// @nodoc
mixin _$CityCorporation {

 String? get uid; String? get name; List<CCChild> get children;
/// Create a copy of CityCorporation
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CityCorporationCopyWith<CityCorporation> get copyWith => _$CityCorporationCopyWithImpl<CityCorporation>(this as CityCorporation, _$identity);

  /// Serializes this CityCorporation to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CityCorporation&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other.children, children));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,uid,name,const DeepCollectionEquality().hash(children));

@override
String toString() {
  return 'CityCorporation(uid: $uid, name: $name, children: $children)';
}


}

/// @nodoc
abstract mixin class $CityCorporationCopyWith<$Res>  {
  factory $CityCorporationCopyWith(CityCorporation value, $Res Function(CityCorporation) _then) = _$CityCorporationCopyWithImpl;
@useResult
$Res call({
 String? uid, String? name, List<CCChild> children
});




}
/// @nodoc
class _$CityCorporationCopyWithImpl<$Res>
    implements $CityCorporationCopyWith<$Res> {
  _$CityCorporationCopyWithImpl(this._self, this._then);

  final CityCorporation _self;
  final $Res Function(CityCorporation) _then;

/// Create a copy of CityCorporation
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? uid = freezed,Object? name = freezed,Object? children = null,}) {
  return _then(_self.copyWith(
uid: freezed == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,children: null == children ? _self.children : children // ignore: cast_nullable_to_non_nullable
as List<CCChild>,
  ));
}

}


/// Adds pattern-matching-related methods to [CityCorporation].
extension CityCorporationPatterns on CityCorporation {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CityCorporation value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CityCorporation() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CityCorporation value)  $default,){
final _that = this;
switch (_that) {
case _CityCorporation():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CityCorporation value)?  $default,){
final _that = this;
switch (_that) {
case _CityCorporation() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? uid,  String? name,  List<CCChild> children)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CityCorporation() when $default != null:
return $default(_that.uid,_that.name,_that.children);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? uid,  String? name,  List<CCChild> children)  $default,) {final _that = this;
switch (_that) {
case _CityCorporation():
return $default(_that.uid,_that.name,_that.children);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? uid,  String? name,  List<CCChild> children)?  $default,) {final _that = this;
switch (_that) {
case _CityCorporation() when $default != null:
return $default(_that.uid,_that.name,_that.children);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CityCorporation implements CityCorporation {
  const _CityCorporation({this.uid, this.name, final  List<CCChild> children = const []}): _children = children;
  factory _CityCorporation.fromJson(Map<String, dynamic> json) => _$CityCorporationFromJson(json);

@override final  String? uid;
@override final  String? name;
 final  List<CCChild> _children;
@override@JsonKey() List<CCChild> get children {
  if (_children is EqualUnmodifiableListView) return _children;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_children);
}


/// Create a copy of CityCorporation
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CityCorporationCopyWith<_CityCorporation> get copyWith => __$CityCorporationCopyWithImpl<_CityCorporation>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CityCorporationToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CityCorporation&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other._children, _children));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,uid,name,const DeepCollectionEquality().hash(_children));

@override
String toString() {
  return 'CityCorporation(uid: $uid, name: $name, children: $children)';
}


}

/// @nodoc
abstract mixin class _$CityCorporationCopyWith<$Res> implements $CityCorporationCopyWith<$Res> {
  factory _$CityCorporationCopyWith(_CityCorporation value, $Res Function(_CityCorporation) _then) = __$CityCorporationCopyWithImpl;
@override @useResult
$Res call({
 String? uid, String? name, List<CCChild> children
});




}
/// @nodoc
class __$CityCorporationCopyWithImpl<$Res>
    implements _$CityCorporationCopyWith<$Res> {
  __$CityCorporationCopyWithImpl(this._self, this._then);

  final _CityCorporation _self;
  final $Res Function(_CityCorporation) _then;

/// Create a copy of CityCorporation
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? uid = freezed,Object? name = freezed,Object? children = null,}) {
  return _then(_CityCorporation(
uid: freezed == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,children: null == children ? _self._children : children // ignore: cast_nullable_to_non_nullable
as List<CCChild>,
  ));
}


}


/// @nodoc
mixin _$CCChild {

 String? get uid; String? get name;@JsonKey(name: 'parent_uid') String? get parentUid; String? get type; List<CCChild> get children;
/// Create a copy of CCChild
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CCChildCopyWith<CCChild> get copyWith => _$CCChildCopyWithImpl<CCChild>(this as CCChild, _$identity);

  /// Serializes this CCChild to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CCChild&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.name, name) || other.name == name)&&(identical(other.parentUid, parentUid) || other.parentUid == parentUid)&&(identical(other.type, type) || other.type == type)&&const DeepCollectionEquality().equals(other.children, children));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,uid,name,parentUid,type,const DeepCollectionEquality().hash(children));

@override
String toString() {
  return 'CCChild(uid: $uid, name: $name, parentUid: $parentUid, type: $type, children: $children)';
}


}

/// @nodoc
abstract mixin class $CCChildCopyWith<$Res>  {
  factory $CCChildCopyWith(CCChild value, $Res Function(CCChild) _then) = _$CCChildCopyWithImpl;
@useResult
$Res call({
 String? uid, String? name,@JsonKey(name: 'parent_uid') String? parentUid, String? type, List<CCChild> children
});




}
/// @nodoc
class _$CCChildCopyWithImpl<$Res>
    implements $CCChildCopyWith<$Res> {
  _$CCChildCopyWithImpl(this._self, this._then);

  final CCChild _self;
  final $Res Function(CCChild) _then;

/// Create a copy of CCChild
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? uid = freezed,Object? name = freezed,Object? parentUid = freezed,Object? type = freezed,Object? children = null,}) {
  return _then(_self.copyWith(
uid: freezed == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,parentUid: freezed == parentUid ? _self.parentUid : parentUid // ignore: cast_nullable_to_non_nullable
as String?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,children: null == children ? _self.children : children // ignore: cast_nullable_to_non_nullable
as List<CCChild>,
  ));
}

}


/// Adds pattern-matching-related methods to [CCChild].
extension CCChildPatterns on CCChild {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CCChild value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CCChild() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CCChild value)  $default,){
final _that = this;
switch (_that) {
case _CCChild():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CCChild value)?  $default,){
final _that = this;
switch (_that) {
case _CCChild() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? uid,  String? name, @JsonKey(name: 'parent_uid')  String? parentUid,  String? type,  List<CCChild> children)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CCChild() when $default != null:
return $default(_that.uid,_that.name,_that.parentUid,_that.type,_that.children);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? uid,  String? name, @JsonKey(name: 'parent_uid')  String? parentUid,  String? type,  List<CCChild> children)  $default,) {final _that = this;
switch (_that) {
case _CCChild():
return $default(_that.uid,_that.name,_that.parentUid,_that.type,_that.children);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? uid,  String? name, @JsonKey(name: 'parent_uid')  String? parentUid,  String? type,  List<CCChild> children)?  $default,) {final _that = this;
switch (_that) {
case _CCChild() when $default != null:
return $default(_that.uid,_that.name,_that.parentUid,_that.type,_that.children);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CCChild implements CCChild {
  const _CCChild({this.uid, this.name, @JsonKey(name: 'parent_uid') this.parentUid, this.type, final  List<CCChild> children = const []}): _children = children;
  factory _CCChild.fromJson(Map<String, dynamic> json) => _$CCChildFromJson(json);

@override final  String? uid;
@override final  String? name;
@override@JsonKey(name: 'parent_uid') final  String? parentUid;
@override final  String? type;
 final  List<CCChild> _children;
@override@JsonKey() List<CCChild> get children {
  if (_children is EqualUnmodifiableListView) return _children;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_children);
}


/// Create a copy of CCChild
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CCChildCopyWith<_CCChild> get copyWith => __$CCChildCopyWithImpl<_CCChild>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CCChildToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CCChild&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.name, name) || other.name == name)&&(identical(other.parentUid, parentUid) || other.parentUid == parentUid)&&(identical(other.type, type) || other.type == type)&&const DeepCollectionEquality().equals(other._children, _children));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,uid,name,parentUid,type,const DeepCollectionEquality().hash(_children));

@override
String toString() {
  return 'CCChild(uid: $uid, name: $name, parentUid: $parentUid, type: $type, children: $children)';
}


}

/// @nodoc
abstract mixin class _$CCChildCopyWith<$Res> implements $CCChildCopyWith<$Res> {
  factory _$CCChildCopyWith(_CCChild value, $Res Function(_CCChild) _then) = __$CCChildCopyWithImpl;
@override @useResult
$Res call({
 String? uid, String? name,@JsonKey(name: 'parent_uid') String? parentUid, String? type, List<CCChild> children
});




}
/// @nodoc
class __$CCChildCopyWithImpl<$Res>
    implements _$CCChildCopyWith<$Res> {
  __$CCChildCopyWithImpl(this._self, this._then);

  final _CCChild _self;
  final $Res Function(_CCChild) _then;

/// Create a copy of CCChild
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? uid = freezed,Object? name = freezed,Object? parentUid = freezed,Object? type = freezed,Object? children = null,}) {
  return _then(_CCChild(
uid: freezed == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,parentUid: freezed == parentUid ? _self.parentUid : parentUid // ignore: cast_nullable_to_non_nullable
as String?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,children: null == children ? _self._children : children // ignore: cast_nullable_to_non_nullable
as List<CCChild>,
  ));
}


}


/// @nodoc
mixin _$District {

 String? get uid; String? get name;
/// Create a copy of District
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DistrictCopyWith<District> get copyWith => _$DistrictCopyWithImpl<District>(this as District, _$identity);

  /// Serializes this District to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is District&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,uid,name);

@override
String toString() {
  return 'District(uid: $uid, name: $name)';
}


}

/// @nodoc
abstract mixin class $DistrictCopyWith<$Res>  {
  factory $DistrictCopyWith(District value, $Res Function(District) _then) = _$DistrictCopyWithImpl;
@useResult
$Res call({
 String? uid, String? name
});




}
/// @nodoc
class _$DistrictCopyWithImpl<$Res>
    implements $DistrictCopyWith<$Res> {
  _$DistrictCopyWithImpl(this._self, this._then);

  final District _self;
  final $Res Function(District) _then;

/// Create a copy of District
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? uid = freezed,Object? name = freezed,}) {
  return _then(_self.copyWith(
uid: freezed == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [District].
extension DistrictPatterns on District {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _District value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _District() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _District value)  $default,){
final _that = this;
switch (_that) {
case _District():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _District value)?  $default,){
final _that = this;
switch (_that) {
case _District() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? uid,  String? name)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _District() when $default != null:
return $default(_that.uid,_that.name);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? uid,  String? name)  $default,) {final _that = this;
switch (_that) {
case _District():
return $default(_that.uid,_that.name);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? uid,  String? name)?  $default,) {final _that = this;
switch (_that) {
case _District() when $default != null:
return $default(_that.uid,_that.name);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _District implements District {
  const _District({this.uid, this.name});
  factory _District.fromJson(Map<String, dynamic> json) => _$DistrictFromJson(json);

@override final  String? uid;
@override final  String? name;

/// Create a copy of District
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DistrictCopyWith<_District> get copyWith => __$DistrictCopyWithImpl<_District>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DistrictToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _District&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,uid,name);

@override
String toString() {
  return 'District(uid: $uid, name: $name)';
}


}

/// @nodoc
abstract mixin class _$DistrictCopyWith<$Res> implements $DistrictCopyWith<$Res> {
  factory _$DistrictCopyWith(_District value, $Res Function(_District) _then) = __$DistrictCopyWithImpl;
@override @useResult
$Res call({
 String? uid, String? name
});




}
/// @nodoc
class __$DistrictCopyWithImpl<$Res>
    implements _$DistrictCopyWith<$Res> {
  __$DistrictCopyWithImpl(this._self, this._then);

  final _District _self;
  final $Res Function(_District) _then;

/// Create a copy of District
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? uid = freezed,Object? name = freezed,}) {
  return _then(_District(
uid: freezed == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$Division {

 String? get uid; String? get name;
/// Create a copy of Division
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DivisionCopyWith<Division> get copyWith => _$DivisionCopyWithImpl<Division>(this as Division, _$identity);

  /// Serializes this Division to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Division&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,uid,name);

@override
String toString() {
  return 'Division(uid: $uid, name: $name)';
}


}

/// @nodoc
abstract mixin class $DivisionCopyWith<$Res>  {
  factory $DivisionCopyWith(Division value, $Res Function(Division) _then) = _$DivisionCopyWithImpl;
@useResult
$Res call({
 String? uid, String? name
});




}
/// @nodoc
class _$DivisionCopyWithImpl<$Res>
    implements $DivisionCopyWith<$Res> {
  _$DivisionCopyWithImpl(this._self, this._then);

  final Division _self;
  final $Res Function(Division) _then;

/// Create a copy of Division
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? uid = freezed,Object? name = freezed,}) {
  return _then(_self.copyWith(
uid: freezed == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Division].
extension DivisionPatterns on Division {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Division value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Division() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Division value)  $default,){
final _that = this;
switch (_that) {
case _Division():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Division value)?  $default,){
final _that = this;
switch (_that) {
case _Division() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? uid,  String? name)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Division() when $default != null:
return $default(_that.uid,_that.name);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? uid,  String? name)  $default,) {final _that = this;
switch (_that) {
case _Division():
return $default(_that.uid,_that.name);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? uid,  String? name)?  $default,) {final _that = this;
switch (_that) {
case _Division() when $default != null:
return $default(_that.uid,_that.name);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Division implements Division {
  const _Division({this.uid, this.name});
  factory _Division.fromJson(Map<String, dynamic> json) => _$DivisionFromJson(json);

@override final  String? uid;
@override final  String? name;

/// Create a copy of Division
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DivisionCopyWith<_Division> get copyWith => __$DivisionCopyWithImpl<_Division>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DivisionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Division&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,uid,name);

@override
String toString() {
  return 'Division(uid: $uid, name: $name)';
}


}

/// @nodoc
abstract mixin class _$DivisionCopyWith<$Res> implements $DivisionCopyWith<$Res> {
  factory _$DivisionCopyWith(_Division value, $Res Function(_Division) _then) = __$DivisionCopyWithImpl;
@override @useResult
$Res call({
 String? uid, String? name
});




}
/// @nodoc
class __$DivisionCopyWithImpl<$Res>
    implements _$DivisionCopyWith<$Res> {
  __$DivisionCopyWithImpl(this._self, this._then);

  final _Division _self;
  final $Res Function(_Division) _then;

/// Create a copy of Division
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? uid = freezed,Object? name = freezed,}) {
  return _then(_Division(
uid: freezed == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$Area {

 int? get id; String? get type; String? get uid; String? get name;@JsonKey(name: 'etracker_name') String? get etrackerName;@JsonKey(name: 'geo_name') String? get geoName;@JsonKey(name: 'parent_uid') String? get parentUid;@JsonKey(name: 'json_file_path') String? get jsonFilePath;@JsonKey(name: 'is_bulk_imported') bool? get isBulkImported;@JsonKey(name: 'vaccine_target') VaccineTarget? get vaccineTarget;@JsonKey(name: 'vaccine_coverage') VaccineCoverage? get vaccineCoverage;@JsonKey(name: 'additional_data') AdditionalData? get additionalData;@JsonKey(name: 'epi_uids') dynamic get epiUids; dynamic get remarks;@JsonKey(name: 'build_at') String? get buildAt;@JsonKey(name: 'created_at') String? get createdAt;@JsonKey(name: 'updated_at') String? get updatedAt; String? get status; Parent? get parent;
/// Create a copy of Area
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AreaCopyWith<Area> get copyWith => _$AreaCopyWithImpl<Area>(this as Area, _$identity);

  /// Serializes this Area to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Area&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.name, name) || other.name == name)&&(identical(other.etrackerName, etrackerName) || other.etrackerName == etrackerName)&&(identical(other.geoName, geoName) || other.geoName == geoName)&&(identical(other.parentUid, parentUid) || other.parentUid == parentUid)&&(identical(other.jsonFilePath, jsonFilePath) || other.jsonFilePath == jsonFilePath)&&(identical(other.isBulkImported, isBulkImported) || other.isBulkImported == isBulkImported)&&(identical(other.vaccineTarget, vaccineTarget) || other.vaccineTarget == vaccineTarget)&&(identical(other.vaccineCoverage, vaccineCoverage) || other.vaccineCoverage == vaccineCoverage)&&(identical(other.additionalData, additionalData) || other.additionalData == additionalData)&&const DeepCollectionEquality().equals(other.epiUids, epiUids)&&const DeepCollectionEquality().equals(other.remarks, remarks)&&(identical(other.buildAt, buildAt) || other.buildAt == buildAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.status, status) || other.status == status)&&(identical(other.parent, parent) || other.parent == parent));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,type,uid,name,etrackerName,geoName,parentUid,jsonFilePath,isBulkImported,vaccineTarget,vaccineCoverage,additionalData,const DeepCollectionEquality().hash(epiUids),const DeepCollectionEquality().hash(remarks),buildAt,createdAt,updatedAt,status,parent]);

@override
String toString() {
  return 'Area(id: $id, type: $type, uid: $uid, name: $name, etrackerName: $etrackerName, geoName: $geoName, parentUid: $parentUid, jsonFilePath: $jsonFilePath, isBulkImported: $isBulkImported, vaccineTarget: $vaccineTarget, vaccineCoverage: $vaccineCoverage, additionalData: $additionalData, epiUids: $epiUids, remarks: $remarks, buildAt: $buildAt, createdAt: $createdAt, updatedAt: $updatedAt, status: $status, parent: $parent)';
}


}

/// @nodoc
abstract mixin class $AreaCopyWith<$Res>  {
  factory $AreaCopyWith(Area value, $Res Function(Area) _then) = _$AreaCopyWithImpl;
@useResult
$Res call({
 int? id, String? type, String? uid, String? name,@JsonKey(name: 'etracker_name') String? etrackerName,@JsonKey(name: 'geo_name') String? geoName,@JsonKey(name: 'parent_uid') String? parentUid,@JsonKey(name: 'json_file_path') String? jsonFilePath,@JsonKey(name: 'is_bulk_imported') bool? isBulkImported,@JsonKey(name: 'vaccine_target') VaccineTarget? vaccineTarget,@JsonKey(name: 'vaccine_coverage') VaccineCoverage? vaccineCoverage,@JsonKey(name: 'additional_data') AdditionalData? additionalData,@JsonKey(name: 'epi_uids') dynamic epiUids, dynamic remarks,@JsonKey(name: 'build_at') String? buildAt,@JsonKey(name: 'created_at') String? createdAt,@JsonKey(name: 'updated_at') String? updatedAt, String? status, Parent? parent
});


$VaccineTargetCopyWith<$Res>? get vaccineTarget;$VaccineCoverageCopyWith<$Res>? get vaccineCoverage;$AdditionalDataCopyWith<$Res>? get additionalData;$ParentCopyWith<$Res>? get parent;

}
/// @nodoc
class _$AreaCopyWithImpl<$Res>
    implements $AreaCopyWith<$Res> {
  _$AreaCopyWithImpl(this._self, this._then);

  final Area _self;
  final $Res Function(Area) _then;

/// Create a copy of Area
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? type = freezed,Object? uid = freezed,Object? name = freezed,Object? etrackerName = freezed,Object? geoName = freezed,Object? parentUid = freezed,Object? jsonFilePath = freezed,Object? isBulkImported = freezed,Object? vaccineTarget = freezed,Object? vaccineCoverage = freezed,Object? additionalData = freezed,Object? epiUids = freezed,Object? remarks = freezed,Object? buildAt = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? status = freezed,Object? parent = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,uid: freezed == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,etrackerName: freezed == etrackerName ? _self.etrackerName : etrackerName // ignore: cast_nullable_to_non_nullable
as String?,geoName: freezed == geoName ? _self.geoName : geoName // ignore: cast_nullable_to_non_nullable
as String?,parentUid: freezed == parentUid ? _self.parentUid : parentUid // ignore: cast_nullable_to_non_nullable
as String?,jsonFilePath: freezed == jsonFilePath ? _self.jsonFilePath : jsonFilePath // ignore: cast_nullable_to_non_nullable
as String?,isBulkImported: freezed == isBulkImported ? _self.isBulkImported : isBulkImported // ignore: cast_nullable_to_non_nullable
as bool?,vaccineTarget: freezed == vaccineTarget ? _self.vaccineTarget : vaccineTarget // ignore: cast_nullable_to_non_nullable
as VaccineTarget?,vaccineCoverage: freezed == vaccineCoverage ? _self.vaccineCoverage : vaccineCoverage // ignore: cast_nullable_to_non_nullable
as VaccineCoverage?,additionalData: freezed == additionalData ? _self.additionalData : additionalData // ignore: cast_nullable_to_non_nullable
as AdditionalData?,epiUids: freezed == epiUids ? _self.epiUids : epiUids // ignore: cast_nullable_to_non_nullable
as dynamic,remarks: freezed == remarks ? _self.remarks : remarks // ignore: cast_nullable_to_non_nullable
as dynamic,buildAt: freezed == buildAt ? _self.buildAt : buildAt // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,parent: freezed == parent ? _self.parent : parent // ignore: cast_nullable_to_non_nullable
as Parent?,
  ));
}
/// Create a copy of Area
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$VaccineTargetCopyWith<$Res>? get vaccineTarget {
    if (_self.vaccineTarget == null) {
    return null;
  }

  return $VaccineTargetCopyWith<$Res>(_self.vaccineTarget!, (value) {
    return _then(_self.copyWith(vaccineTarget: value));
  });
}/// Create a copy of Area
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$VaccineCoverageCopyWith<$Res>? get vaccineCoverage {
    if (_self.vaccineCoverage == null) {
    return null;
  }

  return $VaccineCoverageCopyWith<$Res>(_self.vaccineCoverage!, (value) {
    return _then(_self.copyWith(vaccineCoverage: value));
  });
}/// Create a copy of Area
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AdditionalDataCopyWith<$Res>? get additionalData {
    if (_self.additionalData == null) {
    return null;
  }

  return $AdditionalDataCopyWith<$Res>(_self.additionalData!, (value) {
    return _then(_self.copyWith(additionalData: value));
  });
}/// Create a copy of Area
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ParentCopyWith<$Res>? get parent {
    if (_self.parent == null) {
    return null;
  }

  return $ParentCopyWith<$Res>(_self.parent!, (value) {
    return _then(_self.copyWith(parent: value));
  });
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? id,  String? type,  String? uid,  String? name, @JsonKey(name: 'etracker_name')  String? etrackerName, @JsonKey(name: 'geo_name')  String? geoName, @JsonKey(name: 'parent_uid')  String? parentUid, @JsonKey(name: 'json_file_path')  String? jsonFilePath, @JsonKey(name: 'is_bulk_imported')  bool? isBulkImported, @JsonKey(name: 'vaccine_target')  VaccineTarget? vaccineTarget, @JsonKey(name: 'vaccine_coverage')  VaccineCoverage? vaccineCoverage, @JsonKey(name: 'additional_data')  AdditionalData? additionalData, @JsonKey(name: 'epi_uids')  dynamic epiUids,  dynamic remarks, @JsonKey(name: 'build_at')  String? buildAt, @JsonKey(name: 'created_at')  String? createdAt, @JsonKey(name: 'updated_at')  String? updatedAt,  String? status,  Parent? parent)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Area() when $default != null:
return $default(_that.id,_that.type,_that.uid,_that.name,_that.etrackerName,_that.geoName,_that.parentUid,_that.jsonFilePath,_that.isBulkImported,_that.vaccineTarget,_that.vaccineCoverage,_that.additionalData,_that.epiUids,_that.remarks,_that.buildAt,_that.createdAt,_that.updatedAt,_that.status,_that.parent);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? id,  String? type,  String? uid,  String? name, @JsonKey(name: 'etracker_name')  String? etrackerName, @JsonKey(name: 'geo_name')  String? geoName, @JsonKey(name: 'parent_uid')  String? parentUid, @JsonKey(name: 'json_file_path')  String? jsonFilePath, @JsonKey(name: 'is_bulk_imported')  bool? isBulkImported, @JsonKey(name: 'vaccine_target')  VaccineTarget? vaccineTarget, @JsonKey(name: 'vaccine_coverage')  VaccineCoverage? vaccineCoverage, @JsonKey(name: 'additional_data')  AdditionalData? additionalData, @JsonKey(name: 'epi_uids')  dynamic epiUids,  dynamic remarks, @JsonKey(name: 'build_at')  String? buildAt, @JsonKey(name: 'created_at')  String? createdAt, @JsonKey(name: 'updated_at')  String? updatedAt,  String? status,  Parent? parent)  $default,) {final _that = this;
switch (_that) {
case _Area():
return $default(_that.id,_that.type,_that.uid,_that.name,_that.etrackerName,_that.geoName,_that.parentUid,_that.jsonFilePath,_that.isBulkImported,_that.vaccineTarget,_that.vaccineCoverage,_that.additionalData,_that.epiUids,_that.remarks,_that.buildAt,_that.createdAt,_that.updatedAt,_that.status,_that.parent);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? id,  String? type,  String? uid,  String? name, @JsonKey(name: 'etracker_name')  String? etrackerName, @JsonKey(name: 'geo_name')  String? geoName, @JsonKey(name: 'parent_uid')  String? parentUid, @JsonKey(name: 'json_file_path')  String? jsonFilePath, @JsonKey(name: 'is_bulk_imported')  bool? isBulkImported, @JsonKey(name: 'vaccine_target')  VaccineTarget? vaccineTarget, @JsonKey(name: 'vaccine_coverage')  VaccineCoverage? vaccineCoverage, @JsonKey(name: 'additional_data')  AdditionalData? additionalData, @JsonKey(name: 'epi_uids')  dynamic epiUids,  dynamic remarks, @JsonKey(name: 'build_at')  String? buildAt, @JsonKey(name: 'created_at')  String? createdAt, @JsonKey(name: 'updated_at')  String? updatedAt,  String? status,  Parent? parent)?  $default,) {final _that = this;
switch (_that) {
case _Area() when $default != null:
return $default(_that.id,_that.type,_that.uid,_that.name,_that.etrackerName,_that.geoName,_that.parentUid,_that.jsonFilePath,_that.isBulkImported,_that.vaccineTarget,_that.vaccineCoverage,_that.additionalData,_that.epiUids,_that.remarks,_that.buildAt,_that.createdAt,_that.updatedAt,_that.status,_that.parent);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Area implements Area {
  const _Area({this.id, this.type, this.uid, this.name, @JsonKey(name: 'etracker_name') this.etrackerName, @JsonKey(name: 'geo_name') this.geoName, @JsonKey(name: 'parent_uid') this.parentUid, @JsonKey(name: 'json_file_path') this.jsonFilePath, @JsonKey(name: 'is_bulk_imported') this.isBulkImported, @JsonKey(name: 'vaccine_target') this.vaccineTarget, @JsonKey(name: 'vaccine_coverage') this.vaccineCoverage, @JsonKey(name: 'additional_data') this.additionalData, @JsonKey(name: 'epi_uids') this.epiUids, this.remarks, @JsonKey(name: 'build_at') this.buildAt, @JsonKey(name: 'created_at') this.createdAt, @JsonKey(name: 'updated_at') this.updatedAt, this.status, this.parent});
  factory _Area.fromJson(Map<String, dynamic> json) => _$AreaFromJson(json);

@override final  int? id;
@override final  String? type;
@override final  String? uid;
@override final  String? name;
@override@JsonKey(name: 'etracker_name') final  String? etrackerName;
@override@JsonKey(name: 'geo_name') final  String? geoName;
@override@JsonKey(name: 'parent_uid') final  String? parentUid;
@override@JsonKey(name: 'json_file_path') final  String? jsonFilePath;
@override@JsonKey(name: 'is_bulk_imported') final  bool? isBulkImported;
@override@JsonKey(name: 'vaccine_target') final  VaccineTarget? vaccineTarget;
@override@JsonKey(name: 'vaccine_coverage') final  VaccineCoverage? vaccineCoverage;
@override@JsonKey(name: 'additional_data') final  AdditionalData? additionalData;
@override@JsonKey(name: 'epi_uids') final  dynamic epiUids;
@override final  dynamic remarks;
@override@JsonKey(name: 'build_at') final  String? buildAt;
@override@JsonKey(name: 'created_at') final  String? createdAt;
@override@JsonKey(name: 'updated_at') final  String? updatedAt;
@override final  String? status;
@override final  Parent? parent;

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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Area&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.name, name) || other.name == name)&&(identical(other.etrackerName, etrackerName) || other.etrackerName == etrackerName)&&(identical(other.geoName, geoName) || other.geoName == geoName)&&(identical(other.parentUid, parentUid) || other.parentUid == parentUid)&&(identical(other.jsonFilePath, jsonFilePath) || other.jsonFilePath == jsonFilePath)&&(identical(other.isBulkImported, isBulkImported) || other.isBulkImported == isBulkImported)&&(identical(other.vaccineTarget, vaccineTarget) || other.vaccineTarget == vaccineTarget)&&(identical(other.vaccineCoverage, vaccineCoverage) || other.vaccineCoverage == vaccineCoverage)&&(identical(other.additionalData, additionalData) || other.additionalData == additionalData)&&const DeepCollectionEquality().equals(other.epiUids, epiUids)&&const DeepCollectionEquality().equals(other.remarks, remarks)&&(identical(other.buildAt, buildAt) || other.buildAt == buildAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.status, status) || other.status == status)&&(identical(other.parent, parent) || other.parent == parent));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,type,uid,name,etrackerName,geoName,parentUid,jsonFilePath,isBulkImported,vaccineTarget,vaccineCoverage,additionalData,const DeepCollectionEquality().hash(epiUids),const DeepCollectionEquality().hash(remarks),buildAt,createdAt,updatedAt,status,parent]);

@override
String toString() {
  return 'Area(id: $id, type: $type, uid: $uid, name: $name, etrackerName: $etrackerName, geoName: $geoName, parentUid: $parentUid, jsonFilePath: $jsonFilePath, isBulkImported: $isBulkImported, vaccineTarget: $vaccineTarget, vaccineCoverage: $vaccineCoverage, additionalData: $additionalData, epiUids: $epiUids, remarks: $remarks, buildAt: $buildAt, createdAt: $createdAt, updatedAt: $updatedAt, status: $status, parent: $parent)';
}


}

/// @nodoc
abstract mixin class _$AreaCopyWith<$Res> implements $AreaCopyWith<$Res> {
  factory _$AreaCopyWith(_Area value, $Res Function(_Area) _then) = __$AreaCopyWithImpl;
@override @useResult
$Res call({
 int? id, String? type, String? uid, String? name,@JsonKey(name: 'etracker_name') String? etrackerName,@JsonKey(name: 'geo_name') String? geoName,@JsonKey(name: 'parent_uid') String? parentUid,@JsonKey(name: 'json_file_path') String? jsonFilePath,@JsonKey(name: 'is_bulk_imported') bool? isBulkImported,@JsonKey(name: 'vaccine_target') VaccineTarget? vaccineTarget,@JsonKey(name: 'vaccine_coverage') VaccineCoverage? vaccineCoverage,@JsonKey(name: 'additional_data') AdditionalData? additionalData,@JsonKey(name: 'epi_uids') dynamic epiUids, dynamic remarks,@JsonKey(name: 'build_at') String? buildAt,@JsonKey(name: 'created_at') String? createdAt,@JsonKey(name: 'updated_at') String? updatedAt, String? status, Parent? parent
});


@override $VaccineTargetCopyWith<$Res>? get vaccineTarget;@override $VaccineCoverageCopyWith<$Res>? get vaccineCoverage;@override $AdditionalDataCopyWith<$Res>? get additionalData;@override $ParentCopyWith<$Res>? get parent;

}
/// @nodoc
class __$AreaCopyWithImpl<$Res>
    implements _$AreaCopyWith<$Res> {
  __$AreaCopyWithImpl(this._self, this._then);

  final _Area _self;
  final $Res Function(_Area) _then;

/// Create a copy of Area
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? type = freezed,Object? uid = freezed,Object? name = freezed,Object? etrackerName = freezed,Object? geoName = freezed,Object? parentUid = freezed,Object? jsonFilePath = freezed,Object? isBulkImported = freezed,Object? vaccineTarget = freezed,Object? vaccineCoverage = freezed,Object? additionalData = freezed,Object? epiUids = freezed,Object? remarks = freezed,Object? buildAt = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? status = freezed,Object? parent = freezed,}) {
  return _then(_Area(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,uid: freezed == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,etrackerName: freezed == etrackerName ? _self.etrackerName : etrackerName // ignore: cast_nullable_to_non_nullable
as String?,geoName: freezed == geoName ? _self.geoName : geoName // ignore: cast_nullable_to_non_nullable
as String?,parentUid: freezed == parentUid ? _self.parentUid : parentUid // ignore: cast_nullable_to_non_nullable
as String?,jsonFilePath: freezed == jsonFilePath ? _self.jsonFilePath : jsonFilePath // ignore: cast_nullable_to_non_nullable
as String?,isBulkImported: freezed == isBulkImported ? _self.isBulkImported : isBulkImported // ignore: cast_nullable_to_non_nullable
as bool?,vaccineTarget: freezed == vaccineTarget ? _self.vaccineTarget : vaccineTarget // ignore: cast_nullable_to_non_nullable
as VaccineTarget?,vaccineCoverage: freezed == vaccineCoverage ? _self.vaccineCoverage : vaccineCoverage // ignore: cast_nullable_to_non_nullable
as VaccineCoverage?,additionalData: freezed == additionalData ? _self.additionalData : additionalData // ignore: cast_nullable_to_non_nullable
as AdditionalData?,epiUids: freezed == epiUids ? _self.epiUids : epiUids // ignore: cast_nullable_to_non_nullable
as dynamic,remarks: freezed == remarks ? _self.remarks : remarks // ignore: cast_nullable_to_non_nullable
as dynamic,buildAt: freezed == buildAt ? _self.buildAt : buildAt // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,parent: freezed == parent ? _self.parent : parent // ignore: cast_nullable_to_non_nullable
as Parent?,
  ));
}

/// Create a copy of Area
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$VaccineTargetCopyWith<$Res>? get vaccineTarget {
    if (_self.vaccineTarget == null) {
    return null;
  }

  return $VaccineTargetCopyWith<$Res>(_self.vaccineTarget!, (value) {
    return _then(_self.copyWith(vaccineTarget: value));
  });
}/// Create a copy of Area
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$VaccineCoverageCopyWith<$Res>? get vaccineCoverage {
    if (_self.vaccineCoverage == null) {
    return null;
  }

  return $VaccineCoverageCopyWith<$Res>(_self.vaccineCoverage!, (value) {
    return _then(_self.copyWith(vaccineCoverage: value));
  });
}/// Create a copy of Area
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AdditionalDataCopyWith<$Res>? get additionalData {
    if (_self.additionalData == null) {
    return null;
  }

  return $AdditionalDataCopyWith<$Res>(_self.additionalData!, (value) {
    return _then(_self.copyWith(additionalData: value));
  });
}/// Create a copy of Area
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ParentCopyWith<$Res>? get parent {
    if (_self.parent == null) {
    return null;
  }

  return $ParentCopyWith<$Res>(_self.parent!, (value) {
    return _then(_self.copyWith(parent: value));
  });
}
}


/// @nodoc
mixin _$VaccineTarget {

@JsonKey(name: 'child_0_to_11_month') Map<String, YearTarget> get child0To11Month;
/// Create a copy of VaccineTarget
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VaccineTargetCopyWith<VaccineTarget> get copyWith => _$VaccineTargetCopyWithImpl<VaccineTarget>(this as VaccineTarget, _$identity);

  /// Serializes this VaccineTarget to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VaccineTarget&&const DeepCollectionEquality().equals(other.child0To11Month, child0To11Month));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(child0To11Month));

@override
String toString() {
  return 'VaccineTarget(child0To11Month: $child0To11Month)';
}


}

/// @nodoc
abstract mixin class $VaccineTargetCopyWith<$Res>  {
  factory $VaccineTargetCopyWith(VaccineTarget value, $Res Function(VaccineTarget) _then) = _$VaccineTargetCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'child_0_to_11_month') Map<String, YearTarget> child0To11Month
});




}
/// @nodoc
class _$VaccineTargetCopyWithImpl<$Res>
    implements $VaccineTargetCopyWith<$Res> {
  _$VaccineTargetCopyWithImpl(this._self, this._then);

  final VaccineTarget _self;
  final $Res Function(VaccineTarget) _then;

/// Create a copy of VaccineTarget
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? child0To11Month = null,}) {
  return _then(_self.copyWith(
child0To11Month: null == child0To11Month ? _self.child0To11Month : child0To11Month // ignore: cast_nullable_to_non_nullable
as Map<String, YearTarget>,
  ));
}

}


/// Adds pattern-matching-related methods to [VaccineTarget].
extension VaccineTargetPatterns on VaccineTarget {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VaccineTarget value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VaccineTarget() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VaccineTarget value)  $default,){
final _that = this;
switch (_that) {
case _VaccineTarget():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VaccineTarget value)?  $default,){
final _that = this;
switch (_that) {
case _VaccineTarget() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'child_0_to_11_month')  Map<String, YearTarget> child0To11Month)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VaccineTarget() when $default != null:
return $default(_that.child0To11Month);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'child_0_to_11_month')  Map<String, YearTarget> child0To11Month)  $default,) {final _that = this;
switch (_that) {
case _VaccineTarget():
return $default(_that.child0To11Month);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'child_0_to_11_month')  Map<String, YearTarget> child0To11Month)?  $default,) {final _that = this;
switch (_that) {
case _VaccineTarget() when $default != null:
return $default(_that.child0To11Month);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _VaccineTarget implements VaccineTarget {
  const _VaccineTarget({@JsonKey(name: 'child_0_to_11_month') final  Map<String, YearTarget> child0To11Month = const {}}): _child0To11Month = child0To11Month;
  factory _VaccineTarget.fromJson(Map<String, dynamic> json) => _$VaccineTargetFromJson(json);

 final  Map<String, YearTarget> _child0To11Month;
@override@JsonKey(name: 'child_0_to_11_month') Map<String, YearTarget> get child0To11Month {
  if (_child0To11Month is EqualUnmodifiableMapView) return _child0To11Month;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_child0To11Month);
}


/// Create a copy of VaccineTarget
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VaccineTargetCopyWith<_VaccineTarget> get copyWith => __$VaccineTargetCopyWithImpl<_VaccineTarget>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VaccineTargetToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VaccineTarget&&const DeepCollectionEquality().equals(other._child0To11Month, _child0To11Month));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_child0To11Month));

@override
String toString() {
  return 'VaccineTarget(child0To11Month: $child0To11Month)';
}


}

/// @nodoc
abstract mixin class _$VaccineTargetCopyWith<$Res> implements $VaccineTargetCopyWith<$Res> {
  factory _$VaccineTargetCopyWith(_VaccineTarget value, $Res Function(_VaccineTarget) _then) = __$VaccineTargetCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'child_0_to_11_month') Map<String, YearTarget> child0To11Month
});




}
/// @nodoc
class __$VaccineTargetCopyWithImpl<$Res>
    implements _$VaccineTargetCopyWith<$Res> {
  __$VaccineTargetCopyWithImpl(this._self, this._then);

  final _VaccineTarget _self;
  final $Res Function(_VaccineTarget) _then;

/// Create a copy of VaccineTarget
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? child0To11Month = null,}) {
  return _then(_VaccineTarget(
child0To11Month: null == child0To11Month ? _self._child0To11Month : child0To11Month // ignore: cast_nullable_to_non_nullable
as Map<String, YearTarget>,
  ));
}


}


/// @nodoc
mixin _$YearTarget {

 int? get male; int? get female;
/// Create a copy of YearTarget
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$YearTargetCopyWith<YearTarget> get copyWith => _$YearTargetCopyWithImpl<YearTarget>(this as YearTarget, _$identity);

  /// Serializes this YearTarget to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is YearTarget&&(identical(other.male, male) || other.male == male)&&(identical(other.female, female) || other.female == female));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,male,female);

@override
String toString() {
  return 'YearTarget(male: $male, female: $female)';
}


}

/// @nodoc
abstract mixin class $YearTargetCopyWith<$Res>  {
  factory $YearTargetCopyWith(YearTarget value, $Res Function(YearTarget) _then) = _$YearTargetCopyWithImpl;
@useResult
$Res call({
 int? male, int? female
});




}
/// @nodoc
class _$YearTargetCopyWithImpl<$Res>
    implements $YearTargetCopyWith<$Res> {
  _$YearTargetCopyWithImpl(this._self, this._then);

  final YearTarget _self;
  final $Res Function(YearTarget) _then;

/// Create a copy of YearTarget
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? male = freezed,Object? female = freezed,}) {
  return _then(_self.copyWith(
male: freezed == male ? _self.male : male // ignore: cast_nullable_to_non_nullable
as int?,female: freezed == female ? _self.female : female // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [YearTarget].
extension YearTargetPatterns on YearTarget {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _YearTarget value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _YearTarget() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _YearTarget value)  $default,){
final _that = this;
switch (_that) {
case _YearTarget():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _YearTarget value)?  $default,){
final _that = this;
switch (_that) {
case _YearTarget() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? male,  int? female)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _YearTarget() when $default != null:
return $default(_that.male,_that.female);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? male,  int? female)  $default,) {final _that = this;
switch (_that) {
case _YearTarget():
return $default(_that.male,_that.female);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? male,  int? female)?  $default,) {final _that = this;
switch (_that) {
case _YearTarget() when $default != null:
return $default(_that.male,_that.female);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _YearTarget implements YearTarget {
  const _YearTarget({this.male, this.female});
  factory _YearTarget.fromJson(Map<String, dynamic> json) => _$YearTargetFromJson(json);

@override final  int? male;
@override final  int? female;

/// Create a copy of YearTarget
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$YearTargetCopyWith<_YearTarget> get copyWith => __$YearTargetCopyWithImpl<_YearTarget>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$YearTargetToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _YearTarget&&(identical(other.male, male) || other.male == male)&&(identical(other.female, female) || other.female == female));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,male,female);

@override
String toString() {
  return 'YearTarget(male: $male, female: $female)';
}


}

/// @nodoc
abstract mixin class _$YearTargetCopyWith<$Res> implements $YearTargetCopyWith<$Res> {
  factory _$YearTargetCopyWith(_YearTarget value, $Res Function(_YearTarget) _then) = __$YearTargetCopyWithImpl;
@override @useResult
$Res call({
 int? male, int? female
});




}
/// @nodoc
class __$YearTargetCopyWithImpl<$Res>
    implements _$YearTargetCopyWith<$Res> {
  __$YearTargetCopyWithImpl(this._self, this._then);

  final _YearTarget _self;
  final $Res Function(_YearTarget) _then;

/// Create a copy of YearTarget
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? male = freezed,Object? female = freezed,}) {
  return _then(_YearTarget(
male: freezed == male ? _self.male : male // ignore: cast_nullable_to_non_nullable
as int?,female: freezed == female ? _self.female : female // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$VaccineCoverage {

@JsonKey(name: 'child_0_to_11_month') Map<String, YearCoverage> get child0To11Month;
/// Create a copy of VaccineCoverage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VaccineCoverageCopyWith<VaccineCoverage> get copyWith => _$VaccineCoverageCopyWithImpl<VaccineCoverage>(this as VaccineCoverage, _$identity);

  /// Serializes this VaccineCoverage to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VaccineCoverage&&const DeepCollectionEquality().equals(other.child0To11Month, child0To11Month));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(child0To11Month));

@override
String toString() {
  return 'VaccineCoverage(child0To11Month: $child0To11Month)';
}


}

/// @nodoc
abstract mixin class $VaccineCoverageCopyWith<$Res>  {
  factory $VaccineCoverageCopyWith(VaccineCoverage value, $Res Function(VaccineCoverage) _then) = _$VaccineCoverageCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'child_0_to_11_month') Map<String, YearCoverage> child0To11Month
});




}
/// @nodoc
class _$VaccineCoverageCopyWithImpl<$Res>
    implements $VaccineCoverageCopyWith<$Res> {
  _$VaccineCoverageCopyWithImpl(this._self, this._then);

  final VaccineCoverage _self;
  final $Res Function(VaccineCoverage) _then;

/// Create a copy of VaccineCoverage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? child0To11Month = null,}) {
  return _then(_self.copyWith(
child0To11Month: null == child0To11Month ? _self.child0To11Month : child0To11Month // ignore: cast_nullable_to_non_nullable
as Map<String, YearCoverage>,
  ));
}

}


/// Adds pattern-matching-related methods to [VaccineCoverage].
extension VaccineCoveragePatterns on VaccineCoverage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VaccineCoverage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VaccineCoverage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VaccineCoverage value)  $default,){
final _that = this;
switch (_that) {
case _VaccineCoverage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VaccineCoverage value)?  $default,){
final _that = this;
switch (_that) {
case _VaccineCoverage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'child_0_to_11_month')  Map<String, YearCoverage> child0To11Month)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VaccineCoverage() when $default != null:
return $default(_that.child0To11Month);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'child_0_to_11_month')  Map<String, YearCoverage> child0To11Month)  $default,) {final _that = this;
switch (_that) {
case _VaccineCoverage():
return $default(_that.child0To11Month);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'child_0_to_11_month')  Map<String, YearCoverage> child0To11Month)?  $default,) {final _that = this;
switch (_that) {
case _VaccineCoverage() when $default != null:
return $default(_that.child0To11Month);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _VaccineCoverage implements VaccineCoverage {
  const _VaccineCoverage({@JsonKey(name: 'child_0_to_11_month') final  Map<String, YearCoverage> child0To11Month = const {}}): _child0To11Month = child0To11Month;
  factory _VaccineCoverage.fromJson(Map<String, dynamic> json) => _$VaccineCoverageFromJson(json);

 final  Map<String, YearCoverage> _child0To11Month;
@override@JsonKey(name: 'child_0_to_11_month') Map<String, YearCoverage> get child0To11Month {
  if (_child0To11Month is EqualUnmodifiableMapView) return _child0To11Month;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_child0To11Month);
}


/// Create a copy of VaccineCoverage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VaccineCoverageCopyWith<_VaccineCoverage> get copyWith => __$VaccineCoverageCopyWithImpl<_VaccineCoverage>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VaccineCoverageToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VaccineCoverage&&const DeepCollectionEquality().equals(other._child0To11Month, _child0To11Month));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_child0To11Month));

@override
String toString() {
  return 'VaccineCoverage(child0To11Month: $child0To11Month)';
}


}

/// @nodoc
abstract mixin class _$VaccineCoverageCopyWith<$Res> implements $VaccineCoverageCopyWith<$Res> {
  factory _$VaccineCoverageCopyWith(_VaccineCoverage value, $Res Function(_VaccineCoverage) _then) = __$VaccineCoverageCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'child_0_to_11_month') Map<String, YearCoverage> child0To11Month
});




}
/// @nodoc
class __$VaccineCoverageCopyWithImpl<$Res>
    implements _$VaccineCoverageCopyWith<$Res> {
  __$VaccineCoverageCopyWithImpl(this._self, this._then);

  final _VaccineCoverage _self;
  final $Res Function(_VaccineCoverage) _then;

/// Create a copy of VaccineCoverage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? child0To11Month = null,}) {
  return _then(_VaccineCoverage(
child0To11Month: null == child0To11Month ? _self._child0To11Month : child0To11Month // ignore: cast_nullable_to_non_nullable
as Map<String, YearCoverage>,
  ));
}


}


/// @nodoc
mixin _$YearCoverage {

 List<VaccineItem> get vaccine; Map<String, MonthCoverage> get months;
/// Create a copy of YearCoverage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$YearCoverageCopyWith<YearCoverage> get copyWith => _$YearCoverageCopyWithImpl<YearCoverage>(this as YearCoverage, _$identity);

  /// Serializes this YearCoverage to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is YearCoverage&&const DeepCollectionEquality().equals(other.vaccine, vaccine)&&const DeepCollectionEquality().equals(other.months, months));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(vaccine),const DeepCollectionEquality().hash(months));

@override
String toString() {
  return 'YearCoverage(vaccine: $vaccine, months: $months)';
}


}

/// @nodoc
abstract mixin class $YearCoverageCopyWith<$Res>  {
  factory $YearCoverageCopyWith(YearCoverage value, $Res Function(YearCoverage) _then) = _$YearCoverageCopyWithImpl;
@useResult
$Res call({
 List<VaccineItem> vaccine, Map<String, MonthCoverage> months
});




}
/// @nodoc
class _$YearCoverageCopyWithImpl<$Res>
    implements $YearCoverageCopyWith<$Res> {
  _$YearCoverageCopyWithImpl(this._self, this._then);

  final YearCoverage _self;
  final $Res Function(YearCoverage) _then;

/// Create a copy of YearCoverage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? vaccine = null,Object? months = null,}) {
  return _then(_self.copyWith(
vaccine: null == vaccine ? _self.vaccine : vaccine // ignore: cast_nullable_to_non_nullable
as List<VaccineItem>,months: null == months ? _self.months : months // ignore: cast_nullable_to_non_nullable
as Map<String, MonthCoverage>,
  ));
}

}


/// Adds pattern-matching-related methods to [YearCoverage].
extension YearCoveragePatterns on YearCoverage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _YearCoverage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _YearCoverage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _YearCoverage value)  $default,){
final _that = this;
switch (_that) {
case _YearCoverage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _YearCoverage value)?  $default,){
final _that = this;
switch (_that) {
case _YearCoverage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<VaccineItem> vaccine,  Map<String, MonthCoverage> months)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _YearCoverage() when $default != null:
return $default(_that.vaccine,_that.months);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<VaccineItem> vaccine,  Map<String, MonthCoverage> months)  $default,) {final _that = this;
switch (_that) {
case _YearCoverage():
return $default(_that.vaccine,_that.months);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<VaccineItem> vaccine,  Map<String, MonthCoverage> months)?  $default,) {final _that = this;
switch (_that) {
case _YearCoverage() when $default != null:
return $default(_that.vaccine,_that.months);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _YearCoverage implements YearCoverage {
  const _YearCoverage({final  List<VaccineItem> vaccine = const [], final  Map<String, MonthCoverage> months = const {}}): _vaccine = vaccine,_months = months;
  factory _YearCoverage.fromJson(Map<String, dynamic> json) => _$YearCoverageFromJson(json);

 final  List<VaccineItem> _vaccine;
@override@JsonKey() List<VaccineItem> get vaccine {
  if (_vaccine is EqualUnmodifiableListView) return _vaccine;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_vaccine);
}

 final  Map<String, MonthCoverage> _months;
@override@JsonKey() Map<String, MonthCoverage> get months {
  if (_months is EqualUnmodifiableMapView) return _months;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_months);
}


/// Create a copy of YearCoverage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$YearCoverageCopyWith<_YearCoverage> get copyWith => __$YearCoverageCopyWithImpl<_YearCoverage>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$YearCoverageToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _YearCoverage&&const DeepCollectionEquality().equals(other._vaccine, _vaccine)&&const DeepCollectionEquality().equals(other._months, _months));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_vaccine),const DeepCollectionEquality().hash(_months));

@override
String toString() {
  return 'YearCoverage(vaccine: $vaccine, months: $months)';
}


}

/// @nodoc
abstract mixin class _$YearCoverageCopyWith<$Res> implements $YearCoverageCopyWith<$Res> {
  factory _$YearCoverageCopyWith(_YearCoverage value, $Res Function(_YearCoverage) _then) = __$YearCoverageCopyWithImpl;
@override @useResult
$Res call({
 List<VaccineItem> vaccine, Map<String, MonthCoverage> months
});




}
/// @nodoc
class __$YearCoverageCopyWithImpl<$Res>
    implements _$YearCoverageCopyWith<$Res> {
  __$YearCoverageCopyWithImpl(this._self, this._then);

  final _YearCoverage _self;
  final $Res Function(_YearCoverage) _then;

/// Create a copy of YearCoverage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? vaccine = null,Object? months = null,}) {
  return _then(_YearCoverage(
vaccine: null == vaccine ? _self._vaccine : vaccine // ignore: cast_nullable_to_non_nullable
as List<VaccineItem>,months: null == months ? _self._months : months // ignore: cast_nullable_to_non_nullable
as Map<String, MonthCoverage>,
  ));
}


}


/// @nodoc
mixin _$VaccineItem {

@JsonKey(name: 'vaccine_uid') String? get vaccineUid;@JsonKey(name: 'vaccine_name') String? get vaccineName; int? get male; int? get female;
/// Create a copy of VaccineItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VaccineItemCopyWith<VaccineItem> get copyWith => _$VaccineItemCopyWithImpl<VaccineItem>(this as VaccineItem, _$identity);

  /// Serializes this VaccineItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VaccineItem&&(identical(other.vaccineUid, vaccineUid) || other.vaccineUid == vaccineUid)&&(identical(other.vaccineName, vaccineName) || other.vaccineName == vaccineName)&&(identical(other.male, male) || other.male == male)&&(identical(other.female, female) || other.female == female));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,vaccineUid,vaccineName,male,female);

@override
String toString() {
  return 'VaccineItem(vaccineUid: $vaccineUid, vaccineName: $vaccineName, male: $male, female: $female)';
}


}

/// @nodoc
abstract mixin class $VaccineItemCopyWith<$Res>  {
  factory $VaccineItemCopyWith(VaccineItem value, $Res Function(VaccineItem) _then) = _$VaccineItemCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'vaccine_uid') String? vaccineUid,@JsonKey(name: 'vaccine_name') String? vaccineName, int? male, int? female
});




}
/// @nodoc
class _$VaccineItemCopyWithImpl<$Res>
    implements $VaccineItemCopyWith<$Res> {
  _$VaccineItemCopyWithImpl(this._self, this._then);

  final VaccineItem _self;
  final $Res Function(VaccineItem) _then;

/// Create a copy of VaccineItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? vaccineUid = freezed,Object? vaccineName = freezed,Object? male = freezed,Object? female = freezed,}) {
  return _then(_self.copyWith(
vaccineUid: freezed == vaccineUid ? _self.vaccineUid : vaccineUid // ignore: cast_nullable_to_non_nullable
as String?,vaccineName: freezed == vaccineName ? _self.vaccineName : vaccineName // ignore: cast_nullable_to_non_nullable
as String?,male: freezed == male ? _self.male : male // ignore: cast_nullable_to_non_nullable
as int?,female: freezed == female ? _self.female : female // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [VaccineItem].
extension VaccineItemPatterns on VaccineItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VaccineItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VaccineItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VaccineItem value)  $default,){
final _that = this;
switch (_that) {
case _VaccineItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VaccineItem value)?  $default,){
final _that = this;
switch (_that) {
case _VaccineItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'vaccine_uid')  String? vaccineUid, @JsonKey(name: 'vaccine_name')  String? vaccineName,  int? male,  int? female)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VaccineItem() when $default != null:
return $default(_that.vaccineUid,_that.vaccineName,_that.male,_that.female);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'vaccine_uid')  String? vaccineUid, @JsonKey(name: 'vaccine_name')  String? vaccineName,  int? male,  int? female)  $default,) {final _that = this;
switch (_that) {
case _VaccineItem():
return $default(_that.vaccineUid,_that.vaccineName,_that.male,_that.female);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'vaccine_uid')  String? vaccineUid, @JsonKey(name: 'vaccine_name')  String? vaccineName,  int? male,  int? female)?  $default,) {final _that = this;
switch (_that) {
case _VaccineItem() when $default != null:
return $default(_that.vaccineUid,_that.vaccineName,_that.male,_that.female);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _VaccineItem implements VaccineItem {
  const _VaccineItem({@JsonKey(name: 'vaccine_uid') this.vaccineUid, @JsonKey(name: 'vaccine_name') this.vaccineName, this.male, this.female});
  factory _VaccineItem.fromJson(Map<String, dynamic> json) => _$VaccineItemFromJson(json);

@override@JsonKey(name: 'vaccine_uid') final  String? vaccineUid;
@override@JsonKey(name: 'vaccine_name') final  String? vaccineName;
@override final  int? male;
@override final  int? female;

/// Create a copy of VaccineItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VaccineItemCopyWith<_VaccineItem> get copyWith => __$VaccineItemCopyWithImpl<_VaccineItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VaccineItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VaccineItem&&(identical(other.vaccineUid, vaccineUid) || other.vaccineUid == vaccineUid)&&(identical(other.vaccineName, vaccineName) || other.vaccineName == vaccineName)&&(identical(other.male, male) || other.male == male)&&(identical(other.female, female) || other.female == female));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,vaccineUid,vaccineName,male,female);

@override
String toString() {
  return 'VaccineItem(vaccineUid: $vaccineUid, vaccineName: $vaccineName, male: $male, female: $female)';
}


}

/// @nodoc
abstract mixin class _$VaccineItemCopyWith<$Res> implements $VaccineItemCopyWith<$Res> {
  factory _$VaccineItemCopyWith(_VaccineItem value, $Res Function(_VaccineItem) _then) = __$VaccineItemCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'vaccine_uid') String? vaccineUid,@JsonKey(name: 'vaccine_name') String? vaccineName, int? male, int? female
});




}
/// @nodoc
class __$VaccineItemCopyWithImpl<$Res>
    implements _$VaccineItemCopyWith<$Res> {
  __$VaccineItemCopyWithImpl(this._self, this._then);

  final _VaccineItem _self;
  final $Res Function(_VaccineItem) _then;

/// Create a copy of VaccineItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? vaccineUid = freezed,Object? vaccineName = freezed,Object? male = freezed,Object? female = freezed,}) {
  return _then(_VaccineItem(
vaccineUid: freezed == vaccineUid ? _self.vaccineUid : vaccineUid // ignore: cast_nullable_to_non_nullable
as String?,vaccineName: freezed == vaccineName ? _self.vaccineName : vaccineName // ignore: cast_nullable_to_non_nullable
as String?,male: freezed == male ? _self.male : male // ignore: cast_nullable_to_non_nullable
as int?,female: freezed == female ? _self.female : female // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$MonthCoverage {

 List<VaccineItem> get vaccine;
/// Create a copy of MonthCoverage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MonthCoverageCopyWith<MonthCoverage> get copyWith => _$MonthCoverageCopyWithImpl<MonthCoverage>(this as MonthCoverage, _$identity);

  /// Serializes this MonthCoverage to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MonthCoverage&&const DeepCollectionEquality().equals(other.vaccine, vaccine));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(vaccine));

@override
String toString() {
  return 'MonthCoverage(vaccine: $vaccine)';
}


}

/// @nodoc
abstract mixin class $MonthCoverageCopyWith<$Res>  {
  factory $MonthCoverageCopyWith(MonthCoverage value, $Res Function(MonthCoverage) _then) = _$MonthCoverageCopyWithImpl;
@useResult
$Res call({
 List<VaccineItem> vaccine
});




}
/// @nodoc
class _$MonthCoverageCopyWithImpl<$Res>
    implements $MonthCoverageCopyWith<$Res> {
  _$MonthCoverageCopyWithImpl(this._self, this._then);

  final MonthCoverage _self;
  final $Res Function(MonthCoverage) _then;

/// Create a copy of MonthCoverage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? vaccine = null,}) {
  return _then(_self.copyWith(
vaccine: null == vaccine ? _self.vaccine : vaccine // ignore: cast_nullable_to_non_nullable
as List<VaccineItem>,
  ));
}

}


/// Adds pattern-matching-related methods to [MonthCoverage].
extension MonthCoveragePatterns on MonthCoverage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MonthCoverage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MonthCoverage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MonthCoverage value)  $default,){
final _that = this;
switch (_that) {
case _MonthCoverage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MonthCoverage value)?  $default,){
final _that = this;
switch (_that) {
case _MonthCoverage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<VaccineItem> vaccine)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MonthCoverage() when $default != null:
return $default(_that.vaccine);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<VaccineItem> vaccine)  $default,) {final _that = this;
switch (_that) {
case _MonthCoverage():
return $default(_that.vaccine);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<VaccineItem> vaccine)?  $default,) {final _that = this;
switch (_that) {
case _MonthCoverage() when $default != null:
return $default(_that.vaccine);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MonthCoverage implements MonthCoverage {
  const _MonthCoverage({final  List<VaccineItem> vaccine = const []}): _vaccine = vaccine;
  factory _MonthCoverage.fromJson(Map<String, dynamic> json) => _$MonthCoverageFromJson(json);

 final  List<VaccineItem> _vaccine;
@override@JsonKey() List<VaccineItem> get vaccine {
  if (_vaccine is EqualUnmodifiableListView) return _vaccine;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_vaccine);
}


/// Create a copy of MonthCoverage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MonthCoverageCopyWith<_MonthCoverage> get copyWith => __$MonthCoverageCopyWithImpl<_MonthCoverage>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MonthCoverageToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MonthCoverage&&const DeepCollectionEquality().equals(other._vaccine, _vaccine));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_vaccine));

@override
String toString() {
  return 'MonthCoverage(vaccine: $vaccine)';
}


}

/// @nodoc
abstract mixin class _$MonthCoverageCopyWith<$Res> implements $MonthCoverageCopyWith<$Res> {
  factory _$MonthCoverageCopyWith(_MonthCoverage value, $Res Function(_MonthCoverage) _then) = __$MonthCoverageCopyWithImpl;
@override @useResult
$Res call({
 List<VaccineItem> vaccine
});




}
/// @nodoc
class __$MonthCoverageCopyWithImpl<$Res>
    implements _$MonthCoverageCopyWith<$Res> {
  __$MonthCoverageCopyWithImpl(this._self, this._then);

  final _MonthCoverage _self;
  final $Res Function(_MonthCoverage) _then;

/// Create a copy of MonthCoverage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? vaccine = null,}) {
  return _then(_MonthCoverage(
vaccine: null == vaccine ? _self._vaccine : vaccine // ignore: cast_nullable_to_non_nullable
as List<VaccineItem>,
  ));
}


}


/// @nodoc
mixin _$AdditionalData {

 Map<String, YearDemographics> get demographics;
/// Create a copy of AdditionalData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdditionalDataCopyWith<AdditionalData> get copyWith => _$AdditionalDataCopyWithImpl<AdditionalData>(this as AdditionalData, _$identity);

  /// Serializes this AdditionalData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdditionalData&&const DeepCollectionEquality().equals(other.demographics, demographics));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(demographics));

@override
String toString() {
  return 'AdditionalData(demographics: $demographics)';
}


}

/// @nodoc
abstract mixin class $AdditionalDataCopyWith<$Res>  {
  factory $AdditionalDataCopyWith(AdditionalData value, $Res Function(AdditionalData) _then) = _$AdditionalDataCopyWithImpl;
@useResult
$Res call({
 Map<String, YearDemographics> demographics
});




}
/// @nodoc
class _$AdditionalDataCopyWithImpl<$Res>
    implements $AdditionalDataCopyWith<$Res> {
  _$AdditionalDataCopyWithImpl(this._self, this._then);

  final AdditionalData _self;
  final $Res Function(AdditionalData) _then;

/// Create a copy of AdditionalData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? demographics = null,}) {
  return _then(_self.copyWith(
demographics: null == demographics ? _self.demographics : demographics // ignore: cast_nullable_to_non_nullable
as Map<String, YearDemographics>,
  ));
}

}


/// Adds pattern-matching-related methods to [AdditionalData].
extension AdditionalDataPatterns on AdditionalData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdditionalData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdditionalData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdditionalData value)  $default,){
final _that = this;
switch (_that) {
case _AdditionalData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdditionalData value)?  $default,){
final _that = this;
switch (_that) {
case _AdditionalData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Map<String, YearDemographics> demographics)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdditionalData() when $default != null:
return $default(_that.demographics);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Map<String, YearDemographics> demographics)  $default,) {final _that = this;
switch (_that) {
case _AdditionalData():
return $default(_that.demographics);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Map<String, YearDemographics> demographics)?  $default,) {final _that = this;
switch (_that) {
case _AdditionalData() when $default != null:
return $default(_that.demographics);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AdditionalData implements AdditionalData {
  const _AdditionalData({final  Map<String, YearDemographics> demographics = const {}}): _demographics = demographics;
  factory _AdditionalData.fromJson(Map<String, dynamic> json) => _$AdditionalDataFromJson(json);

 final  Map<String, YearDemographics> _demographics;
@override@JsonKey() Map<String, YearDemographics> get demographics {
  if (_demographics is EqualUnmodifiableMapView) return _demographics;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_demographics);
}


/// Create a copy of AdditionalData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdditionalDataCopyWith<_AdditionalData> get copyWith => __$AdditionalDataCopyWithImpl<_AdditionalData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AdditionalDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdditionalData&&const DeepCollectionEquality().equals(other._demographics, _demographics));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_demographics));

@override
String toString() {
  return 'AdditionalData(demographics: $demographics)';
}


}

/// @nodoc
abstract mixin class _$AdditionalDataCopyWith<$Res> implements $AdditionalDataCopyWith<$Res> {
  factory _$AdditionalDataCopyWith(_AdditionalData value, $Res Function(_AdditionalData) _then) = __$AdditionalDataCopyWithImpl;
@override @useResult
$Res call({
 Map<String, YearDemographics> demographics
});




}
/// @nodoc
class __$AdditionalDataCopyWithImpl<$Res>
    implements _$AdditionalDataCopyWith<$Res> {
  __$AdditionalDataCopyWithImpl(this._self, this._then);

  final _AdditionalData _self;
  final $Res Function(_AdditionalData) _then;

/// Create a copy of AdditionalData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? demographics = null,}) {
  return _then(_AdditionalData(
demographics: null == demographics ? _self._demographics : demographics // ignore: cast_nullable_to_non_nullable
as Map<String, YearDemographics>,
  ));
}


}


/// @nodoc
mixin _$YearDemographics {

 Population? get population;@JsonKey(name: 'child_0_15_month') ChildData? get child0To15Month;@JsonKey(name: 'child_0_11_month') ChildData? get child0To11Month;@JsonKey(name: 'number_of_sessions_in_year') int? get numberOfSessionsInYear;@JsonKey(name: 'women_15_to_49') int? get women15To49;@JsonKey(name: 'ha_vaccinator_designation1') dynamic get haVaccinatorDesignation1;// ✅ Changed to dynamic (can be String or int)
@JsonKey(name: 'ha_vaccinator_name1') dynamic get haVaccinatorName1;// ✅ Changed to dynamic
@JsonKey(name: 'ha_vaccinator_designation2') dynamic get haVaccinatorDesignation2;// ✅ Changed to dynamic
@JsonKey(name: 'ha_vaccinator_name2') dynamic get haVaccinatorName2;// ✅ Changed to dynamic
@JsonKey(name: 'supervisor1_designation') dynamic get supervisor1Designation;// ✅ Changed to dynamic
@JsonKey(name: 'supervisor1_name') dynamic get supervisor1Name;// ✅ Changed to dynamic
@JsonKey(name: 'epi_center_name_address') dynamic get epiCenterNameAddress;// ✅ Changed to dynamic
@JsonKey(name: 'epi_center_implementer_name') dynamic get epiCenterImplementerName;// ✅ Changed to dynamic
@JsonKey(name: 'distance_from_cc_to_epi_center') dynamic get distanceFromCcToEpiCenter;@JsonKey(name: 'mode_of_transportation_distribution') dynamic get modeOfTransportationDistribution;// ✅ Changed to dynamic
@JsonKey(name: 'mode_of_transportation_uhc') dynamic get modeOfTransportationUhc;// ✅ Changed to dynamic
@JsonKey(name: 'time_to_reach_distribution_point') dynamic get timeToReachDistributionPoint;// ✅ Changed to dynamic (can be double or int)
@JsonKey(name: 'time_to_reach_epi_center') dynamic get timeToReachEpiCenter;// ✅ Changed to dynamic
@JsonKey(name: 'porter_name') dynamic get porterName;// ✅ Changed to dynamic
@JsonKey(name: 'porter_mobile') dynamic get porterMobile;// ✅ Changed to dynamic (can be very large number)
@JsonKey(name: 'epi_center_type') dynamic get epiCenterType;
/// Create a copy of YearDemographics
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$YearDemographicsCopyWith<YearDemographics> get copyWith => _$YearDemographicsCopyWithImpl<YearDemographics>(this as YearDemographics, _$identity);

  /// Serializes this YearDemographics to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is YearDemographics&&(identical(other.population, population) || other.population == population)&&(identical(other.child0To15Month, child0To15Month) || other.child0To15Month == child0To15Month)&&(identical(other.child0To11Month, child0To11Month) || other.child0To11Month == child0To11Month)&&(identical(other.numberOfSessionsInYear, numberOfSessionsInYear) || other.numberOfSessionsInYear == numberOfSessionsInYear)&&(identical(other.women15To49, women15To49) || other.women15To49 == women15To49)&&const DeepCollectionEquality().equals(other.haVaccinatorDesignation1, haVaccinatorDesignation1)&&const DeepCollectionEquality().equals(other.haVaccinatorName1, haVaccinatorName1)&&const DeepCollectionEquality().equals(other.haVaccinatorDesignation2, haVaccinatorDesignation2)&&const DeepCollectionEquality().equals(other.haVaccinatorName2, haVaccinatorName2)&&const DeepCollectionEquality().equals(other.supervisor1Designation, supervisor1Designation)&&const DeepCollectionEquality().equals(other.supervisor1Name, supervisor1Name)&&const DeepCollectionEquality().equals(other.epiCenterNameAddress, epiCenterNameAddress)&&const DeepCollectionEquality().equals(other.epiCenterImplementerName, epiCenterImplementerName)&&const DeepCollectionEquality().equals(other.distanceFromCcToEpiCenter, distanceFromCcToEpiCenter)&&const DeepCollectionEquality().equals(other.modeOfTransportationDistribution, modeOfTransportationDistribution)&&const DeepCollectionEquality().equals(other.modeOfTransportationUhc, modeOfTransportationUhc)&&const DeepCollectionEquality().equals(other.timeToReachDistributionPoint, timeToReachDistributionPoint)&&const DeepCollectionEquality().equals(other.timeToReachEpiCenter, timeToReachEpiCenter)&&const DeepCollectionEquality().equals(other.porterName, porterName)&&const DeepCollectionEquality().equals(other.porterMobile, porterMobile)&&const DeepCollectionEquality().equals(other.epiCenterType, epiCenterType));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,population,child0To15Month,child0To11Month,numberOfSessionsInYear,women15To49,const DeepCollectionEquality().hash(haVaccinatorDesignation1),const DeepCollectionEquality().hash(haVaccinatorName1),const DeepCollectionEquality().hash(haVaccinatorDesignation2),const DeepCollectionEquality().hash(haVaccinatorName2),const DeepCollectionEquality().hash(supervisor1Designation),const DeepCollectionEquality().hash(supervisor1Name),const DeepCollectionEquality().hash(epiCenterNameAddress),const DeepCollectionEquality().hash(epiCenterImplementerName),const DeepCollectionEquality().hash(distanceFromCcToEpiCenter),const DeepCollectionEquality().hash(modeOfTransportationDistribution),const DeepCollectionEquality().hash(modeOfTransportationUhc),const DeepCollectionEquality().hash(timeToReachDistributionPoint),const DeepCollectionEquality().hash(timeToReachEpiCenter),const DeepCollectionEquality().hash(porterName),const DeepCollectionEquality().hash(porterMobile),const DeepCollectionEquality().hash(epiCenterType)]);

@override
String toString() {
  return 'YearDemographics(population: $population, child0To15Month: $child0To15Month, child0To11Month: $child0To11Month, numberOfSessionsInYear: $numberOfSessionsInYear, women15To49: $women15To49, haVaccinatorDesignation1: $haVaccinatorDesignation1, haVaccinatorName1: $haVaccinatorName1, haVaccinatorDesignation2: $haVaccinatorDesignation2, haVaccinatorName2: $haVaccinatorName2, supervisor1Designation: $supervisor1Designation, supervisor1Name: $supervisor1Name, epiCenterNameAddress: $epiCenterNameAddress, epiCenterImplementerName: $epiCenterImplementerName, distanceFromCcToEpiCenter: $distanceFromCcToEpiCenter, modeOfTransportationDistribution: $modeOfTransportationDistribution, modeOfTransportationUhc: $modeOfTransportationUhc, timeToReachDistributionPoint: $timeToReachDistributionPoint, timeToReachEpiCenter: $timeToReachEpiCenter, porterName: $porterName, porterMobile: $porterMobile, epiCenterType: $epiCenterType)';
}


}

/// @nodoc
abstract mixin class $YearDemographicsCopyWith<$Res>  {
  factory $YearDemographicsCopyWith(YearDemographics value, $Res Function(YearDemographics) _then) = _$YearDemographicsCopyWithImpl;
@useResult
$Res call({
 Population? population,@JsonKey(name: 'child_0_15_month') ChildData? child0To15Month,@JsonKey(name: 'child_0_11_month') ChildData? child0To11Month,@JsonKey(name: 'number_of_sessions_in_year') int? numberOfSessionsInYear,@JsonKey(name: 'women_15_to_49') int? women15To49,@JsonKey(name: 'ha_vaccinator_designation1') dynamic haVaccinatorDesignation1,@JsonKey(name: 'ha_vaccinator_name1') dynamic haVaccinatorName1,@JsonKey(name: 'ha_vaccinator_designation2') dynamic haVaccinatorDesignation2,@JsonKey(name: 'ha_vaccinator_name2') dynamic haVaccinatorName2,@JsonKey(name: 'supervisor1_designation') dynamic supervisor1Designation,@JsonKey(name: 'supervisor1_name') dynamic supervisor1Name,@JsonKey(name: 'epi_center_name_address') dynamic epiCenterNameAddress,@JsonKey(name: 'epi_center_implementer_name') dynamic epiCenterImplementerName,@JsonKey(name: 'distance_from_cc_to_epi_center') dynamic distanceFromCcToEpiCenter,@JsonKey(name: 'mode_of_transportation_distribution') dynamic modeOfTransportationDistribution,@JsonKey(name: 'mode_of_transportation_uhc') dynamic modeOfTransportationUhc,@JsonKey(name: 'time_to_reach_distribution_point') dynamic timeToReachDistributionPoint,@JsonKey(name: 'time_to_reach_epi_center') dynamic timeToReachEpiCenter,@JsonKey(name: 'porter_name') dynamic porterName,@JsonKey(name: 'porter_mobile') dynamic porterMobile,@JsonKey(name: 'epi_center_type') dynamic epiCenterType
});


$PopulationCopyWith<$Res>? get population;$ChildDataCopyWith<$Res>? get child0To15Month;$ChildDataCopyWith<$Res>? get child0To11Month;

}
/// @nodoc
class _$YearDemographicsCopyWithImpl<$Res>
    implements $YearDemographicsCopyWith<$Res> {
  _$YearDemographicsCopyWithImpl(this._self, this._then);

  final YearDemographics _self;
  final $Res Function(YearDemographics) _then;

/// Create a copy of YearDemographics
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? population = freezed,Object? child0To15Month = freezed,Object? child0To11Month = freezed,Object? numberOfSessionsInYear = freezed,Object? women15To49 = freezed,Object? haVaccinatorDesignation1 = freezed,Object? haVaccinatorName1 = freezed,Object? haVaccinatorDesignation2 = freezed,Object? haVaccinatorName2 = freezed,Object? supervisor1Designation = freezed,Object? supervisor1Name = freezed,Object? epiCenterNameAddress = freezed,Object? epiCenterImplementerName = freezed,Object? distanceFromCcToEpiCenter = freezed,Object? modeOfTransportationDistribution = freezed,Object? modeOfTransportationUhc = freezed,Object? timeToReachDistributionPoint = freezed,Object? timeToReachEpiCenter = freezed,Object? porterName = freezed,Object? porterMobile = freezed,Object? epiCenterType = freezed,}) {
  return _then(_self.copyWith(
population: freezed == population ? _self.population : population // ignore: cast_nullable_to_non_nullable
as Population?,child0To15Month: freezed == child0To15Month ? _self.child0To15Month : child0To15Month // ignore: cast_nullable_to_non_nullable
as ChildData?,child0To11Month: freezed == child0To11Month ? _self.child0To11Month : child0To11Month // ignore: cast_nullable_to_non_nullable
as ChildData?,numberOfSessionsInYear: freezed == numberOfSessionsInYear ? _self.numberOfSessionsInYear : numberOfSessionsInYear // ignore: cast_nullable_to_non_nullable
as int?,women15To49: freezed == women15To49 ? _self.women15To49 : women15To49 // ignore: cast_nullable_to_non_nullable
as int?,haVaccinatorDesignation1: freezed == haVaccinatorDesignation1 ? _self.haVaccinatorDesignation1 : haVaccinatorDesignation1 // ignore: cast_nullable_to_non_nullable
as dynamic,haVaccinatorName1: freezed == haVaccinatorName1 ? _self.haVaccinatorName1 : haVaccinatorName1 // ignore: cast_nullable_to_non_nullable
as dynamic,haVaccinatorDesignation2: freezed == haVaccinatorDesignation2 ? _self.haVaccinatorDesignation2 : haVaccinatorDesignation2 // ignore: cast_nullable_to_non_nullable
as dynamic,haVaccinatorName2: freezed == haVaccinatorName2 ? _self.haVaccinatorName2 : haVaccinatorName2 // ignore: cast_nullable_to_non_nullable
as dynamic,supervisor1Designation: freezed == supervisor1Designation ? _self.supervisor1Designation : supervisor1Designation // ignore: cast_nullable_to_non_nullable
as dynamic,supervisor1Name: freezed == supervisor1Name ? _self.supervisor1Name : supervisor1Name // ignore: cast_nullable_to_non_nullable
as dynamic,epiCenterNameAddress: freezed == epiCenterNameAddress ? _self.epiCenterNameAddress : epiCenterNameAddress // ignore: cast_nullable_to_non_nullable
as dynamic,epiCenterImplementerName: freezed == epiCenterImplementerName ? _self.epiCenterImplementerName : epiCenterImplementerName // ignore: cast_nullable_to_non_nullable
as dynamic,distanceFromCcToEpiCenter: freezed == distanceFromCcToEpiCenter ? _self.distanceFromCcToEpiCenter : distanceFromCcToEpiCenter // ignore: cast_nullable_to_non_nullable
as dynamic,modeOfTransportationDistribution: freezed == modeOfTransportationDistribution ? _self.modeOfTransportationDistribution : modeOfTransportationDistribution // ignore: cast_nullable_to_non_nullable
as dynamic,modeOfTransportationUhc: freezed == modeOfTransportationUhc ? _self.modeOfTransportationUhc : modeOfTransportationUhc // ignore: cast_nullable_to_non_nullable
as dynamic,timeToReachDistributionPoint: freezed == timeToReachDistributionPoint ? _self.timeToReachDistributionPoint : timeToReachDistributionPoint // ignore: cast_nullable_to_non_nullable
as dynamic,timeToReachEpiCenter: freezed == timeToReachEpiCenter ? _self.timeToReachEpiCenter : timeToReachEpiCenter // ignore: cast_nullable_to_non_nullable
as dynamic,porterName: freezed == porterName ? _self.porterName : porterName // ignore: cast_nullable_to_non_nullable
as dynamic,porterMobile: freezed == porterMobile ? _self.porterMobile : porterMobile // ignore: cast_nullable_to_non_nullable
as dynamic,epiCenterType: freezed == epiCenterType ? _self.epiCenterType : epiCenterType // ignore: cast_nullable_to_non_nullable
as dynamic,
  ));
}
/// Create a copy of YearDemographics
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PopulationCopyWith<$Res>? get population {
    if (_self.population == null) {
    return null;
  }

  return $PopulationCopyWith<$Res>(_self.population!, (value) {
    return _then(_self.copyWith(population: value));
  });
}/// Create a copy of YearDemographics
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ChildDataCopyWith<$Res>? get child0To15Month {
    if (_self.child0To15Month == null) {
    return null;
  }

  return $ChildDataCopyWith<$Res>(_self.child0To15Month!, (value) {
    return _then(_self.copyWith(child0To15Month: value));
  });
}/// Create a copy of YearDemographics
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ChildDataCopyWith<$Res>? get child0To11Month {
    if (_self.child0To11Month == null) {
    return null;
  }

  return $ChildDataCopyWith<$Res>(_self.child0To11Month!, (value) {
    return _then(_self.copyWith(child0To11Month: value));
  });
}
}


/// Adds pattern-matching-related methods to [YearDemographics].
extension YearDemographicsPatterns on YearDemographics {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _YearDemographics value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _YearDemographics() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _YearDemographics value)  $default,){
final _that = this;
switch (_that) {
case _YearDemographics():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _YearDemographics value)?  $default,){
final _that = this;
switch (_that) {
case _YearDemographics() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Population? population, @JsonKey(name: 'child_0_15_month')  ChildData? child0To15Month, @JsonKey(name: 'child_0_11_month')  ChildData? child0To11Month, @JsonKey(name: 'number_of_sessions_in_year')  int? numberOfSessionsInYear, @JsonKey(name: 'women_15_to_49')  int? women15To49, @JsonKey(name: 'ha_vaccinator_designation1')  dynamic haVaccinatorDesignation1, @JsonKey(name: 'ha_vaccinator_name1')  dynamic haVaccinatorName1, @JsonKey(name: 'ha_vaccinator_designation2')  dynamic haVaccinatorDesignation2, @JsonKey(name: 'ha_vaccinator_name2')  dynamic haVaccinatorName2, @JsonKey(name: 'supervisor1_designation')  dynamic supervisor1Designation, @JsonKey(name: 'supervisor1_name')  dynamic supervisor1Name, @JsonKey(name: 'epi_center_name_address')  dynamic epiCenterNameAddress, @JsonKey(name: 'epi_center_implementer_name')  dynamic epiCenterImplementerName, @JsonKey(name: 'distance_from_cc_to_epi_center')  dynamic distanceFromCcToEpiCenter, @JsonKey(name: 'mode_of_transportation_distribution')  dynamic modeOfTransportationDistribution, @JsonKey(name: 'mode_of_transportation_uhc')  dynamic modeOfTransportationUhc, @JsonKey(name: 'time_to_reach_distribution_point')  dynamic timeToReachDistributionPoint, @JsonKey(name: 'time_to_reach_epi_center')  dynamic timeToReachEpiCenter, @JsonKey(name: 'porter_name')  dynamic porterName, @JsonKey(name: 'porter_mobile')  dynamic porterMobile, @JsonKey(name: 'epi_center_type')  dynamic epiCenterType)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _YearDemographics() when $default != null:
return $default(_that.population,_that.child0To15Month,_that.child0To11Month,_that.numberOfSessionsInYear,_that.women15To49,_that.haVaccinatorDesignation1,_that.haVaccinatorName1,_that.haVaccinatorDesignation2,_that.haVaccinatorName2,_that.supervisor1Designation,_that.supervisor1Name,_that.epiCenterNameAddress,_that.epiCenterImplementerName,_that.distanceFromCcToEpiCenter,_that.modeOfTransportationDistribution,_that.modeOfTransportationUhc,_that.timeToReachDistributionPoint,_that.timeToReachEpiCenter,_that.porterName,_that.porterMobile,_that.epiCenterType);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Population? population, @JsonKey(name: 'child_0_15_month')  ChildData? child0To15Month, @JsonKey(name: 'child_0_11_month')  ChildData? child0To11Month, @JsonKey(name: 'number_of_sessions_in_year')  int? numberOfSessionsInYear, @JsonKey(name: 'women_15_to_49')  int? women15To49, @JsonKey(name: 'ha_vaccinator_designation1')  dynamic haVaccinatorDesignation1, @JsonKey(name: 'ha_vaccinator_name1')  dynamic haVaccinatorName1, @JsonKey(name: 'ha_vaccinator_designation2')  dynamic haVaccinatorDesignation2, @JsonKey(name: 'ha_vaccinator_name2')  dynamic haVaccinatorName2, @JsonKey(name: 'supervisor1_designation')  dynamic supervisor1Designation, @JsonKey(name: 'supervisor1_name')  dynamic supervisor1Name, @JsonKey(name: 'epi_center_name_address')  dynamic epiCenterNameAddress, @JsonKey(name: 'epi_center_implementer_name')  dynamic epiCenterImplementerName, @JsonKey(name: 'distance_from_cc_to_epi_center')  dynamic distanceFromCcToEpiCenter, @JsonKey(name: 'mode_of_transportation_distribution')  dynamic modeOfTransportationDistribution, @JsonKey(name: 'mode_of_transportation_uhc')  dynamic modeOfTransportationUhc, @JsonKey(name: 'time_to_reach_distribution_point')  dynamic timeToReachDistributionPoint, @JsonKey(name: 'time_to_reach_epi_center')  dynamic timeToReachEpiCenter, @JsonKey(name: 'porter_name')  dynamic porterName, @JsonKey(name: 'porter_mobile')  dynamic porterMobile, @JsonKey(name: 'epi_center_type')  dynamic epiCenterType)  $default,) {final _that = this;
switch (_that) {
case _YearDemographics():
return $default(_that.population,_that.child0To15Month,_that.child0To11Month,_that.numberOfSessionsInYear,_that.women15To49,_that.haVaccinatorDesignation1,_that.haVaccinatorName1,_that.haVaccinatorDesignation2,_that.haVaccinatorName2,_that.supervisor1Designation,_that.supervisor1Name,_that.epiCenterNameAddress,_that.epiCenterImplementerName,_that.distanceFromCcToEpiCenter,_that.modeOfTransportationDistribution,_that.modeOfTransportationUhc,_that.timeToReachDistributionPoint,_that.timeToReachEpiCenter,_that.porterName,_that.porterMobile,_that.epiCenterType);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Population? population, @JsonKey(name: 'child_0_15_month')  ChildData? child0To15Month, @JsonKey(name: 'child_0_11_month')  ChildData? child0To11Month, @JsonKey(name: 'number_of_sessions_in_year')  int? numberOfSessionsInYear, @JsonKey(name: 'women_15_to_49')  int? women15To49, @JsonKey(name: 'ha_vaccinator_designation1')  dynamic haVaccinatorDesignation1, @JsonKey(name: 'ha_vaccinator_name1')  dynamic haVaccinatorName1, @JsonKey(name: 'ha_vaccinator_designation2')  dynamic haVaccinatorDesignation2, @JsonKey(name: 'ha_vaccinator_name2')  dynamic haVaccinatorName2, @JsonKey(name: 'supervisor1_designation')  dynamic supervisor1Designation, @JsonKey(name: 'supervisor1_name')  dynamic supervisor1Name, @JsonKey(name: 'epi_center_name_address')  dynamic epiCenterNameAddress, @JsonKey(name: 'epi_center_implementer_name')  dynamic epiCenterImplementerName, @JsonKey(name: 'distance_from_cc_to_epi_center')  dynamic distanceFromCcToEpiCenter, @JsonKey(name: 'mode_of_transportation_distribution')  dynamic modeOfTransportationDistribution, @JsonKey(name: 'mode_of_transportation_uhc')  dynamic modeOfTransportationUhc, @JsonKey(name: 'time_to_reach_distribution_point')  dynamic timeToReachDistributionPoint, @JsonKey(name: 'time_to_reach_epi_center')  dynamic timeToReachEpiCenter, @JsonKey(name: 'porter_name')  dynamic porterName, @JsonKey(name: 'porter_mobile')  dynamic porterMobile, @JsonKey(name: 'epi_center_type')  dynamic epiCenterType)?  $default,) {final _that = this;
switch (_that) {
case _YearDemographics() when $default != null:
return $default(_that.population,_that.child0To15Month,_that.child0To11Month,_that.numberOfSessionsInYear,_that.women15To49,_that.haVaccinatorDesignation1,_that.haVaccinatorName1,_that.haVaccinatorDesignation2,_that.haVaccinatorName2,_that.supervisor1Designation,_that.supervisor1Name,_that.epiCenterNameAddress,_that.epiCenterImplementerName,_that.distanceFromCcToEpiCenter,_that.modeOfTransportationDistribution,_that.modeOfTransportationUhc,_that.timeToReachDistributionPoint,_that.timeToReachEpiCenter,_that.porterName,_that.porterMobile,_that.epiCenterType);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _YearDemographics implements YearDemographics {
  const _YearDemographics({this.population, @JsonKey(name: 'child_0_15_month') this.child0To15Month, @JsonKey(name: 'child_0_11_month') this.child0To11Month, @JsonKey(name: 'number_of_sessions_in_year') this.numberOfSessionsInYear, @JsonKey(name: 'women_15_to_49') this.women15To49, @JsonKey(name: 'ha_vaccinator_designation1') this.haVaccinatorDesignation1, @JsonKey(name: 'ha_vaccinator_name1') this.haVaccinatorName1, @JsonKey(name: 'ha_vaccinator_designation2') this.haVaccinatorDesignation2, @JsonKey(name: 'ha_vaccinator_name2') this.haVaccinatorName2, @JsonKey(name: 'supervisor1_designation') this.supervisor1Designation, @JsonKey(name: 'supervisor1_name') this.supervisor1Name, @JsonKey(name: 'epi_center_name_address') this.epiCenterNameAddress, @JsonKey(name: 'epi_center_implementer_name') this.epiCenterImplementerName, @JsonKey(name: 'distance_from_cc_to_epi_center') this.distanceFromCcToEpiCenter, @JsonKey(name: 'mode_of_transportation_distribution') this.modeOfTransportationDistribution, @JsonKey(name: 'mode_of_transportation_uhc') this.modeOfTransportationUhc, @JsonKey(name: 'time_to_reach_distribution_point') this.timeToReachDistributionPoint, @JsonKey(name: 'time_to_reach_epi_center') this.timeToReachEpiCenter, @JsonKey(name: 'porter_name') this.porterName, @JsonKey(name: 'porter_mobile') this.porterMobile, @JsonKey(name: 'epi_center_type') this.epiCenterType});
  factory _YearDemographics.fromJson(Map<String, dynamic> json) => _$YearDemographicsFromJson(json);

@override final  Population? population;
@override@JsonKey(name: 'child_0_15_month') final  ChildData? child0To15Month;
@override@JsonKey(name: 'child_0_11_month') final  ChildData? child0To11Month;
@override@JsonKey(name: 'number_of_sessions_in_year') final  int? numberOfSessionsInYear;
@override@JsonKey(name: 'women_15_to_49') final  int? women15To49;
@override@JsonKey(name: 'ha_vaccinator_designation1') final  dynamic haVaccinatorDesignation1;
// ✅ Changed to dynamic (can be String or int)
@override@JsonKey(name: 'ha_vaccinator_name1') final  dynamic haVaccinatorName1;
// ✅ Changed to dynamic
@override@JsonKey(name: 'ha_vaccinator_designation2') final  dynamic haVaccinatorDesignation2;
// ✅ Changed to dynamic
@override@JsonKey(name: 'ha_vaccinator_name2') final  dynamic haVaccinatorName2;
// ✅ Changed to dynamic
@override@JsonKey(name: 'supervisor1_designation') final  dynamic supervisor1Designation;
// ✅ Changed to dynamic
@override@JsonKey(name: 'supervisor1_name') final  dynamic supervisor1Name;
// ✅ Changed to dynamic
@override@JsonKey(name: 'epi_center_name_address') final  dynamic epiCenterNameAddress;
// ✅ Changed to dynamic
@override@JsonKey(name: 'epi_center_implementer_name') final  dynamic epiCenterImplementerName;
// ✅ Changed to dynamic
@override@JsonKey(name: 'distance_from_cc_to_epi_center') final  dynamic distanceFromCcToEpiCenter;
@override@JsonKey(name: 'mode_of_transportation_distribution') final  dynamic modeOfTransportationDistribution;
// ✅ Changed to dynamic
@override@JsonKey(name: 'mode_of_transportation_uhc') final  dynamic modeOfTransportationUhc;
// ✅ Changed to dynamic
@override@JsonKey(name: 'time_to_reach_distribution_point') final  dynamic timeToReachDistributionPoint;
// ✅ Changed to dynamic (can be double or int)
@override@JsonKey(name: 'time_to_reach_epi_center') final  dynamic timeToReachEpiCenter;
// ✅ Changed to dynamic
@override@JsonKey(name: 'porter_name') final  dynamic porterName;
// ✅ Changed to dynamic
@override@JsonKey(name: 'porter_mobile') final  dynamic porterMobile;
// ✅ Changed to dynamic (can be very large number)
@override@JsonKey(name: 'epi_center_type') final  dynamic epiCenterType;

/// Create a copy of YearDemographics
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$YearDemographicsCopyWith<_YearDemographics> get copyWith => __$YearDemographicsCopyWithImpl<_YearDemographics>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$YearDemographicsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _YearDemographics&&(identical(other.population, population) || other.population == population)&&(identical(other.child0To15Month, child0To15Month) || other.child0To15Month == child0To15Month)&&(identical(other.child0To11Month, child0To11Month) || other.child0To11Month == child0To11Month)&&(identical(other.numberOfSessionsInYear, numberOfSessionsInYear) || other.numberOfSessionsInYear == numberOfSessionsInYear)&&(identical(other.women15To49, women15To49) || other.women15To49 == women15To49)&&const DeepCollectionEquality().equals(other.haVaccinatorDesignation1, haVaccinatorDesignation1)&&const DeepCollectionEquality().equals(other.haVaccinatorName1, haVaccinatorName1)&&const DeepCollectionEquality().equals(other.haVaccinatorDesignation2, haVaccinatorDesignation2)&&const DeepCollectionEquality().equals(other.haVaccinatorName2, haVaccinatorName2)&&const DeepCollectionEquality().equals(other.supervisor1Designation, supervisor1Designation)&&const DeepCollectionEquality().equals(other.supervisor1Name, supervisor1Name)&&const DeepCollectionEquality().equals(other.epiCenterNameAddress, epiCenterNameAddress)&&const DeepCollectionEquality().equals(other.epiCenterImplementerName, epiCenterImplementerName)&&const DeepCollectionEquality().equals(other.distanceFromCcToEpiCenter, distanceFromCcToEpiCenter)&&const DeepCollectionEquality().equals(other.modeOfTransportationDistribution, modeOfTransportationDistribution)&&const DeepCollectionEquality().equals(other.modeOfTransportationUhc, modeOfTransportationUhc)&&const DeepCollectionEquality().equals(other.timeToReachDistributionPoint, timeToReachDistributionPoint)&&const DeepCollectionEquality().equals(other.timeToReachEpiCenter, timeToReachEpiCenter)&&const DeepCollectionEquality().equals(other.porterName, porterName)&&const DeepCollectionEquality().equals(other.porterMobile, porterMobile)&&const DeepCollectionEquality().equals(other.epiCenterType, epiCenterType));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,population,child0To15Month,child0To11Month,numberOfSessionsInYear,women15To49,const DeepCollectionEquality().hash(haVaccinatorDesignation1),const DeepCollectionEquality().hash(haVaccinatorName1),const DeepCollectionEquality().hash(haVaccinatorDesignation2),const DeepCollectionEquality().hash(haVaccinatorName2),const DeepCollectionEquality().hash(supervisor1Designation),const DeepCollectionEquality().hash(supervisor1Name),const DeepCollectionEquality().hash(epiCenterNameAddress),const DeepCollectionEquality().hash(epiCenterImplementerName),const DeepCollectionEquality().hash(distanceFromCcToEpiCenter),const DeepCollectionEquality().hash(modeOfTransportationDistribution),const DeepCollectionEquality().hash(modeOfTransportationUhc),const DeepCollectionEquality().hash(timeToReachDistributionPoint),const DeepCollectionEquality().hash(timeToReachEpiCenter),const DeepCollectionEquality().hash(porterName),const DeepCollectionEquality().hash(porterMobile),const DeepCollectionEquality().hash(epiCenterType)]);

@override
String toString() {
  return 'YearDemographics(population: $population, child0To15Month: $child0To15Month, child0To11Month: $child0To11Month, numberOfSessionsInYear: $numberOfSessionsInYear, women15To49: $women15To49, haVaccinatorDesignation1: $haVaccinatorDesignation1, haVaccinatorName1: $haVaccinatorName1, haVaccinatorDesignation2: $haVaccinatorDesignation2, haVaccinatorName2: $haVaccinatorName2, supervisor1Designation: $supervisor1Designation, supervisor1Name: $supervisor1Name, epiCenterNameAddress: $epiCenterNameAddress, epiCenterImplementerName: $epiCenterImplementerName, distanceFromCcToEpiCenter: $distanceFromCcToEpiCenter, modeOfTransportationDistribution: $modeOfTransportationDistribution, modeOfTransportationUhc: $modeOfTransportationUhc, timeToReachDistributionPoint: $timeToReachDistributionPoint, timeToReachEpiCenter: $timeToReachEpiCenter, porterName: $porterName, porterMobile: $porterMobile, epiCenterType: $epiCenterType)';
}


}

/// @nodoc
abstract mixin class _$YearDemographicsCopyWith<$Res> implements $YearDemographicsCopyWith<$Res> {
  factory _$YearDemographicsCopyWith(_YearDemographics value, $Res Function(_YearDemographics) _then) = __$YearDemographicsCopyWithImpl;
@override @useResult
$Res call({
 Population? population,@JsonKey(name: 'child_0_15_month') ChildData? child0To15Month,@JsonKey(name: 'child_0_11_month') ChildData? child0To11Month,@JsonKey(name: 'number_of_sessions_in_year') int? numberOfSessionsInYear,@JsonKey(name: 'women_15_to_49') int? women15To49,@JsonKey(name: 'ha_vaccinator_designation1') dynamic haVaccinatorDesignation1,@JsonKey(name: 'ha_vaccinator_name1') dynamic haVaccinatorName1,@JsonKey(name: 'ha_vaccinator_designation2') dynamic haVaccinatorDesignation2,@JsonKey(name: 'ha_vaccinator_name2') dynamic haVaccinatorName2,@JsonKey(name: 'supervisor1_designation') dynamic supervisor1Designation,@JsonKey(name: 'supervisor1_name') dynamic supervisor1Name,@JsonKey(name: 'epi_center_name_address') dynamic epiCenterNameAddress,@JsonKey(name: 'epi_center_implementer_name') dynamic epiCenterImplementerName,@JsonKey(name: 'distance_from_cc_to_epi_center') dynamic distanceFromCcToEpiCenter,@JsonKey(name: 'mode_of_transportation_distribution') dynamic modeOfTransportationDistribution,@JsonKey(name: 'mode_of_transportation_uhc') dynamic modeOfTransportationUhc,@JsonKey(name: 'time_to_reach_distribution_point') dynamic timeToReachDistributionPoint,@JsonKey(name: 'time_to_reach_epi_center') dynamic timeToReachEpiCenter,@JsonKey(name: 'porter_name') dynamic porterName,@JsonKey(name: 'porter_mobile') dynamic porterMobile,@JsonKey(name: 'epi_center_type') dynamic epiCenterType
});


@override $PopulationCopyWith<$Res>? get population;@override $ChildDataCopyWith<$Res>? get child0To15Month;@override $ChildDataCopyWith<$Res>? get child0To11Month;

}
/// @nodoc
class __$YearDemographicsCopyWithImpl<$Res>
    implements _$YearDemographicsCopyWith<$Res> {
  __$YearDemographicsCopyWithImpl(this._self, this._then);

  final _YearDemographics _self;
  final $Res Function(_YearDemographics) _then;

/// Create a copy of YearDemographics
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? population = freezed,Object? child0To15Month = freezed,Object? child0To11Month = freezed,Object? numberOfSessionsInYear = freezed,Object? women15To49 = freezed,Object? haVaccinatorDesignation1 = freezed,Object? haVaccinatorName1 = freezed,Object? haVaccinatorDesignation2 = freezed,Object? haVaccinatorName2 = freezed,Object? supervisor1Designation = freezed,Object? supervisor1Name = freezed,Object? epiCenterNameAddress = freezed,Object? epiCenterImplementerName = freezed,Object? distanceFromCcToEpiCenter = freezed,Object? modeOfTransportationDistribution = freezed,Object? modeOfTransportationUhc = freezed,Object? timeToReachDistributionPoint = freezed,Object? timeToReachEpiCenter = freezed,Object? porterName = freezed,Object? porterMobile = freezed,Object? epiCenterType = freezed,}) {
  return _then(_YearDemographics(
population: freezed == population ? _self.population : population // ignore: cast_nullable_to_non_nullable
as Population?,child0To15Month: freezed == child0To15Month ? _self.child0To15Month : child0To15Month // ignore: cast_nullable_to_non_nullable
as ChildData?,child0To11Month: freezed == child0To11Month ? _self.child0To11Month : child0To11Month // ignore: cast_nullable_to_non_nullable
as ChildData?,numberOfSessionsInYear: freezed == numberOfSessionsInYear ? _self.numberOfSessionsInYear : numberOfSessionsInYear // ignore: cast_nullable_to_non_nullable
as int?,women15To49: freezed == women15To49 ? _self.women15To49 : women15To49 // ignore: cast_nullable_to_non_nullable
as int?,haVaccinatorDesignation1: freezed == haVaccinatorDesignation1 ? _self.haVaccinatorDesignation1 : haVaccinatorDesignation1 // ignore: cast_nullable_to_non_nullable
as dynamic,haVaccinatorName1: freezed == haVaccinatorName1 ? _self.haVaccinatorName1 : haVaccinatorName1 // ignore: cast_nullable_to_non_nullable
as dynamic,haVaccinatorDesignation2: freezed == haVaccinatorDesignation2 ? _self.haVaccinatorDesignation2 : haVaccinatorDesignation2 // ignore: cast_nullable_to_non_nullable
as dynamic,haVaccinatorName2: freezed == haVaccinatorName2 ? _self.haVaccinatorName2 : haVaccinatorName2 // ignore: cast_nullable_to_non_nullable
as dynamic,supervisor1Designation: freezed == supervisor1Designation ? _self.supervisor1Designation : supervisor1Designation // ignore: cast_nullable_to_non_nullable
as dynamic,supervisor1Name: freezed == supervisor1Name ? _self.supervisor1Name : supervisor1Name // ignore: cast_nullable_to_non_nullable
as dynamic,epiCenterNameAddress: freezed == epiCenterNameAddress ? _self.epiCenterNameAddress : epiCenterNameAddress // ignore: cast_nullable_to_non_nullable
as dynamic,epiCenterImplementerName: freezed == epiCenterImplementerName ? _self.epiCenterImplementerName : epiCenterImplementerName // ignore: cast_nullable_to_non_nullable
as dynamic,distanceFromCcToEpiCenter: freezed == distanceFromCcToEpiCenter ? _self.distanceFromCcToEpiCenter : distanceFromCcToEpiCenter // ignore: cast_nullable_to_non_nullable
as dynamic,modeOfTransportationDistribution: freezed == modeOfTransportationDistribution ? _self.modeOfTransportationDistribution : modeOfTransportationDistribution // ignore: cast_nullable_to_non_nullable
as dynamic,modeOfTransportationUhc: freezed == modeOfTransportationUhc ? _self.modeOfTransportationUhc : modeOfTransportationUhc // ignore: cast_nullable_to_non_nullable
as dynamic,timeToReachDistributionPoint: freezed == timeToReachDistributionPoint ? _self.timeToReachDistributionPoint : timeToReachDistributionPoint // ignore: cast_nullable_to_non_nullable
as dynamic,timeToReachEpiCenter: freezed == timeToReachEpiCenter ? _self.timeToReachEpiCenter : timeToReachEpiCenter // ignore: cast_nullable_to_non_nullable
as dynamic,porterName: freezed == porterName ? _self.porterName : porterName // ignore: cast_nullable_to_non_nullable
as dynamic,porterMobile: freezed == porterMobile ? _self.porterMobile : porterMobile // ignore: cast_nullable_to_non_nullable
as dynamic,epiCenterType: freezed == epiCenterType ? _self.epiCenterType : epiCenterType // ignore: cast_nullable_to_non_nullable
as dynamic,
  ));
}

/// Create a copy of YearDemographics
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PopulationCopyWith<$Res>? get population {
    if (_self.population == null) {
    return null;
  }

  return $PopulationCopyWith<$Res>(_self.population!, (value) {
    return _then(_self.copyWith(population: value));
  });
}/// Create a copy of YearDemographics
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ChildDataCopyWith<$Res>? get child0To15Month {
    if (_self.child0To15Month == null) {
    return null;
  }

  return $ChildDataCopyWith<$Res>(_self.child0To15Month!, (value) {
    return _then(_self.copyWith(child0To15Month: value));
  });
}/// Create a copy of YearDemographics
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ChildDataCopyWith<$Res>? get child0To11Month {
    if (_self.child0To11Month == null) {
    return null;
  }

  return $ChildDataCopyWith<$Res>(_self.child0To11Month!, (value) {
    return _then(_self.copyWith(child0To11Month: value));
  });
}
}


/// @nodoc
mixin _$Population {

 int? get female; int? get male;
/// Create a copy of Population
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PopulationCopyWith<Population> get copyWith => _$PopulationCopyWithImpl<Population>(this as Population, _$identity);

  /// Serializes this Population to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Population&&(identical(other.female, female) || other.female == female)&&(identical(other.male, male) || other.male == male));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,female,male);

@override
String toString() {
  return 'Population(female: $female, male: $male)';
}


}

/// @nodoc
abstract mixin class $PopulationCopyWith<$Res>  {
  factory $PopulationCopyWith(Population value, $Res Function(Population) _then) = _$PopulationCopyWithImpl;
@useResult
$Res call({
 int? female, int? male
});




}
/// @nodoc
class _$PopulationCopyWithImpl<$Res>
    implements $PopulationCopyWith<$Res> {
  _$PopulationCopyWithImpl(this._self, this._then);

  final Population _self;
  final $Res Function(Population) _then;

/// Create a copy of Population
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? female = freezed,Object? male = freezed,}) {
  return _then(_self.copyWith(
female: freezed == female ? _self.female : female // ignore: cast_nullable_to_non_nullable
as int?,male: freezed == male ? _self.male : male // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [Population].
extension PopulationPatterns on Population {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Population value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Population() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Population value)  $default,){
final _that = this;
switch (_that) {
case _Population():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Population value)?  $default,){
final _that = this;
switch (_that) {
case _Population() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? female,  int? male)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Population() when $default != null:
return $default(_that.female,_that.male);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? female,  int? male)  $default,) {final _that = this;
switch (_that) {
case _Population():
return $default(_that.female,_that.male);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? female,  int? male)?  $default,) {final _that = this;
switch (_that) {
case _Population() when $default != null:
return $default(_that.female,_that.male);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Population implements Population {
  const _Population({this.female, this.male});
  factory _Population.fromJson(Map<String, dynamic> json) => _$PopulationFromJson(json);

@override final  int? female;
@override final  int? male;

/// Create a copy of Population
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PopulationCopyWith<_Population> get copyWith => __$PopulationCopyWithImpl<_Population>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PopulationToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Population&&(identical(other.female, female) || other.female == female)&&(identical(other.male, male) || other.male == male));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,female,male);

@override
String toString() {
  return 'Population(female: $female, male: $male)';
}


}

/// @nodoc
abstract mixin class _$PopulationCopyWith<$Res> implements $PopulationCopyWith<$Res> {
  factory _$PopulationCopyWith(_Population value, $Res Function(_Population) _then) = __$PopulationCopyWithImpl;
@override @useResult
$Res call({
 int? female, int? male
});




}
/// @nodoc
class __$PopulationCopyWithImpl<$Res>
    implements _$PopulationCopyWith<$Res> {
  __$PopulationCopyWithImpl(this._self, this._then);

  final _Population _self;
  final $Res Function(_Population) _then;

/// Create a copy of Population
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? female = freezed,Object? male = freezed,}) {
  return _then(_Population(
female: freezed == female ? _self.female : female // ignore: cast_nullable_to_non_nullable
as int?,male: freezed == male ? _self.male : male // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$ChildData {

 int? get female; int? get male;
/// Create a copy of ChildData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChildDataCopyWith<ChildData> get copyWith => _$ChildDataCopyWithImpl<ChildData>(this as ChildData, _$identity);

  /// Serializes this ChildData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChildData&&(identical(other.female, female) || other.female == female)&&(identical(other.male, male) || other.male == male));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,female,male);

@override
String toString() {
  return 'ChildData(female: $female, male: $male)';
}


}

/// @nodoc
abstract mixin class $ChildDataCopyWith<$Res>  {
  factory $ChildDataCopyWith(ChildData value, $Res Function(ChildData) _then) = _$ChildDataCopyWithImpl;
@useResult
$Res call({
 int? female, int? male
});




}
/// @nodoc
class _$ChildDataCopyWithImpl<$Res>
    implements $ChildDataCopyWith<$Res> {
  _$ChildDataCopyWithImpl(this._self, this._then);

  final ChildData _self;
  final $Res Function(ChildData) _then;

/// Create a copy of ChildData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? female = freezed,Object? male = freezed,}) {
  return _then(_self.copyWith(
female: freezed == female ? _self.female : female // ignore: cast_nullable_to_non_nullable
as int?,male: freezed == male ? _self.male : male // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [ChildData].
extension ChildDataPatterns on ChildData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChildData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChildData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChildData value)  $default,){
final _that = this;
switch (_that) {
case _ChildData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChildData value)?  $default,){
final _that = this;
switch (_that) {
case _ChildData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? female,  int? male)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChildData() when $default != null:
return $default(_that.female,_that.male);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? female,  int? male)  $default,) {final _that = this;
switch (_that) {
case _ChildData():
return $default(_that.female,_that.male);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? female,  int? male)?  $default,) {final _that = this;
switch (_that) {
case _ChildData() when $default != null:
return $default(_that.female,_that.male);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChildData implements ChildData {
  const _ChildData({this.female, this.male});
  factory _ChildData.fromJson(Map<String, dynamic> json) => _$ChildDataFromJson(json);

@override final  int? female;
@override final  int? male;

/// Create a copy of ChildData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChildDataCopyWith<_ChildData> get copyWith => __$ChildDataCopyWithImpl<_ChildData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChildDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChildData&&(identical(other.female, female) || other.female == female)&&(identical(other.male, male) || other.male == male));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,female,male);

@override
String toString() {
  return 'ChildData(female: $female, male: $male)';
}


}

/// @nodoc
abstract mixin class _$ChildDataCopyWith<$Res> implements $ChildDataCopyWith<$Res> {
  factory _$ChildDataCopyWith(_ChildData value, $Res Function(_ChildData) _then) = __$ChildDataCopyWithImpl;
@override @useResult
$Res call({
 int? female, int? male
});




}
/// @nodoc
class __$ChildDataCopyWithImpl<$Res>
    implements _$ChildDataCopyWith<$Res> {
  __$ChildDataCopyWithImpl(this._self, this._then);

  final _ChildData _self;
  final $Res Function(_ChildData) _then;

/// Create a copy of ChildData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? female = freezed,Object? male = freezed,}) {
  return _then(_ChildData(
female: freezed == female ? _self.female : female // ignore: cast_nullable_to_non_nullable
as int?,male: freezed == male ? _self.male : male // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$Parent {

 int? get id; String? get type; String? get uid; String? get name;@JsonKey(name: 'etracker_name') String? get etrackerName;@JsonKey(name: 'geo_name') String? get geoName;@JsonKey(name: 'parent_uid') String? get parentUid;@JsonKey(name: 'json_file_path') String? get jsonFilePath;@JsonKey(name: 'is_bulk_imported') bool? get isBulkImported;@JsonKey(name: 'vaccine_target') VaccineTarget? get vaccineTarget;@JsonKey(name: 'vaccine_coverage') VaccineCoverage? get vaccineCoverage;@JsonKey(name: 'additional_data') AdditionalData? get additionalData;@JsonKey(name: 'epi_uids') dynamic get epiUids; dynamic get remarks;@JsonKey(name: 'build_at') String? get buildAt;@JsonKey(name: 'created_at') String? get createdAt;@JsonKey(name: 'updated_at') String? get updatedAt; String? get status;
/// Create a copy of Parent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ParentCopyWith<Parent> get copyWith => _$ParentCopyWithImpl<Parent>(this as Parent, _$identity);

  /// Serializes this Parent to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Parent&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.name, name) || other.name == name)&&(identical(other.etrackerName, etrackerName) || other.etrackerName == etrackerName)&&(identical(other.geoName, geoName) || other.geoName == geoName)&&(identical(other.parentUid, parentUid) || other.parentUid == parentUid)&&(identical(other.jsonFilePath, jsonFilePath) || other.jsonFilePath == jsonFilePath)&&(identical(other.isBulkImported, isBulkImported) || other.isBulkImported == isBulkImported)&&(identical(other.vaccineTarget, vaccineTarget) || other.vaccineTarget == vaccineTarget)&&(identical(other.vaccineCoverage, vaccineCoverage) || other.vaccineCoverage == vaccineCoverage)&&(identical(other.additionalData, additionalData) || other.additionalData == additionalData)&&const DeepCollectionEquality().equals(other.epiUids, epiUids)&&const DeepCollectionEquality().equals(other.remarks, remarks)&&(identical(other.buildAt, buildAt) || other.buildAt == buildAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,uid,name,etrackerName,geoName,parentUid,jsonFilePath,isBulkImported,vaccineTarget,vaccineCoverage,additionalData,const DeepCollectionEquality().hash(epiUids),const DeepCollectionEquality().hash(remarks),buildAt,createdAt,updatedAt,status);

@override
String toString() {
  return 'Parent(id: $id, type: $type, uid: $uid, name: $name, etrackerName: $etrackerName, geoName: $geoName, parentUid: $parentUid, jsonFilePath: $jsonFilePath, isBulkImported: $isBulkImported, vaccineTarget: $vaccineTarget, vaccineCoverage: $vaccineCoverage, additionalData: $additionalData, epiUids: $epiUids, remarks: $remarks, buildAt: $buildAt, createdAt: $createdAt, updatedAt: $updatedAt, status: $status)';
}


}

/// @nodoc
abstract mixin class $ParentCopyWith<$Res>  {
  factory $ParentCopyWith(Parent value, $Res Function(Parent) _then) = _$ParentCopyWithImpl;
@useResult
$Res call({
 int? id, String? type, String? uid, String? name,@JsonKey(name: 'etracker_name') String? etrackerName,@JsonKey(name: 'geo_name') String? geoName,@JsonKey(name: 'parent_uid') String? parentUid,@JsonKey(name: 'json_file_path') String? jsonFilePath,@JsonKey(name: 'is_bulk_imported') bool? isBulkImported,@JsonKey(name: 'vaccine_target') VaccineTarget? vaccineTarget,@JsonKey(name: 'vaccine_coverage') VaccineCoverage? vaccineCoverage,@JsonKey(name: 'additional_data') AdditionalData? additionalData,@JsonKey(name: 'epi_uids') dynamic epiUids, dynamic remarks,@JsonKey(name: 'build_at') String? buildAt,@JsonKey(name: 'created_at') String? createdAt,@JsonKey(name: 'updated_at') String? updatedAt, String? status
});


$VaccineTargetCopyWith<$Res>? get vaccineTarget;$VaccineCoverageCopyWith<$Res>? get vaccineCoverage;$AdditionalDataCopyWith<$Res>? get additionalData;

}
/// @nodoc
class _$ParentCopyWithImpl<$Res>
    implements $ParentCopyWith<$Res> {
  _$ParentCopyWithImpl(this._self, this._then);

  final Parent _self;
  final $Res Function(Parent) _then;

/// Create a copy of Parent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? type = freezed,Object? uid = freezed,Object? name = freezed,Object? etrackerName = freezed,Object? geoName = freezed,Object? parentUid = freezed,Object? jsonFilePath = freezed,Object? isBulkImported = freezed,Object? vaccineTarget = freezed,Object? vaccineCoverage = freezed,Object? additionalData = freezed,Object? epiUids = freezed,Object? remarks = freezed,Object? buildAt = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? status = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,uid: freezed == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,etrackerName: freezed == etrackerName ? _self.etrackerName : etrackerName // ignore: cast_nullable_to_non_nullable
as String?,geoName: freezed == geoName ? _self.geoName : geoName // ignore: cast_nullable_to_non_nullable
as String?,parentUid: freezed == parentUid ? _self.parentUid : parentUid // ignore: cast_nullable_to_non_nullable
as String?,jsonFilePath: freezed == jsonFilePath ? _self.jsonFilePath : jsonFilePath // ignore: cast_nullable_to_non_nullable
as String?,isBulkImported: freezed == isBulkImported ? _self.isBulkImported : isBulkImported // ignore: cast_nullable_to_non_nullable
as bool?,vaccineTarget: freezed == vaccineTarget ? _self.vaccineTarget : vaccineTarget // ignore: cast_nullable_to_non_nullable
as VaccineTarget?,vaccineCoverage: freezed == vaccineCoverage ? _self.vaccineCoverage : vaccineCoverage // ignore: cast_nullable_to_non_nullable
as VaccineCoverage?,additionalData: freezed == additionalData ? _self.additionalData : additionalData // ignore: cast_nullable_to_non_nullable
as AdditionalData?,epiUids: freezed == epiUids ? _self.epiUids : epiUids // ignore: cast_nullable_to_non_nullable
as dynamic,remarks: freezed == remarks ? _self.remarks : remarks // ignore: cast_nullable_to_non_nullable
as dynamic,buildAt: freezed == buildAt ? _self.buildAt : buildAt // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of Parent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$VaccineTargetCopyWith<$Res>? get vaccineTarget {
    if (_self.vaccineTarget == null) {
    return null;
  }

  return $VaccineTargetCopyWith<$Res>(_self.vaccineTarget!, (value) {
    return _then(_self.copyWith(vaccineTarget: value));
  });
}/// Create a copy of Parent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$VaccineCoverageCopyWith<$Res>? get vaccineCoverage {
    if (_self.vaccineCoverage == null) {
    return null;
  }

  return $VaccineCoverageCopyWith<$Res>(_self.vaccineCoverage!, (value) {
    return _then(_self.copyWith(vaccineCoverage: value));
  });
}/// Create a copy of Parent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AdditionalDataCopyWith<$Res>? get additionalData {
    if (_self.additionalData == null) {
    return null;
  }

  return $AdditionalDataCopyWith<$Res>(_self.additionalData!, (value) {
    return _then(_self.copyWith(additionalData: value));
  });
}
}


/// Adds pattern-matching-related methods to [Parent].
extension ParentPatterns on Parent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Parent value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Parent() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Parent value)  $default,){
final _that = this;
switch (_that) {
case _Parent():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Parent value)?  $default,){
final _that = this;
switch (_that) {
case _Parent() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? id,  String? type,  String? uid,  String? name, @JsonKey(name: 'etracker_name')  String? etrackerName, @JsonKey(name: 'geo_name')  String? geoName, @JsonKey(name: 'parent_uid')  String? parentUid, @JsonKey(name: 'json_file_path')  String? jsonFilePath, @JsonKey(name: 'is_bulk_imported')  bool? isBulkImported, @JsonKey(name: 'vaccine_target')  VaccineTarget? vaccineTarget, @JsonKey(name: 'vaccine_coverage')  VaccineCoverage? vaccineCoverage, @JsonKey(name: 'additional_data')  AdditionalData? additionalData, @JsonKey(name: 'epi_uids')  dynamic epiUids,  dynamic remarks, @JsonKey(name: 'build_at')  String? buildAt, @JsonKey(name: 'created_at')  String? createdAt, @JsonKey(name: 'updated_at')  String? updatedAt,  String? status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Parent() when $default != null:
return $default(_that.id,_that.type,_that.uid,_that.name,_that.etrackerName,_that.geoName,_that.parentUid,_that.jsonFilePath,_that.isBulkImported,_that.vaccineTarget,_that.vaccineCoverage,_that.additionalData,_that.epiUids,_that.remarks,_that.buildAt,_that.createdAt,_that.updatedAt,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? id,  String? type,  String? uid,  String? name, @JsonKey(name: 'etracker_name')  String? etrackerName, @JsonKey(name: 'geo_name')  String? geoName, @JsonKey(name: 'parent_uid')  String? parentUid, @JsonKey(name: 'json_file_path')  String? jsonFilePath, @JsonKey(name: 'is_bulk_imported')  bool? isBulkImported, @JsonKey(name: 'vaccine_target')  VaccineTarget? vaccineTarget, @JsonKey(name: 'vaccine_coverage')  VaccineCoverage? vaccineCoverage, @JsonKey(name: 'additional_data')  AdditionalData? additionalData, @JsonKey(name: 'epi_uids')  dynamic epiUids,  dynamic remarks, @JsonKey(name: 'build_at')  String? buildAt, @JsonKey(name: 'created_at')  String? createdAt, @JsonKey(name: 'updated_at')  String? updatedAt,  String? status)  $default,) {final _that = this;
switch (_that) {
case _Parent():
return $default(_that.id,_that.type,_that.uid,_that.name,_that.etrackerName,_that.geoName,_that.parentUid,_that.jsonFilePath,_that.isBulkImported,_that.vaccineTarget,_that.vaccineCoverage,_that.additionalData,_that.epiUids,_that.remarks,_that.buildAt,_that.createdAt,_that.updatedAt,_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? id,  String? type,  String? uid,  String? name, @JsonKey(name: 'etracker_name')  String? etrackerName, @JsonKey(name: 'geo_name')  String? geoName, @JsonKey(name: 'parent_uid')  String? parentUid, @JsonKey(name: 'json_file_path')  String? jsonFilePath, @JsonKey(name: 'is_bulk_imported')  bool? isBulkImported, @JsonKey(name: 'vaccine_target')  VaccineTarget? vaccineTarget, @JsonKey(name: 'vaccine_coverage')  VaccineCoverage? vaccineCoverage, @JsonKey(name: 'additional_data')  AdditionalData? additionalData, @JsonKey(name: 'epi_uids')  dynamic epiUids,  dynamic remarks, @JsonKey(name: 'build_at')  String? buildAt, @JsonKey(name: 'created_at')  String? createdAt, @JsonKey(name: 'updated_at')  String? updatedAt,  String? status)?  $default,) {final _that = this;
switch (_that) {
case _Parent() when $default != null:
return $default(_that.id,_that.type,_that.uid,_that.name,_that.etrackerName,_that.geoName,_that.parentUid,_that.jsonFilePath,_that.isBulkImported,_that.vaccineTarget,_that.vaccineCoverage,_that.additionalData,_that.epiUids,_that.remarks,_that.buildAt,_that.createdAt,_that.updatedAt,_that.status);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Parent implements Parent {
  const _Parent({this.id, this.type, this.uid, this.name, @JsonKey(name: 'etracker_name') this.etrackerName, @JsonKey(name: 'geo_name') this.geoName, @JsonKey(name: 'parent_uid') this.parentUid, @JsonKey(name: 'json_file_path') this.jsonFilePath, @JsonKey(name: 'is_bulk_imported') this.isBulkImported, @JsonKey(name: 'vaccine_target') this.vaccineTarget, @JsonKey(name: 'vaccine_coverage') this.vaccineCoverage, @JsonKey(name: 'additional_data') this.additionalData, @JsonKey(name: 'epi_uids') this.epiUids, this.remarks, @JsonKey(name: 'build_at') this.buildAt, @JsonKey(name: 'created_at') this.createdAt, @JsonKey(name: 'updated_at') this.updatedAt, this.status});
  factory _Parent.fromJson(Map<String, dynamic> json) => _$ParentFromJson(json);

@override final  int? id;
@override final  String? type;
@override final  String? uid;
@override final  String? name;
@override@JsonKey(name: 'etracker_name') final  String? etrackerName;
@override@JsonKey(name: 'geo_name') final  String? geoName;
@override@JsonKey(name: 'parent_uid') final  String? parentUid;
@override@JsonKey(name: 'json_file_path') final  String? jsonFilePath;
@override@JsonKey(name: 'is_bulk_imported') final  bool? isBulkImported;
@override@JsonKey(name: 'vaccine_target') final  VaccineTarget? vaccineTarget;
@override@JsonKey(name: 'vaccine_coverage') final  VaccineCoverage? vaccineCoverage;
@override@JsonKey(name: 'additional_data') final  AdditionalData? additionalData;
@override@JsonKey(name: 'epi_uids') final  dynamic epiUids;
@override final  dynamic remarks;
@override@JsonKey(name: 'build_at') final  String? buildAt;
@override@JsonKey(name: 'created_at') final  String? createdAt;
@override@JsonKey(name: 'updated_at') final  String? updatedAt;
@override final  String? status;

/// Create a copy of Parent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ParentCopyWith<_Parent> get copyWith => __$ParentCopyWithImpl<_Parent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ParentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Parent&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.name, name) || other.name == name)&&(identical(other.etrackerName, etrackerName) || other.etrackerName == etrackerName)&&(identical(other.geoName, geoName) || other.geoName == geoName)&&(identical(other.parentUid, parentUid) || other.parentUid == parentUid)&&(identical(other.jsonFilePath, jsonFilePath) || other.jsonFilePath == jsonFilePath)&&(identical(other.isBulkImported, isBulkImported) || other.isBulkImported == isBulkImported)&&(identical(other.vaccineTarget, vaccineTarget) || other.vaccineTarget == vaccineTarget)&&(identical(other.vaccineCoverage, vaccineCoverage) || other.vaccineCoverage == vaccineCoverage)&&(identical(other.additionalData, additionalData) || other.additionalData == additionalData)&&const DeepCollectionEquality().equals(other.epiUids, epiUids)&&const DeepCollectionEquality().equals(other.remarks, remarks)&&(identical(other.buildAt, buildAt) || other.buildAt == buildAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,uid,name,etrackerName,geoName,parentUid,jsonFilePath,isBulkImported,vaccineTarget,vaccineCoverage,additionalData,const DeepCollectionEquality().hash(epiUids),const DeepCollectionEquality().hash(remarks),buildAt,createdAt,updatedAt,status);

@override
String toString() {
  return 'Parent(id: $id, type: $type, uid: $uid, name: $name, etrackerName: $etrackerName, geoName: $geoName, parentUid: $parentUid, jsonFilePath: $jsonFilePath, isBulkImported: $isBulkImported, vaccineTarget: $vaccineTarget, vaccineCoverage: $vaccineCoverage, additionalData: $additionalData, epiUids: $epiUids, remarks: $remarks, buildAt: $buildAt, createdAt: $createdAt, updatedAt: $updatedAt, status: $status)';
}


}

/// @nodoc
abstract mixin class _$ParentCopyWith<$Res> implements $ParentCopyWith<$Res> {
  factory _$ParentCopyWith(_Parent value, $Res Function(_Parent) _then) = __$ParentCopyWithImpl;
@override @useResult
$Res call({
 int? id, String? type, String? uid, String? name,@JsonKey(name: 'etracker_name') String? etrackerName,@JsonKey(name: 'geo_name') String? geoName,@JsonKey(name: 'parent_uid') String? parentUid,@JsonKey(name: 'json_file_path') String? jsonFilePath,@JsonKey(name: 'is_bulk_imported') bool? isBulkImported,@JsonKey(name: 'vaccine_target') VaccineTarget? vaccineTarget,@JsonKey(name: 'vaccine_coverage') VaccineCoverage? vaccineCoverage,@JsonKey(name: 'additional_data') AdditionalData? additionalData,@JsonKey(name: 'epi_uids') dynamic epiUids, dynamic remarks,@JsonKey(name: 'build_at') String? buildAt,@JsonKey(name: 'created_at') String? createdAt,@JsonKey(name: 'updated_at') String? updatedAt, String? status
});


@override $VaccineTargetCopyWith<$Res>? get vaccineTarget;@override $VaccineCoverageCopyWith<$Res>? get vaccineCoverage;@override $AdditionalDataCopyWith<$Res>? get additionalData;

}
/// @nodoc
class __$ParentCopyWithImpl<$Res>
    implements _$ParentCopyWith<$Res> {
  __$ParentCopyWithImpl(this._self, this._then);

  final _Parent _self;
  final $Res Function(_Parent) _then;

/// Create a copy of Parent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? type = freezed,Object? uid = freezed,Object? name = freezed,Object? etrackerName = freezed,Object? geoName = freezed,Object? parentUid = freezed,Object? jsonFilePath = freezed,Object? isBulkImported = freezed,Object? vaccineTarget = freezed,Object? vaccineCoverage = freezed,Object? additionalData = freezed,Object? epiUids = freezed,Object? remarks = freezed,Object? buildAt = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? status = freezed,}) {
  return _then(_Parent(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,uid: freezed == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,etrackerName: freezed == etrackerName ? _self.etrackerName : etrackerName // ignore: cast_nullable_to_non_nullable
as String?,geoName: freezed == geoName ? _self.geoName : geoName // ignore: cast_nullable_to_non_nullable
as String?,parentUid: freezed == parentUid ? _self.parentUid : parentUid // ignore: cast_nullable_to_non_nullable
as String?,jsonFilePath: freezed == jsonFilePath ? _self.jsonFilePath : jsonFilePath // ignore: cast_nullable_to_non_nullable
as String?,isBulkImported: freezed == isBulkImported ? _self.isBulkImported : isBulkImported // ignore: cast_nullable_to_non_nullable
as bool?,vaccineTarget: freezed == vaccineTarget ? _self.vaccineTarget : vaccineTarget // ignore: cast_nullable_to_non_nullable
as VaccineTarget?,vaccineCoverage: freezed == vaccineCoverage ? _self.vaccineCoverage : vaccineCoverage // ignore: cast_nullable_to_non_nullable
as VaccineCoverage?,additionalData: freezed == additionalData ? _self.additionalData : additionalData // ignore: cast_nullable_to_non_nullable
as AdditionalData?,epiUids: freezed == epiUids ? _self.epiUids : epiUids // ignore: cast_nullable_to_non_nullable
as dynamic,remarks: freezed == remarks ? _self.remarks : remarks // ignore: cast_nullable_to_non_nullable
as dynamic,buildAt: freezed == buildAt ? _self.buildAt : buildAt // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of Parent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$VaccineTargetCopyWith<$Res>? get vaccineTarget {
    if (_self.vaccineTarget == null) {
    return null;
  }

  return $VaccineTargetCopyWith<$Res>(_self.vaccineTarget!, (value) {
    return _then(_self.copyWith(vaccineTarget: value));
  });
}/// Create a copy of Parent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$VaccineCoverageCopyWith<$Res>? get vaccineCoverage {
    if (_self.vaccineCoverage == null) {
    return null;
  }

  return $VaccineCoverageCopyWith<$Res>(_self.vaccineCoverage!, (value) {
    return _then(_self.copyWith(vaccineCoverage: value));
  });
}/// Create a copy of Parent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AdditionalDataCopyWith<$Res>? get additionalData {
    if (_self.additionalData == null) {
    return null;
  }

  return $AdditionalDataCopyWith<$Res>(_self.additionalData!, (value) {
    return _then(_self.copyWith(additionalData: value));
  });
}
}


/// @nodoc
mixin _$CoverageTableData {

 Map<String, MonthTableData> get months; TotalTableData? get totals;@JsonKey(name: 'vaccine_names') List<String> get vaccineNames; Targets? get targets;@JsonKey(name: 'coverage_percentages') Map<String, double> get coveragePercentages;
/// Create a copy of CoverageTableData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CoverageTableDataCopyWith<CoverageTableData> get copyWith => _$CoverageTableDataCopyWithImpl<CoverageTableData>(this as CoverageTableData, _$identity);

  /// Serializes this CoverageTableData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CoverageTableData&&const DeepCollectionEquality().equals(other.months, months)&&(identical(other.totals, totals) || other.totals == totals)&&const DeepCollectionEquality().equals(other.vaccineNames, vaccineNames)&&(identical(other.targets, targets) || other.targets == targets)&&const DeepCollectionEquality().equals(other.coveragePercentages, coveragePercentages));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(months),totals,const DeepCollectionEquality().hash(vaccineNames),targets,const DeepCollectionEquality().hash(coveragePercentages));

@override
String toString() {
  return 'CoverageTableData(months: $months, totals: $totals, vaccineNames: $vaccineNames, targets: $targets, coveragePercentages: $coveragePercentages)';
}


}

/// @nodoc
abstract mixin class $CoverageTableDataCopyWith<$Res>  {
  factory $CoverageTableDataCopyWith(CoverageTableData value, $Res Function(CoverageTableData) _then) = _$CoverageTableDataCopyWithImpl;
@useResult
$Res call({
 Map<String, MonthTableData> months, TotalTableData? totals,@JsonKey(name: 'vaccine_names') List<String> vaccineNames, Targets? targets,@JsonKey(name: 'coverage_percentages') Map<String, double> coveragePercentages
});


$TotalTableDataCopyWith<$Res>? get totals;$TargetsCopyWith<$Res>? get targets;

}
/// @nodoc
class _$CoverageTableDataCopyWithImpl<$Res>
    implements $CoverageTableDataCopyWith<$Res> {
  _$CoverageTableDataCopyWithImpl(this._self, this._then);

  final CoverageTableData _self;
  final $Res Function(CoverageTableData) _then;

/// Create a copy of CoverageTableData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? months = null,Object? totals = freezed,Object? vaccineNames = null,Object? targets = freezed,Object? coveragePercentages = null,}) {
  return _then(_self.copyWith(
months: null == months ? _self.months : months // ignore: cast_nullable_to_non_nullable
as Map<String, MonthTableData>,totals: freezed == totals ? _self.totals : totals // ignore: cast_nullable_to_non_nullable
as TotalTableData?,vaccineNames: null == vaccineNames ? _self.vaccineNames : vaccineNames // ignore: cast_nullable_to_non_nullable
as List<String>,targets: freezed == targets ? _self.targets : targets // ignore: cast_nullable_to_non_nullable
as Targets?,coveragePercentages: null == coveragePercentages ? _self.coveragePercentages : coveragePercentages // ignore: cast_nullable_to_non_nullable
as Map<String, double>,
  ));
}
/// Create a copy of CoverageTableData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TotalTableDataCopyWith<$Res>? get totals {
    if (_self.totals == null) {
    return null;
  }

  return $TotalTableDataCopyWith<$Res>(_self.totals!, (value) {
    return _then(_self.copyWith(totals: value));
  });
}/// Create a copy of CoverageTableData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TargetsCopyWith<$Res>? get targets {
    if (_self.targets == null) {
    return null;
  }

  return $TargetsCopyWith<$Res>(_self.targets!, (value) {
    return _then(_self.copyWith(targets: value));
  });
}
}


/// Adds pattern-matching-related methods to [CoverageTableData].
extension CoverageTableDataPatterns on CoverageTableData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CoverageTableData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CoverageTableData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CoverageTableData value)  $default,){
final _that = this;
switch (_that) {
case _CoverageTableData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CoverageTableData value)?  $default,){
final _that = this;
switch (_that) {
case _CoverageTableData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Map<String, MonthTableData> months,  TotalTableData? totals, @JsonKey(name: 'vaccine_names')  List<String> vaccineNames,  Targets? targets, @JsonKey(name: 'coverage_percentages')  Map<String, double> coveragePercentages)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CoverageTableData() when $default != null:
return $default(_that.months,_that.totals,_that.vaccineNames,_that.targets,_that.coveragePercentages);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Map<String, MonthTableData> months,  TotalTableData? totals, @JsonKey(name: 'vaccine_names')  List<String> vaccineNames,  Targets? targets, @JsonKey(name: 'coverage_percentages')  Map<String, double> coveragePercentages)  $default,) {final _that = this;
switch (_that) {
case _CoverageTableData():
return $default(_that.months,_that.totals,_that.vaccineNames,_that.targets,_that.coveragePercentages);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Map<String, MonthTableData> months,  TotalTableData? totals, @JsonKey(name: 'vaccine_names')  List<String> vaccineNames,  Targets? targets, @JsonKey(name: 'coverage_percentages')  Map<String, double> coveragePercentages)?  $default,) {final _that = this;
switch (_that) {
case _CoverageTableData() when $default != null:
return $default(_that.months,_that.totals,_that.vaccineNames,_that.targets,_that.coveragePercentages);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CoverageTableData implements CoverageTableData {
  const _CoverageTableData({final  Map<String, MonthTableData> months = const {}, this.totals, @JsonKey(name: 'vaccine_names') final  List<String> vaccineNames = const [], this.targets, @JsonKey(name: 'coverage_percentages') final  Map<String, double> coveragePercentages = const {}}): _months = months,_vaccineNames = vaccineNames,_coveragePercentages = coveragePercentages;
  factory _CoverageTableData.fromJson(Map<String, dynamic> json) => _$CoverageTableDataFromJson(json);

 final  Map<String, MonthTableData> _months;
@override@JsonKey() Map<String, MonthTableData> get months {
  if (_months is EqualUnmodifiableMapView) return _months;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_months);
}

@override final  TotalTableData? totals;
 final  List<String> _vaccineNames;
@override@JsonKey(name: 'vaccine_names') List<String> get vaccineNames {
  if (_vaccineNames is EqualUnmodifiableListView) return _vaccineNames;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_vaccineNames);
}

@override final  Targets? targets;
 final  Map<String, double> _coveragePercentages;
@override@JsonKey(name: 'coverage_percentages') Map<String, double> get coveragePercentages {
  if (_coveragePercentages is EqualUnmodifiableMapView) return _coveragePercentages;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_coveragePercentages);
}


/// Create a copy of CoverageTableData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CoverageTableDataCopyWith<_CoverageTableData> get copyWith => __$CoverageTableDataCopyWithImpl<_CoverageTableData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CoverageTableDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CoverageTableData&&const DeepCollectionEquality().equals(other._months, _months)&&(identical(other.totals, totals) || other.totals == totals)&&const DeepCollectionEquality().equals(other._vaccineNames, _vaccineNames)&&(identical(other.targets, targets) || other.targets == targets)&&const DeepCollectionEquality().equals(other._coveragePercentages, _coveragePercentages));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_months),totals,const DeepCollectionEquality().hash(_vaccineNames),targets,const DeepCollectionEquality().hash(_coveragePercentages));

@override
String toString() {
  return 'CoverageTableData(months: $months, totals: $totals, vaccineNames: $vaccineNames, targets: $targets, coveragePercentages: $coveragePercentages)';
}


}

/// @nodoc
abstract mixin class _$CoverageTableDataCopyWith<$Res> implements $CoverageTableDataCopyWith<$Res> {
  factory _$CoverageTableDataCopyWith(_CoverageTableData value, $Res Function(_CoverageTableData) _then) = __$CoverageTableDataCopyWithImpl;
@override @useResult
$Res call({
 Map<String, MonthTableData> months, TotalTableData? totals,@JsonKey(name: 'vaccine_names') List<String> vaccineNames, Targets? targets,@JsonKey(name: 'coverage_percentages') Map<String, double> coveragePercentages
});


@override $TotalTableDataCopyWith<$Res>? get totals;@override $TargetsCopyWith<$Res>? get targets;

}
/// @nodoc
class __$CoverageTableDataCopyWithImpl<$Res>
    implements _$CoverageTableDataCopyWith<$Res> {
  __$CoverageTableDataCopyWithImpl(this._self, this._then);

  final _CoverageTableData _self;
  final $Res Function(_CoverageTableData) _then;

/// Create a copy of CoverageTableData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? months = null,Object? totals = freezed,Object? vaccineNames = null,Object? targets = freezed,Object? coveragePercentages = null,}) {
  return _then(_CoverageTableData(
months: null == months ? _self._months : months // ignore: cast_nullable_to_non_nullable
as Map<String, MonthTableData>,totals: freezed == totals ? _self.totals : totals // ignore: cast_nullable_to_non_nullable
as TotalTableData?,vaccineNames: null == vaccineNames ? _self._vaccineNames : vaccineNames // ignore: cast_nullable_to_non_nullable
as List<String>,targets: freezed == targets ? _self.targets : targets // ignore: cast_nullable_to_non_nullable
as Targets?,coveragePercentages: null == coveragePercentages ? _self._coveragePercentages : coveragePercentages // ignore: cast_nullable_to_non_nullable
as Map<String, double>,
  ));
}

/// Create a copy of CoverageTableData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TotalTableDataCopyWith<$Res>? get totals {
    if (_self.totals == null) {
    return null;
  }

  return $TotalTableDataCopyWith<$Res>(_self.totals!, (value) {
    return _then(_self.copyWith(totals: value));
  });
}/// Create a copy of CoverageTableData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TargetsCopyWith<$Res>? get targets {
    if (_self.targets == null) {
    return null;
  }

  return $TargetsCopyWith<$Res>(_self.targets!, (value) {
    return _then(_self.copyWith(targets: value));
  });
}
}


/// @nodoc
mixin _$MonthTableData {

 Map<String, int> get coverages; Map<String, int> get dropouts;
/// Create a copy of MonthTableData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MonthTableDataCopyWith<MonthTableData> get copyWith => _$MonthTableDataCopyWithImpl<MonthTableData>(this as MonthTableData, _$identity);

  /// Serializes this MonthTableData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MonthTableData&&const DeepCollectionEquality().equals(other.coverages, coverages)&&const DeepCollectionEquality().equals(other.dropouts, dropouts));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(coverages),const DeepCollectionEquality().hash(dropouts));

@override
String toString() {
  return 'MonthTableData(coverages: $coverages, dropouts: $dropouts)';
}


}

/// @nodoc
abstract mixin class $MonthTableDataCopyWith<$Res>  {
  factory $MonthTableDataCopyWith(MonthTableData value, $Res Function(MonthTableData) _then) = _$MonthTableDataCopyWithImpl;
@useResult
$Res call({
 Map<String, int> coverages, Map<String, int> dropouts
});




}
/// @nodoc
class _$MonthTableDataCopyWithImpl<$Res>
    implements $MonthTableDataCopyWith<$Res> {
  _$MonthTableDataCopyWithImpl(this._self, this._then);

  final MonthTableData _self;
  final $Res Function(MonthTableData) _then;

/// Create a copy of MonthTableData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? coverages = null,Object? dropouts = null,}) {
  return _then(_self.copyWith(
coverages: null == coverages ? _self.coverages : coverages // ignore: cast_nullable_to_non_nullable
as Map<String, int>,dropouts: null == dropouts ? _self.dropouts : dropouts // ignore: cast_nullable_to_non_nullable
as Map<String, int>,
  ));
}

}


/// Adds pattern-matching-related methods to [MonthTableData].
extension MonthTableDataPatterns on MonthTableData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MonthTableData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MonthTableData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MonthTableData value)  $default,){
final _that = this;
switch (_that) {
case _MonthTableData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MonthTableData value)?  $default,){
final _that = this;
switch (_that) {
case _MonthTableData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Map<String, int> coverages,  Map<String, int> dropouts)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MonthTableData() when $default != null:
return $default(_that.coverages,_that.dropouts);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Map<String, int> coverages,  Map<String, int> dropouts)  $default,) {final _that = this;
switch (_that) {
case _MonthTableData():
return $default(_that.coverages,_that.dropouts);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Map<String, int> coverages,  Map<String, int> dropouts)?  $default,) {final _that = this;
switch (_that) {
case _MonthTableData() when $default != null:
return $default(_that.coverages,_that.dropouts);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MonthTableData implements MonthTableData {
  const _MonthTableData({final  Map<String, int> coverages = const {}, final  Map<String, int> dropouts = const {}}): _coverages = coverages,_dropouts = dropouts;
  factory _MonthTableData.fromJson(Map<String, dynamic> json) => _$MonthTableDataFromJson(json);

 final  Map<String, int> _coverages;
@override@JsonKey() Map<String, int> get coverages {
  if (_coverages is EqualUnmodifiableMapView) return _coverages;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_coverages);
}

 final  Map<String, int> _dropouts;
@override@JsonKey() Map<String, int> get dropouts {
  if (_dropouts is EqualUnmodifiableMapView) return _dropouts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_dropouts);
}


/// Create a copy of MonthTableData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MonthTableDataCopyWith<_MonthTableData> get copyWith => __$MonthTableDataCopyWithImpl<_MonthTableData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MonthTableDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MonthTableData&&const DeepCollectionEquality().equals(other._coverages, _coverages)&&const DeepCollectionEquality().equals(other._dropouts, _dropouts));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_coverages),const DeepCollectionEquality().hash(_dropouts));

@override
String toString() {
  return 'MonthTableData(coverages: $coverages, dropouts: $dropouts)';
}


}

/// @nodoc
abstract mixin class _$MonthTableDataCopyWith<$Res> implements $MonthTableDataCopyWith<$Res> {
  factory _$MonthTableDataCopyWith(_MonthTableData value, $Res Function(_MonthTableData) _then) = __$MonthTableDataCopyWithImpl;
@override @useResult
$Res call({
 Map<String, int> coverages, Map<String, int> dropouts
});




}
/// @nodoc
class __$MonthTableDataCopyWithImpl<$Res>
    implements _$MonthTableDataCopyWith<$Res> {
  __$MonthTableDataCopyWithImpl(this._self, this._then);

  final _MonthTableData _self;
  final $Res Function(_MonthTableData) _then;

/// Create a copy of MonthTableData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? coverages = null,Object? dropouts = null,}) {
  return _then(_MonthTableData(
coverages: null == coverages ? _self._coverages : coverages // ignore: cast_nullable_to_non_nullable
as Map<String, int>,dropouts: null == dropouts ? _self._dropouts : dropouts // ignore: cast_nullable_to_non_nullable
as Map<String, int>,
  ));
}


}


/// @nodoc
mixin _$TotalTableData {

 Map<String, int> get coverages; Map<String, int> get dropouts;
/// Create a copy of TotalTableData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TotalTableDataCopyWith<TotalTableData> get copyWith => _$TotalTableDataCopyWithImpl<TotalTableData>(this as TotalTableData, _$identity);

  /// Serializes this TotalTableData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TotalTableData&&const DeepCollectionEquality().equals(other.coverages, coverages)&&const DeepCollectionEquality().equals(other.dropouts, dropouts));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(coverages),const DeepCollectionEquality().hash(dropouts));

@override
String toString() {
  return 'TotalTableData(coverages: $coverages, dropouts: $dropouts)';
}


}

/// @nodoc
abstract mixin class $TotalTableDataCopyWith<$Res>  {
  factory $TotalTableDataCopyWith(TotalTableData value, $Res Function(TotalTableData) _then) = _$TotalTableDataCopyWithImpl;
@useResult
$Res call({
 Map<String, int> coverages, Map<String, int> dropouts
});




}
/// @nodoc
class _$TotalTableDataCopyWithImpl<$Res>
    implements $TotalTableDataCopyWith<$Res> {
  _$TotalTableDataCopyWithImpl(this._self, this._then);

  final TotalTableData _self;
  final $Res Function(TotalTableData) _then;

/// Create a copy of TotalTableData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? coverages = null,Object? dropouts = null,}) {
  return _then(_self.copyWith(
coverages: null == coverages ? _self.coverages : coverages // ignore: cast_nullable_to_non_nullable
as Map<String, int>,dropouts: null == dropouts ? _self.dropouts : dropouts // ignore: cast_nullable_to_non_nullable
as Map<String, int>,
  ));
}

}


/// Adds pattern-matching-related methods to [TotalTableData].
extension TotalTableDataPatterns on TotalTableData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TotalTableData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TotalTableData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TotalTableData value)  $default,){
final _that = this;
switch (_that) {
case _TotalTableData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TotalTableData value)?  $default,){
final _that = this;
switch (_that) {
case _TotalTableData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Map<String, int> coverages,  Map<String, int> dropouts)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TotalTableData() when $default != null:
return $default(_that.coverages,_that.dropouts);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Map<String, int> coverages,  Map<String, int> dropouts)  $default,) {final _that = this;
switch (_that) {
case _TotalTableData():
return $default(_that.coverages,_that.dropouts);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Map<String, int> coverages,  Map<String, int> dropouts)?  $default,) {final _that = this;
switch (_that) {
case _TotalTableData() when $default != null:
return $default(_that.coverages,_that.dropouts);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TotalTableData implements TotalTableData {
  const _TotalTableData({final  Map<String, int> coverages = const {}, final  Map<String, int> dropouts = const {}}): _coverages = coverages,_dropouts = dropouts;
  factory _TotalTableData.fromJson(Map<String, dynamic> json) => _$TotalTableDataFromJson(json);

 final  Map<String, int> _coverages;
@override@JsonKey() Map<String, int> get coverages {
  if (_coverages is EqualUnmodifiableMapView) return _coverages;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_coverages);
}

 final  Map<String, int> _dropouts;
@override@JsonKey() Map<String, int> get dropouts {
  if (_dropouts is EqualUnmodifiableMapView) return _dropouts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_dropouts);
}


/// Create a copy of TotalTableData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TotalTableDataCopyWith<_TotalTableData> get copyWith => __$TotalTableDataCopyWithImpl<_TotalTableData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TotalTableDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TotalTableData&&const DeepCollectionEquality().equals(other._coverages, _coverages)&&const DeepCollectionEquality().equals(other._dropouts, _dropouts));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_coverages),const DeepCollectionEquality().hash(_dropouts));

@override
String toString() {
  return 'TotalTableData(coverages: $coverages, dropouts: $dropouts)';
}


}

/// @nodoc
abstract mixin class _$TotalTableDataCopyWith<$Res> implements $TotalTableDataCopyWith<$Res> {
  factory _$TotalTableDataCopyWith(_TotalTableData value, $Res Function(_TotalTableData) _then) = __$TotalTableDataCopyWithImpl;
@override @useResult
$Res call({
 Map<String, int> coverages, Map<String, int> dropouts
});




}
/// @nodoc
class __$TotalTableDataCopyWithImpl<$Res>
    implements _$TotalTableDataCopyWith<$Res> {
  __$TotalTableDataCopyWithImpl(this._self, this._then);

  final _TotalTableData _self;
  final $Res Function(_TotalTableData) _then;

/// Create a copy of TotalTableData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? coverages = null,Object? dropouts = null,}) {
  return _then(_TotalTableData(
coverages: null == coverages ? _self._coverages : coverages // ignore: cast_nullable_to_non_nullable
as Map<String, int>,dropouts: null == dropouts ? _self._dropouts : dropouts // ignore: cast_nullable_to_non_nullable
as Map<String, int>,
  ));
}


}


/// @nodoc
mixin _$Targets {

 int? get year; int? get month;
/// Create a copy of Targets
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TargetsCopyWith<Targets> get copyWith => _$TargetsCopyWithImpl<Targets>(this as Targets, _$identity);

  /// Serializes this Targets to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Targets&&(identical(other.year, year) || other.year == year)&&(identical(other.month, month) || other.month == month));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,year,month);

@override
String toString() {
  return 'Targets(year: $year, month: $month)';
}


}

/// @nodoc
abstract mixin class $TargetsCopyWith<$Res>  {
  factory $TargetsCopyWith(Targets value, $Res Function(Targets) _then) = _$TargetsCopyWithImpl;
@useResult
$Res call({
 int? year, int? month
});




}
/// @nodoc
class _$TargetsCopyWithImpl<$Res>
    implements $TargetsCopyWith<$Res> {
  _$TargetsCopyWithImpl(this._self, this._then);

  final Targets _self;
  final $Res Function(Targets) _then;

/// Create a copy of Targets
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? year = freezed,Object? month = freezed,}) {
  return _then(_self.copyWith(
year: freezed == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int?,month: freezed == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [Targets].
extension TargetsPatterns on Targets {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Targets value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Targets() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Targets value)  $default,){
final _that = this;
switch (_that) {
case _Targets():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Targets value)?  $default,){
final _that = this;
switch (_that) {
case _Targets() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? year,  int? month)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Targets() when $default != null:
return $default(_that.year,_that.month);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? year,  int? month)  $default,) {final _that = this;
switch (_that) {
case _Targets():
return $default(_that.year,_that.month);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? year,  int? month)?  $default,) {final _that = this;
switch (_that) {
case _Targets() when $default != null:
return $default(_that.year,_that.month);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Targets implements Targets {
  const _Targets({this.year, this.month});
  factory _Targets.fromJson(Map<String, dynamic> json) => _$TargetsFromJson(json);

@override final  int? year;
@override final  int? month;

/// Create a copy of Targets
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TargetsCopyWith<_Targets> get copyWith => __$TargetsCopyWithImpl<_Targets>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TargetsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Targets&&(identical(other.year, year) || other.year == year)&&(identical(other.month, month) || other.month == month));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,year,month);

@override
String toString() {
  return 'Targets(year: $year, month: $month)';
}


}

/// @nodoc
abstract mixin class _$TargetsCopyWith<$Res> implements $TargetsCopyWith<$Res> {
  factory _$TargetsCopyWith(_Targets value, $Res Function(_Targets) _then) = __$TargetsCopyWithImpl;
@override @useResult
$Res call({
 int? year, int? month
});




}
/// @nodoc
class __$TargetsCopyWithImpl<$Res>
    implements _$TargetsCopyWith<$Res> {
  __$TargetsCopyWithImpl(this._self, this._then);

  final _Targets _self;
  final $Res Function(_Targets) _then;

/// Create a copy of Targets
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? year = freezed,Object? month = freezed,}) {
  return _then(_Targets(
year: freezed == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int?,month: freezed == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$ChartData {

 List<String> get labels; List<Dataset> get datasets;
/// Create a copy of ChartData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChartDataCopyWith<ChartData> get copyWith => _$ChartDataCopyWithImpl<ChartData>(this as ChartData, _$identity);

  /// Serializes this ChartData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChartData&&const DeepCollectionEquality().equals(other.labels, labels)&&const DeepCollectionEquality().equals(other.datasets, datasets));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(labels),const DeepCollectionEquality().hash(datasets));

@override
String toString() {
  return 'ChartData(labels: $labels, datasets: $datasets)';
}


}

/// @nodoc
abstract mixin class $ChartDataCopyWith<$Res>  {
  factory $ChartDataCopyWith(ChartData value, $Res Function(ChartData) _then) = _$ChartDataCopyWithImpl;
@useResult
$Res call({
 List<String> labels, List<Dataset> datasets
});




}
/// @nodoc
class _$ChartDataCopyWithImpl<$Res>
    implements $ChartDataCopyWith<$Res> {
  _$ChartDataCopyWithImpl(this._self, this._then);

  final ChartData _self;
  final $Res Function(ChartData) _then;

/// Create a copy of ChartData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? labels = null,Object? datasets = null,}) {
  return _then(_self.copyWith(
labels: null == labels ? _self.labels : labels // ignore: cast_nullable_to_non_nullable
as List<String>,datasets: null == datasets ? _self.datasets : datasets // ignore: cast_nullable_to_non_nullable
as List<Dataset>,
  ));
}

}


/// Adds pattern-matching-related methods to [ChartData].
extension ChartDataPatterns on ChartData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChartData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChartData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChartData value)  $default,){
final _that = this;
switch (_that) {
case _ChartData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChartData value)?  $default,){
final _that = this;
switch (_that) {
case _ChartData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<String> labels,  List<Dataset> datasets)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChartData() when $default != null:
return $default(_that.labels,_that.datasets);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<String> labels,  List<Dataset> datasets)  $default,) {final _that = this;
switch (_that) {
case _ChartData():
return $default(_that.labels,_that.datasets);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<String> labels,  List<Dataset> datasets)?  $default,) {final _that = this;
switch (_that) {
case _ChartData() when $default != null:
return $default(_that.labels,_that.datasets);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChartData implements ChartData {
  const _ChartData({final  List<String> labels = const [], final  List<Dataset> datasets = const []}): _labels = labels,_datasets = datasets;
  factory _ChartData.fromJson(Map<String, dynamic> json) => _$ChartDataFromJson(json);

 final  List<String> _labels;
@override@JsonKey() List<String> get labels {
  if (_labels is EqualUnmodifiableListView) return _labels;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_labels);
}

 final  List<Dataset> _datasets;
@override@JsonKey() List<Dataset> get datasets {
  if (_datasets is EqualUnmodifiableListView) return _datasets;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_datasets);
}


/// Create a copy of ChartData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChartDataCopyWith<_ChartData> get copyWith => __$ChartDataCopyWithImpl<_ChartData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChartDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChartData&&const DeepCollectionEquality().equals(other._labels, _labels)&&const DeepCollectionEquality().equals(other._datasets, _datasets));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_labels),const DeepCollectionEquality().hash(_datasets));

@override
String toString() {
  return 'ChartData(labels: $labels, datasets: $datasets)';
}


}

/// @nodoc
abstract mixin class _$ChartDataCopyWith<$Res> implements $ChartDataCopyWith<$Res> {
  factory _$ChartDataCopyWith(_ChartData value, $Res Function(_ChartData) _then) = __$ChartDataCopyWithImpl;
@override @useResult
$Res call({
 List<String> labels, List<Dataset> datasets
});




}
/// @nodoc
class __$ChartDataCopyWithImpl<$Res>
    implements _$ChartDataCopyWith<$Res> {
  __$ChartDataCopyWithImpl(this._self, this._then);

  final _ChartData _self;
  final $Res Function(_ChartData) _then;

/// Create a copy of ChartData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? labels = null,Object? datasets = null,}) {
  return _then(_ChartData(
labels: null == labels ? _self._labels : labels // ignore: cast_nullable_to_non_nullable
as List<String>,datasets: null == datasets ? _self._datasets : datasets // ignore: cast_nullable_to_non_nullable
as List<Dataset>,
  ));
}


}


/// @nodoc
mixin _$Dataset {

 String? get label; List<int?> get data; String? get borderColor; String? get backgroundColor; int? get borderWidth; List<int?> get borderDash; int? get pointRadius; double? get tension;
/// Create a copy of Dataset
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DatasetCopyWith<Dataset> get copyWith => _$DatasetCopyWithImpl<Dataset>(this as Dataset, _$identity);

  /// Serializes this Dataset to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Dataset&&(identical(other.label, label) || other.label == label)&&const DeepCollectionEquality().equals(other.data, data)&&(identical(other.borderColor, borderColor) || other.borderColor == borderColor)&&(identical(other.backgroundColor, backgroundColor) || other.backgroundColor == backgroundColor)&&(identical(other.borderWidth, borderWidth) || other.borderWidth == borderWidth)&&const DeepCollectionEquality().equals(other.borderDash, borderDash)&&(identical(other.pointRadius, pointRadius) || other.pointRadius == pointRadius)&&(identical(other.tension, tension) || other.tension == tension));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,label,const DeepCollectionEquality().hash(data),borderColor,backgroundColor,borderWidth,const DeepCollectionEquality().hash(borderDash),pointRadius,tension);

@override
String toString() {
  return 'Dataset(label: $label, data: $data, borderColor: $borderColor, backgroundColor: $backgroundColor, borderWidth: $borderWidth, borderDash: $borderDash, pointRadius: $pointRadius, tension: $tension)';
}


}

/// @nodoc
abstract mixin class $DatasetCopyWith<$Res>  {
  factory $DatasetCopyWith(Dataset value, $Res Function(Dataset) _then) = _$DatasetCopyWithImpl;
@useResult
$Res call({
 String? label, List<int?> data, String? borderColor, String? backgroundColor, int? borderWidth, List<int?> borderDash, int? pointRadius, double? tension
});




}
/// @nodoc
class _$DatasetCopyWithImpl<$Res>
    implements $DatasetCopyWith<$Res> {
  _$DatasetCopyWithImpl(this._self, this._then);

  final Dataset _self;
  final $Res Function(Dataset) _then;

/// Create a copy of Dataset
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? label = freezed,Object? data = null,Object? borderColor = freezed,Object? backgroundColor = freezed,Object? borderWidth = freezed,Object? borderDash = null,Object? pointRadius = freezed,Object? tension = freezed,}) {
  return _then(_self.copyWith(
label: freezed == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String?,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as List<int?>,borderColor: freezed == borderColor ? _self.borderColor : borderColor // ignore: cast_nullable_to_non_nullable
as String?,backgroundColor: freezed == backgroundColor ? _self.backgroundColor : backgroundColor // ignore: cast_nullable_to_non_nullable
as String?,borderWidth: freezed == borderWidth ? _self.borderWidth : borderWidth // ignore: cast_nullable_to_non_nullable
as int?,borderDash: null == borderDash ? _self.borderDash : borderDash // ignore: cast_nullable_to_non_nullable
as List<int?>,pointRadius: freezed == pointRadius ? _self.pointRadius : pointRadius // ignore: cast_nullable_to_non_nullable
as int?,tension: freezed == tension ? _self.tension : tension // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [Dataset].
extension DatasetPatterns on Dataset {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Dataset value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Dataset() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Dataset value)  $default,){
final _that = this;
switch (_that) {
case _Dataset():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Dataset value)?  $default,){
final _that = this;
switch (_that) {
case _Dataset() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? label,  List<int?> data,  String? borderColor,  String? backgroundColor,  int? borderWidth,  List<int?> borderDash,  int? pointRadius,  double? tension)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Dataset() when $default != null:
return $default(_that.label,_that.data,_that.borderColor,_that.backgroundColor,_that.borderWidth,_that.borderDash,_that.pointRadius,_that.tension);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? label,  List<int?> data,  String? borderColor,  String? backgroundColor,  int? borderWidth,  List<int?> borderDash,  int? pointRadius,  double? tension)  $default,) {final _that = this;
switch (_that) {
case _Dataset():
return $default(_that.label,_that.data,_that.borderColor,_that.backgroundColor,_that.borderWidth,_that.borderDash,_that.pointRadius,_that.tension);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? label,  List<int?> data,  String? borderColor,  String? backgroundColor,  int? borderWidth,  List<int?> borderDash,  int? pointRadius,  double? tension)?  $default,) {final _that = this;
switch (_that) {
case _Dataset() when $default != null:
return $default(_that.label,_that.data,_that.borderColor,_that.backgroundColor,_that.borderWidth,_that.borderDash,_that.pointRadius,_that.tension);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Dataset implements Dataset {
  const _Dataset({this.label, final  List<int?> data = const [], this.borderColor, this.backgroundColor, this.borderWidth, final  List<int?> borderDash = const [], this.pointRadius, this.tension}): _data = data,_borderDash = borderDash;
  factory _Dataset.fromJson(Map<String, dynamic> json) => _$DatasetFromJson(json);

@override final  String? label;
 final  List<int?> _data;
@override@JsonKey() List<int?> get data {
  if (_data is EqualUnmodifiableListView) return _data;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_data);
}

@override final  String? borderColor;
@override final  String? backgroundColor;
@override final  int? borderWidth;
 final  List<int?> _borderDash;
@override@JsonKey() List<int?> get borderDash {
  if (_borderDash is EqualUnmodifiableListView) return _borderDash;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_borderDash);
}

@override final  int? pointRadius;
@override final  double? tension;

/// Create a copy of Dataset
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DatasetCopyWith<_Dataset> get copyWith => __$DatasetCopyWithImpl<_Dataset>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DatasetToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Dataset&&(identical(other.label, label) || other.label == label)&&const DeepCollectionEquality().equals(other._data, _data)&&(identical(other.borderColor, borderColor) || other.borderColor == borderColor)&&(identical(other.backgroundColor, backgroundColor) || other.backgroundColor == backgroundColor)&&(identical(other.borderWidth, borderWidth) || other.borderWidth == borderWidth)&&const DeepCollectionEquality().equals(other._borderDash, _borderDash)&&(identical(other.pointRadius, pointRadius) || other.pointRadius == pointRadius)&&(identical(other.tension, tension) || other.tension == tension));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,label,const DeepCollectionEquality().hash(_data),borderColor,backgroundColor,borderWidth,const DeepCollectionEquality().hash(_borderDash),pointRadius,tension);

@override
String toString() {
  return 'Dataset(label: $label, data: $data, borderColor: $borderColor, backgroundColor: $backgroundColor, borderWidth: $borderWidth, borderDash: $borderDash, pointRadius: $pointRadius, tension: $tension)';
}


}

/// @nodoc
abstract mixin class _$DatasetCopyWith<$Res> implements $DatasetCopyWith<$Res> {
  factory _$DatasetCopyWith(_Dataset value, $Res Function(_Dataset) _then) = __$DatasetCopyWithImpl;
@override @useResult
$Res call({
 String? label, List<int?> data, String? borderColor, String? backgroundColor, int? borderWidth, List<int?> borderDash, int? pointRadius, double? tension
});




}
/// @nodoc
class __$DatasetCopyWithImpl<$Res>
    implements _$DatasetCopyWith<$Res> {
  __$DatasetCopyWithImpl(this._self, this._then);

  final _Dataset _self;
  final $Res Function(_Dataset) _then;

/// Create a copy of Dataset
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? label = freezed,Object? data = null,Object? borderColor = freezed,Object? backgroundColor = freezed,Object? borderWidth = freezed,Object? borderDash = null,Object? pointRadius = freezed,Object? tension = freezed,}) {
  return _then(_Dataset(
label: freezed == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String?,data: null == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as List<int?>,borderColor: freezed == borderColor ? _self.borderColor : borderColor // ignore: cast_nullable_to_non_nullable
as String?,backgroundColor: freezed == backgroundColor ? _self.backgroundColor : backgroundColor // ignore: cast_nullable_to_non_nullable
as String?,borderWidth: freezed == borderWidth ? _self.borderWidth : borderWidth // ignore: cast_nullable_to_non_nullable
as int?,borderDash: null == borderDash ? _self._borderDash : borderDash // ignore: cast_nullable_to_non_nullable
as List<int?>,pointRadius: freezed == pointRadius ? _self.pointRadius : pointRadius // ignore: cast_nullable_to_non_nullable
as int?,tension: freezed == tension ? _self.tension : tension // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}


/// @nodoc
mixin _$Subblock {

 String? get uid; String? get name;
/// Create a copy of Subblock
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SubblockCopyWith<Subblock> get copyWith => _$SubblockCopyWithImpl<Subblock>(this as Subblock, _$identity);

  /// Serializes this Subblock to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Subblock&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,uid,name);

@override
String toString() {
  return 'Subblock(uid: $uid, name: $name)';
}


}

/// @nodoc
abstract mixin class $SubblockCopyWith<$Res>  {
  factory $SubblockCopyWith(Subblock value, $Res Function(Subblock) _then) = _$SubblockCopyWithImpl;
@useResult
$Res call({
 String? uid, String? name
});




}
/// @nodoc
class _$SubblockCopyWithImpl<$Res>
    implements $SubblockCopyWith<$Res> {
  _$SubblockCopyWithImpl(this._self, this._then);

  final Subblock _self;
  final $Res Function(Subblock) _then;

/// Create a copy of Subblock
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? uid = freezed,Object? name = freezed,}) {
  return _then(_self.copyWith(
uid: freezed == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Subblock].
extension SubblockPatterns on Subblock {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Subblock value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Subblock() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Subblock value)  $default,){
final _that = this;
switch (_that) {
case _Subblock():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Subblock value)?  $default,){
final _that = this;
switch (_that) {
case _Subblock() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? uid,  String? name)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Subblock() when $default != null:
return $default(_that.uid,_that.name);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? uid,  String? name)  $default,) {final _that = this;
switch (_that) {
case _Subblock():
return $default(_that.uid,_that.name);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? uid,  String? name)?  $default,) {final _that = this;
switch (_that) {
case _Subblock() when $default != null:
return $default(_that.uid,_that.name);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Subblock implements Subblock {
  const _Subblock({this.uid, this.name});
  factory _Subblock.fromJson(Map<String, dynamic> json) => _$SubblockFromJson(json);

@override final  String? uid;
@override final  String? name;

/// Create a copy of Subblock
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SubblockCopyWith<_Subblock> get copyWith => __$SubblockCopyWithImpl<_Subblock>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SubblockToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Subblock&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,uid,name);

@override
String toString() {
  return 'Subblock(uid: $uid, name: $name)';
}


}

/// @nodoc
abstract mixin class _$SubblockCopyWith<$Res> implements $SubblockCopyWith<$Res> {
  factory _$SubblockCopyWith(_Subblock value, $Res Function(_Subblock) _then) = __$SubblockCopyWithImpl;
@override @useResult
$Res call({
 String? uid, String? name
});




}
/// @nodoc
class __$SubblockCopyWithImpl<$Res>
    implements _$SubblockCopyWith<$Res> {
  __$SubblockCopyWithImpl(this._self, this._then);

  final _Subblock _self;
  final $Res Function(_Subblock) _then;

/// Create a copy of Subblock
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? uid = freezed,Object? name = freezed,}) {
  return _then(_Subblock(
uid: freezed == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$Ward {

 String? get uid; String? get name;
/// Create a copy of Ward
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WardCopyWith<Ward> get copyWith => _$WardCopyWithImpl<Ward>(this as Ward, _$identity);

  /// Serializes this Ward to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Ward&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,uid,name);

@override
String toString() {
  return 'Ward(uid: $uid, name: $name)';
}


}

/// @nodoc
abstract mixin class $WardCopyWith<$Res>  {
  factory $WardCopyWith(Ward value, $Res Function(Ward) _then) = _$WardCopyWithImpl;
@useResult
$Res call({
 String? uid, String? name
});




}
/// @nodoc
class _$WardCopyWithImpl<$Res>
    implements $WardCopyWith<$Res> {
  _$WardCopyWithImpl(this._self, this._then);

  final Ward _self;
  final $Res Function(Ward) _then;

/// Create a copy of Ward
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? uid = freezed,Object? name = freezed,}) {
  return _then(_self.copyWith(
uid: freezed == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Ward].
extension WardPatterns on Ward {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Ward value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Ward() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Ward value)  $default,){
final _that = this;
switch (_that) {
case _Ward():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Ward value)?  $default,){
final _that = this;
switch (_that) {
case _Ward() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? uid,  String? name)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Ward() when $default != null:
return $default(_that.uid,_that.name);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? uid,  String? name)  $default,) {final _that = this;
switch (_that) {
case _Ward():
return $default(_that.uid,_that.name);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? uid,  String? name)?  $default,) {final _that = this;
switch (_that) {
case _Ward() when $default != null:
return $default(_that.uid,_that.name);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Ward implements Ward {
  const _Ward({this.uid, this.name});
  factory _Ward.fromJson(Map<String, dynamic> json) => _$WardFromJson(json);

@override final  String? uid;
@override final  String? name;

/// Create a copy of Ward
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WardCopyWith<_Ward> get copyWith => __$WardCopyWithImpl<_Ward>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WardToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Ward&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,uid,name);

@override
String toString() {
  return 'Ward(uid: $uid, name: $name)';
}


}

/// @nodoc
abstract mixin class _$WardCopyWith<$Res> implements $WardCopyWith<$Res> {
  factory _$WardCopyWith(_Ward value, $Res Function(_Ward) _then) = __$WardCopyWithImpl;
@override @useResult
$Res call({
 String? uid, String? name
});




}
/// @nodoc
class __$WardCopyWithImpl<$Res>
    implements _$WardCopyWith<$Res> {
  __$WardCopyWithImpl(this._self, this._then);

  final _Ward _self;
  final $Res Function(_Ward) _then;

/// Create a copy of Ward
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? uid = freezed,Object? name = freezed,}) {
  return _then(_Ward(
uid: freezed == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$Union {

 String? get uid; String? get name;
/// Create a copy of Union
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UnionCopyWith<Union> get copyWith => _$UnionCopyWithImpl<Union>(this as Union, _$identity);

  /// Serializes this Union to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Union&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,uid,name);

@override
String toString() {
  return 'Union(uid: $uid, name: $name)';
}


}

/// @nodoc
abstract mixin class $UnionCopyWith<$Res>  {
  factory $UnionCopyWith(Union value, $Res Function(Union) _then) = _$UnionCopyWithImpl;
@useResult
$Res call({
 String? uid, String? name
});




}
/// @nodoc
class _$UnionCopyWithImpl<$Res>
    implements $UnionCopyWith<$Res> {
  _$UnionCopyWithImpl(this._self, this._then);

  final Union _self;
  final $Res Function(Union) _then;

/// Create a copy of Union
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? uid = freezed,Object? name = freezed,}) {
  return _then(_self.copyWith(
uid: freezed == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Union].
extension UnionPatterns on Union {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Union value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Union() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Union value)  $default,){
final _that = this;
switch (_that) {
case _Union():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Union value)?  $default,){
final _that = this;
switch (_that) {
case _Union() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? uid,  String? name)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Union() when $default != null:
return $default(_that.uid,_that.name);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? uid,  String? name)  $default,) {final _that = this;
switch (_that) {
case _Union():
return $default(_that.uid,_that.name);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? uid,  String? name)?  $default,) {final _that = this;
switch (_that) {
case _Union() when $default != null:
return $default(_that.uid,_that.name);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Union implements Union {
  const _Union({this.uid, this.name});
  factory _Union.fromJson(Map<String, dynamic> json) => _$UnionFromJson(json);

@override final  String? uid;
@override final  String? name;

/// Create a copy of Union
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UnionCopyWith<_Union> get copyWith => __$UnionCopyWithImpl<_Union>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UnionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Union&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,uid,name);

@override
String toString() {
  return 'Union(uid: $uid, name: $name)';
}


}

/// @nodoc
abstract mixin class _$UnionCopyWith<$Res> implements $UnionCopyWith<$Res> {
  factory _$UnionCopyWith(_Union value, $Res Function(_Union) _then) = __$UnionCopyWithImpl;
@override @useResult
$Res call({
 String? uid, String? name
});




}
/// @nodoc
class __$UnionCopyWithImpl<$Res>
    implements _$UnionCopyWith<$Res> {
  __$UnionCopyWithImpl(this._self, this._then);

  final _Union _self;
  final $Res Function(_Union) _then;

/// Create a copy of Union
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? uid = freezed,Object? name = freezed,}) {
  return _then(_Union(
uid: freezed == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$Upazila {

 String? get uid; String? get name;
/// Create a copy of Upazila
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpazilaCopyWith<Upazila> get copyWith => _$UpazilaCopyWithImpl<Upazila>(this as Upazila, _$identity);

  /// Serializes this Upazila to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Upazila&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,uid,name);

@override
String toString() {
  return 'Upazila(uid: $uid, name: $name)';
}


}

/// @nodoc
abstract mixin class $UpazilaCopyWith<$Res>  {
  factory $UpazilaCopyWith(Upazila value, $Res Function(Upazila) _then) = _$UpazilaCopyWithImpl;
@useResult
$Res call({
 String? uid, String? name
});




}
/// @nodoc
class _$UpazilaCopyWithImpl<$Res>
    implements $UpazilaCopyWith<$Res> {
  _$UpazilaCopyWithImpl(this._self, this._then);

  final Upazila _self;
  final $Res Function(Upazila) _then;

/// Create a copy of Upazila
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? uid = freezed,Object? name = freezed,}) {
  return _then(_self.copyWith(
uid: freezed == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Upazila].
extension UpazilaPatterns on Upazila {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Upazila value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Upazila() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Upazila value)  $default,){
final _that = this;
switch (_that) {
case _Upazila():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Upazila value)?  $default,){
final _that = this;
switch (_that) {
case _Upazila() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? uid,  String? name)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Upazila() when $default != null:
return $default(_that.uid,_that.name);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? uid,  String? name)  $default,) {final _that = this;
switch (_that) {
case _Upazila():
return $default(_that.uid,_that.name);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? uid,  String? name)?  $default,) {final _that = this;
switch (_that) {
case _Upazila() when $default != null:
return $default(_that.uid,_that.name);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Upazila implements Upazila {
  const _Upazila({this.uid, this.name});
  factory _Upazila.fromJson(Map<String, dynamic> json) => _$UpazilaFromJson(json);

@override final  String? uid;
@override final  String? name;

/// Create a copy of Upazila
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpazilaCopyWith<_Upazila> get copyWith => __$UpazilaCopyWithImpl<_Upazila>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UpazilaToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Upazila&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,uid,name);

@override
String toString() {
  return 'Upazila(uid: $uid, name: $name)';
}


}

/// @nodoc
abstract mixin class _$UpazilaCopyWith<$Res> implements $UpazilaCopyWith<$Res> {
  factory _$UpazilaCopyWith(_Upazila value, $Res Function(_Upazila) _then) = __$UpazilaCopyWithImpl;
@override @useResult
$Res call({
 String? uid, String? name
});




}
/// @nodoc
class __$UpazilaCopyWithImpl<$Res>
    implements _$UpazilaCopyWith<$Res> {
  __$UpazilaCopyWithImpl(this._self, this._then);

  final _Upazila _self;
  final $Res Function(_Upazila) _then;

/// Create a copy of Upazila
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? uid = freezed,Object? name = freezed,}) {
  return _then(_Upazila(
uid: freezed == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
