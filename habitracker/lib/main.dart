import 'package:flutter/material.dart';
import 'package:habitracker/global_variables.dart';
import 'package:habitracker/pages/main_page.dart';
import 'package:habitracker/theme.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FitPredict',
      home: const MainPage(),
      theme: AppTheme.themeData,
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
    );
  }
}
