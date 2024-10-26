import 'package:habitracker/models/habit.dart';
import 'package:hive_flutter/hive_flutter.dart';

abstract class HabitDataSource {
  /// Salvar hábito no banco de dados
  void saveHabit(Habit habit);

  /// Obter um hábito pela key
  Habit? getHabit(String key);

  /// Obter todos os hábitos
  List<Habit> getAllHabits();

  /// Deletar um hábito pela key
  void deleteHabit(String key);
}

/// Classe que gerencia a persistência de hábitos
class HabitRepository implements HabitDataSource {
  @override
  void saveHabit(Habit habit) {
    var box = Hive.box<Habit>('habits');
    box.put(habit.key, habit);
  }

  @override
  Habit? getHabit(String key) {
    var box = Hive.box<Habit>('habits');
    return box.get(key);
  }

  @override
  List<Habit> getAllHabits() {
    var box = Hive.box<Habit>('habits');
    return box.values.toList();
  }

  @override
  void deleteHabit(String key) {
    var box = Hive.box<Habit>('habits');
    box.delete(key);
  }
}
