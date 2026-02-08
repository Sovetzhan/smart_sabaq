import 'package:cloud_firestore/cloud_firestore.dart';
import '../core/firestore_collections.dart';
import 'school_scoped_repository.dart';
import '../models/schedule_item_model.dart';

class ScheduleRepository {
  final SchoolScopedRepository _repo;

  ScheduleRepository(this._repo);

  Query<Map<String, dynamic>> get _query =>
      _repo.schoolQuery(FirestoreCollections.scheduleItems);

  Future<void> create(ScheduleItem item) async {
    final conflict = await _query
        .where('dayOfWeek', isEqualTo: item.dayOfWeek)
        .where('timeSlotId', isEqualTo: item.timeSlotId)
        .where(
      Filter.or(
        Filter('teacherId', isEqualTo: item.teacherId),
        Filter('classId', isEqualTo: item.classId),
      ),
    )
        .limit(1)
        .get();

    if (conflict.docs.isNotEmpty) {
      throw Exception('Schedule conflict');
    }

    await _repo.create(
      FirestoreCollections.scheduleItems,
      item.toMap(),
    );
  }

  Query<Map<String, dynamic>> byTeacherAndDay({
    required String teacherId,
    required int dayOfWeek,
  }) {
    return _query
        .where('teacherId', isEqualTo: teacherId)
        .where('dayOfWeek', isEqualTo: dayOfWeek);
  }

  Query<Map<String, dynamic>> byClassAndDay({
    required String classId,
    required int dayOfWeek,
  }) {
    return _query
        .where('classId', isEqualTo: classId)
        .where('dayOfWeek', isEqualTo: dayOfWeek);
  }
}
