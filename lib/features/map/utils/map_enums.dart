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

  /// Ward level (terminal level for drilldown)
  ward('ward'),

  /// Smallest administrative unit - COMMENTED OUT as it's not used in practice
  /// and causes confusion. Ward is the actual terminal level.
  // subblock('subblock');

  // for city corporation based drilldown
  // city corporation level
  cityCorporation('city_corporation'),
  /// Zone level (for city corporation)
  zone('zone');

  const GeographicLevel(this.value);

  final String value;

  /// Get the next level in the hierarchy for drilldown
  GeographicLevel? get nextLevel {
    switch (this) {
      case GeographicLevel.country:
        return GeographicLevel
            .district; // Map drilldown: Country → District (skip division)
      case GeographicLevel.division:
        return GeographicLevel.district;
      case GeographicLevel.district:
        return GeographicLevel.upazila;
      case GeographicLevel.upazila:
        return GeographicLevel.union;
      case GeographicLevel.union:
        return GeographicLevel.ward;
      case GeographicLevel.ward:
        return null; // Ward is now the terminal level - no further drilldown

      // for city corporation based drilldown
      case GeographicLevel.cityCorporation:
        return GeographicLevel.zone;
      case GeographicLevel.zone:
        return null; // Zone is terminal level within city corporation context
    }
  }

  /// Get the previous level in the hierarchy for going back
  /// NOTE: This is primarily used for reference. Actual navigation uses navigation stack context.
  GeographicLevel? get previousLevel {
    switch (this) {
      case GeographicLevel.country:
        return null; // No level above country
      case GeographicLevel.division:
        return GeographicLevel.country;
      case GeographicLevel.district:
        return GeographicLevel
            .country; // Map navigation: District → Country (filter context may differ)
      case GeographicLevel.upazila:
        return GeographicLevel.district;
      case GeographicLevel.union:
        return GeographicLevel.upazila;
      case GeographicLevel.ward:
        return GeographicLevel.union;

      // for city corporation based drilldown
      case GeographicLevel.cityCorporation:
        return GeographicLevel.country; // City corporation goes back to country
      case GeographicLevel.zone:
        return GeographicLevel.cityCorporation;
    }
  }

  /// Check if EPI data is available at this level
  /// EPI centers are available from upazila level and deeper (upazila, union, ward)
  bool get hasEpiData {
    return this == GeographicLevel.upazila ||
        this == GeographicLevel.union ||
        this == GeographicLevel.ward ||
        this == GeographicLevel.cityCorporation ||
        this == GeographicLevel.zone;
  }

  /// Check if this level can be drilled down further
  /// this means that if the level is ward or zone, it cannot be drilled down further
  bool get canDrillDown {
    return !(this == GeographicLevel.ward || this == GeographicLevel.zone);
  }

  /// Check if this is the root/initial level (country view)
  bool get isRootLevel {
    return this == GeographicLevel.country;
  }

  /// Check if area name labels should be shown on the map
  /// Labels are shown for all levels except the root country level
  bool get shouldShowAreaLabels {
    return !isRootLevel;
  }

  /// Get the display name for this geographic level
  String get displayName {
    switch (this) {
      case GeographicLevel.country:
        return 'Country';
      case GeographicLevel.division:
        return 'Division';
      case GeographicLevel.district:
        return 'District';
      case GeographicLevel.upazila:
        return 'Upazila';
      case GeographicLevel.union:
        return 'Union';
      case GeographicLevel.ward:
        return 'Ward';
      case GeographicLevel.cityCorporation:
        return 'City Corporation';
      case GeographicLevel.zone:
        return 'Zone';
    }
  }

  /// Get minimum zoom level for this geographic level
  double get minZoomLevel {
    switch (this) {
      case GeographicLevel.country:
        return 6.6; // Exact zoom for country view
      case GeographicLevel.division:
        return 7.0; // Reduced for better division view
      case GeographicLevel.district:
        return 7.5; // Reduced for better district view
      case GeographicLevel.upazila:
        return 8.5; // Reduced for better upazila view
      case GeographicLevel.union:
        return 10.0; // Reduced for better union view
      case GeographicLevel.ward:
        return 11.5; // Reduced for better ward view - Ward is now the terminal level

      // for city corporation based drilldown
      case GeographicLevel.cityCorporation:
        return 8.0; // Reduced for better city corporation view
      case GeographicLevel.zone:
        return 11.0; // Reduced for better zone view
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
      baseZoom =
          6.2; // Very large area (country level) - reduced for better view
    } else if (maxSpan > 2.0) {
      baseZoom = 7.5; // Large area (multiple districts) - reduced
    } else if (maxSpan > 1.0) {
      baseZoom = 8.5; // Medium area (district level) - reduced
    } else if (maxSpan > 0.5) {
      baseZoom = 9.5; // Smaller area (upazila level) - reduced
    } else if (maxSpan > 0.2) {
      baseZoom = 11.0; // Small area (union level) - reduced
    } else if (maxSpan > 0.1) {
      baseZoom = 12.0; // Very small area (ward level) - reduced
    } else {
      baseZoom = 13.0; // Subblock level - reduced
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
      zoom = 6.6; // Country level - exact zoom as requested
    } else if (maxSpan > 2.0) {
      zoom = 7.2; // Large areas - reduced
    } else if (maxSpan > 1.0) {
      zoom = 8.2; // Medium areas - reduced
    } else if (maxSpan > 0.5) {
      zoom = 9.2; // Smaller areas - reduced
    } else if (maxSpan > 0.2) {
      zoom = 10.2; // Small areas - reduced
    } else if (maxSpan > 0.1) {
      zoom = 11.2; // Very small areas - reduced
    } else {
      zoom = 12.2; // Smallest areas - reduced
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
