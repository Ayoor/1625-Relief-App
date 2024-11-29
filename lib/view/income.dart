import 'package:circular_charts/circular_charts.dart';
import 'package:colour/colour.dart';
import 'package:flutter/material.dart';
import 'package:gauge_chart/gauge_chart.dart';
import 'package:provider/provider.dart';
import 'package:relief_app/view/widgets/striped_table.dart';
import '../viewmodel/provider.dart';

class Income extends StatefulWidget {
  const Income({super.key});

  @override
  State<Income> createState() => _IncomeState();
}

class _IncomeState extends State<Income> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    // Provider.of<AppProvider>(context, listen: false)
    //     .loadData(context);
  }

  final List<PieData> pies = [
    PieData(value: 0.15, color: Colors.yellow, description: 'SGH'),
    PieData(value: 0.35, color: Colors.cyan, description: 'WL'),
    PieData(value: 0.45, color: Colors.lightGreen, description: 'CEH'),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, child) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: const Text(
            "Income",
            style: TextStyle(color: Colors.white),
          ),
          bottom: TabBar(
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
              // Tab 1 - Income1
              RefreshIndicator(
                backgroundColor: Colors.white,
                color: Colors.blue,
                onRefresh: () async {
                  provider.getIncomeSummary(context);
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(), // Ensure scrolling even when content is short
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      Text(
                        getDateRange(),
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: CircularChart(
                          animationTime: 800,
                          chartHeight: 200,
                          chartWidth: 400,
                          pieChartChildNames: [
                            "CEH",
                            "SGH",
                            "Woodleaze",
                          ],
                          pieChartEndColors: [
                            Colors.blue.shade300,
                            Colors.orange,
                            Colour("#FFB703"),
                          ],
                          pieChartStartColors: [
                            Colors.blue.shade300,
                            Colors.orange,
                            Colour("#FFB703"),
                          ],
                          centreCircleTitle: "Title",
                          pieChartPercentages: [
                            60,
                            20,
                            20,
                          ],
                          overAllPercentage: 100,
                          isShowingLegend: true,
                        ),
                      ),
                      const SizedBox(height: 50),
                      Text(
                        "Income Breakdown",
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      StripedTable(),
                    ],
                  ),
                ),
              ),

              // Tab 2 - Completed Shifts
              Center(
                child: Text("Income 2"),
              ),
              Center(
                child: Text("Income 3"),
              ),
            ],
          ),
        )
        ,
      ),
    );
  }

  String getDateRange() {
    DateTime now = DateTime.now();

    DateTime startDate;
    DateTime endDate;

    if (now.day <= 10) {
      // If the date is on or before the 10th of the current month
      startDate =
          DateTime(now.year, now.month - 1, 11); // 11th of the previous month
      endDate = DateTime(now.year, now.month, 10); // 10th of the current month
    } else {
      // If the date is after the 10th of the current month
      startDate =
          DateTime(now.year, now.month, 11); // 11th of the current month
      endDate = DateTime(now.year, now.month + 1, 10); // 10th of the next month
    }

    return "${startDate.day}/${startDate.month}/${startDate.year} - ${endDate.day}/${endDate.month}/${endDate.year}";
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
