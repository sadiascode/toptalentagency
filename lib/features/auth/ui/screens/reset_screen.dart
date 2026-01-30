import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:top_talent_agency/common/custom_button.dart';
import 'package:top_talent_agency/features/auth/controller/reset_password_controller.dart';
import '../widgets/custom_screen.dart';
import '../widgets/custom_textfield.dart';

class ResetScreen extends StatefulWidget {
  final String? email;
  final String? resetToken;

  const ResetScreen({super.key, this.email, this.resetToken});

  @override
  State<ResetScreen> createState() => _ResetScreenState();
}

class _ResetScreenState extends State<ResetScreen> {
  late ResetPasswordController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(ResetPasswordController());

    // Set email and reset token from widget if available
    if (widget.email != null && widget.resetToken != null) {
      controller.setResetData(widget.email!, widget.resetToken!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScreen(
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
                "Set a new password",
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.w600),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: Text(
                "Create a new password. Ensure it differs \n        from previous ones for security",
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
                    ? "Resetting..."
                    : "Reset password",
                onTap: controller.isLoading.value
                    ? () {}
                    : () => controller.resetPassword(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
