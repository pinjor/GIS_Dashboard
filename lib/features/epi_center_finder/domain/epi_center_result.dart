import 'dart:math' as math;

/// Model for EPI center search result
class EpiCenterResult {
  final String id;
  final String name;
  final DateTime sessionDate;
  final double lat;
  final double lng;
  final String? address;
  final String? startTime;
  final String? endTime;
  final double distanceKm;
  final String? orgUid;
  final bool? isFixedCenter;
  final String? typeName;
  final String? sessionDates; // Original session dates string from API
  final String? zoneName; // City corporation zone name
  final String? wardName; // Ward name (for district wards or CC wards)
  final String? cityCorporationName; // City corporation name

  EpiCenterResult({
    required this.id,
    required this.name,
    required this.sessionDate,
    required this.lat,
    required this.lng,
    this.address,
    this.startTime,
    this.endTime,
    required this.distanceKm,
    this.orgUid,
    this.isFixedCenter,
    this.typeName,
    this.sessionDates,
    this.zoneName,
    this.wardName,
    this.cityCorporationName,
  });

  /// Create from Session Plan API feature
  factory EpiCenterResult.fromSessionPlanFeature(
    dynamic feature,
    double userLat,
    double userLng,
    DateTime selectedDate,
  ) {
    final info = feature.info;
    final geometry = feature.geometry;
    
    // Extract coordinates
    double lat = 0.0;
    double lng = 0.0;
    if (geometry?.coordinates != null && geometry!.coordinates!.length >= 2) {
      lng = (geometry.coordinates![0] as num).toDouble();
      lat = (geometry.coordinates![1] as num).toDouble();
    }

    // Calculate distance
    final distanceKm = _haversineKm(userLat, userLng, lat, lng);

    // Extract session date from sessionDates string or use selected date
    DateTime sessionDate = selectedDate;
    if (feature.sessionDates != null && feature.sessionDates!.isNotEmpty) {
      // Try to parse date from sessionDates
      try {
        // Format might be "2025-12-01" or "2025-12-01,2025-12-15"
        final dateStr = feature.sessionDates!.split(',').first.trim();
        sessionDate = DateTime.parse(dateStr);
      } catch (e) {
        // Use selected date if parsing fails
        sessionDate = selectedDate;
      }
    }

    // Try to extract zone/ward information from feature's raw data
    // The session plan API might include additional fields in the info object
    String? zoneName;
    String? wardName;
    String? cityCorporationName;
    
    // Check if feature has additional properties that might contain zone/ward info
    // This handles cases where the API returns extra fields not in the Info model
    try {
      // Try to access raw JSON if available
      // Feature might be a Map or a Feature object with toJson method
      Map<String, dynamic>? featureMap;
      
      if (feature is Map) {
        featureMap = feature as Map<String, dynamic>;
      } else {
        // Try to convert to JSON if it has a toJson method
        try {
          featureMap = feature.toJson() as Map<String, dynamic>?;
        } catch (e) {
          // If conversion fails, try accessing properties directly
          featureMap = null;
        }
      }
      
      if (featureMap != null) {
        // First check feature-level fields (some APIs put zone/ward at feature level)
        zoneName = featureMap['zone_name'] as String? ?? 
                   featureMap['zoneName'] as String? ??
                   featureMap['cc_zone_name'] as String? ??
                   featureMap['ccZoneName'] as String?;
        wardName = featureMap['ward_name'] as String? ?? 
                   featureMap['wardName'] as String? ??
                   featureMap['cc_ward_name'] as String? ??
                   featureMap['ccWardName'] as String?;
        cityCorporationName = featureMap['city_corporation_name'] as String? ?? 
                              featureMap['cityCorporationName'] as String? ??
                              featureMap['cc_name'] as String? ??
                              featureMap['ccName'] as String?;
        
        // Then check info object fields (fallback if not at feature level)
        final infoMap = featureMap['info'] as Map<String, dynamic>?;
        
        if (infoMap != null) {
          // Only use info fields if feature-level fields weren't found
          zoneName ??= infoMap['zone_name'] as String? ?? 
                       infoMap['zoneName'] as String? ??
                       infoMap['cc_zone_name'] as String? ??
                       infoMap['ccZoneName'] as String?;
          wardName ??= infoMap['ward_name'] as String? ?? 
                       infoMap['wardName'] as String? ??
                       infoMap['cc_ward_name'] as String? ??
                       infoMap['ccWardName'] as String?;
          cityCorporationName ??= infoMap['city_corporation_name'] as String? ?? 
                                  infoMap['cityCorporationName'] as String? ??
                                  infoMap['cc_name'] as String? ??
                                  infoMap['ccName'] as String?;
        }
      }
    } catch (e) {
      // If extraction fails, continue without zone/ward info
      // This is expected if the API doesn't include these fields
    }

    return EpiCenterResult(
      id: info?.orgUid ?? 'unknown_${lat}_$lng',
      name: info?.name ?? 'EPI Center',
      sessionDate: sessionDate,
      lat: lat,
      lng: lng,
      distanceKm: distanceKm,
      orgUid: info?.orgUid,
      isFixedCenter: info?.isFixedCenter ?? false,
      typeName: info?.typeName,
      sessionDates: feature.sessionDates,
      zoneName: zoneName,
      wardName: wardName,
      cityCorporationName: cityCorporationName,
    );
  }

  /// Haversine formula to calculate distance between two points in kilometers
  static double _haversineKm(double lat1, double lon1, double lat2, double lon2) {
    const double earthRadiusKm = 6371.0;

    final double dLat = _degreesToRadians(lat2 - lat1);
    final double dLon = _degreesToRadians(lon2 - lon1);

    final double a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_degreesToRadians(lat1)) *
            math.cos(_degreesToRadians(lat2)) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);

    final double c = 2 * math.asin(math.sqrt(a));
    return earthRadiusKm * c;
  }

  static double _degreesToRadians(double degrees) {
    return degrees * (3.141592653589793 / 180.0);
  }
}
