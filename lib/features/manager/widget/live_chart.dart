import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../common/custom_color.dart';

class LiveChart extends StatelessWidget {
  final Map<String, double>? monthlyData;

  const LiveChart({
    super.key,
    this.monthlyData,
  });

  @override
  Widget build(BuildContext context) {
    // Use API data or fallback data
    final data = monthlyData ?? {
      'December': 3529.0,
      'January': 0.0,
      'February': 0.0,
    };

    final maxValue = data.values.fold(0.0, (max, value) => value > max ? value : max);
    
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
            "Last 3 Months Performance",
            style: TextStyle(color:Colors.white,fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),

          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: maxValue > 0 ? maxValue * 1.2 : 100,
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipColor: (_) => Colors.white,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      final month = data.keys.elementAt(group.x.toInt());
                      final value = data.values.elementAt(group.x.toInt());
                      return BarTooltipItem(
                        '$month\n${value.toInt()} diamonds',
                        const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() >= 0 && value.toInt() < data.keys.length) {
                          final month = data.keys.elementAt(value.toInt());
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              month.length > 3 ? month.substring(0, 3) : month,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 10,
                          ),
                        );
                      },
                    ),
                  ),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                barGroups: data.entries.map((entry) {
                  final index = data.keys.toList().indexOf(entry.key);
                  return BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: entry.value,
                        color: _getMonthColor(entry.key),
                        width: 22,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(6),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
          Center(
            child: Text(
              "Monthly Diamonds earned",
              style: TextStyle(color: Colors.white.withOpacity(0.8)),
            ),
          ),
        ],
      ),
      ),
    );
  }

  Color _getMonthColor(String month) {
    switch (month) {
      case 'December':
        return const Color(0xFF9B8DD9);
      case 'January':
        return const Color(0xFF7C3AED);
      case 'February':
        return const Color(0xFF5B21B6);
      default:
        return const Color(0xFF9B8DD9);
    }
  }
}
