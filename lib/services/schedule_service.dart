import 'package:cloud_firestore/cloud_firestore.dart';

import '../core/user_context.dart';
import '../core/user_role.dart';
import '../models/schedule_item_model.dart';

class ScheduleService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ===============================
  // CREATE — ТОЛЬКО АДМИН
  // ===============================
  Future<void> create(
      UserContext user,
      ScheduleItem item,
      ) async {
    if (user.role != UserRole.admin) {
      throw Exception('Только администратор может создавать расписание');
    }

    if (item.schoolId != user.schoolId) {
      throw Exception('Неверная школа');
    }

    await _db
        .collection('schools')
        .doc(user.schoolId)
        .collection('scheduleItems')
        .doc(item.id)
        .set(item.toMap());
  }

  // ===============================
  // UPDATE — ТОЛЬКО АДМИН
  // ===============================
  Future<void> update(
      UserContext user,
      ScheduleItem item,
      ) async {
    if (user.role != UserRole.admin) {
      throw Exception('Только администратор может редактировать расписание');
    }

    if (item.schoolId != user.schoolId) {
      throw Exception('Неверная школа');
    }

    await _db
        .collection('schools')
        .doc(user.schoolId)
        .collection('scheduleItems')
        .doc(item.id)
        .update(item.toMap());
  }

  // ===============================
  // DELETE — ТОЛЬКО АДМИН
  // ===============================
  Future<void> delete(
      UserContext user,
      String scheduleItemId,
      ) async {
    if (user.role != UserRole.admin) {
      throw Exception('Только администратор может удалять расписание');
    }

    await _db
        .collection('schools')
        .doc(user.schoolId)
        .collection('scheduleItems')
        .doc(scheduleItemId)
        .delete();
  }

  // ===============================
  // GET BY TEACHER
  // admin — любого
  // teacher — только себя
  // ===============================
  Future<List<ScheduleItem>> getByTeacher({
    required UserContext user,
    required String teacherId,
    required int dayOfWeek,
  }) async {
    if (user.role == UserRole.teacher &&
        user.userId != teacherId) {
      throw Exception('Доступ запрещён');
    }

    final snap = await _db
        .collection('schools')
        .doc(user.schoolId)
        .collection('scheduleItems')
        .where('teacherId', isEqualTo: teacherId)
        .where('dayOfWeek', isEqualTo: dayOfWeek)
        .get();

    return snap.docs
        .map((d) => ScheduleItem.fromMap(d.id, d.data()))
        .toList();
  }

  // ===============================
  // GET BY CLASS — ТОЛЬКО АДМИН
  // ===============================
  Future<List<ScheduleItem>> getByClass({
    required UserContext user,
    required String classId,
    required int dayOfWeek,
  }) async {
    if (user.role != UserRole.admin) {
      throw Exception('Только администратор');
    }

    final snap = await _db
        .collection('schools')
        .doc(user.schoolId)
        .collection('scheduleItems')
        .where('classId', isEqualTo: classId)
        .where('dayOfWeek', isEqualTo: dayOfWeek)
        .get();

    return snap.docs
        .map((d) => ScheduleItem.fromMap(d.id, d.data()))
        .toList();
  }

  // ===============================
  // GET BY DAY (для админа)
  // ===============================
  Future<List<ScheduleItem>> getByDay({
    required UserContext user,
    required int dayOfWeek,
  }) async {
    if (user.role != UserRole.admin) {
      throw Exception('Только администратор');
    }

    final snap = await _db
        .collection('schools')
        .doc(user.schoolId)
        .collection('scheduleItems')
        .where('dayOfWeek', isEqualTo: dayOfWeek)
        .get();

    return snap.docs
        .map((d) => ScheduleItem.fromMap(d.id, d.data()))
        .toList();
  }
}
