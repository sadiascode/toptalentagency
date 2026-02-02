import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../app/urls.dart';
import '../../../core/services/token_validation_service.dart';
import '../data/user_profile_model.dart';

class UserProfileService {
  static Future<UserProfileModel?> getUserProfile() async {
    try {
      print('=== USER PROFILE SERVICE START ===');

      final token = await TokenValidationService.getValidToken();
      if (token == null) {
        print('❌ No valid token found');
        return null;
      }

      print('✅ Valid token found: ${token.substring(0, 20)}...');

      final response = await http.get(
        Uri.parse(Urls.Self_Profile),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print('📤 Profile Request:');
      print('   - URL: ${Urls.Self_Profile}');
      print('   - Method: GET');

      print('📥 Profile Response:');
      print('   - Status Code: ${response.statusCode}');
      print('   - Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        print('✅ Profile data received');
        
        // Handle different response formats
        Map<String, dynamic> userData;
        if (responseData.containsKey('user')) {
          userData = responseData['user'];
        } else if (responseData.containsKey('data')) {
          userData = responseData['data'];
        } else {
          userData = responseData;
        }
        
        final userProfile = UserProfileModel.fromJson(userData);
        print('✅ Profile parsed successfully');
        print('   - Name: ${userProfile.name}');
        print('   - Email: ${userProfile.email}');
        print('   - Role: ${userProfile.role}');
        print('   - Profile Image: ${userProfile.profileImage}');
        
        return userProfile;
      } else {
        print('❌ Failed to fetch profile');
        print('   - Status: ${response.statusCode}');
        print('   - Error: ${response.body}');
        return null;
      }
    } catch (e) {
      print('💥 Profile service error: $e');
      return null;
    }
  }
}
