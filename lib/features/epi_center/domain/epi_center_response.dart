import 'dart:convert';

// -------------------- EPI Center Response --------------------
class EpiCenterResponse {
  final List<AreaReference>? cityCorporations;
  final List<AreaReference>? districts;
  final List<AreaReference>? divisions;
  final AreaDetails? area;
  final Map<String, dynamic>? coverageTableData;
  final Map<String, dynamic>? chartData;
  final String? uid;
  final String? nameList;
  final List<AreaReference>? subblocks;
  final List<AreaReference>? wards;
  final List<AreaReference>? unions;
  final List<AreaReference>? upazilas;
  final String? subblockId;
  final String? wardId;
  final String? unionId;
  final String? upazilaId;
  final String? districtId;
  final String? divisionId;
  final String? type;
  final String? subBlockName;
  final String? wardName;
  final String? unionName;
  final String? upazilaName;
  final String? districtName;
  final String? divisionName;
  final String? cityCorporationName;
  final String? ccUid;

  EpiCenterResponse({
    this.cityCorporations,
    this.districts,
    this.divisions,
    this.area,
    this.coverageTableData,
    this.chartData,
    this.uid,
    this.nameList,
    this.subblocks,
    this.wards,
    this.unions,
    this.upazilas,
    this.subblockId,
    this.wardId,
    this.unionId,
    this.upazilaId,
    this.districtId,
    this.divisionId,
    this.type,
    this.subBlockName,
    this.wardName,
    this.unionName,
    this.upazilaName,
    this.districtName,
    this.divisionName,
    this.cityCorporationName,
    this.ccUid,
  });

  factory EpiCenterResponse.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic>? safeMap(dynamic value) {
      if (value is Map<String, dynamic>) return value;
      return null; // gracefully ignore wrong types
    }

    List<AreaReference>? safeList(dynamic value) {
      if (value is List) {
        return value
            .whereType<Map<String, dynamic>>()
            .map((e) => AreaReference.fromJson(e))
            .toList();
      }
      return null;
    }

    return EpiCenterResponse(
      cityCorporations: safeList(json['cityCorporations']),
      districts: safeList(json['districts']),
      divisions: safeList(json['divisions']),
      area: json['area'] is Map<String, dynamic>
          ? AreaDetails.fromJson(json['area'])
          : null,
      coverageTableData: safeMap(json['coverageTableData']),
      chartData: safeMap(json['chartData']),
      uid: json['uid']?.toString(),
      nameList: json['nameList']?.toString(),
      subblocks: safeList(json['subblocks']),
      wards: safeList(json['wards']),
      unions: safeList(json['unions']),
      upazilas: safeList(json['upazilas']),
      subblockId: json['subblockId']?.toString(),
      wardId: json['wardId']?.toString(),
      unionId: json['unionId']?.toString(),
      upazilaId: json['upazilaId']?.toString(),
      districtId: json['districtId']?.toString(),
      divisionId: json['divisionId']?.toString(),
      type: json['type']?.toString(),
      subBlockName: json['subBlockName']?.toString(),
      wardName: json['wardName']?.toString(),
      unionName: json['unionName']?.toString(),
      upazilaName: json['upazilaName']?.toString(),
      districtName: json['districtName']?.toString(),
      divisionName: json['divisionName']?.toString(),
      cityCorporationName: json['cityCorporationName']?.toString(),
      ccUid: json['ccUid']?.toString(),
    );
  }
}

// -------------------- Area Reference --------------------
class AreaReference {
  final String? uid;
  final String? name;

  AreaReference({this.uid, this.name});

  factory AreaReference.fromJson(Map<String, dynamic> json) {
    return AreaReference(
      uid: json['uid']?.toString(),
      name: json['name']?.toString(),
    );
  }
}

// -------------------- Area Details --------------------
class AreaDetails {
  final int? id;
  final String? type;
  final String? uid;
  final String? name;
  final String? etrackerName;
  final String? geoName;
  final String? parentUid;
  final String? jsonFilePath;
  final bool? isBulkImported;
  final String? vaccineTarget;
  final String? vaccineCoverage;
  final String? epiUids;
  final String? remarks;
  final String? buildAt;
  final String? createdAt;
  final String? updatedAt;
  final String? status;
  final AreaDetails? parent;

  // Parsed data from JSON strings
  final Map<String, dynamic>? parsedVaccineTarget;
  final Map<String, dynamic>? parsedVaccineCoverage;

  AreaDetails({
    this.id,
    this.type,
    this.uid,
    this.name,
    this.etrackerName,
    this.geoName,
    this.parentUid,
    this.jsonFilePath,
    this.isBulkImported,
    this.vaccineTarget,
    this.vaccineCoverage,
    this.epiUids,
    this.remarks,
    this.buildAt,
    this.createdAt,
    this.updatedAt,
    this.status,
    this.parent,
    this.parsedVaccineTarget,
    this.parsedVaccineCoverage,
  });

  factory AreaDetails.fromJson(Map<String, dynamic> json) {
    // Parse vaccine target JSON string
    Map<String, dynamic>? parsedTarget;
    try {
      if (json['vaccine_target'] != null) {
        parsedTarget = jsonDecode(json['vaccine_target']);
      }
    } catch (e) {
      print('Error parsing vaccine_target: $e');
    }

    // Parse vaccine coverage JSON string
    Map<String, dynamic>? parsedCoverage;
    try {
      if (json['vaccine_coverage'] != null) {
        parsedCoverage = jsonDecode(json['vaccine_coverage']);
      }
    } catch (e) {
      print('Error parsing vaccine_coverage: $e');
    }

    return AreaDetails(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? ''),
      type: json['type']?.toString(),
      uid: json['uid']?.toString(),
      name: json['name']?.toString(),
      etrackerName: json['etracker_name']?.toString(),
      geoName: json['geo_name']?.toString(),
      parentUid: json['parent_uid']?.toString(),
      jsonFilePath: json['json_file_path']?.toString(),
      isBulkImported: json['is_bulk_imported'] is bool
          ? json['is_bulk_imported']
          : (json['is_bulk_imported']?.toString().toLowerCase() == 'true'),
      vaccineTarget: json['vaccine_target']?.toString(),
      vaccineCoverage: json['vaccine_coverage']?.toString(),
      epiUids: json['epi_uids']?.toString(),
      remarks: json['remarks']?.toString(),
      buildAt: json['build_at']?.toString(),
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
      status: json['status']?.toString(),
      parent: json['parent'] is Map<String, dynamic>
          ? AreaDetails.fromJson(json['parent'])
          : null,
      parsedVaccineTarget: parsedTarget,
      parsedVaccineCoverage: parsedCoverage,
    );
  }
}
