class ManagerHomeModel {
  final String? username;
  final int myCreators;
  final int rank;
  final int atRisk;
  final int totalDiamond;
  final String totalHour;

  ManagerHomeModel({
    this.username,
    required this.myCreators,
    required this.rank,
    required this.atRisk,
    required this.totalDiamond,
    required this.totalHour,
  });

  /// Factory constructor from JSON
  factory ManagerHomeModel.fromJson(Map<String, dynamic> json) {
    print('🔍 ManagerHomeModel.fromJson called with:');
    print('   - Full JSON keys: ${json.keys.toList()}');
    print('   - Full JSON data: $json');
    print(
      '   - total_diamond key exists: ${json.containsKey('total_diamond')}',
    );
    print('   - total_diamond value: ${json['total_diamond']}');
    print('   - total_diamond type: ${json['total_diamond'].runtimeType}');

    final totalDiamond = json['total_diamond'] ?? 0;
    print('   - Parsed totalDiamond: $totalDiamond');

    return ManagerHomeModel(
      username: json['username'] ?? json['name'] ?? json['manager_name'],
      myCreators: json['my_creators'] ?? 0,
      rank: json['rank'] ?? 0,
      atRisk: json['at_risk'] ?? 0,
      totalDiamond: totalDiamond,
      totalHour: json['total_hour'] ?? '0',
    );
  }

  /// Convert back to JSON
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'my_creators': myCreators,
      'rank': rank,
      'at_risk': atRisk,
      'total_diamond': totalDiamond,
      'total_hour': totalHour,
    };
  }
}
