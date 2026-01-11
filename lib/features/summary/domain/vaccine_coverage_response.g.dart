// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vaccine_coverage_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_VaccineCoverageResponse _$VaccineCoverageResponseFromJson(
  Map<String, dynamic> json,
) => _VaccineCoverageResponse(
  metadata: json['metadata'] == null
      ? null
      : Metadata.fromJson(json['metadata'] as Map<String, dynamic>),
  vaccines: (json['vaccines'] as List<dynamic>?)
      ?.map((e) => Vaccine.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$VaccineCoverageResponseToJson(
  _VaccineCoverageResponse instance,
) => <String, dynamic>{
  'metadata': instance.metadata,
  'vaccines': instance.vaccines,
};

_Metadata _$MetadataFromJson(Map<String, dynamic> json) => _Metadata(
  year: (json['year'] as num?)?.toInt(),
  areaType: json['area_type'] as String?,
  generatedAt: json['generated_at'] as String?,
  dataStructure: json['data_structure'] as String?,
);

Map<String, dynamic> _$MetadataToJson(_Metadata instance) => <String, dynamic>{
  'year': instance.year,
  'area_type': instance.areaType,
  'generated_at': instance.generatedAt,
  'data_structure': instance.dataStructure,
};

_Vaccine _$VaccineFromJson(Map<String, dynamic> json) => _Vaccine(
  vaccineUid: json['vaccine_uid'] as String?,
  vaccineName: json['vaccine_name'] as String?,
  totalTarget: (json['total_target'] as num?)?.toInt(),
  totalTargetMale: (json['total_target_male'] as num?)?.toInt(),
  totalTargetFemale: (json['total_target_female'] as num?)?.toInt(),
  totalCoverage: (json['total_coverage'] as num?)?.toInt(),
  totalCoverageMale: (json['total_coverage_male'] as num?)?.toInt(),
  totalCoverageFemale: (json['total_coverage_female'] as num?)?.toInt(),
  totalCoveragePercentage: (json['total_coverage_percentage'] as num?)
      ?.toDouble(),
  totalCoveragePercentageMale: (json['total_coverage_percentage_male'] as num?)
      ?.toDouble(),
  totalCoveragePercentageFemale:
      (json['total_coverage_percentage_female'] as num?)?.toDouble(),
  areas: (json['areas'] as List<dynamic>?)
      ?.map((e) => Area.fromJson(e as Map<String, dynamic>))
      .toList(),
  monthWiseTotalCoverages:
      (json['month_wise_total_coverages'] as Map<String, dynamic>?)?.map(
        (k, e) =>
            MapEntry(k, MonthlyCoverage.fromJson(e as Map<String, dynamic>)),
      ),
  performance: json['performance'] == null
      ? null
      : Performance.fromJson(json['performance'] as Map<String, dynamic>),
);

Map<String, dynamic> _$VaccineToJson(_Vaccine instance) => <String, dynamic>{
  'vaccine_uid': instance.vaccineUid,
  'vaccine_name': instance.vaccineName,
  'total_target': instance.totalTarget,
  'total_target_male': instance.totalTargetMale,
  'total_target_female': instance.totalTargetFemale,
  'total_coverage': instance.totalCoverage,
  'total_coverage_male': instance.totalCoverageMale,
  'total_coverage_female': instance.totalCoverageFemale,
  'total_coverage_percentage': instance.totalCoveragePercentage,
  'total_coverage_percentage_male': instance.totalCoveragePercentageMale,
  'total_coverage_percentage_female': instance.totalCoveragePercentageFemale,
  'areas': instance.areas,
  'month_wise_total_coverages': instance.monthWiseTotalCoverages,
  'performance': instance.performance,
};

_Area _$AreaFromJson(Map<String, dynamic> json) => _Area(
  name: json['name'] as String?,
  uid: json['uid'] as String?,
  target: (json['target'] as num?)?.toInt(),
  targetMale: (json['target_male'] as num?)?.toInt(),
  targetFemale: (json['target_female'] as num?)?.toInt(),
  coverage: (json['coverage'] as num?)?.toInt(),
  coverageMale: (json['coverage_male'] as num?)?.toInt(),
  coverageFemale: (json['coverage_female'] as num?)?.toInt(),
  coveragePercentage: (json['coverage_percentage'] as num?)?.toDouble(),
  coveragePercentageMale: (json['coverage_percentage_male'] as num?)
      ?.toDouble(),
  coveragePercentageFemale: (json['coverage_percentage_female'] as num?)
      ?.toDouble(),
  dropout: (json['dropout'] as num?)?.toDouble(),
  dropoutMale: (json['dropout_male'] as num?)?.toDouble(),
  dropoutFemale: (json['dropout_female'] as num?)?.toDouble(),
  monthlyCoverages: (json['monthly_coverages'] as Map<String, dynamic>?)?.map(
    (k, e) => MapEntry(k, MonthlyCoverage.fromJson(e as Map<String, dynamic>)),
  ),
);

Map<String, dynamic> _$AreaToJson(_Area instance) => <String, dynamic>{
  'name': instance.name,
  'uid': instance.uid,
  'target': instance.target,
  'target_male': instance.targetMale,
  'target_female': instance.targetFemale,
  'coverage': instance.coverage,
  'coverage_male': instance.coverageMale,
  'coverage_female': instance.coverageFemale,
  'coverage_percentage': instance.coveragePercentage,
  'coverage_percentage_male': instance.coveragePercentageMale,
  'coverage_percentage_female': instance.coveragePercentageFemale,
  'dropout': instance.dropout,
  'dropout_male': instance.dropoutMale,
  'dropout_female': instance.dropoutFemale,
  'monthly_coverages': instance.monthlyCoverages,
};

_MonthlyCoverage _$MonthlyCoverageFromJson(Map<String, dynamic> json) =>
    _MonthlyCoverage(
      coverage: (json['coverage'] as num?)?.toInt(),
      coverageMale: (json['coverage_male'] as num?)?.toInt(),
      coverageFemale: (json['coverage_female'] as num?)?.toInt(),
      coveragePercentage: (json['coverage_percentage'] as num?)?.toDouble(),
      coveragePercentageMale: (json['coverage_percentage_male'] as num?)
          ?.toDouble(),
      coveragePercentageFemale: (json['coverage_percentage_female'] as num?)
          ?.toDouble(),
    );

Map<String, dynamic> _$MonthlyCoverageToJson(_MonthlyCoverage instance) =>
    <String, dynamic>{
      'coverage': instance.coverage,
      'coverage_male': instance.coverageMale,
      'coverage_female': instance.coverageFemale,
      'coverage_percentage': instance.coveragePercentage,
      'coverage_percentage_male': instance.coveragePercentageMale,
      'coverage_percentage_female': instance.coveragePercentageFemale,
    };

_Performance _$PerformanceFromJson(Map<String, dynamic> json) => _Performance(
  highest: (json['highest'] as List<dynamic>?)
      ?.map((e) => Area.fromJson(e as Map<String, dynamic>))
      .toList(),
  lowest: (json['lowest'] as List<dynamic>?)
      ?.map((e) => Area.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$PerformanceToJson(_Performance instance) =>
    <String, dynamic>{'highest': instance.highest, 'lowest': instance.lowest};
