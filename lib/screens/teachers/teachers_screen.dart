import 'package:flutter/material.dart';

import '../../core/current_user.dart';
import '../../core/user_context.dart';
import '../../core/user_role.dart';

import '../../models/teacher.dart';
import '../../services/teacher_service.dart';
import 'add_teacher_screen.dart';

class TeachersScreen extends StatelessWidget {
  TeachersScreen({super.key});

  final TeacherService _service = TeacherService();

  @override
  Widget build(BuildContext context) {
    final UserContext user = CurrentUser.user!;

    // ❌ Учитель не имеет права видеть штат
    if (user.role != UserRole.admin) {
      return const Scaffold(
        body: Center(
          child: Text(
            'Доступ запрещён',
            style: TextStyle(fontSize: 16),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Штат'),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddTeacherScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),

      body: StreamBuilder<List<Teacher>>(
        stream: _service.getTeachers(user),
        builder: (context, snapshot) {
          // 1. Ошибка
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Ошибка загрузки: ${snapshot.error}',
                textAlign: TextAlign.center,
              ),
            );
          }

          // 2. Загрузка
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // 3. Данные
          final teachers = snapshot.data ?? [];

          // 4. Пусто
          if (teachers.isEmpty) {
            return const Center(
              child: Text(
                'Преподаватели не добавлены',
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          // 5. Список
          return ListView.separated(
            itemCount: teachers.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final teacher = teachers[index];

              return ListTile(
                title: Text(
                  '${teacher.lastName} ${teacher.firstName}',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Text(teacher.login),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // позже: экран редактирования преподавателя
                },
              );
            },
          );
        },
      ),
    );
  }
}
