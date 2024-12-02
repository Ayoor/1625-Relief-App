import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:relief_app/view/widgets/history_table.dart';
import '../viewmodel/provider.dart';

class History extends StatefulWidget {
  const History({super.key});



  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> with SingleTickerProviderStateMixin {


  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {

    return Consumer<AppProvider>(
      builder: (context, provider, child) {
      return RefreshIndicator(
          backgroundColor: Colors.white,
          color: Colors.blue,
          onRefresh: () async {
            provider.shiftHistory(context);
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            // Ensure scrolling even when content is short
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Text(
                    "Income History"
                ),
                const SizedBox(height: 20),
                Center(
                  child: Text("Bar Chart"),
                ),
                const SizedBox(height: 50),
                Text(
                  "Income per month",
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height:10),
                Padding(
                  padding: const EdgeInsets.only(bottom: 40.0),
                  child: HistoryTable(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }


  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
