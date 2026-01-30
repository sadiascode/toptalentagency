import 'package:flutter/material.dart';
class CustomAlign extends StatelessWidget {
  final title;
  const CustomAlign({
    super.key,
    required this.title
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          color: Colors.white,
        ),
      ),
    );
  }
}
