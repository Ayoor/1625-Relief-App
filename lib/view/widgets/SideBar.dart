import 'package:flutter/material.dart';
import 'package:relief_app/test.dart';
import 'package:relief_app/view/account.dart';

import '../../services/firebase_auth.dart';
import '../signup.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery
          .of(context)
          .size
          .width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.transparent,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
            IconButton(
            onPressed: () => Navigator.pop(context),
    icon: const Icon(Icons.arrow_back,
    size: 25, color: Colors.blue),
    ),                Center(
    child: Image.asset(
    "lib/assets/1625_logo.png",
    width: 80,
    ),
    )
                  ],
                ),

                SizedBox(height: 30,),
                Row(
                  children: [
                    Image.asset(
                      "lib/assets/user.png",
                      width: 40,
                    ),
                    SizedBox(width: 10,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Ayodele Oduoola", style: TextStyle(fontSize: 16),),
                        Text("gbengajohn4god@gmail.com", style: TextStyle(fontSize: 12, color: Colors.grey)),
                      ]

                    )
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 20,),
          ListTile(
            minVerticalPadding: 20,
            leading: const Icon(
              Icons.person_2,
              color: Colors.blue,
            ),
            trailing: Icon(Icons.chevron_right, color: Colors.grey,),
            title: const Text('Account'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const Account()));
            },
          ),
          ListTile(
            minVerticalPadding: 20,
            leading: const Icon(
              Icons.settings,
              color: Colors.blue,
            ),
            trailing: Icon(Icons.chevron_right, color: Colors.grey,),

            title: const Text('Settings'),
            onTap: () {
              Navigator.pop(context);
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (context) => const DeviceNameSearch()));
            },
          ),
          ListTile(
            minVerticalPadding: 20,
            leading: Image.asset("lib/assets/to-do-list.png", width: 25,),
            trailing: Icon(Icons.chevron_right, color: Colors.grey,),
            title: const Text('Task Checklist'),
            onTap: () {
              Navigator.pop(context);


            },
          ),
          ListTile(
            title: Center(
                child: Text(
                  "Log out",
                  style: TextStyle(fontSize: 16, color: Colors.pinkAccent, fontWeight: FontWeight.bold),
                )),
            onTap: () {
              showDialog(context: context, builder: (context) => AlertDialog(
                title: Text("Log out", style: TextStyle(fontWeight: FontWeight.bold),),
                content: Text("Are you sure you want to log out?"),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Cancel')),
                  TextButton(
                      onPressed: () => signOutUser(context),
                      child: Text('Log out', style: TextStyle(color: Colors.pinkAccent),),),
                ],
              ),
              );
            },
          ),
          const Spacer(),
          const Center(
            child: Text(
              "Developed by Ayodele Oduola",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Center(
            child: Text(
              "Version: 1.0.0",
              style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 70,
          )
        ],
      ),
    );
  }

  Future<void> signOutUser(BuildContext context) async {
    final AuthenticationService authService = AuthenticationService();

    final googleEmail = await authService.getSession('googleEmail');
    if (googleEmail != null) {
      await authService.signOut();
    }
    await authService.clearSession();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => Signin()),
          (route) => false,
    );
  }
}
