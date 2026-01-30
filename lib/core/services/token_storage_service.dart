import 'package:get_storage/get_storage.dart';

class TokenStorageService {
  static const String _tokenKey = 'token';
  static const String _accessTokenKey = 'access_token';
  static const String _accessKey = 'access';
  static final GetStorage _storage = GetStorage();

  /// Store token with multiple keys for compatibility
  static Future<void> storeToken(String token) async {
    try {
      await _storage.write(_tokenKey, token);
      await _storage.write(_accessTokenKey, token);
      await _storage.write(_accessKey, token);
      
      print('✅ TokenStorageService: Token stored successfully');
      print('🔑 Token length: ${token.length} characters');
      print('📦 Storage keys: ${_storage.getKeys()}');
      
      // Verify storage
      final storedToken = getStoredToken();
      print('🔍 Verification: ${storedToken != null ? "Token found" : "Token missing"}');
    } catch (e) {
      print('💥 TokenStorageService: Error storing token: $e');
    }
  }

  /// Get stored token (tries multiple keys)
  static String? getStoredToken() {
    try {
      // Try in order of preference
      final possibleKeys = [_accessKey, _tokenKey, _accessTokenKey];
      
      for (String key in possibleKeys) {
        final token = _storage.read(key);
        if (token != null && token.toString().isNotEmpty) {
          print('✅ TokenStorageService: Found token with key: $key');
          return token.toString();
        }
      }
      
      print('❌ TokenStorageService: No token found');
      return null;
    } catch (e) {
      print('💥 TokenStorageService: Error getting token: $e');
      return null;
    }
  }

  /// Clear all stored tokens
  static Future<void> clearTokens() async {
    try {
      await _storage.remove(_tokenKey);
      await _storage.remove(_accessTokenKey);
      await _storage.remove(_accessKey);
      print('🗑️ TokenStorageService: All tokens cleared');
    } catch (e) {
      print('💥 TokenStorageService: Error clearing tokens: $e');
    }
  }

  /// Check if any token is stored
  static bool hasStoredToken() {
    return getStoredToken() != null;
  }

  /// Get all stored token info for debugging
  static Map<String, dynamic> getTokenInfo() {
    final token = getStoredToken();
    return {
      'hasToken': token != null,
      'tokenLength': token?.length ?? 0,
      'storageKeys': _storage.getKeys(),
      'tokenPreview': token != null ? '${token.substring(0, 20)}...' : 'null',
    };
  }

  /// Force store token from login response data
  static Future<void> forceStoreFromLoginResponse(Map<String, dynamic> data) async {
    try {
      print('🔧 TokenStorageService: Force storing from login response');
      
      // Try all possible token locations
      String? token;
      
      if (data['access'] != null) {
        token = data['access'].toString();
        print('🔧 Found token in data["access"]');
      } else if (data['token'] != null) {
        token = data['token'].toString();
        print('🔧 Found token in data["token"]');
      } else if (data['access_token'] != null) {
        token = data['access_token'].toString();
        print('🔧 Found token in data["access_token"]');
      }
      
      if (token != null && token.isNotEmpty) {
        await storeToken(token);
        print('🔧 Force store completed successfully');
      } else {
        print('⚠️ No token found in login response for force store');
      }
    } catch (e) {
      print('💥 TokenStorageService: Error in force store: $e');
    }
  }
}
