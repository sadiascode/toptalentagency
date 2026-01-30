import 'package:flutter/material.dart';

import '../../../common/custom_color.dart';

class AiAnalysisCard extends StatelessWidget {
  const AiAnalysisCard({
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
            color: Color(0xff1D0014),
            borderRadius: BorderRadius.circular(14),
          ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                "AI Analysis",
                style: TextStyle(color:Colors.white,fontWeight: FontWeight.w600),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xff620041),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  "Updated 2h ago",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            "Manager Sarah Johnson exceeds targets by 20.0%.\n"
                "Creators crossed 100% of both coin and live-hour targets.Maintained high performance.",
            style: TextStyle(
              color: Colors.white,
              fontSize: 13,
              height: 1.4,
            ),
          )
        ],
      ),
        ),
    );
  }
}
