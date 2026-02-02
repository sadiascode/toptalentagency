import 'package:flutter/material.dart';
import 'package:top_talent_agency/features/manager/data/manager_model.dart';
import 'package:top_talent_agency/features/admin/data/manager_dashboard_model.dart';
import 'package:top_talent_agency/features/manager/data/single_creator_model.dart';

class ProfileCard extends StatelessWidget {
  final ManagerModel? managerModel;
  final ManagerInfo? managerInfo;
  final SingleCreatorModel? creatorInfo;
  final List<SingleCreatorModel>? creatorsList;

  const ProfileCard({
    super.key,
    this.managerModel,
    this.managerInfo,
    this.creatorInfo,
    this.creatorsList,
  });

  @override
  Widget build(BuildContext context) {
    // Prioritize creatorInfo (creator data) over managerInfo (manager data) over managerModel (static data)
    final displayName = creatorInfo?.username ?? managerInfo?.name ?? managerModel?.username ?? 'name ';
    final displayImage = managerInfo?.profileImage ?? managerModel?.profileImage; // Creator doesn't have profileImage field
    final displayCreators = creatorsList?.length ?? managerInfo?.myCreatorsValue ?? managerModel?.myCreators ?? 0;
    final displayDiamonds = creatorInfo?.totalDiamond ?? managerInfo?.score ?? managerModel?.diamond ?? 0;
    
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: displayImage != null && displayImage.isNotEmpty
              ? Image.network(
                  displayImage,
                  height: 52,
                  width: 52,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 52,
                      width: 52,
                      color: Colors.grey[600],
                      child: Icon(Icons.person, color: Colors.white),
                    );
                  },
                )
              : Container(
                  height: 52,
                  width: 52,
                  color: Colors.grey[600],
                  child: Icon(Icons.person, color: Colors.white),
                ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                displayName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              // Show creators count only for managers, not for creators
              if (creatorInfo == null) ...[
                Text(
                  '$displayCreators creators',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 12,
                  ),
                ),
              ],
              const SizedBox(height: 2),
              Text(
                '$displayDiamonds diamonds',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
