import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';

import '../utils/passwordhash.dart';
import '../viewmodel/authentication.dart';
import '../viewmodel/provider.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final _formKey = GlobalKey<FormState>();

  bool obscureText = true;
  bool isLoading = false;

  // Controllers for the text fields
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final Authentication authentication = Authentication();

  @override
  void initState() {
    super.initState();
  }

  FocusNode focusNode1 = FocusNode();
  FocusNode focusNode2 = FocusNode();

  @override
  Widget build(BuildContext context) {
    // Removed any unnecessary setState calls here
    return Scaffold(
      appBar: AppBar(
        title: const Text("Change Password"),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: Container(
            color: Colors.grey,
            height: 1.0,
          ),
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Give some top padding so content isn't hidden behind status bar
              SizedBox(height: 30),
              TextFormField(
                validator: passwordValidator,
                autofocus: true,
                focusNode: focusNode1,
                textInputAction:TextInputAction.next,
                controller: _currentPasswordController,
                decoration: InputDecoration(
                  labelText: "Current Password",
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.lock_outline, size: 20),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                validator: passwordValidator,
                autofocus: true,

                focusNode: focusNode2,
                controller: _newPasswordController,
                decoration: InputDecoration(
                  labelText: "New Password",
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.lock_outline, size: 20),
                ),
              ),
              const SizedBox(height: 30),
              Center(
                child: SizedBox(
                  width: 200,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(color: Colors.orange),
                      ),
                      backgroundColor: Theme.of(context).colorScheme.surface,
                      elevation: 3,
                    ),
                      onPressed: isLoading? null: () {
                        if (_formKey.currentState!.validate()) {
                          changePassword(
                            _currentPasswordController.text.trim(),
                            _newPasswordController.text.trim(),
                            context,
                          );
                        }

                    },
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: isLoading? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Theme.of(context).colorScheme.onSurface,
                  strokeWidth: 2,
                        ),
                      ): Text(
                        "Change Password",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface),
                      ),
                    ),
                  ),
                ),
              ),
              // Extra space at the bottom, if needed
              SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> changePassword(String oldPassword, String newPassword, BuildContext context) async {
    setState(() {
      isLoading = true;
    });
    var email = await AppProvider().userEmail();
    final DatabaseReference dbRef =
    FirebaseDatabase.instance.ref().child("Users/$email/");
    final DataSnapshot snapshot = await dbRef.get();
    try {
      if (snapshot.exists) {
        final user = snapshot.value as Map;
        String dbPassword = user["Password"];
        oldPassword = PasswordHash(password: oldPassword).encryptWithArgon2();

        if (dbPassword == oldPassword) {
          newPassword = PasswordHash(password: newPassword).encryptWithArgon2();
          await dbRef.child("Password").set(newPassword);
          AppProvider().showMessage(
              context: context,
              message: "New Password set",
              type: ToastificationType.success,
              icon: Icons.check_circle);
          setState(() {
            isLoading = false;
          });
          Navigator.pop(context);
        }
        else{
          AppProvider().showMessage(
              context: context,
              message: "Your current password is incorrect",
              type: ToastificationType.error,
              icon: Icons.error);
          setState(() {
            isLoading = false;
          });
          return;
        }
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "An error occurred try again later");
    }
  }


  String? passwordValidator(String? value) {

    if (value == null || value.isEmpty) {
      return 'Password cannot be empty';
    } else if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

}
