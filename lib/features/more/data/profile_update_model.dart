class ProfileUpdateModel {
  final String name;
  final String? profileImage;

  ProfileUpdateModel({
    required this.name,
    this.profileImage,
  });

  factory ProfileUpdateModel.fromJson(Map<String, dynamic> json) {
    return ProfileUpdateModel(
      name: json['name'] ?? '',
      profileImage: json['profile_image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'profile_image': profileImage,
    };
  }
}