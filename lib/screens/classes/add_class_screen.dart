import 'package:flutter/material.dart';
import '../../services/class_service.dart';
import '../../core/current_user.dart';
import 'classes_screen.dart';

class AddClassScreen extends StatefulWidget {
  const AddClassScreen({super.key});

  @override
  State<AddClassScreen> createState() => _AddClassScreenState();
}

class _AddClassScreenState extends State<AddClassScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final ClassService _classService = ClassService();

  String _language = 'RU';
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Добавить класс'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Название класса (например 9А)',
                ),
                validator: (value) =>
                value == null || value.isEmpty ? 'Введите название' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _language,
                items: const [
                  DropdownMenuItem(value: 'RU', child: Text('Русский')),
                  DropdownMenuItem(value: 'KZ', child: Text('Казахский')),
                ],
                onChanged: (value) => setState(() => _language = value!),
                decoration: const InputDecoration(
                  labelText: 'Язык обучения',
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _loading ? null : _save,
                  child: _loading
                      ? const CircularProgressIndicator()
                      : const Text('Сохранить'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    final schoolId = CurrentUser.require.schoolId;


    await _classService.createClass(
      schoolId: schoolId,
      name: _nameController.text.trim(),
      language: _language,
    );

    if (mounted) {
      Navigator.pop(context);
    }
  }
}
