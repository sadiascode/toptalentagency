import 'package:flutter/material.dart';
import 'package:top_talent_agency/features/home/data/home_ai_model.dart';

import '../../../common/custom_color.dart';

class CustomAlerts extends StatelessWidget {
  final AdminHomeAiModel? aiData;
  final bool isLoading;
  final String? errorMessage;

  const CustomAlerts({
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
        maxWidth: screenWidth > 600 ? 386 : double.infinity,
        minHeight: screenHeight > 800 ? 266 : 220,
        maxHeight: screenHeight > 800 ? 300 : 250,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Alerts',
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width > 600 ? 20 : 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                if (isLoading)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.blue[100],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'Loading...',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.blue[900],
                      ),
                    ),
                  )
                else if (aiData != null && aiData!.dailySummary.alertMessage != null)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                    decoration: BoxDecoration(
                      color: aiData!.dailySummary.priority == 'high'
                          ? Colors.red[100]
                          : aiData!.dailySummary.priority == 'medium'
                          ? Colors.orange[100]
                          : Colors.green[100],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      aiData!.dailySummary.priority?.toUpperCase() ?? 'NORMAL',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: aiData!.dailySummary.priority == 'high'
                            ? Colors.red[900]
                            : aiData!.dailySummary.priority == 'medium'
                            ? Colors.orange[900]
                            : Colors.green[900],
                      ),
                    ),
                  )
                else
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'No Alerts',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 10),

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
                      'Loading alerts...',
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
                      'Error loading alerts',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              )
                  : aiData != null && aiData!.dailySummary.alertMessage != null
                  ? SingleChildScrollView(
                child: _buildAiAlerts(aiData!),
              )
                  : SingleChildScrollView(
                child: _buildFallbackAlerts(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAiAlerts(AdminHomeAiModel aiData) {
    final summary = aiData.dailySummary;

    return Column(
      children: [
        // Main alert message
        _buildAlertItem(
          summary.alertMessage ?? 'No alerts available',
          summary.updatedAt.formattedTime,
          priority: summary.priority ?? 'medium',
        ),

        // Additional summary if available
        if (summary.summary.isNotEmpty) ...[
          const SizedBox(height: 10),
          _buildAlertItem(
            summary.summary,
            summary.updatedAt.formattedTime,
            priority: 'low',
          ),
        ],

        // Suggested actions
        if (summary.suggestedAction.isNotEmpty) ...[
          const SizedBox(height: 10),
          _buildAlertItem(
            'Suggested: ${summary.suggestedAction.first}',
            summary.updatedAt.formattedTime,
            priority: 'low',
          ),
        ],
      ],
    );
  }

  Widget _buildFallbackAlerts() {
    return Column(
      children: [
        _buildAlertItem(
          'Manager Lisa Anderson is underperforming - 59% of target',
          '13:31:55',
        ),
        const SizedBox(height: 10),
        _buildAlertItem(
          'Manager Lisa Anderson is underperforming - 59% of target',
          '13:31:55',
        ),
        const SizedBox(height: 10),
        _buildAlertItem(
          'Manager Lisa Anderson is underperforming - 59% of target',
          '13:31:55',
        ),
      ],
    );
  }

  Widget _buildAlertItem(String message, String time, {String priority = 'medium'}) {
    Color dotColor = Colors.orange;
    if (priority == 'high') dotColor = Colors.red;
    if (priority == 'low') dotColor = Colors.green;

    return Container(
      height: 52,
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: dotColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 13,
                color: Colors.white,
                height: 1.3,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            time,
            style: TextStyle(
              fontSize: 12,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}