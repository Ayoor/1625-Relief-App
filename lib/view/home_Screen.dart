import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:relief_app/view/all_shifts.dart';

import 'income.dart';
import 'overview.dart';
import 'widgets/customNav.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {

    return PersistentTabView(
      tabs: [
        PersistentTabConfig(
          screen: const AllShifts(),
          item: ItemConfig(
            icon: const Icon(Icons.calendar_today_rounded, size: 18,),
            title: "Schedule",
          ),
        ),
        PersistentTabConfig(
          screen: const Income(),
          item: ItemConfig(
            icon: const Icon(Icons.currency_pound_sharp, size: 18,),
            title: "Income",
          ),
        ),
        PersistentTabConfig(
          screen: const Overview(),
          item: ItemConfig(
            icon: const Icon(Icons.bubble_chart, size: 18,),
            title: "Overview",
          ),
        ),
      ],
      screenTransitionAnimation:  ScreenTransitionAnimation.none(),

      navBarBuilder: (navBarConfig) =>
          CustomNavBar(navBarConfig: navBarConfig)
    );
  }
}

