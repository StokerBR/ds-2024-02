import 'package:habitracker/models/habit.dart';
import 'package:habitracker/models/habit_goal.dart';
import 'package:habitracker/services/habit_tracker.dart';
import 'package:habitracker/services/habit_notifier.dart';
import 'habit_data_source.dart';

class HabitManager {
  final HabitDataSource dataSource;
  final NotificationService notifier;
  final HabitTracker tracker;

  HabitManager(this.dataSource, this.notifier, this.tracker);

  /// Salva um hábito
  void saveHabit(Habit habit) {
    dataSource.saveHabit(habit);
  }

  /// Obtém um hábito pela key
  Habit? getHabit(String key) {
    return dataSource.getHabit(key);
  }

  /// Obtém todos os hábitos
  List<Habit> getAllHabits() {
    return dataSource.getAllHabits();
  }

  /// Deleta um hábito pela key
  void deleteHabit(String key) {
    dataSource.deleteHabit(key);
  }

  /// Notifica o usuário sobre um hábito
  void notifyHabit(Habit habit) {
    notifier.notifyUser(habit);
  }

  /// Marca um hábito como completo
  void markHabitAsCompleted(Habit habit, DateTime date) {
    tracker.markHabitAsCompleted(habit, date);
  }

  /// Verifica se um hábito atingiu uma meta
  bool checkGoal(Habit habit, HabitGoal goal) {
    return tracker.checkGoal(habit, goal);
  }
}
