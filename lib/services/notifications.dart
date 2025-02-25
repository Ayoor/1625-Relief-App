import 'package:firebase_messaging/firebase_messaging.dart';

class Notifications {
  final firebaseMessaging = FirebaseMessaging.instance;

  // initialise notifications
  Future<void> initNotifications() async {
    // request permission
await firebaseMessaging.requestPermission();

    // fetch firebase token
    final token = await firebaseMessaging.getToken();
    // if (token!= null) {
    //   print('FCM Token:\n $token \n');
    // }

    // listen for notifications

  }
}
