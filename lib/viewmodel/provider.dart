import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:toastification/toastification.dart';
import 'package:tuple/tuple.dart';

import '../model/shiftData.dart';
import '../model/shifts.dart';
import '../utils/dateformat.dart';
import '../utils/location.dart';

class AppProvider extends ChangeNotifier {
  DateTime _today = DateTime.now();
  Map<String, Shifts> newShift = {};
  List<List<Shifts>> allShifts = [];

  // List<Shifts> _addedShifts = [];
  List<Shifts> shifts = [];

  DateTime get today => _today;
  final List<Shifts> _scheduledShifts = ShiftsData().scheduledShifts;

  final List<Shifts> _cancelledShifts = ShiftsData().cancelledShifts;

  List<Shifts> get cancelledShifts => _cancelledShifts;

  List<Shifts> _completedShifts = ShiftsData().completedShifts;

  List<Shifts> get completedShifts => _completedShifts;

  final String _status = "Scheduled";

  String get status => _status;

  List<Shifts> get scheduledShifts => _scheduledShifts;

  double get SGHShiftHrs => _SGHShiftHrs;

  double get woodleazeShiftHrs => _woodleazeShiftHrs;

  double get SGHShiftIncome => _SGHShiftIncome;

  double get woodleazeShiftIncome => _woodleazeShiftIncome;

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

  void updateShiftStatus(int index, String key, BuildContext context,
      {String shiftType = "", String endTime = ""}) async {
    try {
      // Update the status of the shift locally
      // shifts[index].status = "Cancelled";

      // Reference to the specific shift in the Firebase Database
      final DatabaseReference dbRef =
          FirebaseDatabase.instance.ref().child("Shifts/$key");

      switch (shiftType) {
        case "Scheduled":
          await dbRef.update({"status": "Scheduled"});
          break;
        case "Cancelled":
          await dbRef.update({"status": "Cancelled"});
          break;
        case "Completed":
          print(endTime);
          DateTime shiftEnd = DateTime.parse(endTime);
          if (shiftEnd.isAfter(DateTime.now())) {
            showMessage(
              context: context,
              message: "Oops! Too early to complete shift",
              type: ToastificationType.error,
              bgColor: Colors.red[400]!,
              icon: Icons.error,
            );
            return;
          }
          await dbRef.update({"status": "Completed"});
          break;
        case "Deleted":
          await dbRef.update({"status": "Deleted"});
          break;

        case "Revert":
          await dbRef.update({"status": "Scheduled"});
          break;
      } // Notify listeners to update UI
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
        durationText: duration(context, start, end),
        duration: getDuration(start, end) ,
        status: status,
        dateofAction: dateFormater(DateTime.now()),
      ));
      notifyListeners();

      showMessage(
          context: context,
          message: "New shift added",
          type: ToastificationType.info,
          bgColor: Colors.blueAccent,
          icon: Icons.info_outline);
    }
  }
  double getDuration(DateTime start, DateTime end) {
    // Calculate the duration in hours by dividing the total minutes by 60
    double duration = end.difference(start).inMinutes / 60.0;
    return double.parse(duration.toStringAsFixed(2)); // Round to 2 decimal places
  }


  Future fetchShifts(BuildContext context) async {
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
                  durationText: shiftData['durationText'],
                  status: shiftData['status'],
                  dateofAction: shiftData['dateofAction'],
                  duration: shiftData['duration'].toDouble(),

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
                  durationText: shiftData['durationText'],
                  status: shiftData['status'],
                  dateofAction: shiftData['dateofAction'],
                  duration: shiftData['duration'].toDouble(),

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
                  durationText: shiftData['durationText'],
                  status: shiftData['status'],
                  dateofAction: shiftData['dateofAction'],
                  duration: shiftData['duration'].toDouble(),
                );
                _completedShifts.add(shift);
              } catch (e) {
                print("Error parsing shift data for date $dateKey: $e");
              }
            }
          });
          _scheduledShifts.sort((a, b) => a.startTime.compareTo(b.startTime));
          _cancelledShifts.sort((a, b) => a.startTime.compareTo(b.startTime));
          _completedShifts.sort((a, b) => a.startTime.compareTo(b.startTime));
          _completedShifts = _completedShifts.reversed.toList();

          // allShifts.add(_scheduledShifts);
          // allShifts.add(_completedShifts);
          // allShifts.add(_cancelledShifts);

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

  double _CEHShiftHrs=0;
   double _CEHShiftIncome=0;

  double get CEHShiftHrs => _CEHShiftHrs;
   double _SGHShiftHrs = 0;
   double _SGHShiftIncome =0;
   double _woodleazeShiftHrs=0;
   double _woodleazeShiftIncome=0;

  double get CEHShiftIncome => _CEHShiftIncome;

  void getIncomeSummary(BuildContext context) async {
    _CEHShiftHrs= 0;
    _CEHShiftIncome = 0;
     _SGHShiftHrs =0;
     _SGHShiftIncome=0 ;
     _woodleazeShiftHrs=0;
     _woodleazeShiftIncome=0;
    await fetchShifts(context);
    for (Shifts shift in _completedShifts) {
      if (shift.location == "Charles England House") {
        _CEHShiftIncome +=  shift.duration.toDouble() * shift.rate;
        _CEHShiftHrs += shift.duration;
      }
      if (shift.location == "St. George's House") {
        _SGHShiftIncome += (shift.duration.toDouble() * shift.rate);
        _SGHShiftHrs += shift.duration;

      }
      if (shift.location == "Woodleaze") {
        _woodleazeShiftIncome += (shift.duration.toDouble() * shift.rate);
        _woodleazeShiftHrs += shift.duration;
      }
    }
    notifyListeners();
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

  bool isLoading = true;

  Future<void> loadData(BuildContext context) async {
    try {
      await fetchShifts(context);
    } catch (e) {
      // Handle error if needed
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
  LocationIncomeHistory SGH = LocationIncomeHistory();
  LocationIncomeHistory CEH = LocationIncomeHistory();
  LocationIncomeHistory WL = LocationIncomeHistory();


  void shiftHistory(BuildContext context) {


    if (_completedShifts.isNotEmpty) {
      _completedShifts= _completedShifts.reversed.toList();
      // Only process shifts for the current year
      if (_completedShifts.last.startTime.year == DateTime.now().year) {

        // Map each location to its respective class
        final locationMap = {
          "St. George's House": SGH,
          "Charles England House": CEH,
          "Woodleaze": WL,
        };

        for (final location in locationMap.values) {
          location.resetMonthlyValues();
        }

        for (Shifts cs in _completedShifts.toList()) {
          final monthIndex = cs.startTime.month; // 1 for Jan, 2 for Feb, etc.

          // Update the corresponding month dynamically
          if (locationMap.containsKey(cs.location)) {
            final LocationIncomeHistory locationClass = locationMap[cs.location]!;
            locationClass.updateMonthlyValue(monthIndex, cs.duration * cs.rate);
          }
        }
      }
    }

    notifyListeners();
  }
  List<Shifts> _filteredShifts =[];

  List<Shifts> get filteredShifts => _filteredShifts;
 final List <List<String>> _exportData = [];

  List<List<String>> get exportData => _exportData;

  void generateTimeSheet(DateTime start, DateTime end, String location, BuildContext context) {
    _filteredShifts.clear;
    if( _completedShifts.isNotEmpty) {
      _filteredShifts = _completedShifts.where((shift) =>
         shift.startTime.isAfter(start.subtract(Duration(days: 1))) &&
            shift.startTime.isBefore(end.add(Duration(days: 1))) && shift.location == location
      ).toList();
    }
    else{
      showMessage(context: context, message: "No shifts in timeframe", type: ToastificationType.error, bgColor: Colors.red.shade200, icon: Icons.cancel_rounded);
    }
    if(_filteredShifts.isEmpty){
      showMessage(context: context, message: "No shifts in timeframe", type: ToastificationType.error, bgColor: Colors.red.shade200, icon: Icons.cancel_rounded);

    }
    _filteredShifts= _filteredShifts.reversed.toList();
    for (Shifts completedShift in _filteredShifts) {
      exportData.add([
        ReadableDate(dateTime: completedShift.startTime).date(),
        ReadableDate(dateTime: completedShift.startTime).time(),
        "",
        ReadableDate(dateTime: completedShift.endTime).time(),
        "${completedShift.duration}",]);
      _totalHours+= completedShift.duration;
    }
    if(_filteredShifts.length < 22){
      for(int i=0; i< 22 -_filteredShifts.length ; i++){
        exportData.add(["a","a","b","b","b",]);
      }

    }


    notifyListeners();
}

  // Future<void> exportTimeSheet({
  //   required String name,
  //   required String month,
  //   required double payRate,
  //   required List<Shifts> shifts, // Now receiving a List of Shifts objects
  // }) async {
  //   // Load the template
  //   final data = File("lib/assets/ceh.docx");
  //   final docx = await DocxTemplate.fromBytes(await data.readAsBytes());
  //
  //   // Replace placeholders
  //   Content content = Content();
  //   content
  //     ..add(TextContent("NAME", name))
  //     ..add(TextContent("MONTH", month))
  //     ..add(TextContent("PAY_RATE", payRate.toString()));
  //
  //   // Transform the List<Shifts> into table rows
  //   List<RowContent> tableRows = [];
  //   for (var shift in shifts) {
  //     tableRows.add(RowContent()
  //       ..add(TextContent("DATE", DateFormat('dd/MM/yyyy').format(shift.startTime)))
  //       ..add(TextContent("START_TIME", DateFormat('hh:mm a').format(shift.startTime)))
  //       ..add(TextContent("END_TIME", DateFormat('hh:mm a').format(shift.endTime))));
  //   }
  //   content.add(TableContent("SHIFTS", tableRows));
  //
  //   // Generate the document
  //   final docGenerated = await docx.generate(content);
  //   final fileGenerated = File('generated.docx');
  //   if (docGenerated != null) await fileGenerated.writeAsBytes(docGenerated);
  // }
double _totalHours = 0;

  double get totalHours => _totalHours;
}// end of provider class

