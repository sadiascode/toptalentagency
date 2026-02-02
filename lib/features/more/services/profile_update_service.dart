import 'dart:convert';
import 'dart:math' as math;
import 'package:http/http.dart' as http;
import '../../../app/urls.dart';
import '../../../core/services/token_validation_service.dart';
import '../data/profile_update_model.dart';

class ProfileUpdateService {
  static Future<bool> updateProfile({
    required String name,
    String? profileImage,
  }) async {
    try {
      print('=== PROFILE UPDATE SERVICE START ===');
      print('Name: $name');
      print('Profile Image: $profileImage');

      final token = await TokenValidationService.getValidToken();
      if (token == null) {
        print('❌ No valid token found');
        return false;
      }

      print('✅ Valid token found: ${token.substring(0, math.min(20, token.length))}...');

      // Create profile update model
      final profileUpdateModel = ProfileUpdateModel(
        name: name,
        profileImage: profileImage,
      );

      final response = await http.put(
        Uri.parse(Urls.Self_Profile_Update),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(profileUpdateModel.toJson()),
      );

      print('📤 API Request:');
      print('   - URL: ${Urls.Self_Profile_Update}');
      print('   - Method: PUT');
      print('   - Headers: Content-Type: application/json, Authorization: Bearer {token}');
      print('   - Body: ${profileUpdateModel.toJson()}');

      print('📥 API Response:');
      print('   - Status Code: ${response.statusCode}');
      print('   - Response Body: ${response.body}');

      if (response.statusCode == 200) {
        print('✅ Profile updated successfully');
        return true;
      } else {
        print('❌ Profile update failed');
        print('   - Status: ${response.statusCode}');
        print('   - Error: ${response.body}');
        return false;
      }
    } catch (e) {
      print('💥 Error: $e');
      return false;
    }
  }
}
