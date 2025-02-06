import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:relief_app/view/widgets/delete_confirmation.dart';

import 'package:relief_app/viewmodel/provider.dart';
import 'package:toastification/toastification.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          // Adjust the height as needed
          child: Container(
            color: Colors.grey, // Set your desired border color
            height: 1.0, // Set your desired border thickness
          ),
        ),
      ),
      body: Consumer<AppProvider>(
        builder: (context, provider, child) => SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10,
                ),
                ListTile(
                  title: Text(
                    "Theme",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text("Light"),
                  trailing: Icon(
                    Icons.light_mode,
                    color: Colors.grey,
                  ),
                  onTap: () {
                    // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> EditAccount(detail: "Email")));
                  },
                ),
                ListTile(
                  trailing: Icon(
                    Icons.lock_rounded,
                    color: Colors.grey,
                  ),
                  title: Text(
                    "Change Password",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onTap: () {},
                ),
                ListTile(
                    trailing: Icon(
                      Icons.delete_forever,
                      color: Colors.red,
                    ),
                    title: Text(
                      "Delete Account",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onTap: () {
                      //show confirmation dialog
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                backgroundColor: Colors.red,
                                title: Text(
                                  "Delete Account",
                                  style: TextStyle(color: Colors.white),
                                ),
                                content: Text(
                                    style: TextStyle(color: Colors.white),
                                    "Please note that deleting this account means you will lose all your data including your logged shifts and every other thing.\nThis is an irreversible action\n\n"
                                    "Are you sure you want to delete your account?"),
                                actions: [
                                  TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text("Cancel",
                                          style:
                                              TextStyle(color: Colors.white))),
                                  TextButton(
                                      onPressed: () {
                                        try {
                                          provider.deleteUser(context);
                                          provider.signOutUser(context);
                                          Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    DeleteConfirmation()),
                                            (route) => false,
                                          );
                                        } catch (e) {
                                          provider.showMessage(
                                              context: context,
                                              message:
                                                  "Action failed. Check internet or retry later.",
                                              type: ToastificationType.error,
                                              bgColor: Colors.red.shade200,
                                              icon: Icons.cancel);
                                        }
                                      },
                                      child: Text(
                                        "Delete",
                                        style: TextStyle(color: Colors.white),
                                      )),
                                ],
                              ));
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
