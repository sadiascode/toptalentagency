import 'package:flutter/material.dart';
import 'package:top_talent_agency/common/custom_button.dart';
import '../../../common/custom_color.dart';
import '../../auth/ui/widgets/custom_textfield.dart';

class CustomAssign extends StatelessWidget {
  const CustomAssign({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 398,
        width: 382,
        padding: const EdgeInsets.all(1.5), //  thickness
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: AppColors.primaryGradient, // gradient
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black, //  inside color
            borderRadius: BorderRadius.circular(15), // 16 - 1
          ),
      child: Padding(
        padding: const EdgeInsets.only(left: 18.0, top: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Manager Name",
              style: TextStyle(
                fontSize: 14,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.only(right: 18.0),
              child: CustomTextfield(hintText: "Enter manager name"),
            ),

            SizedBox(height: 20),
            const Text(
              "Email Address",
              style: TextStyle(
                fontSize: 14,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.only(right: 18.0),
              child: CustomTextfield(hintText: "manager@company.name"),
            ),

            SizedBox(height: 20),
            const Text(
              "Password",
              style: TextStyle(
                fontSize: 14,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.only(right: 18.0),
              child: CustomTextfield(hintText: "Enter initial password",
              isPassword: true),
            ),

            SizedBox(height: 20),
            Padding(
                padding: const EdgeInsets.only(right: 18.0),
                child:  CustomButton(text: "Assign Manager", onTap: (){})
            ),
          ],
        ),
      ),
        ),
    );
  }
}
