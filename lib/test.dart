import 'package:flutter/material.dart';
import 'package:relief_app/utils/passwordhash.dart';
import 'package:relief_app/view/all_shifts.dart';
import 'package:relief_app/view/signup.dart';
import 'package:relief_app/viewmodel/authentication.dart';
import 'package:relief_app/viewmodel/provider.dart';
import 'package:toastification/toastification.dart';

class Signin extends StatefulWidget {
  const Signin({super.key});

  @override
  State<Signin> createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  final _formKey = GlobalKey<FormState>();
  bool obscureText = true;
  String password = "";
  String email = "";
  String errorMsg = "";
  String emailError = "";
  bool isFetching = false;

  final Authentication auth = Authentication();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    AppProvider provider = AppProvider();

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
              Image.asset(
                "lib/assets/1625_logo.png",
                width: 150,
              ),
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

              // email
              TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    setState(() {
                      emailError = 'Please enter your email';
                    });
                    return emailError;
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    setState(() {
                      emailError = 'Please enter a valid email';
                    });
                    return emailError;
                  }
                  setState(() {
                    emailError = "";
                  });
                  return null;
                },
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: "Email",
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.email_outlined, size: 20),
                  // errorText: emailError, // Real-time error display
                ),
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                // Call validation on change
              ),
              const SizedBox(height: 30),

              //password

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
                    await signin(context, provider);
                  },
                  child: isFetching
                      ? SizedBox(
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
                    child: Text("Or Sign in with"),
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
              SizedBox(
                height: 30,
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

                      try {
                        await signin(context, provider);
                      } catch (e) {
                        provider.showMessage(context: context,
                            message: "An error occurred while trying to sign in",
                            type: ToastificationType.error,
                            bgColor: Colors.red,
                            icon: Icons.cancel);
                      } finally {
                        setState(() {
                          isFetching = false;
                        });
                      }
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

  Future<void> signin(BuildContext context, AppProvider provider) async {
    if (_formKey.currentState!.validate() &&
        (emailError == (null) || emailError == "")) {
      password = _passwordController.text;

      email = _emailController.text.trim();
      password =
          PasswordHash(password: password).encryptWithArgon2();

      if (mounted) {
        //sign in logic
        bool isExistingEmail =
        await auth.checkEmailExists(email);
        if (isExistingEmail) {
          bool isValidCredentials = await auth
              .isValidCredentials(email, password, context);
          if (isValidCredentials) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => AllShifts(),
              ),
            );
          } else {
            setState(() {
              isFetching = false;
            });
            errorMsg = "Incorrect Password";
            provider.showMessage(
                context: context,
                message: errorMsg,
                type: ToastificationType.error,
                bgColor: Colors.red,
                icon: Icons.cancel);
          }
        } else {
          setState(() {
            isFetching = false;
          });
          errorMsg =
          "Sorry, this email has not been registered";
          provider.showMessage(
              context: context,
              message: errorMsg,
              type: ToastificationType.error,
              bgColor: Colors.red,
              icon: Icons.cancel);
        }
      }
    }
  }
}
