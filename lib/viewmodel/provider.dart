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

  void addShift(
      DateTime start, DateTime end, String location, BuildContext context) {
    shifts.add(Shifts(
        startTime: start,
        endTime: start,
        location: location,
        shiftType: getShiftTypeAndRate(start, location).item1,
        rate:getShiftTypeAndRate(start, location).item2,
        duration: duration(start, end)));
    notifyListeners();
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

 Tuple2 <String, double> getShiftTypeAndRate(DateTime startTime, String location) {
    // DateTime startTime = DateTime.parse(start);
    if (startTime.hour < 12) {
      return Tuple2("Early Shift", 12);
    } else if (startTime.hour < 21) {
      return Tuple2("Late Shift",12);
    } else {
      if (location == "Charles England House") {
        return Tuple2("Sleep in Shift", 12);
      }
      return Tuple2("Wake in Shift",12.3);
    }
  }

  String duration(DateTime start, DateTime end) {
    Duration duration = end.difference(start);
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
