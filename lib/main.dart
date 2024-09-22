import 'package:flutter/material.dart';
import 'package:student_task_app/home.dart' as home;
import 'package:student_task_app/login.dart' as login;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Set to false to remove debug banner
      initialRoute:
          '/login', // Set the initial route to login or home based on your logic
      routes: {
        '/login': (context) => const login.LoginScreen(),
        '/home': (context) => home.HomeScreen(),
      },
    );
  }
}
