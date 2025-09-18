import 'package:flutter_map/flutter_map.dart';

/// Class to represent a polygon with associated area data
/// This class holds the polygon shape and metadata for a specific geographical area.
/// It is used to render areas on the map and provide relevant information.
/// Polygon: Units of the area (e.g., district, state)
/// AreaPolygon: Represents a polygon with area metadata
class AreaPolygon {
  final Polygon polygon;
  final String areaId;
  final String areaName;
  final String level; 
  final double? coveragePercentage;
  final String? slug;
  final String? parentSlug;
  final bool canDrillDown;

  AreaPolygon({
    required this.polygon,
    required this.areaId,
    required this.areaName,
    required this.level,
    this.coveragePercentage,
    this.slug,
    this.parentSlug,
    this.canDrillDown = false,
  });

  /// Create a copy with updated properties
  AreaPolygon copyWith({
    Polygon? polygon,
    String? areaId,
    String? areaName,
    String? level,
    double? coveragePercentage,
    String? slug,
    String? parentSlug,
    bool? canDrillDown,
  }) {
    return AreaPolygon(
      polygon: polygon ?? this.polygon,
      areaId: areaId ?? this.areaId,
      areaName: areaName ?? this.areaName,
      level: level ?? this.level,
      coveragePercentage: coveragePercentage ?? this.coveragePercentage,
      slug: slug ?? this.slug,
      parentSlug: parentSlug ?? this.parentSlug,
      canDrillDown: canDrillDown ?? this.canDrillDown,
    );
  }
}
