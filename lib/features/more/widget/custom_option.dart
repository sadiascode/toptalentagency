import 'package:flutter/material.dart';

import '../../../common/custom_color.dart';

class CustomOption extends StatefulWidget {
  final String name;
  final String email;
  final String password;
  final String dateTime;
  final VoidCallback? onDelete;

  const CustomOption({
    super.key,
    required this.name,
    required this.email,
    required this.password,
    required this.dateTime,
    this.onDelete,
  });

  @override
  State<CustomOption> createState() => _CustomAssignState();
}

class _CustomAssignState extends State<CustomOption> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(1.5), //  gradient thickness
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: AppColors.primaryGradient,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 18.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.person_outline, size: 20, color: Colors.white),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  widget.name,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
              ),
              IconButton(
                onPressed: widget.onDelete,
                icon: Icon(Icons.delete_outline, color: Colors.red, size: 23),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Email
          Row(
            children: [
              Icon(Icons.email_outlined, size: 20, color: Colors.white),
              const SizedBox(width: 8),
              Text(
                widget.email,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          Row(
            children: [
              Icon(Icons.remove_red_eye_outlined, size: 20, color: Colors.white),
              const SizedBox(width: 8),
              Text(
                widget.password,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),


          Row(
            children: [
              Icon(Icons.calendar_today_outlined, size: 18, color: Colors.white),
              const SizedBox(width: 8),
              Text(
                widget.dateTime,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
  }
}
