import 'package:cloud_firestore/cloud_firestore.dart';

class LessonPlan {
  final String id;
  final String schoolId;
  final String scheduleItemId;
  final String date; // YYYY-MM-DD
  final String topic;
  final String fileUrl;
  final String? note;
  final DateTime createdAt;

  LessonPlan({
    required this.id,
    required this.schoolId,
    required this.scheduleItemId,
    required this.date,
    required this.topic,
    required this.fileUrl,
    this.note,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'schoolId': schoolId,
      'scheduleItemId': scheduleItemId,
      'date': date,
      'topic': topic,
      'fileUrl': fileUrl,
      'note': note,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }


  factory LessonPlan.fromMap(String id, Map<String, dynamic> map) {
    return LessonPlan(
      id: id,
      schoolId: map['schoolId'],
      scheduleItemId: map['scheduleItemId'],
      date: map['date'],
      topic: map['topic'],
      fileUrl: map['fileUrl'],
      note: map['note'],
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }
}
