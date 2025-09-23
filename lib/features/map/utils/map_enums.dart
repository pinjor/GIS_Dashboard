/// Geographic administrative levels in Bangladesh hierarchy
enum GeographicLevel {
  /// Country level view (shows all districts)
  country('country'),

  /// Administrative division level
  division('division'),

  /// District level (individual district)
  district('district'),

  /// Sub-district level (upazila)
  upazila('upazila'),

  /// Union level
  union('union'),

  /// Ward level
  ward('ward'),

  /// Smallest administrative unit
  subblock('subblock');

  const GeographicLevel(this.value);

  final String value;

  /// Get the next level in the hierarchy for drilldown
  GeographicLevel? get nextLevel {
    switch (this) {
      case GeographicLevel.country:
        return GeographicLevel.district;
      case GeographicLevel.division:
        return GeographicLevel.district;
      case GeographicLevel.district:
        return GeographicLevel.upazila;
      case GeographicLevel.upazila:
        return GeographicLevel.union;
      case GeographicLevel.union:
        return GeographicLevel.ward;
      case GeographicLevel.ward:
        return GeographicLevel.subblock;
      case GeographicLevel.subblock:
        return null; // No further drilldown
    }
  }

  /// Get the previous level in the hierarchy for going back
  GeographicLevel? get previousLevel {
    switch (this) {
      case GeographicLevel.country:
        return null; // No level above country
      case GeographicLevel.division:
        return GeographicLevel.country;
      case GeographicLevel.district:
        return GeographicLevel.country; // or division depending on context
      case GeographicLevel.upazila:
        return GeographicLevel.district;
      case GeographicLevel.union:
        return GeographicLevel.upazila;
      case GeographicLevel.ward:
        return GeographicLevel.union;
      case GeographicLevel.subblock:
        return GeographicLevel.ward;
    }
  }

  /// Check if EPI data is available at this level
  bool get hasEpiData {
    return this == GeographicLevel.union ||
        this == GeographicLevel.ward ||
        this == GeographicLevel.subblock;
  }

  /// Check if this level can be drilled down further
  bool get canDrillDown {
    return this != GeographicLevel.subblock;
  }

  /// Get minimum zoom level for this geographic level
  double get minZoomLevel {
    switch (this) {
      case GeographicLevel.country:
        return 6.0;
      case GeographicLevel.division:
        return 6.5;
      case GeographicLevel.district:
        return 6.5;
      case GeographicLevel.upazila:
        return 8.0;
      case GeographicLevel.union:
        return 10.0;
      case GeographicLevel.ward:
        return 11.5;
      case GeographicLevel.subblock:
        return 12.5;
    }
  }

  /// Calculate appropriate zoom level based on bounds size and polygon count
  /// This centralizes zoom calculation logic that was scattered across the app
  double calculateZoomForBounds({
    required double maxSpan,
    required int polygonCount,
  }) {
    // Base zoom calculation based on span size
    double baseZoom;
    if (maxSpan > 5.0) {
      baseZoom = 6.0; // Very large area (country level)
    } else if (maxSpan > 2.0) {
      baseZoom = 7.5; // Large area (multiple districts)
    } else if (maxSpan > 1.0) {
      baseZoom = 8.5; // Medium area (district level)
    } else if (maxSpan > 0.5) {
      baseZoom = 9.5; // Smaller area (upazila level)
    } else if (maxSpan > 0.2) {
      baseZoom = 11.0; // Small area (union level)
    } else if (maxSpan > 0.1) {
      baseZoom = 12.0; // Very small area (ward level)
    } else {
      baseZoom = 13.0; // Subblock level
    }

    // Adjust zoom based on polygon density
    if (polygonCount > 50) {
      baseZoom -= 0.5; // Zoom out for many polygons
    } else if (polygonCount > 20) {
      baseZoom -= 0.3; // Slight zoom out for moderate polygon count
    } else if (polygonCount == 1) {
      baseZoom += 0.5; // Zoom in for single polygon
    }

    // Use the enum's minZoomLevel method for level-specific minimum zoom
    // Ensure zoom is within reasonable bounds (6.0 to 15.0)
    return minZoomLevel > baseZoom
        ? minZoomLevel
        : (baseZoom > 15.0 ? 15.0 : baseZoom);
  }

  /// Get optimal zoom level for auto-zoom based on span size (simplified)
  /// Used for quick auto-zoom calculations
  double getOptimalZoomForSpan(double maxSpan) {
    double zoom;
    if (maxSpan > 4.0) {
      zoom = 6.0;
    } else if (maxSpan > 2.0) {
      zoom = 7.0;
    } else if (maxSpan > 1.0) {
      zoom = 8.0;
    } else if (maxSpan > 0.5) {
      zoom = 9.0;
    } else if (maxSpan > 0.2) {
      zoom = 10.0;
    } else if (maxSpan > 0.1) {
      zoom = 11.0;
    } else {
      zoom = 12.0;
    }

    // Ensure zoom is within reasonable bounds and respects minimum zoom for this level
    return minZoomLevel > zoom ? minZoomLevel : (zoom > 15.0 ? 15.0 : zoom);
  }

  /// Create GeographicLevel from string value with fallback
  static GeographicLevel fromString(String value) {
    return GeographicLevel.values.firstWhere(
      (level) => level.value == value,
      orElse: () => GeographicLevel.district, // Default fallback
    );
  }
}

/// Area types for filter purposes
enum AreaType {
  /// Regular district areas
  district('district'),

  /// City corporation areas (urban administrative units)
  cityCorporation('city_corporation');

  const AreaType(this.value);

  final String value;

  /// Create AreaType from string value with fallback
  static AreaType fromString(String value) {
    return AreaType.values.firstWhere(
      (type) => type.value == value,
      orElse: () => AreaType.district, // Default fallback
    );
  }
}
