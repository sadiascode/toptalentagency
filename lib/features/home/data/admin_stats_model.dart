class AdminStatsModel {
  final int totalCreators;
  final int totalManagers;
  final int scrapeToday;
  final int totalDiamondAchieve;
  final double totalHour;

  AdminStatsModel({
    required this.totalCreators,
    required this.totalManagers,
    required this.scrapeToday,
    required this.totalDiamondAchieve,
    required this.totalHour,
  });

  factory AdminStatsModel.fromJson(Map<String, dynamic> json) {
    return AdminStatsModel(
      totalCreators: json['total_creators'] ?? 0,
      totalManagers: json['total_managers'] ?? 0,
      scrapeToday: json['scrape_today'] ?? 0,
      totalDiamondAchieve: json['total_diamond_achieve'] ?? 0,
      totalHour: double.tryParse(json['total_hour'].toString()) ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_creators': totalCreators,
      'total_managers': totalManagers,
      'scrape_today': scrapeToday,
      'total_diamond_achieve': totalDiamondAchieve,
      'total_hour': totalHour,
    };
  }

  // Format totalDiamondAchieve as million/thousand
  String get formattedDiamondAchieve {
    if (totalDiamondAchieve >= 1000000) {
      return '${(totalDiamondAchieve / 1000000).toStringAsFixed(2)}M';
    } else if (totalDiamondAchieve >= 1000) {
      return '${(totalDiamondAchieve / 1000).toStringAsFixed(1)}K';
    } else {
      return totalDiamondAchieve.toString();
    }
  }

  // Format totalHour as million/thousand
  String get formattedHour {
    if (totalHour >= 1000000) {
      return '${(totalHour / 1000000).toStringAsFixed(2)}M';
    } else if (totalHour >= 1000) {
      return '${(totalHour / 1000).toStringAsFixed(1)}K';
    } else {
      return totalHour.toStringAsFixed(1);
    }
  }
}
