import 'package:flutter/material.dart';

import '../../../../common/custom_color.dart';

class CustomTargets extends StatelessWidget {
  final String title;
  final Color progressBarColor;
  final Color containerColor;
  final int? diamonds;
  final double? Hours;

  const CustomTargets({
    super.key,
    this.title = 'December 2025',
    this.progressBarColor = const Color(0xff155DFC),
    this.containerColor = const Color(0xFF002370),
    this.diamonds,
    this.Hours,
  });

  @override
  Widget build(BuildContext context) {
    final diamondCurrent = diamonds ?? 0;
    final hourCurrent = Hours ?? 0.0;

    return Container(
      height: 200,
      padding: const EdgeInsets.all(1.5),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: AppColors.primaryGradient,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 17),

            // Diamonds Progress (changed from Coins)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Diamonds Progress',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                Text(
                  _formatNumber(diamondCurrent.toDouble()),
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: 100 / 100,
                minHeight: 12,
                backgroundColor: const Color(0xFFE0E0E0),
                valueColor: AlwaysStoppedAnimation<Color>(progressBarColor),
              ),
            ),
            const SizedBox(height: 25),

            // Hours Progress
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Hours Progress',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
                Text(
                  _formatNumber(hourCurrent),
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: 100 / 100,
                minHeight: 12,
                backgroundColor: const Color(0xFFE0E0E0),
                valueColor: AlwaysStoppedAnimation<Color>(progressBarColor),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatNumber(double number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toInt().toString();
  }
}
