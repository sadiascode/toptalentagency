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
        
        setState(() {
          alertCounts = AlertCountsModel.fromJson(data);
          isLoading = false;
        });
        
        print('✅ Parsed: High=${alertCounts?.high}, Low=${alertCounts?.low}');
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
        return '${Urls.AI_Response_alertproblem}?role=admin';
      case UiUserRole.manager:
        return '${Urls.AI_Response_alertproblem}?role=manager';
      case UiUserRole.creator:
        return '${Urls.AI_Response_alertproblem}?role=creator';
      default:
        return Urls.AI_Response_alertproblem;
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

              /// Medium card with API data
              CustomMedium(
                high: alertCounts?.high ?? 0,
                low: alertCounts?.low ?? 0,
              ),

              const SizedBox(height: 25),

              /// Alerts list
              const CustomAlert(
                priorityLabel: "High",
                priorityConColor: Color(0xffD4183D),
                priorityColor: Color(0xffFFE2E2),
                categoryLabel: "underperformance",
                categoryLabelCo: Color(0xffD4183D),
                name: 'Sarah Johnson',
                description:
                'Sarah Johnson is underperforming - 59% of \ntarget',
                date: '02/12/2025, 13:31:55',
                containerColor: Color(0xFF101828),
                containerBorderColor: Color(0xFFD4183D),
              ),

              const SizedBox(height: 15),

              const CustomAlert(
                priorityLabel: "High",
                priorityConColor: Color(0xffD4183D),
                priorityColor: Color(0xffFFE2E2),
                categoryLabel: "spike",
                categoryLabelCo: Color(0xffD4183D),
                name: 'Lisa Anderson',
                description:
                'Lisa Anderson experienced a 40% drop in \nengagement',
                date: '02/12/2025, 13:31:55',
                containerColor: Color(0xFF101828),
                containerBorderColor: Color(0xFFD4183D),
              ),

              const SizedBox(height: 15),

              const CustomAlert(
                priorityLabel: "Medium",
                priorityConColor: Color(0xffFF6900),
                priorityColor: Color(0xffFFEDD4),
                categoryLabel: "target",
                categoryLabelCo: Color(0xffFF6900),
                name: 'Sarah Johnson',
                description:
                'Monthly target at risk - 65% completion with 5 \ndays remaining',
                date: '02/12/2025, 13:31:55',
                containerColor: Color(0xFF101828),
                containerBorderColor: Color(0xffFF6900),
              ),

              const SizedBox(height: 15),

              const CustomAlert(
                priorityLabel: "Medium",
                priorityConColor: Color(0xffFF6900),
                priorityColor: Color(0xffFFEDD4),
                categoryLabel: "system",
                categoryLabelCo: Color(0xffFF6900),
                name: 'Lisa Anderson',
                description: 'TikTok API token expiring in 3 days',
                date: '02/12/2025, 13:31:55',
                containerColor: Color(0xFF101828),
                containerBorderColor: Color(0xffFF6900),
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
}
