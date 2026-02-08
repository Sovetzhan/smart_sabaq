import 'package:cloud_firestore/cloud_firestore.dart';
import '../core/firestore_collections.dart';
import 'school_scoped_repository.dart';
import '../models/time_slot_model.dart';

class TimeSlotRepository {
  final SchoolScopedRepository _repo;

  TimeSlotRepository(this._repo);

  CollectionReference<Map<String, dynamic>> get _ref =>
      _repo.schoolCollection(FirestoreCollections.timeSlots);

  Future<void> create(TimeSlotModel slot) async {
    assert(slot.schoolId.isNotEmpty);
    assert(slot.order >= 0);
    assert(slot.startTime.isBefore(slot.endTime));

    final conflict = await _ref
        .where('order', isEqualTo: slot.order)
        .get();

    if (conflict.docs.isNotEmpty) {
      throw Exception('TimeSlot order already exists');
    }

    await _ref.add(slot.toMap());
  }

  Query<Map<String, dynamic>> all() {
    return _ref.orderBy('order');
  }
}
