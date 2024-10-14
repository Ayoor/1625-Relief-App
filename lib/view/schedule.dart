import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import '../viewmodel/provider.dart';

class Schedule extends StatefulWidget {
  const Schedule({super.key});

  @override
  State<Schedule> createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    // Provider.of<AppProvider>(context, listen: false)
    //     .loadDrinkHistory();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          "Schedule",
          style: TextStyle(color: Colors.white),
        ),
        bottom: TabBar(
          indicatorColor: Colors.orange,
          indicatorSize: TabBarIndicatorSize.tab,
          controller: _tabController,
          tabs: const [
            Tab(
              child: Text("Scheduled", style: TextStyle(color: Colors.white)),
            ),
            Tab(
              child: Text("Completed", style: TextStyle(color: Colors.white)),
            ),
            Tab(
              child: Text("Cancelled", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Tab 1 - Today
          Consumer<AppProvider>(
            builder: (context, provider, child) {
              provider.loadShifts();
              if (provider.scheduledShifts.isEmpty) {
                return const Center(
                  child: Text("You don't have any shift scheduled"),
                );
              } else {
                return Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      Container(
                        child: Consumer<AppProvider>(
                            builder: (BuildContext context,
                                    AppProvider provider, Widget? child) =>
                                TableCalendar(
                                  headerStyle: HeaderStyle(formatButtonVisible: false, titleCentered: true),
                                    focusedDay: provider.today(),
                                    selectedDayPredicate:  (day) => isSameDay(day, provider.today()),
                                    onDaySelected: provider.onDaySelect,
                                    availableGestures: AvailableGestures.all,
                                    firstDay: provider.today().subtract(Duration(days: 60)),
                                    lastDay: provider.today().add(Duration(days: 50))))),
                      // ListView.builder(
                      //   itemCount: provider.scheduledShifts.length,
                      //   itemBuilder: (context, index) {
                      //     final drinkData = provider.scheduledShifts[index];
                      //     return Container(
                      //       margin: const EdgeInsets.only(bottom: 20),
                      //       decoration: BoxDecoration(
                      //         borderRadius: BorderRadius.circular(10.0),
                      //         border: Border.all(
                      //             color: Colors.blueGrey, width: 1.0),
                      //       ),
                      //       child: ListTile(
                      //         contentPadding: const EdgeInsets.all(12),
                      //         leading: Image.asset(drinkData.cupData.image),
                      //         title: Text(
                      //           "You drank ${drinkData.cupData.cupMlText} at ${drinkData.time} ",
                      //         ),
                      //       ),
                      //     );
                      //   },
                      // ),
                    ],
                  ),
                );
              }
            },
          ),

          // Tab 2 - Past Week
          const Center(
            child: Text("Completed"),
          ),

          // Tab 3 - Past Month
          const Center(
            child: Text(
              "Cancelled",
            ),
          ),
        ],
      ),
    );
  }
}
