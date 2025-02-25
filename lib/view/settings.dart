import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:relief_app/viewmodel/provider.dart';
import 'package:toastification/toastification.dart';
import 'package:relief_app/view/widgets/delete_confirmation.dart';

import '../viewmodel/theme.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  GlobalKey passwordFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: Container(
            color: Colors.grey,
            height: 1.0,
          ),
        ),
      ),
      body: Consumer2<ThemeProvider, AppProvider>(
        builder: (context, themeProvider, appProvider, child) =>
            SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                // Theme Toggle
                ListTile(
                  title: const Text(
                    "Theme",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    themeProvider.themeMode == ThemeMode.dark
                        ? "Dark"
                        : "Light",
                  ),
                  trailing: Icon(
                    themeProvider.themeMode == ThemeMode.dark
                        ? Icons.dark_mode
                        : Icons.light_mode,
                    color: Colors.grey,
                  ),
                  onTap: () {
                    themeProvider.toggleTheme();
                  },
                ),
                // Change Password
                ListTile(
                  trailing: const Icon(Icons.lock_rounded, color: Colors.grey),
                  title: const Text(
                    "Change Password",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    TextEditingController currentPasswordController =
                        TextEditingController();
                    TextEditingController newPasswordController =
                        TextEditingController();
                    TextEditingController confirmPasswordController =
                        TextEditingController();
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              title: Text("Change Password"),
                              content: SizedBox(
                                height: 310,
                                width: 300,
                                child: Form(
                                  key: passwordFormKey,
                                  child: Column(
                                    children: [
                                      TextFormField(
                                        controller: currentPasswordController,
                                        decoration: InputDecoration(
                                          labelText: "Current password",
                                          border: const OutlineInputBorder(),
                                          prefixIcon: const Icon(
                                              Icons.lock_outline,
                                              size: 20),
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
                                      SizedBox(height: 20),
                                      TextFormField(
                                        controller: newPasswordController,
                                        decoration: InputDecoration(
                                          labelText: "New password",
                                          border: const OutlineInputBorder(),
                                          prefixIcon: const Icon(
                                              Icons.lock_outline,
                                              size: 20),
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
                                      SizedBox(height: 20),
                                      TextFormField(
                                        controller: confirmPasswordController,
                                        decoration: InputDecoration(
                                          labelText: "Re-enter new password",
                                          border: const OutlineInputBorder(),
                                          prefixIcon: const Icon(
                                              Icons.lock_outline,
                                              size: 20),
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
                                      SizedBox(
                                        height: 30,
                                      ),
                                      ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  Colors.transparent),
                                          onPressed: () {},
                                          child: Text(
                                            "Update Password",
                                            style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSurface,
                                            ),
                                          ))
                                    ],
                                  ),
                                ),
                              ),
                            ));
                  },
                ),
                // Delete Account
                ListTile(
                  trailing: const Icon(Icons.delete_forever, color: Colors.red),
                  title: const Text(
                    "Delete Account",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        backgroundColor: Colors.red,
                        title: Text(
                          "Delete Account",
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface),
                        ),
                        content: Text(
                          "Please note that deleting this account means you will lose all your data including your logged shifts and every other thing.\nThis is an irreversible action.\n\n"
                          "Are you sure you want to delete your account?",
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text("Cancel",
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface)),
                          ),
                          TextButton(
                            onPressed: () {
                              try {
                                appProvider.deleteUser(context);
                                appProvider.signOutUser(context);
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const DeleteConfirmation()),
                                  (route) => false,
                                );
                              } catch (e) {
                                appProvider.showMessage(
                                  context: context,
                                  message:
                                      "Action failed. Check internet or retry later.",
                                  type: ToastificationType.error,
                                  bgColor: Colors.red.shade200,
                                  icon: Icons.cancel,
                                );
                              }
                            },
                            child: Text("Delete",
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface)),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
