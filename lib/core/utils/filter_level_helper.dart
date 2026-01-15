import 'package:gis_dashboard/features/filter/domain/filter_state.dart';
import 'package:gis_dashboard/features/map/utils/map_enums.dart';

/// Utility class to determine child level labels based on current filter state
/// This helps display dynamic labels like "Districts", "Upazilas", "Wards", etc.
/// based on the deepest selected filter level
class FilterLevelHelper {
  /// Get the child level label based on the current filter state
  /// Returns the appropriate label for the child level of the deepest selected filter
  /// 
  /// Examples:
  /// - Country/All → "Districts"
  /// - Division → "Districts"
  /// - District → "Upazilas"
  /// - Upazila → "Unions"
  /// - Union → "Wards"
  /// - Ward → "Subblocks"
  /// - City Corporation → "Zones"
  /// - Zone → "CC-wards"
  static String getChildLevelLabel(FilterState filterState) {
    // Check from deepest to shallowest level to find the active filter
    
    // For District area type hierarchy
    if (filterState.selectedAreaType == AreaType.district) {
      if (filterState.selectedSubblock != null && filterState.selectedSubblock != 'All') {
        // Subblock is deepest, but it has no children, so this shouldn't happen in performance table
        // But if it does, we'll show "Subblocks" (though there are no children)
        return 'Subblocks';
      } else if (filterState.selectedWard != null && filterState.selectedWard != 'All') {
        // Ward is selected, child level is Subblocks
        return 'Subblocks';
      } else if (filterState.selectedUnion != null && filterState.selectedUnion != 'All') {
        // Union is selected, child level is Wards
        return 'Wards';
      } else if (filterState.selectedUpazila != null && filterState.selectedUpazila != 'All') {
        // Upazila is selected, child level is Unions
        return 'Unions';
      } else if (filterState.selectedDistrict != null && filterState.selectedDistrict != 'All') {
        // District is selected, child level is Upazilas
        return 'Upazilas';
      } else if (filterState.selectedDivision != 'All') {
        // Division is selected, child level is Districts
        return 'Districts';
      } else {
        // Country/All level, child level is Districts
        return 'Districts';
      }
    }
    
    // For City Corporation area type hierarchy
    else if (filterState.selectedAreaType == AreaType.cityCorporation) {
      if (filterState.selectedZone != null && filterState.selectedZone != 'All') {
        // Zone is selected, child level is CC-wards (wards within city corporation)
        return 'CC-wards';
      } else if (filterState.selectedCityCorporation != null) {
        // City Corporation is selected, child level is Zones
        return 'Zones';
      } else {
        // All City Corporations view, child level is City Corporations
        return 'City Corporations';
      }
    }
    
    // Default fallback (shouldn't normally reach here)
    return 'Districts';
  }
  
  /// Get the singular form of the child level label
  /// Useful for single item references
  static String getChildLevelLabelSingular(FilterState filterState) {
    final plural = getChildLevelLabel(filterState);
    
    // Convert plural to singular
    if (plural.endsWith('s')) {
      return plural.substring(0, plural.length - 1);
    }
    
    // Handle special cases
    if (plural == 'CC-wards') {
      return 'CC-ward';
    }
    
    return plural;
  }
}
