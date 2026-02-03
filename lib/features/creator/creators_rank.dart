import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:top_talent_agency/features/manager/widget/custom_rankcoin.dart';
import 'package:top_talent_agency/features/manager/data/single_creator_model.dart';
import 'package:top_talent_agency/app/urls.dart';
import 'package:top_talent_agency/core/services/token_storage_service.dart';
import '../../../common/custom_color.dart';
import '../../core/roles.dart';

class CreatorsRank extends StatefulWidget {
  final UiUserRole role;
  const CreatorsRank({super.key, required this.role});

  @override
  State<CreatorsRank> createState() => _CreatorsRankState();
}

class _CreatorsRankState extends State<CreatorsRank> {
  List<SingleCreatorModel> allCreators = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCreators();
  }

  Future<void> _fetchCreators() async {
    print('=== CREATORS RANK: FETCHING CREATORS ===');
    try {
      final token = await TokenStorageService.getStoredToken();
      final dio = Dio();
      
      final response = await dio.get(
        Urls.Creator_Dashboard_Score,
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
        
        // Sort creators by diamonds in descending order
        creatorList.sort((a, b) {
          final aDiamonds = a.totalDiamond ?? 0;
          final bDiamonds = b.totalDiamond ?? 0;
          return bDiamonds.compareTo(aDiamonds);
        });
        
        if (mounted) {
          setState(() {
            allCreators = creatorList;
            isLoading = false;
          });
          print('✅ Creators loaded from API:');
          for (int i = 0; i < allCreators.length; i++) {
            print('   ${i + 1}. ${allCreators[i].username}: ${allCreators[i].totalDiamond} diamonds');
          }
        }
      } else {
        if (mounted) {
          setState(() {
            isLoading = false;
          });
          print('❌ No creator data available');
        }
      }
    } catch (e) {
      print('💥 Error fetching creators: $e');
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
    print('=== CREATORS RANK: FETCH COMPLETE ===');
  }

  @override
  Widget build(BuildContext context) {
    final double sw = MediaQuery
        .of(context)
        .size
        .width;
    final double imageSize = sw * 0.18;
    final double rankFont = sw * 0.1;

    if (widget.role == UiUserRole.admin || widget.role == UiUserRole.manager) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: isLoading
            ? const Center(child: CircularProgressIndicator(color: Colors.white))
            : SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 25),
                    // Top 3 Creators
                    if (allCreators.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: sw * 0.08),
                        child: Row(
                          children: [
                            // 1st Creator
                            Expanded(
                              child: Column(
                                children: [
                                  Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: allCreators.isNotEmpty
                                            ? Image.network(
                                                'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=200',
                                                width: imageSize,
                                                height: imageSize,
                                                fit: BoxFit.cover,
                                              )
                                            : Container(),
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
                                    allCreators.isNotEmpty ? (allCreators[0].username ?? 'Unknown Creator') : 'Sophie Kihm',
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
                            // 2nd and 3rd creators similar...
                          ],
                        ),
                      ),
                    const SizedBox(height: 30),
                    // Creator List
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
                        height: 520,
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: isLoading
                            ? const Center(child: CircularProgressIndicator(color: Colors.white))
                            : SingleChildScrollView(
                                child: Column(
                                  children: [
                                    const SizedBox(height: 10),
                                    // Show all creators from API
                                    if (allCreators.isNotEmpty)
                                      ...allCreators.toList().asMap().entries.map((entry) {
                                        final index = entry.key;
                                        final creator = entry.value;
                                        final actualRank = index + 1;
                                        print('🏆 Creator Rank $actualRank: ${creator.username} with ${creator.totalDiamond ?? 0} diamonds');
                                        return Column(
                                          children: [
                                            CustomRankcoin(
                                              rank: '$actualRank',
                                              name: creator.username ?? 'Unknown Creator',
                                              hours: '${creator.totalHour ?? 0}h',
                                              Diamond: '${creator.totalDiamond ?? 0}'
                                            ),
                                            const SizedBox(height: 20),
                                          ],
                                        );
                                      }).toList()
                                    else
                                      Column(
                                        children: [
                                          Text(
                                            'No creator data available',
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
    //  ONLY THIS else IS ADDED
    else {
      return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.black,
          title: const Text(
            "Your rank",
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
                    // Top 3 Creators
                    if (allCreators.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: sw * 0.08),
                        child: Row(
                          children: [
                            // 1st Creator
                            Expanded(
                              child: Column(
                                children: [
                                  Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: allCreators.isNotEmpty
                                            ? Image.network(
                                                'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=200',
                                                width: imageSize,
                                                height: imageSize,
                                                fit: BoxFit.cover,
                                              )
                                            : Container(),
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
                                    allCreators.isNotEmpty ? (allCreators[0].username ?? 'Unknown Creator') : 'Sophie Kihm',
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
                            // 2nd and 3rd creators similar...
                          ],
                        ),
                      ),
                    const SizedBox(height: 30),
                    // Creator List
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
                        height: 520,
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
                              // Show all creators from API
                              if (allCreators.isNotEmpty)
                                ...allCreators.toList().asMap().entries.map((entry) {
                                  final index = entry.key;
                                  final creator = entry.value;
                                  final actualRank = index + 1;
                                  print('🏆 Creator Rank $actualRank: ${creator.username} with ${creator.totalDiamond ?? 0} diamonds');
                                  return Column(
                                    children: [
                                      CustomRankcoin(
                                        rank: '$actualRank',
                                        name: creator.username ?? 'Unknown Creator',
                                        hours: '${creator.totalHour ?? 0}h',
                                        Diamond: '${creator.totalDiamond ?? 0}'
                                      ),
                                      const SizedBox(height: 20),
                                    ],
                                  );
                                }).toList()
                              else
                                Column(
                                  children: [
                                    Text(
                                      'No creator data available',
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
}
