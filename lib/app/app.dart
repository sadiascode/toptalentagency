import 'package:flutter/material.dart';
import '../features/auth/ui/screens/login_screen.dart';

class TopTalentAgency extends StatelessWidget {
  const TopTalentAgency({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      title: "Top Talent Agency",
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}
