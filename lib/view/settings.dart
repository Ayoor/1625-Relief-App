
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:permission_handler/permission_handler.dart' as AppSettings;
import 'package:provider/provider.dart';
import 'package:relief_app/view/changepassword.dart';
import 'package:relief_app/viewmodel/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toastification/toastification.dart';
import 'package:relief_app/view/custom_widgets/delete_confirmation.dart';

import 'package:onesignal_flutter/onesignal_flutter.dart';
import '../viewmodel/authentication.dart';
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
  bool _isNotificationsEnabled = false;
  final Authentication authentication = Authentication();
  bool emailVerified = false;
  final AppProvider provider = AppProvider();

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
    OneSignal.initialize("8110724a-d13e-43f8-a58d-450454c49101");
    _checkNotificationPermission();
    _loadNotificationStatus();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      emailVerified = await isEmailVerification();
      setState(() {
        emailVerified = emailVerified;
      });
    });

  }

  Future<bool> isEmailVerification()async {
    bool isemailauth = false;
    String email = await provider.userEmail();
    await authentication.checkEmailExists(email);
    isemailauth = authentication.isEmailVerification;
    print ("isemail = $isemailauth");
    return isemailauth;
  }

  /// Load notification toggle status from SharedPreferences
  Future<void> _loadNotificationStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isNotificationsEnabled = prefs.getBool('notifications_enabled') ?? false;
    });
    print("Notification status loaded: $_isNotificationsEnabled");
    bool isSubscribed = await OneSignal.User.pushSubscription.optedIn??false;
    print("Notification subscription: $isSubscribed");
  }

  /// Save notification toggle status to SharedPreferences
  Future<void> _saveNotificationStatus(bool enabled) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications_enabled', enabled);
  }



  /// Show dialog prompting the user to enable notifications in settings
  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Enable Notifications"),
          content: Text("To receive notifications, please enable them in settings."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                openAppSettings(); // Open app settings
                Navigator.pop(context);
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
    // print("Notification permission: $hasPermission");

  }


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

                    // ListTile(
                    //   title: Text("Notifications", style: TextStyle(fontWeight: FontWeight.bold)),
                    //   trailing: Container(
                    //     width: 50,
                    //     padding: EdgeInsets.only(left: 20),
                    //     child: Transform.scale(
                    //       scale: 0.7,
                    //       child: Switch(
                    //         value: _isNotificationsEnabled,
                    //         onChanged: (value) => _toggleNotifications(value),
                    //       ),
                    //     ),
                    //   ),
                    // )
                    // Change Password
                    if(emailVerified)
                    ListTile(
                      trailing: const Icon(Icons.lock_rounded, color: Colors.grey),
                      title: const Text(
                        "Change Password",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onTap: () {
                        Navigator.push(
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
                                  color: Colors.white),
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
