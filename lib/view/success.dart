import 'package:flutter/material.dart';
import 'package:relief_app/view/signin.dart';

import '../services/firebase_auth.dart';

class AccountSuccess extends StatefulWidget {
  const AccountSuccess({super.key});

  @override
  State<AccountSuccess> createState() => _AccountSuccessState();
}

class _AccountSuccessState extends State<AccountSuccess> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'lib/assets/verified.gif',
                width: 200,
              ),
              const SizedBox(height: 20),
              const Text(
                'Your Email has been verified and Account is now Active',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 50),
              SizedBox(
                width: 300,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightBlue),
                  onPressed: () async {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => Signin()));
                  },
                  child:  Text('Continue',
                      style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
