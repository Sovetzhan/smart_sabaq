import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../models/subject_model.dart';
import '../../services/subject_service.dart';

class SubjectListScreen extends StatelessWidget {
  final String schoolId;

  const SubjectListScreen({super.key, required this.schoolId});

  @override
  Widget build(BuildContext context) {
    final service = SubjectService();

    return Scaffold(
      appBar: AppBar(title: const Text('Предметы')),
      body: StreamBuilder<List<Subject>>(
        stream: service.watchSubjects(schoolId),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Ошибка: ${snapshot.error}'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }


          final subjects = snapshot.data!;

          if (subjects.isEmpty) {
            return const Center(child: Text('Предметов нет'));
          }

          return ListView.builder(
            itemCount: subjects.length,
            itemBuilder: (context, index) {
              final subject = subjects[index];
              return ListTile(
                title: Text(subject.name),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context, service),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddDialog(BuildContext context, SubjectService service) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Новый предмет'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: 'Например: Математика',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Отмена'),
            ),
            ElevatedButton(
              onPressed: () async {
                final name = controller.text.trim();
                if (name.isEmpty) return;

                try {
                  await service.createSubject(
                    schoolId: 'school_001',
                    name: name,
                  );
                  Navigator.pop(context);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Предмет уже существует')),
                  );
                }
              },
              child: const Text('Сохранить'),
            ),
          ],
        );
      },
    );
  }
}