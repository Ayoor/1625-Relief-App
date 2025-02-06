import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:relief_app/test.dart';
import 'package:relief_app/view/account.dart';
import 'package:relief_app/view/settings.dart';

import '../../services/firebase_auth.dart';
import '../../viewmodel/provider.dart';
import '../signin.dart';
import '../signup.dart';

class Sidebar extends StatefulWidget {
   Sidebar({super.key});

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  setUser() async{
    final provider = AppProvider();
    final user = await provider.fetchUser(context);
    if(user!= null){
      if(mounted){
        setState(() {
          firstname = user.firstname;
          lastname = user.lastname;
          if(user.target != null){
            targetText = user.target!;
          }
          else{
            targetText = "No target set";
          }
          email = user.email;
        });
      }

    }


  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setUser();
  }

  String firstname ="-";

  String lastname ="-";

  String targetText ="";

  String email ="-";

  @override
  Widget build(BuildContext context) {

    return Drawer(
      width: MediaQuery.of(context).size.width * 0.8,
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
                    ),
                    Center(
                      child: Image.asset(
                        "lib/assets/1625_logo.png",
                        width: 80,
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                Center(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "$firstname ${lastname == "-" ? "" : lastname}",
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(email,
                            style: TextStyle(fontSize: 12, color: Colors.grey)),
                      ]),
                )
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          ListTile(
            minVerticalPadding: 20,
            leading: const Icon(
              Icons.person_2,
              color: Colors.blue,
            ),
            trailing: Icon(
              Icons.chevron_right,
              color: Colors.grey,
            ),
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
            trailing: Icon(
              Icons.chevron_right,
              color: Colors.grey,
            ),
            title: const Text('Settings'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const Settings()));
            },
          ),
          ListTile(
            minVerticalPadding: 20,
            leading: Image.asset(
              "lib/assets/to-do-list.png",
              width: 25,
            ),
            trailing: Icon(
              Icons.chevron_right,
              color: Colors.grey,
            ),
            title: const Text('Task Checklist'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Center(
                child: Text(
              "Log out",
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.pinkAccent,
                  fontWeight: FontWeight.bold),
            )),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(
                    "Log out",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  content: Text("Are you sure you want to log out?"),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('Cancel')),
                    TextButton(
                      onPressed: () async {
                       await  AppProvider().signOutUser(context);
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => Signin()),
                              (route) => false,
                        );
                        Fluttertoast.showToast(msg: "Signed out");
                      },
                      child: Text(
                        'Log out',
                        style: TextStyle(color: Colors.pinkAccent),
                      ),
                    ),
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
}
