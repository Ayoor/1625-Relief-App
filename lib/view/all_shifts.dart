import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:relief_app/view/adding_new_shift.dart';
import 'package:relief_app/view/widgets/shift_tile.dart';
import '../viewmodel/provider.dart';

class AllShifts extends StatefulWidget {
  const AllShifts({super.key});

  @override
  State<AllShifts> createState() => _AllShiftsState();
}

class _AllShiftsState extends State<AllShifts>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    Provider.of<AppProvider>(context, listen: false)
        .loadData(context);
  }


  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, child) => Scaffold(
        floatingActionButton: SizedBox(
          width: 150,
          child: FloatingActionButton(
            onPressed: () async {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const NewShift()));
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
              Tab(
                  child:
                      Text("Scheduled", style: TextStyle(color: Colors.white))),
              Tab(
                  child:
                      Text("Completed", style: TextStyle(color: Colors.white))),
              Tab(
                  child:
                      Text("Cancelled", style: TextStyle(color: Colors.white))),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: TabBarView(
            controller: _tabController,
            children: [
              // Tab 1 - Scheduled Shifts
              if (!provider.isLoading)
              provider.scheduledShifts.isEmpty
                  ? const Center(child: Text("No shift Scheduled yet"))
                  : ShiftTile(
                      provider: provider,
                      shiftType: "Scheduled",
                    ),
              if(provider.isLoading)
                Column(mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height:30, width:30,child: CircularProgressIndicator(color: Colors.orange, backgroundColor: Colors.blue,)),
                    SizedBox(height: 10,),Text("Fetching shifts", style: TextStyle(fontWeight: FontWeight.bold),)
                  ],
                ),

              // Tab 2 - Completed Shifts
              provider.completedShifts.isEmpty
                  ? const Center(
                      child: Text("You have not completed any shift yet"))
                  : ShiftTile(provider: provider, shiftType: "Completed"),

              // Tab 3 - Cancelled Shifts
              provider.cancelledShifts.isEmpty
                  ? const Center(child: Text("No cancelled shift"))
                  : ShiftTile(
                      provider: provider,
                      shiftType: "Cancelled",
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
