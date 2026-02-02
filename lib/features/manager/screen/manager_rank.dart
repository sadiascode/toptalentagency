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
        sortedManagers.sort((a, b) {
          final aDiamonds = a.score ?? 0;
          final bDiamonds = b.score ?? 0;
          return bDiamonds.compareTo(aDiamonds);
        });
        
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
                                          : Image.network(
                                              'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=200',
                                              width: imageSize,
                                              height: imageSize,
                                              fit: BoxFit.cover,
                                            ),
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
                                  allManagers.isNotEmpty ? allManagers[0].name : 'Sophie Kihm',
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
                                          : Image.network(
                                              'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=200',
                                              width: imageSize,
                                              height: imageSize,
                                              fit: BoxFit.cover,
                                            ),
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
                                  allManagers.length > 1 ? allManagers[1].name : 'Lisa Anderson',
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
                                          : Image.network(
                                              'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=200',
                                              width: imageSize,
                                              height: imageSize,
                                              fit: BoxFit.cover,
                                            ),
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
                                  allManagers.length > 2 ? allManagers[2].name : 'Van Dijk',
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
                                return Column(
                                  children: [
                                    CustomRankcoin(
                                      rank: '$actualRank', 
                                      name: manager.name,
                                      hours: '${manager.myCreatorsValue} creators',
                                      Diamond: '${manager.score ?? 0}'
                                    ),
                                    const SizedBox(height: 20),
                                  ],
                                );
                              }).toList()
                            else if (allManagers.isNotEmpty)
                              // If less than 4 managers, show remaining from start
                              ...allManagers.toList().asMap().entries.map((entry) {
                                final index = entry.key;
                                final manager = entry.value;
                                final actualRank = index + 1;
                                return Column(
                                  children: [
                                    CustomRankcoin(
                                      rank: '$actualRank', 
                                      name: manager.name,
                                      hours: '${manager.myCreatorsValue} creators',
                                      Diamond: '${manager.score ?? 0}'
                                    ),
                                    const SizedBox(height: 20),
                                  ],
                                );
                              }).toList()
                            else
                              // Fallback static data if no API data
                              Column(
                                children: [
                                  CustomRankcoin(
                                      rank: '4', name: "Sarah Johnson",
                                      hours: '5.6h', Diamond: '1,743'
                                  ),
                                  const SizedBox(height: 20),
                                  CustomRankcoin(
                                      rank: '5', name: "Sarah Johnson",
                                      hours: '5.6h', Diamond: '1,743'
                                  ),
                                  const SizedBox(height: 20),
                                  CustomRankcoin(
                                      rank: '6', name: "Sarah Johnson",
                                      hours: '5.6h', Diamond: '1,743'
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
