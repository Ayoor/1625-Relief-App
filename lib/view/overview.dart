import 'package:colour/colour.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:relief_app/view/widgets/animatedBarGrapgh.dart';
import 'package:relief_app/viewmodel/provider.dart';

class Overview extends StatefulWidget {
  const Overview({super.key});

  @override
  State<Overview> createState() => _OverviewState();
}

class _OverviewState extends State<Overview> {@override
void initState() {
  super.initState();

  WidgetsBinding.instance.addPostFrameCallback((_) {
    final provider = Provider.of<AppProvider>(context, listen: false);
    getDateRange();
    provider.overviewData(
      context,
      monthStart!,
      monthEnd!,
    );
  });
}

  DateTime? monthStart;
  DateTime? monthEnd;

  void getDateRange() {
    DateTime now = DateTime.now();

    if (now.day <= 10) {
      // If the date is on or before the 10th of the current month
      monthStart =
          DateTime(now.year, now.month - 1, 11); // 11th of the previous month
      monthEnd = DateTime(now.year, now.month, 10); // 10th of the current month
    } else {
      // If the date is after the 10th of the current month
      monthStart =
          DateTime(now.year, now.month, 11); // 11th of the current month
      monthEnd =
          DateTime(now.year, now.month + 1, 10); // 10th of the next month
    }
  }
  var formatter = NumberFormat.currency(locale: "en_UK", decimalDigits: 2, symbol: "£");
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context, listen: true);


    final List<OverviewDetails> overviewTiles = [
      OverviewDetails(
        title: "Completed",
        value: provider.monthCompletedShifts,
      ),
      OverviewDetails(
        title: "Allocated",
        value: provider.monthAlocatedShifts,
      ),
      OverviewDetails(
        title: "Cancelled",
        value: provider.monthCancelledShifts,
      ),
      OverviewDetails(
        title: "Remaining shifts to achieve target",
        value: 11,
      ),
      OverviewDetails(
        title: "Total amount earned",
        value: formatter.format(provider.totalIncomeforTheMonth),
      ),
    ];

    List<double> yValues = [
      provider.compJan,
      provider.compFeb,
      provider.compMar,
      provider.compApr,
      provider.compMay,
      provider.compJun,
      provider.compJul,
      provider.compAug,
      provider.compSep,
      provider.compOct,
      provider.compNov,
      provider.compDec,
    ];
    List<String> xLables = [
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

    return Scaffold(
      backgroundColor: Colour("#f2f5fa"),
      appBar: AppBar(
        title: const Text('Overview'),
      ),
      body: Consumer(builder: (context, provider, child) => SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Summary",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 30),
                SizedBox(
                    height: MediaQuery.of(context).size.height / 3,
                    child: AnimatedBarGraph(
                      yValues: yValues,
                      labels: xLables,
                      maxY: 35,
                    )),
                const SizedBox(height: 10),
                Center(
                    child: Text(
                  "Completed shifts per month",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                )),
                SizedBox(
                  height: 30,
                ),
                Text(
                  "Your metrics this month",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                for (int index = 0; index < overviewTiles.length; index++)
                  Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadiusDirectional.circular(5),
                        color: Colors.white,
                      ),
                      margin: EdgeInsets.only(
                          bottom: index == overviewTiles.length - 1 ? 80 : 10),
                      child: ListTile(
                          title: Text(overviewTiles[index].title),
                          trailing: Text(index == overviewTiles.length - 1
                              ? "${overviewTiles[index].value}"
                              : "${overviewTiles[index].value}")))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class OverviewDetails {
  final String title;
  final dynamic value;

  const OverviewDetails({required this.title, required this.value});
}
