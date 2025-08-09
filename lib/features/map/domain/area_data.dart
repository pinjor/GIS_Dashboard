class AreaData {
  final String uid;
  final String name;
  final double? coveragePercentage;
  final double? coveragePercentageMale;
  final double? coveragePercentageFemale;
  final int? target;
  final int? coverage;
  final int? dropout;

  AreaData({
    required this.uid,
    required this.name,
    this.coveragePercentage,
    this.coveragePercentageMale,
    this.coveragePercentageFemale,
    this.target,
    this.coverage,
    this.dropout,
  });

  factory AreaData.fromJson(Map<String, dynamic> json) {
    return AreaData(
      uid: json['uid'] ?? '',
      name: json['name'] ?? '',
      coveragePercentage: json['coverage_percentage']?.toDouble(),
      coveragePercentageMale: json['coverage_percentage_male']?.toDouble(),
      coveragePercentageFemale: json['coverage_percentage_female']?.toDouble(),
      target: json['target'],
      coverage: json['coverage'],
      dropout: json['dropout'],
    );
  }
}
