import 'package:colour/colour.dart';
import 'package:flutter/material.dart';

class StripedTable extends StatelessWidget {
  const StripedTable({super.key});

  @override
  Widget build(BuildContext context) {
    return  Padding(
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
                0: FlexColumnWidth(2), // Project column (wider)
                1: FlexColumnWidth(1), // Total Hours column
                2: FlexColumnWidth(1), // Income column
              },
              children: [
                // Table Header
                TableRow(
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100, // Header row background color
                  ),
                  children: const [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Project",
                        style: TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Total Hours",
                        style: TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Income",
                        style: TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
                // Table Body (Striped Rows)
                incomeTable(hrs: 40, income: 500, isOdd: true, projectName: "CEH"),
                incomeTable(hrs: 40, income: 500, projectName: "SGH"),
                incomeTable(hrs: 40, income: 500, isOdd: true, projectName: "Woodleaze"),
                incomeTable(hrs: 40, income: 500, projectName: "Total", isLast: true),
              ],
            ),
          ),
        )
    );
  }

  TableRow incomeTable(
      {required String projectName, required int hrs, required double income, bool isOdd= false, bool isLast= false}) {
    return TableRow(
              decoration: BoxDecoration(
                color: isLast
                    ? Colors.amberAccent // Specific color for the last row
                    : (isOdd ? Colors.grey.shade200 : Colors.white),
              ),
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    projectName,
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "$hrs",
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "£$income",
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            );
  }
}
