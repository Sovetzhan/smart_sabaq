import 'package:flutter/material.dart';

class AdminScheduleScreen extends StatefulWidget {
  final String schoolId;

  const AdminScheduleScreen({super.key, required this.schoolId});

  @override
  State<AdminScheduleScreen> createState() => _AdminScheduleScreenState();
}

class _AdminScheduleScreenState extends State<AdminScheduleScreen> {
  int selectedDayOfWeek = DateTime.monday;
  String? selectedClassId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Расписание'),
      ),
      body: Column(
        children: [
          _daySelector(),
          _classSelector(),
          const Divider(),
          Expanded(child: _scheduleGrid()),
        ],
      ),
    );
  }

  Widget _daySelector() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: DropdownButton<int>(
        value: selectedDayOfWeek,
        isExpanded: true,
        items: const [
          DropdownMenuItem(value: 1, child: Text('Понедельник')),
          DropdownMenuItem(value: 2, child: Text('Вторник')),
          DropdownMenuItem(value: 3, child: Text('Среда')),
          DropdownMenuItem(value: 4, child: Text('Четверг')),
          DropdownMenuItem(value: 5, child: Text('Пятница')),
          DropdownMenuItem(value: 6, child: Text('Суббота')),
        ],
        onChanged: (v) => setState(() => selectedDayOfWeek = v!),
      ),
    );
  }

  Widget _classSelector() {
    // заглушка, schoolId уже есть: widget.schoolId
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: DropdownButton<String>(
        hint: const Text('Выбери класс'),
        isExpanded: true,
        value: selectedClassId,
        items: const [],
        onChanged: (v) => setState(() => selectedClassId = v),
      ),
    );
  }

  Widget _scheduleGrid() {
    if (selectedClassId == null) {
      return const Center(child: Text('Выбери класс'));
    }

    return const Center(
      child: Text('Здесь будет таблица расписания'),
    );
  }
}
