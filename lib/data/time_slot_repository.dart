import 'package:cloud_firestore/cloud_firestore.dart';
import '../core/firestore_collections.dart';
import 'school_scoped_repository.dart';
import '../models/time_slot_model.dart';

class TimeSlotRepository {
  final SchoolScopedRepository _repo;

  TimeSlotRepository(this._repo);

  CollectionReference<Map<String, dynamic>> get _ref =>
      _repo.schoolCollection(FirestoreCollections.timeSlots);

  DateTime _parseTime(String time) {
    // ожидается формат HH:mm
    return DateTime.parse('1970-01-01 $time:00');
  }

  Future<void> create(TimeSlot slot) async {
    if (slot.schoolId.isEmpty) {
      throw Exception('schoolId is required');
    }

    if (slot.order < 0) {
      throw Exception('order must be >= 0');
    }

    final start = _parseTime(slot.startTime);
    final end = _parseTime(slot.endTime);

    if (!start.isBefore(end)) {
      throw Exception('startTime must be before endTime');
    }

    final conflict = await _ref
        .where('schoolId', isEqualTo: slot.schoolId)
        .where('order', isEqualTo: slot.order)
        .limit(1)
        .get();

    if (conflict.docs.isNotEmpty) {
      throw Exception('TimeSlot with this order already exists');
    }

    await _ref.add(slot.toMap());
  }

  Query<Map<String, dynamic>> all({required String schoolId}) {
    return _ref
        .where('schoolId', isEqualTo: schoolId)
        .orderBy('order');
  }
}
