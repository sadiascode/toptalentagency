import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:top_talent_agency/features/manager/screen/creator_details_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:top_talent_agency/features/manager/screen/saras_rank.dart';
import 'package:top_talent_agency/core/roles.dart';
import 'package:top_talent_agency/features/manager/data/manager_model.dart';
import 'package:top_talent_agency/features/manager/data/single_creator_model.dart';
import 'package:top_talent_agency/app/urls.dart';
import 'package:top_talent_agency/core/services/token_storage_service.dart';
import '../../../common/custom_color.dart';
import '../widget/custom_search.dart';

class ViewAssignCreatorsScreen extends StatefulWidget {
  final UiUserRole role;
  final ManagerModel? managerModel;

  const ViewAssignCreatorsScreen({
    super.key,
    required this.role,
    this.managerModel,
  });

  @override
  State<ViewAssignCreatorsScreen> createState() => _ViewAssignCreatorsScreenState();
}

class _ViewAssignCreatorsScreenState extends State<ViewAssignCreatorsScreen> {
  bool isLoading = false;
  List<SingleCreatorModel> creators = [];
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    if (widget.managerModel?.id != null) {
      _fetchCreators();
    }
  }

  Future<void> _fetchCreators() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

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
          isLoading = false;
        });

        print('✅ Parsed ${creators.length} creators');
      } else {
        setState(() {
          errorMessage = 'Failed to load creators (${response.statusCode})';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error: $e';
        isLoading = false;
      });
      print('❌ Error fetching creators: $e');
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
        title: Text(
          widget.role == UiUserRole.manager
              ? "My Creators"
              : "${widget.managerModel?.username ?? 'Sarah'}'s creators",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),

        leading: widget.role == UiUserRole.manager
            ? null
            : IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
            size: 18,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomSearch(),
            const SizedBox(height: 12),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Showing ${creators.length} of ${creators.length} creators",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const SarasRank (),
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

            const SizedBox(height: 20),

            // Show creators from API
            ...creators.map((creator) {
              print('👤 Creator: ${creator.username}, Diamonds: ${creator.totalDiamond}, Hours: ${creator.totalHour}');
              return _creatorCard(
                context: context,
                name: creator.username,
                manager: creator.managerUsername,
                diamonds: creator.totalDiamond.toString(),
                hours: creator.totalHour.toString(),
                creatorId: creator.id,
              );
            }).toList(),

            // Fallback static creators if no API data
            if (creators.isEmpty) ...[
              _creatorCard(
                context: context,
                name: "djes.yt",
                manager: "Sarah Johnson",
                diamonds: "12",
                hours: "15",
                creatorId: null,
              ),
              _creatorCard(
                context: context,
                name: "sarah.h",
                manager: "Emily Rodriguez",
                diamonds: "6",
                hours: "11",
                creatorId: null,
              ),
              _creatorCard(
                context: context,
                name: "djes.yt",
                manager: "Emily Rodriguez",
                diamonds: "3",
                hours: "9",
                creatorId: null,
              ),
              _creatorCard(
                context: context,
                name: "sarah.h",
                manager: "Emily Rodriguez",
                diamonds: "34",
                hours: "11",
                creatorId: null,
              ),
              _creatorCard(
                context: context,
                name: "djes.yt",
                manager: "Emily Rodriguez",
                diamonds: "11",
                hours: "10",
                creatorId: null,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _creatorCard({
    required BuildContext context,
    required String name,
    required String manager,
    required String diamonds,
    required String hours,
    int? creatorId,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => CreatorDetailsScreen(creatorId: creatorId)),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(1),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: AppColors.primaryGradient,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.grey.shade300,
                    child: Icon(
                      Icons.person,
                      size: 28,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              name,
                              style: const TextStyle(fontWeight: FontWeight.w600,color: Colors.white),
                            ),
                            const SizedBox(width: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(

                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Manager: $manager",
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "$diamonds      $hours",
                          style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.white
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      const Icon(Icons.chevron_right, color: Colors.white),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getCreatorStatus(int rank) {
    if (rank <= 3) return "Excellent";
    if (rank <= 10) return "Good";
    return "Underperforming";
  }

  Color _getStatusTextColor(int rank) {
    if (rank <= 3) return const Color(0xff008236);
    if (rank <= 10) return const Color(0xff1447E6);
    return Colors.white;
  }

  Color _getStatusColor(int rank) {
    if (rank <= 3) return const Color(0xffDCFCE7);
    if (rank <= 10) return Colors.white;
    return const Color(0xffDC2626);
  }

  Color _getProgressColor(int rank) {
    if (rank <= 3) return const Color(0xff22C55E);
    if (rank <= 10) return const Color(0xff3B82F6);
    return const Color(0xffDC2626);
  }
}
