import 'package:colour/colour.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:relief_app/viewmodel/provider.dart';

class StripedTable extends StatefulWidget {
  const StripedTable({super.key});

  @override
  State<StripedTable> createState() => _StripedTableState();
}

class _StripedTableState extends State<StripedTable> {
  @override
  void initState() {
    Provider.of<AppProvider>(context, listen: false)
        .getIncomeSummary(context);
    // TODO: implement initState
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    return  Consumer<AppProvider>(builder: (context, provider, child) => Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey), // Apply the border to the container
              borderRadius: BorderRadius.circular(20), // Rounded corners
            ),
            child: ClipRRect( // to enforce the border radius
              borderRadius: BorderRadius.circular(20),
              child: Table(
                columnWidths: const {
                  0: FlexColumnWidth(1), // Project column (wider)
                  1: FlexColumnWidth(1), // Total Hours column
                  2: FlexColumnWidth(1), // Income column
                },
                children: [
                  // Table Header
                  TableRow(
                    decoration: BoxDecoration(
                      // color: Colors.blue.shade100, // Header row background color
                      color: Colour("#00334F"), // Header row background color
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Project",
                          style: TextStyle( color: Colors.white,fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,

                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Total Hours",
                          style: TextStyle( color: Colors.white,fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Income",
                          style: TextStyle( color: Colors.white,fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                  // Table Body (Striped Rows)
                  incomeTable(hrs: (provider.CEHShiftHrs), income: provider.CEHShiftIncome, isOdd: true, projectName: "CEH"),
                  incomeTable(hrs: provider.SGHShiftHrs, income: provider.SGHShiftIncome, projectName: "SGH"),
                  incomeTable(hrs: provider.woodleazeShiftHrs, income: provider.woodleazeShiftIncome, isOdd: true, projectName: "Woodleaze"),
                  incomeTable(hrs: sum(provider.CEHShiftHrs, provider.SGHShiftHrs, provider.woodleazeShiftHrs), income: sum(provider.CEHShiftIncome, provider.SGHShiftIncome, provider.woodleazeShiftIncome), projectName: "Total", isLast: true),
                ],
              ),
            ),
          )
      ),
    );
  }
double sum(ceh,sgh,woodlease){
    return ceh + sgh + woodlease;

}
  TableRow incomeTable(
      {required String projectName, required double hrs, required double income, bool isOdd= false, bool isLast= false}) {
      var formatter = NumberFormat.currency(locale: "en_UK", decimalDigits: 2, symbol: "£");
    return TableRow(
              decoration: BoxDecoration(
                color: isOdd ? Colors.grey.shade200 : Colors.white),
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    style: TextStyle(
                      fontWeight: isLast? FontWeight.bold : FontWeight.normal
                    ),
                    projectName,
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    style: TextStyle(
                      fontWeight: isLast? FontWeight.bold : FontWeight.normal
                  ),
                    "$hrs",
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    style: TextStyle(
                        fontWeight: isLast? FontWeight.bold : FontWeight.normal
                    ),
                    formatter.format(income),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            );
  }
}
