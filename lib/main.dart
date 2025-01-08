import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:relief_app/view/signin.dart';
import 'package:relief_app/viewmodel/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(ChangeNotifierProvider(
    create: (context) => AppProvider(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '1625 Relief',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // home: AnimatedSplashScreen(
      //     splashIconSize: MediaQuery.of(context).size.height / 3,
      //     splash: const Splashscreen(),
      //     duration: 5000,
      //     centered: true,
      //     backgroundColor: Colors.white,
      //     animationDuration: const Duration(seconds: 2),
      //     nextScreen: const BottomNavigation(title: "1625 Relief")),
      home: Signin(),
    );
  }
}
