import 'package:cloud_firestore/cloud_firestore.dart';
import '../core/firestore_collections.dart';
import '../models/time_slot_model.dart';
import 'school_scoped_repository.dart';

class TimeSlotRepository {
  final SchoolScopedRepository _repo;

  TimeSlotRepository(this._repo);

  DateTime _parseTime(String time) {
    return DateTime.parse('1970-01-01 $time:00');
  }

  Future<void> create(TimeSlot slot) async {
    if (slot.order < 0) {
      throw Exception('order must be >= 0');
    }

    final start = _parseTime(slot.startTime);
    final end = _parseTime(slot.endTime);

    if (!start.isBefore(end)) {
      throw Exception('startTime must be before endTime');
    }

    final conflict = await _repo
        .schoolQuery(FirestoreCollections.timeSlots)
        .where('order', isEqualTo: slot.order)
        .limit(1)
        .get();

    if (conflict.docs.isNotEmpty) {
      throw Exception('TimeSlot with this order already exists');
    }

    await _repo.create(
      FirestoreCollections.timeSlots,
      slot.toMap(),
    );
  }

  Query<Map<String, dynamic>> all() {
    return _repo
        .schoolQuery(FirestoreCollections.timeSlots)
        .orderBy('order');
  }
}
