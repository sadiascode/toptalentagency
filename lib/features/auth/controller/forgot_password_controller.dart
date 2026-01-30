import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/urls.dart';
import '../../../core/services/network/network_client.dart';
import '../ui/screens/verify_screen.dart';

class ForgotPasswordController extends GetxController {
  final TextEditingController emailController = TextEditingController();
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

  bool validateEmail(String email) {
    if (email.isEmpty) {
      Get.snackbar("Error", "Email cannot be empty");
      return false;
    }

    // Basic email validation regex
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      Get.snackbar("Error", "Please enter a valid email address");
      return false;
    }

    return true;
  }

  Future<void> sendResetCode(BuildContext context) async {
    final email = emailController.text.trim();

    if (!validateEmail(email)) {
      return;
    }

    isLoading.value = true;

    try {
      final response = await networkClient.postRequest(
        Urls.forgot_password,
        body: {"email": email},
      );

      isLoading.value = false;

      if (!response.isSuccess) {
        Get.snackbar(
          "Error",
          response.errorMessage ?? "Failed to send reset code",
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

      // Success - navigate to OTP verification screen
      Get.snackbar(
        "Success",
        "Reset code sent to your email",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      // Navigate to VerifyScreen with email
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => VerifyScreen(email: email)),
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
    emailController.dispose();
    super.onClose();
  }
}
