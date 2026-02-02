import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../app/urls.dart';
import '../../../core/services/token_storage_service.dart';
import '../data/manager_dashboard_model.dart';

class ManagerApiTestService {
  static Future<void> testManagerApiWithToken() async {
    try {
      print('=== MANAGER API TEST WITH TOKEN START ===');
      
      // Get token from storage
      final token = await TokenStorageService.getStoredToken();
      if (token == null) {
        print('❌ No token found in storage');
        return;
      }
      
      print('✅ Token found: ${token.substring(0, 20)}...');
      print('🔑 Token Length: ${token.length}');
      
      // Make API call with token
      final response = await http.get(
        Uri.parse(Urls.Manager_Dashboard_Score),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      
      print('📤 API Request:');
      print('   - URL: ${Urls.Manager_Dashboard_Score}');
      print('   - Method: GET');
      print('   - Authorization: Bearer {token}');
      
      print('📥 API Response:');
      print('   - Status Code: ${response.statusCode}');
      print('   - Response Length: ${response.body.length}');
      print('   - Response Body: ${response.body}');
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        print('✅ API Success - Parsing response...');
        
        // Try to parse as ManagerDashboardModel
        try {
          final managerDashboard = ManagerDashboardModel.fromJson(responseData);
          print('✅ Successfully parsed ManagerDashboardModel');
          print('   - Total Managers: ${managerDashboard.totalManagers}');
          print('   - Managers List Length: ${managerDashboard.managers.length}');
          
          // Print each manager details
          for (int i = 0; i < managerDashboard.managers.length; i++) {
            final manager = managerDashboard.managers[i];
            print('   - Manager ${i + 1}: ${manager.name} (${manager.email})');
            print('     - Score: ${manager.score}');
            print('     - Risk: ${manager.risk}');
            print('     - Excellent: ${manager.excellent}');
            print('     - Status: ${manager.status}');
          }
          
        } catch (e) {
          print('❌ Failed to parse as ManagerDashboardModel: $e');
          print('🔍 Raw response keys: ${responseData.keys.toList()}');
        }
        
      } else {
        print('❌ API Failed with status: ${response.statusCode}');
        print('   - Error: ${response.body}');
      }
      
    } catch (e) {
      print('💥 API Test Error: $e');
    }
    
    print('=== MANAGER API TEST WITH TOKEN END ===');
  }
  
  // Test different API endpoints
  static Future<void> testMultipleEndpoints() async {
    print('=== TESTING MULTIPLE ENDPOINTS ===');
    
    final token = await TokenStorageService.getStoredToken();
    if (token == null) {
      print('❌ No token found');
      return;
    }
    
    final endpoints = [
      Urls.Manager_Dashboard_Score,
      '${Urls.Manager_Dashboard_Score}?format=json',
      '${Urls.Manager_Dashboard_Score}/',
      'http://172.252.13.97:8025/api/manager/',
      'http://172.252.13.97:8025/api/managers/',
    ];
    
    for (String endpoint in endpoints) {
      print('\n🔄 Testing endpoint: $endpoint');
      try {
        final response = await http.get(
          Uri.parse(endpoint),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ).timeout(Duration(seconds: 10));
        
        print('   - Status: ${response.statusCode}');
        print('   - Length: ${response.body.length}');
        
        if (response.statusCode == 200) {
          print('   - ✅ SUCCESS');
          if (response.body.length < 500) {
            print('   - Body: ${response.body}');
          }
        } else {
          print('   - ❌ FAILED');
          if (response.body.length < 500) {
            print('   - Body: ${response.body}');
          }
        }
        
      } catch (e) {
        print('   - 💥 ERROR: $e');
      }
    }
    
    print('=== MULTIPLE ENDPOINTS TEST END ===');
  }
}
