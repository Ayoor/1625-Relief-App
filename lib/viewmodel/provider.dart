import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:toastification/toastification.dart';
import 'package:tuple/tuple.dart';

import '../model/shiftData.dart';
import '../model/shifts.dart';

class AppProvider extends ChangeNotifier {
  DateTime _today = DateTime.now();
  Map<String, Shifts> newShift = {};
  List <List<Shifts>> allShifts = [];

  // List<Shifts> _addedShifts = [];
  List<Shifts> shifts = [];

  DateTime get today => _today;
  final List<Shifts> _scheduledShifts = ShiftsData().scheduledShifts;

  final List<Shifts> _cancelledShifts = ShiftsData().cancelledShifts;

  List<Shifts> get cancelledShifts => _cancelledShifts;

  final List<Shifts> _completedShifts = ShiftsData().completedShifts;

  List<Shifts> get completedShifts => _completedShifts;

  final String _status = "Scheduled";

  String get status => _status;

  List<Shifts> get scheduledShifts => _scheduledShifts;

  void removeShift(int index, BuildContext context) {
    shifts.removeAt(index);
    showMessage(
        context: context,
        message: "Shift Removed",
        type: ToastificationType.info,
        bgColor: Colors.blue,
        icon: Icons.info);
    notifyListeners();
  }

  void updateShiftStatus(int index, String key, BuildContext context, {String shiftType = ""}) async {
    try {
      // Update the status of the shift locally
      // shifts[index].status = "Cancelled";

      // Reference to the specific shift in the Firebase Database
      final DatabaseReference dbRef =
          FirebaseDatabase.instance.ref().child("Shifts/$key");

      // Update only the status field in Firebase
      if(shiftType == "Completed") {
        await dbRef.update({"status": "Completed"});
      }
      else {
        await dbRef.update({"status": "Cancelled"});
      }

      // Notify listeners to update UI
      notifyListeners();

      // Show success message if the context is still mounted
      if (context.mounted) {
        showMessage(
          context: context,
          message: "Shift status updated successfully.",
          type: ToastificationType.success,
          bgColor: Colors.lightGreen,
          icon: Icons.check,
        );
        fetchShifts(context);
        notifyListeners();
      }
    } catch (e) {
      // Show error message if the update fails
      if (context.mounted) {
        showMessage(
          context: context,
          message: "Action failed. Check internet or retry later.",
          type: ToastificationType.error,
          bgColor: Colors.red[400]!,
          icon: Icons.clear,
        );
      }
    }
  }

  void showMessage(
      {required BuildContext context,
      required String message,
      required ToastificationType type,
      required Color bgColor,
      required IconData icon}) {
    toastification.show(
      context: context,
      title: Text(message),
      alignment: Alignment.bottomCenter,
      type: type,
      backgroundColor: bgColor,
      foregroundColor: Colors.white,
      icon: Icon(
        icon,
        color: Colors.white,
      ),
      style: ToastificationStyle.flatColored,
      autoCloseDuration: const Duration(seconds: 3),
      showProgressBar: false,
      dragToClose: true,
    );
  }

  void addShift(
      DateTime start, DateTime end, String location, BuildContext context) {
    // Check if there's already a shift with the same start time
    bool isDuplicate = shifts.any((shift) => shift.startTime == start);

    if (isDuplicate) {
      // If duplicate, show a toast notification
      showMessage(
          context: context,
          message: "Shift already exists for this date",
          type: ToastificationType.warning,
          bgColor: Colors.orange,
          icon: Icons.warning);
    } else {
      // If not a duplicate, add the shift
      shifts.add(Shifts(
          startTime: start,
          endTime: end,
          location: location,
          shiftType: getShiftTypeAndRate(start, location).item1,
          rate: getShiftTypeAndRate(start, location).item2,
          duration: duration(context, start, end),
          status: status));
      notifyListeners();

      showMessage(
          context: context,
          message: "New shift added",
          type: ToastificationType.info,
          bgColor: Colors.blueAccent,
          icon: Icons.info_outline);
    }
  }

  Future  fetchShifts(
      BuildContext context) async {
    final DatabaseReference dbRef = FirebaseDatabase.instance.ref();

    try {
      final DataSnapshot snapshot = await dbRef.child('Shifts').get();

      if (snapshot.exists) {
        // Print snapshot for debugging

        // Check if the value is a Map
        if (snapshot.value is Map<dynamic, dynamic>) {
          final Map<dynamic, dynamic> dateMap =
              snapshot.value as Map<dynamic, dynamic>;
          _completedShifts.clear();
          _scheduledShifts.clear();
          _cancelledShifts.clear();

          dateMap.forEach((dateKey, shiftData) {
              if (shiftData['status'] == 'Scheduled') {
                try {
                  Shifts shift = Shifts(
                    startTime: DateTime.parse(shiftData['startTime']),
                    endTime: DateTime.parse(shiftData['endTime']),
                    location: shiftData['location'],
                    shiftType: shiftData['shiftType'],
                    rate: shiftData['rate'].toDouble(),
                    duration: shiftData['duration'],
                    status: shiftData['status'],
                  );

                  _scheduledShifts.add(shift);
                } catch (e) {
                  print("Error parsing shift data for date $dateKey: $e");
                }
              }

              if (shiftData['status'] == 'Cancelled') {
                try {
                  Shifts shift = Shifts(
                    startTime: DateTime.parse(shiftData['startTime']),
                    endTime: DateTime.parse(shiftData['endTime']),
                    location: shiftData['location'],
                    shiftType: shiftData['shiftType'],
                    rate: shiftData['rate'].toDouble(),
                    duration: shiftData['duration'],
                    status: shiftData['status'],
                  );
                  _cancelledShifts.add(shift);
                } catch (e) {
                  print("Error parsing shift data for date $dateKey: $e");
                }
              }

              if (shiftData['status'] == 'Completed') {
                try {
                  Shifts shift = Shifts(
                    startTime: DateTime.parse(shiftData['startTime']),
                    endTime: DateTime.parse(shiftData['endTime']),
                    location: shiftData['location'],
                    shiftType: shiftData['shiftType'],
                    rate: shiftData['rate'].toDouble(),
                    duration: shiftData['duration'],
                    status: shiftData['status'],
                  );
                  _completedShifts.add(shift);
                }
                catch (e) {
                  print("Error parsing shift data for date $dateKey: $e");
                }
              }

          });

          allShifts.add(_scheduledShifts);
          allShifts.add(_completedShifts);
          allShifts.add(_cancelledShifts);

          notifyListeners();
        } else {
          print("Data is not a Map. Unable to iterate.");
        }

        notifyListeners();
      } else {
        print("No shifts data found.");
        notifyListeners();
        return [];
      }
    } catch (e) {
      if (context.mounted) {
        showMessage(
          context: context,
          message: "An error occurred retrieving shifts",
          type: ToastificationType.error,
          bgColor: Colors.red[400]!,
          icon: Icons.clear,
        );
      }
      print("Error retrieving shifts: $e");
      notifyListeners();
      return [];
    }
  }

  DateTime convertToDateTime(String date) {
    DateFormat format = DateFormat("dd/MM/yyyy h:mm a");
    return format.parse(date);
  }

  void onDaySelect(DateTime day, DateTime focusedDate) {
    _today = day;
    notifyListeners();
  }

// Function to add new shift and save it to Firebase Realtime Database// For date formatting

  Future<void> saveNewShifts(
    BuildContext context,
    List<Shifts> shifts,
  ) async {
    if (shifts.isEmpty) {
      showMessage(
        context: context,
        message: "You need to add new shifts first",
        type: ToastificationType.warning,
        bgColor: Colors.red,
        icon: Icons.cancel,
      );
      return;
    }

    try {
      for (var shift in shifts) {
        // Format the startTime to a date string (e.g., "dd-MM-yyyy")
        final String dateKey = DateFormat('dd-MM-yyyy').format(shift.startTime);

        final DatabaseReference dbRef =
            FirebaseDatabase.instance.ref().child("Shifts/$dateKey");

        // Save each shift under the date key in "Shifts"
        await dbRef.set(shift.toJson());
      }

      shifts.clear();
      notifyListeners();

      if (context.mounted) {
        showMessage(
          context: context,
          message: "Your shifts have been successfully saved.",
          type: ToastificationType.success,
          bgColor: Colors.lightGreen,
          icon: Icons.check,
        );
      }
    } catch (e) {
      // Show error notification if saving shifts fails
      if (context.mounted) {
        showMessage(
          context: context,
          message: "Action failed. Check internet or retry later",
          type: ToastificationType.error,
          bgColor: Colors.red[400]!,
          icon: Icons.clear,
        );
      }
    }
  }

  Tuple2<String, double> getShiftTypeAndRate(
      DateTime startTime, String location) {
    // DateTime startTime = DateTime.parse(start);
    if (startTime.hour < 12) {
      return Tuple2("Early Shift", 12);
    } else if (startTime.hour < 21) {
      return Tuple2("Late Shift", 12);
    } else {
      if (location == "Charles England House") {
        return Tuple2("Sleep in Shift", 12);
      }
      return Tuple2("Wake in Shift", 12.3);
    }
  }

  String dateFormater(DateTime? datetime) {
    if (datetime != null) {
      // Define the date format
      String formattedDate = DateFormat('dd/MM/yyyy hh:mm a').format(datetime);
      return formattedDate;
    } else {
      return "Choose";
    }
  }

  duration(BuildContext context, DateTime start, DateTime end) {
    Duration duration = end.difference(start);
    if ((duration.inHours > 16)) {
      showMessage(
          context: context,
          message: "Shift cannot be more than 16 hrs in a day",
          type: ToastificationType.warning,
          bgColor: Colors.orange,
          icon: Icons.cancel);
      return;
    }
    if (duration.inMinutes.remainder(60) == 0) {
      return "${duration.inHours} hours";
    }
    if (duration.inMinutes.remainder(60) == 1) {
      return "${duration.inHours} hours, ${duration.inMinutes.remainder(60)} minute";
    }
    return "${duration.inHours} hours, ${duration.inMinutes.remainder(60)} minutes";
  }

// Shifts getSelectedDayShift(DateTime selectedDate){
//      return _addedShifts[selectedDate];
// }
}
