import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:top_talent_agency/common/custom_button.dart';
import 'package:top_talent_agency/core/roles.dart';
import 'package:top_talent_agency/features/more/widget/custom_align.dart';

import '../../auth/ui/widgets/custom_textfield.dart';

class EditScreen extends StatelessWidget {
  final UiUserRole role;

   EditScreen({super.key, required this.role});

  final nameController = TextEditingController(text: "Admin User");
  final emailController = TextEditingController(text: "admin@company.com");
  final passwordController = TextEditingController(text: "password123");

  bool get isAdmin => role == UiUserRole.admin;
  bool get isManager => role == UiUserRole.manager;
  bool get isCreator => role == UiUserRole.creator;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 18),
        ),
        title:   Text(
          role == UiUserRole.admin
              ? 'Edit Admin'
              : role == UiUserRole.manager
              ? 'Edit Manager'
              : 'Edit Creator',
          style: const TextStyle(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.bold
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.40,
                    height: MediaQuery.of(context).size.width * 0.40,
                    decoration: const BoxDecoration(shape: BoxShape.circle),
                    child: ClipOval(
                      child: Center(
                        child: Image.network(
                          'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=200',
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 7),
            GestureDetector(
              onTap: () async {
                final ImagePicker picker = ImagePicker();
                // Pick an image.
                final XFile? image = await picker.pickImage(
                  source: ImageSource.gallery,
                );
              },
              child: Text(
                'Change photo',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            const SizedBox(height: 30),
            CustomAlign(title: "Admin name"),
            const SizedBox(height: 5),
            CustomTextfield(
              controller: nameController,
              textColor: Colors.white, //  only this screen
            ),

            const SizedBox(height: 20),
            CustomAlign(title: "Email ID"),
            const SizedBox(height: 5),
            CustomTextfield(
              controller: emailController,
              textColor: Colors.white,
            ),

            const SizedBox(height: 20),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Current Password',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Text(
                        'Change password',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black87,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                CustomTextfield(hintText: "Enter Your New Password ",isPassword: true, textColor: Colors.white),

              ],
            ),
            SizedBox(height: 16,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'New Password',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Text(
                        'Change password',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black87,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                CustomTextfield(hintText: "Enter Your New Password ",isPassword: true, textColor: Colors.white),

              ],
            ),
            SizedBox(height: 30),
            CustomButton(text: "Save", onTap: () {}),
          ],
        ),
      ),
    );
  }
}