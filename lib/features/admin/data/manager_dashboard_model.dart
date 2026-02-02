class ManagerDashboardModel {
  final int totalManagers;
  final List<ManagerInfo> managers;

  ManagerDashboardModel({
    required this.totalManagers,
    required this.managers,
  });

  factory ManagerDashboardModel.fromJson(Map<String, dynamic> json) {
    // Handle different response formats
    List<dynamic> managersList = [];
    int totalManagers = 0;
    
    if (json.containsKey('managers')) {
      managersList = json['managers'] ?? [];
      totalManagers = json['total_managers'] ?? json['count'] ?? json['total'] ?? managersList.length;
    } else if (json['data'] is List) {
      // API returns a list directly
      managersList = json['data'] ?? [];
      totalManagers = managersList.length;
    } else {
      managersList = json['data'] ?? [];
      totalManagers = json['total_managers'] ?? json['count'] ?? json['total'] ?? managersList.length;
    }
    
    return ManagerDashboardModel(
      totalManagers: totalManagers,
      managers: managersList.map((item) => ManagerInfo.fromJson(item)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_managers': totalManagers,
      'managers': managers.map((manager) => manager.toJson()).toList(),
    };
  }
}

class ManagerInfo {
  final String id;
  final String name;
  final String email;
  final String? profileImage;
  final int? score;
  final int? myCreators;  // Add myCreators field
  final String? status;
  final String? phone;
  final String? department;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool? isActive;
  final int? risk;
  final int? excellent;
  final double? totalHour;

  ManagerInfo({
    required this.id,
    required this.name,
    required this.email,
    this.profileImage,
    this.score,
    this.myCreators,  // Add to constructor
    this.status,
    this.phone,
    this.department,
    this.createdAt,
    this.updatedAt,
    this.isActive,
    this.risk,
    this.excellent,
    this.totalHour,
  });

  factory ManagerInfo.fromJson(Map<String, dynamic> json) {
    return ManagerInfo(
      id: json['id']?.toString() ?? '',
      name: json['username'] ?? json['name'] ?? json['first_name'] ?? '',
      email: json['email'] ?? '',
      profileImage: json['profile_image'] ?? json['image'] ?? json['avatar'],
      score: json['total_diamond'] ?? json['score'] ?? json['total_score'] ?? json['diamonds'] ?? json['points'] ?? 0,
      myCreators: json['my_creators'] ?? json['creators_count'] ?? json['score'] ?? 0,  // Parse my_creators field
      status: json['status'] ?? json['role'] ?? json['user_type'],
      phone: json['phone'] ?? json['contact'] ?? json['mobile'],
      department: json['department'] ?? json['team'] ?? json['division'],
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.tryParse(json['updated_at']) : null,
      isActive: json['is_active'] ?? json['active'] ?? json['status'] == 'active',
      risk: json['at_risk'] ?? json['risk'] ?? json['at_risk_count'] ?? 0,
      excellent: json['excellent'] ?? json['excellent_count'] ?? 0,
      totalHour: json['total_hour'] != null ? double.tryParse(json['total_hour'].toString()) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'profile_image': profileImage,
      'score': score,
      'status': status,
      'phone': phone,
      'department': department,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'is_active': isActive,
      'risk': risk,
      'excellent': excellent,
    };
  }

  // Helper method for display
  String get displayName => name.isNotEmpty ? name : email.split('@')[0];
  String get displayStatus => isActive == true ? 'Active' : (status ?? 'Unknown');
  String get displayScore => score?.toString() ?? '0';
  String get displayRisk => risk?.toString() ?? '0';
  String get displayExcellent => excellent?.toString() ?? '0';
  
  // Getters for ManagerModel compatibility
  int get myCreatorsValue => myCreators ?? score ?? 0;
  int get atRisk => risk ?? 0;
  int get excellentValue => excellent ?? 0;
}
