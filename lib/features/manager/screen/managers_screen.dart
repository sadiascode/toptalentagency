import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:top_talent_agency/features/manager/screen/manager_rank.dart';
import 'package:top_talent_agency/features/manager/widget/custom_sortview.dart';
import 'package:top_talent_agency/features/admin/services/manager_dashboard_service.dart';
import 'package:top_talent_agency/features/admin/data/manager_dashboard_model.dart';
import 'package:top_talent_agency/features/manager/data/manager_model.dart';
import '../widget/custom_search.dart';

class ManagersScreen extends StatefulWidget {
  const ManagersScreen({super.key});

  @override
  State<ManagersScreen> createState() => _ManagersScreenState();
}

class _ManagersScreenState extends State<ManagersScreen> {
  ManagerDashboardModel? managerDashboard;
  bool isLoading = true;
  int totalCreators = 0;

  @override
  void initState() {
    super.initState();
    _fetchManagerDashboard();
  }

  Future<void> _fetchManagerDashboard() async {
    print('=== MANAGERS SCREEN: FETCHING DASHBOARD ===');
    try {
      final dashboard = await ManagerDashboardService.fetchManagerDashboard();
      print('ManagerDashboardService returned: ${dashboard != null ? "SUCCESS" : "NULL"}');
      if (dashboard != null) {
        print('   - Total Managers: ${dashboard.totalManagers}');
        print('   - Managers List Length: ${dashboard.managers.length}');
        print('   - First Manager: ${dashboard.managers.isNotEmpty ? dashboard.managers.first.name : "None"}');

        // Calculate total creators
        int creators = 0;
        for (var manager in dashboard.managers) {
          creators += manager.myCreatorsValue;
          print('   - Adding ${manager.name}: ${manager.myCreatorsValue} creators');
        }

        if (mounted) {
          setState(() {
            managerDashboard = dashboard;
            totalCreators = creators;
            isLoading = false;
          });
          print('✅ State updated with dashboard data');
          print('   - Total Creators: $creators');
        }
      }
    } catch (e) {
      print('💥 Error in _fetchManagerDashboard: $e');
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
    print('=== MANAGERS SCREEN: FETCH COMPLETE ===');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Managers",
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
              const SizedBox(height: 20),
              CustomSearch(
                hintText: "Search managers...",
                onSearch: (query) {
                  print('Searching for manager: $query');
                  // Add search logic here if needed
                },
              ),

              SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isLoading
                            ? "Loading managers..."
                            : "Showing ${managerDashboard?.managers.length ?? 0} of ${managerDashboard?.totalManagers ?? 0} managers",
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
                      if (!isLoading && totalCreators > 0)
                        Text(
                          "Total Creators: $totalCreators",
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.white.withOpacity(0.7),
                          ),
                        ),
                    ],
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ManagerRank(),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: SvgPicture.asset(
                        'assets/soil.svg',
                        color: Colors.white,
                        width: 25,
                        height: 25,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              // Display managers from backend data
              if (!isLoading && managerDashboard != null)
                ...managerDashboard!.managers.map((manager) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: CustomSortview(
                      managerInfo: manager,
                    ),
                  );
                }).toList()
              else if (isLoading)
                Column(
                  children: [
                    CustomSortview(), // Loading placeholder
                    SizedBox(height: 20),
                    CustomSortview(), // Loading placeholder
                    SizedBox(height: 20),
                    CustomSortview(), // Loading placeholder
                  ],
                )
              else
                Column(
                  children: [
                    Text(
                      'No managers found',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}


