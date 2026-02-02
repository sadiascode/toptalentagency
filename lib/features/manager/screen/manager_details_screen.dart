import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:top_talent_agency/app/urls.dart';
import 'package:top_talent_agency/core/roles.dart';
import 'package:top_talent_agency/core/services/token_storage_service.dart';
import 'package:top_talent_agency/features/home/widget/custom_pichart.dart';
import 'package:top_talent_agency/features/manager/screen/view_assign_creator_screen.dart';
import 'package:top_talent_agency/features/manager/widget/actions_tile.dart';
import 'package:top_talent_agency/features/manager/widget/ai_analysis_card.dart';
import 'package:top_talent_agency/features/manager/widget/live_chart.dart';
import 'package:top_talent_agency/features/manager/widget/profile_card.dart';
import 'package:top_talent_agency/features/manager/widget/progress_card.dart';
import 'package:top_talent_agency/features/manager/data/manager_model.dart';
import 'package:top_talent_agency/features/manager/data/single_creator_model.dart';
import 'package:top_talent_agency/features/admin/data/manager_dashboard_model.dart';
import '../../../common/custom_color.dart';


class ManagerDetailsScreen extends StatefulWidget {
  final ManagerModel? managerModel;

  const ManagerDetailsScreen({super.key, this.managerModel});

  @override
  State<ManagerDetailsScreen> createState() => _ManagerDetailsScreenState();
}

class _ManagerDetailsScreenState extends State<ManagerDetailsScreen> {
  bool isLoading = false;
  ManagerInfo? managerInfo;
  Map<String, double>? monthlyData;
  List<SingleCreatorModel>? creators;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    if (widget.managerModel?.id != null) {
      _fetchManagerDetails();
      _fetchMonthlyData();
      _fetchCreators();
    }
  }

  Future<void> _fetchMonthlyData() async {
    try {
      final token = await TokenStorageService.getStoredToken();
      final dio = Dio();
      
      // Get current month API data (it contains last_3_months)
      final now = DateTime.now();
      final monthStr = '${now.year}${now.month.toString().padLeft(2, '0')}';
      
      final response = await dio.get(
        Urls.monthWiseTargetFilterAdmin(monthStr),
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            if (token != null) 'Authorization': 'Bearer $token',
          },
        ),
      );
      
      if (response.statusCode == 200 && response.data != null) {
        final apiData = response.data;
        final Map<String, double> data = {};
        
        print('🔍 Monthly API Response: $apiData');
        
        // Parse last_3_months data from map
        if (apiData['last_3_months'] != null) {
          final last3Months = apiData['last_3_months'];
          
          if (last3Months is Map<String, dynamic>) {
            last3Months.forEach((monthKey, monthData) {
              if (monthData is Map<String, dynamic>) {
                final diamonds = double.tryParse(monthData['diamonds']?.toString() ?? '0') ?? 0.0;
                data[monthKey] = diamonds;
                print('📊 $monthKey: $diamonds diamonds');
              }
            });
          }
        }
        
        setState(() {
          monthlyData = data;
        });
        
        print('✅ 3 Months Data: $data');
      }
    } catch (e) {
      print('❌ Error fetching monthly data: $e');
    }
  }

  Future<void> _fetchCreators() async {
    try {
      final token = await TokenStorageService.getStoredToken();
      final dio = Dio();
      
      final response = await dio.get(
        Urls.getCreatorByManagerId(int.tryParse(widget.managerModel!.id!) ?? 0),
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            if (token != null) 'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data;
        print('🔍 Creators API Response: $data');
        
        List<SingleCreatorModel> creatorList = [];
        
        if (data is List) {
          creatorList = data.map((item) => SingleCreatorModel.fromJson(item)).toList();
        } else if (data['data'] is List) {
          creatorList = (data['data'] as List).map((item) => SingleCreatorModel.fromJson(item)).toList();
        }
        
        setState(() {
          creators = creatorList;
        });
        
        print('✅ Parsed ${creatorList.length} creators');
      }
    } catch (e) {
      print('❌ Error fetching creators: $e');
    }
  }

  Future<void> _fetchManagerDetails() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final token = await TokenStorageService.getStoredToken();
      final dio = Dio();
      
      final response = await dio.get(
        Urls.singleManagerDashboardScore(int.tryParse(widget.managerModel!.id!) ?? 0),
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            if (token != null) 'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data;
        print('🔍 Manager Details API Response: $data');
        
        // Handle both List and Map responses
        Map<String, dynamic> managerData;
        if (data is List && data.isNotEmpty) {
          managerData = data[0] as Map<String, dynamic>;
        } else if (data is Map<String, dynamic>) {
          managerData = data;
        } else {
          throw Exception('Invalid API response format');
        }
        
        setState(() {
          managerInfo = ManagerInfo.fromJson(managerData);
          isLoading = false;
        });
        
        print('✅ Manager Details Parsed: ${managerInfo?.name}');
      } else {
        setState(() {
          errorMessage = 'Failed to load manager details (${response.statusCode})';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error: $e';
        isLoading = false;
      });
      print('❌ Error fetching manager details: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back_ios,color: Colors.white,size: 20,)),
        title: Text(
          "Manager Details",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.more_vert, color: Colors.white),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
          Container(
          padding: const EdgeInsets.all(1.5),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: AppColors.primaryGradient,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Color(0xff101828),
              borderRadius: BorderRadius.circular(14),
            ),
              // Profile Card with API data
              child: ProfileCard(
                managerModel: widget.managerModel,
                managerInfo: managerInfo,
                creatorsList: creators,
              ),
          ),
          ),
              const SizedBox(height: 20),

              // Action Tiles
              ActionTile(title: "View Assigned Creators", iconPath: 'assets/user.svg', onTap: (){
                Navigator.push(context, MaterialPageRoute(
                  builder: (_) => ViewAssignCreatorsScreen(
                    role: UiUserRole.admin,
                    managerModel: widget.managerModel,
                  ),
                ),
                );
              }),
              const SizedBox(height: 20),
              Text(
                _getCurrentMonthOverview(),
                style: TextStyle(color:Colors.white,fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10),
              CustomPichart(
                diamondValue: managerInfo?.score?.toString() ?? widget.managerModel?.diamond?.toString() ?? '0',
              ),

              const SizedBox(height: 16),
              const AiAnalysisCard(),

              const SizedBox(height: 18),
              Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: AppColors.primaryGradient,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xff101828),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Target vs Actual (Current Month)",
                            style: TextStyle(color:Colors.white,fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 10),
                          ProgressCard(
                            subtitle: managerInfo?.score?.toString() ?? widget.managerModel?.diamond?.toString() ?? '0',
                            title: "Coins",
                            percent: 1.2,
                          ),

                          const SizedBox(height: 10),

                          ProgressCard(
                            subtitle: managerInfo?.totalHour?.toString() ?? '0',
                            title: "Hours",
                            percent: 1.144,

                          ),
                        ],
                      ),
                    ),
                  )
              ),

              const SizedBox(height: 20),

              // Live Chart with API data
              LiveChart(
                monthlyData: monthlyData,
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  String _getCurrentMonthOverview() {
    final now = DateTime.now();
    final monthNames = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return '${monthNames[now.month - 1]} Overview';
  }
}
