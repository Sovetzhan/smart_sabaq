import 'package:cloud_firestore/cloud_firestore.dart';

class LessonPlan {
  final String id;
  final String schoolId;
  final String scheduleItemId;
  final DateTime lessonDate; // YYYY-MM-DD
  final String topic;
  final String fileUrl;
  final String? note;
  final DateTime? createdAt;



  LessonPlan({
    required this.id,
    required this.schoolId,
    required this.scheduleItemId,
    required this.lessonDate,
    required this.topic,
    required this.fileUrl,
    this.note,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'schoolId': schoolId,
      'scheduleItemId': scheduleItemId,
      'lessonDate': Timestamp.fromDate(lessonDate),
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
      lessonDate: (map['lessonDate'] as Timestamp).toDate(),
      topic: map['topic'],
      fileUrl: map['fileUrl'],
      note: map['note'],
      createdAt: map['createdAt'] != null
          ? (map['createdAt'] as Timestamp).toDate()
          : null,

    );
  }
}
