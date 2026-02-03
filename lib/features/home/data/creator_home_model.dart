class CreatorHomeModel {
  final int rank;
  final int totalDiamond;
  final String totalHour;

  CreatorHomeModel({
    required this.rank,
    required this.totalDiamond,
    required this.totalHour,
  });

  /// Factory constructor to parse from JSON
  factory CreatorHomeModel.fromJson(Map<String, dynamic> json) {
    return CreatorHomeModel(
      rank: json['rank'] ?? 0,
      totalDiamond: json['total_diamond'] ?? 0,
      totalHour: json['total_hour'] ?? '0',
    );
  }

  /// Convert object back to JSON
  Map<String, dynamic> toJson() {
    return {
      'rank': rank,
      'total_diamond': totalDiamond,
      'total_hour': totalHour,
    };
  }
}
