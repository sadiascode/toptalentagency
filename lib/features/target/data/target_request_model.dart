// Manager/Agency Model
class TargetRequestModel {
  final int id;
  final String username;
  final int managerId;
  final String managerUsername;
  final String totalDiamond;
  final String totalHour;
  final int targetDiamonds;
  final int targetHours;
  final int rank;

  TargetRequestModel({
    required this.id,
    required this.username,
    required this.managerId,
    required this.managerUsername,
    required this.totalDiamond,
    required this.totalHour,
    required this.targetDiamonds,
    required this.targetHours,
    required this.rank,
  });

  factory TargetRequestModel.fromJson(Map<String, dynamic> json) {
    return TargetRequestModel(
      id: json['id'] ?? 0,
      username: json['username'] ?? '',
      managerId: json['manager_id'] ?? 0,
      managerUsername: json['manager_username'] ?? '',
      totalDiamond: json['total_diamond']?.toString() ?? '0',
      totalHour: json['total_hour']?.toString() ?? '0.00',
      targetDiamonds: json['target_diamonds'] ?? 0,
      targetHours: json['target_hours'] ?? 0,
      rank: json['rank'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'manager_id': managerId,
      'manager_username': managerUsername,
      'total_diamond': totalDiamond,
      'total_hour': totalHour,
      'target_diamonds': targetDiamonds,
      'target_hours': targetHours,
      'rank': rank,
    };
  }

  // Diamond Progress - Target: 95,000,000
  double get diamondProgress {
    const targetDiamonds = 95000000.0;
    return (double.parse(totalDiamond) / targetDiamonds) * 100;
  }

  int get diamondGap {
    const targetDiamonds = 95000000;
    final currentDiamonds = double.tryParse(totalDiamond) ?? 0;
    return (targetDiamonds - currentDiamonds).toInt();
  }

  String get diamondProgressFormatted {
    return '${diamondProgress.toStringAsFixed(1)}%';
  }

  // Hour Progress - Target: 135,000
  double get hourProgress {
    const targetHours = 135000.0;
    final hours = double.tryParse(totalHour) ?? 0;
    return (hours / targetHours) * 100;
  }

  double get hourGap {
    const targetHours = 135000.0;
    final hours = double.tryParse(totalHour) ?? 0;
    return targetHours - hours;
  }

  String get hourProgressFormatted {
    return '${hourProgress.toStringAsFixed(1)}%';
  }

  // Formatted values for UI
  String get totalDiamondFormatted {
    final diamonds = double.tryParse(totalDiamond) ?? 0;
    if (diamonds >= 1000000) {
      return '${(diamonds / 1000000).toStringAsFixed(1)}M';
    } else if (diamonds >= 1000) {
      return '${(diamonds / 1000).toStringAsFixed(1)}K';
    }
    return diamonds.toInt().toString();
  }

  String get totalHourFormatted {
    final hours = double.tryParse(totalHour) ?? 0;
    if (hours >= 1000) {
      return '${(hours / 1000).toStringAsFixed(1)}K';
    }
    return hours.toStringAsFixed(0);
  }

  String get diamondGapFormatted {
    if (diamondGap >= 1000000) {
      return '-${(diamondGap / 1000000).toStringAsFixed(1)}M';
    } else if (diamondGap >= 1000) {
      return '-${(diamondGap / 1000).toStringAsFixed(1)}K';
    }
    return '-$diamondGap';
  }

  String get hourGapFormatted {
    if (hourGap >= 1000) {
      return '-${(hourGap / 1000).toStringAsFixed(1)}K';
    }
    return '-${hourGap.toStringAsFixed(0)}';
  }

  // Check if behind target
  bool get isDiamondBehindTarget => (double.tryParse(totalDiamond) ?? 0) < 95000000;
  bool get isHourBehindTarget => (double.tryParse(totalHour) ?? 0) < 135000;

  // Get progress bar color based on percentage
  String get diamondProgressColor {
    if (diamondProgress >= 90) return 'green';
    if (diamondProgress >= 80) return 'blue';
    return 'red';
  }

  String get hourProgressColor {
    if (hourProgress >= 90) return 'green';
    if (hourProgress >= 80) return 'blue';
    return 'red';
  }
}

// Progress Model
class AgencyProgress {
  final double current;
  final double target;
  final double percentage;

  AgencyProgress({
    required this.current,
    required this.target,
    required this.percentage,
  });

  factory AgencyProgress.fromJson(Map<String, dynamic> json) {
    final current = (json['current'] ?? 0).toDouble();
    final target = (json['target'] ?? 1).toDouble();
    return AgencyProgress(
      current: current,
      target: target,
      percentage: json['percentage'] ?? ((current / target) * 100),
    );
  }

  double get gap => target - current;
  bool get isBehindTarget => current < target;

  String get gapFormatted {
    if (gap >= 1000000) {
      return '-${(gap / 1000000).toStringAsFixed(1)}M';
    } else if (gap >= 1000) {
      return '-${(gap / 1000).toStringAsFixed(1)}K';
    }
    return '-${gap.toInt()}';
  }
}

// Agency Dashboard Response Model
class AgencyDashboard {
  final String month;
  final int totalCreatorsAssigned;
  final AgencyProgress diamondsProgress;
  final AgencyProgress hoursProgress;
  final List<TargetRequestModel> creators;

  AgencyDashboard({
    required this.month,
    required this.totalCreatorsAssigned,
    required this.diamondsProgress,
    required this.hoursProgress,
    required this.creators,
  });

  factory AgencyDashboard.fromJson(Map<String, dynamic> json) {
    return AgencyDashboard(
      month: json['month'] ?? '',
      totalCreatorsAssigned: json['total_creators_assigned'] ?? 0,
      diamondsProgress: AgencyProgress.fromJson(json['diamonds_progress'] ?? {}),
      hoursProgress: AgencyProgress.fromJson(json['hours_progress'] ?? {}),
      creators: (json['creators'] as List?)
          ?.map((creator) => TargetRequestModel.fromJson(creator))
          .toList() ?? [],
    );
  }
}

// Monthly Agency Stats (for the cards shown in screenshot)
class MonthlyAgencyStats {
  final String month;
  final String monthYear; // e.g., "Jan 2026"
  final int creatorsAssigned;
  final double diamondProgress;
  final double hourProgress;
  final TargetRequestModel? managerData;

  MonthlyAgencyStats({
    required this.month,
    required this.monthYear,
    required this.creatorsAssigned,
    required this.diamondProgress,
    required this.hourProgress,
    this.managerData,
  });

  factory MonthlyAgencyStats.fromJson(Map<String, dynamic> json) {
    return MonthlyAgencyStats(
      month: json['month'] ?? '',
      monthYear: json['month_year'] ?? '',
      creatorsAssigned: json['creators_assigned'] ?? 0,
      diamondProgress: (json['diamond_progress'] ?? 0).toDouble(),
      hourProgress: (json['hour_progress'] ?? 0).toDouble(),
      managerData: json['manager_data'] != null
          ? TargetRequestModel.fromJson(json['manager_data'])
          : null,
    );
  }

  String get diamondProgressFormatted => '${diamondProgress.toStringAsFixed(1)}%';
  String get hourProgressFormatted => '${hourProgress.toStringAsFixed(1)}%';

  // Get color based on screenshot logic
  String get progressColor {
    // January 2026: Blue (current month)
    // Jan 2026: Red (same month, different display?)
    // Nov 2025: Green (past month)
    if (month.contains('2026') && month.contains('January')) return 'blue';
    if (month.contains('2026') && month.contains('Jan')) return 'red';
    return 'green';
  }
}