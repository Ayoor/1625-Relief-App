import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:relief_app/services/notifications.dart';
import 'package:relief_app/view/signin.dart';
import 'package:relief_app/view/widgets/splashscreen.dart';
import 'package:relief_app/viewmodel/provider.dart';
import 'package:relief_app/viewmodel/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Notifications().initNotifications();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AppProvider()),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: '1625 Relief',
        theme: ThemeData.light(),  // Light Theme
        darkTheme: ThemeData.dark(),  // Dark Theme
        themeMode: themeProvider.themeMode, // Apply Theme Mode
        home: AnimatedSplashScreen(
          splashIconSize: MediaQuery.of(context).size.height,
          splash: const Splashscreen(),
          duration: 5000,
          centered: true,
          backgroundColor: Theme.of(context).colorScheme.surface,
          animationDuration: const Duration(seconds: 2),
          nextScreen: const Signin(),
        ),
      ),
    );
  }
}
