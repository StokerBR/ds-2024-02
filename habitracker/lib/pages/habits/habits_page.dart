import 'package:flutter/material.dart';
import 'package:habitracker/functions/hex_color.dart';
import 'package:habitracker/models/habit.dart';
import 'package:habitracker/pages/habits/habit_form_page.dart';
import 'package:habitracker/services/habit_data_source.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HabitsPage extends StatefulWidget {
  const HabitsPage({super.key});

  @override
  State<HabitsPage> createState() => _HabitsPageState();
}

class _HabitsPageState extends State<HabitsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hábitos'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const HabitFormPage(),
            ),
          );
        },
        tooltip: 'Adicionar hábito',
        child: const Icon(Icons.add),
      ),
      body: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: ValueListenableBuilder(
              valueListenable: Hive.box<Habit>('habits').listenable(),
              builder: (context, Box<Habit> box, _) {
                if (box.isEmpty) {
                  return const Center(
                    child: Text(
                        'Nenhum hábito cadastrado.\nClique no + para criar um novo!',
                        textAlign: TextAlign.center),
                  );
                }
                return Column(
                  children: box.values.map((habit) {
                    return ListTile(
                      title: Text(habit.name),
                      subtitle: Text(
                        habit.description ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.grey[800], fontSize: 14),
                      ),
                      leading: Icon(
                        IconData(habit.icon, fontFamily: 'MaterialIcons'),
                        color: HexColor.fromHex(habit.color),
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      splashColor: Colors.grey[200],
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                HabitFormPage(habitKey: habit.key),
                          ),
                        );
                      },
                      onLongPress: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Deletar hábito'),
                              content: Text(
                                  'Tem certeza que deseja deletar o hábito ${habit.name}?'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Cancelar'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    HabitRepository().deleteHabit(habit.key!);
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Deletar'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
