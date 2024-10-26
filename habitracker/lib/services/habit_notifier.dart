import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:habitracker/models/habit.dart';
import 'package:habitracker/theme.dart';

abstract class HabitNotifier {
  void notifyUser(Habit habit);
}

class NotificationService implements HabitNotifier {
  @override
  void notifyUser(Habit habit) {
    FlutterLocalNotificationsPlugin().show(
      0,
      "Habitracker",
      "Não se esqueça de completar seu hábito ${habit.name}!",
      NotificationDetails(
        android: AndroidNotificationDetails(
          'habitracker_channel',
          'Habitracker',
          channelDescription: 'Habitracker notifications',
          importance: Importance.high,
          color: AppColors.primary,
          playSound: true,
          icon: 'app_icon',
        ),
        iOS: const DarwinNotificationDetails(
          presentSound: true,
          presentAlert: true,
          presentBadge: true,
        ),
      ),
    );
  }

  static final NotificationService _notificationService =
      NotificationService._internal();

  factory NotificationService() {
    return _notificationService;
  }

  NotificationService._internal();

  // Inicializa o serviço de notificação
  void init() async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    const DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings();
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }
}
