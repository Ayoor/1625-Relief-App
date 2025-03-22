import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:relief_app/view/changepassword.dart';
import 'package:relief_app/viewmodel/provider.dart';
import 'package:toastification/toastification.dart';
import 'package:relief_app/view/widgets/delete_confirmation.dart';

import 'package:onesignal_flutter/onesignal_flutter.dart';
import '../viewmodel/theme.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  GlobalKey passwordFormKey = GlobalKey<FormState>();
  TextEditingController currentPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    // Dispose the controller when the widget is removed from the widget tree
    confirmPasswordController.dispose();
    newPasswordController.dispose();
    currentPasswordController.dispose();
    super.dispose(); // Call super.dispose() after disposing the controller
  }

  @override
  void initState() {
    super.initState();
    _checkNotificationPermission();
  }

  Future<void> _toggleNotifications(bool enabled) async {
    if (enabled) {
      // Check if notification permission is granted
      PermissionStatus status = await Permission.notification.status;

      if (!status.isGranted) {
        // If not granted, request permission
        PermissionStatus newStatus = await Permission.notification.request();

        if (newStatus.isGranted) {
          // Permission granted, now initialize OneSignal if needed
          await OneSignal.Notifications.requestPermission(true);
          OneSignal.consentGiven(true);
        } else {
          // Optionally handle the case when the user denies permission
          print("Permission denied");
          // Show dialog before opening settings
          _showPermissionDialog(context);
        }
      } else {
        // Permission already granted, enable notifications
        await OneSignal.Notifications.requestPermission(true);();
      }
    } else {
      // Optionally, disable notifications here
      await OneSignal.Notifications.requestPermission(false);();
    }

    // Check permission status again
    _checkNotificationPermission();
  }

  void _showPermissionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Enable Notifications"),
          content: Text(
              "Notifications are disabled. Please go to settings and enable them."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                openAppSettings(); // Open settings
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("Open Settings"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _checkNotificationPermission() async {
    bool hasPermission = await OneSignal.Notifications.permission;
    setState(() {
      _isNotificationsEnabled = hasPermission;
    });
  }

  bool _isNotificationsEnabled = false;

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
  
                    ListTile(
                      title: Text("Notifications", style: TextStyle(fontWeight: FontWeight.bold)),
                      trailing: Container(
                        width: 50,
                        padding: EdgeInsets.only(left: 30),
                        child: Transform.scale(
                          scale: 0.5,
                          child: Switch(
                            value: _isNotificationsEnabled,
                            onChanged: (value) => _toggleNotifications(value),
                          ),
                        ),
                      ),
                    )
                    ,
                    // Change Password
                    ListTile(
                      trailing: const Icon(Icons.lock_rounded, color: Colors.grey),
                      title: const Text(
                        "Change Password",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ChangePassword()));
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
