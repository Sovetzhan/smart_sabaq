import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/schedule_item_model.dart';

class ScheduleService {
  final _db = FirebaseFirestore.instance;

  Future<void> create(ScheduleItem item) async {
    await _db
        .collection('schools')
        .doc(item.schoolId)
        .collection('scheduleItems')
        .doc(item.id)
        .set(item.toMap());
  }

  Future<List<ScheduleItem>> getByTeacher({
    required String schoolId,
    required String teacherId,
    required int dayOfWeek,
  }) async {
    final snap = await _db
        .collection('schools')
        .doc(schoolId)
        .collection('scheduleItems')
        .where('teacherId', isEqualTo: teacherId)
        .where('dayOfWeek', isEqualTo: dayOfWeek)
        .get();

    return snap.docs
        .map((d) => ScheduleItem.fromMap(d.id, d.data()))
        .toList();
  }
}
