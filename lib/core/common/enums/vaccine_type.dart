/// Centralized enum for vaccine types used throughout the application
///
/// This enum provides a single source of truth for vaccine names,
/// preventing typos and making it easy to maintain vaccine-related code.
enum VaccineType {
  bcg('BCG'),
  penta1('Penta - 1'),
  penta2('Penta - 2'),
  penta3('Penta - 3'),
  mr1('MR - 1'),
  mr2('MR - 2');

  const VaccineType(this.displayName);

  /// The display name that matches the API response vaccine_name field
  final String displayName;

  /// Get vaccine type from API string (exact match)
  /// Returns null if no match found
  static VaccineType? fromString(String name) {
    try {
      return VaccineType.values.firstWhere((v) => v.displayName == name.trim());
    } catch (e) {
      return null;
    }
  }

  /// List all vaccine display names for UI dropdowns
  static List<String> get allDisplayNames =>
      VaccineType.values.map((v) => v.displayName).toList();

  /// Default vaccine to show on app launch
  static const VaccineType defaultVaccine = VaccineType.bcg;
}
