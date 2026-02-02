class UserProfileModel {
  final String name;
  final String email;
  final String? profileImage;
  final String role;

  UserProfileModel({
    required this.name,
    required this.email,
    this.profileImage,
    required this.role,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      name: json['name'] ?? json['username'] ?? json['first_name'] ?? 'User',
      email: json['email'] ?? '',
      profileImage: json['profile_image'] ?? json['image'] ?? json['avatar'],
      role: json['role'] ?? 'user',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'profile_image': profileImage,
      'role': role,
    };
  }
}
