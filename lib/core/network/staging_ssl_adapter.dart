// ===========================================================================
// ⚠️  SSL BYPASS ADAPTER
// ===========================================================================
//
// PURPOSE:
// This file configures Dio to bypass SSL certificate validation for
// the staging server (staging.gisdashboard.online) which has an expired
// certificate.
//
// IMPORTANT:
// This bypasses SSL validation for ALL environments (debug, profile, release).
//
// TODO: REMOVE THIS FILE AND ITS USAGE once the staging SSL certificate
//       is renewed and valid.
//
// ===========================================================================

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:gis_dashboard/core/common/constants/api_constants.dart';
import 'package:gis_dashboard/core/utils/utils.dart';

/// Factory class to create Dio HTTP client adapters with SSL bypass.
///
/// TODO: Remove this class once SSL certificate on staging is fixed.
class StagingSslAdapter {
  /// The staging host that bypasses SSL validation.
  static String get _stagingHost => ApiConstants.stagingServerHost;

  /// Creates an IOHttpClientAdapter that bypasses SSL validation.
  ///
  /// This adapter will accept invalid/expired certificates from the staging host.
  ///
  /// Returns an [IOHttpClientAdapter] that can be assigned to Dio.httpClientAdapter
  static IOHttpClientAdapter createAdapter() {
    return IOHttpClientAdapter(
      createHttpClient: () {
        final client = HttpClient();

        // Bypass SSL validation for staging host
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) {
              // Accept all certificates from the staging host
              final isAllowedHost = host == _stagingHost;

              if (isAllowedHost) {
                logg.w('⚠️ SSL BYPASS: Accepting certificate for: $host');
                return true;
              }

              // For other hosts, also accept to prevent any SSL issues
              // TODO: Change this back to false once staging SSL is fixed
              logg.w('⚠️ SSL BYPASS: Accepting certificate for: $host');
              return true;
            };

        return client;
      },
    );
  }

  /// Configures an existing Dio instance with SSL bypass.
  ///
  /// TODO: Remove calls to this method once SSL certificate is fixed.
  static void configureForDio(Dio dio) {
    dio.httpClientAdapter = createAdapter();
    logg.i('🔧 SSL Bypass configured (all certificates accepted)');
  }
}
