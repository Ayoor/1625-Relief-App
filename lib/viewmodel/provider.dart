import 'package:flutter/widgets.dart';
import 'package:relief_app/model/shiftData.dart';

class AppProvider extends ChangeNotifier{
  DateTime date = DateTime.now();
   final List _scheduledShifts = ShiftData().scheduledShift;

   List get scheduledShifts => _scheduledShifts;

   void loadShifts() {

   }

   void onDaySelect (DateTime day, DateTime focusedDate){
     date = day;
     notifyListeners();
   }
   DateTime today() => DateTime.now();
}