import 'package:flutter/material.dart';

import '../../core/current_user.dart';
import '../../models/schedule_item_model.dart';
import '../../services/schedule_service.dart';

class EditScheduleItemScreen extends StatefulWidget {
  final String classId;
  final String timeSlotId;
  final int dayOfWeek;
  final ScheduleItem? existing;

  const EditScheduleItemScreen({
    super.key,
    required this.classId,
    required this.timeSlotId,
    required this.dayOfWeek,
    this.existing,
  });

  @override
  State<EditScheduleItemScreen> createState() =>
      _EditScheduleItemScreenState();
}

class _EditScheduleItemScreenState extends State<EditScheduleItemScreen> {
  final _scheduleService = ScheduleService();

  final _subjectIdCtrl = TextEditingController();
  final _teacherIdCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.existing != null) {
      _subjectIdCtrl.text = widget.existing!.subjectId;
      _teacherIdCtrl.text = widget.existing!.teacherId;
    }
  }

  Future<void> _save() async {
    final user = CurrentUser.require;

    if (_subjectIdCtrl.text.isEmpty ||
        _teacherIdCtrl.text.isEmpty) {
      return;
    }

    if (widget.existing == null) {
      await _scheduleService.create(
        user,
        ScheduleItem(
          id: '',
          schoolId: user.schoolId,
          classId: widget.classId,
          timeSlotId: widget.timeSlotId,
          dayOfWeek: widget.dayOfWeek,
          subjectId: _subjectIdCtrl.text,
          teacherId: _teacherIdCtrl.text,
        ),
      );
    } else {
      await _scheduleService.update(
        user,
        ScheduleItem(
          id: widget.existing!.id,
          schoolId: widget.existing!.schoolId,
          classId: widget.existing!.classId,
          timeSlotId: widget.existing!.timeSlotId,
          dayOfWeek: widget.existing!.dayOfWeek,
          subjectId: _subjectIdCtrl.text,
          teacherId: _teacherIdCtrl.text,
        ),
      );
    }

    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Урок')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _subjectIdCtrl,
              decoration: const InputDecoration(
                labelText: 'subjectId',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _teacherIdCtrl,
              decoration: const InputDecoration(
                labelText: 'teacherId',
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _save,
                child: const Text('Сохранить'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
