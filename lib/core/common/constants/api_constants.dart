import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
  static final String baseUrlProd = dotenv.env['PROD_SERVER_URL'] ?? '';
  static final String baseUrlStaging = dotenv.env['STAGING_SERVER_URL'] ?? '';
  static final String urlCommonPath = dotenv.env['URL_COMMON_PATH'] ?? '';

  static String get districtJsonPath => '/shapes/shape.json.gz';
  static String get districtCoveragePath25 => '/coverage/2025-coverage.json';
  static String get districtCoveragePath24 => '/coverage/2024-coverage.json';
}
