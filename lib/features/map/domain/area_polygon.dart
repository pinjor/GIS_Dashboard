import 'package:flutter_map/flutter_map.dart';

/// Class to represent a polygon with associated area data
class AreaPolygon {
  final Polygon polygon;
  final String areaId;
  final String areaName;
  final String level;
  final double coveragePercentage;

  AreaPolygon({
    required this.polygon,
    required this.areaId,
    required this.areaName,
    required this.level,
    required this.coveragePercentage,
  });
}
