// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'epi_center_details_response.freezed.dart';
part 'epi_center_details_response.g.dart';

@freezed
abstract class EpiCenterDetailsResponse with _$EpiCenterDetailsResponse {
  const EpiCenterDetailsResponse._(); // Add private constructor for custom getters

  const factory EpiCenterDetailsResponse({
    @Default([]) List<CityCorporation> cityCorporations,
    @Default([]) List<District> districts,
    @Default([]) List<Division> divisions,
    Area? area,
    CoverageTableData? coverageTableData,
    ChartData? chartData,
    String? uid,
    String? nameList,
    @Default([]) List<Subblock> subblocks,
    @Default([]) List<Ward> wards,
    @Default([]) List<Union> unions,
    @Default([]) List<Upazila> upazilas,
    String? subblockId,
    String? wardId,
    String? unionId,
    String? upazilaId,
    String? districtId,
    String? divisionId,
    String? type,
    String? subBlockName,
    String? wardName,
    String? unionName,
    String? upazilaName,
    String? districtName,
    String? divisionName,
    String? cityCorporationName,
    String? ccZoneName,
    String? ccWardName,
    String? ccUid,
    int? selectedYear,
    // ✅ NEW: Root-level additionalData for country-level responses
    AdditionalData? additionalData,
  }) = _EpiCenterDetailsResponse;

  factory EpiCenterDetailsResponse.fromJson(Map<String, dynamic> json) =>
      _$EpiCenterDetailsResponseFromJson(json);

  /// Helper method to get demographics data from either location:
  /// 1. First tries: area.additionalData.demographics (EPI center level)
  /// 2. Falls back to: additionalData.demographics (country level)
  Map<String, YearDemographics> getDemographics() {
    // Try area first (EPI center level)
    if (area?.additionalData?.demographics != null) {
      return area!.additionalData!.demographics;
    }
    // Fallback to root level (country level)
    if (additionalData?.demographics != null) {
      return additionalData!.demographics;
    }
    // Return empty map if neither exists
    return {};
  }

  /// Get demographics for a specific year
  YearDemographics? getDemographicsForYear(String year) {
    final demographics = getDemographics();
    return demographics[year];
  }
}

@freezed
abstract class CityCorporation with _$CityCorporation {
  const factory CityCorporation({
    String? uid,
    String? name,
    @Default([]) List<CCChild> children,
  }) = _CityCorporation;

  factory CityCorporation.fromJson(Map<String, dynamic> json) =>
      _$CityCorporationFromJson(json);
}

@freezed
abstract class CCChild with _$CCChild {
  const factory CCChild({
    String? uid,
    String? name,
    @JsonKey(name: 'parent_uid') String? parentUid,
    String? type,
    @Default([]) List<CCChild> children,
  }) = _CCChild;

  factory CCChild.fromJson(Map<String, dynamic> json) =>
      _$CCChildFromJson(json);
}

@freezed
abstract class District with _$District {
  const factory District({String? uid, String? name}) = _District;

  factory District.fromJson(Map<String, dynamic> json) =>
      _$DistrictFromJson(json);
}

@freezed
abstract class Division with _$Division {
  const factory Division({String? uid, String? name}) = _Division;

  factory Division.fromJson(Map<String, dynamic> json) =>
      _$DivisionFromJson(json);
}

@freezed
abstract class Area with _$Area {
  const factory Area({
    int? id,
    String? type,
    String? uid,
    String? name,
    @JsonKey(name: 'etracker_name') String? etrackerName,
    @JsonKey(name: 'geo_name') String? geoName,
    @JsonKey(name: 'parent_uid') String? parentUid,
    @JsonKey(name: 'json_file_path') String? jsonFilePath,
    @JsonKey(name: 'is_bulk_imported') bool? isBulkImported,
    @JsonKey(name: 'vaccine_target') VaccineTarget? vaccineTarget,
    @JsonKey(name: 'vaccine_coverage') VaccineCoverage? vaccineCoverage,
    @JsonKey(name: 'additional_data') AdditionalData? additionalData,
    @JsonKey(name: 'epi_uids') dynamic epiUids,
    dynamic remarks,
    @JsonKey(name: 'build_at') String? buildAt,
    @JsonKey(name: 'created_at') String? createdAt,
    @JsonKey(name: 'updated_at') String? updatedAt,
    String? status,
    Parent? parent,
  }) = _Area;

  factory Area.fromJson(Map<String, dynamic> json) => _$AreaFromJson(json);
}

@freezed
abstract class VaccineTarget with _$VaccineTarget {
  const factory VaccineTarget({
    @JsonKey(name: 'child_0_to_11_month')
    @Default({})
    Map<String, YearTarget> child0To11Month,
  }) = _VaccineTarget;

  factory VaccineTarget.fromJson(Map<String, dynamic> json) =>
      _$VaccineTargetFromJson(json);
}

@freezed
abstract class YearTarget with _$YearTarget {
  const factory YearTarget({int? male, int? female}) = _YearTarget;

  factory YearTarget.fromJson(Map<String, dynamic> json) =>
      _$YearTargetFromJson(json);
}

@freezed
abstract class VaccineCoverage with _$VaccineCoverage {
  const factory VaccineCoverage({
    @JsonKey(name: 'child_0_to_11_month')
    @Default({})
    Map<String, YearCoverage> child0To11Month,
  }) = _VaccineCoverage;

  factory VaccineCoverage.fromJson(Map<String, dynamic> json) =>
      _$VaccineCoverageFromJson(json);
}

@freezed
abstract class YearCoverage with _$YearCoverage {
  const factory YearCoverage({
    @Default([]) List<VaccineItem> vaccine,
    @Default({}) Map<String, MonthCoverage> months,
  }) = _YearCoverage;

  factory YearCoverage.fromJson(Map<String, dynamic> json) =>
      _$YearCoverageFromJson(json);
}

@freezed
abstract class VaccineItem with _$VaccineItem {
  const factory VaccineItem({
    @JsonKey(name: 'vaccine_uid') String? vaccineUid,
    @JsonKey(name: 'vaccine_name') String? vaccineName,
    int? male,
    int? female,
  }) = _VaccineItem;

  factory VaccineItem.fromJson(Map<String, dynamic> json) =>
      _$VaccineItemFromJson(json);
}

@freezed
abstract class MonthCoverage with _$MonthCoverage {
  const factory MonthCoverage({@Default([]) List<VaccineItem> vaccine}) =
      _MonthCoverage;

  factory MonthCoverage.fromJson(Map<String, dynamic> json) =>
      _$MonthCoverageFromJson(json);
}

@freezed
abstract class AdditionalData with _$AdditionalData {
  const factory AdditionalData({
    @Default({}) Map<String, YearDemographics> demographics,
  }) = _AdditionalData;

  factory AdditionalData.fromJson(Map<String, dynamic> json) =>
      _$AdditionalDataFromJson(json);
}

@freezed
abstract class YearDemographics with _$YearDemographics {
  const factory YearDemographics({
    Population? population,
    @JsonKey(name: 'child_0_15_month') ChildData? child0To15Month,
    @JsonKey(name: 'child_0_11_month') ChildData? child0To11Month,
    @JsonKey(name: 'number_of_sessions_in_year') int? numberOfSessionsInYear,
    @JsonKey(name: 'women_15_to_49') int? women15To49,
    @JsonKey(name: 'ha_vaccinator_designation1')
    dynamic
    haVaccinatorDesignation1, // ✅ Changed to dynamic (can be String or int)
    @JsonKey(name: 'ha_vaccinator_name1')
    dynamic haVaccinatorName1, // ✅ Changed to dynamic
    @JsonKey(name: 'ha_vaccinator_designation2')
    dynamic haVaccinatorDesignation2, // ✅ Changed to dynamic
    @JsonKey(name: 'ha_vaccinator_name2')
    dynamic haVaccinatorName2, // ✅ Changed to dynamic
    @JsonKey(name: 'supervisor1_designation')
    dynamic supervisor1Designation, // ✅ Changed to dynamic
    @JsonKey(name: 'supervisor1_name')
    dynamic supervisor1Name, // ✅ Changed to dynamic
    @JsonKey(name: 'epi_center_name_address')
    dynamic epiCenterNameAddress, // ✅ Changed to dynamic
    @JsonKey(name: 'epi_center_implementer_name')
    dynamic epiCenterImplementerName, // ✅ Changed to dynamic
    @JsonKey(name: 'distance_from_cc_to_epi_center')
    dynamic distanceFromCcToEpiCenter,
    @JsonKey(name: 'mode_of_transportation_distribution')
    dynamic modeOfTransportationDistribution, // ✅ Changed to dynamic
    @JsonKey(name: 'mode_of_transportation_uhc')
    dynamic modeOfTransportationUhc, // ✅ Changed to dynamic
    @JsonKey(name: 'time_to_reach_distribution_point')
    dynamic
    timeToReachDistributionPoint, // ✅ Changed to dynamic (can be double or int)
    @JsonKey(name: 'time_to_reach_epi_center')
    dynamic timeToReachEpiCenter, // ✅ Changed to dynamic
    @JsonKey(name: 'porter_name') dynamic porterName, // ✅ Changed to dynamic
    @JsonKey(name: 'porter_mobile')
    dynamic porterMobile, // ✅ Changed to dynamic (can be very large number)
    @JsonKey(name: 'epi_center_type')
    dynamic epiCenterType, // ✅ Changed to dynamic
  }) = _YearDemographics;

  factory YearDemographics.fromJson(Map<String, dynamic> json) =>
      _$YearDemographicsFromJson(json);
}

@freezed
abstract class Population with _$Population {
  const factory Population({int? female, int? male}) = _Population;

  factory Population.fromJson(Map<String, dynamic> json) =>
      _$PopulationFromJson(json);
}

@freezed
abstract class ChildData with _$ChildData {
  const factory ChildData({int? female, int? male}) = _ChildData;

  factory ChildData.fromJson(Map<String, dynamic> json) =>
      _$ChildDataFromJson(json);
}

@freezed
abstract class Parent with _$Parent {
  const factory Parent({
    int? id,
    String? type,
    String? uid,
    String? name,
    @JsonKey(name: 'etracker_name') String? etrackerName,
    @JsonKey(name: 'geo_name') String? geoName,
    @JsonKey(name: 'parent_uid') String? parentUid,
    @JsonKey(name: 'json_file_path') String? jsonFilePath,
    @JsonKey(name: 'is_bulk_imported') bool? isBulkImported,
    @JsonKey(name: 'vaccine_target') VaccineTarget? vaccineTarget,
    @JsonKey(name: 'vaccine_coverage') VaccineCoverage? vaccineCoverage,
    @JsonKey(name: 'additional_data') AdditionalData? additionalData,
    @JsonKey(name: 'epi_uids') dynamic epiUids,
    dynamic remarks,
    @JsonKey(name: 'build_at') String? buildAt,
    @JsonKey(name: 'created_at') String? createdAt,
    @JsonKey(name: 'updated_at') String? updatedAt,
    String? status,
  }) = _Parent;

  factory Parent.fromJson(Map<String, dynamic> json) => _$ParentFromJson(json);
}

@freezed
abstract class CoverageTableData with _$CoverageTableData {
  const factory CoverageTableData({
    @Default({}) Map<String, MonthTableData> months,
    TotalTableData? totals,
    @JsonKey(name: 'vaccine_names') @Default([]) List<String> vaccineNames,
    Targets? targets,
    @JsonKey(name: 'coverage_percentages')
    @Default({})
    Map<String, double> coveragePercentages,
  }) = _CoverageTableData;

  factory CoverageTableData.fromJson(Map<String, dynamic> json) =>
      _$CoverageTableDataFromJson(json);
}

@freezed
abstract class MonthTableData with _$MonthTableData {
  const factory MonthTableData({
    @Default({}) Map<String, int> coverages,
    @Default({}) Map<String, int> dropouts,
  }) = _MonthTableData;

  factory MonthTableData.fromJson(Map<String, dynamic> json) =>
      _$MonthTableDataFromJson(json);
}

@freezed
abstract class TotalTableData with _$TotalTableData {
  const factory TotalTableData({
    @Default({}) Map<String, int> coverages,
    @Default({}) Map<String, int> dropouts,
  }) = _TotalTableData;

  factory TotalTableData.fromJson(Map<String, dynamic> json) =>
      _$TotalTableDataFromJson(json);
}

@freezed
abstract class Targets with _$Targets {
  const factory Targets({int? year, int? month}) = _Targets;

  factory Targets.fromJson(Map<String, dynamic> json) =>
      _$TargetsFromJson(json);
}

@freezed
abstract class ChartData with _$ChartData {
  const factory ChartData({
    @Default([]) List<String> labels,
    @Default([]) List<Dataset> datasets,
  }) = _ChartData;

  factory ChartData.fromJson(Map<String, dynamic> json) =>
      _$ChartDataFromJson(json);
}

@freezed
abstract class Dataset with _$Dataset {
  const factory Dataset({
    String? label,
    @Default([]) List<int?> data,
    String? borderColor,
    String? backgroundColor,
    int? borderWidth,
    @Default([]) List<int?> borderDash,
    int? pointRadius,
    double? tension,
  }) = _Dataset;

  factory Dataset.fromJson(Map<String, dynamic> json) =>
      _$DatasetFromJson(json);
}

@freezed
abstract class Subblock with _$Subblock {
  const factory Subblock({String? uid, String? name}) = _Subblock;

  factory Subblock.fromJson(Map<String, dynamic> json) =>
      _$SubblockFromJson(json);
}

@freezed
abstract class Ward with _$Ward {
  const factory Ward({String? uid, String? name}) = _Ward;

  factory Ward.fromJson(Map<String, dynamic> json) => _$WardFromJson(json);
}

@freezed
abstract class Union with _$Union {
  const factory Union({String? uid, String? name}) = _Union;

  factory Union.fromJson(Map<String, dynamic> json) => _$UnionFromJson(json);
}

@freezed
abstract class Upazila with _$Upazila {
  const factory Upazila({String? uid, String? name}) = _Upazila;

  factory Upazila.fromJson(Map<String, dynamic> json) =>
      _$UpazilaFromJson(json);
}
