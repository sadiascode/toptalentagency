import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/urls.dart';
import '../../../core/services/network/network_client.dart';
import '../ui/screens/login_screen.dart';

class ResetPasswordController extends GetxController {
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  var isLoading = false.obs;

  late NetworkClient networkClient;
  late String email;
  late String resetToken;

  void setResetData(String userEmail, String userResetToken) {
    email = userEmail;
    resetToken = userResetToken;
  }

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

  bool validatePasswords(String newPassword, String confirmPassword) {
    // Check if passwords are empty
    if (newPassword.isEmpty) {
      Get.snackbar("Error", "New password cannot be empty");
      return false;
    }

    if (confirmPassword.isEmpty) {
      Get.snackbar("Error", "Please confirm your password");
      return false;
    }

    // Check password length (minimum 8 characters)
    if (newPassword.length < 8) {
      Get.snackbar("Error", "Password must be at least 8 characters long");
      return false;
    }

    // Check if passwords match
    if (newPassword != confirmPassword) {
      Get.snackbar("Error", "Passwords do not match");
      return false;
    }

    // Check for basic password strength (optional but recommended)
    if (!RegExp(r'^(?=.*[a-zA-Z])(?=.*\d)').hasMatch(newPassword)) {
      Get.snackbar(
        "Error", 
        "Password must contain at least one letter and one number",
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return false;
    }

    return true;
  }

  Future<void> resetPassword(BuildContext context) async {
    final newPassword = newPasswordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (!validatePasswords(newPassword, confirmPassword)) {
      return;
    }

    // Check if email and token are available
    if (email.isEmpty) {
      Get.snackbar("Error", "Email is required for password reset");
      return;
    }

    if (resetToken.isEmpty) {
      Get.snackbar("Error", "Reset token is required");
      return;
    }

    isLoading.value = true;

    try {
      final response = await networkClient.postRequest(
        Urls.Reset_password,
        body: {
          "email": email,
          "token": resetToken,
          "password": newPassword,
          "password_confirmation": confirmPassword,
        },
      );

      isLoading.value = false;

      if (!response.isSuccess) {
        String errorMessage = response.errorMessage ?? "Password reset failed";
        
        // Handle specific error cases
        if (errorMessage.toLowerCase().contains('token') && 
            (errorMessage.toLowerCase().contains('invalid') || 
             errorMessage.toLowerCase().contains('expired'))) {
          errorMessage = "Reset token is invalid or expired. Please try again.";
        } else if (errorMessage.toLowerCase().contains('password')) {
          errorMessage = "Password reset failed. Please check your requirements.";
        }
        
        Get.snackbar(
          "Error",
          errorMessage,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      final data = response.responseData;
      if (data == null) {
        Get.snackbar(
          "Error",
          "Invalid server response",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      // Success - show success message and navigate to login
      Get.snackbar(
        "Success",
        "Password has been reset successfully",
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );

      // Clear controllers (don't store passwords locally)
      newPasswordController.clear();
      confirmPasswordController.clear();

      // Navigate to Login screen, replacing all previous screens
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );

    } catch (e) {
      isLoading.value = false;
      Get.snackbar(
        "Error",
        "Something went wrong. Please try again.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  void onClose() {
    // Clear controllers to ensure passwords are not stored
    newPasswordController.clear();
    confirmPasswordController.clear();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
