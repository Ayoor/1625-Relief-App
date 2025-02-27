import 'package:board_datetime_picker/board_datetime_picker.dart';
import 'package:dropdown_flutter/custom_dropdown.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:relief_app/utils/saveandopenPDF.dart';
import 'package:relief_app/view/widgets/timesheet_table.dart';
import 'package:relief_app/viewmodel/provider.dart';
import 'package:toastification/toastification.dart';

import '../utils/time_sheet_exporter.dart';

class TimeSheet extends StatefulWidget {
  const TimeSheet({super.key});

  @override
  State<TimeSheet> createState() => _TimeSheetState();
}

class _TimeSheetState extends State<TimeSheet> {
  @override
  void initState() {
    super.initState();
    dateFormater(null);
  }

  TextEditingController locationController = TextEditingController();
  late int hrs;
  late double rate;

  String selectedLocation = "Charles England House";
  final List<String> locations = [
    "Charles England House",
    "St. George's House",
    "Woodleaze"
  ]; // Default location
  Map<String, String> loc = {
    "Charles England House": "CEH",
    "St. George's House": "SGH",
    "Woodleaze": "WL"
  };
  DateTime? startTime;
  DateTime? endTime;
  final controller = BoardDateTimeController();

  bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  String dateFormater(DateTime? datetime) {
    if (datetime != null) {
      // Define the date format
      String formattedDate = DateFormat('dd/MM/yyyy').format(datetime);
      return formattedDate;
    } else {
      return "Choose";
    }
  }

  String locationShort = "";
  bool showTable = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
        builder: (context, provider, child) => SingleChildScrollView(
                child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Location is",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface),
                    ),
                    SizedBox(
                      height: 5,
                    ),

                    // Location dropdown
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        // White background
                        borderRadius: BorderRadius.circular(12),
                        // Rounded corners
                        boxShadow: [
                          BoxShadow(
                            color: isDarkMode(context)
                                ? Colors.white.withOpacity(0.5)
                                : Colors.grey.withOpacity(0.5),
                            // Shadow color
                            spreadRadius: 1,
                            // Spread radius of the shadow
                            blurRadius: 1,
                            // Blur radius
                            offset: Offset(0, 1), // Offset of the shadow
                          ),
                        ],
                      ),
                      child: DropdownFlutter<String>(
                        decoration: CustomDropdownDecoration(
                          closedBorder: Border.all(
                              color: isDarkMode(context)
                                  ? Colors.grey.withOpacity(0.5)
                                  : Colors.transparent),
                          expandedFillColor:
                              Theme.of(context).colorScheme.surface,
                          closedFillColor:
                              Theme.of(context).colorScheme.surface,
                          listItemStyle: TextStyle(
                              color: isDarkMode(context)
                                  ? Colors.white.withOpacity(0.5)
                                  : Colors.grey.withOpacity(0.5)),
                          prefixIcon: Icon(
                            Icons.house,
                            color: isDarkMode(context)
                                ? Colors.white.withOpacity(0.5)
                                : Colors.grey.withOpacity(0.5),
                            size: 18,
                          ),
                        ),
                        hintText: 'Location',
                        initialItem: locations[0],
                        items: locations,
                        onChanged: (value) {
                          setState(() {
                            if (value != null) {
                              selectedLocation = value;
                            }
                          });
                        },
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    // Shift start time

                    Text(
                      "Choose time frame",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface),
                    ),
                    //start custom time
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: isDarkMode(context)
                                ? Colors.grey
                                : Colors.transparent),
                        color: Theme.of(context).colorScheme.surface,
                        // White background
                        borderRadius: BorderRadius.circular(12),
                        // Rounded corners
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            // Shadow color
                            spreadRadius: 1,
                            // Spread radius of the shadow
                            blurRadius: 1,
                            // Blur radius
                            offset: Offset(0, 1), // Offset of the shadow
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'From',
                              style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14),
                            ),
                            Row(
                              children: [
                                TextButton(
                                  onPressed: () {
                                    pickDate("start");
                                  },
                                  child: Text(
                                    dateFormater(startTime),
                                    style: TextStyle(color: Colors.blue),
                                  ),
                                ),
                                IconButton(
                                    onPressed: () {
                                      pickDate("start");
                                    },
                                    icon: Icon(
                                      Icons.chevron_right,
                                      size: 25,
                                      color: Colors.orange,
                                    ))
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),

                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        border: Border.all(
                            color: isDarkMode(context)
                                ? Colors.grey
                                : Colors.transparent),
                        // White background
                        borderRadius: BorderRadius.circular(12),
                        // Rounded corners
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            // Shadow color
                            spreadRadius: 1,
                            // Spread radius of the shadow
                            blurRadius: 1,
                            // Blur radius
                            offset: Offset(0, 1), // Offset of the shadow
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'To',
                              style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14),
                            ),
                            Row(
                              children: [
                                TextButton(
                                  onPressed: () {
                                    pickDate("end");
                                  },
                                  child: Text(dateFormater(endTime),
                                      style: TextStyle(color: Colors.blue)),
                                ),
                                IconButton(
                                    onPressed: () {
                                      pickDate("end");
                                    },
                                    icon: Icon(
                                      Icons.chevron_right,
                                      size: 25,
                                      color: Colors.orange,
                                    )),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(
                      height: 20,
                    ),
                    Center(
                        child: SizedBox(
                      width: MediaQuery.of(context).size.width / 2,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: BorderSide(color: Colors.orange)),
                          backgroundColor:
                              Theme.of(context).colorScheme.surface,
                          elevation: 0,
                        ),
                        onPressed: () {
                          if (dateFormater(endTime) != "Choose" && startTime != null && endTime != null) {

                              provider.generateTimeSheet(startTime!, endTime!,
                                  selectedLocation, context);
                              locationShort = loc[selectedLocation] ?? "";
                            } else {
Fluttertoast.showToast(msg: "Enter shift start/end date.");
                            }
                          },
                        child: Text(
                          "Generate",
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    )),
                    SizedBox(
                      height: 30,
                    ),

                    if (provider.showTable)
                      SizedBox(
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  "Your $locationShort shifts from ${dateFormater(startTime)} to ${dateFormater(endTime)}",
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    showBottomSheet();
                                  },
                                  child: Text(
                                    "Export",
                                    style: TextStyle(
                                        color: Colors.blue,
                                        fontSize: 16,
                                        decoration: TextDecoration.underline),
                                  ),
                                )
                              ],
                            ),
                            if (provider.filteredShifts.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 30.0),
                                child: TimesheetTable(),
                              ),
                          ],
                        ),
                      )
                  ]),
            )));
  }

  void pickDate(String timeDetail) {
    if (timeDetail == "end" && startTime == null) {
      Fluttertoast.showToast(
          msg: "Select Start date first", toastLength: Toast.LENGTH_SHORT);
      return;
    }
    showMaterialModalBottomSheet(
      context: context,
      builder: (context) => SizedBox(
        height: MediaQuery.of(context).size.height / 2,
        child: Column(
          children: [
            // Give the date picker a fixed height so that it doesn't push the button off the screen.
            SizedBox(
              height: MediaQuery.of(context).size.height / 3,
              // Adjust the height as needed
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.date,
                onDateTimeChanged: (DateTime value) {
                  setState(() {
                    if (timeDetail == "end") {
                      endTime = value;
                    } else {
                      startTime = value;
                      // endTime = value.add(Duration(days: 8));
                    }
                  });
                },
                dateOrder: DatePickerDateOrder.dmy,
                minimumYear: DateTime.now().year - 1,
                maximumYear: DateTime.now().year,
                use24hFormat: false,
                showDayOfWeek: false,
                initialDateTime: DateTime.now(),
                maximumDate: DateTime.now(),
                minimumDate: DateTime.now().subtract(Duration(days: 60)),
              ),
            ),
            SizedBox(height: 10),
            // Add some space between the picker and the button
            TextButton(
              onPressed: () {
                setState(() {});
                Navigator.of(context).pop(); // Close the modal
              },
              child: Text(
                "OK",
                style: TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showBottomSheet() {
    final provider = Provider.of<AppProvider>(context, listen: false);
    showMaterialModalBottomSheet(
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.white, width: 2.0),
        borderRadius: BorderRadius.circular(
            20.0), // Adjust the radius for desired curvature
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
                  //delete
                  InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () async {
                      Navigator.pop(context);
                      final file = await TimeSheetExporter(
                              name: "Ayodele Oduola",
                              range:
                                  "${dateFormater(startTime)} to ${dateFormater(endTime)}",
                              data: provider.exportData,
                              total: provider.totalHours)
                          .newCEHTimeSheet();
                      SaveandOpenPDF().sendEmailWithAttachment(file);
                      if (mounted) {
                        provider.showMessage(
                            context: context,
                            message:
                                "Your timesheet has been sent to your email",
                            type: ToastificationType.success,
                            icon: Icons.email_outlined);
                        // Navigator.pop(bottomSheetContext);
                      }
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.mail,
                          color: Colors.blueGrey,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            "Send to Email",
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),

                  //download
                  InkWell(
                    onTap: () async {
                      Navigator.pop(context);

                      final file = await TimeSheetExporter(
                              name: "Ayodele Oduola",
                              range:
                                  "${dateFormater(startTime)} to ${dateFormater(endTime)}",
                              data: provider.exportData,
                              total: provider.totalHours)
                          .newCEHTimeSheet();
                      if (mounted) {
                        provider.showMessage(
                            context: context,
                            message: "Timesheet downloaded",
                            type: ToastificationType.success,
                            icon: Icons.download_outlined);
                      }

                      Future.delayed(
                        Duration(seconds: 1),
                        () => SaveandOpenPDF().openPDF(file),
                      );
                    },

                    //cancel
                    child: Row(
                      children: [
                        Icon(Icons.download, color: Colors.blueGrey),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            "Download",
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
