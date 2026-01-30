// admin_home_ai_model.dart

class AdminHomeAiModel {
  final WelcomeMessage welcomeMsg;
  final DailySummary dailySummary;
  final AdminStats adminStats;

  AdminHomeAiModel({
    required this.welcomeMsg,
    required this.dailySummary,
    required this.adminStats,
  });

  factory AdminHomeAiModel.fromJson(Map<String, dynamic> json) {
    return AdminHomeAiModel(
      welcomeMsg: WelcomeMessage.fromJson(json['welcome_msg'] ?? {}),
      dailySummary: DailySummary.fromJson(json['daily_summary'] ?? {}),
      adminStats: AdminStats.fromJson(json['admin_stats'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'welcome_msg': welcomeMsg.toJson(),
      'daily_summary': dailySummary.toJson(),
      'admin_stats': adminStats.toJson(),
    };
  }
}

// Welcome Message Model
class WelcomeMessage {
  final String msgType;
  final String msg;

  WelcomeMessage({
    required this.msgType,
    required this.msg,
  });

  factory WelcomeMessage.fromJson(Map<String, dynamic> json) {
    return WelcomeMessage(
      msgType: json['msg_type'] ?? '',
      msg: json['msg'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'msg_type': msgType,
      'msg': msg,
    };
  }

  bool get isMonthStartOverview => msgType == 'month_start_overview';
  bool get isMonthStart => msgType == 'month_start_team_target';
  bool get isWeekStart => msgType == 'week_start';
}

// Updated At Model
class UpdatedAt {
  final String date;
  final String time;

  UpdatedAt({
    required this.date,
    required this.time,
  });

  factory UpdatedAt.fromJson(Map<String, dynamic> json) {
    return UpdatedAt(
      date: json['date'] ?? '',
      time: json['time'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'time': time,
    };
  }

  DateTime? get dateTime {
    try {
      return DateTime.parse('$date $time');
    } catch (e) {
      return null;
    }
  }

  String get formattedDateTime {
    try {
      final dt = DateTime.parse('$date $time');
      return '${dt.day}/${dt.month}/${dt.year} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return '$date $time';
    }
  }

  String get formattedTime {
    return time.length >= 5 ? time.substring(0, 5) : time;
  }

  String get formattedDate {
    try {
      final dt = DateTime.parse(date);
      const months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ];
      return '${dt.day} ${months[dt.month - 1]} ${dt.year}';
    } catch (e) {
      return date;
    }
  }
}

// Daily Summary Model
class DailySummary {
  final String summary;
  final String reason;
  final List<String> suggestedAction;
  final String? alertType;
  final String? alertMessage;
  final String? priority;
  final String status;
  final UpdatedAt updatedAt;

  DailySummary({
    required this.summary,
    required this.reason,
    required this.suggestedAction,
    this.alertType,
    this.alertMessage,
    this.priority,
    required this.status,
    required this.updatedAt,
  });

  factory DailySummary.fromJson(Map<String, dynamic> json) {
    return DailySummary(
      summary: json['summary'] ?? '',
      reason: json['reason'] ?? '',
      suggestedAction: List<String>.from(json['suggested_action'] ?? []),
      alertType: json['alert_type'],
      alertMessage: json['alert_message'],
      priority: json['priority'],
      status: json['status'] ?? '',
      updatedAt: UpdatedAt.fromJson(json['updated_at'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'summary': summary,
      'reason': reason,
      'suggested_action': suggestedAction,
      'alert_type': alertType,
      'alert_message': alertMessage,
      'priority': priority,
      'status': status,
      'updated_at': updatedAt.toJson(),
    };
  }

  // Priority helpers
  bool get hasAlert => alertType != null && alertMessage != null;
  bool get hasPriority => priority != null;

  bool get isHighPriority => priority?.toLowerCase() == 'high';
  bool get isMediumPriority => priority?.toLowerCase() == 'medium';
  bool get isLowPriority => priority?.toLowerCase() == 'low';

  // Status helpers
  bool get isActive => status.toLowerCase() == 'active';
  bool get isInactive => status.toLowerCase() == 'inactive';
  bool get isResolved => status.toLowerCase() == 'resolved';

  // Alert type helpers
  bool get isTeamAlert => alertType == 'team_alert';
  bool get isCreatorAlert => alertType == 'creator_alert';
  bool get isPerformanceAlert => alertType == 'performance_alert';
  bool get isManagerAlert => alertType == 'manager_alert';

  // Priority label for UI
  String get priorityLabel {
    if (priority == null) return 'No Priority';
    switch (priority!.toLowerCase()) {
      case 'high':
        return 'High Priority';
      case 'medium':
        return 'Medium Priority';
      case 'low':
        return 'Low Priority';
      default:
        return 'Priority';
    }
  }

  // Get priority color as hex string
  String get priorityColorHex {
    if (priority == null) return '#666666';
    switch (priority!.toLowerCase()) {
      case 'high':
        return '#8B2252'; // Purple/Magenta
      case 'medium':
        return '#FF9800'; // Orange
      case 'low':
        return '#4CAF50'; // Green
      default:
        return '#666666'; // Grey
    }
  }

  // Extract percentage from summary (e.g., "72% of creators are currently at risk.")
  int? get riskPercentage {
    final match = RegExp(r'(\d+)%').firstMatch(summary);
    if (match != null) {
      return int.tryParse(match.group(1) ?? '');
    }
    return null;
  }

  // Check if it mentions creators
  bool get isAboutCreators => summary.toLowerCase().contains('creator');

  // Check if it mentions managers
  bool get isAboutManagers => reason.toLowerCase().contains('manager');
}

// Admin Stats Model
class AdminStats {
  final int totalDiamonds;
  final int totalManagers;
  final int totalCreators;
  final int totalScrap;

  AdminStats({
    required this.totalDiamonds,
    required this.totalManagers,
    required this.totalCreators,
    required this.totalScrap,
  });

  factory AdminStats.fromJson(Map<String, dynamic> json) {
    return AdminStats(
      totalDiamonds: json['total_diamonds'] ?? 0,
      totalManagers: json['total_managers'] ?? 0,
      totalCreators: json['total_creators'] ?? 0,
      totalScrap: json['total_scrap'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_diamonds': totalDiamonds,
      'total_managers': totalManagers,
      'total_creators': totalCreators,
      'total_scrap': totalScrap,
    };
  }
}