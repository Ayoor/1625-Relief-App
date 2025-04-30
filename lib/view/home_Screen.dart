import 'package:colour/colour.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:provider/provider.dart';
import 'package:relief_app/model/userData.dart';
import 'package:relief_app/view/all_shifts.dart';
import 'package:relief_app/view/custom_widgets/SideBar.dart';
import 'package:relief_app/view/custom_widgets/internetstatuswrapper.dart';
import '../viewmodel/provider.dart';
import 'custom_widgets/customNav.dart';
import 'income.dart';
import 'overview.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.title});

  final String title;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  final PersistentTabController controller =
      PersistentTabController(initialIndex: 0);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final prov = Provider.of<AppProvider>(context, listen: false);
      prov.getIncomeSummary(context);
      prov.fetchUser(context);
      prov.scheduleMonthlyTimeSheetNotification();



    });
  }

  @override
  Widget build(BuildContext context) {
    return InternetStatusWrapper(
      child: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Theme.of(context).brightness == Brightness.dark
              ? Colors.white10 // Softer white shadow in dark mode
              : Colour("#00334F"),
          centerTitle: true,
          title: Column(
            children: [
              Row(
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
              SizedBox(
                height: 2,
              )
            ],
          ),
        ),
        drawer: Sidebar(
                ), // Shared drawer across tabs
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
