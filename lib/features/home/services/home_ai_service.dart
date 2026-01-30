import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../app/urls.dart';
import '../../../core/services/token_storage_service.dart';
import '../data/home_ai_model.dart';

class HomeAiService {
  // Get auth token using TokenStorageService
  static String? _getAuthToken() {
    return TokenStorageService.getStoredToken();
  }

  // Fetch AI response with alert summary role-wise
  static Future<AdminHomeAiModel?> fetchAiResponse(String role) async {
    try {
      final url = Urls.AI_Response_admin_manager_creator;
      final token = _getAuthToken();
      
      print('🤖 Home AI Service Debug:');
      print('   - URL: $url');
      print('   - Role: $role');
      print('   - Token: ${token != null ? "Present (${token.length} chars)" : "Missing"}');

      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

      // Add authentication headers if token is available
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
        headers['token'] = token;
        headers['x-auth-token'] = token;
        print('� Added auth headers');
      }

      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );

      print('📊 Status Code: ${response.statusCode}');
      print('📝 Response Body: ${response.body}');
      print('📏 Response Length: ${response.body.length}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        print('✅ Parsed Data: $responseData');
        print('📊 Data Type: ${responseData.runtimeType}');

        final aiModel = AdminHomeAiModel.fromJson(responseData);
        
        print('✅ Successfully parsed AdminHomeAiModel');
        print('   - Welcome Msg Type: ${aiModel.welcomeMsg.msgType}');
        print('   - Welcome Msg: ${aiModel.welcomeMsg.msg}');
        print('   - Alert Type: ${aiModel.dailySummary.alertType}');
        print('   - Alert Message: ${aiModel.dailySummary.alertMessage}');
        print('   - Priority: ${aiModel.dailySummary.priority}');
        print('   - Summary: ${aiModel.dailySummary.summary}');
        print('   - Total Diamonds: ${aiModel.adminStats.totalDiamonds}');
        print('   - Total Managers: ${aiModel.adminStats.totalManagers}');
        print('   - Total Creators: ${aiModel.adminStats.totalCreators}');
        print('   - Total Scrap: ${aiModel.adminStats.totalScrap}');
        
        return aiModel;
      } else {
        print('❌ Failed to load AI data. Status code: ${response.statusCode}');
        print('❌ Response: ${response.body}');
        return null;
      }
    } catch (e) {
      print('💥 Error fetching AI data: $e');
      return null;
    }
  }

  // Create fallback AI model for when API fails
  static AdminHomeAiModel createFallbackModel(String role) {
    print('🔄 Creating fallback AI model for role: $role');
    
    return AdminHomeAiModel(
      welcomeMsg: WelcomeMessage(
        msgType: 'fallback',
        msg: 'Unable to fetch AI data. Please check your connection.',
      ),
      dailySummary: DailySummary(
        summary: 'No summary available at the moment.',
        reason: 'Connection issue or server unavailable',
        suggestedAction: ['Please try again later', 'Check internet connection'],
        alertType: null,
        alertMessage: null,
        priority: null,
        status: 'inactive',
        updatedAt: UpdatedAt(
          date: DateTime.now().toString().substring(0, 10),
          time: DateTime.now().toString().substring(11, 19),
        ),
      ),
      adminStats: AdminStats(
        totalDiamonds: 0,
        totalManagers: 0,
        totalCreators: 0,
        totalScrap: 0,
      ),
    );
  }
}
