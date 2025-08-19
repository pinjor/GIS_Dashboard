import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
  static final String urlScheme = dotenv.env['URL_SCHEME'] ?? '';
  static final String stagingHost = dotenv.env['STAGING_HOST'] ?? '';
  static final String prodHost = dotenv.env['PROD_HOST'] ?? '';
  static final String baseUrlProd = dotenv.env['PROD_SERVER_URL'] ?? '';
  static final String baseUrlStaging = dotenv.env['STAGING_SERVER_URL'] ?? '';
  static final String urlCommonPath = dotenv.env['URL_COMMON_PATH'] ?? '';

  static String get districtJsonPath => '/shapes/shape.json.gz';
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
    return '/shapes/$slug/shape.json.gz';
  }

  /// Generate coverage path based on slug and year
  /// Example: /coverage/dhaka-district/2025-coverage.json
  static String getCoveragePath({String? slug, required String year}) {
    if (slug == null || slug.isEmpty) {
      return '/coverage/$year-coverage.json'; // Default country level
    }
    return '/coverage/$slug/$year-coverage.json';
  }

  /// Legacy getters for backward compatibility
  static String getCoveragePath25({String? slug}) =>
      getCoveragePath(slug: slug, year: '2025');
  static String getCoveragePath24({String? slug}) =>
      getCoveragePath(slug: slug, year: '2024');
}
