import 'package:cloud_firestore/cloud_firestore.dart';
import '../core/firestore_collections.dart';
import 'school_scoped_repository.dart';
import '../models/lesson_plan_model.dart';

class LessonPlanRepository {
  final SchoolScopedRepository _repo;

  LessonPlanRepository(this._repo);

  Query<Map<String, dynamic>> get _query =>
      _repo.schoolQuery(FirestoreCollections.lessonPlans);

  Future<void> create(LessonPlan plan) async {
    final dateOnly = Timestamp.fromDate(
      DateTime(
        plan.lessonDate.year,
        plan.lessonDate.month,
        plan.lessonDate.day,
      ),
    );

    final snapshot = await _query
        .where('scheduleItemId', isEqualTo: plan.scheduleItemId)
        .where('lessonDate', isEqualTo: dateOnly)
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      throw Exception('Lesson plan already exists');
    }

    await _repo.create(
      FirestoreCollections.lessonPlans,
      plan.toMap(),
    );
  }

  Query<Map<String, dynamic>> byScheduleItem(String scheduleItemId) {
    return _query.where('scheduleItemId', isEqualTo: scheduleItemId);
  }

  Query<Map<String, dynamic>> byDate(DateTime date) {
    final dateOnly = Timestamp.fromDate(
      DateTime(date.year, date.month, date.day),
    );

    return _query.where('lessonDate', isEqualTo: dateOnly);
  }
}
