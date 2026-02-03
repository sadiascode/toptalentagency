import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:top_talent_agency/common/custom_button.dart';
import 'package:top_talent_agency/features/auth/controller/verify_otp_controller.dart';
import '../widgets/custom_screen.dart';

class VerifyScreen extends StatefulWidget {
  final String? email;
  final bool isVerification;

  const VerifyScreen({super.key, this.email, this.isVerification = false});

  @override
  State<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  late VerifyOtpController controller;

  @override
  void dispose() {
    Get.delete<VerifyOtpController>();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    controller = Get.put(VerifyOtpController());
    
    controller.setIsVerification(widget.isVerification);

    // Set email from widget if available
    if (widget.email != null) {
      controller.setEmail(widget.email!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScreen(
      svgPath: 'assets/Group.svg',
      svgHeight: 180,
      svgWidth: 130,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 25),
          Center(
            child: Text(
              "Check your email",
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.w600),
            ),
          ),
          SizedBox(height: 10),

          Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: Text(
              "We have sent a 6 digit code to your email. \nPlease enter it below to verify your identity",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ),
          SizedBox(height: 30),
          PinCodeTextField(
            length: 6,
            obscureText: false,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            keyboardType: TextInputType.number,
            animationType: AnimationType.fade,
            pinTheme: PinTheme(
              shape: PinCodeFieldShape.box,
              borderRadius: BorderRadius.circular(8),
              fieldHeight: 50,
              fieldWidth: 40,
              activeColor: Colors.green,
              selectedColor: Colors.black,
              inactiveColor: Colors.grey,
            ),
            animationDuration: const Duration(milliseconds: 300),
            controller: controller.otpController,
            appContext: context,
            onChanged: controller.onOtpChanged,
          ),
          SizedBox(height: 20),
          Align(
            alignment: Alignment.centerRight,
            child: Obx(
              () => GestureDetector(
                onTap: controller.isResending.value
                    ? null
                    : controller.resendOtp,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      controller.isResending.value
                          ? "Resending..."
                          : "Resend OTP",
                      style: TextStyle(
                        fontSize: 15,
                        color: controller.isResending.value
                            ? Colors.grey
                            : Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 2),
                    Container(width: 83, height: 1, color: Colors.black),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 40),
          Obx(
            () => CustomButton(
              text: controller.isLoading.value
                  ? "Verifying..."
                  : "Verify code",
              onTap: controller.isLoading.value
                  ? () {}
                  : () => controller.verifyOtp(context),
            ),
          ),
        ],
      ),
    );
  }
}
