import 'package:flutter/material.dart';
import 'package:habitracker/functions/hex_color.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'habit.g.dart';
// dart run build_runner build

/**
 * Aplicação dos princípios SOLID neste arquivo:
 *  - Single Responsibility Principle (SRP): 
 *    Responsabilidades separadas em classes diferentes. 
 *    Habit é responsável por gerenciar o estado e representar um hábito e HabitRepository é responsável por lidar com a persistência de dados.
 */

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
  String icon;
  @HiveField(4)
  Color color;

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

  // Construtor de habit a partir de um json
  factory Habit.fromJson(Map<String, dynamic> json) {
    return Habit(
      key: json['key'],
      name: json['name'],
      description: json['description'],
      icon: json['icon'],
      color: HexColor.fromHex(json['color']),
    );
  }

  // Converte o habit para um json
  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'name': name,
      'description': description,
      'icon': icon,
      'color': color.toHex(),
    };
  }
}

/// Classe que gerencia a persistência de hábitos
class HabitRepository {
  // Salvar hábito no banco de dados
  void saveHabit(Habit habit) {
    var box = Hive.box<Habit>('habits');
    box.put(habit.key, habit);
  }

  // Obter um hábito pela key
  Habit? getHabit(String key) {
    var box = Hive.box<Habit>('habits');
    return box.get(key);
  }

  // Obter todos os hábitos
  List<Habit> getAllHabits() {
    var box = Hive.box<Habit>('habits');
    return box.values.toList();
  }

  // Deletar um hábito pela key
  void deleteHabit(String key) {
    var box = Hive.box<Habit>('habits');
    box.delete(key);
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