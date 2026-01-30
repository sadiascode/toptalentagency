import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  const CustomText({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recent Activity',
          style: TextStyle(
            fontSize: 13,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 7),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Assigned creator to target',
                  style: TextStyle(fontSize: 12,color: Colors.white,),
                ),
                SizedBox(height: 2),
                Text(
                  '03/12/2025',
                  style: TextStyle(fontSize: 12, color:  Color(0xffC5C5C5)),
                ),
              ],
            ),
          ],
        ),

        const SizedBox(height: 5),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Target updated successfully',
                  style: TextStyle(fontSize: 12,color: Colors.white,),
                ),
                SizedBox(height: 2),
                Text(
                  '04/12/2025',
                  style: TextStyle(fontSize: 12, color:  Color(0xffC5C5C5)),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
