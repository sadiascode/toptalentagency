import 'package:flutter/material.dart';
import 'package:top_talent_agency/core/roles.dart';
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

  @override
  void initState() {
    super.initState();

    if (widget.role == UiUserRole.manager) {
      tabs = ['All', 'Under', 'Spike'];
    } else if (widget.role == UiUserRole.admin) {
      tabs = ['All', 'Under', 'Spike', 'Target', 'System'];
    } else {
      tabs = [];
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

              /// Medium card
              const CustomMedium(),

              const SizedBox(height: 20),

              ///  Tabs UI (NOT for creator)
              if (widget.role != UiUserRole.creator)
                Container(
                  height: 46,
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF101828),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    children: List.generate(tabs.length, (index) {
                      final bool isSelected = selectedIndex == index;
                      return Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedIndex = index;
                            });
                          },
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Colors.black
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Text(
                              tabs[index],
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),

              if (widget.role != UiUserRole.creator)
                const SizedBox(height: 15),

              /// Gradient line
              if (widget.role != UiUserRole.creator)
              Container(
                height: 1,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: AppColors.primaryGradient,
                  ),
                ),
              ),

              const SizedBox(height: 20),

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
}
