import 'package:relief_app/model/shifts.dart';

class ShiftsData{
  List<Shifts> scheduledShifts = [];
  List<Shifts> cancelledShifts = [];
  List<Shifts> completedShifts = [];
DateTime today = DateTime.now();

}