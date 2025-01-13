import 'package:board_datetime_picker/board_datetime_picker.dart';
import 'package:colour/colour.dart';
import 'package:dropdown_flutter/custom_dropdown.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:relief_app/model/shifts.dart';
import 'package:relief_app/view/all_shifts.dart';
import 'package:relief_app/viewmodel/provider.dart';
import 'package:toastification/toastification.dart';

class NewShift extends StatefulWidget {
  const NewShift({super.key});

  @override
  State<NewShift> createState() => _NewShiftState();
}

class _NewShiftState extends State<NewShift> {
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
  DateTime? startTime;
  DateTime? endTime;
  final controller = BoardDateTimeController();


  // List <String> shiftTime(String location){
  //   List <String> timeRange=[];
  //   switch (location){
  //     case "Charles England House":
  //       timeRange= ["8am-4pm", "3pm-11pm", "10:30pm-8:15am", "Custom"];
  //     case "St. George's House":
  //       timeRange= ["7am-3pm","2pm-10pm", "9:30pm-7:30am","Custom"];
  //     case "Woodleaze":
  //       timeRange= ["7am-12pm", "7am-3pm", "1:30pm-10pm", "2:30pm-10pm", "4pm-10pm" "9:30pm-7:30am","Custom"];
  //   }
  //   return timeRange;
  // }

  String dateFormater(DateTime? datetime) {
    if (datetime != null) {
      // Define the date format
      String formattedDate = DateFormat('dd/MM/yyyy hh:mm a').format(datetime);
      return formattedDate;
    } else {
      return "Choose";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
        builder: (context, provider, child) => Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              automaticallyImplyLeading: false,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      enableFeedback: false,
                      onPressed: () {
                        reset(context, provider.shifts);
                      },
                      icon:
                          Icon(Icons.close, size: 30, color: Colors.red[400])),
                  IconButton(
                    enableFeedback: false,
                    icon: Icon(
                      Icons.check,
                      size: 30,
                      color: Colors.blue,
                    ),
                    onPressed: () {
                      provider.saveNewShifts(context, provider.shifts, startTime!, endTime!);
                    },
                  ),
                ],
              ),
            ),
            backgroundColor: Colour("#e8f3fa"),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      // Shift start time
                      const Text('Add a new Shift',
                          style:
                              TextStyle(fontSize: 22, color: Colors.black45)),
                      const SizedBox(height: 10),
//location

                      Text(
                        "Location is",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black54),
                      ),
                      SizedBox(
                        height: 5,
                      ),

                      // Location dropdown
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
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
                              offset: Offset(0, 3), // Offset of the shadow
                            ),
                          ],
                        ),
                        child: DropdownFlutter<String>(
                          decoration: CustomDropdownDecoration(
                            prefixIcon: Icon(
                              Icons.house,
                              color: Colors.grey,
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

                      //start custom time
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
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
                              offset: Offset(0, 3), // Offset of the shadow
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 15.0),
                                    child: Icon(Icons.date_range, size: 17, color: Colors.grey,),
                                  ),
                          const Text(
                            'Shift Starts at',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14),
                          )
                                ],
                              )
,
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
                          color: Colors.white,
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
                              offset: Offset(0, 3), // Offset of the shadow
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 15.0),
                                    child: Icon(Icons.date_range, size: 17, color: Colors.grey,),
                                  ),
                                  const Text(
                                    'Shift Closes at',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold, fontSize: 14),
                                  ),
                                ],
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
                            backgroundColor: Colors.white,
                            elevation: 0,
                          ),
                          onPressed: () {
                            // provider.saveNewShifts(
                            //     "Early",
                            //     DateTime.now().add(Duration(minutes: 300)),
                            //     DateTime.now().add(Duration(minutes: 600)),
                            //     "Woodleaze",
                            //     context);
                            if (startTime != null && endTime != null) {
                              provider.addShift(startTime!, endTime!,
                                  selectedLocation, context);
                            } else {
                              toastification.show(
                                context: context,
                                // optional if you use ToastificationWrapper
                                title: Text("Enter shift start/end date."),
                                alignment: Alignment.bottomCenter,
                                type: ToastificationType.error,
                                backgroundColor: Colors.red[400],
                                foregroundColor: Colors.white,
                                icon: Icon(
                                  Icons.close,
                                  color: Colors.white,
                                ),
                                style: ToastificationStyle.flatColored,
                                autoCloseDuration: const Duration(seconds: 3),
                                showProgressBar: false,
                                dragToClose: true,
                              );
                            }
                          },
                          child: Text(
                            "Add",
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      )),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Added Shifts",
                        style: TextStyle(fontSize: 17, color: Colors.blue),
                      ),
                      ListView.builder(
                        physics: ClampingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: provider.shifts.length,
                        itemBuilder: (context, index) {
                          final shift = provider.shifts[index];

                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              leading: Image.asset(
                                "lib/assets/1625_logo.png",
                                width: 50,
                              ),
                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    shift.shiftType,
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 13),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.close,
                                        color: Colors.red[300]),
                                    onPressed: () {
                                      setState(() {
                                        provider.removeShift(index, context);
                                      });
                                    },
                                  )
                                ],
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text("Start time:",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      Text(
                                        " ${dateFormater(shift.startTime)}",
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    children: [
                                      Text("End time:",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      Text(
                                        " ${dateFormater(shift.endTime)}",
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    children: [
                                      Text("Location:",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      Text(
                                        " ${shift.location}",
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    children: [
                                      Text("Hrs: ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      Text(shift.durationText),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    children: [
                                      Text("Rate: ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      Text(
                                        "${shift.rate}",
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              contentPadding: EdgeInsets.all(10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              tileColor: Colors.white,
                              selectedTileColor: Colors.grey[100],
                            ),
                          );
                        },
                      ),
                    ]),
              ),
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
                minuteInterval: 15,
                mode: CupertinoDatePickerMode.dateAndTime,
                onDateTimeChanged: (DateTime value) {
                  setState(() {
                    if (timeDetail == "end") {
                      endTime = value;
                    } else {
                      startTime = value;
                      endTime = value.add(Duration(hours: 8));
                    }
                  });
                },
                use24hFormat: false,
                showDayOfWeek: true,
                initialDateTime: minDate(timeDetail).add(Duration(minutes: 15)),
                maximumDate: DateTime.now().add(Duration(days: 40)),
                minimumDate:  minDate(timeDetail).subtract(Duration(minutes: 15)),
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

  DateTime minDate(String timeDetail) {
    if (timeDetail == "end") {
      return startTime!.add(Duration(hours: 8));
    }

    if (startTime != null) {
      return startTime!;
    } else {
      // Get the current time
      DateTime now = DateTime.now();

      // Round the minutes to the nearest 15-minute interval
      int roundedMinutes = (now.minute / 15).round() * 15;

      // Handle cases where rounding exceeds 60 minutes
      if (roundedMinutes >= 60) {
        roundedMinutes = 0;
        // now = now.add(Duration(hours: 1));
      }

      // Return the adjusted time
      return DateTime(now.year, now.month, now.day, now.hour, roundedMinutes);
    }
  }


  void reset(BuildContext context, List<Shifts> shifts) {
    if (shifts.isNotEmpty) {
      showDialog(
        context: context,
        builder: (alertContext) => AlertDialog(
          content: Text(
              "All added shifts will be deleted, do you want to continue?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fixed here
              },
              child: Text("No"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  startTime = null;
                  endTime = null;
                  shifts.clear();
                });
                Navigator.of(alertContext).pop();
                Navigator.of(context).pop();
              },
              child: Text("Yes"),
            ),
          ],
        ),
      );
    } else {
      Navigator.of(context).pop();
      // Navigator.of(context).pushReplacement(
      //   MaterialPageRoute(builder: (context) => AllShifts()),
      // );
    }
  }
}
