import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
  static final String urlScheme = dotenv.env['URL_SCHEME'] ?? '';
  static final String stagingHost = dotenv.env['STAGING_HOST'] ?? '';
  // static final String prodHost = dotenv.env['PROD_HOST'] ?? '';
  // static final String baseUrlProd = dotenv.env['PROD_SERVER_URL'] ?? '';
  static final String baseUrlStaging = dotenv.env['STAGING_SERVER_URL'] ?? '';
  static final String urlCommonPath = dotenv.env['URL_COMMON_PATH'] ?? '';
  static final String epiCenterDataBaseUrl =
      dotenv.env['EPI_CENTER_DATA_BASE_URL'] ?? '';

  static String get districtJsonPath => '/shapes/shape.json.gz';

  // these two paths needs to be dynamic based on year value, like a getter function like below:::

  // static String districtCoveragePath(String year) => '/coverage/$year-coverage.json';
  static String get districtCoveragePath25 => '/coverage/2025-coverage.json';
  static String get districtCoveragePath24 => '/coverage/2024-coverage.json';

  static String get filterByArea => '/areas';

  /// Dynamic path generators for drilldown functionality

  /// Generate GeoJSON path based on slug
  /// Example: /shapes/dhaka-district/shape.json.gz
  static String getGeoJsonPath({String? slug}) {
    if (slug == null || slug.isEmpty) {
      return districtJsonPath; // Default country level
    }
    // Convert slug to lowercase to handle any UIDs that might be in the slug
    return '/shapes/${slug.toLowerCase()}/shape.json.gz';
  }

  /// Generate coverage path based on slug and year
  /// Example: /coverage/dhaka-district/2025-coverage.json
  static String getCoveragePath({String? slug, required String year}) {
    if (slug == null || slug.isEmpty) {
      return '/coverage/$year-coverage.json'; // Default country level
    }
    // Convert slug to lowercase to handle any UIDs that might be in the slug
    return '/coverage/${slug.toLowerCase()}/$year-coverage.json';
  }

  /// Generate EPI path based on slug
  /// Example: /epi/sunamganj-district/tahirpur-upazila/epi.json
  static String getEpiPath({String? slug}) {
    if (slug == null || slug.isEmpty) {
      return '/epi/epi.json'; // Default if no slug
    }
    // Convert slug to lowercase to handle any UIDs that might be in the slug
    return '/epi/${slug.toLowerCase()}/epi.json';
  }

  /// Generate division-specific paths
  /// Example: /shapes/divisions/barishal-division/shape.json.gz
  static String getDivisionGeoJsonPath({required String divisionSlug}) {
    return '/shapes/divisions/$divisionSlug/shape.json.gz';
  }

  /// Generate division coverage path
  /// Example: /coverage/divisions/barishal-division/2025-coverage.json
  static String getDivisionCoveragePath({
    required String divisionSlug,
    required String year,
  }) {
    return '/coverage/divisions/$divisionSlug/$year-coverage.json';
  }

  /// Generate city corporation-specific paths with fallback strategy
  /// Returns list of URLs to try: [UID-based, name-based]
  static List<String> getCityCorporationGeoJsonPaths({
    String? ccUid,
    String? ccName,
  }) {
    List<String> paths = [];

    // Try UID first if available (convert to lowercase for URL)
    if (ccUid != null && ccUid.isNotEmpty) {
      final lowercaseUid = ccUid.toLowerCase();
      paths.add('/shapes/$lowercaseUid/shape.json.gz');
    }

    // Then try name-based slug if available
    if (ccName != null && ccName.isNotEmpty) {
      final ccSlug = cityCorporationNameToSlug(ccName);
      paths.add('/shapes/$ccSlug/shape.json.gz');
    }

    return paths;
  }

  /// Generate city corporation coverage paths with fallback strategy
  static List<String> getCityCorporationCoveragePaths({
    String? ccUid,
    String? ccName,
    required String year,
  }) {
    List<String> paths = [];

    // Try UID first if available (convert to lowercase for URL)
    if (ccUid != null && ccUid.isNotEmpty) {
      final lowercaseUid = ccUid.toLowerCase();
      paths.add('/coverage/$lowercaseUid/$year-coverage.json');
    }

    // Then try name-based slug if available
    if (ccName != null && ccName.isNotEmpty) {
      final ccSlug = cityCorporationNameToSlug(ccName);
      paths.add('/coverage/$ccSlug/$year-coverage.json');
    }

    return paths;
  }

  /// Generate city corporation EPI paths with fallback strategy
  static List<String> getCityCorporationEpiPaths({
    String? ccUid,
    String? ccName,
  }) {
    List<String> paths = [];

    // Try UID first if available (convert to lowercase for URL)
    if (ccUid != null && ccUid.isNotEmpty) {
      final lowercaseUid = ccUid.toLowerCase();
      paths.add('/epi/$lowercaseUid/epi.json');
    }

    // Then try name-based slug if available
    if (ccName != null && ccName.isNotEmpty) {
      final ccSlug = cityCorporationNameToSlug(ccName);
      paths.add('/epi/$ccSlug/epi.json');
    }

    return paths;
  }

  /// Legacy single-path methods for backward compatibility
  /// Example: /shapes/dhaka-north-cc/shape.json.gz
  static String getCityCorporationGeoJsonPath({required String ccSlug}) {
    return '/shapes/$ccSlug/shape.json.gz';
  }

  /// Generate city corporation coverage path
  /// Example: /coverage/dhaka-north-cc/2025-coverage.json
  static String getCityCorporationCoveragePath({
    required String ccSlug,
    required String year,
  }) {
    return '/coverage/$ccSlug/$year-coverage.json';
  }

  /// Generate city corporation EPI path
  /// Example: /epi/dhaka-north-cc/epi.json
  static String getCityCorporationEpiPath({required String ccSlug}) {
    return '/epi/$ccSlug/epi.json';
  }

  /// Helper methods to convert names to proper slugs for different types

  /// Convert division name to slug format
  /// Example: "Rangpur Division" -> "rangpur-division"
  static String divisionNameToSlug(String divisionName) {
    return divisionName.toLowerCase().replaceAll(' ', '-').replaceAll('\'', '');
  }

  /// Convert city corporation name to slug format
  /// Example: "Narayanganj CC" -> "narayanganj-cc"
  static String cityCorporationNameToSlug(String ccName) {
    return ccName.toLowerCase().replaceAll(' ', '-').replaceAll('\'', '');
  }

  /// Legacy getters for backward compatibility
  static String getCoveragePath25({String? slug}) =>
      getCoveragePath(slug: slug, year: '2025');
  static String getCoveragePath24({String? slug}) =>
      getCoveragePath(slug: slug, year: '2024');
}
