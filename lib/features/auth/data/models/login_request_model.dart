// lib/features/auth/data/models/login_request_model.dart

class LoginRequestModel {
  final String? username;
  final String? password;

  LoginRequestModel({this.username, this.password});

  Map<String, dynamic> toJson() {
    return {
      "username": username,
      "password": password,
    }..removeWhere((key, value) => value == null);
  }

  factory LoginRequestModel.fromJson(Map<String, dynamic> json) {
    return LoginRequestModel(
      username: json['username'],
      password: json['password'],
    );
  }
}
