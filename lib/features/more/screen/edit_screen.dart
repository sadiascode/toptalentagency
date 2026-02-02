import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:top_talent_agency/common/custom_button.dart';
import 'package:top_talent_agency/core/roles.dart';
import 'package:top_talent_agency/features/more/widget/custom_align.dart';
import 'package:top_talent_agency/features/more/services/password_change_service.dart';
import 'package:top_talent_agency/features/more/services/profile_update_service.dart';

import '../../auth/ui/widgets/custom_textfield.dart';

class EditScreen extends StatelessWidget {
  final UiUserRole role;

   EditScreen({super.key, required this.role});

  final nameController = TextEditingController();
  final emailController = TextEditingController(text: "admin@company.com");
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool get isAdmin => role == UiUserRole.admin;
  bool get isManager => role == UiUserRole.manager;
  bool get isCreator => role == UiUserRole.creator;

  // Password change method
  Future<void> changePassword(BuildContext context) async {
    if (oldPasswordController.text.isEmpty ||
        newPasswordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.black,
          content: Text(
            'Please fill all password fields',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );

      return;
    }

    if (newPasswordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.black,
          content: Text(
            'New password and confirm password do not match',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );
      return;
    }

    final success = await PasswordChangeService.changePassword(
      oldPassword: oldPasswordController.text,
      newPassword: newPasswordController.text,
      confirmPassword: confirmPasswordController.text,
      role: role,
    );

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.black,
          content: Text(
            'Password changed successfully',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );
      // Clear password fields
      oldPasswordController.clear();
      newPasswordController.clear();
      confirmPasswordController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.black,
          content: Text(
            'Password change failed',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );
    }
  }

  // Profile update method
  Future<void> updateProfile(BuildContext context) async {
    print('=== PROFILE UPDATE METHOD START ===');
    print('Name Controller Text: "${nameController.text}"');
    print('Name Length: ${nameController.text.length}');
    
    if (nameController.text.isEmpty) {
      print('❌ Validation Failed: Name is empty');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.black,
          content: Text(
            'Please enter your name',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );
      return;
    }

    print('✅ Validation Passed: Calling ProfileUpdateService');
    final success = await ProfileUpdateService.updateProfile(
      name: nameController.text,
      profileImage: null, // Can add image picker later
    );

    print('ProfileUpdateService Result: $success');
    if (success) {
      print('✅ Profile Update Success - Showing success message');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.black,
          content: Text(
            'Profile updated successfully',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );
    } else {
      print('❌ Profile Update Failed - Showing error message');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.black,
          content: Text(
            'Profile update failed',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );
    }
    print('=== PROFILE UPDATE METHOD END ===');
  }

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
            CustomAlign(title: "Name"),
            const SizedBox(height: 5),
            CustomTextfield(
              controller: nameController,
              textColor: Colors.white,
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
                      'Old Password',
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
                CustomTextfield(
                  controller: oldPasswordController,
                  hintText: "Enter Your Old Password", 
                  isPassword: true, 
                  textColor: Colors.white
                ),

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
                CustomTextfield(
                  controller: newPasswordController,
                  hintText: "Enter Your New Password", 
                  isPassword: true, 
                  textColor: Colors.white
                ),
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
                  'Confirm Password',
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
            CustomTextfield(
              controller: confirmPasswordController,
              hintText: "Confirm Your New Password", 
              isPassword: true, 
              textColor: Colors.white
            ),
            ]
        ),
            SizedBox(height: 30),
            CustomButton(
              text: "Save Changes", 
              onTap: () async {
                print('=== SAVE BUTTON CLICKED ===');
                
                // Check if any password fields are filled
                bool hasPasswordData = oldPasswordController.text.isNotEmpty ||
                                     newPasswordController.text.isNotEmpty ||
                                     confirmPasswordController.text.isNotEmpty;
                
                bool hasProfileData = nameController.text.isNotEmpty;
                
                print('Save Button Analysis:');
                print('   - Has Password Data: $hasPasswordData');
                print('   - Has Profile Data: $hasProfileData');
                print('   - Name Text: "${nameController.text}"');
                print('   - Old Password Length: ${oldPasswordController.text.length}');
                print('   - New Password Length: ${newPasswordController.text.length}');
                print('   - Confirm Password Length: ${confirmPasswordController.text.length}');
                
                if (hasPasswordData && hasProfileData) {
                  print('🔄 Scenario: Both profile and password changes detected');
                  // Update both profile and password
                  await updateProfile(context);
                  await changePassword(context);
                } else if (hasPasswordData) {
                  print('🔄 Scenario: Only password change detected');
                  // Only change password
                  await changePassword(context);
                } else if (hasProfileData) {
                  print('🔄 Scenario: Only profile change detected');
                  // Only update profile
                  await updateProfile(context);
                } else {
                  print('🔄 Scenario: No changes detected');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.black,
                      content: Text(
                        'No changes to save',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                }
                
                print('=== SAVE BUTTON COMPLETE ===');
              }
            ),
          ],
        ),
      ),
    );
  }
}