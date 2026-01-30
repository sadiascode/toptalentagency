import 'package:flutter/material.dart';
import 'package:top_talent_agency/core/roles.dart';
import '../widget/custom_targets.dart';

class TargetsScreen extends StatelessWidget {
  final UiUserRole role;
  const TargetsScreen({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.black,
          elevation: 0,
          title: Text(
            role == UiUserRole.creator
                ? "Targets for you"
                : "Total targets for Agency",
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 15),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
             CustomTargets(),

             const SizedBox(height: 20),
             CustomTargets(
               title: 'January 2026',
               progressBarColor: Colors.red,
               containerColor: const Color(0xff3F002B),
             ),

             const SizedBox(height: 20),
             CustomTargets(),

             const SizedBox(height: 20),
             CustomTargets(
               title: 'November 2025',
               progressBarColor: const Color(0xff00A63E),
               containerColor: const Color(0xff003612),
             ),
            ]
          ),
        ),
      ),
    );
  }
}
