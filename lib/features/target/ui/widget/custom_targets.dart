import 'package:flutter/material.dart';

import '../../../../common/custom_color.dart';
import '../../data/target_request_model.dart';


class CustomTargets extends StatelessWidget {
  final String title;
  final Color progressBarColor;
  final Color containerColor;
  final AgencyDashboard? dashboardData;

  const CustomTargets({
    super.key,
    this.title = 'December 2025',
    this.progressBarColor = const Color(0xff155DFC),
    this.containerColor = const Color(0xFF002370),
    this.dashboardData,
  });

  @override
  Widget build(BuildContext context) {
    // Use API data if available, otherwise use mock data
    final totalCreators = dashboardData?.totalCreatorsAssigned ?? 1247;
    final diamondsProgress = dashboardData?.diamondsProgress;
    final hoursProgress = dashboardData?.hoursProgress;
    
    final diamondPercentage = diamondsProgress?.percentage ?? 87.1;
    final diamondCurrent = diamondsProgress?.current ?? 82750000;
    final diamondTarget = diamondsProgress?.target ?? 95000000;
    
    final hourPercentage = hoursProgress?.percentage ?? 88.7;
    final hourCurrent = hoursProgress?.current ?? 119800;
    final hourTarget = hoursProgress?.target ?? 135000;

    return Container(
        height: 240,
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
          const SizedBox(height: 2),
          Text(
            '$totalCreators creators assigned',
            style: const TextStyle(
              fontSize: 12,
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
                '${diamondPercentage.toStringAsFixed(1)}%',
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
              value: diamondPercentage / 100,
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
                '${hourPercentage.toStringAsFixed(1)}%',
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
              value: hourPercentage / 100,
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

  // Helper method to format numbers with K, M suffixes
  String _formatNumber(double number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toInt().toString();
  }
}

// Example usage:
// CustomTargets() // Default colors
//
// CustomTargets(
//   year: 'January 2026',
//   progressBarColor: Colors.green,
//   containerColor: Color(0xFFE8F5E9),
//   containerBorderColor: Color(0xFFA5D6A7),
// )