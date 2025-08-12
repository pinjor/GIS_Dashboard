// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'vaccine_coverage_response.freezed.dart';
part 'vaccine_coverage_response.g.dart';

@freezed
abstract class VaccineCoverageResponse with _$VaccineCoverageResponse {
  const factory VaccineCoverageResponse({
    @JsonKey(name: 'metadata') Metadata? metadata,
    @JsonKey(name: 'vaccines') List<Vaccine>? vaccines,
  }) = _VaccineCoverageResponse;

  factory VaccineCoverageResponse.fromJson(Map<String, dynamic> json) =>
      _$VaccineCoverageResponseFromJson(json);
}

@freezed
abstract class Metadata with _$Metadata {
  const factory Metadata({
    @JsonKey(name: 'year') int? year,
    @JsonKey(name: 'area_type') String? areaType,
    @JsonKey(name: 'generated_at') String? generatedAt,
    @JsonKey(name: 'data_structure') String? dataStructure,
  }) = _Metadata;

  factory Metadata.fromJson(Map<String, dynamic> json) =>
      _$MetadataFromJson(json);
}

@freezed
abstract class Vaccine with _$Vaccine {
  const factory Vaccine({
    @JsonKey(name: 'vaccine_uid') String? vaccineUid,
    @JsonKey(name: 'vaccine_name') String? vaccineName,
    @JsonKey(name: 'total_target') int? totalTarget,
    @JsonKey(name: 'total_target_male') int? totalTargetMale,
    @JsonKey(name: 'total_target_female') int? totalTargetFemale,
    @JsonKey(name: 'total_coverage') int? totalCoverage,
    @JsonKey(name: 'total_coverage_male') int? totalCoverageMale,
    @JsonKey(name: 'total_coverage_female') int? totalCoverageFemale,
    @JsonKey(name: 'total_coverage_percentage') double? totalCoveragePercentage,
    @JsonKey(name: 'total_coverage_percentage_male') double? totalCoveragePercentageMale,
    @JsonKey(name: 'total_coverage_percentage_female') double? totalCoveragePercentageFemale,
    @JsonKey(name: 'areas') List<Area>? areas,
    @JsonKey(name: 'month_wise_total_coverages') Map<String, MonthlyCoverage>? monthWiseTotalCoverages,
    @JsonKey(name: 'performance') Performance? performance,
  }) = _Vaccine;

  factory Vaccine.fromJson(Map<String, dynamic> json) =>
      _$VaccineFromJson(json);
}

@freezed
abstract class Area with _$Area {
  const factory Area({
    @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'uid') String? uid,
    @JsonKey(name: 'target') int? target,
    @JsonKey(name: 'target_male') int? targetMale,
    @JsonKey(name: 'target_female') int? targetFemale,
    @JsonKey(name: 'coverage') int? coverage,
    @JsonKey(name: 'coverage_male') int? coverageMale,
    @JsonKey(name: 'coverage_female') int? coverageFemale,
    @JsonKey(name: 'coverage_percentage') double? coveragePercentage,
    @JsonKey(name: 'coverage_percentage_male') double? coveragePercentageMale,
    @JsonKey(name: 'coverage_percentage_female') double? coveragePercentageFemale,
    @JsonKey(name: 'dropout') double? dropout,
    @JsonKey(name: 'dropout_male') double? dropoutMale,
    @JsonKey(name: 'dropout_female') double? dropoutFemale,
    @JsonKey(name: 'monthly_coverages') Map<String, MonthlyCoverage>? monthlyCoverages,
  }) = _Area;

  factory Area.fromJson(Map<String, dynamic> json) => _$AreaFromJson(json);
}

@freezed
abstract class MonthlyCoverage with _$MonthlyCoverage {
  const factory MonthlyCoverage({
    @JsonKey(name: 'coverage') int? coverage,
    @JsonKey(name: 'coverage_male') int? coverageMale,
    @JsonKey(name: 'coverage_female') int? coverageFemale,
    @JsonKey(name: 'coverage_percentage') double? coveragePercentage,
    @JsonKey(name: 'coverage_percentage_male') double? coveragePercentageMale,
    @JsonKey(name: 'coverage_percentage_female') double? coveragePercentageFemale,
  }) = _MonthlyCoverage;

  factory MonthlyCoverage.fromJson(Map<String, dynamic> json) =>
      _$MonthlyCoverageFromJson(json);
}

@freezed
abstract class Performance with _$Performance {
  const factory Performance({
    @JsonKey(name: 'highest') List<Area>? highest,
    @JsonKey(name: 'lowest') List<Area>? lowest,
  }) = _Performance;

  factory Performance.fromJson(Map<String, dynamic> json) =>
      _$PerformanceFromJson(json);
}
