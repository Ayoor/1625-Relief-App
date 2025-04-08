import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:relief_app/utils/otp_html.dart';
import 'package:relief_app/utils/passwordhash.dart';
import 'package:relief_app/viewmodel/provider.dart';
import 'package:toastification/toastification.dart';

class Authentication extends ChangeNotifier {
  static final Authentication _instance = Authentication._internal();

  Authentication._internal();

  factory Authentication() => _instance;
  late String genOTP;
  late DateTime otpExpiryTime;
bool isEmailVerification = false;
  Future<bool> checkEmailExists(String email) async {
    email = email.replaceAll(".", "dot");
    final DatabaseReference ref = FirebaseDatabase.instance.ref().child("Users/$email");
    final DataSnapshot snapshot = await ref.get();

    if (snapshot.exists) {
      final users = snapshot.value as Map;
      notifyListeners();
      email = email.replaceAll("dot", ".");

      //to check for google auth users
      if(users["Email"]== email && users["Account Status"] == "Verified") {
        _isVerifiedUser = true;
      }
      if(users["Authentication Type"]== "Email") {
        isEmailVerification = true;
      }
      else {
        isEmailVerification = false;
      }

      return users["Email"]== email;
    }
    notifyListeners();
    return false;
  }

  Future<void> createNewUserData(
      String firstName, String lastName, String email, String password) async {
    final databaseRef = FirebaseDatabase.instance.ref().child("Users");

    // Replace invalid characters in the email
    final safeKey = email.replaceAll('.', 'dot');

    // Save the data
    await databaseRef.child(safeKey).set({
      "First Name": firstName,
      "Last Name": lastName,
      "Email": email,
      "Password": password, // Use encrypted password
      "Account Status": "Awaiting email verification",
      "Authentication Type" :"Email"
    });

    // sendOTP(email);
  }

  bool isExpiredOTP() {
    if (DateTime.now().difference(otpExpiryTime) >= Duration(minutes: 5)) {
      return true;
    }
    return false;
  }

  bool isvalidOTP(String userotp) {

    if (userotp != genOTP || isExpiredOTP()) {
      return false;
    }
    return true;
  }

  Future<void> sendOTP(String email) async {
    generateUniqueOTP();
    // SMTP Server Configuration
    String username = 'gbengajohn4god@gmail.com'; // Your email address
    String password =
        'kdpe awvy jzaf sexs'; // Your email password or app-specific password (for Gmail)
    final smtpServer = gmail(username, password); // Gmail SMTP server
    // Compose the Email
    final message = Message()
      ..from = Address(username, '1625 Relief') // Sender
      ..recipients.add(email) // Recipient
      ..subject = 'Your One time Registration Token'
      ..html = OtpHtml(otp: genOTP).htmlContent; // Attach a file

    try {
      // Send the email
      final sendReport = await send(message, smtpServer);
      print('Email sent: $sendReport');
    } catch (e) {

      print('Failed to send email: $e');
    }
  }
bool _isVerifiedUser = false;

  static Authentication get instance => _instance;

  Future<bool> isValidCredentials(String email, String password, BuildContext context) async{
      final userEmail = email.replaceAll('.', 'dot');
password = PasswordHash(password: password).encryptWithArgon2();
      final dbRef = FirebaseDatabase.instance.ref().child("Users/$userEmail");

      try {
        final DataSnapshot snapshot = await dbRef.get();

        if (snapshot.exists) {
          final users = snapshot.value as Map;
          email = email.replaceAll("dot", ".");
          if( users["Email"]== email && users["Password"]== password ) {
            if( users["Account Status"]== "Verified" ) {
              _isVerifiedUser = true;
            }

            return true;
          }
        }
      } catch (e) {
        AppProvider().showMessage(context: context,
            message: "An error occurred please try again later",
            type: ToastificationType.error,
            icon: Icons.cancel);
      }
      return false;
      // Navigate to next screen

    }


  void generateUniqueOTP() {
    List<int> digits =
        List.generate(10, (index) => index); // List of digits 0-9
    digits.shuffle(); // Shuffle the digits randomly
    otpExpiryTime = DateTime.now().add(
        Duration(minutes: 5)); // Set OTP expiry time to 5 minutes from now
    genOTP = digits.take(5).join();

  }

  bool get isverifiedUser => _isVerifiedUser;
}
