import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
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
import 'package:top_talent_agency/features/manager/data/manager_model.dart';
import 'package:top_talent_agency/features/home/data/manager_home_model.dart';
import 'package:top_talent_agency/features/home/data/creator_home_model.dart';
import 'package:top_talent_agency/app/urls.dart';
import 'package:top_talent_agency/core/services/token_storage_service.dart';

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

  // Manager data from ManagerHomeModel
  ManagerHomeModel? currentManager;

  // Creator data from CreatorHomeModel
  CreatorHomeModel? currentCreator;

  @override
  void initState() {
    super.initState();
    print('🚀 HomeScreen initState called');
    print('🔍 Current role: ${widget.role}');
    print('🔍 Is Manager: $isManager');
    print('🔍 Is Admin: $isAdmin');
    print('🔍 Is Creator: $isCreator');

    _fetchUserProfile();
    _fetchAiData();
    if (isAdmin) {
      print('📊 Fetching admin stats...');
      _fetchAdminStats();
    }
    if (isManager) {
      print('👨‍💼 Fetching manager data...');
      _fetchManagerData();
    }
    if (isCreator) {
      print('🎨 Fetching creator data...');
      _fetchCreatorData();
    }
  }

  Future<void> _fetchManagerData() async {
    print('=== HOME SCREEN: FETCHING MANAGER DATA ===');
    try {
      final token = await TokenStorageService.getStoredToken();
      final dio = Dio();

      print('🔍 Making API call to: ${Urls.Manager_Dashboard_Score}');
      final response = await dio.get(
        Urls.Manager_Dashboard_Score,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            if (token != null) 'Authorization': 'Bearer $token',
          },
        ),
      );

      print('🔍 Response status: ${response.statusCode}');
      print('🔍 Response data type: ${response.data.runtimeType}');

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data;
        print('🔍 Manager API Response: $data');
        print(
          '🔍 Response keys: ${data is Map ? data.keys.toList() : "Not a Map"}',
        );

        // Parse managers list and find current manager
        List<ManagerHomeModel> managerList = [];

        if (data is List) {
          print('🔍 Data is List with ${data.length} items');
          print(
            '🔍 First item keys: ${data.isNotEmpty ? (data[0] is Map ? data[0].keys.toList() : "Not a Map") : "Empty"}',
          );
          try {
            managerList = data
                .map((item) => ManagerHomeModel.fromJson(item))
                .toList();
            print('✅ ManagerHomeModel parsing successful');
          } catch (e) {
            print('❌ ManagerHomeModel parsing error: $e');
          }
        } else if (data['data'] is List) {
          print('🔍 Data contains List with ${data['data'].length} items');
          print(
            '🔍 First item keys: ${data['data'].isNotEmpty ? (data['data'][0] is Map ? data['data'][0].keys.toList() : "Not a Map") : "Empty"}',
          );
          try {
            managerList = (data['data'] as List)
                .map((item) => ManagerHomeModel.fromJson(item))
                .toList();
            print('✅ ManagerHomeModel parsing successful');
          } catch (e) {
            print('❌ ManagerHomeModel parsing error: $e');
          }
        } else if (data['managers'] is List) {
          print(
            '🔍 Data contains managers list with ${data['managers'].length} items',
          );
          print(
            '🔍 First item keys: ${data['managers'].isNotEmpty ? (data['managers'][0] is Map ? data['managers'][0].keys.toList() : "Not a Map") : "Empty"}',
          );
          try {
            managerList = (data['managers'] as List)
                .map((item) => ManagerHomeModel.fromJson(item))
                .toList();
            print('✅ ManagerHomeModel parsing successful');
          } catch (e) {
            print('❌ ManagerHomeModel parsing error: $e');
          }
        } else {
          print('🔍 Unexpected data format: ${data.runtimeType}');
          print('🔍 Data structure: $data');
        }

        print('🔍 Parsed ${managerList.length} managers');
        for (int i = 0; i < managerList.length; i++) {
          print(
            '   ${i + 1}. ${managerList[i].username} (rank: ${managerList[i].rank})',
          );
        }

        // Find current manager by name
        final currentManagerName = userProfile?.name;
        print('🔍 Looking for manager with name: "$currentManagerName"');
        print('🔍 User profile name type: ${currentManagerName.runtimeType}');
        print('🔍 User profile available: ${userProfile != null}');

        if (currentManagerName != null && currentManagerName.isNotEmpty) {
          bool found = false;
          for (var manager in managerList) {
            print('🔍 Comparing:');
            print(
              '   - Manager username: "${manager.username}" (type: ${manager.username.runtimeType})',
            );
            print(
              '   - Profile name: "$currentManagerName" (type: ${currentManagerName.runtimeType})',
            );
            print(
              '   - Are they equal? ${manager.username == currentManagerName}',
            );
            print('   - Manager username trim: "${manager.username?.trim()}"');
            print('   - Profile name trim: "${currentManagerName.trim()}"');
            print(
              '   - Trim equal? ${manager.username?.trim() == currentManagerName.trim()}',
            );

            if (manager.username?.trim() == currentManagerName.trim()) {
              if (mounted) {
                setState(() {
                  currentManager = manager;
                });
                print(
                  '✅ Manager data loaded: ${manager.username} with rank ${manager.rank}',
                );
                print('🔍 ManagerHomeModel values:');
                print('   - myCreators: ${manager.myCreators}');
                print('   - totalDiamond: ${manager.totalDiamond}');
                print('   - totalHour: ${manager.totalHour}');
                print('   - atRisk: ${manager.atRisk}');
                found = true;
              }
              return;
            }
          }
          if (!found) {
            print('❌ No manager found with name: "$currentManagerName"');
            print('🔍 Available manager names:');
            for (var manager in managerList) {
              print('   - "${manager.username}"');
            }
          }
        } else {
          print('❌ Current manager name is null or empty');
        }

        // Fallback: if no specific manager found but we have manager data, use the first one
        if (currentManager == null && managerList.isNotEmpty) {
          print('🔄 Using fallback: first manager in list');
          if (mounted) {
            setState(() {
              currentManager = managerList.first;
            });
            print(
              '✅ Fallback manager data loaded: ${managerList.first.username} with rank ${managerList.first.rank}',
            );
          }
        }

        print('❌ Current manager not found in API response');
      } else {
        print('❌ No manager data available - Status: ${response.statusCode}');
      }
    } catch (e) {
      print('💥 Error fetching manager data: $e');
    }
  }

  Future<void> _fetchCreatorData() async {
    print('=== HOME SCREEN: FETCHING CREATOR DATA ===');
    try {
      final token = await TokenStorageService.getStoredToken();
      final dio = Dio();

      print('🔍 Making API call to: ${Urls.Creator_Dashboard_Score}');
      final response = await dio.get(
        Urls.Creator_Dashboard_Score,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            if (token != null) 'Authorization': 'Bearer $token',
          },
        ),
      );

      print('🔍 Response status: ${response.statusCode}');
      print('🔍 Response data type: ${response.data.runtimeType}');

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data;
        print('🔍 Creator API Response: $data');
        print(
          '🔍 Response keys: ${data is Map ? data.keys.toList() : "Not a Map"}',
        );

        // Parse creators list and find current creator
        List<CreatorHomeModel> creatorList = [];

        if (data is List) {
          print('🔍 Data is List with ${data.length} items');
          try {
            creatorList = data
                .map((item) => CreatorHomeModel.fromJson(item))
                .toList();
            print('✅ CreatorHomeModel parsing successful');
          } catch (e) {
            print('❌ CreatorHomeModel parsing error: $e');
          }
        } else if (data['data'] is List) {
          print('🔍 Data contains List with ${data['data'].length} items');
          try {
            creatorList = (data['data'] as List)
                .map((item) => CreatorHomeModel.fromJson(item))
                .toList();
            print('✅ CreatorHomeModel parsing successful');
          } catch (e) {
            print('❌ CreatorHomeModel parsing error: $e');
          }
        } else if (data['creators'] is List) {
          print(
            '🔍 Data contains creators list with ${data['creators'].length} items',
          );
          try {
            creatorList = (data['creators'] as List)
                .map((item) => CreatorHomeModel.fromJson(item))
                .toList();
            print('✅ CreatorHomeModel parsing successful');
          } catch (e) {
            print('❌ CreatorHomeModel parsing error: $e');
          }
        } else {
          print('🔍 Unexpected data format: ${data.runtimeType}');
          print('🔍 Data structure: $data');
        }

        print('🔍 Parsed ${creatorList.length} creators');
        for (int i = 0; i < creatorList.length; i++) {
          print(
            '   ${i + 1}. Rank: ${creatorList[i].rank}, Diamond: ${creatorList[i].totalDiamond}',
          );
        }

        // Find current creator by name
        final currentCreatorName = userProfile?.name;
        print('🔍 Looking for creator with name: $currentCreatorName');

        if (currentCreatorName != null) {
          for (var creator in creatorList) {
            // For creators, we might need to match by name or just use the first one
            // since creators might not have usernames in the same way
            if (mounted) {
              setState(() {
                currentCreator = creator;
              });
              print(
                '✅ Creator data loaded: Rank ${creator.rank}, Diamond: ${creator.totalDiamond}',
              );
              print('🔍 CreatorHomeModel values:');
              print('   - rank: ${creator.rank}');
              print('   - totalDiamond: ${creator.totalDiamond}');
              print('   - totalHour: ${creator.totalHour}');
              return;
            }
          }
        }

        // If no specific match found, use the first creator
        if (creatorList.isNotEmpty && mounted) {
          setState(() {
            currentCreator = creatorList.first;
          });
          print('✅ Using first creator data: Rank ${creatorList.first.rank}');
        }
      } else {
        print('❌ No creator data available - Status: ${response.statusCode}');
      }
    } catch (e) {
      print('💥 Error fetching creator data: $e');
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

  // Helper method to get ordinal suffix (1st, 2nd, 3rd, 4th, etc.)
  String _getOrdinalSuffix(int number) {
    if (number >= 11 && number <= 13) {
      return 'th';
    }
    switch (number % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }

  @override
  Widget build(BuildContext context) {
    final ManagerController managerController = Get.put(ManagerController());

    print('🏠 HomeScreen Build Debug:');
    print('   - Role: ${widget.role}');
    print('   - Is Admin: $isAdmin');
    print('   - Is Manager: $isManager');
    print('   - Is Creator: $isCreator');
    print('   - AI Data: ${aiData != null ? "Present" : "Null"}');
    print('   - Is Loading: $isLoading');
    print('   - Error Message: $errorMessage');
    print(
      '   - Current Manager: ${currentManager != null ? "Present (${currentManager?.username})" : "Null"}',
    );
    print(
      '   - Current Creator: ${currentCreator != null ? "Present (rank: ${currentCreator?.rank})" : "Null"}',
    );
    print(
      '   - User Profile: ${userProfile != null ? "Present (${userProfile?.name})" : "Null"}',
    );

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
                          child: Icon(
                            Icons.person,
                            size: 24,
                            color: Colors.grey[600],
                          ),
                        );
                      },
                    )
                        : Container(
                      color: Colors.grey[300],
                      child: Icon(
                        Icons.person,
                        size: 24,
                        color: Colors.grey[600],
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
                      isLoadingProfile
                          ? 'Loading...'
                          : (userProfile?.name ?? 'User'),
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
                  child: currentManager != null
                      ? Text(
                    "You are in ${currentManager!.rank}${_getOrdinalSuffix(currentManager!.rank)} position in manager ranking",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  )
                      : Text(
                    "Loading ranking...",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
              if (widget.role == UiUserRole.manager ||
                  widget.role == UiUserRole.creator) ...[
                const SizedBox(height: 15),
                Row(
                  children: [
                    CustomBoth(
                      title: isManager ? "My Creators" : "My Rank",
                      iconPath: 'assets/user.svg',
                      iconColor: Color(0xff6A7282),
                      number: isManager
                          ? (currentManager?.myCreators ?? 0)
                          : (currentCreator?.rank ?? 0),
                      subtitleColor: Color(0xff00A63E),
                    ),
                    SizedBox(width: 9),
                    CustomBoth(
                      title: "Today's Diamonds",
                      iconPath: 'assets/coin.svg',
                      iconColor: Color(0xffF0B100),
                      number: isManager
                          ? (currentManager?.totalDiamond ?? 0)
                          : (currentCreator?.totalDiamond ?? 0),
                    ),
                  ],
                ),
                SizedBox(height: 15),

                Row(
                  children: [
                    CustomBoth(
                      title: "Hours",
                      iconPath: 'assets/clock.svg',
                      iconColor: Color(0xff2B7FFF),
                      number: isManager
                          ? (double.tryParse(
                        currentManager?.totalHour ?? '0',
                      )?.toInt() ??
                          0)
                          : (double.tryParse(
                        currentCreator?.totalHour ?? '0',
                      )?.toInt() ??
                          0),
                      subtitleColor: Color((0xffF54900)),
                    ),
                    SizedBox(width: 9),
                    CustomBoth(
                      title: "Risk",
                      iconPath: 'assets/Alert.svg',
                      iconColor: Color(0xffCF5050),
                      number: isManager
                          ? (currentManager?.atRisk ?? 0)
                          : 0, // Creator model doesn't have atRisk field
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
                CustomPichart(
                  diamondValue: isManager
                      ? (currentManager?.totalDiamond.toString() ?? '0')
                      : (currentCreator?.totalDiamond.toString() ?? '0'),
                ),

              SizedBox(height: 25),
              if (isAdmin)
                CustomCoin(
                  totalHour: adminStats?.formattedHour ?? '0',
                  totalDiamondAchieve:
                  adminStats?.formattedDiamondAchieve ?? '0',
                )
              else
                CustomCoin(
                  totalHour: isManager
                      ? (currentManager?.totalHour ?? '0')
                      : (currentCreator?.totalHour ?? '0'),
                  totalDiamondAchieve: isManager
                      ? (currentManager?.totalDiamond.toString() ?? '0')
                      : (currentCreator?.totalDiamond.toString() ?? '0'),
                ),

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
