import 'package:colour/colour.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:provider/provider.dart';
import 'package:relief_app/view/all_shifts.dart';
import 'package:relief_app/view/widgets/SideBar.dart';
import '../viewmodel/provider.dart';
import 'income.dart';
import 'overview.dart';
import 'widgets/customNav.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key, required this.title});

  final String title;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final PersistentTabController controller =
      PersistentTabController(initialIndex: 0);

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<AppProvider>(context, listen: false);
    prov.getIncomeSummary(context);
    prov.fetchUser(context);

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.white10 // Softer white shadow in dark mode
            : Colour("#00334F"),
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "lib/assets/1625_logo.png",
              width: 150,
            ),
            SizedBox(
              width: 50,
            )
          ],
        ),
      ),
      drawer: Sidebar(), // Shared drawer across tabs
      body: PersistentTabView(
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.white10 // Softer white shadow in dark mode
            : Colour("#00334F"),
        controller: controller,
        tabs: _buildTabConfigs(controller),
        screenTransitionAnimation: ScreenTransitionAnimation.none(),
        navBarBuilder: (navBarConfig) =>
            CustomNavBar(navBarConfig: navBarConfig),
      ),
    );
  }

  //bottom navigation

  List<PersistentTabConfig> _buildTabConfigs(
      PersistentTabController controller) {
    return [
      PersistentTabConfig(
        screen: const AllShifts(),
        item: ItemConfig(
          icon: const Icon(Icons.calendar_today_rounded, size: 18),
          title: "Schedule",
        ),
      ),
      PersistentTabConfig(
        screen: Income(controller: controller),
        item: ItemConfig(
          icon: const Icon(Icons.currency_pound_sharp, size: 18),
          title: "Income",
        ),
      ),
      PersistentTabConfig(
        screen: const Overview(),
        item: ItemConfig(
          icon: const Icon(Icons.bubble_chart, size: 18),
          title: "Overview",
        ),
      ),
    ];
  }
}
