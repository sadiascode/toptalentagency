import 'package:flutter/material.dart';

import '../../../common/custom_color.dart';
import '../../../features/manager/data/analysis_model.dart';

class AiAnalysisCard extends StatelessWidget {
  final AnalysisModel? analysisData;

  const AiAnalysisCard({
    super.key,
    this.analysisData,
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
            ],
          ),
          const SizedBox(height: 10),
          Text(
            analysisData?.summary ?? "AI Analysis data loading...",
            style: TextStyle(
              color: Colors.white,
              fontSize: 13,
              height: 1.4,
            ),
          ),
          if (analysisData?.reason != null) ...[
            const SizedBox(height: 8),
            Text(
              "Reason: ${analysisData!.reason}",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 12,
                height: 1.3,
              ),
            ),
          ]
        ],
      ),
        ),
    );
  }
}
