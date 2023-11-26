import 'package:ess_assignment_project/init_app.dart';
import 'package:ess_assignment_project/view/screen/home_screen.dart';
import 'package:ess_assignment_project/view/screen/login_screen.dart';
import 'package:ess_assignment_project/view/screen/test.dart';
import 'package:flutter/material.dart';

void main() async {
  await initApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:  LoginScreen(),
    );
  }
}
