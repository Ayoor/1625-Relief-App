import 'package:flutter/material.dart';

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

  @override
  void initState() {
    super.initState();
    // (Optional) You can request focus after a slight delay if needed:
    // Future.delayed(Duration(milliseconds: 300), () {
    //   FocusScope.of(context).requestFocus(_currentFocusNode);
    // });
  }
  FocusNode focusNode1 = FocusNode();
  FocusNode focusNode2 = FocusNode();
  @override
  Widget build(BuildContext context) {
    // Removed any unnecessary setState calls here
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Give some top padding so content isn't hidden behind status bar
              SizedBox(height: MediaQuery.of(context).size.height / 10),
              const SizedBox(height: 20),
              const Text(
                "Change your Password",
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 30),
              TextField(
                autofocus: true,

                onTap: (){
                  Future.delayed(Duration(milliseconds: 300), () {
                    FocusScope.of(context).requestFocus(focusNode1);
                  });

                },
                focusNode: focusNode1,
                controller: _currentPasswordController,
                 decoration: InputDecoration(
                  labelText: "Current Password",
                  border: const OutlineInputBorder(),
                  prefixIcon:
                  const Icon(Icons.lock_outline, size: 20),
                ),

              ),
              const SizedBox(height: 20),
              TextFormField(
                autofocus: true,
                onTap: (){
                  Future.delayed(Duration(milliseconds: 100), () {
                    focusNode2.requestFocus();
                  });
                },
                focusNode: focusNode2,
                controller: _newPasswordController,
                  decoration: InputDecoration(
                  labelText: "New Password",
                  border: const OutlineInputBorder(),
                  prefixIcon:
                  const Icon(Icons.lock_outline, size: 20),
                ),
              ),
              const SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(color: Colors.orange),
                    ),
                    backgroundColor:
                    Theme.of(context).colorScheme.surface,
                    elevation: 3,
                  ),
                  onPressed: () {

                  },
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(
                      "Change Password",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface),
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
}


