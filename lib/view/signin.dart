  import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

  import 'package:relief_app/utils/passwordhash.dart';

  import 'package:relief_app/view/all_shifts.dart';
import 'package:relief_app/view/resetPassword.dart';

  import 'package:relief_app/view/signup.dart';

  import 'package:relief_app/viewmodel/authentication.dart';

  import 'package:relief_app/viewmodel/provider.dart';

  import 'package:toastification/toastification.dart';

import '../services/firebase_auth.dart';
import 'home_Screen.dart';

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
    bool isLoading = false;

    final Authentication auth = Authentication();
    final AuthenticationService authService = AuthenticationService();

    final TextEditingController _emailController = TextEditingController();

    final TextEditingController _passwordController = TextEditingController();

    @override
  void initState() {
    // TODO: implement initState
    super.initState();
   checkSession(context);

    }

    Future<void> checkSession(BuildContext context) async {
      setState(() {
        isLoading = true;
      });
      final googleEmail = await authService.getSession('googleEmail');
      final email = await authService.getSession('email');

      if (googleEmail != null || email != null) {
        // Navigate directly to HomeScreen
        Future.microtask(() {

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(title: "1625 Relief"),
            ),
          );
        });
      } else {
        // No session found, update isLoading to show the sign-in screen
        setState(() {
          isLoading = false;
        });
      }
    }

    @override
    Widget build(BuildContext context) {
      AppProvider provider = AppProvider();
if (isLoading) {
  return Scaffold(
    body: Center(
      child: Text("Loading..."),
    ),
  );
}
else {
  return Scaffold(
    backgroundColor: Theme.of(context).colorScheme.surface,
    body: SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height / 10),
            Center(
              child: Image.asset(
                "lib/assets/1625_logo.png",
                width: 150, // Explicitly setting the width
                fit: BoxFit.contain, // Ensuring the image maintains its aspect ratio
              ),
            ),
                const SizedBox(height: 20),
                const Text(
                  "Sign in to your 1625 Relief App Account",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const Text(
                  "Seamlessly manage your shifts",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey, fontSize: 15),
                ),
                const SizedBox(height: 40),
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
                  ),
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
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
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange),
                    onPressed: () async {
                      setState(() {
                        isFetching = true;
                      });

                      try {
                        await signin(context, provider);
                      } catch (e) {
                        provider.showMessage(
                          context: context,
                          message: "An error occurred while trying to sign in",
                          type: ToastificationType.error,
                          bgColor: Colors.red,
                          icon: Icons.cancel,
                        );
                      } finally {
                        setState(() {
                          isFetching = false;
                        });
                      }
                    },
                    child: isFetching
                        ? SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Theme.of(context).colorScheme.onSurface,
                        strokeWidth: 2,
                      ),
                    )
                        :  Text(
                      "Sign in",
                      style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Divider(color: Colors.grey),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text("Or Sign in with"),
                    ),
                    Expanded(
                      child: Divider(color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: 300,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.surface,
                      side: BorderSide(width: .5, color: Colors.grey),
                    ),
                    onPressed: () async {
                      setState(() {
                        isFetching = true;
                      });
                      try {
                        await googleSignin();
                      } catch (e) {
                        provider.showMessage(
                          context: context,
                          message: "An error occurred while trying to sign in",
                          type: ToastificationType.error,
                          bgColor: Colors.red,
                          icon: Icons.cancel,
                        );
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
                          style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account?",
                      style: TextStyle(fontSize: 16),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => Signup()),
                      ),
                      child: const Text(
                        "Sign up",
                        style: TextStyle(
                            color: Colors.pinkAccent, fontSize: 16),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> ResetPassword()));

                  },
                  child: const Text(
                    "Forgot password?",
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 12,
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.blue,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
    }

    Future<void> googleSignin() async {
       final provider = AppProvider();
      try {
        final googleUser = await authService.signInWithGoogle();
        if (googleUser == null) {
          return;
        } else {
          if (await auth.checkEmailExists("${googleUser.email}") &&
              auth.isverifiedUser) {
            await authService.saveSession("googleEmail", "${googleUser.email}");
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomeScreen(title: "1625 Relief"),
              ),
            );
            Fluttertoast.showToast(msg: "Welcome back!");

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
            bgColor: Colors.red,
            icon: Icons.cancel);
      } finally {
        setState(() {
          isFetching = false;
        });
      }
    }


    Future<void> signin(BuildContext context, AppProvider provider) async {
      if (_formKey.currentState!.validate() &&
          (emailError == (null) || emailError == "")) {
        password = _passwordController.text;

        email = _emailController.text.trim();

        if (mounted) {
          //sign in logic

          bool isExistingEmail = await auth.checkEmailExists(email);

          if (isExistingEmail) {
            bool isValidCredentials =
                await auth.isValidCredentials(email, password, context);

            if (isValidCredentials) {
              await authService.saveSession("email", email);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => HomeScreen(title: "1625 Relief"),
                ),
              );
              Fluttertoast.showToast(msg: "Welcome back!");
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

            errorMsg = "Sorry, this email has not been registered";

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
