import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:top_talent_agency/common/custom_button.dart';
import 'package:top_talent_agency/features/auth/controller/forgot_password_controller.dart';
import '../widgets/custom_screen.dart';
import '../widgets/custom_textfield.dart';

class ForgotScreen extends StatefulWidget {
  final bool isVerification;
  const ForgotScreen({super.key, this.isVerification = false});

  @override
  State<ForgotScreen> createState() => _ForgotScreenState();
}

class _ForgotScreenState extends State<ForgotScreen> {
  final ForgotPasswordController controller = Get.put(
    ForgotPasswordController(),
  );

  @override
  void initState() {
    super.initState();
    controller.setIsVerification(widget.isVerification);
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
              widget.isVerification ? "Verify Email" : "Forgot password?",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ),
          SizedBox(height: 10),

          Padding(
            padding: const EdgeInsets.only(left: 15.0), // adjust as needed
            child: Text(
              widget.isVerification 
                  ? "Enter your email to receive a verification code."
                  : "Enter your email and we will send you a \n                  verification code.",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ),
          SizedBox(height: 30),

          Text(
            "Email",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
          SizedBox(height: 10),
          CustomTextfield(
            hintText: "Enter your email address",
            controller: controller.emailController,
          ),

          SizedBox(height: 30),
          Obx(
            () => CustomButton(
              text: controller.isLoading.value ? "Sending..." : "Send code",
              onTap: controller.isLoading.value
                  ? () {}
                  : () => controller.sendResetCode(context),
            ),
          ),
        ],
      ),
    );
  }
}
