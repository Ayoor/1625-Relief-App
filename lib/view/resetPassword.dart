import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:relief_app/view/new_password.dart';
import 'package:relief_app/viewmodel/authentication.dart';

import '../utils/otp_html.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  String? errorText;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController tokenController = TextEditingController();
  bool isLoading = false;
  bool isRequesting = false;
  final auth = Authentication();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Reset Password",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                    color: Colors.pinkAccent),
              ),
              const SizedBox(height: 10),
              const Text(
                "We will send reset instructions to this email",
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 25),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: !isRequesting
                    ? TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                          labelText: "Your Email",
                          border: const OutlineInputBorder(),
                          prefixIcon:
                              const Icon(Icons.email_outlined, size: 20),
                          errorText: errorText, // Show real-time error
                        ),
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.done,
                      )
                    : TextFormField(
                        controller: tokenController,
                        decoration: InputDecoration(
                          labelText: "Enter Token",
                          border: const OutlineInputBorder(),
                          prefixIcon: const Icon(
                              Icons.enhanced_encryption_outlined,
                              size: 20),
                          errorText: errorText, // Show real-time error
                        ),
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.done,
                      ),
              ),
              const SizedBox(
                height: 40,
              ),
              Center(
                child: SizedBox(
                  width: 200,
                  child: !isRequesting
                      ? ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue),
                          onPressed: () async {
                            setState(() {
                              isLoading = true;
                            });
                            validateEmail(emailController.text);
                            if (errorText == null) {
                              bool exists = await auth.checkEmailExists(
                                  emailController.text.trim());
                              setState(() {
                                if (exists && auth.isEmailVerification) {
                                  isLoading = false;
                                  isRequesting = true;
                                  //send email
                                  sendOTP(emailController.text.trim());
                                } else {
                                  isLoading = false;
                                  errorText =
                                      "Sorry we don't recognize this email";
                                }
                              });
                            } else {
                              setState(() {
                                isLoading = false;
                              });
                              return;
                            }
                          },
                          child: isLoading
                              ? SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Theme.of(context).colorScheme.onSurface,
                                    strokeWidth: 2,
                                  ),
                                )
                              :  Text(
                                  "Reset Password",
                                  style: TextStyle(color: Colors.white),
                                ),
                        )
                      : ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue),
                          onPressed: isLoading? null : () {
                            setState(() {
                              isLoading = true;
                            });
                            if (auth.genOTP == tokenController.text) {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => NewPassword(email: emailController.text.trim(),)));
                            }
                            else {
                              setState(() {
                                isLoading = false;
                                errorText = "Invalid OTP";
                              });
                            }
                            //verify email and nav to new password page.
                          },
                          child: isLoading
                              ? SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(
                                  "Reset",
                                  style: TextStyle(color: Colors.white),
                                ),
                        ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void validateEmail(String value) {
    if (value.isEmpty) {
      setState(() {
        errorText = 'Please enter your email';
      });
      return;
    } else {
      setState(() {
        errorText = null;
      });
    }
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      setState(() {
        errorText = 'Please enter a valid email';
      });
      return;
    } else {
      setState(() {
        errorText = null;
      });
    }
  }

  Future<void> sendOTP(String email) async {
    final auth = Authentication();
    auth.generateUniqueOTP();
    // SMTP Server Configuration
    String username = 'gbengajohn4god@gmail.com'; // Your email address
    String password =
        'kdpe awvy jzaf sexs'; // Your email password or app-specific password (for Gmail)
    final smtpServer = gmail(username, password); // Gmail SMTP server
    // Compose the Email
    final message = Message()
      ..from = Address(username, '1625 Relief') // Sender
      ..recipients.add(email) // Recipient
      ..subject = 'Reset Token'
      ..html = OtpHtml(otp: auth.genOTP).htmlContent; // Attach a file

    try {
      // Send the email
      final sendReport = await send(message, smtpServer);
      print('Email sent: $sendReport');
    } catch (e) {
      print('Failed to send email: $e');
    }
  }
}
