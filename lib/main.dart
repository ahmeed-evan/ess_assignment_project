import 'package:ess_assignment_project/init_app.dart';
import 'package:ess_assignment_project/utils.dart';
import 'package:ess_assignment_project/view/screen/home_screen.dart';
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
      theme: themeData,
      home:  HomeScreen(),
    );
  }
}
