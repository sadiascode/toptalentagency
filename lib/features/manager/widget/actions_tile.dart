import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

Widget ActionTile({
  required String title,
  required String iconPath,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      height: 40,
      width: 375,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Color(0xff101828),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SvgPicture.asset(
            iconPath,
            width: 17,
            height: 17,
            color: Colors.white,
            fit: BoxFit.cover,
          ),
          SizedBox(width: 15),
          Text(
            title,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white),
          ),
          Spacer(),
          Icon(
            Icons.chevron_right,
            color: Colors.white,
            size: 18,
          ),
        ],
      ),
    ),
  );
}
