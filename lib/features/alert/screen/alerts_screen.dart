import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:top_talent_agency/app/urls.dart';
import 'package:top_talent_agency/core/roles.dart';
import 'package:top_talent_agency/core/services/token_storage_service.dart';
import 'package:top_talent_agency/features/alert/data/alert_counts_model.dart';
import 'package:top_talent_agency/features/alert/widget/custom_alert.dart';
import 'package:top_talent_agency/features/alert/widget/custom_medium.dart';
import '../../../common/custom_color.dart';

class AlertsScreen extends StatefulWidget {
  final UiUserRole role;

  const AlertsScreen({super.key, required this.role});

  @override
  State<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> {
  int selectedIndex = 0;
  late final List<String> tabs;
  bool isLoading = false;
  AlertCountsModel? alertCounts;
  List<Alert> alerts = [];
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchAlerts();

    if (widget.role == UiUserRole.manager) {
      tabs = ['All', 'Under', 'Spike'];
    } else if (widget.role == UiUserRole.admin) {
      tabs = ['All', 'Under', 'Spike', 'Target', 'System'];
    } else {
      tabs = [];
    }
  }

  Future<void> _fetchAlerts() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final token = await TokenStorageService.getStoredToken();
      final dio = Dio();

      final response = await dio.get(
        _getRoleWiseAlertUrl(widget.role),
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            if (token != null) 'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data;
        print('🔍 API Response for role ${widget.role}: $data');

        // Parse the alerts response with role-wise data
        final alertsResponse = AlertsResponse.fromJson(data);

        setState(() {
          alertCounts = alertsResponse.alertCounts;
          alerts = alertsResponse.alerts;
          isLoading = false;
        });

        print(
          '✅ Parsed: High=${alertCounts?.high}, Low=${alertCounts?.low}, Alerts count: ${alerts.length}',
        );
      } else {
        setState(() {
          errorMessage = 'Failed to load alerts (${response.statusCode})';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error: $e';
        isLoading = false;
      });
      print('❌ Error fetching alerts: $e');
    }
  }

  String _getRoleWiseAlertUrl(UiUserRole role) {
    switch (role) {
      case UiUserRole.admin:
        return '${Urls.AI_Response_alerts}?role=admin';
      case UiUserRole.manager:
        return '${Urls.AI_Response_alerts}?role=manager';
      case UiUserRole.creator:
        return '${Urls.AI_Response_alerts}?role=creator';
      default:
        return Urls.AI_Response_alerts;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Alerts",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 15),

              //Medium card with API data
              CustomMedium(
                high: alertCounts?.high ?? 0,
                low: alertCounts?.low ?? 0,
              ),

              const SizedBox(height: 25),

              // Alerts list
              if (alerts.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 40),
                  child: Center(
                    child: Text(
                      'No alerts available',
                      style: TextStyle(color: Colors.white54, fontSize: 16),
                    ),
                  ),
                )
              else
                ...alerts.map(
                      (alert) => Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: CustomAlert(
                      priorityLabel: alert.priority?.toUpperCase() ?? "HIGH",
                      priorityConColor: _getPriorityColor(alert.priority),
                      priorityColor: _getPriorityBgColor(alert.priority),
                      categoryLabel: alert.alertType ?? "general",
                      categoryLabelCo: _getPriorityColor(alert.priority),
                      name: alert.username ?? 'Unknown User',
                      description:
                      alert.alertMessage ?? 'No description available',
                      date: _formatDate(alert.updatedAt),
                      containerColor: const Color(0xFF101828),
                      containerBorderColor: _getPriorityColor(alert.priority),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getPriorityColor(String? priority) {
    switch (priority?.toLowerCase()) {
      case 'critical':
        return const Color(0xffD4183D);
      case 'high':
        return const Color(0xffD4183D);
      case 'medium':
        return const Color(0xffFF6900);
      case 'low':
        return const Color(0xff00A63E);
      default:
        return const Color(0xffD4183D);
    }
  }

  Color _getPriorityBgColor(String? priority) {
    switch (priority?.toLowerCase()) {
      case 'critical':
        return const Color(0xffFFE2E2);
      case 'high':
        return const Color(0xffFFE2E2);
      case 'medium':
        return const Color(0xffFFEDD4);
      case 'low':
        return const Color(0xffE2F7E2);
      default:
        return const Color(0xffFFE2E2);
    }
  }

  String _formatDate(DateTime? dateTime) {
    if (dateTime == null) return 'Unknown date';

    return '${dateTime.day.toString().padLeft(2, '0')}/'
        '${dateTime.month.toString().padLeft(2, '0')}/'
        '${dateTime.year}, '
        '${dateTime.hour.toString().padLeft(2, '0')}:'
        '${dateTime.minute.toString().padLeft(2, '0')}:'
        '${dateTime.second.toString().padLeft(2, '0')}';
  }
}
