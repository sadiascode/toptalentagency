import 'package:flutter/material.dart';
import 'package:top_talent_agency/features/home/data/home_ai_model.dart';

import '../../../common/custom_color.dart';

class CustomSummary extends StatelessWidget {
  final AdminHomeAiModel? aiData;
  final bool isLoading;
  final String? errorMessage;

  const CustomSummary({
    super.key,
    this.aiData,
    this.isLoading = false,
    this.errorMessage
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      width: double.infinity,
      constraints: BoxConstraints(
        maxWidth: screenWidth > 600 ? 420 : double.infinity,
        minHeight: screenHeight > 800 ? 250 : 200,
        maxHeight: screenHeight > 800 ? 500 : 400,
      ),
      padding: const EdgeInsets.all(1.5),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: AppColors.primaryGradient,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(
                  Icons.auto_awesome,
                  color: Color(0xffAD46FF),
                  size: screenWidth > 600 ? 25 : 22,
                ),
                const SizedBox(width: 10),
                Flexible(
                  child: Text(
                    'AI Daily Summary for Your Team',
                    style: TextStyle(
                      fontSize: screenWidth > 600 ? 16 : 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),

            // Scrollable content area
            Expanded(
              child: isLoading
                  ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: Colors.white),
                    SizedBox(height: 10),
                    Text(
                      'Loading AI summary...',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              )
                  : errorMessage != null
                  ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, color: Colors.red, size: 40),
                    SizedBox(height: 10),
                    Text(
                      'Error loading AI summary',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              )
                  : aiData != null
                  ? SingleChildScrollView(
                child: _buildAiSummary(aiData!),
              )
                  : SingleChildScrollView(
                child: _buildFallbackSummary(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAiSummary(AdminHomeAiModel aiData) {
    final summary = aiData.dailySummary;

    return Column(
      children: [
        // High Priority Section with AI data
        Container(
          padding: const EdgeInsets.all(16),
          width: double.infinity,
          decoration: BoxDecoration(
            color: summary.priority == 'high'
                ? const Color(0xff1D0014)
                : summary.priority == 'medium'
                ? const Color(0xff1A1400)
                : const Color(0xff00140D),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: summary.priority == 'high'
                      ? Color(0xff620041)
                      : summary.priority == 'medium'
                      ? Color(0xff614E00)
                      : Color(0xff00551D),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  summary.priority?.toUpperCase() ?? 'NORMAL',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 9),
              Text(
                summary.alertMessage ?? 'Team Performance Alert',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                summary.summary.isNotEmpty ? summary.summary : 'No detailed summary available.',
                textAlign: TextAlign.start,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 15),
              if (summary.suggestedAction.isNotEmpty)
                ...summary.suggestedAction.take(2).map((action) =>
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: _buildBulletPoint(action),
                    ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // Team Insight Section
        Container(
          padding: const EdgeInsets.all(16),
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFF001206),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Color(0xff00551D),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Team Insight',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    height: 1.5,
                  ),
                  children: [
                    TextSpan(text: 'Last updated: '),
                    TextSpan(
                      text: summary.updatedAt.formattedDateTime,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    height: 1.5,
                  ),
                  children: [
                    TextSpan(text: 'Status: '),
                    TextSpan(
                      text: summary.status.toUpperCase(),
                      style: TextStyle(
                        color: summary.status == 'active' ? Colors.green : Colors.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              if (summary.reason.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  'Reason: ${summary.reason}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                    height: 1.4,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFallbackSummary() {
    return Column(
      children: [
        // High Priority Section
        Container(
          padding: const EdgeInsets.all(16),
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xff1D0014),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Color(0xff620041),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'High Priority',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 9),
              Text(
                'Nadia Islam-',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Nadia is significantly underperforming across all metrics. Coins are 37% below target, hours are inconsistent, and follower growth has stalled.',
                textAlign: TextAlign.start,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 15),
              _buildBulletPoint('Schedule one-on-one coaching session to identify blockers'),
              const SizedBox(height: 6),
              _buildBulletPoint('Review content strategy and posting schedule'),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // Team Insight Section
        Container(
          padding: const EdgeInsets.all(16),
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFF001206),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Color(0xff00551D),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Team Insight',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    height: 1.5,
                  ),
                  children: [
                    TextSpan(text: 'Your team is averaging '),
                    TextSpan(
                      text: '4.2 hours',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(text: ' and '),
                    TextSpan(
                      text: '1,092 coins',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(text: ' per creator today.'),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    height: 1.5,
                  ),
                  children: [
                    TextSpan(
                      text: '4',
                      style: TextStyle(color:Colors.white,fontWeight: FontWeight.bold),
                    ),
                    TextSpan(text: ' out of ',style: TextStyle(color:Colors.white,)),
                    TextSpan(
                      text: '8',
                      style: TextStyle(color:Colors.white,fontWeight: FontWeight.bold),
                    ),
                    TextSpan(text: ' creators are performing well.',style: TextStyle(color:Colors.white,)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBulletPoint(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(top: 6),
          width: 4,
          height: 4,
          decoration: BoxDecoration(
            color: Color(0xffAD46FF),
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 13,
              color: Colors.white,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}