import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:relief_app/model/shifts.dart';
import 'package:relief_app/view/adding_new_shift.dart';
import '../viewmodel/provider.dart';

class Schedule extends StatefulWidget {
  const Schedule({super.key});

  @override
  State<Schedule> createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isChecked = false;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    // Fetch scheduled shifts when the widget is first created.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AppProvider>(context, listen: false).getScheduledShifts(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, child) => Scaffold(
        floatingActionButton: SizedBox(
          width: 150,
          child: FloatingActionButton(
            onPressed: () async {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const NewShift()));
            },
            backgroundColor: Colors.orange,
            child: const Text(
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
            controller: _tabController,
            tabs: const [
              Tab(child: Text("Scheduled", style: TextStyle(color: Colors.white))),
              Tab(child: Text("Completed", style: TextStyle(color: Colors.white))),
              Tab(child: Text("Cancelled", style: TextStyle(color: Colors.white))),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: TabBarView(
            controller: _tabController,
            children: [
              // Tab 1 - Scheduled Shifts
              provider.scheduledShifts.isEmpty
                  ? const Center(child: Text("No shift Scheduled yet"))
                  : ListView.builder(
                physics: const ClampingScrollPhysics(),
                itemCount: provider.scheduledShifts.length,
                itemBuilder: (context, index) {
                  final shift = provider.scheduledShifts[index];

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      leading: Image.asset(
                        "lib/assets/1625_logo.png",
                        width: 50,
                      ),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            shift.shiftType,
                            style: const TextStyle(color: Colors.grey, fontSize: 13),
                          ),
                          Column(
                            children: [
                              IconButton(
                                icon: Icon(Icons.close, color: Colors.red[300]),
                                onPressed: () {
                                  provider.removeShift(index, context);
                                },
                              ),
                              Text("Cancel Shift", style: TextStyle(color: Colors.grey, fontSize: 12),)
                            ],
                          ),
                        ],
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Text("Start time:", style: TextStyle(fontWeight: FontWeight.bold)),
                              Text(" ${provider.dateFormater(shift.startTime)}"),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              const Text("End time:", style: TextStyle(fontWeight: FontWeight.bold)),
                              Text(" ${provider.dateFormater(shift.endTime)}"),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              const Text("Location:", style: TextStyle(fontWeight: FontWeight.bold)),
                              Text(" ${shift.location}"),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              const Text("Hrs:", style: TextStyle(fontWeight: FontWeight.bold)),
                              Text(shift.duration),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Text("Rate:", style: TextStyle(fontWeight: FontWeight.bold)),
                                  Text("${shift.rate}"),
                                ],
                              ),
                              Column(
                                children: [
                                  Checkbox(value: _isChecked, onChanged: (value){
                                    setState(() {
                                      _isChecked = value ?? false;
                                    });
                                  }),
                                Text("Mark Completed", style: TextStyle(color: Colors.grey, fontSize: 12),)],
                              )
                            ],
                          ),
                        ],
                      ),
                      contentPadding: const EdgeInsets.all(10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      tileColor: Colors.white,
                      selectedTileColor: Colors.grey[100],
                    ),
                  );
                },
              ),

              // Tab 2 - Completed Shifts
              const Center(
                child: Text("Completed"),
              ),

              // Tab 3 - Cancelled Shifts
              const Center(
                child: Text("Cancelled"),
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
