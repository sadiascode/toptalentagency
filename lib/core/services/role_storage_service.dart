import 'package:get_storage/get_storage.dart';
import '../roles.dart';

class RoleStorageService {
  static const String _roleKey = 'user_role';
  static final GetStorage _storage = GetStorage();

  /// Save user role to secure storage
  static Future<void> saveRole(UiUserRole role) async {
    await _storage.write(_roleKey, role.name);
  }

  /// Get user role from secure storage
  static UiUserRole getRole() {
    final roleString = _storage.read(_roleKey);
    if (roleString == null) {
      return UiUserRole.admin; // Default role
    }
    
    try {
      return UiUserRole.values.firstWhere(
        (role) => role.name == roleString,
        orElse: () => UiUserRole.admin,
      );
    } catch (e) {
      return UiUserRole.admin; // Fallback to admin
    }
  }

  /// Clear stored role (for logout)
  static Future<void> clearRole() async {
    await _storage.remove(_roleKey);
  }

  /// Check if role exists in storage
  static bool hasStoredRole() {
    return _storage.hasData(_roleKey);
  }
}
