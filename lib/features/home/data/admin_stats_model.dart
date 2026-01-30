// admin_stats_model.dart

class AdminStatsModel {
  final int totalCreators;
  final int totalManagers;
  final int scrapeToday;
  final int totalDiamondAchieve;

  AdminStatsModel({
    required this.totalCreators,
    required this.totalManagers,
    required this.scrapeToday,
    required this.totalDiamondAchieve,
  });

  factory AdminStatsModel.fromJson(Map<String, dynamic> json) {
    return AdminStatsModel(
      totalCreators: json['total_creators'] ?? 0,
      totalManagers: json['total_managers'] ?? 0,
      scrapeToday: json['scrape_today'] ?? 0,
      totalDiamondAchieve: json['total_diamond_achieve'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_creators': totalCreators,
      'total_managers': totalManagers,
      'scrape_today': scrapeToday,
      'total_diamond_achieve': totalDiamondAchieve,
    };
  }

  // Formatted values for UI
  String get totalCreatorsFormatted {
    if (totalCreators >= 1000) {
      return '${(totalCreators / 1000).toStringAsFixed(1)}K';
    }
    return totalCreators.toString();
  }

  String get totalManagersFormatted {
    if (totalManagers >= 1000) {
      return '${(totalManagers / 1000).toStringAsFixed(1)}K';
    }
    return totalManagers.toString();
  }

  String get scrapeTodayFormatted {
    if (scrapeToday >= 1000000) {
      return '${(scrapeToday / 1000000).toStringAsFixed(1)}M';
    } else if (scrapeToday >= 1000) {
      return '${(scrapeToday / 1000).toStringAsFixed(1)}K';
    }
    return scrapeToday.toString();
  }

  String get totalDiamondAchieveFormatted {
    if (totalDiamondAchieve >= 1000000) {
      return '${(totalDiamondAchieve / 1000000).toStringAsFixed(1)}M';
    } else if (totalDiamondAchieve >= 1000) {
      return '${(totalDiamondAchieve / 1000).toStringAsFixed(1)}K';
    }
    return totalDiamondAchieve.toString();
  }

  // With comma separator (like screenshot: 45,623)
  String get scrapeTodayWithComma {
    return scrapeToday.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
    );
  }

  String get totalDiamondWithComma {
    return totalDiamondAchieve.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
    );
  }

  String get totalCreatorsWithComma {
    return totalCreators.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
    );
  }

  // Helper methods
  bool get hasManagers => totalManagers > 0;
  bool get hasCreators => totalCreators > 0;
  bool get hasScrapedToday => scrapeToday > 0;
  bool get hasDiamonds => totalDiamondAchieve > 0;

  double get creatorsPerManager {
    if (totalManagers == 0) return 0;
    return totalCreators / totalManagers;
  }

  String get creatorsPerManagerFormatted {
    return creatorsPerManager.toStringAsFixed(1);
  }
}