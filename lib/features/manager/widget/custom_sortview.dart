import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:top_talent_agency/core/roles.dart';
import 'package:top_talent_agency/features/manager/screen/manager_details_screen.dart';
import 'package:top_talent_agency/features/manager/screen/view_assign_creator_screen.dart';
import 'package:top_talent_agency/features/admin/data/manager_dashboard_model.dart';
import 'package:top_talent_agency/features/manager/data/manager_model.dart';

import '../../../common/custom_color.dart';

class CustomSortview extends StatelessWidget {
  final ManagerInfo? managerInfo;

  const CustomSortview({super.key, this.managerInfo});

  @override
  Widget build(BuildContext context) {
    // Use backend data if available, otherwise use defaults
    final String username = managerInfo?.name ?? 'Sarah Johnson';
    final String email = managerInfo?.email ?? 'sarah@example.com';
    final String profileImage = managerInfo?.profileImage ?? '';
    final int myCreators = managerInfo?.myCreatorsValue ?? 120;
    final int rank = managerInfo?.score ?? 1;
    final int atRisk = managerInfo?.atRisk ?? 48;
    final int excellent = managerInfo?.excellentValue ?? 72;
    
    // Create ManagerModel for navigation
    final managerModel = managerInfo != null ? ManagerModel.fromManagerInfo(managerInfo!.toJson()) : null;
    return Container(
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
          height: 214,
          width: 382,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Color(0xff101828),
            borderRadius: BorderRadius.circular(10),
          ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ManagerDetailsScreen(
                    managerModel: managerModel,
                  ),
                ),
              );
            },
            child: Row(
              children: [
                ClipOval(
                  child: profileImage.isNotEmpty
                      ? Image.network(
                          profileImage,
                          width: 48,
                          height: 48,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 48,
                              height: 48,
                              color: Colors.grey[600],
                              child: Icon(Icons.person, color: Colors.white),
                            );
                          },
                        )
                      : Container(
                          width: 48,
                          height: 48,
                          color: Colors.grey[600],
                          child: Icon(Icons.person, color: Colors.white),
                        ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        username,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      const Icon(
                        Icons.chevron_right,
                        color: Colors.white,
                        size: 28,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {},
                  child: Container(
                    height: 56,
                    decoration: BoxDecoration(
                    color: Color(0xff002370),
                    borderRadius: BorderRadius.circular(8),),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          myCreators.toString(),
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'My Creators',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color.fromRGBO(255, 255, 255, 0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 8),

              Expanded(
                child: Container(
                  height: 56,
                  decoration: BoxDecoration(
                  color: Color(0xff003612),
                  borderRadius: BorderRadius.circular(8),),

                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        excellent.toString(),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Excellent',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(width: 8),

              Expanded(
                child: Container(
                  height: 56,
                  decoration: BoxDecoration(
                  color: Color(0xff3F002B),
                  borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        atRisk.toString(),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'At Risk',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ViewAssignCreatorsScreen(
                    role: UiUserRole.admin,
                    managerModel: managerModel,
                  ),
                ),
              );
            },
            child: Container(
              height: 40,
              width: 349,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Color(0xff0F0F0F),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/user.svg',
                    width: 17,
                    height: 17,
                    color: Colors.white,
                    fit: BoxFit.cover,
                  ),
                  const Text(
                    'View Assigned Creators',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right,
                    color: Colors.white,
                    size: 18,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),

          ],
        ),
      ),
    );
  }
}
