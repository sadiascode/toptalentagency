import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import '../services/api_service.dart';
import '../../../common/custom_color.dart';

class CustomMinicontainer extends StatefulWidget {
  final String title;
  final String iconPath;
  final int number;
  final Color? borderColor;

  const CustomMinicontainer({
    super.key,
    required this.title,
    required this.iconPath,
    required this.number,
    this.borderColor,
  });

  @override
  State<CustomMinicontainer> createState() => _CustomMinicontainerState();
}

class _CustomMinicontainerState extends State<CustomMinicontainer> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double w = size.width;
    final double h = size.height;

    return GestureDetector(
      onTap: () {
      },
      child: Container(
        padding: const EdgeInsets.all(1.5),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: AppColors.primaryGradient,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Container(
          width: w * 0.45,
          height: h * 0.20,
          decoration: BoxDecoration(
            color: Color(0xff101828),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 10, top: 8, right: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10),
                Row(
                  children: [
                    SvgPicture.asset(
                      widget.iconPath,
                      width: 25,
                      height: 25,
                    ),

                    const SizedBox(width: 10),
                    Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 35),
                Text(
                  NumberFormat('#,###').format(widget.number),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
