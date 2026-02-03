import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/teacher.dart';
import '../app_config.dart';

class TeacherService {
  final _db = FirebaseFirestore.instance;

  CollectionReference get _teachers =>
      _db.collection('schools').doc(schoolId).collection('teachers');

  Stream<List<Teacher>> getTeachers() {
    return _teachers.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => Teacher.fromMap(
        doc.id,
        doc.data() as Map<String, dynamic>,
      ))
          .toList();
    });
  }

  Future<void> addTeacher(Teacher teacher) async {
    await _teachers.add(teacher.toMap());
  }
}
