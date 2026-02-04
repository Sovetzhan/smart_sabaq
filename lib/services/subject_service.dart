import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

import '../models/subject_model.dart';

class SubjectService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> createSubject({
    required String schoolId,
    required String name,
  }) async {
    final normalizedName = name.trim().toLowerCase();

    // 1. Проверяем дубликаты
    final query = await _db
        .collection('schools')
        .doc(schoolId)
        .collection('subjects')
        .where('normalizedName', isEqualTo: normalizedName)
        .limit(1)
        .get();

    if (query.docs.isNotEmpty) {
      throw Exception('Subject already exists');
    }

    final id = const Uuid().v4();

    await _db
        .collection('schools')
        .doc(schoolId)
        .collection('subjects')
        .doc(id)
        .set({
      'schoolId': schoolId,
      'name': name,
      'normalizedName': normalizedName,
      'createdAt': FieldValue.serverTimestamp(),
    });

  }

  Stream<List<Subject>> watchSubjects(String schoolId) {
    return _db
        .collection('schools')
        .doc(schoolId)
        .collection('subjects')
        .orderBy('name')
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((d) => Subject.fromMap(d.id, d.data())).toList());
  }
}
