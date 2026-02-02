import 'package:get_storage/get_storage.dart';

class TokenStorageService {
  static const String _tokenKey = 'access_token';
  static const String _accessKey = 'access';
  static const String _refreshKey = 'refresh_token';
  static const String _tokenTypeKey = 'token_type';

  // Store token with multiple keys for compatibility
  static Future<void> forceStoreToken(String token) async {
    try {
      print(' === TOKEN STORAGE START ===');
      print('   - Token Length: ${token.length}');
      print('   - Token Preview: ${token.substring(0, Math.min(20, token.length))}...');
      
      final box = GetStorage();
      await box.write(_tokenKey, token);
      print(' Stored with key: $_tokenKey');
      
      await box.write(_accessKey, token);
      print(' Stored with key: $_accessKey');
      
      await box.write('token', token);
      print(' Stored with key: token');
      
      await box.write(_tokenTypeKey, 'Bearer');
      print(' Stored token type: Bearer');
      
      // Verify storage
      print(' Verifying Storage...');
      final verify1 = box.read(_accessKey);
      final verify2 = box.read(_tokenKey);
      final verify3 = box.read('token');
      
      print('   - $_accessKey: ${verify1 != null ? "Present (${verify1.length} chars)" : "Missing"}');
      print('   - $_tokenKey: ${verify2 != null ? "Present (${verify2.length} chars)" : "Missing"}');
      print('   - token: ${verify3 != null ? "Present (${verify3.length} chars)" : "Missing"}');
      
      print(' TokenStorageService: Token stored successfully');
      print(' === TOKEN STORAGE COMPLETE ===');
    } catch (e) {
      print(' TokenStorageService: Error storing token - $e');
    }
  }

  // Get stored token (checks multiple keys)
  static Future<String?> getStoredToken() async {
    try {
      print(' === TOKEN RETRIEVAL START ===');
      final box = GetStorage();
      
      // Check in priority order
      print(' Checking storage keys in priority order...');
      
      String? token = box.read(_accessKey);
      if (token != null && token.isNotEmpty) {
        print(' TokenStorageService: Found token with key: $_accessKey');
        print('   - Token Length: ${token.length}');
        print('   - Token Preview: ${token.substring(0, Math.min(20, token.length))}...');
        print(' === TOKEN RETRIEVAL SUCCESS ===');
        return token;
      }
      print('   - $_accessKey: Empty or missing');
      
      token = box.read(_tokenKey);
      if (token != null && token.isNotEmpty) {
        print(' TokenStorageService: Found token with key: $_tokenKey');
        print('   - Token Length: ${token.length}');
        print('   - Token Preview: ${token.substring(0, Math.min(20, token.length))}...');
        print(' === TOKEN RETRIEVAL SUCCESS ===');
        return token;
      }
      print('   - $_tokenKey: Empty or missing');
      
      token = box.read('token');
      if (token != null && token.isNotEmpty) {
        print(' TokenStorageService: Found token with key: token');
        print('   - Token Length: ${token.length}');
        print('   - Token Preview: ${token.substring(0, Math.min(20, token.length))}...');
        print('🔍 === TOKEN RETRIEVAL SUCCESS ===');
        return token;
      }
      print('   - token: Empty or missing');
      
      print('⚠ TokenStorageService: No token found');
      print(' === TOKEN RETRIEVAL FAILED ===');
      return null;
    } catch (e) {
      print(' TokenStorageService: Error getting token - $e');
      print(' === TOKEN RETRIEVAL ERROR ===');
      return null;
    }
  }

  // Clear all tokens
  static Future<void> clearTokens() async {
    try {
      final box = GetStorage();
      await box.remove(_tokenKey);
      await box.remove(_accessKey);
      await box.remove('token');
      await box.remove(_refreshKey);
      await box.remove(_tokenTypeKey);
      
      print(' TokenStorageService: All tokens cleared');
    } catch (e) {
      print(' TokenStorageService: Error clearing tokens - $e');
    }
  }

  // Check if token exists
  static Future<bool> hasToken() async {
    final token = await getStoredToken();
    return token != null && token.isNotEmpty;
  }

  // Get token info for debugging
  static Future<Map<String, dynamic>> getTokenInfo() async {
    try {
      final box = GetStorage();
      final token = await getStoredToken();
      
      return {
        'hasToken': token != null && token.isNotEmpty,
        'tokenLength': token?.length ?? 0,
        'storageKeys': [
          _tokenKey,
          _accessKey,
          'token',
          _refreshKey,
          _tokenTypeKey
        ],
        'tokenPreview': token != null ? '${token.substring(0, Math.min(20, token.length))}...' : null,
      };
    } catch (e) {
      print(' TokenStorageService: Error getting token info - $e');
      return {
        'hasToken': false,
        'tokenLength': 0,
        'storageKeys': [],
        'tokenPreview': null,
        'error': e.toString(),
      };
    }
  }

  // Verify token integrity
  static Future<bool> verifyToken() async {
    try {
      final token = await getStoredToken();
      if (token == null || token.isEmpty) {
        return false;
      }
      
      // Basic token validation (you can add more sophisticated validation)
      return token.length > 10 && token.contains('.');
    } catch (e) {
      print(' TokenStorageService: Error verifying token - $e');
      return false;
    }
  }
}

// Math utility for min function
class Math {
  static int min(int a, int b) => a < b ? a : b;
}
