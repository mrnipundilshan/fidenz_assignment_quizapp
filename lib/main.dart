import 'package:fidenz_assignment_quizapp/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // load env variables
  await dotenv.load(fileName: ".env");
  print("API_BASE_URL = ${dotenv.env['API_BASE_URL']}");

  runApp(const MainApp());
}
