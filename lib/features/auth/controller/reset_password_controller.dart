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

  bool validatePasswords(String newPassword, String confirmPassword, BuildContext context) {
    // Check if passwords are empty
    if (newPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("New password cannot be empty")),
      );
      return false;
    }

    if (confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please confirm your password")),
      );
      return false;
    }

    // Check password length (minimum 8 characters)
    if (newPassword.length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password must be at least 8 characters long")),
      );
      return false;
    }

    // Check if passwords match
    if (newPassword != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Passwords do not match")),
      );
      return false;
    }

    // Check for basic password strength (optional but recommended)
    if (!RegExp(r'^(?=.*[a-zA-Z])(?=.*\d)').hasMatch(newPassword)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password must contain at least one letter and one number")),
      );
      return false;
    }

    return true;
  }

  var isSetPassword = false;

  void setIsSetPassword(bool value) {
    isSetPassword = value;
  }

  Future<void> resetPassword(BuildContext context) async {
    final newPassword = newPasswordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (!validatePasswords(newPassword, confirmPassword, context)) {
      return;
    }

    // Check if email is available
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Email is required")),
      );
      return;
    }

    isLoading.value = true;

    try {
      // Use the Reset Password API as requested
      // Endpoint: auth/reset-password/
      // Body: email, new_password, confirm_password
      final response = await networkClient.postRequest(
        Urls.Reset_password,
        body: {
          "email": email,
          "new_password": newPassword,
          "confirm_password": confirmPassword,
        },
      );

      isLoading.value = false;

      if (!response.isSuccess) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response.errorMessage ?? "Failed to reset password"),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }

      final data = response.responseData;
      
      // Success
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Password reset successfully"),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );
      }

      // Clear controllers
      newPasswordController.clear();
      confirmPasswordController.clear();

      // Navigate to LoginScreen
      if (context.mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
          (route) => false,
        );
      }

    } catch (e) {
      isLoading.value = false;
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Something went wrong. Please try again."),
            backgroundColor: Colors.red,
          ),
        );
      }
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
