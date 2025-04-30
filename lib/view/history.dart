import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:relief_app/view/custom_widgets/animatedBarGrapgh.dart';
import 'package:relief_app/view/custom_widgets/history_table.dart';
import '../viewmodel/provider.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    // Provider.of<AppProvider>(context, listen: false).shiftHistory(context);
  }

  @override
  Widget build(BuildContext context) {
    List<String> graphLabels = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec"
    ];

    return Consumer<AppProvider>(
      builder: (context, provider, child) {
        List<double> graphData = [
          provider.SGH.Jan + provider.CEH.Jan + provider.WL.Jan,
          provider.SGH.Feb + provider.CEH.Feb + provider.WL.Feb,
          provider.SGH.Mar + provider.CEH.Mar + provider.WL.Mar,
          provider.SGH.Apr + provider.CEH.Apr + provider.WL.Apr,
          provider.SGH.May + provider.CEH.May + provider.WL.May,
          provider.SGH.Jun + provider.CEH.Jun + provider.WL.Jun,
          provider.SGH.Jul + provider.CEH.Jul + provider.WL.Jul,
          provider.SGH.Aug + provider.CEH.Aug + provider.WL.Aug,
          provider.SGH.Sep + provider.CEH.Sep + provider.WL.Sep,
          provider.SGH.Oct + provider.CEH.Oct + provider.WL.Oct,
          provider.SGH.Nov + provider.CEH.Nov + provider.WL.Nov,
          provider.SGH.Dec + provider.CEH.Dec + provider.WL.Dec,
        ];
// Loop through each month and generate the sum expression

        return RefreshIndicator(
          backgroundColor: Theme.of(context).colorScheme.onSurface,
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
                Text("Income History"),
                const SizedBox(height: 20),
                Center(
                  child: SizedBox(
                      height: MediaQuery.of(context).size.height / 3.5,
                      child: AnimatedBarGraph(
                          labels: graphLabels, yValues: graphData)),
                ),
                // const SizedBox(height: 50),
                Text(
                  "Income per month",
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
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


}
