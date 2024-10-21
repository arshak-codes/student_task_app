import 'package:flutter/material.dart';
import 'package:student_task_app/home.dart' as home;
import 'package:student_task_app/login.dart' as login;
import 'package:student_task_app/splash_screen.dart' as splash;
import 'package:student_task_app/profile.dart' as profile;
import 'package:student_task_app/study.dart' as study;
void main() {
  WidgetsFlutterBinding.ensureInitialized(); // Initialize bindings
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Remove debug banner
      initialRoute: '/splash', // Set initial route to SplashScreen
      routes: {
        '/splash': (context) => splash.SplashScreen(), // SplashScreen route
        '/login': (context) => const login.LoginScreen(), // LoginScreen route
        '/home': (context) => home.HomeScreen(), // HomeScreen route
        '/profile': (context) => profile.ProfileScreen(),
        '/study':(context) =>study.StudyScreen(),
      },
    );
  }
}
