import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:relief_app/services/firebase_auth.dart';
import 'package:relief_app/utils/passwordhash.dart';
import 'package:relief_app/viewmodel/authentication.dart';
import 'package:toastification/toastification.dart';

import '../test.dart';
import '../utils/otp_html.dart';
import '../viewmodel/provider.dart';

class NewPassword extends StatefulWidget {
  String email;

  NewPassword({super.key, required this.email});

  @override
  State<NewPassword> createState() => _NewPasswordState();
}

class _NewPasswordState extends State<NewPassword> {
  String? errorText;
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

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
                "Enter your new password",
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 25),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: TextFormField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      labelText: "Your new password",
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.key, size: 20),
                      errorText: errorText, // Show real-time error
                    ),
                    keyboardType: TextInputType.visiblePassword,
                    textInputAction: TextInputAction.done,
                  )),
              const SizedBox(
                height: 40,
              ),
              Center(
                child: SizedBox(
                    width: 200,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue),
                      onPressed: () async {
                        final password = passwordController.text;
                        setState(() {
                          isLoading = true;
                        });
                        if (password.length < 6) {
                          setState(() {
                            isLoading = false;
                            errorText =
                                "Password must be at least 6 characters long.";
                          });
                        } else {
                          String email = widget.email.replaceAll(".", "dot");

                          //save password to db
                          await saveNewPasswordToDB(email, password);

                          //save email session
                          await AuthenticationService()
                              .saveSession("email", email);

                          // display success message
                          AppProvider().showMessage(
                              context: context,
                              message:
                                  "Your Password has been successfully Changed",
                              type: ToastificationType.success,
                              bgColor: Colors.lightGreen,
                              icon: Icons.download_outlined);

                          //navigate to signin;
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Signin()));
                        }
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
                          : const Text(
                              "Finish",
                              style: TextStyle(color: Colors.white),
                            ),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> saveNewPasswordToDB(String email, String password) async {
    password = PasswordHash(password: password).encryptWithArgon2();
    final DatabaseReference dbRef =
        FirebaseDatabase.instance.ref().child("Users/$email/");
    final DataSnapshot snapshot = await dbRef.get();
    try {
      if (snapshot.exists) {
        await dbRef.child("Password").set(password);
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "An error occurred try again later");
      return;
    }
  }
}
