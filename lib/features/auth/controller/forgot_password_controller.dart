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

  var isVerification = false;

  void setIsVerification(bool value) {
    isVerification = value;
  }

  Future<void> sendResetCode(BuildContext context) async {
    final email = emailController.text.trim();

    if (!validateEmail(email)) {
      return;
    }

    isLoading.value = true;

    try {
      final url = isVerification ? Urls.Email_otp : Urls.forgot_password;
      
      final response = await networkClient.postRequest(
        url,
        body: {"email": email},
      );

      isLoading.value = false;

      if (!response.isSuccess) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response.errorMessage ?? "Failed to send code"),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }

      // Success - navigate to OTP verification screen
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Code sent to your email"),
            backgroundColor: Colors.green,
          ),
        );
      }

      // Navigate to VerifyScreen with email
      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => VerifyScreen(
              email: email, 
              isVerification: isVerification,
            ),
          ),
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
    emailController.dispose();
    super.onClose();
  }
}
