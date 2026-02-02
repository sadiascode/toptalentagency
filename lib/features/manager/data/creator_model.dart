class CreatorModel {
  final int id;
  final String username;
  final int managerId;
  final String managerUsername;
  final double totalHour;
  final double totalCoin;
  final int totalDiamond;
  final Last3Months last3Months;
  final int targetDiamonds;
  final int rank;

  CreatorModel({
    required this.id,
    required this.username,
    required this.managerId,
    required this.managerUsername,
    required this.totalHour,
    required this.totalCoin,
    required this.totalDiamond,
    required this.last3Months,
    required this.targetDiamonds,
    required this.rank,
  });

  factory CreatorModel.fromJson(Map<String, dynamic> json) {
    return CreatorModel(
      id: json['id'] ?? 0,
      username: json['username'] ?? '',
      managerId: json['manager_id'] ?? 0,
      managerUsername: json['manager_username'] ?? '',
      totalHour: double.tryParse(json['total_hour']?.toString() ?? '0') ?? 0.0,
      totalCoin: double.tryParse(json['total_coin']?.toString() ?? '0') ?? 0.0,
      totalDiamond: json['total_diamond'] ?? 0,
      last3Months: Last3Months.fromJson(json['last_3_months'] ?? {}),
      targetDiamonds: json['target_diamonds'] ?? 0,
      rank: json['rank'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'manager_id': managerId,
      'manager_username': managerUsername,
      'total_hour': totalHour,
      'total_coin': totalCoin,
      'total_diamond': totalDiamond,
      'last_3_months': last3Months.toJson(),
      'target_diamonds': targetDiamonds,
      'rank': rank,
    };
  }

  @override
  String toString() {
    return 'CreatorModel(username: $username, manager: $managerUsername, totalDiamond: $totalDiamond, rank: $rank)';
  }
}

// ------------------- Last 3 Months -------------------

class Last3Months {
  final Map<String, MonthStats> months;

  Last3Months({required this.months});

  factory Last3Months.fromJson(Map<String, dynamic> json) {
    final Map<String, MonthStats> monthsMap = {};
    json.forEach((month, stats) {
      if (stats is Map<String, dynamic>) {
        monthsMap[month] = MonthStats.fromJson(stats);
      }
    });
    return Last3Months(months: monthsMap);
  }

  Map<String, dynamic> toJson() {
    return months.map((month, stats) => MapEntry(month, stats.toJson()));
  }

  @override
  String toString() => months.toString();
}

// ------------------- Month Stats -------------------

class MonthStats {
  final int diamonds;
  final double hours;

  MonthStats({required this.diamonds, required this.hours});

  factory MonthStats.fromJson(Map<String, dynamic> json) {
    return MonthStats(
      diamonds: json['diamonds'] ?? 0,
      hours: double.tryParse(json['hours']?.toString() ?? '0') ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'diamonds': diamonds,
      'hours': hours,
    };
  }

  @override
  String toString() => 'MonthStats(diamonds: $diamonds, hours: $hours)';
}
