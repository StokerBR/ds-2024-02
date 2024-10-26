import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'habit.g.dart';
// dart run build_runner build

/// Classe que representa um hábito
@HiveType(
    typeId: 1,
    adapterName:
        'HabitAdapter') // Os decorators do Hive (HiveType e HiveField) são necessários para serialização para o banco de dados
class Habit {
  @HiveField(0)
  String? key;
  @HiveField(1)
  String name;
  @HiveField(2)
  String? description;
  @HiveField(3)
  int icon;
  @HiveField(4)
  String color;
  @HiveField(5)
  List<DateTime> completedDays = [];

  Habit({
    this.key,
    required this.name,
    this.description,
    required this.icon,
    required this.color,
  }) : super() {
    // Se a key não for informada gera um uuid
    key ??= const Uuid().v4();
  }

  /// Marca o hábito como completado na data informada
  void markAsCompleted(DateTime date) {
    completedDays.add(date);
  }

  /// Construtor de habit a partir de um json
  factory Habit.fromJson(Map<String, dynamic> json) {
    return Habit(
      key: json['key'],
      name: json['name'],
      description: json['description'],
      icon: json['icon'],
      color: json['color'],
    );
  }

  /// Converte o habit para um json
  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'name': name,
      'description': description,
      'icon': icon,
      'color': color,
    };
  }
}

/// Hábito baseado em tempo
class TimeBasedHabit extends Habit {
  Duration targetDuration;

  TimeBasedHabit(String name, String description, String color, int icon,
      this.targetDuration)
      : super(
          name: name,
          description: description,
          color: color,
          icon: icon,
        );

  void markAsCompletedWithDuration(DateTime date, Duration duration) {
    if (duration >= targetDuration) {
      super.markAsCompleted(date);
    }
  }
}

/// Hábito baseado em tarefas
class TaskBasedHabit extends Habit {
  int targetTasks;

  TaskBasedHabit(
      String name, String description, String color, int icon, this.targetTasks)
      : super(
          name: name,
          description: description,
          color: color,
          icon: icon,
        );

  void markAsCompletedWithTasks(DateTime date, int tasksCompleted) {
    if (tasksCompleted >= targetTasks) {
      super.markAsCompleted(date);
    }
  }
}

/* 
Exemplo de hábitos
TODO: Adicionar esses hábitos no banco de dados ao iniciar o aplicativo pela primeira vez (seed)
List<Habit> habits = [
    Habit(
      name: 'Exercício',
      description: 'Fazer exercícios físicos',
      icon: '🏋️',
      color: Colors.red,
    ),
    Habit(
      name: 'Estudo',
      description: 'Estudar para a faculdade',
      icon: '📚',
      color: Colors.green,
    ),
    Habit(
      name: 'Leitura',
      description: 'Ler um livro',
      icon: '📖',
      color: Colors.purple,
    ),
    Habit(
      name: 'Meditação',
      description: 'Praticar meditação',
      icon: '🧘',
      color: Colors.orange,
    ),
    Habit(
      name: 'Hidratação',
      description: 'Beber água',
      icon: '💧',
      color: Colors.blue,
    ),
  ]
 */