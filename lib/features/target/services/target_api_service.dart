import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:get_storage/get_storage.dart';
import '../../../app/urls.dart';
import '../data/target_request_model.dart';

class TargetApiService {
  // Get auth token - check multiple possible keys
  static String? _getAuthToken() {
    try {
      final box = GetStorage();
      
      // Try different possible token keys
      final possibleKeys = ['token', 'access_token', 'jwt_token', 'auth_token', 'bearer_token'];
      
      for (String key in possibleKeys) {
        final token = box.read(key);
        if (token != null && token.toString().isNotEmpty) {
          print('✅ Found token with key: $key');
          return token.toString();
        }
      }
      
      print('❌ No token found in storage');
      return null;
    } catch (e) {
      print('Error getting auth token: $e');
      return null;
    }
  }
  // Fetch month-wise target data for all roles
  static Future<AgencyDashboard?> fetchMonthWiseTargets(String month) async {
    try {
      final response = await http.get(Uri.parse(Urls.monthWiseTargetFilter(month)));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return AgencyDashboard.fromJson(data);
      } else {
        print('Failed to load month-wise targets. Status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching month-wise targets: $e');
      return null;
    }
  }

  // Fetch role-wise target data for a specific month
  static Future<AgencyDashboard?> fetchRoleWiseTargets(String month, String role) async {
    try {
      final url = Urls.roleWiseTargetFilter(month, role);
      final token = _getAuthToken();
      
      print('🔍 API URL: $url');
      print('� User Role: $role');
      print('📅 Month: $month');
      print('�🔑 Auth Token: ${token != null ? "Present (${token.length} chars)" : "Missing"}');
      
      final headers = <String, String>{
        'Content-Type': 'application/json',
      };
      
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
        headers['token'] = token;
      }
      
      print('📤 Headers: $headers');
      
      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );
      
      print('📊 Status Code: ${response.statusCode}');
      print('📝 Response Body: ${response.body}');
      print('📏 Response Length: ${response.body.length}');

      if (response.statusCode == 200) {
        if (response.body.isEmpty) {
          print('⚠️ Response body is empty');
          return null;
        }
        
        final data = json.decode(response.body);
        print('✅ Parsed Data: $data');
        print('📊 Data Type: ${data.runtimeType}');
        
        // Check if response is empty or has expected structure
        if (data == null) {
          print('⚠️ Response is null');
          return null;
        }
        
        if (data is Map && data.isEmpty) {
          print('⚠️ Response is empty map');
          return null;
        }
        
        // Check if it's an empty list
        if (data is List && data.isEmpty) {
          print('⚠️ Response is empty list');
          return null;
        }
        
        // Try to parse the response
        try {
          final result = AgencyDashboard.fromJson(data);
          print('✅ Successfully parsed AgencyDashboard');
          print('   - Month: ${result.month}');
          print('   - Creators: ${result.totalCreatorsAssigned}');
          print('   - Diamonds: ${result.diamondsProgress.current}/${result.diamondsProgress.target}');
          print('   - Hours: ${result.hoursProgress.current}/${result.hoursProgress.target}');
          return result;
        } catch (e) {
          print('💥 Error parsing AgencyDashboard: $e');
          print('🔧 Response structure might be different. Expected keys: month, total_creators_assigned, diamonds_progress, hours_progress');
          
          // Try to create a basic dashboard from whatever data we got
          return _createFallbackDashboard(data);
        }
      } else {
        print('❌ Failed to load role-wise targets. Status code: ${response.statusCode}');
        print('❌ Response: ${response.body}');
        return null;
      }
    } catch (e) {
      print('💥 Error fetching role-wise targets: $e');
      return null;
    }
  }

  // Create fallback dashboard from any response structure
  static AgencyDashboard? _createFallbackDashboard(dynamic data) {
    try {
      if (data is! Map) {
        print('⚠️ Cannot create dashboard from non-map data');
        return null;
      }
      
      final Map<String, dynamic> dataMap = Map<String, dynamic>.from(data);
      
      // Try to extract whatever we can from the response
      final month = dataMap['month'] ?? TargetApiService.getCurrentMonth();
      final totalCreators = dataMap['total_creators_assigned'] ?? 
                           dataMap['creators_count'] ?? 
                           dataMap['count'] ?? 0;
      
      // Try to get progress data
      final diamondsData = dataMap['diamonds_progress'] ?? dataMap['diamonds'] ?? {};
      final hoursData = dataMap['hours_progress'] ?? dataMap['hours'] ?? {};
      
      final diamondsProgress = AgencyProgress(
        current: (diamondsData['current'] ?? diamondsData['total'] ?? 0).toDouble(),
        target: (diamondsData['target'] ?? 1000000).toDouble(),
        percentage: (diamondsData['percentage'] ?? 0).toDouble(),
      );
      
      final hoursProgress = AgencyProgress(
        current: (hoursData['current'] ?? hoursData['total'] ?? 0).toDouble(),
        target: (hoursData['target'] ?? 1000).toDouble(),
        percentage: (hoursData['percentage'] ?? 0).toDouble(),
      );
      
      print('🔧 Created fallback dashboard with extracted data');
      print('   - Month: $month');
      print('   - Creators: $totalCreators');
      print('   - Diamonds: ${diamondsProgress.current}/${diamondsProgress.target}');
      print('   - Hours: ${hoursProgress.current}/${hoursProgress.target}');
      
      return AgencyDashboard(
        month: month.toString(),
        totalCreatorsAssigned: totalCreators,
        diamondsProgress: diamondsProgress,
        hoursProgress: hoursProgress,
        creators: [],
      );
    } catch (e) {
      print('💥 Failed to create fallback dashboard: $e');
      return null;
    }
  }

  // Helper method to get current month in YYYYMM format
  static String getCurrentMonth() {
    final now = DateTime.now();
    return '${now.year}${now.month.toString().padLeft(2, '0')}';
  }

  // Helper method to get month name from YYYYMM format using intl
  static String getMonthName(String monthFormat) {
    if (monthFormat.length != 6) return monthFormat;
    
    try {
      final year = int.parse(monthFormat.substring(0, 4));
      final month = int.parse(monthFormat.substring(4, 6));
      final date = DateTime(year, month);
      
      // Format: "January 2026", "February 2026", etc.
      return DateFormat('MMMM yyyy').format(date);
    } catch (e) {
      return monthFormat; // Fallback to original format if error
    }
  }

  // Get formatted month for different display purposes
  static String getShortMonthName(String monthFormat) {
    if (monthFormat.length != 6) return monthFormat;
    
    try {
      final year = int.parse(monthFormat.substring(0, 4));
      final month = int.parse(monthFormat.substring(4, 6));
      final date = DateTime(year, month);
      
      // Format: "Jan 2026", "Feb 2026", etc.
      return DateFormat('MMM yyyy').format(date);
    } catch (e) {
      return monthFormat;
    }
  }

  // Get month with year for display
  static String getMonthWithYear(String monthFormat) {
    if (monthFormat.length != 6) return monthFormat;
    
    try {
      final year = int.parse(monthFormat.substring(0, 4));
      final month = int.parse(monthFormat.substring(4, 6));
      final date = DateTime(year, month);
      
      // Format: "Jan 2026"
      return DateFormat('MMM yyyy').format(date);
    } catch (e) {
      return monthFormat;
    }
  }
}
