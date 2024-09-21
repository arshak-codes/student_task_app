import 'package:flutter/material.dart';
import 'package:student_task_app/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return const MaterialApp(
      debugShowCheckedModeBanner: true,
      home: HomeScreen(),
      login: LoginScreen(),
    );
  }
}
