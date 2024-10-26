# Aplicação dos Princípios SOLID no Habitracker

Aqui serão apresentados exemplos de como os princípios SOLID podem ser aplicados no projeto Habitracker. Cada princípio será explicado e exemplificado com trechos de código em Dart.

_Obs: Os exemplos são simplificados para ilustrar a aplicação dos princípios SOLID, e podem não representar a implementação completa do projeto._
_Após cada exemplo, será indicada a fonte (link para o arquivo no repositório do projeto) de cada código utilizado no exemplo._

## 1. Single Responsibility Principle (SRP) - Princípio da Responsabilidade Única

- **Aplicação no Habitracker**: Cada classe ou módulo deve ter uma única responsabilidade. No Habitracker, por exemplo:

  - A classe `Habit` será responsável apenas por gerenciar os dados relacionados a um hábito, como nome, descrição, ícone e cor.
  - A classe `HabitRepository` será responsável exclusivamente por salvar e carregar dados de hábitos no banco de dados local, sem interferir na lógica de negócios ou na interface do usuário.

  **Exemplo**:

  ```dart
  /* habit.dart */
  class Habit {
    String? key;
    String name;
    String? description;
    int icon;
    String color;
    List<DateTime> completedDays = [];

    Habit({this.key, this.name, this.description, this.icon, this.color});
  }

  /* habit_data_source.dart */
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

  - **Fontes:**

    - [habit.dart](../habitracker/lib/models/habit.dart#L12) (Classe `Habit`)
    - [habit_data_source.dart](../habitracker/lib/services/habit_data_source.dart#L19) (Classe `HabitRepository`)

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
      // Código para verificar se a meta semanal foi alcançada
    }
  }
  ```

  - **Fonte:**

    - [habit_goal.dart](../habitracker/lib/models/habit_goal.dart) (Interface `HabitGoal` e classe `WeeklyGoal`)

## 3. Liskov Substitution Principle (LSP) - Princípio da Substituição de Liskov

- **Aplicação no Habitracker**: Classes derivadas devem poder substituir suas classes base sem afetar a corretude do programa. No Habitracker, diferentes tipos de hábitos podem ser tratados uniformemente, mesmo que tenham comportamentos específicos.

  - `TimeBasedHabit` e `TaskBasedHabit` podem substituir a classe base `Habit` sem afetar a lógica de acompanhamento de hábitos.

  **Exemplo**:

  ```dart
  class TimeBasedHabit extends Habit {
    Duration targetDuration;

    TimeBasedHabit(/* parâmetros de Habit */, this.targetDuration)
      : super(/* parâmetros de Habit */);

    void markAsCompletedWithDuration(DateTime date, Duration duration) {
      if (duration >= targetDuration) {
        super.markAsCompleted(date);
      }
    }
  }

  class TaskBasedHabit extends Habit {
    int targetTasks;

    TaskBasedHabit(/* parâmetros de Habit */, this.targetTasks)
      : super(/* parâmetros de Habit */);

    void markAsCompletedWithTasks(DateTime date, int tasksCompleted) {
      if (tasksCompleted >= targetTasks) {
        super.markAsCompleted(date);
      }
    }
  }
  ```

  - **Fonte:**

    - [habit.dart](../habitracker/lib/models/habit.dart#L66) (Classes `TimeBasedHabit` e `TaskBasedHabit`)

## 4. Interface Segregation Principle (ISP) - Princípio da Segregação de Interfaces

- **Aplicação no Habitracker**: Interfaces grandes e genéricas devem ser evitadas, sendo preferível dividir em interfaces menores e mais específicas. No Habitracker:

  - `HabitNotifier` e `HabitTracker` são interfaces separadas, uma para gerenciar notificações e outra para o acompanhamento de hábitos, evitando que uma classe precise implementar métodos que não usa.

  **Exemplo**:

  ```dart
  /* habit_notifier.dart */
  abstract class HabitNotifier {
    void notifyUser(Habit habit);
  }

  class NotificationService implements HabitNotifier {
    @override
    void notifyUser(Habit habit) {
      // Código para enviar uma notificação local
    }

    /* Outros métodos do NotificationService */
  }

  /* habit_tracker.dart */
  abstract class HabitTracker {
    void markHabitAsCompleted(Habit habit, DateTime date);
    bool checkGoal(Habit habit, HabitGoal goal);
  }

  class BasicHabitTracker implements HabitTracker {
    @override
    void markHabitAsCompleted(Habit habit, DateTime date) {
      // Código para marcar hábito como concluído
    }

    @override
    bool checkGoal(Habit habit, HabitGoal goal) {
      // Código para verificar se a meta do hábito foi alcançada
    }
  }
  ```

  - **Fontes:**

    - [habit_notifier.dart](../habitracker/lib/services/habit_notifier.dart) (Interface `HabitNotifier` e classe `NotificationService`)
    - [habit_tracker.dart](../habitracker/lib/services/habit_tracker.dart) (Interface `HabitTracker` e classe `BasicHabitTracker`)

## 5. Dependency Inversion Principle (DIP) - Princípio da Inversão de Dependência

- **Aplicação no Habitracker**: Módulos de alto nível não devem depender de implementações de baixo nível, ambos devem depender de abstrações. No Habitracker:

  - O `HabitManager` depende da abstração `HabitDataSource`, e não diretamente de uma implementação específica como `HabitRepository`, o que permite a troca do repositório de dados sem impactar a lógica de negócios.

  **Exemplo**:

  ```dart
  /* habit_manager.dart */
  class HabitManager {
    final HabitDataSource dataSource;

    HabitManager(this.dataSource);

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

    /* Outros métodos do HabitManager */
  }

  /* habit_data_source.dart */
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

  class HabitRepository implements HabitDataSource {
    @override
    void saveHabit(Habit habit) {
      // Código para salvar hábito no banco de dados
    }

    @override
    Habit? getHabit(String key) {
      // Código para obter um hábito pela key
    }

    @override
    List<Habit> getAllHabits() {
      // Código para obter todos os hábitos
    }

    @override
    void deleteHabit(String key) {
      // Código para deletar um hábito pela key
    }
  }
  ```

  - **Fontes:**

    - [habit_manager.dart](../habitracker/lib/services/habit_manager.dart) (Classe `HabitManager`)
    - [habit_data_source.dart](../habitracker/lib/services/habit_data_source.dart) (Interface `HabitDataSource` e classe `HabitRepository`)
