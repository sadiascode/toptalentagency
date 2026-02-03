import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:top_talent_agency/common/custom_button.dart';
import 'package:top_talent_agency/features/auth/controller/reset_password_controller.dart';
import '../widgets/custom_screen.dart';
import '../widgets/custom_textfield.dart';

class ResetScreen extends StatefulWidget {
  final String? email;
  final String? resetToken;
  final bool isSetPassword;

  const ResetScreen({super.key, this.email, this.resetToken, this.isSetPassword = false});

  @override
  State<ResetScreen> createState() => _ResetScreenState();
}

class _ResetScreenState extends State<ResetScreen> {
  late ResetPasswordController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(ResetPasswordController());
    
    controller.setIsSetPassword(widget.isSetPassword);

    // Set email and reset token from widget if available
    // For Set Password flow, we might not have resetToken, which is fine as we updated controller check
    if (widget.email != null) {
      controller.email = widget.email!;
    }
    if (widget.resetToken != null) {
      controller.resetToken = widget.resetToken!;
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
          SizedBox(height: 20),
          Center(
            child: Text(
              widget.isSetPassword ? "Set Password" : "Set a new password",
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.w600),
            ),
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: Text(
              widget.isSetPassword 
                  ? "Set your account password to secure your account."
                  : "Create a new password. Ensure it differs \n        from previous ones for security",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ),
          SizedBox(height: 35),
          CustomTextfield(
            hintText: "New Password",
            controller: controller.newPasswordController,
            isPassword: true,
          ),

          SizedBox(height: 15),
          CustomTextfield(
            hintText: "Retype New Password",
            controller: controller.confirmPasswordController,
            isPassword: true,
          ),

          SizedBox(height: 30),
          Obx(
            () => CustomButton(
              text: controller.isLoading.value
                  ? (widget.isSetPassword ? "Setting..." : "Resetting...")
                  : (widget.isSetPassword ? "Set Password" : "Reset password"),
              onTap: controller.isLoading.value
                  ? () {}
                  : () => controller.resetPassword(context),
            ),
          ),
        ],
      ),
    );
  }
}
