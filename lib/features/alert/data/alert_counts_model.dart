class AlertCountsModel {
  final int high;
  final int low;

  AlertCountsModel({required this.high, required this.low});

  factory AlertCountsModel.fromJson(Map<String, dynamic> json) {
    // Try to get alerts list from different possible structures
    List<dynamic> alertsList = [];
    if (json['alerts'] != null) {
      alertsList = json['alerts'] is List ? json['alerts'] : [];
    } else if (json['data'] != null && json['data']['alerts'] != null) {
      alertsList = json['data']['alerts'] is List ? json['data']['alerts'] : [];
    }

    // Parse high and low priority alerts
    int highCount = 0;
    int lowCount = 0;

    for (final alert in alertsList) {
      if (alert is Map<String, dynamic>) {
        final priority = alert['priority']?.toString().toLowerCase() ?? '';
        final severity = alert['severity']?.toString().toLowerCase() ?? '';

        if (priority == 'high' || priority == 'critical' || severity == 'high') {
          highCount++;
        } else if (priority == 'low' || severity == 'low') {
          lowCount++;
        }
      }
    }

    // Also check for direct high/low fields in API response
    final apiHigh = json['high'] ?? json['high_alerts'] ?? json['highAlerts'] ?? highCount;
    final apiLow = json['low'] ?? json['low_alerts'] ?? json['lowAlerts'] ?? lowCount;

    return AlertCountsModel(
      high: apiHigh is int ? apiHigh : int.tryParse(apiHigh.toString()) ?? 0,
      low: apiLow is int ? apiLow : int.tryParse(apiLow.toString()) ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'high': high,
      'low': low,
    };
  }

  @override
  String toString() => 'AlertCounts(high: $high, low: $low)';
}

class Alert {
  final int? userId;
  final String? username;
  final String? role;
  final String? alertType;
  final String? priority;
  final String? alertMessage;
  final DateTime? updatedAt;

  Alert({
    this.userId,
    this.username,
    this.role,
    this.alertType,
    this.priority,
    this.alertMessage,
    this.updatedAt,
  });

  factory Alert.fromJson(Map<String, dynamic> json) {
    DateTime? parseUpdatedAt(Map<String, dynamic>? map) {
      if (map == null) return null;
      final date = map['date'] ?? '';
      final time = map['time'] ?? '';
      if (date.isEmpty || time.isEmpty) return null;
      return DateTime.tryParse('$date $time');
    }

    return Alert(
      userId: json['user_id'],
      username: json['username'],
      role: json['role'],
      alertType: json['alert_type'],
      priority: json['priority'],
      alertMessage: json['alert_message'],
      updatedAt: parseUpdatedAt(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    String? formatUpdatedAt(DateTime? dt) {
      if (dt == null) return null;
      return '${dt.year.toString().padLeft(4, '0')}-'
          '${dt.month.toString().padLeft(2, '0')}-'
          '${dt.day.toString().padLeft(2, '0')} '
          '${dt.hour.toString().padLeft(2, '0')}:'
          '${dt.minute.toString().padLeft(2, '0')}:'
          '${dt.second.toString().padLeft(2, '0')}';
    }

    return {
      'user_id': userId,
      'username': username,
      'role': role,
      'alert_type': alertType,
      'priority': priority,
      'alert_message': alertMessage,
      'updated_at': updatedAt != null
          ? {
        'date': '${updatedAt!.year.toString().padLeft(4, '0')}-'
            '${updatedAt!.month.toString().padLeft(2, '0')}-'
            '${updatedAt!.day.toString().padLeft(2, '0')}',
        'time': '${updatedAt!.hour.toString().padLeft(2, '0')}:'
            '${updatedAt!.minute.toString().padLeft(2, '0')}:'
            '${updatedAt!.second.toString().padLeft(2, '0')}',
      }
          : null,
    };
  }

  @override
  String toString() {
    return 'Alert(userId: $userId, username: $username, role: $role, priority: $priority, message: $alertMessage, updatedAt: $updatedAt)';
  }
}

class AlertsResponse {
  final AlertCountsModel? alertCounts;
  final List<Alert> alerts;

  AlertsResponse({this.alertCounts, required this.alerts});

  factory AlertsResponse.fromJson(Map<String, dynamic> json) {
    final alertList = (json['alerts'] as List<dynamic>? ?? [])
        .map((e) => Alert.fromJson(e as Map<String, dynamic>))
        .toList();

    return AlertsResponse(
      alertCounts: json['alert_counts'] != null
          ? AlertCountsModel.fromJson(json['alert_counts'])
          : null,
      alerts: alertList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'alert_counts': alertCounts?.toJson(),
      'alerts': alerts.map((e) => e.toJson()).toList(),
    };
  }

  @override
  String toString() => 'AlertsResponse(alertCounts: $alertCounts, alerts: $alerts)';
}
