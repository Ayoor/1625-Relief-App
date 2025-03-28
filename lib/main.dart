import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'package:relief_app/view/signin.dart';
import 'package:relief_app/view/widgets/splashscreen.dart';
import 'package:relief_app/viewmodel/provider.dart';
import 'package:relief_app/viewmodel/theme.dart';
import 'package:firebase_admin/firebase_admin.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // OneSignal.Debug.setLogLevel(OSLogLevel.verbose);

  // Initialize OneSignal with the correct App ID
  OneSignal.initialize("8110724a-d13e-43f8-a58d-450454c49101");
  OneSignal.consentRequired(true);


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

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
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
