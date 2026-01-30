import 'package:flutter/material.dart';
import 'package:top_talent_agency/common/custom_button.dart';
import 'package:top_talent_agency/core/roles.dart';
import 'package:top_talent_agency/features/more/screen/add_screen.dart';
import 'package:top_talent_agency/features/more/screen/edit_screen.dart';
import 'package:top_talent_agency/features/more/widget/custom_more.dart';

import '../../../common/custom_color.dart';
import '../../auth/ui/screens/login_screen.dart';

class MoreScreen extends StatefulWidget {
  final UiUserRole role;
  const MoreScreen({super.key, required this.role});

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  bool get isAdmin => widget.role == UiUserRole.admin;
  bool pushNotification = true;
  bool emailNotification = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            "Settings",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
            Container(
            padding: const EdgeInsets.all(1.5),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: AppColors.primaryGradient,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color:  Colors.black,
                borderRadius: BorderRadius.circular(15),
              ),
                    child: Row(
                      children: [
                        // img
                        Container(
                          width: 56,
                          height: 56,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: ClipOval(
                            child: Image.network(
                              'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=200',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Name and Email
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Admin User',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'admin@company.com',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Color(0xff155DFC),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  'Super Admin',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                    InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: () { Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>  EditScreen(role: widget.role),
                        ),
                      );
                        },
                      child:Container(
                          padding: EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                           ),
                          child: Text('Edit', style:
                          TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                            ),
                          ),
                        ),
                       ),
                      ],
                    ),
                  ),
                ),
                  const SizedBox(height: 24),
                  CustomMore(
                    sectionIcon: Icons.notifications_outlined,
                    sectionTitle: 'Notifications',
                    items: [
                      SettingItemData(
                        title: 'Push Notifications',
                        subtitle: 'Real-time alerts and updates',
                        isSwitch: true,
                        switchValue: pushNotification,
                        onSwitchChanged: (value) {
                          setState(() {
                            pushNotification = value;
                          });
                        },
                      ),
                      SettingItemData(
                        title: 'Email Preferences',
                        subtitle: 'Daily digest and reports',
                        isSwitch: true,
                        switchValue: emailNotification,
                        onSwitchChanged: (value) {
                          setState(() {
                            emailNotification = value;
                          });
                        },
                      ),
                      SettingItemData(
                        title: 'Alert Thresholds',
                        subtitle: 'Configure alert sensitivity',
                        onTap: () {},
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  CustomButton(text: "Sign Out", onTap: (){
                    showDialog(
                      context: context,
                      builder: (context) {
                        return Dialog(
                          backgroundColor: Colors.grey[900],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          insetPadding: const EdgeInsets.symmetric(horizontal: 35), // wider
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Confirm Sign Out",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  "Are you sure you want to sign out?",
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 15,
                                    height: 1.4,
                                  ),
                                ),
                                const SizedBox(height: 24),

                                // Buttons
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text(
                                        "Cancel",
                                        style: TextStyle(color: Colors.blue, fontSize: 16),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) => LoginScreen(),
                                          ),
                                        );
                                      },
                                      child: const Text(
                                        "Sign Out",
                                        style: TextStyle(color: Colors.red, fontSize: 16),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
             SizedBox(height: 10),
              ],
            ),
          ),
       );
  }
}
