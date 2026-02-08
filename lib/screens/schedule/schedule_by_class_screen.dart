import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/current_user.dart';
import '../../models/class_model.dart';
import '../../models/schedule_item_model.dart';
import '../../models/time_slot_model.dart';
import '../../services/class_service.dart';
import '../../services/schedule_service.dart';
import '../../services/time_slot_service.dart';
import 'edit_schedule_item_screen.dart';

class ScheduleByClassScreen extends StatefulWidget {
  const ScheduleByClassScreen({super.key});

  @override
  State<ScheduleByClassScreen> createState() => _ScheduleByClassScreenState();
}

class _ScheduleByClassScreenState extends State<ScheduleByClassScreen> {
  final _classService = ClassService();
  final _scheduleService = ScheduleService();
  final _timeSlotService = TimeSlotService();

  SchoolClass? selectedClass;
  int selectedDay = 1;

  List<SchoolClass> classes = [];
  List<TimeSlot> timeSlots = [];
  List<ScheduleItem> scheduleItems = [];

  bool loading = true;

  late StreamSubscription _classSub;

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void dispose() {
    _classSub.cancel();
    super.dispose();
  }

  Future<void> _init() async {
    final user = CurrentUser.require;

    timeSlots = await _timeSlotService.getAll(user.schoolId);
    timeSlots.sort((a, b) => a.order.compareTo(b.order));

    _classSub =
        _classService.watchClasses(user.schoolId).listen((data) {
          setState(() {
            classes = data;
            loading = false;
          });
        });
  }

  Future<void> _loadSchedule() async {
    if (selectedClass == null) return;

    final user = CurrentUser.require;

    scheduleItems = await _scheduleService.getByClass(
      user: user,
      classId: selectedClass!.id,
      dayOfWeek: selectedDay,
    );

    setState(() {});
  }

  ScheduleItem? _itemForSlot(TimeSlot slot) {
    for (final item in scheduleItems) {
      if (item.timeSlotId == slot.id) {
        return item;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Расписание по классу')),
      body: Column(
        children: [
          _selectors(),
          const Divider(),
          Expanded(child: _table()),
        ],
      ),
    );
  }

  Widget _selectors() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          DropdownButtonFormField<SchoolClass>(
            hint: const Text('Класс'),
            value: selectedClass,
            items: classes
                .map(
                  (c) => DropdownMenuItem(
                value: c,
                child: Text(c.name),
              ),
            )
                .toList(),
            onChanged: (v) {
              setState(() => selectedClass = v);
              _loadSchedule();
            },
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<int>(
            value: selectedDay,
            items: const [
              DropdownMenuItem(value: 1, child: Text('Понедельник')),
              DropdownMenuItem(value: 2, child: Text('Вторник')),
              DropdownMenuItem(value: 3, child: Text('Среда')),
              DropdownMenuItem(value: 4, child: Text('Четверг')),
              DropdownMenuItem(value: 5, child: Text('Пятница')),
              DropdownMenuItem(value: 6, child: Text('Суббота')),
            ],
            onChanged: (v) {
              if (v == null) return;
              setState(() => selectedDay = v);
              _loadSchedule();
            },
          ),
        ],
      ),
    );
  }

  Widget _table() {
    if (selectedClass == null) {
      return const Center(child: Text('Выберите класс'));
    }

    return ListView.builder(
      itemCount: timeSlots.length,
      itemBuilder: (context, index) {
        final slot = timeSlots[index];
        final item = _itemForSlot(slot);

        return ListTile(
          title: Text('${slot.startTime} – ${slot.endTime}'),
          subtitle: item == null
              ? const Text('— нет урока')
              : Text(
            'subjectId: ${item.subjectId}\nteacherId: ${item.teacherId}',
          ),
          trailing: const Icon(Icons.edit),
          onTap: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => EditScheduleItemScreen(
                  classId: selectedClass!.id,
                  timeSlotId: slot.id,
                  dayOfWeek: selectedDay,
                  existing: item,
                ),
              ),
            );

            _loadSchedule();
          },
        );
      },
    );
  }
}
