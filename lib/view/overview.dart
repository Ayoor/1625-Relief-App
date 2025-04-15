import 'package:colour/colour.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:relief_app/model/userData.dart';
import 'package:relief_app/view/widgets/SideBar.dart';
import 'package:relief_app/view/widgets/animatedBarGrapgh.dart';
import 'package:relief_app/viewmodel/provider.dart';

class Overview extends StatefulWidget {
  const Overview({super.key});

  @override
  State<Overview> createState() => _OverviewState();
}

class _OverviewState extends State<Overview> {
  int remainingShiftToTarget = 0;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final provider = Provider.of<AppProvider>(context, listen: false);
      await shiftsToTarget(provider);
      provider.getDateRange();
      provider.getIncomeSummary(context);
    });
  }

  var formatter =
      NumberFormat.currency(locale: "en_UK", decimalDigits: 2, symbol: "£");
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> shiftsToTarget(AppProvider provider) async {
    ReliefUser? user = await provider.fetchUser(context);
    String userTargetString = "";
    double target = 0;
    if (user != null) {
      userTargetString = user.target.toString();
      userTargetString = userTargetString.replaceAll("£", "");
      userTargetString = userTargetString.replaceAll(",", "");
      target = double.tryParse(userTargetString) ?? 0.0;
      double currentIncome = (provider.CEHShiftIncome +
          provider.SGHShiftIncome +
          provider.woodleazeShiftIncome);
      double difference = target - currentIncome;
    if (difference <= 0) {
        setState(() {
          remainingShiftToTarget = 0;
        });
      } else {
        setState(() {

          // added one for contingency
          remainingShiftToTarget =
              (difference/98.4 + 1)
                  .round()
                  .toInt();
        });
      }
    } else {
      setState(() {
        remainingShiftToTarget = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context, listen: true);

    final List<OverviewDetails> overviewTiles = [
      OverviewDetails(
        title: "Allocated",
        value: provider.monthAlocatedShifts,
      ),
      OverviewDetails(
        title: "Completed",
        value: provider.monthCompletedShifts,
      ),
      OverviewDetails(
        title: "Uncompleted",
        value: provider.monthAlocatedShifts - provider.monthCompletedShifts,
      ),
      OverviewDetails(
        title: "Cancelled",
        value: provider.monthCancelledShifts,
      ),
      OverviewDetails(
        title: "Remaining shifts to achieve target",
        value: remainingShiftToTarget,
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
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? Theme.of(context)
              .colorScheme
              .surface // Softer white shadow in dark mode
          : Colour("#f2f5fa"),
      body: Consumer<AppProvider>(
        builder: (context, provider, child) => RefreshIndicator(
          color: Colors.blue,
          backgroundColor: Theme.of(context).colorScheme.surface,
          onRefresh: () async {
            final provider = Provider.of<AppProvider>(context, listen: false);
            await shiftsToTarget(provider);
            provider.getDateRange();
            provider.getIncomeSummary(context);

          },
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  const Text(
                    "Summary",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  Center(
                      child: Text(
                        "Completed shifts by month",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.pinkAccent.shade700),
                      )),
                  const SizedBox(height: 30),
                  SizedBox(
                      height: MediaQuery.of(context).size.height / 3,
                      child: AnimatedBarGraph(
                        yValues: yValues,
                        labels: xLables,
                        maxY: 35,
                      )),
                  SizedBox(
                    height: 10,
                  ),

                  Divider(color: Colors.grey.shade500),
                  SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: Text(
                      "Shift metrics from ${provider.getDateRange()}",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.pinkAccent.shade700),
                    ),

                  ),
                  SizedBox(
                    height: 10,
                  ),
                  for (int index = 0; index < overviewTiles.length; index++)
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadiusDirectional.circular(5),
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Theme.of(context).colorScheme.surface
                            : Colour("#f2f5fa"),
                      ),

                      child: Container(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Theme.of(context)
                                .colorScheme
                                .surface // Dark mode background
                            : Colors.transparent, // Light mode background
                        child: ListTile(
                          title: Text(overviewTiles[index].title),
                          trailing: Text(index == overviewTiles.length - 1
                              ? "${overviewTiles[index].value}"
                              : "${overviewTiles[index].value}"),
                        ),
                      ),
                    ),
                  SizedBox(height: 70),

                ],
              ),
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
