import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:habitracker/functions/hex_color.dart';
import 'package:habitracker/global_variables.dart';
import 'package:habitracker/models/habit.dart';
import 'package:habitracker/pages/main_page.dart';
import 'package:habitracker/theme.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  // Inicia o Hive
  await Hive.initFlutter();
  Hive.registerAdapter(HabitAdapter());
  await Hive.openBox<Habit>('habits');

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Habitracker',
      home: const MainPage(),
      theme: AppTheme.themeData,
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
    );
  }
}
