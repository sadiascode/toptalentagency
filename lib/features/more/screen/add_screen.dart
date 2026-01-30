import 'package:flutter/material.dart';
import 'package:top_talent_agency/core/roles.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:top_talent_agency/features/more/widget/custom_assign.dart';
import 'package:top_talent_agency/features/more/widget/custom_option.dart';

class AddScreen extends StatelessWidget {
  final UiUserRole role;

  const AddScreen({super.key, required this.role});

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
        title: const Text(
          "Add or delete managers",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row with SVG and Text
            Row(
              children: [
                SvgPicture.asset(
                  'assets/add.svg',
                  height: 16,
                  width: 16,
                  color: Colors.white,
                ),
                const SizedBox(width: 10),
                Text(
                  "Add new manager",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            CustomAssign(),

            SizedBox(height: 20),
            Text("Assigned Managers",style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white
             ),
            ),

            SizedBox(height: 10),
            Column(
             children: [
             CustomOption(
               name: 'Sarah Johnson',
               email: 'sarah@gmail.com',
               password: '••••••••',
               dateTime: '12/13/2025 at 11:40',
               onDelete: () {},
             ),
               SizedBox(height: 10),
               CustomOption(
                 name: 'Sarah Johnson',
                 email: 'sarah@gmail.com',
                 password: '••••••••',
                 dateTime: '12/13/2025 at 11:40',
                 onDelete: () {},
               ),
               SizedBox(height: 10),
               CustomOption(
                 name: 'Sarah Johnson',
                 email: 'sarah@gmail.com',
                 password: '••••••••',
                 dateTime: '12/13/2025 at 11:40',
                 onDelete: () {},
               ),
               SizedBox(height: 10),

          ],
        ),
      ]
    ),
      ),
    );
  }
}
