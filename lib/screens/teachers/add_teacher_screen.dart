import 'package:flutter/material.dart';
import '../../app_config.dart';
import '../../models/subject.dart';
import '../../models/teacher.dart';
import '../../services/subject_service.dart';
import '../../services/teacher_service.dart';

import '../../services/subject_service.dart';
import '../../models/subject.dart';


class AddTeacherScreen extends StatefulWidget {
  @override
  State<AddTeacherScreen> createState() => _AddTeacherScreenState();
}

class _AddTeacherScreenState extends State<AddTeacherScreen> {

  final _formKey = GlobalKey<FormState>();
  final _service = TeacherService();

  final _lastName = TextEditingController();
  final _firstName = TextEditingController();
  final _middleName = TextEditingController();
  final _login = TextEditingController();

  final SubjectService _subjectService = SubjectService();
  List<Subject> _subjects = [];
  List<String> _selectedSubjectIds = [];


  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final teacher = Teacher(
      id: '',
      schoolId: schoolId,
      lastName: _lastName.text.trim(),
      firstName: _firstName.text.trim(),
      middleName: _middleName.text.trim(),
      login: _login.text.trim(),
      subjectIds: _selectedSubjectIds,
    );

    await _service.addTeacher(teacher);
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();

    _subjectService.getSubjects().listen((list) {
      setState(() {
        _subjects = list;
      });
    });
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
                decoration:
                const InputDecoration(labelText: 'Email или телефон'),
                validator: (v) => v!.isEmpty ? 'Обязательно' : null,
              ),
              const SizedBox(height: 16),
              const Text(
                'Предметы',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),

              ..._subjects.map((s) {
                final selected = _selectedSubjectIds.contains(s.id);

                return CheckboxListTile(
                  title: Text(s.name),
                  value: selected,
                  onChanged: (value) {
                    setState(() {
                      if (value == true) {
                        _selectedSubjectIds.add(s.id);
                      } else {
                        _selectedSubjectIds.remove(s.id);
                      }
                    });
                  },
                );
              }).toList(),
              TextButton(
                onPressed: () async {
                  final controller = TextEditingController();

                  final result = await showDialog<String>(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('Новый предмет'),
                      content: TextField(
                        controller: controller,
                        decoration: const InputDecoration(hintText: 'Название предмета'),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Отмена'),
                        ),
                        TextButton(
                          onPressed: () =>
                              Navigator.pop(context, controller.text),
                          child: const Text('Добавить'),
                        ),
                      ],
                    ),
                  );

                  if (result != null && result.trim().isNotEmpty) {
                    final subjectId =
                    await _subjectService.createOrGetSubject(result);

                    setState(() {
                      _selectedSubjectIds.add(subjectId);
                    });
                  }
                },
                child: const Text('+ Добавить предмет'),
              ),

              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _save,
                child: const Text('Сохранить'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
