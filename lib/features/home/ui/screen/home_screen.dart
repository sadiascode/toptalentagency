import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:top_talent_agency/core/roles.dart';
import 'package:top_talent_agency/core/services/role_storage_service.dart';
import 'package:top_talent_agency/features/home/controller/admin/manager_controller.dart';
import 'package:top_talent_agency/features/home/data/home_ai_model.dart';
import 'package:top_talent_agency/features/home/services/home_ai_service.dart';
import 'package:top_talent_agency/features/home/services/admin_stats_service.dart';
import 'package:top_talent_agency/features/home/widget/custom_alerts.dart';
import 'package:top_talent_agency/features/home/widget/custom_both.dart';
import 'package:top_talent_agency/features/home/widget/custom_coin.dart';
import 'package:top_talent_agency/features/home/widget/custom_minicontainer.dart';
import 'package:top_talent_agency/features/home/widget/custom_pichart.dart';
import 'package:top_talent_agency/features/home/widget/custom_summary.dart';

class HomeScreen extends StatefulWidget {
  final UiUserRole role;

  const HomeScreen({super.key, required this.role});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  AdminHomeAiModel? aiData;
  bool isLoading = false;
  String? errorMessage;
  late ManagerController managerController;

  @override
  void initState() {
    super.initState();
    print('🏠 initState called');
    print('   - Is Admin: $isAdmin');
    _fetchAiData();
    if (isAdmin) {
      print('🏠 Calling _fetchAdminStats...');
      _fetchAdminStats();
    } else {
      print('🏠 Not admin, skipping admin stats fetch');
    }
  }

  Future<void> _fetchAiData() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      print(' Home Screen: Fetching AI data for role: ${widget.role.name}');
      final data = await HomeAiService.fetchAiResponse(widget.role.name);
      
      setState(() {
        isLoading = false;
        aiData = data;
      });

      if (data != null) {
        print(' Home Screen: AI data loaded');
        print('   - Welcome Msg: ${data.welcomeMsg.msg}');
        print('   - Alert Message: ${data.dailySummary.alertMessage}');
        print('   - Priority: ${data.dailySummary.priority}');
      } else {
        print(' Home Screen: Using fallback data');
        setState(() {
          aiData = HomeAiService.createFallbackModel(widget.role.name);
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = e.toString();
        aiData = HomeAiService.createFallbackModel(widget.role.name);
      });
      print(' Home Screen: Error - $errorMessage');
    }
  }

  Future<void> _fetchAdminStats() async {
    try {
      print(' Home Screen: Fetching admin stats...');
      final adminStats = await AdminStatsService.fetchAdminStats();
      
      if (adminStats != null && aiData != null) {
        setState(() {
          // Update existing aiData with new admin stats
          aiData = AdminHomeAiModel(
            welcomeMsg: aiData!.welcomeMsg,
            dailySummary: aiData!.dailySummary,
            adminStats: adminStats,
          );
        });
        print(' Home Screen: Admin stats updated successfully');
      }
    } catch (e) {
      print(' Home Screen: Error fetching admin stats - $e');
    }
  }

  bool get isAdmin => widget.role == UiUserRole.admin;
  bool get isManager => widget.role == UiUserRole.manager;
  bool get isCreator => widget.role == UiUserRole.creator;

  @override
  Widget build(BuildContext context) {
    final ManagerController managerController = Get.put(ManagerController());
    
    print(' HomeScreen Build Debug:');
    print('   - Role: ${widget.role}');
    print('   - Is Admin: $isAdmin');
    print('   - AI Data: ${aiData != null ? "Present" : "Null"}');
    print('   - Is Loading: $isLoading');
    print('   - Error Message: $errorMessage');

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
          child: AppBar(
            centerTitle: true,
            backgroundColor: Color(0xff101828),
            elevation: 0,
            toolbarHeight: 100,
            title: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey[200],
                  ),
                  child: ClipOval(
                    child: Container(
                      width: 48,
                      height: 48,
                      color: Colors.grey[300],
                      child: Image.network(
                        'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=200',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.role == UiUserRole.admin
                          ? 'Akhil Doe'
                          : widget.role == UiUserRole.manager
                          ? 'Sarah Johnson'
                          : 'John Doe',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      widget.role == UiUserRole.admin
                          ? 'Welcome back, Admin'
                          : widget.role == UiUserRole.manager
                          ? 'Welcome back, Manager'
                          : 'Welcome back, Creator',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xffA2A3A3),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(
          top: 20.0, 
          left: MediaQuery.of(context).size.width > 600 ? 20.0 : 9.0,
          right: MediaQuery.of(context).size.width > 600 ? 20.0 : 9.0,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              if (isManager) ...[
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: const Text(
                    "You are in 5th position in manager ranking",
                    textAlign: TextAlign.center,
                    style: TextStyle(color:Colors.white,fontWeight: FontWeight.w600, fontSize: 15),
                  ),
                ),
                ],
              if (widget.role == UiUserRole.manager || widget.role == UiUserRole.creator) ...[

                const SizedBox(height: 15),
                Row(
                  children: [
                    CustomBoth(
                      title: isManager ? "My Creators" : "My Rank",
                      iconPath: 'assets/user.svg',
                      iconColor:Color(0xff6A7282),
                      number: 10666,
                      subtitleColor: Color(0xff00A63E),
                    ),
                    SizedBox(width: 9),
                    CustomBoth(
                      title: "Today's Diamonds",
                      iconPath: 'assets/coin.svg',
                      iconColor:Color(0xffF0B100),
                      number: 2035,
                    ),
                  ],
                ),
                SizedBox(height: 15),

                Row(
                  children: [
                    CustomBoth(
                      title: "Today's Hours",
                      iconPath: 'assets/clock.svg',
                      iconColor:Color(0xff2B7FFF),
                      number: 24560,
                      subtitleColor: Color((0xffF54900)),
                    ),
                    SizedBox(width: 9),
                    CustomBoth(
                      title: "Alerts",
                      iconPath: 'assets/Alert.svg',
                      iconColor:Color(0xffCF5050),
                      number: 45623,
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "December Overview",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
              if (isAdmin) ...[
                Row(
                  children: [
                    CustomMinicontainer(
                      title: "Total Creators",
                      iconPath: 'assets/user.svg',
                      number: aiData?.adminStats.totalCreators ?? 1000,
                    ),
                    SizedBox(width: 9),
                    Flexible(
                      fit: FlexFit.loose,
                      child: Obx(() {
                        if (managerController.isLoading.value) {
                          return CustomMinicontainer(
                            title: "Managers",
                            iconPath: 'assets/m.svg',
                            number: aiData?.adminStats.totalManagers ?? 0,
                          );
                        } else {
                          return CustomMinicontainer(
                            title: "Managers",
                            iconPath: 'assets/m.svg',
                            number: aiData?.adminStats.totalManagers ?? managerController.managerCount.value,
                          );
                        }
                      }),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                Row(
                  children: [
                    CustomMinicontainer(
                      title: "Total Diamonds",
                      iconPath: 'assets/coin.svg',
                      number: aiData?.adminStats.totalDiamonds ?? 240,
                    ),
                    SizedBox(width: 9),
                    CustomMinicontainer(
                      title: "Total Scrap",
                      iconPath: 'assets/clock.svg',
                      number: aiData?.adminStats.totalScrap ?? 45623,
                    ),
                  ],
                ),
                SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "December Overview",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
              SizedBox(height: 5),
              CustomPichart(),

              SizedBox(height: 25),
              CustomCoin(),

              SizedBox(height: 20),
              CustomAlerts(
                aiData: aiData,
                isLoading: isLoading,
                errorMessage: errorMessage,
              ),

              SizedBox(height: 20),
              CustomSummary(
                aiData: aiData,
                isLoading: isLoading,
                errorMessage: errorMessage,
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
