import 'package:flutter/material.dart';
import 'package:relief_app/test.dart';

import '../../services/firebase_auth.dart';

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
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back,
                      size: 25, color: Colors.blue),
                ),
                Center(
                  child: Image.asset(
                    "lib/assets/1625_logo.png",
                    width: 150,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(
              Icons.account_box,
              color: Colors.blue,
            ),
            title: const Text('Account'),
            onTap: () {
              Navigator.pop(context);
              // Navigator.push(context,
              //     MaterialPageRoute(builder: (context) => const ImeiSearch()));
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.settings,
              color: Colors.blue,
            ),
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
            leading: const Icon(
              Icons.check_box,
              color: Colors.blue,
            ),
            title: const Text('Task Checklist'),
            onTap: () {
              Navigator.pop(context);

              String doc = 'lib/Assets/Documents/IOS_guide.pdf';
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (context) =>  Documents(doc: doc)));
            },
          ),
          ListTile(
            title: Center(
                child: Text(
                  "Log out",
                  style: TextStyle(fontSize: 16, color: Colors.pinkAccent),
                )),
            onTap: () {
              signOutUser(context);
              Navigator.pop(context);
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

Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Signin()));
  }
}
