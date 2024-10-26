import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:relief_app/model/shiftData.dart';
import 'package:toastification/toastification.dart';

import '../model/shifts.dart';

class AppProvider extends ChangeNotifier{
  DateTime _today = ShiftData().today;
  Map<String, Shifts> newShift= {};
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref().child('Shifts');

  // List<Shifts> _addedShifts = [];

  DateTime get today => _today;
  final List _scheduledShifts = ShiftData().scheduledShift;

   List get scheduledShifts => _scheduledShifts;

   void loadShifts() {

   }

   void onDaySelect (DateTime day, DateTime focusedDate){
     _today = day;
     notifyListeners();
   }
// Function to add new shift and save it to Firebase Realtime Database
  void addNewShift(String shiftType, DateTime start, DateTime end, String location, BuildContext context) {
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

      if (context.mounted) { // because we are using context in an async function
        toastification.show(
          context: context,
          // optional if you use ToastificationWrapper
          title: Text('New Shift Added.'),
          alignment: Alignment.bottomCenter,
          type: ToastificationType.success,
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          icon: Icon(Icons.check, color: Colors.white,),
          style: ToastificationStyle.flatColored,
          autoCloseDuration: const Duration(seconds: 3),
          showProgressBar: false,
          dragToClose: true,

        );
      }
    }).catchError((error) {
    });
  }
// Shifts getSelectedDayShift(DateTime selectedDate){
//      return _addedShifts[selectedDate];
// }

}