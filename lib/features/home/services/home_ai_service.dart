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
        msg: 'Unable to load AI insights. Please check your connection.',
      ),
      dailySummary: DailySummary(
        summary: 'No AI summary available at the moment.',
        reason: 'API connection failed or server unavailable.',
        suggestedAction: [
          'Check internet connection',
          'Try refreshing the page',
          'Contact support if issue persists'
        ],
        alertType: 'system_alert',
        alertMessage: 'AI Service Unavailable',
        priority: 'medium',
        status: 'inactive',
        updatedAt: UpdatedAt(
          date: DateTime.now().toString().split(' ')[0],
          time: DateTime.now().toString().split(' ')[1].substring(0, 8),
        ),
      ),
    );
  }
}
