import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

import '../models/class_model.dart';

class ClassService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> createClass({
    required String schoolId,
    required String name,
    required String language,
    String? classTeacherId,
  }) async {
    final id = const Uuid().v4();

    await _db
        .collection('schools')
        .doc(schoolId)
        .collection('classes')
        .doc(id)
        .set({
      'schoolId': schoolId,
      'name': name,
      'language': language,
      'classTeacherId': classTeacherId,
      'createdAt': DateTime.now().toIso8601String(),
    });
  }

  Stream<List<SchoolClass>> watchClasses(String schoolId) {
    return _db
        .collection('schools')
        .doc(schoolId)
        .collection('classes')
        .orderBy('name')
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((d) => SchoolClass.fromMap(d.id, d.data())).toList());
  }
}
