import 'package:cloud_firestore/cloud_firestore.dart';
import '../app_config.dart';
import '../models/subject.dart';

class SubjectService {
  final _db = FirebaseFirestore.instance;

  CollectionReference get _subjects =>
      _db.collection('schools').doc(schoolId).collection('subjects');

  Stream<List<Subject>> getSubjects() {
    return _subjects
        .orderBy('name')
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((d) => Subject.fromMap(
      d.id,
      d.data() as Map<String, dynamic>,
    ))
        .toList());
  }

  Future<String> createOrGetSubject(String name) async {
    final query = await _subjects
        .where('name', isEqualTo: name.trim())
        .limit(1)
        .get();

    if (query.docs.isNotEmpty) {
      return query.docs.first.id;
    }

    final doc = await _subjects.add({
      'schoolId': schoolId,
      'name': name.trim(),
      'createdAt': DateTime.now(),
    });

    return doc.id;
  }

  Future<void> deleteSubject(String subjectId) async {
    await _subjects.doc(subjectId).delete();
  }
}
