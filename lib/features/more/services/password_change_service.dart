import 'dart:convert';
import 'dart:math' as math;
import 'package:http/http.dart' as http;
import '../../../app/urls.dart';
import '../../../core/services/token_validation_service.dart';
import '../../../core/roles.dart';
import '../data/password_change_model.dart';

class PasswordChangeService {
  static Future<bool> changePassword({
    required String oldPassword,
    required String newPassword,
    required String confirmPassword,
    required UiUserRole role,
  }) async {
    try {
      print('=== PASSWORD CHANGE SERVICE START ===');
      print('Role: ${role.name}');
      print('Old Password Length: ${oldPassword.length}');
      print('New Password Length: ${newPassword.length}');
      print('Confirm Password Length: ${confirmPassword.length}');

      final token = await TokenValidationService.getValidToken();
      if (token == null) {
        print('❌ No valid token found');
        return false;
      }

      print('✅ Valid token found: ${token.substring(0, math.min(20, token.length))}...');

      // Create password change model
      final passwordChangeModel = PasswordChangeModel(
        oldPassword: oldPassword,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
        role: role.name,
      );

      final response = await http.post(
        Uri.parse(Urls.Self_Profile_change_password),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(passwordChangeModel.toJson()),
      );

      print('📤 API Request:');
      print('   - URL: ${Urls.Self_Profile_change_password}');
      print('   - Method: POST');
      print('   - Body: ${passwordChangeModel.toJson()}');

      print('📥 API Response:');
      print('   - Status Code: ${response.statusCode}');
      print('   - Response Body: ${response.body}');

      if (response.statusCode == 200) {
        print('✅ Password changed successfully');
        return true;
      } else {
        print('❌ Password change failed');
        return false;
      }
    } catch (e) {
      print('💥 Error: $e');
      return false;
    }
  }
}
