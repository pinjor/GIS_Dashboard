class ShapeFeature {
  final Map<String, dynamic> properties;
  final FeatureInfo? info;
  final dynamic geometry;

  ShapeFeature({
    required this.properties,
    this.info,
    required this.geometry,
  });

  factory ShapeFeature.fromJson(Map<String, dynamic> json) {
    return ShapeFeature(
      properties: json['properties'] ?? {},
      info: json['info'] != null ? FeatureInfo.fromJson(json['info']) : null,
      geometry: json['geometry'],
    );
  }
}

class FeatureInfo {
  final String? name;
  final String? type;
  final String? slug;
  final String? orgUid;
  final String? parentSlug;

  FeatureInfo({
    this.name,
    this.type,
    this.slug,
    this.orgUid,
    this.parentSlug,
  });

  factory FeatureInfo.fromJson(Map<String, dynamic> json) {
    return FeatureInfo(
      name: json['name'],
      type: json['type'],
      slug: json['slug'],
      orgUid: json['org_uid'],
      parentSlug: json['parent_slug'],
    );
  }
}