import 'package:flutter/material.dart';
import '../../app_config.dart';
import '../../models/teacher.dart';
import '../../services/teacher_service.dart';

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

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final teacher = Teacher(
      id: '',
      schoolId: schoolId,
      lastName: _lastName.text.trim(),
      firstName: _firstName.text.trim(),
      middleName: _middleName.text.trim(),
      login: _login.text.trim(),
      subjectIds: [],
    );

    await _service.addTeacher(teacher);
    Navigator.pop(context);
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
