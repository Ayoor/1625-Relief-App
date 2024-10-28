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
  final DatabaseReference _dbRef =
      FirebaseDatabase.instance.ref().child('Shifts');

  // List<Shifts> _addedShifts = [];
  List<Shifts> shifts = [];

  DateTime get today => _today;
  final List _scheduledShifts = ShiftsData().scheduledShift;

  List get scheduledShifts => _scheduledShifts;
  void removeShift(int index){
shifts.removeAt(index);
notifyListeners();
  }

  void showWarning(BuildContext context, String message) {
    toastification.show(
      context: context,
      title: Text(message),
      alignment: Alignment.bottomCenter,
      type: ToastificationType.warning,
      backgroundColor: Colors.orange,
      foregroundColor: Colors.white,
      icon: Icon(
        Icons.warning,
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
      showWarning(context, "Shift already exists for this date");
    } else {
      // If not a duplicate, add the shift
      shifts.add(Shifts(
        startTime: start,
        endTime: end,
        location: location,
        shiftType: getShiftTypeAndRate(start, location).item1,
        rate: getShiftTypeAndRate(start, location).item2,
        duration: duration(context,start, end),
      ));
      notifyListeners();

      toastification.show(
        context: context,
        title: Text('New Shift Added.'),
        alignment: Alignment.bottomCenter,
        type: ToastificationType.success,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        icon: Icon(
          Icons.check,
          color: Colors.white,
        ),
        style: ToastificationStyle.flatColored,
        autoCloseDuration: const Duration(seconds: 3),
        showProgressBar: false,
        dragToClose: true,
      );
    }
  }

  void loadShifts() {}

  DateTime convertToDateTime(String date) {
    DateFormat format = DateFormat("dd/MM/yyyy h:mm a");
    return format.parse(date);
  }

  void onDaySelect(DateTime day, DateTime focusedDate) {
    _today = day;
    notifyListeners();
  }

// Function to add new shift and save it to Firebase Realtime Database
  void saveNewShifts(String shiftType, DateTime start, DateTime end,
      String location, BuildContext context) {
    // Shifts newShift = Shifts(startTime: start, endTime: end, location: location);

    // Save the shift in Firebase Realtime Database
    _dbRef.push().set({
      'shiftType': shiftType,
      'startTime': start.toIso8601String(),
      'endTime': end.toIso8601String(),
      'location': location,
      'status': "Open",
    }).then((_) {
      // Notify listeners once data is successfully saved
      notifyListeners();

      if (context.mounted) {
        // because we are using context in an async function
        toastification.show(
          context: context,
          // optional if you use ToastificationWrapper
          title: Text('New Shift Added.'),
          alignment: Alignment.bottomCenter,
          type: ToastificationType.success,
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          icon: Icon(
            Icons.check,
            color: Colors.white,
          ),
          style: ToastificationStyle.flatColored,
          autoCloseDuration: const Duration(seconds: 3),
          showProgressBar: false,
          dragToClose: true,
        );
      }
    }).catchError((error) {});
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

  duration(BuildContext context, DateTime start, DateTime end) {
    Duration duration = end.difference(start);
    if((duration.inHours > 16)){
      showWarning(context, "Shift duration cannot exceed 16hrs in a day");
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
