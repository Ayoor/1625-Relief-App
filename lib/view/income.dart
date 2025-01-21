import 'package:colour/colour.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:provider/provider.dart';
import 'package:relief_app/view/history.dart';
import 'package:relief_app/view/timesheet.dart';
import 'package:relief_app/view/widgets/SideBar.dart';
import 'package:relief_app/view/widgets/income_pie_chart.dart';
import 'package:relief_app/view/widgets/striped_table.dart';
import '../viewmodel/provider.dart';

class Income extends StatefulWidget {
 PersistentTabController controller;

  Income({super.key, required this.controller});

  @override
  State<Income> createState() => _IncomeState();
}

class _IncomeState extends State<Income> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);


  }

  @override

  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, child) => Scaffold(
               appBar: AppBar(

          backgroundColor: Colour("#00334F"),

          title: TabBar(
            indicatorColor: Colors.orange,
            controller: _tabController,
            tabs: const [
              Tab(child: Text("Income", style: TextStyle(color: Colors.white))),
              Tab(
                  child:
                      Text("History", style: TextStyle(color: Colors.white))),
              Tab(
                  child:
                      Text("Timesheet", style: TextStyle(color: Colors.white))),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: TabBarView(
            controller: _tabController,
            children: [
              // Tab 1 - Income
              RefreshIndicator(
                backgroundColor: Colors.white,
                color: Colors.blue,
                onRefresh: () async {
                  provider.getIncomeSummary(context);
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  // Ensure scrolling even when content is short
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      Text(
                        "Income from ${provider.getDateRange()}",
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: IncomePieChart(
                          CEH: provider.CEHShiftIncome,
                          SGH: provider.SGHShiftIncome,
                          woodleaze: provider.woodleazeShiftIncome,
                          total: provider.CEHShiftIncome +
                              provider.SGHShiftIncome +
                              provider.woodleazeShiftIncome,
                        ),
                      ),
                      const SizedBox(height: 50),
                      Text(
                        "Income Breakdown",
                        style: TextStyle(
                        color: Colors.blueGrey,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      StripedTable(),
                      Text("Your total expected income based on allocated shifts from ${provider.getDateRange()} is ${provider.allocatedIncomeText}" ,style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey), textAlign: TextAlign.center,)
                    ],
                  ),
                ),
              ),

              // Tab 2 - Completed Shifts
              History(),
              TimeSheet(),
            ],
          ),
        ),
      ),
    );
  }


  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
