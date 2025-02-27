import 'package:flutter/material.dart';
import 'package:relief_app/services/firebase_auth.dart';
import 'package:relief_app/utils/passwordhash.dart';
import 'package:relief_app/view/otpverificationscreen.dart';
import 'package:relief_app/view/signin.dart';
import 'package:relief_app/viewmodel/authentication.dart';
import 'package:toastification/toastification.dart';

import '../viewmodel/provider.dart';
import 'home_Screen.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _formKey = GlobalKey<FormState>();
  bool obscureText = true;
  bool isLoading = false;
  String password = "";
  String firstName = "";
  String lastName = "";
  String email = "";
  String? emailError; // For real-time email validation errors

  final Authentication auth = Authentication();
  final TextEditingController _firstnameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> validateEmail(String value) async {
    if (value.isEmpty) {
      setState(() {
        emailError = 'Please enter your email';
      });
      return;
    }
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      setState(() {
        emailError = 'Please enter a valid email';
      });
      return;
    }
    bool exists = await auth.checkEmailExists(value);
    setState(() {
      emailError = exists ? 'Email already exists' : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Column(
            children: [
              Form(
                key: _formKey,
                child: Column(children: [
                  SizedBox(height: MediaQuery.of(context).size.height / 10.5),
                  Image.asset(
                    "lib/assets/1625_logo.png",
                    width: 150,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Create Your 1625 Relief App Account",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const Text(
                    "Sign up to manage your shifts seamlessly",
                    style: TextStyle(color: Colors.grey, fontSize: 15),
                  ),
                  const SizedBox(height: 40),
                  TextFormField(
                    controller: _firstnameController,
                    decoration: const InputDecoration(
                      labelText: "First Name",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person_outlined, size: 20),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 30),
                  TextFormField(
                    controller: _lastnameController,
                    decoration: const InputDecoration(
                      labelText: "Last Name",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person_outlined, size: 20),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your last name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 30),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: "Email",
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.email_outlined, size: 20),
                      errorText: emailError, // Show real-time error
                    ),
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    onChanged: validateEmail,
                  ),
                  const SizedBox(height: 30),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: obscureText,
                    obscuringCharacter: "*",
                    decoration: InputDecoration(
                      labelText: "Password",
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.lock_outline, size: 20),
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscureText ? Icons.visibility_off : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            obscureText = !obscureText;
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: 300,
                    child: ElevatedButton(
                      style:
                          ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                      onPressed: () async {
                        if (_formKey.currentState!.validate() &&
                            emailError == null) {
                          password = _passwordController.text;
                          firstName = _firstnameController.text.trim();
                          lastName = _lastnameController.text.trim();
                          email = _emailController.text.trim();
                          password =
                              PasswordHash(password: password).encryptWithArgon2();
                          auth.createNewUserData(
                              firstName, lastName, email, password);
                          auth.sendOTP(email);

                          if (mounted) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    OtpVerificationScreen(email: email),
                              ),
                            );
                          }
                        }
                      },
                      child: isLoading? CircularProgressIndicator(
                        color: Theme.of(context).colorScheme.onSurface,
                        strokeWidth: 2,
                      ): Text(
                        "Create Account",
                        style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                      ),
                    ),
                  ),

                ]),
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      height: 1, // Set the line height
                      decoration:
                      BoxDecoration(border: Border.all(color: Colors.grey)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text("Or"),
                  ),
                  Expanded(
                    child: Container(
                      height: 1, // Set the line height
                      decoration:
                      BoxDecoration(border: Border.all(color: Colors.grey)),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              Text("Continue in with", style: TextStyle(color: Colors.grey),),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                width: 300,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.surface,
                        side: BorderSide(width: .5, color: Colors.grey)),
                    onPressed: () {

                      googleSignin();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 3.0),
                          child: Image.asset(
                            "lib/assets/google_g.png",
                            width: 30,
                          ),
                        ),
                        Text(
                          "Google",
                          style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                        ),
                      ],
                    )),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have an account?", style: TextStyle(fontSize: 16),),
                  TextButton(
                      onPressed: () => Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => Signin())),
                      child: Text(
                        "Sign in",
                        style: TextStyle(color: Colors.pinkAccent, fontSize: 16),
                      ))
                ],
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
  Future<void> googleSignin() async {
    final authService = AuthenticationService();
    final provider = AppProvider();
    try {
      final googleUser = await authService.signInWithGoogle();
      if (googleUser == null) {
        return;
      } else {
        if (await auth.checkEmailExists("${googleUser.email}") &&
            auth.isverifiedUser) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(title: "1625 Relief"),
            ),
          );
        } else if (!await auth.checkEmailExists("${googleUser.email}")) {
          await authService.saveGoogleUserToDatabase(googleUser);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(title: "1625 Relief"),
            ),
          );
        }
      }
    } catch (e) {
      provider.showMessage(
          context: context,
          message: "Google sign in failed",
          type: ToastificationType.error,
          icon: Icons.cancel);
    } finally {
      setState(() {
        // isFetching = false;
      });
    }
  }

}
