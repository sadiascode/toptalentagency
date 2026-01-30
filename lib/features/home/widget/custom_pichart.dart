import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../common/custom_color.dart';

class CustomPichart extends StatelessWidget {
  const CustomPichart({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
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
          color: Color(0xff101828), // inside color
          borderRadius: BorderRadius.circular(8),
        ),

    child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // Pie Chart
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
                          value: 43,
                          color: Color(0xFF9B8DD9),  // Color for the first section
                          radius: 7.5,
                          showTitle: false,
                        ),
                        PieChartSectionData(
                          value: 30,
                          color: Color(0xFFE0E0E0),  // Color for the second section
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
                        '557,749',
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
                      color: Color(0xFF9B8DD9),  // Color matching the pie chart section
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
                    'assets/hand.svg',  // Make sure the path to the icon is correct
                    width: 20,
                    height: 20,
                    colorFilter: ColorFilter.mode(
                      Color(0xFF9B8DD9),  // Matching color for the icon
                      BlendMode.srcIn,
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    '\$800 achieved',
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
