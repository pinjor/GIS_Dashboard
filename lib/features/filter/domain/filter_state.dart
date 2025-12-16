import 'area_response_model.dart';
import '../../map/utils/map_enums.dart';

/// Filter state for managing user selections and area data
class FilterState {
  final String selectedVaccine;
  final AreaType selectedAreaType;
  final String selectedDivision;
  final String? selectedCityCorporation;
  final String? selectedDistrict;
  final String selectedYear;

  // Extended hierarchical selections (for EPI details screen)
  final String? selectedUpazila;
  final String? selectedUnion;
  final String? selectedWard;
  final String? selectedSubblock;

  // Area data
  final List<AreaResponseModel> divisions;
  final List<AreaResponseModel> districts;
  final List<AreaResponseModel> cityCorporations;
  final List<AreaResponseModel>
  filteredDistricts; // Districts filtered by selected division

  // Extended hierarchical area data (for EPI details screen)
  final List<AreaResponseModel> upazilas;
  final List<AreaResponseModel> unions;
  final List<AreaResponseModel> wards;
  final List<AreaResponseModel> subblocks;

  // Loading states
  final bool isLoadingAreas;
  final String? areasError;

  // EPI details context
  final bool isEpiDetailsContext;
  final String? initialSubblockUid; // For reset functionality in EPI context

  // Original EPI state (captured when first entering EPI context)
  final String? originalEpiUid;
  final String? originalCcUid;
  final String? originalDivision;
  final String? originalDistrict;
  final String? originalUpazila;
  final String? originalUnion;
  final String? originalWard;
  final String? originalSubblock;
  final String? originalYear;

  // ✅ PLAN A: Cached hierarchical lists and UIDs for instant reset
  final List<AreaResponseModel>? originalUpazilasList;
  final List<AreaResponseModel>? originalUnionsList;
  final List<AreaResponseModel>? originalWardsList;
  final List<AreaResponseModel>? originalSubblocksList;
  final String? originalUpazilaUid;
  final String? originalUnionUid;
  final String? originalWardUid;
  final String? originalSubblockUid;

  // Filter application tracking
  final DateTime? lastAppliedTimestamp;

  const FilterState({
    this.selectedVaccine = 'BCG',
    this.selectedAreaType = AreaType.district,
    this.selectedDivision = 'All',
    this.selectedCityCorporation,
    this.selectedDistrict,
    this.selectedYear = '2025',
    // Extended hierarchical selections
    this.selectedUpazila,
    this.selectedUnion,
    this.selectedWard,
    this.selectedSubblock,
    // Area data
    this.divisions = const [],
    this.districts = const [],
    this.cityCorporations = const [],
    this.filteredDistricts = const [],
    // Extended hierarchical area data
    this.upazilas = const [],
    this.unions = const [],
    this.wards = const [],
    this.subblocks = const [],
    // Loading and context states
    this.isLoadingAreas = false,
    this.areasError,
    this.isEpiDetailsContext = false,
    this.initialSubblockUid,
    // Original EPI state
    this.originalEpiUid,
    this.originalCcUid,
    this.originalDivision,
    this.originalDistrict,
    this.originalUpazila,
    this.originalUnion,
    this.originalWard,
    this.originalSubblock,
    this.originalYear,
    // Cached hierarchical lists and UIDs for instant reset
    this.originalUpazilasList,
    this.originalUnionsList,
    this.originalWardsList,
    this.originalSubblocksList,
    this.originalUpazilaUid,
    this.originalUnionUid,
    this.originalWardUid,
    this.originalSubblockUid,
    this.lastAppliedTimestamp,
  });

  FilterState copyWith({
    String? selectedVaccine,
    AreaType? selectedAreaType,
    String? selectedDivision,
    String? selectedCityCorporation,
    String? selectedDistrict,
    String? selectedYear,
    // Extended hierarchical selections
    String? selectedUpazila,
    String? selectedUnion,
    String? selectedWard,
    String? selectedSubblock,
    // Area data
    List<AreaResponseModel>? divisions,
    List<AreaResponseModel>? districts,
    List<AreaResponseModel>? cityCorporations,
    List<AreaResponseModel>? filteredDistricts,
    // Extended hierarchical area data
    List<AreaResponseModel>? upazilas,
    List<AreaResponseModel>? unions,
    List<AreaResponseModel>? wards,
    List<AreaResponseModel>? subblocks,
    // Loading and context states
    bool? isLoadingAreas,
    String? areasError,
    bool? isEpiDetailsContext,
    String? initialSubblockUid,
    // Original EPI state
    String? originalEpiUid,
    String? originalCcUid,
    String? originalDivision,
    String? originalDistrict,
    String? originalUpazila,
    String? originalUnion,
    String? originalWard,
    String? originalSubblock,
    String? originalYear,
    // Cached hierarchical lists and UIDs
    List<AreaResponseModel>? originalUpazilasList,
    List<AreaResponseModel>? originalUnionsList,
    List<AreaResponseModel>? originalWardsList,
    List<AreaResponseModel>? originalSubblocksList,
    String? originalUpazilaUid,
    String? originalUnionUid,
    String? originalWardUid,
    String? originalSubblockUid,
    DateTime? lastAppliedTimestamp,
    // Explicit flags for nullable fields to allow setting to null
    bool clearCityCorporation = false,
    bool clearDistrict = false,
    bool clearUpazila = false,
    bool clearUnion = false,
    bool clearWard = false,
    bool clearSubblock = false,
    bool clearAreasError = false,
    bool clearInitialSubblockUid = false,
    bool clearOriginalEpiUid = false,
    bool clearOriginalCcUid = false,
    bool clearOriginalDivision = false,
    bool clearOriginalDistrict = false,
    bool clearOriginalUpazila = false,
    bool clearOriginalUnion = false,
    bool clearOriginalWard = false,
    bool clearOriginalSubblock = false,
    bool clearOriginalYear = false,
    bool clearOriginalCachedData = false,
  }) {
    return FilterState(
      selectedVaccine: selectedVaccine ?? this.selectedVaccine,
      selectedAreaType: selectedAreaType ?? this.selectedAreaType,
      selectedDivision: selectedDivision ?? this.selectedDivision,
      selectedCityCorporation: clearCityCorporation
          ? null
          : (selectedCityCorporation ?? this.selectedCityCorporation),
      selectedDistrict: clearDistrict
          ? null
          : (selectedDistrict ?? this.selectedDistrict),
      selectedYear: selectedYear ?? this.selectedYear,
      // Extended hierarchical selections
      selectedUpazila: clearUpazila
          ? null
          : (selectedUpazila ?? this.selectedUpazila),
      selectedUnion: clearUnion ? null : (selectedUnion ?? this.selectedUnion),
      selectedWard: clearWard ? null : (selectedWard ?? this.selectedWard),
      selectedSubblock: clearSubblock
          ? null
          : (selectedSubblock ?? this.selectedSubblock),
      // Area data
      divisions: divisions ?? this.divisions,
      districts: districts ?? this.districts,
      cityCorporations: cityCorporations ?? this.cityCorporations,
      filteredDistricts: filteredDistricts ?? this.filteredDistricts,
      // Extended hierarchical area data
      upazilas: upazilas ?? this.upazilas,
      unions: unions ?? this.unions,
      wards: wards ?? this.wards,
      subblocks: subblocks ?? this.subblocks,
      // Loading and context states
      isLoadingAreas: isLoadingAreas ?? this.isLoadingAreas,
      areasError: clearAreasError ? null : (areasError ?? this.areasError),
      isEpiDetailsContext: isEpiDetailsContext ?? this.isEpiDetailsContext,
      initialSubblockUid: clearInitialSubblockUid
          ? null
          : (initialSubblockUid ?? this.initialSubblockUid),
      // Original EPI state
      originalEpiUid: clearOriginalEpiUid
          ? null
          : (originalEpiUid ?? this.originalEpiUid),
      originalCcUid: clearOriginalCcUid
          ? null
          : (originalCcUid ?? this.originalCcUid),
      originalDivision: clearOriginalDivision
          ? null
          : (originalDivision ?? this.originalDivision),
      originalDistrict: clearOriginalDistrict
          ? null
          : (originalDistrict ?? this.originalDistrict),
      originalUpazila: clearOriginalUpazila
          ? null
          : (originalUpazila ?? this.originalUpazila),
      originalUnion: clearOriginalUnion
          ? null
          : (originalUnion ?? this.originalUnion),
      originalWard: clearOriginalWard
          ? null
          : (originalWard ?? this.originalWard),
      originalSubblock: clearOriginalSubblock
          ? null
          : (originalSubblock ?? this.originalSubblock),
      originalYear: clearOriginalYear
          ? null
          : (originalYear ?? this.originalYear),
      // Cached hierarchical lists and UIDs
      originalUpazilasList: clearOriginalCachedData
          ? null
          : (originalUpazilasList ?? this.originalUpazilasList),
      originalUnionsList: clearOriginalCachedData
          ? null
          : (originalUnionsList ?? this.originalUnionsList),
      originalWardsList: clearOriginalCachedData
          ? null
          : (originalWardsList ?? this.originalWardsList),
      originalSubblocksList: clearOriginalCachedData
          ? null
          : (originalSubblocksList ?? this.originalSubblocksList),
      originalUpazilaUid: clearOriginalCachedData
          ? null
          : (originalUpazilaUid ?? this.originalUpazilaUid),
      originalUnionUid: clearOriginalCachedData
          ? null
          : (originalUnionUid ?? this.originalUnionUid),
      originalWardUid: clearOriginalCachedData
          ? null
          : (originalWardUid ?? this.originalWardUid),
      originalSubblockUid: clearOriginalCachedData
          ? null
          : (originalSubblockUid ?? this.originalSubblockUid),
      lastAppliedTimestamp: lastAppliedTimestamp ?? this.lastAppliedTimestamp,
    );
  }
}
