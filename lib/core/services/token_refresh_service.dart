import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../app/urls.dart';
import 'token_storage_service.dart';
import '../../../core/roles.dart';
import 'role_storage_service.dart';

class TokenRefreshService {
  static Future<bool> refreshToken() async {
    try {
      print(' === TOKEN REFRESH START ===');
      
      final currentToken = await TokenStorageService.getStoredToken();
      
      if (currentToken == null) {
        print(' No token to refresh');
        return false;
      }

      print('� Current Token Info:');
      print('   - Token Length: ${currentToken.length}');
      print('   - Token Preview: ${currentToken.substring(0, Math.min(20, currentToken.length))}...');
      print('   - URL: ${Urls.token_refresh}');

      final response = await http.post(
        Uri.parse(Urls.token_refresh),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $currentToken',
        },
      );

      print(' API Response:');
      print('   - Status Code: ${response.statusCode}');
      print('   - Response Length: ${response.body.length}');
      print('   - Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        print(' Parsed Response Data: $responseData');
        
        // Extract new token from response
        String? newToken;
        if (responseData.containsKey('access')) {
          newToken = responseData['access'];
          print(' Found token in "access" field');
        } else if (responseData.containsKey('token')) {
          newToken = responseData['token'];
          print(' Found token in "token" field');
        } else if (responseData.containsKey('data') && responseData['data'].containsKey('access')) {
          newToken = responseData['data']['access'];
          print(' Found token in "data.access" field');
        }

        if (newToken != null) {
          print(' Processing New Token:');
          print('   - New Token Length: ${newToken.length}');
          print('   - New Token Preview: ${newToken.substring(0, Math.min(20, newToken.length))}...');
          
          // Store new token
          await TokenStorageService.forceStoreToken(newToken);
          print(' Token sent to storage');
          
          // Verify token was stored
          print(' Verifying Token Storage...');
          final storedToken = await TokenStorageService.getStoredToken();
          if (storedToken == null || storedToken != newToken) {
            print(' Token not stored properly, forcing store...');
            await TokenStorageService.forceStoreToken(newToken);
            
            // Verify again
            final reStoredToken = await TokenStorageService.getStoredToken();
            if (reStoredToken == newToken) {
              print(' Token successfully stored after retry');
            } else {
              print(' Token storage failed even after retry');
              print('   - Expected: ${newToken.substring(0, Math.min(20, newToken.length))}...');
              print('   - Got: ${reStoredToken?.substring(0, Math.min(20, reStoredToken?.length ?? 0))}...');
            }
          } else {
            print(' Token verified in storage');
            print('   - Stored Token Length: ${storedToken.length}');
            print('   - Stored Token Preview: ${storedToken.substring(0, Math.min(20, storedToken.length))}...');
          }
          
          // Extract and manage role from the same response
          await _manageRoleFromResponse(responseData);
          
          print(' === TOKEN REFRESH SUCCESS ===');
          return true;
        } else {
          print(' No new token found in response');
          return false;
        }
      } else {
        print(' Token refresh failed. Status: ${response.statusCode}');
        print(' Response: ${response.body}');
        return false;
      }
    } catch (e) {
      print(' Error refreshing token: $e');
      return false;
    }
  }

  static Future<void> _manageRoleFromResponse(Map<String, dynamic> responseData) async {
    try {
      print(' Managing role from token refresh response...');
      
      // Extract role from response
      String? userRole;
      if (responseData.containsKey('role')) {
        userRole = responseData['role'];
      } else if (responseData.containsKey('data') && responseData['data'].containsKey('role')) {
        userRole = responseData['data']['role'];
      } else if (responseData.containsKey('user') && responseData['user'].containsKey('role')) {
        userRole = responseData['user']['role'];
      } else if (responseData.containsKey('userData') && responseData['userData'].containsKey('role')) {
        userRole = responseData['userData']['role'];
      }

      if (userRole != null) {
        // Map backend role to UI role
        UiUserRole mappedRole = _mapBackendRoleToUiRole(userRole);
        
        // Store role
        await RoleStorageService.saveRole(mappedRole);
        
        // Verify role was stored
        final storedRole = RoleStorageService.getRole();
        if (storedRole != mappedRole) {
          print(' Role not stored properly, forcing store...');
          await RoleStorageService.saveRole(mappedRole);
          
          // Verify again
          final reStoredRole = RoleStorageService.getRole();
          if (reStoredRole == mappedRole) {
            print(' Role successfully stored after retry');
          } else {
            print(' Role storage failed even after retry');
          }
        } else {
          print(' Role verified in storage');
        }
        
        print(' Role managed successfully from token refresh');
        print('   - Backend Role: $userRole');
        print('   - Mapped UI Role: $mappedRole');
      } else {
        print('No role found in token refresh response');
      }
    } catch (e) {
      print(' Error managing role from token refresh: $e');
    }
  }

  static UiUserRole _mapBackendRoleToUiRole(String backendRole) {
    switch (backendRole.toLowerCase()) {
      case 'super_admin':
      case 'admin':
        return UiUserRole.admin;
      case 'manager':
        return UiUserRole.manager;
      case 'creator':
        return UiUserRole.creator;
      default:
        print(' Unknown role: $backendRole, defaulting to admin');
        return UiUserRole.admin;
    }
  }
}
