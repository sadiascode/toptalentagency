import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../common/custom_color.dart';

class CustomCoin extends StatelessWidget {
  final String? totalHour;
  final String? totalDiamondAchieve;

  const CustomCoin({
    super.key,
    this.totalHour,
    this.totalDiamondAchieve,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 231,
      width: 385,
      padding: const EdgeInsets.all(1.5),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: AppColors.primaryGradient,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Color(0xff101828),
          borderRadius: BorderRadius.circular(10),
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              'Diamonds & Hours Overview',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),

            // Total Coins Section
            Row(
              children: [
                SvgPicture.asset(
                  'assets/coin.svg',
                  width: 22,
                  height: 22,
                  color: Color(0xffFDC700),
                ),
                const SizedBox(width: 8),
                Text(
                  'Total Diamonds',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                Spacer(),
                Text(
                  totalDiamondAchieve ?? '13.78M',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Coins Progress Bar
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: 8,
                minHeight: 8,
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
              ),
            ),

            const SizedBox(height: 35),

            // Total Hours Section
            Row(
              children: [
                Icon(Icons.access_time, color: Colors.blue, size: 22),
                const SizedBox(width: 8),
                Text(
                  'Total Hours',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                Spacer(),
                Text(
                  totalHour ?? '139.7K',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Hours Progress Bar
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: 8,
                minHeight: 8,
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
            ),
            const SizedBox(height: 8),

          ],
        ),
      ),
    );
  }
}