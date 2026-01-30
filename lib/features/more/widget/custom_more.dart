import 'package:flutter/material.dart';

import '../../../common/custom_color.dart';

class CustomMore extends StatelessWidget {
  final IconData sectionIcon;
  final String sectionTitle;
  final List<SettingItemData> items;

  const CustomMore({
    super.key,
    required this.sectionIcon,
    required this.sectionTitle,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Row(
            children: [
              Icon(sectionIcon, size: 18, color: Colors.white),
              const SizedBox(width: 8),
              Text(
                sectionTitle,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),

        // Container
        Container(
          padding: const EdgeInsets.all(1.5), // thickness
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: AppColors.primaryGradient,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(11),
            ),
          child: Column(
            children: [
              _buildSettingItem(items[0]),
              Container(
                height: 1,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: AppColors.primaryGradient,
                  ),
                ),
              ),
              _buildSettingItem(items[1]),
              Container(
                height: 1,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: AppColors.primaryGradient,
                  ),
                ),
              ),
              _buildSettingItem(items[2]),
             ],
           ),
         ),
        ),
      ],
    );
  }

  Widget _buildSettingItem(SettingItemData item) {
    return InkWell(
      onTap: item.isSwitch ? null : item.onTap,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        item.title,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                      if (item.badge != null) ...[
                        const SizedBox(width: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Colors.grey,
                              width: 1,
                            ),
                          ),
                          child: Text(
                            item.badge!,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.subtitle,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),

            if (item.isSwitch)
              Switch(
                value: item.switchValue,
                onChanged: item.onSwitchChanged,
                activeColor: Colors.blue,
              )
            else
              const Icon(
                Icons.chevron_right,
                color: Colors.white,
                size: 23,
              ),
          ],
        ),
      ),
    );
  }
}

class SettingItemData {
  final String title;
  final String subtitle;
  final String? badge;

  final VoidCallback? onTap;

  // 🔥 switch related
  final bool isSwitch;
  final bool switchValue;
  final ValueChanged<bool>? onSwitchChanged;

  SettingItemData({
    required this.title,
    required this.subtitle,
    this.badge,
    this.onTap,
    this.isSwitch = false,
    this.switchValue = false,
    this.onSwitchChanged,
  });
}

