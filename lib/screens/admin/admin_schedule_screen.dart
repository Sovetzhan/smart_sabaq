import 'package:flutter/material.dart';

class AdminScheduleScreen extends StatefulWidget {
  const AdminScheduleScreen({super.key});

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
          _DaySelector(),
          _ClassSelector(),
          const Divider(),
          Expanded(child: _ScheduleGrid()),
        ],
      ),
    );
  }

  Widget _DaySelector() {
    return DropdownButton<int>(
      value: selectedDayOfWeek,
      items: const [
        DropdownMenuItem(value: 1, child: Text('Понедельник')),
        DropdownMenuItem(value: 2, child: Text('Вторник')),
        DropdownMenuItem(value: 3, child: Text('Среда')),
        DropdownMenuItem(value: 4, child: Text('Четверг')),
        DropdownMenuItem(value: 5, child: Text('Пятница')),
        DropdownMenuItem(value: 6, child: Text('Суббота')),
      ],
      onChanged: (v) => setState(() => selectedDayOfWeek = v!),
    );
  }

  Widget _ClassSelector() {
    // временно заглушка
    return DropdownButton<String>(
      hint: const Text('Выбери класс'),
      value: selectedClassId,
      items: const [],
      onChanged: (v) => setState(() => selectedClassId = v),
    );
  }

  Widget _ScheduleGrid() {
    if (selectedClassId == null) {
      return const Center(child: Text('Выбери класс'));
    }

    return const Center(
      child: Text('Здесь будет таблица расписания'),
    );
  }
}
