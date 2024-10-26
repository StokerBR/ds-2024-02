import 'package:flutter/material.dart';
import 'package:habitracker/functions/hex_color.dart';
import 'package:habitracker/models/habit.dart';
import 'package:habitracker/services/habit_data_source.dart';
import 'package:habitracker/theme.dart';
import 'package:habitracker/widgets/alert.dart';
import 'package:habitracker/widgets/input.dart';
import 'package:habitracker/widgets/input_label.dart';

class HabitFormPage extends StatefulWidget {
  const HabitFormPage({
    super.key,
    this.habitKey,
  });

  final String? habitKey;

  @override
  State<HabitFormPage> createState() => _HabitFormPageState();
}

class _HabitFormPageState extends State<HabitFormPage> {
  Habit? _habit;

  final _habitRepository = HabitRepository();

  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  IconData _selectedIcon = Icons.emoji_emotions_outlined;
  Color _selectedColor = AppTheme.themeData.primaryColor;

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (_habit == null) {
        _habit = Habit(
          name: _nameController.text,
          description: _descriptionController.text,
          icon: _selectedIcon.codePoint,
          color: _selectedColor.toHex(),
        );
      } else {
        _habit!.name = _nameController.text;
        _habit!.description = _descriptionController.text;
        _habit!.icon = _selectedIcon.codePoint;
        _habit!.color = _selectedColor.toHex();
      }

      // Salva o hábito
      _habitRepository.saveHabit(_habit!);

      Navigator.of(context).pop();

      showSuccess('Hábito salvo com sucesso');
    }
  }

  @override
  void initState() {
    if (widget.habitKey != null) {
      _habit = _habitRepository.getHabit(widget.habitKey!);
      if (_habit != null) {
        _nameController.text = _habit!.name;
        _descriptionController.text = _habit!.description ?? '';
        _selectedIcon = IconData(_habit!.icon, fontFamily: 'MaterialIcons');
        _selectedColor = HexColor.fromHex(_habit!.color);
      }
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${_habit == null ? 'Adicionar' : 'Editar'} hábito'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          behavior: HitTestBehavior.opaque,
          child: CustomScrollView(
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      CustomInput(
                        controller: _nameController,
                        maxLength: 50,
                        labelText: 'Nome',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, informe o nome do hábito';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      CustomInput(
                        controller: _descriptionController,
                        maxLength: 200,
                        labelText: 'Descrição (opcional)',
                      ),
                      const SizedBox(height: 20),
                      // TODO: Adicionar seleção de ícone e cor
                      const Text('Em breve: seleção de ícone e cor'),
                      const SizedBox(height: 10),
                      Stack(
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const InputLabel(
                                      'Ícone',
                                      alignment: Alignment.center,
                                    ),
                                    const SizedBox(height: 10),
                                    Icon(
                                      _selectedIcon,
                                      size: 50,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: Column(
                                  children: [
                                    const InputLabel(
                                      'Cor',
                                      alignment: Alignment.center,
                                    ),
                                    const SizedBox(height: 10),
                                    Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: _selectedColor,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Container(
                            height: 90,
                            decoration: BoxDecoration(
                              color: Colors.grey[100]!.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ],
                      ),
                      const Expanded(child: SizedBox(height: 20)),
                      ElevatedButton(
                        onPressed: _submitForm,
                        child: const Text('Salvar'),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
