import 'package:fidenz_assignment_quizapp/features/home_page.dart';
import 'package:flutter/material.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    // home page
    return const MaterialApp(home: HomePage());
  }
}
