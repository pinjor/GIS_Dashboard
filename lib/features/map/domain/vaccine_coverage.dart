class VaccineCoverage {
  final String uid;
  final String name;
  final double coveragePercentage;

  VaccineCoverage({
    required this.uid,
    required this.name,
    required this.coveragePercentage,
  });

  factory VaccineCoverage.fromJson(Map<String, dynamic> json) {
    return VaccineCoverage(
      uid: json['uid'] as String,
      name: json['name'] as String,
      coveragePercentage: (json['coverage_percentage'] as num).toDouble(),
    );
  }
}
