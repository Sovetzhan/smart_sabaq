import 'package:flutter/material.dart';
import '../../models/teacher.dart';
import '../../services/teacher_service.dart';
import '../../services/subject_service.dart';
import '../subjects/subject_select_screen.dart';
import '../../core/current_user.dart';

class AddTeacherScreen extends StatefulWidget {
  @override
  State<AddTeacherScreen> createState() => _AddTeacherScreenState();
}

class _AddTeacherScreenState extends State<AddTeacherScreen> {
  final _formKey = GlobalKey<FormState>();
  final _teacherService = TeacherService();
  final _subjectService = SubjectService();

  final _lastName = TextEditingController();
  final _firstName = TextEditingController();
  final _middleName = TextEditingController();
  final _login = TextEditingController();

  /// Храним ТОЛЬКО id предметов
  List<String> _selectedSubjectIds = [];

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedSubjectIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Выберите хотя бы один предмет')),
      );
      return;
    }

    final teacher = Teacher(
      id: '',
      schoolId: CurrentUser.require.schoolId,
      lastName: _lastName.text.trim(),
      firstName: _firstName.text.trim(),
      middleName: _middleName.text.trim(),
      login: _login.text.trim(),
      subjectIds: _selectedSubjectIds,
    );

    await _teacherService.addTeacher(CurrentUser.require!, teacher);

    Navigator.pop(context);
  }

  Future<void> _openSubjectSelector() async {
    final result = await Navigator.push<List<String>>(
      context,
      MaterialPageRoute(
        builder: (_) => SubjectSelectScreen(
          schoolId: CurrentUser.require.schoolId,
          selected: _selectedSubjectIds,
        ),
      ),
    );

    if (result != null) {
      setState(() => _selectedSubjectIds = result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Добавить преподавателя')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _lastName,
                decoration: const InputDecoration(labelText: 'Фамилия'),
                validator: (v) => v!.isEmpty ? 'Обязательно' : null,
              ),
              TextFormField(
                controller: _firstName,
                decoration: const InputDecoration(labelText: 'Имя'),
                validator: (v) => v!.isEmpty ? 'Обязательно' : null,
              ),
              TextFormField(
                controller: _middleName,
                decoration: const InputDecoration(labelText: 'Отчество'),
              ),
              TextFormField(
                controller: _login,
                decoration: const InputDecoration(
                  labelText: 'Email или телефон',
                ),
                validator: (v) => v!.isEmpty ? 'Обязательно' : null,
              ),

              const SizedBox(height: 24),

              InkWell(
                onTap: _openSubjectSelector,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Предметы',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _selectedSubjectIds.isEmpty
                                  ? 'Не выбраны'
                                  : 'Выбрано: ${_selectedSubjectIds.length}',
                              style: TextStyle(
                                color: _selectedSubjectIds.isEmpty
                                    ? Colors.grey
                                    : Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right),
                    ],
                  ),
                ),
              ),
              ElevatedButton(onPressed: _save, child: const Text('Сохранить')),
            ],
          ),
        ),
      ),
    );
  }
}
