import 'package:colour/colour.dart';
import 'package:flutter/material.dart';
import 'package:gauge_chart/gauge_chart.dart';
import 'package:provider/provider.dart';
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
              SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    GaugeChart(
                      centerText: ["\nHello"],
                      children: [
                        PieData(
                          value: 4,
                          color: Colors.blue.shade300,
                          description: "Planned",
                        ),
                        PieData(
                          value: 10,
                          color: Colors.orange,
                          description: "Taken",
                        ),
                        PieData(
                          value: 14,
                          color: Colour("#FFB703"),
                          description: "To plan",
                        ),
                      ],
                      gap: 1,
                      animateDuration: const Duration(seconds: 4),
                      start: 180,
                      displayIndex: 1,
                      shouldAnimate: true,
                      animateFromEnd: false,
                      isHalfChart: false,
                      size: 200,
                      showValue: false,
                      borderWidth: 15,
                    ),
                  ],
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
