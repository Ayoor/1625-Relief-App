import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:relief_app/model/shifts.dart';
import 'package:relief_app/view/widgets/adding_new_shift.dart';
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
  Map<DateTime, List<Shifts>> shifts = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    // Provider.of<AppProvider>(context, listen: false)
    //     .loadDrinkHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, child) => Scaffold(
        floatingActionButton: SizedBox(
          width: 150,
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => NewShift()));
            },
            backgroundColor: Colors.orange,
            child: Text(
              "New Shift",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
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
                            child: TableCalendar(
                                headerStyle: HeaderStyle(
                                    formatButtonVisible: false,
                                    titleCentered: true),
                                focusedDay: provider.today,
                                selectedDayPredicate: (day) =>
                                    isSameDay(day, provider.today),
                                onDaySelected: provider.onDaySelect,
                                availableGestures: AvailableGestures.all,
                                firstDay:
                                    provider.today.subtract(Duration(days: 60)),
                                lastDay:
                                    provider.today.add(Duration(days: 50)))),
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
      ),
    );
  }
}
