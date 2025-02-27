import 'package:colour/colour.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:relief_app/utils/dateformat.dart';
import 'package:relief_app/viewmodel/provider.dart';

import '../../model/shifts.dart';

class TimesheetTable extends StatefulWidget {
  const TimesheetTable({super.key});

  @override
  State<TimesheetTable> createState() => _TimesheetTableState();
}

class _TimesheetTableState extends State<TimesheetTable> {

  @override
  Widget build(BuildContext context) {

    return  Consumer<AppProvider>(builder: (context, provider, child) => Padding(
        padding: const EdgeInsets.all(8.0),
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
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.blue.shade100 // Softer white shadow in dark mode
                        : Colour("#00334F") ,// Header row background color
                  ),
                  children:  [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(

                        "Date",
                        style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).brightness == Brightness.dark
                            ? Theme.of(context).colorScheme.surface:
                              Colors.white,),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Start Time",
                        style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).brightness == Brightness.dark
                            ? Theme.of(context).colorScheme.surface:
                        Colors.white,),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "End Time",
                        style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).brightness == Brightness.dark
                            ? Theme.of(context).colorScheme.surface:
                        Colors.white,),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Hours",
                        style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).brightness == Brightness.dark
                            ? Theme.of(context).colorScheme.surface:
                        Colors.white,),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
                // Table Body (Striped Rows)
            for (Shifts completedShift in provider.filteredShifts)
      timeSheetBody(
    hours: "${completedShift.duration}",
      date: ReadableDate(dateTime: completedShift.startTime).date(),
      start: ReadableDate(dateTime: completedShift.startTime).time(),
      end: ReadableDate(dateTime: completedShift.endTime).time(),
      completedShifts: provider.filteredShifts, // Adjust parameter name if necessary
      isOdd: provider.filteredShifts.indexOf(completedShift) % 2 == 1, // Dynamically check odd rows
      isLast: completedShift == provider.filteredShifts.last, // Check if it's the last shift
    ),
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
  TableRow timeSheetBody(
      {required List<Shifts> completedShifts,required String date, required String start, required String end, required String hours, required bool isLast, required bool isOdd}) {

        return TableRow(
        decoration: BoxDecoration(
        //   color: isLast
        //       ? Colors.amberAccent.shade200 // Specific color for the last row
        //       : (isOdd ? Colors.grey.shade200 : Colors.white),
        // ),
          color: isOdd
              ? Theme.of(context)
              .colorScheme
              .surfaceContainerHighest // Light grey in light mode, darker in dark mode
              : Theme.of(context).colorScheme.surface,),
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              date,
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              start,
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              end,
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              hours,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      );
    }
  }
