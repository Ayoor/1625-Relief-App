import 'package:flutter/material.dart';
import 'package:relief_app/test.dart';

import '../signin.dart';

class DeleteConfirmation extends StatelessWidget {
  const DeleteConfirmation({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Image.asset(
            "lib/assets/deleted.gif",
            width: 200,
          ),
          SizedBox(
            height: 30,
          ),
          Text(
            "Account Deleted",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 30,
          ),
          SizedBox(width: 200,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.pinkAccent),
                onPressed: () {
                  Navigator.pushReplacement(
                      context, MaterialPageRoute(builder: (context) => Signin()));
                },
                child: Text("Finish", style: TextStyle(color: Theme.of(context).colorScheme.onSurface))),
          )
        ]),
      ),
    );
  }
}
