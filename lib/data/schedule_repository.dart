import 'package:cloud_firestore/cloud_firestore.dart';
import '../core/firestore_collections.dart';
import 'school_scoped_repository.dart';
import '../models/schedule_item_model.dart';

class ScheduleRepository {
  final SchoolScopedRepository _repo;

  ScheduleRepository(this._repo);

  CollectionReference<Map<String, dynamic>> get _ref =>
      _repo.schoolCollection(FirestoreCollections.scheduleItems);

  Future<void> create(ScheduleItem item) async {
    final conflict = await _ref
        .where('dayOfWeek', isEqualTo: item.dayOfWeek)
        .where('timeSlotId', isEqualTo: item.timeSlotId)
        .where(
      Filter.or(
        Filter('teacherId', isEqualTo: item.teacherId),
        Filter('classId', isEqualTo: item.classId),
      ),
    )
        .get();

    if (conflict.docs.isNotEmpty) {
      throw Exception('Schedule conflict');
    }

    await _ref.add(item.toMap());
  }

  Query<Map<String, dynamic>> byTeacherAndDay({
    required String teacherId,
    required int dayOfWeek,
  }) {
    return _ref
        .where('teacherId', isEqualTo: teacherId)
        .where('dayOfWeek', isEqualTo: dayOfWeek);
  }

  Query<Map<String, dynamic>> byClassAndDay({
    required String classId,
    required int dayOfWeek,
  }) {
    return _ref
        .where('classId', isEqualTo: classId)
        .where('dayOfWeek', isEqualTo: dayOfWeek);
  }
}
