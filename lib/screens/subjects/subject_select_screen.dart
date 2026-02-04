import 'package:flutter/material.dart';
import '../../models/subject_model.dart';
import '../../services/subject_service.dart';

class SubjectSelectScreen extends StatefulWidget {
  final String schoolId;
  final List<String> selected; // ← ВАЖНО: List<String>

  const SubjectSelectScreen({
    super.key,
    required this.schoolId,
    required this.selected,
  });

  @override
  State<SubjectSelectScreen> createState() => _SubjectSelectScreenState();
}

class _SubjectSelectScreenState extends State<SubjectSelectScreen> {
  final _service = SubjectService();
  late Set<String> _selectedIds;

  @override
  void initState() {
    super.initState();
    _selectedIds = widget.selected.toSet();
  }

  void _toggle(Subject subject) {
    setState(() {
      if (_selectedIds.contains(subject.id)) {
        _selectedIds.remove(subject.id);
      } else {
        _selectedIds.add(subject.id);
      }
    });
  }

  Future<void> _createSubject() async {
    final controller = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Новый предмет'),
          content: TextField(
            controller: controller,
            decoration:
            const InputDecoration(hintText: 'Например: Математика'),
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
                  await _service.createSubject(
                    schoolId: widget.schoolId,
                    name: name,
                  );
                  Navigator.pop(context);
                } catch (_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Предмет уже существует')),
                  );
                }
              },
              child: const Text('Создать'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Выбор предметов'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(
              context,
              _selectedIds.toList(), // ← ВОЗВРАЩАЕМ List<String>
            ),
            child: const Text(
              'Готово',
              style: TextStyle(color: Colors.blue),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<Subject>>(
              stream: _service.watchSubjects(widget.schoolId),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Ошибка: ${snapshot.error}'),
                  );
                }

                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final subjects = snapshot.data!;

                if (subjects.isEmpty) {
                  return const Center(child: Text('Предметов нет'));
                }

                return ListView.builder(
                  itemCount: subjects.length,
                  itemBuilder: (context, index) {
                    final subject = subjects[index];
                    final checked =
                    _selectedIds.contains(subject.id);

                    return CheckboxListTile(
                      value: checked,
                      title: Text(subject.name),
                      onChanged: (_) => _toggle(subject),
                    );
                  },
                );
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _createSubject,
                child: const Text('Создать предмет'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
