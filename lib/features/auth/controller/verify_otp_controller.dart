import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/urls.dart';
import '../../../core/services/network/network_client.dart';
import '../ui/screens/reset_screen.dart';

class VerifyOtpController extends GetxController {
  final TextEditingController otpController = TextEditingController();
  var isLoading = false.obs;
  var isResending = false.obs;
  var otpCode = ''.obs;

  late NetworkClient networkClient;
  late String email;

  void setEmail(String userEmail) {
    email = userEmail;
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

  bool validateOtp(String otp) {
    if (otp.isEmpty) {
      Get.snackbar("Error", "Please enter the OTP code");
      return false;
    }

    if (otp.length != 6) {
      Get.snackbar("Error", "Please enter a valid 6-digit OTP");
      return false;
    }

    // Check if OTP contains only digits
    if (!RegExp(r'^\d{6}$').hasMatch(otp)) {
      Get.snackbar("Error", "OTP must contain only digits");
      return false;
    }

    return true;
  }

  Future<void> verifyOtp(BuildContext context) async {
    final otp = otpController.text.trim();

    if (!validateOtp(otp)) {
      return;
    }

    if (email.isEmpty) {
      Get.snackbar("Error", "Email is required for OTP verification");
      return;
    }

    isLoading.value = true;

    try {
      final response = await networkClient.postRequest(
        Urls.verify_otp,
        body: {
          "email": email,
          "otp": otp,
        },
      );

      isLoading.value = false;

      if (!response.isSuccess) {
        String errorMessage = response.errorMessage ?? "OTP verification failed";
        
        // Handle specific invalid OTP error
        if (errorMessage.toLowerCase().contains('invalid') || 
            errorMessage.toLowerCase().contains('incorrect') ||
            errorMessage.toLowerCase().contains('wrong')) {
          errorMessage = "Invalid OTP. Please check and try again.";
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

      // Success - navigate to Reset Password screen
      Get.snackbar(
        "Success",
        "OTP verified successfully",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      // Extract reset token if available
      String? resetToken;
      if (data['reset_token'] != null) {
        resetToken = data['reset_token'].toString();
      } else if (data['token'] != null) {
        resetToken = data['token'].toString();
      }

      // Navigate to ResetScreen with email and token
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ResetScreen(
            email: email,
            resetToken: resetToken,
          ),
        ),
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

  Future<void> resendOtp() async {
    if (email.isEmpty) {
      Get.snackbar("Error", "Email is required to resend OTP");
      return;
    }

    isResending.value = true;

    try {
      final response = await networkClient.postRequest(
        Urls.resend_otp,
        body: {"email": email},
      );

      isResending.value = false;

      if (!response.isSuccess) {
        Get.snackbar(
          "Error",
          response.errorMessage ?? "Failed to resend OTP",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      Get.snackbar(
        "Success",
        "OTP has been resent to your email",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

    } catch (e) {
      isResending.value = false;
      Get.snackbar(
        "Error",
        "Failed to resend OTP. Please try again.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void onOtpChanged(String value) {
    otpCode.value = value;
  }

  @override
  void onClose() {
    otpController.dispose();
    super.onClose();
  }
}
