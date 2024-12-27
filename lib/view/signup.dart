import 'package:flutter/material.dart';
import 'package:argon2/argon2.dart';
import 'package:relief_app/utils/passwordhash.dart';
import 'package:relief_app/viewmodel/authentication.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _formKey = GlobalKey<FormState>();
  bool obscureText = true;
String password ="";
String name ="";
String email ="";
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Form(
            key: _formKey,
            child: Column(children: [
              SizedBox(height: MediaQuery.of(context).size.height / 10),
              Image.asset(
                "lib/assets/1625_logo.png",
                width: 150,
              ),
              SizedBox(height: 20),
              Text(
                "Create Your 1625 Relief App Account",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              Text(
                "Sign up to manage your shifts seamlessly",
                style: TextStyle(color: Colors.grey, fontSize: 15),
              ),
              SizedBox(height: 40),
              SizedBox(height: 45,
                child: TextFormField(
                  autovalidateMode: AutovalidateMode.onUnfocus,
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: "Name",
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
              ),
              SizedBox(height: 30),
              SizedBox(
                height: 45,
                child: TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email_outlined, size: 20),
                  ),
                  autovalidateMode: AutovalidateMode.onUnfocus,
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
              ),
              SizedBox(height: 30),
              SizedBox(height:45,
                child: TextFormField(
                  controller: _passwordController,
                  obscureText: obscureText,
                  obscuringCharacter: "*",
                  decoration: InputDecoration(
                    labelText: "Password",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock_outline, size: 20),
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
              ),
              SizedBox(height: 30),
              SizedBox(
                width: 300,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      password= _passwordController.text;
                     password =  PasswordHash(password: password).encryptWithArgon2();
                     name= _nameController.text;
                      email= _emailController.text;
bool x;
                      x = await Authentication().checkEmailExists(email);
                      print(x);
                      // You can now send the hashed password to your backend
                    }
                  },
                  child: Text(
                    "Create Account",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),

              SizedBox(
                height: 30,
              ),
              SizedBox(
                width: 300,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.white, side: BorderSide(width: .5, color: Colors.grey)),
                    onPressed: () {

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
              )
            ]),
          ),
        ),
      ),
    );
  }
}
