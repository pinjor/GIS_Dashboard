// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'epi_center_details_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_EpiCenterDetailsResponse _$EpiCenterDetailsResponseFromJson(
  Map<String, dynamic> json,
) => _EpiCenterDetailsResponse(
  cityCorporations:
      (json['cityCorporations'] as List<dynamic>?)
          ?.map((e) => CityCorporation.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  districts:
      (json['districts'] as List<dynamic>?)
          ?.map((e) => District.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  divisions:
      (json['divisions'] as List<dynamic>?)
          ?.map((e) => Division.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  area: json['area'] == null
      ? null
      : Area.fromJson(json['area'] as Map<String, dynamic>),
  coverageTableData: json['coverageTableData'] == null
      ? null
      : CoverageTableData.fromJson(
          json['coverageTableData'] as Map<String, dynamic>,
        ),
  chartData: json['chartData'] == null
      ? null
      : ChartData.fromJson(json['chartData'] as Map<String, dynamic>),
  uid: json['uid'] as String?,
  nameList: json['nameList'] as String?,
  subblocks:
      (json['subblocks'] as List<dynamic>?)
          ?.map((e) => Subblock.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  wards:
      (json['wards'] as List<dynamic>?)
          ?.map((e) => Ward.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  unions:
      (json['unions'] as List<dynamic>?)
          ?.map((e) => Union.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  upazilas:
      (json['upazilas'] as List<dynamic>?)
          ?.map((e) => Upazila.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  subblockId: json['subblockId'] as String?,
  wardId: json['wardId'] as String?,
  unionId: json['unionId'] as String?,
  upazilaId: json['upazilaId'] as String?,
  districtId: json['districtId'] as String?,
  divisionId: json['divisionId'] as String?,
  type: json['type'] as String?,
  subBlockName: json['subBlockName'] as String?,
  wardName: json['wardName'] as String?,
  unionName: json['unionName'] as String?,
  upazilaName: json['upazilaName'] as String?,
  districtName: json['districtName'] as String?,
  divisionName: json['divisionName'] as String?,
  cityCorporationName: json['cityCorporationName'] as String?,
  ccZoneName: json['ccZoneName'] as String?,
  ccWardName: json['ccWardName'] as String?,
  ccUid: json['ccUid'] as String?,
  selectedYear: (json['selectedYear'] as num?)?.toInt(),
  additionalData: json['additionalData'] == null
      ? null
      : AdditionalData.fromJson(json['additionalData'] as Map<String, dynamic>),
);

Map<String, dynamic> _$EpiCenterDetailsResponseToJson(
  _EpiCenterDetailsResponse instance,
) => <String, dynamic>{
  'cityCorporations': instance.cityCorporations,
  'districts': instance.districts,
  'divisions': instance.divisions,
  'area': instance.area,
  'coverageTableData': instance.coverageTableData,
  'chartData': instance.chartData,
  'uid': instance.uid,
  'nameList': instance.nameList,
  'subblocks': instance.subblocks,
  'wards': instance.wards,
  'unions': instance.unions,
  'upazilas': instance.upazilas,
  'subblockId': instance.subblockId,
  'wardId': instance.wardId,
  'unionId': instance.unionId,
  'upazilaId': instance.upazilaId,
  'districtId': instance.districtId,
  'divisionId': instance.divisionId,
  'type': instance.type,
  'subBlockName': instance.subBlockName,
  'wardName': instance.wardName,
  'unionName': instance.unionName,
  'upazilaName': instance.upazilaName,
  'districtName': instance.districtName,
  'divisionName': instance.divisionName,
  'cityCorporationName': instance.cityCorporationName,
  'ccZoneName': instance.ccZoneName,
  'ccWardName': instance.ccWardName,
  'ccUid': instance.ccUid,
  'selectedYear': instance.selectedYear,
  'additionalData': instance.additionalData,
};

_CityCorporation _$CityCorporationFromJson(Map<String, dynamic> json) =>
    _CityCorporation(
      uid: json['uid'] as String?,
      name: json['name'] as String?,
      children:
          (json['children'] as List<dynamic>?)
              ?.map((e) => CCChild.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$CityCorporationToJson(_CityCorporation instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'name': instance.name,
      'children': instance.children,
    };

_CCChild _$CCChildFromJson(Map<String, dynamic> json) => _CCChild(
  uid: json['uid'] as String?,
  name: json['name'] as String?,
  parentUid: json['parent_uid'] as String?,
  type: json['type'] as String?,
  children:
      (json['children'] as List<dynamic>?)
          ?.map((e) => CCChild.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$CCChildToJson(_CCChild instance) => <String, dynamic>{
  'uid': instance.uid,
  'name': instance.name,
  'parent_uid': instance.parentUid,
  'type': instance.type,
  'children': instance.children,
};

_District _$DistrictFromJson(Map<String, dynamic> json) =>
    _District(uid: json['uid'] as String?, name: json['name'] as String?);

Map<String, dynamic> _$DistrictToJson(_District instance) => <String, dynamic>{
  'uid': instance.uid,
  'name': instance.name,
};

_Division _$DivisionFromJson(Map<String, dynamic> json) =>
    _Division(uid: json['uid'] as String?, name: json['name'] as String?);

Map<String, dynamic> _$DivisionToJson(_Division instance) => <String, dynamic>{
  'uid': instance.uid,
  'name': instance.name,
};

_Area _$AreaFromJson(Map<String, dynamic> json) => _Area(
  id: (json['id'] as num?)?.toInt(),
  type: json['type'] as String?,
  uid: json['uid'] as String?,
  name: json['name'] as String?,
  etrackerName: json['etracker_name'] as String?,
  geoName: json['geo_name'] as String?,
  parentUid: json['parent_uid'] as String?,
  jsonFilePath: json['json_file_path'] as String?,
  isBulkImported: json['is_bulk_imported'] as bool?,
  vaccineTarget: json['vaccine_target'] == null
      ? null
      : VaccineTarget.fromJson(json['vaccine_target'] as Map<String, dynamic>),
  vaccineCoverage: json['vaccine_coverage'] == null
      ? null
      : VaccineCoverage.fromJson(
          json['vaccine_coverage'] as Map<String, dynamic>,
        ),
  additionalData: json['additional_data'] == null
      ? null
      : AdditionalData.fromJson(
          json['additional_data'] as Map<String, dynamic>,
        ),
  epiUids: json['epi_uids'],
  remarks: json['remarks'],
  buildAt: json['build_at'] as String?,
  createdAt: json['created_at'] as String?,
  updatedAt: json['updated_at'] as String?,
  status: json['status'] as String?,
  parent: json['parent'] == null
      ? null
      : Parent.fromJson(json['parent'] as Map<String, dynamic>),
);

Map<String, dynamic> _$AreaToJson(_Area instance) => <String, dynamic>{
  'id': instance.id,
  'type': instance.type,
  'uid': instance.uid,
  'name': instance.name,
  'etracker_name': instance.etrackerName,
  'geo_name': instance.geoName,
  'parent_uid': instance.parentUid,
  'json_file_path': instance.jsonFilePath,
  'is_bulk_imported': instance.isBulkImported,
  'vaccine_target': instance.vaccineTarget,
  'vaccine_coverage': instance.vaccineCoverage,
  'additional_data': instance.additionalData,
  'epi_uids': instance.epiUids,
  'remarks': instance.remarks,
  'build_at': instance.buildAt,
  'created_at': instance.createdAt,
  'updated_at': instance.updatedAt,
  'status': instance.status,
  'parent': instance.parent,
};

_VaccineTarget _$VaccineTargetFromJson(Map<String, dynamic> json) =>
    _VaccineTarget(
      child0To11Month:
          (json['child_0_to_11_month'] as Map<String, dynamic>?)?.map(
            (k, e) =>
                MapEntry(k, YearTarget.fromJson(e as Map<String, dynamic>)),
          ) ??
          const {},
    );

Map<String, dynamic> _$VaccineTargetToJson(_VaccineTarget instance) =>
    <String, dynamic>{'child_0_to_11_month': instance.child0To11Month};

_YearTarget _$YearTargetFromJson(Map<String, dynamic> json) => _YearTarget(
  male: (json['male'] as num?)?.toInt(),
  female: (json['female'] as num?)?.toInt(),
);

Map<String, dynamic> _$YearTargetToJson(_YearTarget instance) =>
    <String, dynamic>{'male': instance.male, 'female': instance.female};

_VaccineCoverage _$VaccineCoverageFromJson(Map<String, dynamic> json) =>
    _VaccineCoverage(
      child0To11Month:
          (json['child_0_to_11_month'] as Map<String, dynamic>?)?.map(
            (k, e) =>
                MapEntry(k, YearCoverage.fromJson(e as Map<String, dynamic>)),
          ) ??
          const {},
    );

Map<String, dynamic> _$VaccineCoverageToJson(_VaccineCoverage instance) =>
    <String, dynamic>{'child_0_to_11_month': instance.child0To11Month};

_YearCoverage _$YearCoverageFromJson(Map<String, dynamic> json) =>
    _YearCoverage(
      vaccine:
          (json['vaccine'] as List<dynamic>?)
              ?.map((e) => VaccineItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      months:
          (json['months'] as Map<String, dynamic>?)?.map(
            (k, e) =>
                MapEntry(k, MonthCoverage.fromJson(e as Map<String, dynamic>)),
          ) ??
          const {},
    );

Map<String, dynamic> _$YearCoverageToJson(_YearCoverage instance) =>
    <String, dynamic>{'vaccine': instance.vaccine, 'months': instance.months};

_VaccineItem _$VaccineItemFromJson(Map<String, dynamic> json) => _VaccineItem(
  vaccineUid: json['vaccine_uid'] as String?,
  vaccineName: json['vaccine_name'] as String?,
  male: (json['male'] as num?)?.toInt(),
  female: (json['female'] as num?)?.toInt(),
);

Map<String, dynamic> _$VaccineItemToJson(_VaccineItem instance) =>
    <String, dynamic>{
      'vaccine_uid': instance.vaccineUid,
      'vaccine_name': instance.vaccineName,
      'male': instance.male,
      'female': instance.female,
    };

_MonthCoverage _$MonthCoverageFromJson(Map<String, dynamic> json) =>
    _MonthCoverage(
      vaccine:
          (json['vaccine'] as List<dynamic>?)
              ?.map((e) => VaccineItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$MonthCoverageToJson(_MonthCoverage instance) =>
    <String, dynamic>{'vaccine': instance.vaccine};

_AdditionalData _$AdditionalDataFromJson(Map<String, dynamic> json) =>
    _AdditionalData(
      demographics:
          (json['demographics'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(
              k,
              YearDemographics.fromJson(e as Map<String, dynamic>),
            ),
          ) ??
          const {},
    );

Map<String, dynamic> _$AdditionalDataToJson(_AdditionalData instance) =>
    <String, dynamic>{'demographics': instance.demographics};

_YearDemographics _$YearDemographicsFromJson(
  Map<String, dynamic> json,
) => _YearDemographics(
  population: json['population'] == null
      ? null
      : Population.fromJson(json['population'] as Map<String, dynamic>),
  child0To15Month: json['child_0_15_month'] == null
      ? null
      : ChildData.fromJson(json['child_0_15_month'] as Map<String, dynamic>),
  child0To11Month: json['child_0_11_month'] == null
      ? null
      : ChildData.fromJson(json['child_0_11_month'] as Map<String, dynamic>),
  numberOfSessionsInYear: (json['number_of_sessions_in_year'] as num?)?.toInt(),
  women15To49: (json['women_15_to_49'] as num?)?.toInt(),
  haVaccinatorDesignation1: json['ha_vaccinator_designation1'],
  haVaccinatorName1: json['ha_vaccinator_name1'],
  haVaccinatorDesignation2: json['ha_vaccinator_designation2'],
  haVaccinatorName2: json['ha_vaccinator_name2'],
  supervisor1Designation: json['supervisor1_designation'],
  supervisor1Name: json['supervisor1_name'],
  epiCenterNameAddress: json['epi_center_name_address'],
  epiCenterImplementerName: json['epi_center_implementer_name'],
  distanceFromCcToEpiCenter: json['distance_from_cc_to_epi_center'],
  modeOfTransportationDistribution: json['mode_of_transportation_distribution'],
  modeOfTransportationUhc: json['mode_of_transportation_uhc'],
  timeToReachDistributionPoint: json['time_to_reach_distribution_point'],
  timeToReachEpiCenter: json['time_to_reach_epi_center'],
  porterName: json['porter_name'],
  porterMobile: json['porter_mobile'],
  epiCenterType: json['epi_center_type'],
);

Map<String, dynamic> _$YearDemographicsToJson(_YearDemographics instance) =>
    <String, dynamic>{
      'population': instance.population,
      'child_0_15_month': instance.child0To15Month,
      'child_0_11_month': instance.child0To11Month,
      'number_of_sessions_in_year': instance.numberOfSessionsInYear,
      'women_15_to_49': instance.women15To49,
      'ha_vaccinator_designation1': instance.haVaccinatorDesignation1,
      'ha_vaccinator_name1': instance.haVaccinatorName1,
      'ha_vaccinator_designation2': instance.haVaccinatorDesignation2,
      'ha_vaccinator_name2': instance.haVaccinatorName2,
      'supervisor1_designation': instance.supervisor1Designation,
      'supervisor1_name': instance.supervisor1Name,
      'epi_center_name_address': instance.epiCenterNameAddress,
      'epi_center_implementer_name': instance.epiCenterImplementerName,
      'distance_from_cc_to_epi_center': instance.distanceFromCcToEpiCenter,
      'mode_of_transportation_distribution':
          instance.modeOfTransportationDistribution,
      'mode_of_transportation_uhc': instance.modeOfTransportationUhc,
      'time_to_reach_distribution_point': instance.timeToReachDistributionPoint,
      'time_to_reach_epi_center': instance.timeToReachEpiCenter,
      'porter_name': instance.porterName,
      'porter_mobile': instance.porterMobile,
      'epi_center_type': instance.epiCenterType,
    };

_Population _$PopulationFromJson(Map<String, dynamic> json) => _Population(
  female: (json['female'] as num?)?.toInt(),
  male: (json['male'] as num?)?.toInt(),
);

Map<String, dynamic> _$PopulationToJson(_Population instance) =>
    <String, dynamic>{'female': instance.female, 'male': instance.male};

_ChildData _$ChildDataFromJson(Map<String, dynamic> json) => _ChildData(
  female: (json['female'] as num?)?.toInt(),
  male: (json['male'] as num?)?.toInt(),
);

Map<String, dynamic> _$ChildDataToJson(_ChildData instance) =>
    <String, dynamic>{'female': instance.female, 'male': instance.male};

_Parent _$ParentFromJson(Map<String, dynamic> json) => _Parent(
  id: (json['id'] as num?)?.toInt(),
  type: json['type'] as String?,
  uid: json['uid'] as String?,
  name: json['name'] as String?,
  etrackerName: json['etracker_name'] as String?,
  geoName: json['geo_name'] as String?,
  parentUid: json['parent_uid'] as String?,
  jsonFilePath: json['json_file_path'] as String?,
  isBulkImported: json['is_bulk_imported'] as bool?,
  vaccineTarget: json['vaccine_target'] == null
      ? null
      : VaccineTarget.fromJson(json['vaccine_target'] as Map<String, dynamic>),
  vaccineCoverage: json['vaccine_coverage'] == null
      ? null
      : VaccineCoverage.fromJson(
          json['vaccine_coverage'] as Map<String, dynamic>,
        ),
  additionalData: json['additional_data'] == null
      ? null
      : AdditionalData.fromJson(
          json['additional_data'] as Map<String, dynamic>,
        ),
  epiUids: json['epi_uids'],
  remarks: json['remarks'],
  buildAt: json['build_at'] as String?,
  createdAt: json['created_at'] as String?,
  updatedAt: json['updated_at'] as String?,
  status: json['status'] as String?,
);

Map<String, dynamic> _$ParentToJson(_Parent instance) => <String, dynamic>{
  'id': instance.id,
  'type': instance.type,
  'uid': instance.uid,
  'name': instance.name,
  'etracker_name': instance.etrackerName,
  'geo_name': instance.geoName,
  'parent_uid': instance.parentUid,
  'json_file_path': instance.jsonFilePath,
  'is_bulk_imported': instance.isBulkImported,
  'vaccine_target': instance.vaccineTarget,
  'vaccine_coverage': instance.vaccineCoverage,
  'additional_data': instance.additionalData,
  'epi_uids': instance.epiUids,
  'remarks': instance.remarks,
  'build_at': instance.buildAt,
  'created_at': instance.createdAt,
  'updated_at': instance.updatedAt,
  'status': instance.status,
};

_CoverageTableData _$CoverageTableDataFromJson(Map<String, dynamic> json) =>
    _CoverageTableData(
      months:
          (json['months'] as Map<String, dynamic>?)?.map(
            (k, e) =>
                MapEntry(k, MonthTableData.fromJson(e as Map<String, dynamic>)),
          ) ??
          const {},
      totals: json['totals'] == null
          ? null
          : TotalTableData.fromJson(json['totals'] as Map<String, dynamic>),
      vaccineNames:
          (json['vaccine_names'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      targets: json['targets'] == null
          ? null
          : Targets.fromJson(json['targets'] as Map<String, dynamic>),
      coveragePercentages:
          (json['coverage_percentages'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, (e as num).toDouble()),
          ) ??
          const {},
    );

Map<String, dynamic> _$CoverageTableDataToJson(_CoverageTableData instance) =>
    <String, dynamic>{
      'months': instance.months,
      'totals': instance.totals,
      'vaccine_names': instance.vaccineNames,
      'targets': instance.targets,
      'coverage_percentages': instance.coveragePercentages,
    };

_MonthTableData _$MonthTableDataFromJson(Map<String, dynamic> json) =>
    _MonthTableData(
      coverages: json['coverages'] as Map<String, dynamic>? ?? const {},
      dropouts: json['dropouts'] as Map<String, dynamic>? ?? const {},
    );

Map<String, dynamic> _$MonthTableDataToJson(_MonthTableData instance) =>
    <String, dynamic>{
      'coverages': instance.coverages,
      'dropouts': instance.dropouts,
    };

_TotalTableData _$TotalTableDataFromJson(Map<String, dynamic> json) =>
    _TotalTableData(
      coverages: json['coverages'] as Map<String, dynamic>? ?? const {},
      dropouts: json['dropouts'] as Map<String, dynamic>? ?? const {},
    );

Map<String, dynamic> _$TotalTableDataToJson(_TotalTableData instance) =>
    <String, dynamic>{
      'coverages': instance.coverages,
      'dropouts': instance.dropouts,
    };

_Targets _$TargetsFromJson(Map<String, dynamic> json) => _Targets(
  year: (json['year'] as num?)?.toInt(),
  month: (json['month'] as num?)?.toInt(),
);

Map<String, dynamic> _$TargetsToJson(_Targets instance) => <String, dynamic>{
  'year': instance.year,
  'month': instance.month,
};

_ChartData _$ChartDataFromJson(Map<String, dynamic> json) => _ChartData(
  labels:
      (json['labels'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  datasets:
      (json['datasets'] as List<dynamic>?)
          ?.map((e) => Dataset.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$ChartDataToJson(_ChartData instance) =>
    <String, dynamic>{'labels': instance.labels, 'datasets': instance.datasets};

_Dataset _$DatasetFromJson(Map<String, dynamic> json) => _Dataset(
  label: json['label'] as String?,
  data:
      (json['data'] as List<dynamic>?)
          ?.map((e) => (e as num?)?.toInt())
          .toList() ??
      const [],
  borderColor: json['borderColor'] as String?,
  backgroundColor: json['backgroundColor'] as String?,
  borderWidth: (json['borderWidth'] as num?)?.toInt(),
  borderDash:
      (json['borderDash'] as List<dynamic>?)
          ?.map((e) => (e as num?)?.toInt())
          .toList() ??
      const [],
  pointRadius: (json['pointRadius'] as num?)?.toInt(),
  tension: (json['tension'] as num?)?.toDouble(),
);

Map<String, dynamic> _$DatasetToJson(_Dataset instance) => <String, dynamic>{
  'label': instance.label,
  'data': instance.data,
  'borderColor': instance.borderColor,
  'backgroundColor': instance.backgroundColor,
  'borderWidth': instance.borderWidth,
  'borderDash': instance.borderDash,
  'pointRadius': instance.pointRadius,
  'tension': instance.tension,
};

_Subblock _$SubblockFromJson(Map<String, dynamic> json) =>
    _Subblock(uid: json['uid'] as String?, name: json['name'] as String?);

Map<String, dynamic> _$SubblockToJson(_Subblock instance) => <String, dynamic>{
  'uid': instance.uid,
  'name': instance.name,
};

_Ward _$WardFromJson(Map<String, dynamic> json) =>
    _Ward(uid: json['uid'] as String?, name: json['name'] as String?);

Map<String, dynamic> _$WardToJson(_Ward instance) => <String, dynamic>{
  'uid': instance.uid,
  'name': instance.name,
};

_Union _$UnionFromJson(Map<String, dynamic> json) =>
    _Union(uid: json['uid'] as String?, name: json['name'] as String?);

Map<String, dynamic> _$UnionToJson(_Union instance) => <String, dynamic>{
  'uid': instance.uid,
  'name': instance.name,
};

_Upazila _$UpazilaFromJson(Map<String, dynamic> json) =>
    _Upazila(uid: json['uid'] as String?, name: json['name'] as String?);

Map<String, dynamic> _$UpazilaToJson(_Upazila instance) => <String, dynamic>{
  'uid': instance.uid,
  'name': instance.name,
};
