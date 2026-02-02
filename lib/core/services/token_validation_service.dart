import 'dart:convert';
import 'dart:math' as math;
import 'package:http/http.dart' as http;
import '../services/token_storage_service.dart';
import '../services/token_refresh_service.dart';
import '../../../app/urls.dart';

class TokenValidationService {
  // Check if token is valid by making a test API call
  static Future<bool> isTokenValid() async {
    try {
      print('=== TOKEN VALIDATION START ===');
      
      final token = await TokenStorageService.getStoredToken();
      if (token == null) {
        print('❌ No token found for validation');
        return false;
      }

      print('✅ Token found, validating...');
      print('   - Token Preview: ${token.substring(0, math.min(20, token.length))}...');

      // Make a test API call to validate token
      final response = await http.get(
        Uri.parse(Urls.Self_Profile),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print('📤 Validation Request:');
      print('   - URL: ${Urls.Self_Profile}');
      print('   - Method: GET');
      print('   - Headers: Authorization: Bearer {token}');

      print('📥 Validation Response:');
      print('   - Status Code: ${response.statusCode}');
      print('   - Response Length: ${response.body.length}');

      if (response.statusCode == 200) {
        print('✅ Token is valid');
        print('=== TOKEN VALIDATION SUCCESS ===');
        return true;
      } else if (response.statusCode == 401) {
        print('❌ Token expired (401)');
        print('   - Response: ${response.body}');
        print('=== TOKEN VALIDATION FAILED - EXPIRED ===');
        return false;
      } else {
        print('❌ Token validation failed with status: ${response.statusCode}');
        print('   - Response: ${response.body}');
        print('=== TOKEN VALIDATION FAILED ===');
        return false;
      }
    } catch (e) {
      print('💥 Token validation error: $e');
      print('=== TOKEN VALIDATION ERROR ===');
      return false;
    }
  }

  // Get valid token (refresh if needed)
  static Future<String?> getValidToken() async {
    try {
      print('=== GET VALID TOKEN START ===');
      
      // First check if current token is valid
      bool isValid = await isTokenValid();
      
      if (isValid) {
        print('✅ Current token is valid, using it');
        final token = await TokenStorageService.getStoredToken();
        print('=== GET VALID TOKEN SUCCESS ===');
        return token;
      } else {
        print('🔄 Token invalid, attempting refresh...');
        bool refreshSuccess = await TokenRefreshService.refreshToken();
        
        if (refreshSuccess) {
          print('✅ Token refreshed successfully');
          final newToken = await TokenStorageService.getStoredToken();
          print('=== GET VALID TOKEN SUCCESS (REFRESHED) ===');
          return newToken;
        } else {
          print('❌ Token refresh failed');
          print('=== GET VALID TOKEN FAILED ===');
          return null;
        }
      }
    } catch (e) {
      print('💥 Get valid token error: $e');
      print('=== GET VALID TOKEN ERROR ===');
      return null;
    }
  }
}
