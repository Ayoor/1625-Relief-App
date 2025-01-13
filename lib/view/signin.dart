import 'package:flutter/material.dart';
import 'package:relief_app/view/all_shifts.dart';
import 'package:relief_app/view/otpverificationscreen.dart';
import 'package:relief_app/view/signup.dart';
import 'package:relief_app/view/widgets/home_Screen.dart';
import 'package:relief_app/viewmodel/authentication.dart';
import 'package:relief_app/viewmodel/provider.dart';
import 'package:toastification/toastification.dart';

import '../services/firebase_auth.dart';

class Signin extends StatefulWidget {
  const Signin({super.key});

  @override
  State<Signin> createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  final _formKey = GlobalKey<FormState>();
  bool obscureText = true;
  bool isFetching = false;
  String password = "";
  String email = "";
  String errorMsg = "";
  bool isLoading = true;


  final Authentication auth = Authentication();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthenticationService authService = AuthenticationService();

  Future<void> checkSession(BuildContext context) async {
    final googleEmail = await authService.getSession('googleEmail');
    final email = await authService.getSession('email');

    if (googleEmail != null) {

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(title: "1625 Relief"),
        ),
      );
      // Proceed to the home screen
    } else if (email != null) {

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(title: "1625 Relief"),
        ),
      );
      // Proceed to the home screen
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkSession(context);
  }

  @override
  Widget build(BuildContext context) {
    final AppProvider provider = AppProvider();
    if (isLoading) {
      return Scaffold(
        body: Center(
          child: Text("Loading..."),
        ),
      );
    }
setState(() {
  isLoading = false;
});
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Form(
            key: _formKey,
            child: Column(children: [
              SizedBox(height: MediaQuery
                  .of(context)
                  .size
                  .height / 10),
              Image.asset("lib/assets/1625_logo.png", width: 150),
              const SizedBox(height: 20),
              const Text(
                "Sign in to your 1625 Relief App Account",
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const Text(
                "Seamlessly manage your shifts",
                style: TextStyle(color: Colors.grey, fontSize: 15),
              ),
              const SizedBox(height: 40),

              // Email Input
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email_outlined, size: 20),
                ),
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),

              // Password Input
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

              // Sign In Button
              SizedBox(
                width: 300,
                child: ElevatedButton(
                  style:
                  ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                  onPressed: isFetching
                      ? null
                      : () async {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        isFetching = true; // Show loading indicator
                      });

                      try {
                        password = _passwordController.text;

                        email = _emailController.text.trim();
                        // Perform Sign In Logic
                        bool isSuccess =
                        await signin(email, password, provider, context);

                        if (isSuccess && auth.isverifiedUser) {
                          // save sign in session
                         await authService.saveSession("email", email);

                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomeScreen(title: "1625 Relief"),
                            ),
                          );
                        }
                        if (isSuccess && !auth.isverifiedUser) {
                          auth.sendOTP(email);
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  OtpVerificationScreen(email: email),
                            ),
                          );
                        }
                      } catch (e) {
                        // showErrorToast(context, "Sign in failed. $e");
                        provider.showMessage(context: context,
                            message: "An error occurred while trying to sign in",
                            type: ToastificationType.error,
                            bgColor: Colors.red,
                            icon: Icons.cancel);
                      } finally {
                        setState(() {
                          isFetching = false; // Hide loading indicator
                        });
                      }
                    }
                  },
                  child: isFetching
                      ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                      : const Text(
                    "Sign in",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
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
                        backgroundColor: Colors.white,
                        side: BorderSide(width: .5, color: Colors.grey)),
                    onPressed: () async {
                      setState(() {
                        isFetching = true;
                      });
                      googleSignin(provider);
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
                          style: TextStyle(color: Colors.black87),
                        ),
                      ],
                    )),
              ),
              SizedBox(
                height: 40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account?",
                    style: TextStyle(fontSize: 16),
                  ),
                  TextButton(
                      onPressed: () =>
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (context) =>
                                  Signup())),
                      child: Text(
                        "Sign up",
                        style:
                        TextStyle(color: Colors.pinkAccent, fontSize: 16),
                      ))
                ],
              ),
              SizedBox(
                height: 20,
              ),
              TextButton(
                  onPressed: () {},
                  child: Text("Forgot password?",
                      style: TextStyle(
                          color: Colors.blue,
                          fontSize: 12,
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.blue)))
            ]),
          ),
        ),
      ),
    );
  }

  Future<bool> signin(String email, String password, AppProvider provider,
      BuildContext context) async {
    final isExistingEmail = await auth.checkEmailExists(email);
    if (!isExistingEmail) {
      provider.showMessage(context: context,
          message: "Your email is not registered.",
          type: ToastificationType.error,
          bgColor: Colors.red,
          icon: Icons.cancel);
      return false;
    }

    final isValidCredentials =
    await auth.isValidCredentials(email, password, context);
    if (!isValidCredentials) {
      provider.showMessage(context: context,
          message: "Incorrect Password",
          type: ToastificationType.error,
          bgColor: Colors.red,
          icon: Icons.cancel);
      return false;
    }


    return true;
  }

  Future<void> googleSignin(AppProvider provider) async {
    try {
      final googleUser = await authService.signInWithGoogle();
      if (googleUser== null) {
        return;
      }
      else {
        if(await auth.checkEmailExists("${googleUser.email}") && auth.isverifiedUser){
    Navigator.pushReplacement(
    context,
    MaterialPageRoute(
    builder: (context) =>
    AllShifts(),
    ),
    );
    }
    else if(! await auth.checkEmailExists("${googleUser.email}")){
    await authService.saveGoogleUserToDatabase(googleUser);
    Navigator.pushReplacement(
    context,
    MaterialPageRoute(
    builder: (context) =>
    HomeScreen(title: "1625 Relief"),
    ),
    );
    }
    }
    }
    catch (e) {
    provider.showMessage(context: context,
    message: "Google sign in failed",
    type: ToastificationType.error,
    bgColor: Colors.red,
    icon: Icons.cancel);
    }
    finally {
    setState(() {
    isFetching = false;
    });
    }
  }


}