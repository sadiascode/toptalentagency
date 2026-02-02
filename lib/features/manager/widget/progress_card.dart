import 'package:flutter/material.dart';

Widget ProgressCard({
  required String title,
  required String subtitle,
  required double percent,

}) {
  return
     Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            Text(
              subtitle,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ],
        ),

        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: percent > 1 ? 1 : percent,
          minHeight: 8,
          backgroundColor: Colors.grey.shade200,
          color: const Color(0xff22C55E),
        ),
        const SizedBox(height: 9),
      ],
  );
}