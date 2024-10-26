import 'package:flutter/material.dart';
import 'package:habitracker/global_variables.dart';
import 'package:habitracker/models/habit.dart';
import 'package:habitracker/pages/main_page.dart';
import 'package:habitracker/services/habit_notifier.dart';
import 'package:habitracker/theme.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  // Inicia o Hive
  await Hive.initFlutter();
  Hive.registerAdapter(HabitAdapter());
  await Hive.openBox<Habit>('habits');

  // Inicializa o serviço de notificação
  NotificationService().init();

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
