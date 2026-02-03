class ManagerHomeModel {
  final int myCreators;
  final int rank;
  final int atRisk;
  final int totalDiamond;
  final String totalHour;

  ManagerHomeModel({
    required this.myCreators,
    required this.rank,
    required this.atRisk,
    required this.totalDiamond,
    required this.totalHour,
  });

  /// Factory constructor from JSON
  factory ManagerHomeModel.fromJson(Map<String, dynamic> json) {
    return ManagerHomeModel(
      myCreators: json['my_creators'] ?? 0,
      rank: json['rank'] ?? 0,
      atRisk: json['at_risk'] ?? 0,
      totalDiamond: json['total_diamond'] ?? 0,
      totalHour: json['total_hour'] ?? '0',
    );
  }

  /// Convert back to JSON
  Map<String, dynamic> toJson() {
    return {
      'my_creators': myCreators,
      'rank': rank,
      'at_risk': atRisk,
      'total_diamond': totalDiamond,
      'total_hour': totalHour,
    };
  }
}
