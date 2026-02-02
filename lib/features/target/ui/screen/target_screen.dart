import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:top_talent_agency/core/roles.dart';
import 'package:top_talent_agency/app/urls.dart';
import 'package:top_talent_agency/core/services/token_storage_service.dart';
import 'package:top_talent_agency/features/target/data/target_request_model.dart';
import '../widget/custom_targets.dart';

class TargetsScreen extends StatefulWidget {
  final UiUserRole role;
  const TargetsScreen({super.key, required this.role});

  @override
  State<TargetsScreen> createState() => _TargetsScreenState();
}

class _TargetsScreenState extends State<TargetsScreen> {
  bool isLoading = true;
  final List<_MonthTarget> monthTargets = [];
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchTargetData();
  }

  Future<void> _fetchTargetData() async {
    print('=== TARGETS SCREEN: FETCHING DATA ===');
    try {
      final dio = Dio();

      // Get authentication token
      final token = await TokenStorageService.getStoredToken();
      print('   - Token found: ${token != null ? "YES" : "NO"}');

      if (!mounted) return;
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      final months = _getRecentMonths(4);
      final List<_MonthTarget> fetched = [];

      for (final month in months) {
        final apiUrl = _roleWiseMonthUrl(widget.role, month);

        print(' Target Request:');
        print('   - Role: ${widget.role}');
        print('   - URL: $apiUrl');
        print('   - Month: $month');

        try {
          final response = await dio.get(
            apiUrl,
            options: Options(
              headers: {
                'Content-Type': 'application/json',
                if (token != null) 'Authorization': 'Bearer $token',
              },
            ),
          );

          if (response.statusCode == 200 && response.data != null && response.data is Map) {
            final data = (response.data as Map).cast<String, dynamic>();
            fetched.add(_MonthTarget(month: month, data: data));
          } else {
            errorMessage ??= 'Request failed (${response.statusCode}) for month $month';
          }
        } on DioException catch (e) {
          final status = e.response?.statusCode;
          errorMessage ??= 'Request failed (${status ?? 'no status'}) for month $month';
        }
      }

      if (!mounted) return;
      setState(() {
        monthTargets
          ..clear()
          ..addAll(fetched);
        isLoading = false;
        if (fetched.isEmpty && errorMessage == null) {
          errorMessage = 'No data returned from API';
        }
      });
    } catch (e) {
      print('❌ Error fetching target data: $e');
      setState(() {
        isLoading = false;
        errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        elevation: 0,
        title: Text(
          widget.role == UiUserRole.creator
              ? "Targets for you"
              : "Total targets for Agency",
          style: const TextStyle(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Colors.white),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (monthTargets.isEmpty) ...[
                      Container(
                        padding: const EdgeInsets.all(32),
                        decoration: BoxDecoration(
                          color: const Color(0xff1D0014),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.data_usage,
                              size: 48,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              "No target data available",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              errorMessage ?? "Please check your connection and try again",
                              style: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: _fetchTargetData,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xff620041),
                                foregroundColor: Colors.white,
                              ),
                              child: const Text("Retry"),
                            ),
                          ],
                        ),
                      ),
                    ] else ...[
                      ...monthTargets.map((item) {
                        print('🔍 MonthTarget for ${item.month}:');
                        print('   - All keys: ${item.data.keys.toList()}');
                        print('   - diamondtotal: ${item.data['diamondtotal']}');
                        print('   - diamonds: ${item.data['diamonds']}');
                        print('   - total_hour: ${item.data['total_hour']}');
                        
                        final diamonds = int.tryParse(item.data['diamondtotal']?.toString() ?? '0') ?? 0;
                        final hours = double.tryParse(item.data['total_hour']?.toString() ?? '0') ?? 0.0;

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: CustomTargets(
                            title: item.data['month']?.toString() ?? _formatMonthLabel(item.month),
                            progressBarColor: Colors.blue,
                            containerColor: const Color(0xff1D0014),
                            diamonds: diamonds,
                            Hours: hours,
                          ),
                        );
                      }).toList(),
                    ],
                  ],
                ),
              ),
            ),
    );
  }

  Color _getProgressColor(double percentage) {
    if (percentage >= 1.0) return const Color(0xff00A63E); // Green
    if (percentage >= 0.8) return Colors.orange;
    if (percentage >= 0.6) return Colors.yellow;
    return Colors.red;
  }
}

String _roleWiseMonthUrl(UiUserRole role, String month) {
  switch (role) {
    case UiUserRole.admin:
      return Urls.monthWiseTargetFilterAdmin(month);
    case UiUserRole.creator:
      return Urls.monthWiseTargetFilterCreator(month);
    case UiUserRole.manager:
    default:
      return Urls.monthWiseTargetFilterManager(month);
  }
}

class _MonthTarget {
  final String month;
  final Map<String, dynamic> data;

  const _MonthTarget({required this.month, required this.data});
}

List<String> _getRecentMonths(int count) {
  final now = DateTime.now();
  final List<String> months = [];
  for (int i = 0; i < count; i++) {
    final date = DateTime(now.year, now.month - i, 1);
    months.add('${date.year}${date.month.toString().padLeft(2, '0')}');
  }
  return months;
}

String _formatMonthLabel(String yyyyMM) {
  if (yyyyMM.length != 6) return yyyyMM;
  final year = yyyyMM.substring(0, 4);
  final monthNum = int.tryParse(yyyyMM.substring(4, 6)) ?? 1;
  const names = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];
  final idx = (monthNum.clamp(1, 12)) - 1;
  return '${names[idx]} $year';
}
