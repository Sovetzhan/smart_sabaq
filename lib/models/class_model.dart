import 'package:cloud_firestore/cloud_firestore.dart';

class SchoolClass {
  final String id;
  final String schoolId;
  final String name;
  final String language;
  final String? classTeacherId;
  final DateTime? createdAt;

  SchoolClass({
    required this.id,
    required this.schoolId,
    required this.name,
    required this.language,
    this.classTeacherId,
    this.createdAt,
  });

  factory SchoolClass.fromMap(String id, Map<String, dynamic> data) {
    return SchoolClass(
      id: id,
      schoolId: data['schoolId'],
      name: data['name'],
      language: data['language'],
      classTeacherId: data['classTeacherId'],
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }
}
