class ManagerModel {
  final String username;
  final int myCreators;
  final double hour;
  final int rank;
  final int atRisk;
  final int diamond;
  final int excellent;
  final String? id;
  final String? email;
  final String? profileImage;
  final String? status;
  final String? phone;
  final String? department;

  ManagerModel({
    required this.username,
    required this.myCreators,
    required this.hour,
    required this.diamond,
    required this.rank,
    required this.atRisk,
    required this.excellent,
    this.id,
    this.email,
    this.profileImage,
    this.status,
    this.phone,
    this.department,
  });

  //  create object from JSON
  factory ManagerModel.fromJson(Map<String, dynamic> json) {
    return ManagerModel(
      username: json['username'] ?? json['name'] ?? '',
      myCreators: json['my_creators'] ?? json['creators_count'] ?? 0,
      hour: json['hour'] ?? json['hours'] ?? json['total_hour'] ?? 0,
      diamond: json['diamond'] ?? json['diamonds'] ?? json['total_diamond'] ?? 0,
      rank: json['rank'] ?? 0,
      atRisk: json['at_risk'] ?? json['at_risk_count'] ?? json['risk'] ?? 0,
      excellent: json['excellent'] ?? json['excellent_count'] ?? 0,
      id: json['id']?.toString(),
      email: json['email'],
      profileImage: json['profile_image'] ?? json['image'],
      status: json['status'],
      phone: json['phone'],
      department: json['department'],
    );
  }

  //  ManagerInfo
  factory ManagerModel.fromManagerInfo(Map<String, dynamic> managerInfo) {
    return ManagerModel(
      username: managerInfo['name'] ?? managerInfo['username'] ?? 'Unknown Manager',
      myCreators: managerInfo['my_creators'] ?? managerInfo['creators_count'] ?? managerInfo['score'] ?? 0,
      hour: managerInfo['hour'] ?? managerInfo['hours'] ?? 0,
      diamond: managerInfo['score'] ?? managerInfo['diamond'] ?? managerInfo['total_diamond'] ?? 0,
      rank: managerInfo['rank'] ?? 1,
      atRisk: managerInfo['risk'] ?? managerInfo['at_risk'] ?? managerInfo['at_risk_count'] ?? 0,
      excellent: managerInfo['excellent'] ?? managerInfo['excellent_count'] ?? 0,
      id: managerInfo['id']?.toString(),
      email: managerInfo['email'] ?? 'manager@example.com',
      profileImage: managerInfo['profile_image'] ?? managerInfo['image'],
      status: managerInfo['status'],
      phone: managerInfo['phone'],
      department: managerInfo['department'],
    );
  }

  // Convert object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'profile_image': profileImage,
      'status': status,
      'phone': phone,
      'department': department,
      'my_creators': myCreators,
      'hour': hour,
      'diamond': diamond,
      'rank': rank,
      'at_risk': atRisk,
      'excellent': excellent,
    };
  }

  @override
  String toString() {
    return 'ManagerModel(username: $username, myCreators: $myCreators, rank: $rank, atRisk: $atRisk, excellent: $excellent, email: $email)';
  }
}
