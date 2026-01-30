// lib/core/roles.dart

import 'package:get_storage/get_storage.dart';
import 'services/role_storage_service.dart';

/// Enum for user roles in the UI
enum UiUserRole { admin, manager, creator }

/// Global variable to hold the current UI role
UiUserRole currentUiUserRole = UiUserRole.admin;

/// Initialize role storage and load stored role
Future<void> initializeRole() async {
  await GetStorage.init();
  currentUiUserRole = RoleStorageService.getRole();
}

/// Update current UI role and save to storage
Future<void> updateCurrentRole(UiUserRole role) async {
  currentUiUserRole = role;
  await RoleStorageService.saveRole(role);
}

/// Clear current role (for logout)
Future<void> clearCurrentRole() async {
  currentUiUserRole = UiUserRole.admin;
  await RoleStorageService.clearRole();
}

/// Map backend role string to UiUserRole enum
UiUserRole mapBackendRoleToUiRole(String? backendRole) {
  if (backendRole == null || backendRole.isEmpty) {
    return UiUserRole.admin; // Default role
  }

  switch (backendRole.toLowerCase().trim()) {
    case "admin":
      return UiUserRole.admin;
    case "manager":
      return UiUserRole.manager;
    case "creator":
      return UiUserRole.creator;
    default:
      return UiUserRole.admin; // Default to admin for unknown roles
  }
}
