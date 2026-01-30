import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:top_talent_agency/common/app_shell.dart';
import 'package:top_talent_agency/core/roles.dart';
import 'package:top_talent_agency/core/services/role_storage_service.dart';
import 'package:top_talent_agency/core/services/token_storage_service.dart';
import '../../../app/urls.dart';
import '../../../core/services/network/network_client.dart';

class LoginController extends GetxController {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  var rememberMe = false.obs;
  var isLoading = false.obs;

  late NetworkClient networkClient;

  @override
  void onInit() {
    super.onInit();

    networkClient = NetworkClient(
      onUnAuthorize: () {
        Get.snackbar("Error", "Unauthorized");
      },
      commonHeaders: () => {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
    );
  }

  void toggleRememberMe(bool? value) {
    rememberMe.value = value ?? false;
  }

  Future<void> login(BuildContext context) async {
    final username = usernameController.text.trim();
    final password = passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      Get.snackbar("Error", "Username and password cannot be empty");
      return;
    }

    isLoading.value = true;

    final response = await networkClient.postRequest(
      Urls.login,
      body: {"username": username, "password": password},
    );

    isLoading.value = false;

    if (!response.isSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response.errorMessage ?? "Login failed")),
      );
      return;
    }

    final data = response.responseData;

    if (data == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Invalid server response")));
      return;
    }

    print("===== FULL RESPONSE =====");
    print("Type: ${data.runtimeType}");
    print("Keys: ${data.keys}");
    print("Full Data: $data");

    data.forEach((key, value) {
      print("Key: $key, Value: $value, Type: ${value.runtimeType}");
    });
    print("==========================");

    // Extract and store token
    String? authToken;
    
    // Check for token in various possible locations
    if (data['access'] != null) {
      authToken = data['access'].toString();
      print("Found token in data['access']: $authToken");
    } else if (data['token'] != null) {
      authToken = data['token'].toString();
      print("Found token in data['token']: $authToken");
    } else if (data['access_token'] != null) {
      authToken = data['access_token'].toString();
      print("Found token in data['access_token']: $authToken");
    } else if (data['jwt_token'] != null) {
      authToken = data['jwt_token'].toString();
      print("Found token in data['jwt_token']: $authToken");
    } else if (data['data'] != null && data['data'] is Map) {
      Map dataMap = data['data'] as Map;
      if (dataMap['access'] != null) {
        authToken = dataMap['access'].toString();
        print("Found token in data['data']['access']: $authToken");
      } else if (dataMap['token'] != null) {
        authToken = dataMap['token'].toString();
        print("Found token in data['data']['token']: $authToken");
      } else if (dataMap['access_token'] != null) {
        authToken = dataMap['access_token'].toString();
        print("Found token in data['data']['access_token']: $authToken");
      }
    } else if (data['user'] != null && data['user'] is Map) {
      Map userMap = data['user'] as Map;
      if (userMap['token'] != null) {
        authToken = userMap['token'].toString();
        print("Found token in data['user']['token']: $authToken");
      }
    }

    // Store token using TokenStorageService
    if (authToken != null && authToken.isNotEmpty) {
      await TokenStorageService.storeToken(authToken!);
      
      // Show token info for debugging
      final tokenInfo = TokenStorageService.getTokenInfo();
      print('📊 Token Info: $tokenInfo');
    } else {
      print("⚠️ No token found in normal extraction");
      
      // Force store from login response
      await TokenStorageService.forceStoreFromLoginResponse(data);
      
      // Check if force store worked
      if (TokenStorageService.hasStoredToken()) {
        print("✅ Force store successful!");
        final tokenInfo = TokenStorageService.getTokenInfo();
        print('📊 Token Info after force store: $tokenInfo');
      } else {
        print("❌ Force store failed - no token stored");
      }
    }

    String? roleStr;

    // Enhanced role extraction - check all possible locations
    final List<Map<String, dynamic>> roleLocations = [
      data, // Direct level
      if (data['data'] is Map) data['data'], // Nested in 'data'
      if (data['user'] is Map) data['user'], // Nested in 'user'
      if (data['userData'] is Map) data['userData'], // Nested in 'userData'
      if (data['profile'] is Map) data['profile'], // Nested in 'profile'
      if (data['account'] is Map) data['account'], // Nested in 'account'
    ];

    final List<String> roleKeys = ['role', 'user_role', 'userType', 'user_type', 'permission_level'];

    for (final location in roleLocations) {
      for (final key in roleKeys) {
        if (location[key] != null) {
          roleStr = location[key].toString().trim();
          print("✅ Found role in location['$key']: $roleStr");
          break;
        }
      }
      if (roleStr != null) break;
    }

    // Additional fallback - check if role is in permissions array
    if (roleStr == null && data['permissions'] is List) {
      final permissions = data['permissions'] as List;
      if (permissions.isNotEmpty) {
        roleStr = permissions.first.toString();
        print("✅ Found role in permissions[0]: $roleStr");
      }
    }

    print("🔍 Final extracted role: '$roleStr'");
    print("🔍 Role type: ${roleStr?.runtimeType}");

    // Validate role string
    if (roleStr != null) {
      roleStr = roleStr.toLowerCase().trim();
      final validRoles = ['admin', 'manager', 'creator'];
      
      if (!validRoles.contains(roleStr)) {
        print("⚠️ Invalid role '$roleStr', defaulting to 'admin'");
        roleStr = 'admin';
      } else {
        print("✅ Valid role: '$roleStr'");
      }
    } else {
      print("⚠️ No role found, defaulting to 'admin'");
      roleStr = 'admin';
    }

    // Map backend role to UI role using the new mapping function
    final mappedRole = mapBackendRoleToUiRole(roleStr);
    currentUiUserRole = mappedRole;

    // Save role to secure storage
    await updateCurrentRole(mappedRole);

    print("🎯 Role Management Summary:");
    print("   - Backend Role: '$roleStr'");
    print("   - Mapped UI Role: $mappedRole");
    print("   - Final currentUiUserRole: $currentUiUserRole");
    print("   - Storage Status: ${RoleStorageService.hasStoredRole() ? 'Stored' : 'Not Stored'}");
    print("   - Stored Role: ${RoleStorageService.getRole()}");

    // Verify role was stored correctly
    final storedRole = RoleStorageService.getRole();
    if (storedRole != mappedRole) {
      print("⚠️ Role storage mismatch! Expected: $mappedRole, Got: $storedRole");
      // Try to store again
      await RoleStorageService.saveRole(mappedRole);
      print("🔄 Attempted to re-store role");
    } else {
      print("✅ Role stored successfully");
    }

    // Navigate to AppShell
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => AppShell(role: currentUiUserRole)),
    );
  }

  @override
  void onClose() {
    usernameController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
