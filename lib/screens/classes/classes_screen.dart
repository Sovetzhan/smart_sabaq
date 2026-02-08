import 'package:flutter/material.dart';
import '../../services/class_service.dart';
import '../../models/class_model.dart';
import '../../core/current_user.dart';
import 'add_class_screen.dart';

class ClassesScreen extends StatelessWidget {
  ClassesScreen({super.key});

  final ClassService _classService = ClassService();

  @override
  Widget build(BuildContext context) {
    final schoolId = CurrentUser.require.schoolId;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Классы'),
      ),
      body: StreamBuilder<List<SchoolClass>>(
        stream: _classService.watchClasses(schoolId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Классов нет'));
          }

          final classes = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.only(bottom: 80),
            itemCount: classes.length,
            itemBuilder: (context, index) {
              final c = classes[index];

              return ListTile(
                title: Text(c.name),
                subtitle: Text('Язык: ${c.language}'),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddClassScreen()),
          );
        },
        label: const Text('Добавить класс'),
        icon: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
