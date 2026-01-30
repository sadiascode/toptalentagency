import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../common/custom_color.dart';

class LiveChart extends StatelessWidget {
  const LiveChart({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Color(0xff101828),
          borderRadius: BorderRadius.circular(15),
        ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Last 30 Days Performance",
            style: TextStyle(color:Colors.white,fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),

          SizedBox(
            height: 170,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: false),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 5,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          "D${value.toInt()}",
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.black54,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                minX: 1,
                maxX: 30,
                minY: 0,
                maxY: 100,
                lineBarsData: [
                  LineChartBarData(
                    spots: const [
                      FlSpot(1, 20),
                      FlSpot(5, 40),
                      FlSpot(10, 35),
                      FlSpot(15, 60),
                      FlSpot(20, 55),
                      FlSpot(25, 80),
                      FlSpot(30, 70),
                    ],
                    isCurved: true,
                    color: Color(0xff7C3AED),
                    barWidth: 3,
                    dotData: FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: Color(0xff7C3AED).withOpacity(0.12),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Center(child: Text("Daily coins earned over the past month", style: TextStyle(color: Colors.white))),
        ],
      ),
      ),
    );
  }
}
