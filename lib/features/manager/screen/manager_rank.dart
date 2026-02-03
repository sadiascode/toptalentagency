import 'package:flutter/material.dart';
import 'package:top_talent_agency/features/manager/widget/custom_rankcoin.dart';
import 'package:top_talent_agency/features/admin/services/manager_dashboard_service.dart';
import 'package:top_talent_agency/features/admin/data/manager_dashboard_model.dart';

import '../../../common/custom_color.dart';

class ManagerRank extends StatefulWidget {
  const ManagerRank({super.key});

  @override
  State<ManagerRank> createState() => _ManagerRankState();
}

class _ManagerRankState extends State<ManagerRank> {
  List<ManagerInfo> allManagers = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchManagers();
  }

  Future<void> _fetchManagers() async {
    print('=== MANAGER RANK: FETCHING MANAGERS ===');
    try {
      final dashboard = await ManagerDashboardService.fetchManagerDashboard();
      if (dashboard != null && dashboard.managers.isNotEmpty) {
        // Sort managers by diamonds/score in descending order
        final sortedManagers = List<ManagerInfo>.from(dashboard.managers);
        print('🔍 Before sorting:');
        for (int i = 0; i < sortedManagers.length; i++) {
          print('   ${i + 1}. ${sortedManagers[i].name}: ${sortedManagers[i].score ?? 0} diamonds');
        }
        
        sortedManagers.sort((a, b) {
          final aDiamonds = a.score ?? 0;
          final bDiamonds = b.score ?? 0;
          return bDiamonds.compareTo(aDiamonds);
        });
        
        print('🔍 After sorting:');
        for (int i = 0; i < sortedManagers.length; i++) {
          print('   ${i + 1}. ${sortedManagers[i].name}: ${sortedManagers[i].score ?? 0} diamonds');
        }
        
        if (mounted) {
          setState(() {
            allManagers = sortedManagers;
            isLoading = false;
          });
          print('✅ Managers loaded from API:');
          for (int i = 0; i < allManagers.length; i++) {
            print('   ${i + 1}. ${allManagers[i].name}: ${allManagers[i].score} diamonds');
          }
        }
      } else {
        if (mounted) {
          setState(() {
            isLoading = false;
          });
          print('❌ No manager data available');
        }
      }
    } catch (e) {
      print('💥 Error fetching managers: $e');
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
    print('=== MANAGER RANK: FETCH COMPLETE ===');
  }

  @override
  Widget build(BuildContext context) {
    final double sw = MediaQuery.of(context).size.width;
    final double imageSize = sw * 0.18;
    final double rankFont = sw * 0.1;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.black,
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: ( Icon(Icons.arrow_back_ios, color: Colors.white, size: 18))),
        title: const Text(
          "Rank of managers",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 25),

                  // Top 3 Managers
                  if (allManagers.isNotEmpty)
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: sw * 0.08),
                      child: Row(
                        children: [
                          // 1st Manager
                          Expanded(
                            child: Column(
                              children: [
                                Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: allManagers.isNotEmpty && allManagers[0].profileImage != null && allManagers[0].profileImage!.isNotEmpty
                                          ? Image.network(
                                              allManagers[0].profileImage!,
                                              width: imageSize,
                                              height: imageSize,
                                              fit: BoxFit.cover,
                                              errorBuilder: (context, error, stackTrace) {
                                                return Container(
                                                  width: imageSize,
                                                  height: imageSize,
                                                  color: Colors.grey[600],
                                                  child: const Icon(Icons.person, color: Colors.white),
                                                );
                                              },
                                            )
                                          :  Icon(
                                        Icons.person,
                                        size: 66,
                                        color: Colors.grey[600],)
                                    ),
                                    Positioned(
                                      top: -rankFont * 0.6,
                                      right: -rankFont * 0.2,
                                      child: Text(
                                        '1',
                                        style: TextStyle(
                                          fontSize: rankFont,
                                          fontWeight: FontWeight.bold,
                                          color: const Color(0xff679929),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  allManagers.isNotEmpty ? (allManagers[0].name ?? 'Unknown Manager') : 'Sophie Kihm',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: sw * 0.04,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // 2nd Manager
                          Expanded(
                            child: Column(
                              children: [
                                Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: allManagers.length > 1 && allManagers[1].profileImage != null && allManagers[1].profileImage!.isNotEmpty
                                          ? Image.network(
                                              allManagers[1].profileImage!,
                                              width: imageSize,
                                              height: imageSize,
                                              fit: BoxFit.cover,
                                              errorBuilder: (context, error, stackTrace) {
                                                return Container(
                                                  width: imageSize,
                                                  height: imageSize,
                                                  color: Colors.grey[600],
                                                  child: const Icon(Icons.person, color: Colors.white),
                                                );
                                              },
                                            )
                                          : Icon(
                                        Icons.person,
                                        size: 66,
                                        color: Colors.grey[600],)
                                    ),
                                    Positioned(
                                      top: -rankFont * 0.6,
                                      right: -rankFont * 0.2,
                                      child: Text(
                                        '2',
                                        style: TextStyle(
                                          fontSize: rankFont,
                                          fontWeight: FontWeight.bold,
                                          color: const Color(0xffD08700),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  allManagers.length > 1 ? (allManagers[1].name ?? 'Unknown Manager') : 'Lisa Anderson',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: sw * 0.04,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // 3rd Manager
                          Expanded(
                            child: Column(
                              children: [
                                Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: allManagers.length > 2 && allManagers[2].profileImage != null && allManagers[2].profileImage!.isNotEmpty
                                          ? Image.network(
                                              allManagers[2].profileImage!,
                                              width: imageSize,
                                              height: imageSize,
                                              fit: BoxFit.cover,
                                              errorBuilder: (context, error, stackTrace) {
                                                return Container(
                                                  width: imageSize,
                                                  height: imageSize,
                                                  color: Colors.grey[600],
                                                  child: const Icon(Icons.person, color: Colors.white),
                                                );
                                              },
                                            )
                                          : Icon(
                                          Icons.person,
                                        size: 66,
                                        color: Colors.grey[600],)
                                    ),
                                    Positioned(
                                      top: -rankFont * 0.6,
                                      right: -rankFont * 0.2,
                                      child: Text(
                                        '3',
                                        style: TextStyle(
                                          fontSize: rankFont,
                                          fontWeight: FontWeight.bold,
                                          color: const Color(0xffA65E2E),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  allManagers.length > 2 ? (allManagers[2].name ?? 'Unknown Manager') : 'Van Dijk',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: sw * 0.04,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                  const SizedBox(height: 30),
                  
                  // Manager List (4th onwards) - Only show CustomRankcoin with API data
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.all(1.5),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: AppColors.primaryGradient,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Container(
                      height: 500,
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            const SizedBox(height: 10),
                            // Show all managers from API in CustomRankcoin (starting from 4th)
                            if (allManagers.length > 3)
                              ...allManagers.skip(3).toList().asMap().entries.map((entry) {
                                final index = entry.key;
                                final manager = entry.value;
                                final actualRank = index + 4; // Start from 4th position
                                print('🏆 Rank $actualRank: ${manager.name} with ${manager.score ?? 0} diamonds');
                                return Column(
                                  children: [
                                    CustomRankcoin(
                                      rank: '$actualRank', 
                                      name: manager.name ?? 'Unknown Manager',
                                      hours: '${manager.myCreatorsValue ?? 0} creators',
                                      Diamond: '${manager.score ?? 0}'
                                    ),
                                    const SizedBox(height: 20),
                                  ],
                                );
                              }).toList()
                            else
                              // Show API data from start if less than 4 managers
                              if (allManagers.isNotEmpty)
                                ...allManagers.toList().asMap().entries.map((entry) {
                                  final index = entry.key;
                                  final manager = entry.value;
                                  final actualRank = index + 1;
                                  print('🏆 Rank $actualRank: ${manager.name} with ${manager.score ?? 0} diamonds');
                                  return Column(
                                    children: [
                                      CustomRankcoin(
                                        rank: '$actualRank', 
                                        name: manager.name ?? 'Unknown Manager',
                                        hours: '${manager.myCreatorsValue ?? 0} creators',
                                        Diamond: '${manager.score ?? 0}'
                                      ),
                                      const SizedBox(height: 20),
                                    ],
                                  );
                                }).toList()
                              else
                                Column(
                                  children: [
                                    Text(
                                      'No manager data available',
                                      style: TextStyle(color: Colors.white, fontSize: 16),
                                    ),
                                  ],
                                ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
