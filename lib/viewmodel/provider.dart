import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:relief_app/model/userData.dart';
import 'package:relief_app/services/firebase_auth.dart';
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

  Future<String> userEmail() async {
    final authService = AuthenticationService();
    String userEmail = "";
    final googleEmail = await authService.getSession('googleEmail');
    final email = await authService.getSession('email');

    if (googleEmail != null) {
      userEmail = googleEmail.replaceAll(".", "dot");
    } else if (email != null) {
      userEmail = email.replaceAll(".", "dot");
    }
    return userEmail;
  }

  void removeShift(int index, BuildContext context) {
    shifts.removeAt(index);
    showMessage(
        context: context,
        message: "Shift Removed",
        type: ToastificationType.info,
        icon: Icons.info);
    notifyListeners();
  }

  Future<void> updateShiftStatus(int index, String key, BuildContext context,
      {String startDate = "",
      String updateShiftTo = "",
      String endTime = ""}) async {
    String email = await userEmail();
    if (email.isEmpty) {
      print("Error: No valid email found.");
      return;
    }

    String? userId = await OneSignal.User.getExternalId();
    if (userId == null) {
      print("Error: No valid OneSignal user ID found.");
      return;
    }

    try {
      final DatabaseReference dbRef =
          FirebaseDatabase.instance.ref().child("Users/$email/Shifts/$key");

      // Retrieve notification IDs
      final snapshot = await dbRef.child("NotificationIdPre").get();
      String? notificationIdPre = snapshot.value?.toString();

      final snapshot2 = await dbRef.child("NotificationIdPost").get();
      String? notificationIdPost = snapshot2.value?.toString();
      print("Notification IDs: $notificationIdPre, $notificationIdPost" );


      switch (updateShiftTo) {
        case "Cancelled":
          await dbRef.update({"status": "Cancelled"});
          if (notificationIdPre != null) cancelNotification(notificationIdPre);
          if (notificationIdPost != null) cancelNotification(notificationIdPost);
          if (context.mounted) {
            showMessage(
              context: context,
              message: "Shift Cancelled.",
              type: ToastificationType.success,
              icon: Icons.check,
            );
            fetchShifts(context);
          }

          break;

        case "Completed":
          DateTime shiftEnd = DateTime.parse(endTime);
          if (shiftEnd.isAfter(DateTime.now())) {
            showMessage(
              context: context,
              message: "Oops! Too early to complete shift",
              type: ToastificationType.error,
              icon: Icons.error,
            );
            return;
          }
          await dbRef.update({"status": "Completed"});
          if (notificationIdPost != null)
            cancelNotification(notificationIdPost);
          if (context.mounted) {
            showMessage(
              context: context,
              message: "Shift status updated successfully.",
              type: ToastificationType.success,
              icon: Icons.check,
            );
            fetchShifts(context);
          }

          break;

        case "Deleted":
          await dbRef.update({"status": "Deleted"});
          if (notificationIdPre != null) cancelNotification(notificationIdPre);
          if (notificationIdPost != null)
            cancelNotification(notificationIdPost);
          if (context.mounted) {
            showMessage(
              context: context,
              message: "Shift Deleted.",
              type: ToastificationType.success,
              icon: Icons.check,
            );
            fetchShifts(context);
          }

          break;

        case "Revert":
          await dbRef.update({"status": "Scheduled"});
          DateTime scheduledTimePre =
              DateTime.parse(startDate).subtract(Duration(hours: 3));
          DateTime scheduledTimePost =
              DateTime.parse(endTime).add(Duration(minutes: 30));
          scheduleNotification(
              userId: userId,
              templateId: templateId,
              scheduledTime: scheduledTimePre);
          scheduleNotification(
              userId: userId,
              templateId: completedShiftsTemplateId,
              scheduledTime: scheduledTimePost);
          if (context.mounted) {
            showMessage(
              context: context,
              message: "Shift Cancellation Reverted.",
              type: ToastificationType.success,
              icon: Icons.check,
            );
            fetchShifts(context);
          }

          break;
      }

      notifyListeners();
    } catch (e) {
      if (context.mounted) {
        showMessage(
          context: context,
          message: "Action failed. Check internet or retry later.",
          type: ToastificationType.error,
          icon: Icons.clear,
        );
      }
    }
  }

  // Future<void> getFCMToken() async {
  //   final email =
  //       await userEmail(); // Assuming you have a method to get the logged-in user's email
  //   FirebaseMessaging messaging = FirebaseMessaging.instance;
  //   String? token = await messaging.getToken(); // Get the FCM token
  //
  //   if (token != null) {
  //     print("FCM Token: $token");
  //
  //     // Reference to the user's FCM tokens in Firebase
  //     final dbRef =
  //         FirebaseDatabase.instance.ref().child("Users/$email/FcmTokens");
  //
  //     // Fetch the existing tokens (if any)
  //     final snapshot = await dbRef.get();
  //
  //     List<String> tokens = [];
  //
  //     if (snapshot.exists) {
  //       // Convert the snapshot value into a List<String>
  //       tokens = List<String>.from(snapshot.value as List);
  //     }
  //
  //     // Add the new token to the list (if it's not already there)
  //     if (!tokens.contains(token)) {
  //       tokens.add(token); // Add the new token to the list
  //     }
  //
  //     // Update the FCM tokens list in the database
  //     await dbRef.set(tokens); // Store the updated list of tokens
  //   }
  // }

  void showMessage(
      {required BuildContext context,
      required String message,
      required ToastificationType type,
      required IconData icon}) {
    toastification.show(
      context: context,
      description: Text(
        message,
        style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold),
      ),
      alignment: Alignment.topCenter,
      type: type,
      foregroundColor: Theme.of(context).colorScheme.onSurface,
      icon: Icon(
        icon,
        color: Colors.white,
      ),
      style: ToastificationStyle.fillColored,
      autoCloseDuration: const Duration(seconds: 2),
      showProgressBar: false,
      dragToClose: true,
    );
  }

  Future<void> deleteUser(BuildContext context) async {
    String email = await userEmail();

    DatabaseReference userRef = FirebaseDatabase.instance.ref("Users/$email");
    await userRef.remove();
  }

  Future<void> signOutUser(BuildContext context) async {
    _completedShifts.clear();
    _scheduledShifts.clear();
    _cancelledShifts.clear();
    final AuthenticationService authService = AuthenticationService();

    final googleEmail = await authService.getSession('googleEmail');
    final email = await authService.getSession('email');
    if (googleEmail != null || email != null) {
      await authService.signOut();
    }
    await authService.clearSession();
  }

  void addShift(
      DateTime start, DateTime end, String location, BuildContext context) {
    fetchShifts(context);

    // Check if there's already a shift with the same start time
    bool isDuplicate = false;

    if (shifts.any((shift) =>
        (start.isBefore(shift.endTime) && end.isAfter(shift.startTime)))) {
      isDuplicate = true;
    }

    if (isDuplicate) {
      // If duplicate, show a toast notification
      showMessage(
          context: context,
          message: "A shift already exists in timeframe",
          type: ToastificationType.warning,
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
        duration: getDuration(start, end),
        status: status,
        dateofAction: dateFormater(DateTime.now()),
      ));
      notifyListeners();

      showMessage(
          context: context,
          message: "New shift added",
          type: ToastificationType.info,
          icon: Icons.info_outline);
    }
  }

  double getDuration(DateTime start, DateTime end) {
    // Calculate the duration in hours by dividing the total minutes by 60
    double duration = end.difference(start).inMinutes / 60.0;
    return double.parse(
        duration.toStringAsFixed(2)); // Round to 2 decimal places
  }

  Future<ReliefUser?> fetchUser(BuildContext context) async {
    String email = await userEmail(); // Function to get the user's email
    final DatabaseReference dbRef = FirebaseDatabase.instance.ref();

    try {
      final DataSnapshot snapshot = await dbRef.child('Users/$email').get();

      if (snapshot.exists && snapshot.value is Map<dynamic, dynamic>) {
        final Map<dynamic, dynamic> userData =
            snapshot.value as Map<dynamic, dynamic>;

        // Create a ReliefUser instance from the retrieved data
        return ReliefUser(
          email: userData['Email'] ?? "",
          firstname: userData['First Name'] ?? "",
          lastname: userData['Last Name'] == "N/A" ? "" : userData['Last Name'],
          target: userData['Target'],
        );
      } else {
        // Show an error message if the user doesn't exist
        showMessage(
          context: context,
          message: "User not found",
          type: ToastificationType.warning,
          icon: Icons.info,
        );
      }
    } catch (e) {
      // Handle any errors during the fetch process
      showMessage(
        context: context,
        message: "Error fetching user: ${e.toString()}",
        type: ToastificationType.error,
        icon: Icons.cancel,
      );
    }

    return null; // Return null if no user is found or an error occurs
  }

//shifts are being duplicated in the loop
  Future fetchShifts(BuildContext context) async {
    _completedShifts.clear();
    _scheduledShifts.clear();
    _cancelledShifts.clear();
    String email = await userEmail();
    final DatabaseReference dbRef = FirebaseDatabase.instance.ref();

    try {
      final DataSnapshot snapshot =
          await dbRef.child('Users/$email/Shifts').get();

      if (snapshot.exists) {
        // Check if the value is a Map
        if (snapshot.value is Map<dynamic, dynamic>) {
          final Map<dynamic, dynamic> dateMap =
              snapshot.value as Map<dynamic, dynamic>;
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
                showMessage(
                    context: context,
                    message: "Error parsing shift data for date $dateKey",
                    type: ToastificationType.error,
                    icon: Icons.cancel);
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
                showMessage(
                    context: context,
                    message: "Error parsing shift data for date $dateKey",
                    type: ToastificationType.error,
                    icon: Icons.cancel);
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
                showMessage(
                    context: context,
                    message: "Error parsing shift data for date $dateKey",
                    type: ToastificationType.error,
                    icon: Icons.cancel);
              }
            }
          });

          _scheduledShifts.sort((a, b) => a.startTime.compareTo(b.startTime));
          _cancelledShifts.sort((a, b) => a.startTime.compareTo(b.startTime));
          _completedShifts.sort((a, b) => a.startTime.compareTo(b.startTime));
          _completedShifts = _completedShifts.reversed.toList();

          notifyListeners();
        } else {
          showMessage(
              context: context,
              message: "Something failed, please try again later",
              type: ToastificationType.error,
              icon: Icons.cancel);
        }

        notifyListeners();
      } else {
        return [];
      }
    } catch (e) {
      if (context.mounted) {
        showMessage(
          context: context,
          message: "An error occurred retrieving shifts",
          type: ToastificationType.error,
          icon: Icons.clear,
        );
      }
      showMessage(
        context: context,
        message: "An error occurred retrieving shifts",
        type: ToastificationType.error,
        icon: Icons.clear,
      );

      notifyListeners();
      return [];
    }
  }

  double _CEHShiftHrs = 0;
  double _CEHShiftIncome = 0;

  double get CEHShiftHrs => _CEHShiftHrs;
  double _SGHShiftHrs = 0;
  double _SGHShiftIncome = 0;
  double _woodleazeShiftHrs = 0;
  double _woodleazeShiftIncome = 0;
  double _allocatedIncome = 0;

  double get allocatedIncome => _allocatedIncome;
  String _allocatedIncomeText = "";

  double get CEHShiftIncome => _CEHShiftIncome;

  void getIncomeSummary(BuildContext context) async {
    _CEHShiftHrs = 0;
    _CEHShiftIncome = 0;
    _SGHShiftHrs = 0;
    _SGHShiftIncome = 0;
    _woodleazeShiftHrs = 0;
    _woodleazeShiftIncome = 0;
    _allocatedIncome = 0;

    getDateRange();
    await overviewData(context, monthStart!, monthEnd!);

    for (Shifts shift in _monthlycompletedShifts) {
      if (shift.location == "Charles England House") {
        _CEHShiftIncome += shift.duration.toDouble() * shift.rate;
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
    _allocatedIncome =
        _CEHShiftIncome + _SGHShiftIncome + _woodleazeShiftIncome;
    double remainingIncome = 0;

    for (Shifts shift in _scheduledShifts) {
      if (!shift.startTime.isBefore(monthStart!) &&
          !shift.endTime.isAfter(monthEnd!)) {
        remainingIncome += shift.duration.toDouble() * shift.rate;
      }
    }
    var formatter =
        NumberFormat.currency(locale: "en_UK", decimalDigits: 2, symbol: "£");
    _allocatedIncome += remainingIncome;
    _allocatedIncomeText = formatter.format(_allocatedIncome);
    notifyListeners();
  }

  DateTime convertToDateTime(String date) {
    DateFormat format = DateFormat("dd/MM/yyyy h:mm a");
    return format.parse(date);
  }

  //schedule shift reminder notification

  Future<void> scheduleNotification({
    required String userId,
    required String templateId, // Add the template ID here
    required DateTime scheduledTime,
    String? notificationType,
  }) async {
    // change to actual time

    // Convert time to UTC format required by OneSignal
    String scheduledTimeUtc = scheduledTime.toUtc().toIso8601String();
    // String scheduledTimeUtc = DateTime.now().add(Duration(minutes: 1)).toIso8601String();

    // OneSignal API Endpoint
    const String oneSignalUrl = "https://onesignal.com/api/v1/notifications";

    // Headers
    Map<String, String> headers = {
      "Content-Type": "application/json; charset=UTF-8",
      "Authorization": "Basic $oneSignalRestApiKey",
    };

    // Request Body
    Map<String, dynamic> body = {
      "app_id": oneSignalAppId,
      "include_external_user_ids": [userId],
      "template_id": templateId,
      "send_after": scheduledTimeUtc,
    };

    try {
      // Send the request
      final response = await http.post(
        Uri.parse(oneSignalUrl),
        headers: headers,
        body: jsonEncode(body),
      );

      // Check response
      if (response.statusCode == 200) {
        print("✅ Notification scheduled successfully: ${response.body}");
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        String notificationId = responseData['id']; // Extract notification ID
        if (notificationType == "Pre") {
          _notificationID = notificationId;
        }
        if (notificationType == "Post") {
          _shiftCompleteNotificationID = notificationId;
        }
      } else {
        print("❌ Failed to schedule notification: ${response.body}");
      }
    } catch (e) {
      print("❌ Error scheduling notification: $e");
    }
  }

  final String oneSignalAppId = "8110724a-d13e-43f8-a58d-450454c49101";
  final String oneSignalRestApiKey =
      "os_v2_app_qeiheswrhzb7rjmniucfjreraeluvmilmkjummejdexh6ui6lp7npq6jkxpv5jobmgzauq4yxpep2ytxydvsyvjeguenepqj2yzrhxq";

  //cancel shift notification
  Future<void> cancelNotification(String notificationId) async {
    final Uri url = Uri.parse(
        "https://onesignal.com/api/v1/notifications/$notificationId?app_id=$oneSignalAppId");

    final Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": "Basic $oneSignalRestApiKey",
    };

    try {
      final response = await http.delete(url, headers: headers);

      if (response.statusCode == 200) {
        print("✅ Notification canceled successfully");
      } else {
        print("❌ Failed to cancel notification: ${response.body}");
      }
    } catch (e) {
      print("❌ Error canceling notification: $e");
    }
  }

  void scheduleMonthlyTimeSheetNotification() async {
    String timeSheetTemplateID = "aa162c41-24a4-4c56-b79b-c0a21449814f";
    String email = await userEmail();
    final DatabaseReference dbRef =
        FirebaseDatabase.instance.ref("Users/$email/Last Login");
    final DateTime now = DateTime.now();
    final DateTime? lastLogin = await getLastLogin(dbRef);

    // If user has already logged in this month, do nothing
    if (lastLogin != null &&
        lastLogin.year == now.year &&
        lastLogin.month == now.month) {
      await updateLastLogin(dbRef, now); // Just update login date
      return;
    }

    // Try to get the external user ID (set during login)
    String? userId = await OneSignal.User.getExternalId();

    if (userId == null) {
      print("Error: No valid OneSignal user ID found.");
      return;
    }

    // Find the correct notification date
    DateTime notificationDate =
        DateTime(now.year, now.month + 1, 10, 10, 0); // Next 10th at 10 AM
    if (notificationDate.weekday == DateTime.saturday) {
      notificationDate =
          notificationDate.subtract(Duration(days: 1)); // Move to 9th
    } else if (notificationDate.weekday == DateTime.sunday) {
      notificationDate =
          notificationDate.subtract(Duration(days: 2)); // Move to 8th
    }

    // Schedule notification
    await scheduleNotification(
        userId: userId,
        templateId: timeSheetTemplateID,
        scheduledTime: notificationDate);

    // Update last login in database
    await updateLastLogin(dbRef, now);
  }

  Future<DateTime?> getLastLogin(DatabaseReference dbRef) async {
    final snapshot = await dbRef.get();
    if (snapshot.exists) {
      return DateTime.parse(snapshot.value.toString());
    }
    return null;
  }

  Future<void> updateLastLogin(
      DatabaseReference dbRef, DateTime loginTime) async {
    await dbRef.set(loginTime.toIso8601String());
  }

// Function to add new shift and save it to Firebase Realtime Database// For date formatting

  Future<void> saveNewShifts(
    BuildContext context,
    List<Shifts> shifts,
    DateTime start,
    DateTime end,
  ) async {
    if (shifts.isEmpty) {
      showMessage(
        context: context,
        message: "You need to add new shifts first",
        type: ToastificationType.warning,
        icon: Icons.cancel,
      );
      return;
    }
    await fetchShifts(context);

    if (_scheduledShifts.any((shift) =>
        (start.isBefore(shift.endTime) && end.isAfter(shift.startTime)))) {
      showMessage(
        context: context,
        message: "Shift clash detected, unable to save new shifts",
        type: ToastificationType.warning,
        icon: Icons.cancel,
      );
      return;
    }
// Try to get the external user ID (set during login)
    String? userId = await OneSignal.User.getExternalId();

    if (userId == null) {
      print("Error: No valid OneSignal user ID found.");
      return;
    }

    try {
      String email = await userEmail();
      for (var shift in shifts) {
        // Format the startTime to a date string (e.g., "dd-MM-yyyy")
        final String dateKey = DateFormat('dd-MM-yyyy').format(shift.startTime);
        final DatabaseReference dbRef = FirebaseDatabase.instance
            .ref()
            .child("Users/$email/Shifts/$dateKey: ${shift.shiftType}");

        // Save each shift under the date key in "Shifts"
        await dbRef.set(shift.toJson());
        await scheduleNotification(
           userId: userId,
           templateId: templateId,
           scheduledTime: shift.startTime.subtract(Duration(hours: 3)),
          notificationType: "Pre"
         );

         await scheduleNotification(
           userId: userId,
           templateId: completedShiftsTemplateId,
           scheduledTime: shift.endTime.add(Duration(minutes: 30)),
           notificationType: "Post"
         );

         dbRef.child("NotificationIdPre").set(_notificationID);
         dbRef.child("NotificationIdPost").set(_shiftCompleteNotificationID);
      }

      shifts.clear();
      notifyListeners();

      if (context.mounted) {
        showMessage(
          context: context,
          message: "Your shifts have been successfully saved.",
          type: ToastificationType.success,
          icon: Icons.check,
        );
      }
      checkboxes();
      fetchShifts(context);
    } catch (e) {
      // Show error notification if saving shifts fails
      if (context.mounted) {
        showMessage(
          context: context,
          message: "Action failed. Check internet or retry later",
          type: ToastificationType.error,
          icon: Icons.clear,
        );
      }
    }
  }

  final templateId = "b1b1fae0-45f9-44c0-88f9-af88420700c1";
  final completedShiftsTemplateId = "20e7cb0a-4966-4b20-ad6c-f7499cc61f7a";
  late List<bool> _isCheckedList;
  String _notificationID = "";

  String get notificationID => _notificationID;

  String _shiftCompleteNotificationID = "";

  String get shiftCompleteNotificationID => _shiftCompleteNotificationID;

  List<bool> checkboxes() {
    _isCheckedList = List<bool>.filled(scheduledShifts.length, false);
    return _isCheckedList;
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

  bool _isLoading = true;

  bool get isLoading => _isLoading;

  List<bool> get isCheckedList => _isCheckedList;

  Future<void> loadData(BuildContext context) async {
    try {
      await fetchShifts(context);
    } catch (e) {
      // Handle error if needed
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  LocationIncomeHistory SGH = LocationIncomeHistory();
  LocationIncomeHistory CEH = LocationIncomeHistory();
  LocationIncomeHistory WL = LocationIncomeHistory();

  void shiftHistory(BuildContext context) {
    final locationMap = {
      "St. George's House": SGH,
      "Charles England House": CEH,
      "Woodleaze": WL,
    };
    if (_completedShifts.isNotEmpty) {
      _completedShifts = _completedShifts.reversed.toList();

      // Only process shifts for the current year
      if (_completedShifts.last.startTime.year == DateTime.now().year) {
        // Map each location to its respective class

        // Reinitialize values to avoid duplication
        for (final location in locationMap.values) {
          location.reInitialiseMonthlyValues();
        }

        // Accumulate monthly values
        for (Shifts cs in _completedShifts.toList()) {
          final monthIndex = cs.startTime.month; // 1 for Jan, 2 for Feb, etc.

          // Update the corresponding month dynamically
          if (locationMap.containsKey(cs.location)) {
            final LocationIncomeHistory locationClass =
                locationMap[cs.location]!;
            locationClass.accumulateMonthlyValue(
                monthIndex, cs.duration * cs.rate);
          }
        }
      } else {
        // Reinitialize values to avoid duplication
        for (final location in locationMap.values) {
          location.reInitialiseMonthlyValues();
        }
      }
    } else {
      // Reinitialize values to avoid duplication
      for (final location in locationMap.values) {
        location.reInitialiseMonthlyValues();
      }
    }

    notifyListeners();
  }

  List<Shifts> _filteredShifts = [];

  List<Shifts> get filteredShifts => _filteredShifts;
  final List<List<dynamic>> _exportData = [];

  List<List<dynamic>> get exportData => _exportData;
  bool _showTable = false;

  bool get showTable => _showTable;

  void generateTimeSheet(
      DateTime start, DateTime end, String location, BuildContext context) {
    _filteredShifts.clear();
    _exportData.clear();
    _totalHours = 0;
    if (_completedShifts.isNotEmpty) {
      _filteredShifts = _completedShifts
          .where((shift) =>
              shift.startTime.isAfter(start) &&
              shift.startTime.isBefore(end) &&
              shift.location == location)
          .toList();
    } else {
      showMessage(
          context: context,
          message: "No shifts in timeframe",
          type: ToastificationType.error,
          icon: Icons.cancel_rounded);
      _showTable = false;
      notifyListeners();
      return;
    }
    if (_filteredShifts.isEmpty) {
      showMessage(
          context: context,
          message: "No shifts in timeframe",
          type: ToastificationType.error,
          icon: Icons.cancel_rounded);
      _showTable = false;
      notifyListeners();
      return;
    } else {
      _filteredShifts = _filteredShifts.reversed.toList();

      for (Shifts completedShift in _filteredShifts) {
        exportData.add([
          ReadableDate(dateTime: completedShift.startTime).date(),
          ReadableDate(dateTime: completedShift.startTime).time(),
          "",
          ReadableDate(dateTime: completedShift.endTime).time(),
          completedShift.duration,
        ]);
        _totalHours += completedShift.duration;
      }
      if (_filteredShifts.length < 15) {
        for (int i = 0; i < 15 - _filteredShifts.length; i++) {
          exportData.add([
            "\n",
            "\n",
            "\n",
            "\n",
            "\n",
          ]);
        }
      }
    }
    _showTable = true;
    notifyListeners();
  }

  int get monthCompletedShifts => _monthCompletedShifts;
  int _monthCompletedShifts = 0;
  int _monthAlocatedShifts = 0;
  int _monthCancelledShifts = 0;
  final int _balanceShifts = 0;
  double _totalIncomeforTheMonth = 0;
  List<Shifts> _monthlycompletedShifts = [];
  List<Shifts> _monthlycancelledShifts = [];

  List<Shifts> get monthlycancelledShifts => _monthlycancelledShifts;
  List<Shifts> _monthlyScheduledShifts = [];

  List<Shifts> get monthlycompletedShifts => _monthlycompletedShifts;
  double _compJan = 0,
      _compFeb = 0,
      _compMar = 0,
      _compMay = 0,
      _compApr = 0,
      _compJun = 0,
      _compJul = 0,
      _compAug = 0,
      _compSep = 0,
      _compOct = 0,
      _compNov = 0,
      _compDec = 0;

  double get compJan => _compJan;

  Future overviewData(
      BuildContext context, DateTime start, DateTime end) async {
    await loadData(context);
    _compJan = _compFeb = _compMar = _compMay = _compApr = _compJun =
        _compJul = _compAug = _compSep = _compOct = _compNov = _compDec = 0;

    // Filter shifts for the given range
    _monthlycompletedShifts = _completedShifts
        .where((shift) =>
            (shift.startTime.isAfter(start) ||
                shift.startTime.isAtSameMomentAs(start)) &&
            (shift.startTime.isBefore(end) ||
                shift.startTime.isAtSameMomentAs(end)))
        .toList();

    _monthlyScheduledShifts = _scheduledShifts
        .where((shift) =>
            (shift.startTime.isAfter(start) ||
                shift.startTime.isAtSameMomentAs(start)) &&
            (shift.startTime.isBefore(end) ||
                shift.startTime.isAtSameMomentAs(end)))
        .toList();

    _monthlycancelledShifts = _cancelledShifts
        .where((shift) =>
            (shift.startTime.isAfter(start) ||
                shift.startTime.isAtSameMomentAs(start)) &&
            (shift.startTime.isBefore(end) ||
                shift.startTime.isAtSameMomentAs(end)))
        .toList();

    // Calculate shift counts
    _monthCompletedShifts = _monthlycompletedShifts.length;
    _monthAlocatedShifts =
        _monthlycompletedShifts.length + _monthlyScheduledShifts.length;
    _monthCancelledShifts = _monthlycancelledShifts.length;

    _totalIncomeforTheMonth = 0;
    // Calculate total income for completed shifts
    for (Shifts shift in _monthlycompletedShifts) {
      _totalIncomeforTheMonth += shift.rate * shift.duration;
    }

    // Process completed shifts by year and month
    for (int i = 0; i < _completedShifts.length; i++) {
      if (_completedShifts[i].startTime.year != DateTime.now().year) {
        continue; // Skip shifts not in the current year
      }

      switch (_completedShifts[i].startTime.month) {
        case 1:
          _compJan++;
          break;
        case 2:
          _compFeb++;
          break;
        case 3:
          _compMar++;
          break;
        case 4:
          _compApr++;
          break;
        case 5:
          _compMay++;
          break;
        case 6:
          _compJun++;
          break;
        case 7:
          _compJul++;
          break;
        case 8:
          _compAug++;
          break;
        case 9:
          _compSep++;
          break;
        case 10:
          _compOct++;
          break;
        case 11:
          _compNov++;
          break;
        case 12:
          _compDec++;
          break;
      }
    }

    notifyListeners();
  }

  DateTime? monthStart;
  DateTime? monthEnd;

  String getDateRange() {
    DateTime now = DateTime.now();

    if (now.day <= 10) {
      // If the date is on or before the 10th of the current month
      monthStart =
          DateTime(now.year, now.month - 1, 11); // 11th of the previous month
      monthEnd = DateTime(now.year, now.month, 10); // 10th of the current month
    } else {
      // If the date is after the 10th of the current month
      monthStart =
          DateTime(now.year, now.month, 11); // 11th of the current month
      monthEnd =
          DateTime(now.year, now.month + 1, 10); // 10th of the next month
    }

    return "${monthStart!.day}/${monthStart!.month}/${monthStart!.year} to ${monthEnd!.day}/${monthEnd!.month}/${monthEnd!.year}";
  }

  bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  // }
  double _totalHours = 0;

  double get totalHours => _totalHours;

  int get monthAlocatedShifts => _monthAlocatedShifts;

  int get monthCancelledShifts => _monthCancelledShifts;

  int get balanceShifts => _balanceShifts;

  double get totalIncomeforTheMonth => _totalIncomeforTheMonth;

  List<Shifts> get monthlyScheduledShifts => _monthlyScheduledShifts;

  get compFeb => _compFeb;

  get compMar => _compMar;

  get compMay => _compMay;

  get compApr => _compApr;

  get compJun => _compJun;

  get compJul => _compJul;

  get compAug => _compAug;

  get compSep => _compSep;

  get compOct => _compOct;

  get compNov => _compNov;

  get compDec => _compDec;

  String get allocatedIncomeText => _allocatedIncomeText;
} // end of provider class
