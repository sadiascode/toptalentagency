class PasswordChangeModel {
  final String oldPassword;
  final String newPassword;
  final String confirmPassword;
  final String role;

  PasswordChangeModel({
    required this.oldPassword,
    required this.newPassword,
    required this.confirmPassword,
    required this.role,
  });

  factory PasswordChangeModel.fromJson(Map<String, dynamic> json) {
    return PasswordChangeModel(
      oldPassword: json['old_password'] ?? '',
      newPassword: json['new_password'] ?? '',
      confirmPassword: json['confirm_password'] ?? '',
      role: json['role'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'old_password': oldPassword,
      'new_password': newPassword,
      'confirm_password': confirmPassword,
      'role': role,
    };
  }
}
