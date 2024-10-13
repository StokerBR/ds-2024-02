# Aplicação dos Princípios SOLID no Habitracker

Aqui serão apresentados exemplos de como os princípios SOLID podem ser aplicados no projeto Habitracker. Cada princípio será explicado e exemplificado com trechos de código em Dart.

_Obs: Os exemplos são simplificados para ilustrar a aplicação dos princípios SOLID, e podem não representar a implementação completa do projeto._

## 1. Single Responsibility Principle (SRP) - Princípio da Responsabilidade Única

- **Aplicação no Habitracker**: Cada classe ou módulo deve ter uma única responsabilidade. No Habitracker, por exemplo:

  - A classe `Habit` será responsável apenas por gerenciar os dados relacionados a um hábito, como nome, descrição, ícone e cor.
  - A classe `HabitRepository` será responsável exclusivamente por salvar e carregar dados de hábitos no banco de dados local, sem interferir na lógica de negócios ou na interface do usuário.

  **Exemplo**:

  ```dart
  class Habit {
    String? key;
    String name;
    String? description;
    int icon;
    String color;

    Habit({this.key, this.name, this.description, this.icon, this.color});
  }

  class HabitRepository {

    static void saveHabit(Habit habit) {
        // Código para salvar hábito no banco de dados
    }

    static Habit? getHabit(String key) {
        // Código para obter um hábito pela key
        return habit;
    }

    static List<Habit> getAllHabits() {
        // Código para obter todos os hábitos
        return habits;
    }

    static void deleteHabit(String key) {
        // Código para deletar um hábito pela key
    }
  }
  ```

## 2. Open/Closed Principle (OCP) - Princípio Aberto/Fechado

- **Aplicação no Habitracker**: O sistema deve ser aberto para extensão, mas fechado para modificação. Isso significa que novas funcionalidades podem ser adicionadas sem alterar o código existente. No Habitracker:

  - A classe `HabitGoal` pode ser uma interface, permitindo a adição de novos tipos de metas (diárias, semanais, mensais) sem precisar modificar a lógica existente.

  **Exemplo**:

  ```dart
  abstract class HabitGoal {
    bool isGoalAchieved(Habit habit);
  }

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
  ```

## 3. Liskov Substitution Principle (LSP) - Princípio da Substituição de Liskov

- **Aplicação no Habitracker**: Classes derivadas devem poder substituir suas classes base sem afetar a corretude do programa. No Habitracker, diferentes tipos de hábitos podem ser tratados uniformemente, mesmo que tenham comportamentos específicos.

  - `TimeBasedHabit` e `TaskBasedHabit` podem substituir a classe base `Habit` sem afetar a lógica de acompanhamento de hábitos.

  **Exemplo**:

  ```dart
  class TimeBasedHabit extends Habit {
    Duration targetDuration;

    TimeBasedHabit(String name, DateTime creationDate, int goalPerWeek, this.targetDuration)
      : super(name, creationDate, goalPerWeek);

    void markAsCompleted(DateTime date, Duration duration) {
      if (duration >= targetDuration) {
        super.markAsCompleted(date);
      }
    }
  }

  class TaskBasedHabit extends Habit {
    int targetTasks;

    TaskBasedHabit(String name, DateTime creationDate, int goalPerWeek, this.targetTasks)
      : super(name, creationDate, goalPerWeek);

    void markAsCompleted(DateTime date, int tasksCompleted) {
      if (tasksCompleted >= targetTasks) {
        super.markAsCompleted(date);
      }
    }
  }
  ```

## 4. Interface Segregation Principle (ISP) - Princípio da Segregação de Interfaces

- **Aplicação no Habitracker**: Interfaces grandes e genéricas devem ser evitadas, sendo preferível dividir em interfaces menores e mais específicas. No Habitracker:

  - `HabitNotifier` e `HabitTracker` são interfaces separadas, uma para gerenciar notificações e outra para o acompanhamento de hábitos, evitando que uma classe precise implementar métodos que não usa.

  **Exemplo**:

  ```dart
  abstract class HabitNotifier {
    void notifyUser(Habit habit);
  }

  abstract class HabitTracker {
    void markHabitAsCompleted(Habit habit, DateTime date);
  }

  class BasicHabitTracker implements HabitTracker {
    @override
    void markHabitAsCompleted(Habit habit, DateTime date) {
      habit.markAsCompleted(date);
    }
  }

  class LocalHabitNotifier implements HabitNotifier {
    @override
    void notifyUser(Habit habit) {
      // Código para enviar uma notificação local
    }
  }
  ```

## 5. Dependency Inversion Principle (DIP) - Princípio da Inversão de Dependência

- **Aplicação no Habitracker**: Módulos de alto nível não devem depender de implementações de baixo nível, ambos devem depender de abstrações. No Habitracker:

  - O `HabitManager` depende da abstração `HabitDataSource`, e não diretamente de uma implementação específica como `LocalHabitDataSource`, o que permite a troca do repositório de dados sem impactar a lógica de negócios.

  **Exemplo**:

  ```dart
  abstract class HabitDataSource {
    void saveHabit(Habit habit);
    Habit loadHabit(String name);
  }

  class HabitManager {
    final HabitDataSource dataSource;

    HabitManager(this.dataSource);

    void saveHabit(Habit habit) {
      dataSource.saveHabit(habit);
    }

    Habit loadHabit(String name) {
      return dataSource.loadHabit(name);
    }
  }

  class LocalHabitDataSource implements HabitDataSource {
    @override
    void saveHabit(Habit habit) {
      // Salva hábito no banco de dados local
    }

    @override
    Habit loadHabit(String name) {
      // Carrega hábito do banco de dados local
      return Habit(name, DateTime.now(), 5);
    }
  }
  ```
