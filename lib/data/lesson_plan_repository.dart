import 'package:cloud_firestore/cloud_firestore.dart';
import '../core/firestore_collections.dart';
import 'school_scoped_repository.dart';
import '../models/lesson_plan_model.dart';

class LessonPlanRepository {
  final SchoolScopedRepository _repo;

  LessonPlanRepository(this._repo);

  CollectionReference<Map<String, dynamic>> get _ref =>
      _repo.schoolCollection(FirestoreCollections.lessonPlans);

  Future<void> create(LessonPlanModel plan) async {
    final exists = await _ref
        .where('scheduleItemId', isEqualTo: plan.scheduleItemId)
        .where('date', isEqualTo: plan.date.toIso8601String())
        .get();

    if (exists.docs.isNotEmpty) {
      throw Exception('Lesson plan already exists');
    }

    await _ref.add(plan.toMap());
  }
}
