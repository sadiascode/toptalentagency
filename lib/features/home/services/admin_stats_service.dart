import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../app/urls.dart';
import '../../../core/services/token_storage_service.dart';
import '../data/home_ai_model.dart';

class AdminStatsService {
  static Future<AdminStats?> fetchAdminStats() async {
    try {
      final token = await TokenStorageService.getStoredToken();
      print('🔍 Admin Stats Service Debug:');
      print('   - URL: ${Urls.Admin}');
      print('   - Token: ${token != null ? "Present (${token.length} chars)" : "Not found"}');

      final response = await http.get(
        Uri.parse(Urls.Admin),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('📊 Admin Stats Status Code: ${response.statusCode}');
      print('📝 Admin Stats Response: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        print('✅ Admin Stats Data: $responseData');

        // Extract admin stats from response
        final adminStats = AdminStats.fromJson(responseData);
        
        print('✅ Admin Stats Parsed:');
        print('   - Total Diamonds: ${adminStats.totalDiamonds}');
        print('   - Total Managers: ${adminStats.totalManagers}');
        print('   - Total Creators: ${adminStats.totalCreators}');
        print('   - Total Scrap: ${adminStats.totalScrap}');
        
        return adminStats;
      } else {
        print('❌ Failed to fetch admin stats. Status: ${response.statusCode}');
        print('❌ Response: ${response.body}');
        return null;
      }
    } catch (e) {
      print('💥 Error fetching admin stats: $e');
      return null;
    }
  }
}
