import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

import '../../../../core/common/constants/constants.dart';
import '../../../../core/utils/utils.dart';

class MapTileLayer extends StatelessWidget {
  const MapTileLayer({super.key});

  @override
  Widget build(BuildContext context) {
    return TileLayer(
      urlTemplate: Constants.urlTemplate,
      subdomains: Constants.subDomains,
      // Add fallback URL for better reliability
      fallbackUrl: Constants.fallbackUrl,
      // Silence network exceptions to prevent error flooding
      tileProvider: NetworkTileProvider(silenceExceptions: true),
      // Add user agent to comply with OSM usage policy
      userAgentPackageName: Constants.userAgentPackageName,
      // Error handling configuration
      errorTileCallback: (tile, error, stackTrace) {
        // Log the error but don't show UI errors
        logg.w('Tile loading error for ${tile.coordinates}: $error');
      },
      // Keep tiles in memory longer to reduce reloads
      keepBuffer: 3,
      // Reduce tile loading during panning
      panBuffer: 1,
      // Limit max zoom to reduce tile requests
      maxZoom: 15,
    );
  }
}
