import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../common/custom_color.dart';

class CustomPichart extends StatelessWidget {
  final String? diamondValue;

  const CustomPichart({
    super.key,
    this.diamondValue,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate dynamic values based on diamond data
    final diamondNum = double.tryParse(diamondValue?.replaceAll(',', '') ?? '0') ?? 0;
    final targetDiamonds = 10000.0; // Target value
    final percentage = (diamondNum / targetDiamonds).clamp(0.0, 1.0);
    final achievedValue = percentage * 100;
    final remainingValue = 100 - achievedValue;

    return Container(
      height: 175,
      width: 385,
      padding: const EdgeInsets.all(1.5),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: AppColors.primaryGradient,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Color(0xff101828),
          borderRadius: BorderRadius.circular(8),
        ),

        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [

            SizedBox(
              width: 120,
              height: 120,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    PieChart(
                      PieChartData(
                        sectionsSpace: 0,
                        centerSpaceRadius: 57,
                        startDegreeOffset: -115,
                        sections: [
                          PieChartSectionData(
                            value: achievedValue,
                            color: Color(0xFF9B8DD9),
                            radius: 7.5,
                            showTitle: false,
                          ),
                          PieChartSectionData(
                            value: remainingValue,
                            color: Color(0xFFE0E0E0),
                            radius: 7.5,
                            showTitle: false,
                          ),
                        ],
                      ),
                    ),
                    // Text in the center of the pie chart
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          diamondValue ?? '0',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Right side info
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFF9B8DD9),
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Diamonds',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    SvgPicture.asset(
                      'assets/hand.svg',
                      width: 20,
                      height: 20,
                      colorFilter: ColorFilter.mode(
                        Color(0xFF9B8DD9),
                        BlendMode.srcIn,
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      '${diamondValue ?? '800'} achieved',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
