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

  bool validateOtp(String otp, BuildContext context) {
    if (otp.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter the OTP code")),
      );
      return false;
    }

    if (otp.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a valid 6-digit OTP")),
      );
      return false;
    }

    // Check if OTP contains only digits
    if (!RegExp(r'^\d{6}$').hasMatch(otp)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("OTP must contain only digits")),
      );
      return false;
    }

    return true;
  }

  var isVerification = false;

  void setIsVerification(bool value) {
    isVerification = value;
  }

  Future<void> verifyOtp(BuildContext context) async {
    final otp = otpController.text.trim();

    if (!validateOtp(otp, context)) {
      return;
    }

    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Email is required for OTP verification")),
      );
      return;
    }

    isLoading.value = true;

    try {
      final url = isVerification ? Urls.Verify_Email : Urls.verify_otp;
      
      final response = await networkClient.postRequest(
        url,
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
        
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMessage),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }

      final data = response.responseData;
      
      // For verify email, data might be just a message or contain details, 
      // but we don't strictly require response data validation like password reset flow
      // unless it's the password reset flow which needs a token
      
      if (!isVerification && data == null) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Invalid server response"),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }

      // Success - navigate to Reset Password screen
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isVerification ? "Email verified successfully" : "OTP verified successfully"),
            backgroundColor: Colors.green,
          ),
        );
      }

      // Extract reset token if available (only for password reset flow)
      String? resetToken;
      if (!isVerification && data != null) {
        if (data['reset_token'] != null) {
          resetToken = data['reset_token'].toString();
        } else if (data['token'] != null) {
          resetToken = data['token'].toString();
        }
      }

      // Navigate to ResetScreen
      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => ResetScreen(
              email: email,
              resetToken: resetToken,
              isSetPassword: isVerification,
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
