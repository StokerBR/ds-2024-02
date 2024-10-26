import 'package:habitracker/models/habit.dart';
import 'package:habitracker/models/habit_goal.dart';

abstract class HabitTracker {
  void markHabitAsCompleted(Habit habit, DateTime date);
  bool checkGoal(Habit habit, HabitGoal goal);
}

class BasicHabitTracker implements HabitTracker {
  @override
  void markHabitAsCompleted(Habit habit, DateTime date) {
    habit.markAsCompleted(date);
  }

  @override
  bool checkGoal(Habit habit, HabitGoal goal) {
    return goal.isGoalAchieved(habit);
  }
}
