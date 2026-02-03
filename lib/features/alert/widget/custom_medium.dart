import 'package:flutter/material.dart';

class CustomMedium extends StatelessWidget {
  final int high;
  final int low;

  const CustomMedium({
    super.key,
    required this.high ,
    required this.low,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            width: 111,
            height: 56,
            decoration: BoxDecoration(
              color: Color(0xff101828),
              borderRadius: BorderRadius.circular(13),
              border: Border.all(
                color: Color(0xffD4183D),
                width: 1,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '$high',
                  style: TextStyle(fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xffD4183D)),
                ),
                Text(
                  'High',
                  style: TextStyle(fontSize: 12, color: Color(0xffD4183D)),
                ),
              ],
            ),
          ),
          SizedBox(width: 5),
          Container(
            width: 111,
            height: 56,
            decoration: BoxDecoration(
              color: Color(0xff101828),
              borderRadius: BorderRadius.circular(13),
              border: Border.all(
                color: Color(0xffFF9C17),
                width: 1,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '$low',
                  style: TextStyle
                    (fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xffFF9C17),),
                ),
                Text(
                  'Low',
                  style: TextStyle(fontSize: 12, color: Color(0xffFF9C17),),
                ),
              ],
            ),
          ),
        ]
    );
  }
}