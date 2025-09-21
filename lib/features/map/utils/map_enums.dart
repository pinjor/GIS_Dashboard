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
    return this == GeographicLevel.upazila ||
        this == GeographicLevel.union ||
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
