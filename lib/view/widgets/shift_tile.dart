import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:relief_app/viewmodel/provider.dart';

import '../../model/shifts.dart';

class ShiftTile extends StatefulWidget {
  final AppProvider provider;
  final String shiftType;

  const ShiftTile({super.key, required this.provider, required this.shiftType});

  @override
  State<ShiftTile> createState() => _ShiftTileState();
}

class _ShiftTileState extends State<ShiftTile> {

    @override
  void initState() {
    super.initState();
  }

  String formatDate(String dateTimeString) {
    // Parse the input string to a DateTime object
    DateTime dateTime = DateTime.parse(dateTimeString);

    // Format the date as dd-MM-yyyy
    String formattedDate =
        '${dateTime.day.toString().padLeft(2, '0')}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.year}';

    return formattedDate;
  }

  @override
  Widget build(BuildContext context) {
    Widget shiftTile = Placeholder();

    //Scheduled
    if (widget.shiftType == "Scheduled") {

      // Group shifts by month
      Map<String, List<Shifts>> groupedShifts = {};

      for (var shift in widget.provider.scheduledShifts) {
        String monthYear = DateFormat("MMMM yyyy").format(shift.startTime); // e.g., "January 2025"

        if (!groupedShifts.containsKey(monthYear)) {
          groupedShifts[monthYear] = []; // If the month isn't in the map, create an empty list
        }
        groupedShifts[monthYear]!.add(shift);
      }

      shiftTile = RefreshIndicator(
        color: Colors.blue,
        backgroundColor: Colors.white,
        onRefresh: () async {
          widget.provider.loadData(context);
        },
        child: ListView.builder(
          itemCount: groupedShifts.length,
          itemBuilder: (context, groupIndex) {
            String monthYear = groupedShifts.keys.elementAt(groupIndex);
            List<Shifts> shifts = groupedShifts[monthYear]!;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Month Header
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  child: Text(
                    monthYear,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),

                // Shifts for this month
                ...shifts.map((shift) => Consumer<AppProvider>(
                  builder: (context, provider, child) => InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onLongPress: () {
                      canceDeleteShift(shifts.indexOf(shift), shift, "Scheduled");
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ListTile(
                          leading: Image.asset(
                            "lib/assets/1625_logo.png",
                            width: 50,
                          ),
                          title: Text(
                            shift.shiftType,
                            style: const TextStyle(color: Colors.grey, fontSize: 13),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  const Text("Start time:",
                                      style: TextStyle(fontWeight: FontWeight.bold)),
                                  Text(" ${widget.provider.dateFormater(shift.startTime)}"),
                                ],
                              ),
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  const Text("End time:",
                                      style: TextStyle(fontWeight: FontWeight.bold)),
                                  Text(" ${widget.provider.dateFormater(shift.endTime)}"),
                                ],
                              ),
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  const Text("Location:",
                                      style: TextStyle(fontWeight: FontWeight.bold)),
                                  Text(" ${shift.location}"),
                                ],
                              ),
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  const Text("Hrs: ",
                                      style: TextStyle(fontWeight: FontWeight.bold)),
                                  Text(shift.durationText),
                                ],
                              ),
                              const SizedBox(height: 5),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const Text("Rate:",
                                          style: TextStyle(fontWeight: FontWeight.bold)),
                                      Text("${shift.rate}"),
                                    ],
                                  ),
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Checkbox(
                                        value: provider.checkboxes()[shifts.indexOf(shift)],
                                        onChanged: (value) {
                                          setState(() {
                                            widget.provider.updateShiftStatus(
                                              shifts.indexOf(shift),
                                              formatDate(shift.startTime.toString()),
                                              context,
                                              shiftType: "Completed",
                                              endTime: shift.endTime.toString(),
                                            );
                                          });
                                        },
                                      ),
                                      const Text("Mark Completed",
                                          style: TextStyle(color: Colors.grey, fontSize: 12)),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 30),
                            ],
                          ),
                          contentPadding: const EdgeInsets.all(10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          tileColor: Colors.white,
                          selectedTileColor: Colors.grey[100],
                        ),
                      ),
                    ),
                  ),
                ))
                    .toList(),
              ],
            );
          },
        ),
      );
    }


//Cancelled

    if (widget.shiftType == "Cancelled") {
      // Group shifts by month
      Map<String, List<Shifts>> groupedShifts = {};

      for (var shift in widget.provider.cancelledShifts) {
        String monthYear = DateFormat("MMMM yyyy").format(shift.startTime); // e.g., "January 2025"

        if (!groupedShifts.containsKey(monthYear)) {
          groupedShifts[monthYear] = [];
        }
        groupedShifts[monthYear]!.add(shift);
      }

      shiftTile = RefreshIndicator(
        color: Colors.blue,
        backgroundColor: Colors.white,
        onRefresh: () async {
          widget.provider.loadData(context);
        },
        child: ListView.builder(
          itemCount: groupedShifts.length,
          itemBuilder: (context, groupIndex) {
            String monthYear = groupedShifts.keys.elementAt(groupIndex);
            List<Shifts> shifts = groupedShifts[monthYear]!;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Month Header
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  child: Text(
                    monthYear,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),

                // Shifts for this month
                ...shifts.map((shift) => InkWell(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onLongPress: () {
                    canceDeleteShift(shifts.indexOf(shift), shift, "Cancelled");
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ListTile(
                        leading: Image.asset(
                          "lib/assets/1625_logo.png",
                          width: 50,
                        ),
                        title: Text(
                          shift.shiftType,
                          style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 13,
                              decoration: TextDecoration.lineThrough),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Text("Start time:",
                                    style: TextStyle(fontWeight: FontWeight.bold)),
                                Text(" ${widget.provider.dateFormater(shift.startTime)},",
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 13,
                                        decoration: TextDecoration.lineThrough)),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                const Text("End time:",
                                    style: TextStyle(fontWeight: FontWeight.bold)),
                                Text(" ${widget.provider.dateFormater(shift.endTime)}",
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 13,
                                        decoration: TextDecoration.lineThrough)),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                const Text("Location:",
                                    style: TextStyle(fontWeight: FontWeight.bold)),
                                Text(" ${shift.location}",
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 13,
                                        decoration: TextDecoration.lineThrough)),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                const Text("Hrs:",
                                    style: TextStyle(fontWeight: FontWeight.bold)),
                                Text(shift.durationText,
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 13,
                                        decoration: TextDecoration.lineThrough)),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Text("Rate:",
                                        style: TextStyle(fontWeight: FontWeight.bold)),
                                    Text("${shift.rate}",
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 13,
                                            decoration: TextDecoration.lineThrough)),
                                  ],
                                ),
                                const Text("Cancelled",
                                    style: TextStyle(color: Colors.grey)),
                              ],
                            ),
                            const SizedBox(height: 30),
                          ],
                        ),
                        contentPadding: const EdgeInsets.all(10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        tileColor: Colors.white,
                        selectedTileColor: Colors.grey[100],
                      ),
                    ),
                  ),
                ))
                    .toList(),
              ],
            );
          },
        ),
      );
    }

//Completed
    if (widget.shiftType == "Completed") {
      widget.provider.loadData(context);

      // Group shifts by month
      Map<String, List<Shifts>> groupedShifts = {};

      for (var shift in widget.provider.completedShifts) {
        String monthYear = DateFormat("MMMM yyyy").format(shift.startTime); // e.g., "January 2025"

        if (!groupedShifts.containsKey(monthYear)) {
          groupedShifts[monthYear] = [];
        }
        groupedShifts[monthYear]!.add(shift);
      }

      shiftTile = RefreshIndicator(
        color: Colors.blue,
        backgroundColor: Colors.white,
        onRefresh: () async {
          widget.provider.loadData(context);
        },
        child: ListView.builder(
          itemCount: groupedShifts.length,
          itemBuilder: (context, groupIndex) {
            String monthYear = groupedShifts.keys.elementAt(groupIndex);
            List<Shifts> shifts = groupedShifts[monthYear]!;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Month Header
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  child: Text(
                    monthYear,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),

                // Shifts for this month
                ...shifts.map((shift) => InkWell(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onLongPress: () {
                    canceDeleteShift(shifts.indexOf(shift), shift, "Completed");
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ListTile(
                        leading: Image.asset(
                          "lib/assets/1625_logo.png",
                          width: 50,
                        ),
                        title: Text(
                          shift.shiftType,
                          style: const TextStyle(color: Colors.grey, fontSize: 13),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Text("Start time:",
                                    style: TextStyle(fontWeight: FontWeight.bold)),
                                Text(" ${widget.provider.dateFormater(shift.startTime)}"),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                const Text("End time:",
                                    style: TextStyle(fontWeight: FontWeight.bold)),
                                Text(" ${widget.provider.dateFormater(shift.endTime)}"),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                const Text("Location:",
                                    style: TextStyle(fontWeight: FontWeight.bold)),
                                Text(" ${shift.location}"),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                const Text("Hrs:",
                                    style: TextStyle(fontWeight: FontWeight.bold)),
                                Text(shift.durationText),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Text("Rate:",
                                        style: TextStyle(fontWeight: FontWeight.bold)),
                                    Text("${shift.rate}"),
                                  ],
                                ),
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.check,
                                      color: Colors.green,
                                    ),
                                    const Text("Completed",
                                        style: TextStyle(color: Colors.grey, fontSize: 12)),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 30),
                          ],
                        ),
                        contentPadding: const EdgeInsets.all(10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        tileColor: Colors.white,
                        selectedTileColor: Colors.grey[100],
                      ),
                    ),
                  ),
                ))
                    .toList(),
              ],
            );
          },
        ),
      );
    }

    return shiftTile;
  }
  void canceDeleteShift(int index, Shifts shift, String shiftType) {
    showMaterialModalBottomSheet(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0), // Adjust the radius for desired curvature
      ),
      context: context,
      builder: (bottomSheetContext) => Padding(
          padding: const EdgeInsets.all(10),
          child: SizedBox(
            height: MediaQuery.of(context).size.height / 6,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  if(shiftType!= "Completed")
                  //delete
                  InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text(
                                "Irreversible Action"),
                            content: Text(
                                "Are you sure you want to Delete this shift?"),
                            actions: [
                              InkWell(
                                onTap: () {
                                  Navigator.pop(bottomSheetContext);
                                  Navigator.pop(context);
                                },
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                child: SizedBox(
                                    width: 50,
                                    child: Center(
                                        child: Text(
                                          "No",
                                          style: TextStyle(
                                              fontSize: 18),
                                        ))),
                              ),
                              InkWell(
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () {
                                  widget.provider
                                      .updateShiftStatus(
                                      index,
                                      formatDate(shift
                                          .startTime
                                          .toString()),
                                      context, shiftType: "Deleted");
                                  Navigator.pop(bottomSheetContext);
                                  Navigator.pop(context);
                                },
                                enableFeedback: false,
                                child: Text("Yes",
                                    style: TextStyle(
                                        fontSize: 18,
                                        color:
                                        Colors.pink)),
                              ),
                            ],
                          ));


                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.delete,
                          color: Colors.pink,
                        ),
                        Padding(
                          padding:
                          const EdgeInsets.only(left: 8.0),
                          child: Text(
                            "Delete",
                            style: TextStyle(
                                fontSize: 18, color: Colors.pink),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20,),

                  //Cancel shift
                  if(shiftType !="Cancelled" && shiftType != "Completed")
                  InkWell(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text(
                                "Confirm Shift Cancel"),
                            content: Text(
                                "Are you sure you want to cancel this shift?"),
                            actions: [
                              InkWell(
                                onTap: () {
                                  Navigator.pop(bottomSheetContext);
                                  Navigator.pop(context);
                                },
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                child: SizedBox(
                                    width: 50,
                                    child: Center(
                                        child: Text(
                                          "No",
                                          style: TextStyle(
                                              fontSize: 18),
                                        ))),
                              ),
                              InkWell(
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () {
                                  widget.provider
                                      .updateShiftStatus(
                                      index,
                                      formatDate(shift
                                          .startTime
                                          .toString()),
                                      context, shiftType: "Cancelled");
                                  Navigator.pop(bottomSheetContext);
                                  Navigator.pop(context);
                                },
                                enableFeedback: false,
                                child: Text("Yes",
                                    style: TextStyle(
                                        fontSize: 18,
                                        color:
                                        Colors.pink)),
                              ),
                            ],
                          ));
                    },

                    //cancel
                    child: Row(
                      children: [
                        Icon(Icons.close,
                            color: Colors.red[300]),
                        Padding(
                          padding:
                          const EdgeInsets.only(left: 8.0),
                          child: Text(
                            "Cancel",
                            style: TextStyle(
                                fontSize: 18, color: Colors.pink),
                          ),
                        )
                      ],
                    ),
                  ),

                  //revert
                  if(shiftType == "Completed")
                    InkWell(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text(
                                  "Revert Shift Complete"),
                              content: Text(
                                  "Are you sure you want to revert completed shift?"),
                              actions: [
                                InkWell(
                                  onTap: () {
                                    Navigator.pop(bottomSheetContext);
                                    Navigator.pop(context);
                                  },
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  child: SizedBox(
                                      width: 50,
                                      child: Center(
                                          child: Text(
                                            "No",
                                            style: TextStyle(
                                                fontSize: 18),
                                          ))),
                                ),
                                InkWell(
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () {
                                    widget.provider
                                        .updateShiftStatus(
                                        index,
                                        formatDate(shift
                                            .startTime
                                            .toString()),
                                        context, shiftType: "Revert");
                                    Navigator.pop(bottomSheetContext);
                                    Navigator.pop(context);
                                  },
                                  enableFeedback: false,
                                  child: Text("Yes",
                                      style: TextStyle(
                                          fontSize: 18)),
                                ),
                              ],
                            ));
                      },

                      //cancel
                      child: Row(
                        children: [
                          Icon(Icons.turn_left,
                              color: Colors.black),
                          Padding(
                            padding:
                            const EdgeInsets.only(left: 8.0),
                            child: Text(
                              "Revert",
                              style: TextStyle(
                                  fontSize: 18, color: Colors.black),
                            ),
                          )
                        ],
                      ),
                    )

                ],
              ),
            ),
          )),
    );
  }
}
