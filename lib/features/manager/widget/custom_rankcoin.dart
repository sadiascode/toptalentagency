import 'package:flutter/material.dart';

class CustomRankcoin extends StatelessWidget {
  final String rank;
  final String name;
  final String hours;
  final String Diamond;
  final bool isIncreasing;

  const CustomRankcoin({
    super.key,
    required this.rank,
    required this.name,
    required this.hours,
    required this.Diamond,
    this.isIncreasing = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
        children: [
          Container(
            width: 35,
            height: 45,
            decoration: BoxDecoration(
              color: Color(0xffFEF9C2),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                rank,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xffA65F00),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Name
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),

              ],
            ),
          ),
          // Coins
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    Diamond,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    'Diamond',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.trending_up,
                color: Color(0xFF4CAF50),
                size: 24,
              ),
            ],
          ),
        ],
    );
  }
}