import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:top_talent_agency/common/custom_button.dart';
import '../../controller/login_controller.dart';
import '../widgets/custom_screen.dart';
import '../widgets/custom_textfield.dart';
import 'forgot_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final LoginController controller = Get.put(LoginController());

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: CustomScreen(
        svgPath: 'assets/Group.svg',
        svgHeight: 180,
        svgWidth: 130,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: const Text(
                "Welcome to Top Talent Agency",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 16),
            const Text("User Name"),
            const SizedBox(height: 6),
            CustomTextfield(
              hintText: "Enter your name",
              controller: controller.usernameController,
            ),
            const SizedBox(height: 12),
            const Text("Password"),
            const SizedBox(height: 6),
            CustomTextfield(
              hintText: "Password",
              isPassword: true,
              controller: controller.passwordController,
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Obx(
                      () => Row(
                    children: [
                      Checkbox(
                        value: controller.rememberMe.value,
                        onChanged: controller.toggleRememberMe,
                      ),
                      const Text("Remember Me", style: TextStyle(fontSize: 14)),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ForgotScreen()),
                    );
                  },
                  child: const Text(
                    "Forgot Password?",
                    style: TextStyle(fontSize: 14, color: Color(0xff333333)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Obx(
                  () => controller.isLoading.value
                  ? const Center(child: CircularProgressIndicator())
                  : CustomButton(
                text: "Sign in",
                onTap: () => controller.login(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
