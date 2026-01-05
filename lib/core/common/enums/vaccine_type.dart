/// Centralized enum for vaccine types used throughout the application
///
/// This enum provides a single source of truth for vaccine names,
/// preventing typos and making it easy to maintain vaccine-related code.
enum VaccineType {
  /// VaccineType enum with robust UID and display name
  ///
  /// UIDs are used for all lookups and equality, displayName is for UI only
  bcg('x3aIDdpR65a', 'BCG'),
  penta1('HOq1Ax6xB19', 'Penta - 1'),
  penta2('NCu55gLH6Te', 'Penta - 2'),
  penta3('b3FM2S2oaAd', 'Penta - 3'),
  mr1('xyVY5CmifZP', 'MR - 1'),
  mr2('nHwxXPJziO2', 'MR - 2');

  /// The unique vaccine UID from API
  final String uid;

  /// The display name for UI
  final String displayName;

  const VaccineType(this.uid, this.displayName);

  /// Get vaccine type from UID (robust, recommended)
  static VaccineType? fromUid(String uid) {
    try {
      return VaccineType.values.firstWhere((v) => v.uid == uid.trim());
    } catch (e) {
      return null;
    }
  }

  /// Get vaccine type from display name (legacy, fallback)
  static VaccineType? fromDisplayName(String name) {
    try {
      return VaccineType.values.firstWhere((v) => v.displayName == name.trim());
    } catch (e) {
      return null;
    }
  }

  /// List all vaccine display names for UI dropdowns
  static List<String> get allDisplayNames =>
      VaccineType.values.map((v) => v.displayName).toList();

  /// List all vaccine UIDs
  static List<String> get allUids =>
      VaccineType.values.map((v) => v.uid).toList();

  /// Default vaccine to show on app launch
  static const VaccineType defaultVaccine = VaccineType.bcg;
}
