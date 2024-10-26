import 'package:habitracker/models/habit.dart';

/// Classe que representa uma meta de hábito
abstract class HabitGoal {
  /// Verifica se a meta foi alcançada
  bool isGoalAchieved(Habit habit);
}

/// Meta de hábito diária
class WeeklyGoal implements HabitGoal {
  int targetDays;

  WeeklyGoal(this.targetDays);

  @override
  bool isGoalAchieved(Habit habit) {
    DateTime now = DateTime.now();
    int completedThisWeek = habit.completedDays
        .where((date) =>
            date.isAfter(now.subtract(Duration(days: now.weekday))) &&
            date.isBefore(now.add(Duration(days: 7 - now.weekday))))
        .length;

    return completedThisWeek >= targetDays;
  }
}
