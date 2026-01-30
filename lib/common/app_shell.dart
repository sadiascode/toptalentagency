import 'package:flutter/material.dart';
import 'package:top_talent_agency/common/navBar/bottom_tab_item.dart';
import 'package:top_talent_agency/common/navBar/bottom_tabs.dart';
import 'package:top_talent_agency/common/navBar/custom_bottom_navbar.dart';
import 'package:top_talent_agency/core/roles.dart';
import 'package:top_talent_agency/features/alert/screen/alerts_screen.dart';
import 'package:top_talent_agency/features/creator/creators_rank.dart';
import 'package:top_talent_agency/features/manager/screen/view_assign_creator_screen.dart';
import 'package:top_talent_agency/features/more/screen/more_screen.dart';

import '../features/home/ui/screen/home_screen.dart';
import '../features/target/ui/screen/target_screen.dart';


class AppShell extends StatefulWidget {
  final UiUserRole role;

  const AppShell({super.key, required this.role});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int index = 0;

  late final List<GlobalKey<NavigatorState>> _navigatorKeys;

  List<BottomTabItem> get visibleTabs {
    return bottomTabs.where((tab) {
      if (widget.role == UiUserRole.admin) return tab.admin;
      if (widget.role == UiUserRole.manager) return tab.manager;
      if (widget.role == UiUserRole.creator) return tab.creator;
      return false;
    }).map((tab) {
      // Center tab
      if (tab.isCenter) {
        return BottomTabItem(
          label: tab.label,
          icon: tab.icon,
          isCenter: true,
          page: HomeScreen(role: widget.role),
        );
      }

      // Targets tab
      if (tab.label == "Targets") {
        return BottomTabItem(
          label: tab.label,
          icon: tab.icon,
          page: TargetsScreen(role: widget.role),
        );
      }

      // Creators tab
      if (tab.label == "Creators") {
        return BottomTabItem(
          label: tab.label,
          icon: tab.icon,
          page: ViewAssignCreatorsScreen(role: widget.role),
        );
      }

      // Alerts tab
      if (tab.label == "Alerts") {
        return BottomTabItem(
          label: tab.label,
          icon: tab.icon,
          page: AlertsScreen(role: widget.role),
        );
      }

      // Rank tab
      if (tab.label == "Rank") {
        return BottomTabItem(
          label: tab.label,
          icon: tab.icon,
          page: CreatorsRank(role: widget.role),
        );
      }
      if (tab.label == "More") {
        return BottomTabItem(
          label: tab.label,
          icon: tab.icon,
          page: MoreScreen(role: widget.role),
        );
      }

      return tab;
    }).toList();
  }


  @override
  void initState() {
    super.initState();
    final tabs = visibleTabs;
    _navigatorKeys = List.generate(tabs.length, (_) => GlobalKey<NavigatorState>());
    final centerIndex = tabs.indexWhere((tab) => tab.isCenter);
    index = centerIndex >= 0 ? centerIndex : 0;
  }

  @override
  Widget build(BuildContext context) {
    final tabs = visibleTabs;

    // Safety check
    if (index >= tabs.length) index = 0;

    return Scaffold(
      body: IndexedStack(
        index: index,
        children: List.generate(tabs.length, (i) {
          return Navigator(
            key: _navigatorKeys[i],
            onGenerateRoute: (_) => MaterialPageRoute(builder: (_) => tabs[i].page),
          );
        }),
      ),
      bottomNavigationBar: CustomBottomNav(
        tabs: tabs,
        currentIndex: index,
        onTap: (i) {
          if (i == index) {
            _navigatorKeys[i].currentState?.popUntil((route) => route.isFirst);
          } else {
            setState(() => index = i);
          }
        },
      ),
    );
  }
}
