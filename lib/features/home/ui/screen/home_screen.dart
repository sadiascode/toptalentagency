import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:top_talent_agency/core/roles.dart';
import 'package:top_talent_agency/core/services/role_storage_service.dart';
import 'package:top_talent_agency/features/home/controller/admin/manager_controller.dart';
import 'package:top_talent_agency/features/home/data/home_ai_model.dart';
import 'package:top_talent_agency/features/home/data/admin_stats_model.dart';
import 'package:top_talent_agency/features/home/services/home_ai_service.dart';
import 'package:top_talent_agency/features/home/services/admin_stats_service.dart';
import 'package:top_talent_agency/features/more/services/user_profile_service.dart';
import 'package:top_talent_agency/features/more/data/user_profile_model.dart';
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
  AdminStatsModel? adminStats;
  bool isLoading = false;
  String? errorMessage;
  late ManagerController managerController;
  
  // User profile data
  UserProfileModel? userProfile;
  bool isLoadingProfile = true;

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
    _fetchAiData();
    if (isAdmin) {
      _fetchAdminStats();
    }
  }

  Future<void> _fetchUserProfile() async {
    print('=== HOME SCREEN: FETCHING USER PROFILE ===');
    final profile = await UserProfileService.getUserProfile();
    if (mounted) {
      setState(() {
        userProfile = profile;
        isLoadingProfile = false;
      });
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
      final stats = await AdminStatsService.fetchAdminStats();
      
      if (stats != null) {
        setState(() {
          adminStats = stats;
        });
        print(' Home Screen: Admin stats updated successfully');
        print('   - Total Creators: ${stats.totalCreators}');
        print('   - Total Managers: ${stats.totalManagers}');
        print('   - Scrape Today: ${stats.scrapeToday}');
        print('   - Total Diamond Achieve: ${stats.totalDiamondAchieve}');
        print('   - Total Hour: ${stats.totalHour}');
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
                    child: userProfile?.profileImage != null
                        ? Image.network(
                            userProfile!.profileImage!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey[300],
                                child: Icon(Icons.person, size: 24, color: Colors.grey[600]),
                              );
                            },
                          )
                        : Container(
                            color: Colors.grey[300],
                            child: Icon(Icons.person, size: 24, color: Colors.grey[600]),
                          ),
                  ),
                ),
                const SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      isLoadingProfile ? 'Loading...' : (userProfile?.name ?? 'User'),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      isLoadingProfile 
                          ? 'Loading...'
                          : 'Welcome back, ${userProfile?.role ?? 'User'}',
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
                      number: adminStats?.totalCreators ?? 0,
                    ),
                    SizedBox(width: 9),
                    CustomMinicontainer(
                      title: "Total Managers",
                      iconPath: 'assets/m.svg',
                      number: adminStats?.totalManagers ?? 0,
                    ),
                  ],
                ),
                SizedBox(height: 15),
                Row(
                  children: [
                    CustomMinicontainer(
                      title: "Scrape Today",
                      iconPath: 'assets/clock.svg',
                      number: adminStats?.scrapeToday ?? 0,
                    ),
                    SizedBox(width: 9),
                    CustomMinicontainer(
                      title: "Total Diamond ",
                      iconPath: 'assets/coin.svg',
                      number: adminStats?.totalDiamondAchieve ?? 0,
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
              if (isAdmin)
                CustomPichart(
                  diamondValue: adminStats?.formattedDiamondAchieve ?? '0',
                )
              else
                CustomPichart(),

              SizedBox(height: 25),
              if (isAdmin)
                CustomCoin(
                  totalHour: adminStats?.formattedHour ?? '0',
                  totalDiamondAchieve: adminStats?.formattedDiamondAchieve ?? '0',
                )
              else
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
