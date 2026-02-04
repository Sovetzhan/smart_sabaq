import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../models/lesson_plan_model.dart';
import '../../models/teacher.dart';
import '../../services/lesson_plan_service.dart';
import '../../services/teacher_service.dart';
import 'add_teacher_screen.dart';

class TeachersScreen extends StatelessWidget {
  TeachersScreen({super.key});

  final TeacherService _service = TeacherService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Штат')),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AddTeacherScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),

      body: StreamBuilder<List<Teacher>>(
        stream: _service.getTeachers(),
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
            return const Center(child: CircularProgressIndicator());
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
          /*Временно*/
          ElevatedButton(
            onPressed: () async {
              final plan = LessonPlan(
                id: const Uuid().v4(),
                schoolId: 'SCHOOL_ID_1',
                scheduleItemId: 'SCHEDULE_1',
                date: '2026-02-04',
                topic: 'Тестовый урок',
                fileUrl: 'fake_url',
                createdAt: DateTime.now(),
              );

              await LessonPlanService().create(plan);
            },
            child: const Text('CREATE LESSON PLAN'),
          );
          /*Временно*/

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
                  // позже: экран редактирования
                },
              );
            },
          );
        },
      ),
    );
  }
}
