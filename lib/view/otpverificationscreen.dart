import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:relief_app/view/success.dart';
import 'package:relief_app/viewmodel/authentication.dart';
import 'package:relief_app/viewmodel/provider.dart';
import 'package:toastification/toastification.dart';

import '../services/firebase_auth.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String email;

  const OtpVerificationScreen({super.key, required this.email});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final otpFields = List.generate(5, (index) => TextEditingController());
  String countdown = "10:00"; // Initial countdown string
  late Timer _timer;
  final FocusNode _focusNode = FocusNode();

  // int totalSeconds = 10 * 60;  // 10 minutes in seconds
  int totalSeconds = 300;
  String otpTimerelay = ""; // 10 minutes in seconds;
  String error = ""; // 10 minutes in seconds;
  bool isActive = false;
  Authentication auth = Authentication();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startCountdownTimer();
      _focusNode.requestFocus();
    });
    // Start the timer when the screen loads

  }

  void _startCountdownTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      if (totalSeconds < 0) {
        timer.cancel();
        setState(() {
          countdown = "00:00";
          // Show "00:00" when the timer reaches 0;
        });
      } else {
        setState(() {
          int minutes = totalSeconds ~/ 60;
          int seconds = totalSeconds % 60;
          countdown =
          '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(
              2, '0')}';
          otpTimerelay = "Resend OTP in $countdown";

          totalSeconds--; // Decrement the time

          isActive = false;
          if (countdown == ('00:00')) {
            // Show a snackbar when the countdown reaches 0
            otpTimerelay = "";
            isActive = true;
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _timer
        .cancel(); // Cancel the timer when leaving the screen to prevent memory leaks
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 16),
              Image.asset(
                'lib/assets/otp.png', // Replace with your asset path
                height: 150,
              ),
              const SizedBox(height: 16),
              const Text(
                'OTP Verification',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Enter the OTP sent to ${widget.email}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(5, (index) {
                  return SizedBox(
                    width: 50,
                    child: TextField(
                      focusNode: index == 0 ? _focusNode : null,
                      controller: otpFields[index],
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 1,
                      style: const TextStyle(fontSize: 24),
                      decoration: const InputDecoration(
                        counterText: '',
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                      ),
                      onChanged: (value) {
                        if (value.isNotEmpty && index < 4) {
                          FocusScope.of(context).nextFocus();
                        }
                        if ((value.isEmpty && !(index == 4)) ||
                            value.isEmpty && (index == 4)) {
                          FocusScope.of(context).previousFocus();
                        }
                      },
                    ),
                  );
                }),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: isActive ? () {
                  setState(() {
                    totalSeconds = 300;
                    _startCountdownTimer();
                    error = "";
                  });
                  auth.sendOTP(widget.email);
                } : null,
                child: Text(
                  'RESEND OTP',
                  style: TextStyle(
                      color: isActive ? Colors.black : Colors.grey
                  ),
                ),
              ),
              Text(
                otpTimerelay,
                style: TextStyle(color: Colors.blueGrey, fontSize: 12),
              ),
              Text(
                error,
                style: TextStyle(color: Colors.red, fontSize: 12),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () async {
                  // Add verify OTP logic here
                  String userotp = otpFields.map((e) => e.text).join();
                  //get generted otp
                  bool validOTP = auth.isvalidOTP(userotp);

                  if (validOTP) {

                    final userEmail = widget.email.replaceAll('.', 'dot');
                    final dbRef = FirebaseDatabase.instance.ref().child("Users/$userEmail");

                    try {
                      final DataSnapshot snapshot = await dbRef.get();

                      if (snapshot.exists) {
                        dbRef.update({"Account Status": "Verified"});
                        final AuthenticationService authService = AuthenticationService();
                        await authService.saveSession("email", widget.email);
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => AccountSuccess(),
                          ),
                        );
                      }
                    } catch (e) {
                      AppProvider().showMessage(context: context,
                          message: "An error occurred please try again later",
                          type: ToastificationType.error,
                          icon: Icons.cancel);
                    }
                    // Navigate to next screen

                  }
                  else {
                    setState(() {

                      for(TextEditingController fields in otpFields) {
                        fields.text ="";
                      }
                      error = "Invalid OTP";
                      _focusNode.requestFocus();
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding:
                  const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child:  Text(
                  'VERIFY & PROCEED',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
