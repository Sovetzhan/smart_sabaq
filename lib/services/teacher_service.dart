import 'package:cloud_firestore/cloud_firestore.dart';

import '../core/user_context.dart';
import '../core/user_role.dart';
import '../models/teacher.dart';

class TeacherService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _teachers(String schoolId) {
    return _db
        .collection('schools')
        .doc(schoolId)
        .collection('teachers');
  }

  /// Просмотр штата — ТОЛЬКО администратор
  Stream<List<Teacher>> getTeachers(UserContext user) {
    if (user.role != UserRole.admin) {
      throw Exception('Доступ запрещён');
    }

    return _teachers(user.schoolId).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Teacher.fromMap(
          doc.id,
          doc.data(),
        );
      }).toList();
    });
  }

  /// Добавление преподавателя — ТОЛЬКО администратор
  Future<void> addTeacher(
      UserContext user,
      Teacher teacher,
      ) async {
    if (user.role != UserRole.admin) {
      throw Exception('Доступ запрещён');
    }

    await _teachers(user.schoolId).add(
      teacher.toMap(),
    );
  }
}
