import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/lesson_plan_model.dart';

class LessonPlanService {
  final _db = FirebaseFirestore.instance;

  Future<void> create(LessonPlan plan) async {
    final exists = await getByScheduleAndDate(
      schoolId: plan.schoolId,
      scheduleItemId: plan.scheduleItemId,
      date: plan.date,
    );

    if (exists != null) {
      throw Exception('LessonPlan already exists');
    }

    await _db
        .collection('schools')
        .doc(plan.schoolId)
        .collection('lessonPlans')
        .doc(plan.id)
        .set(plan.toMap());
  }

  Future<LessonPlan?> getByScheduleAndDate({
    required String schoolId,
    required String scheduleItemId,
    required String date,
  }) async {
    final snap = await _db
        .collection('schools')
        .doc(schoolId)
        .collection('lessonPlans')
        .where('scheduleItemId', isEqualTo: scheduleItemId)
        .where('date', isEqualTo: date)
        .limit(1)
        .get();

    if (snap.docs.isEmpty) return null;

    final d = snap.docs.first;
    return LessonPlan.fromMap(d.id, d.data());
  }

  Future<List<LessonPlan>> getForAdmin({
    required String schoolId,
    required String date,
  }) async {
    final snap = await _db
        .collection('schools')
        .doc(schoolId)
        .collection('lessonPlans')
        .where('date', isEqualTo: date)
        .get();

    return snap.docs.map((d) => LessonPlan.fromMap(d.id, d.data())).toList();
  }

  Future<bool> hasPlan({
    required String schoolId,
    required String scheduleItemId,
    required String date,
  }) async {
    final snap = await _db
        .collection('schools')
        .doc(schoolId)
        .collection('lessonPlans')
        .where('scheduleItemId', isEqualTo: scheduleItemId)
        .where('date', isEqualTo: date)
        .limit(1)
        .get();

    return snap.docs.isNotEmpty;
  }
}
