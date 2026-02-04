import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/time_slot_model.dart';

class TimeSlotService {
  final _db = FirebaseFirestore.instance;

  Future<void> create(TimeSlot slot) async {
    await _db
        .collection('schools')
        .doc(slot.schoolId)
        .collection('timeSlots')
        .doc(slot.id)
        .set(slot.toMap());
  }

  Future<List<TimeSlot>> getAll(String schoolId) async {
    final snap = await _db
        .collection('schools')
        .doc(schoolId)
        .collection('timeSlots')
        .orderBy('order')
        .get();

    return snap.docs
        .map((d) => TimeSlot.fromMap(d.id, d.data()))
        .toList();
  }
}

