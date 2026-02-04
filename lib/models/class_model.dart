class SchoolClass {
  final String id;
  final String schoolId;
  final String name;
  final String language;
  final String? classTeacherId;
  final DateTime createdAt;

  SchoolClass({
    required this.id,
    required this.schoolId,
    required this.name,
    required this.language,
    this.classTeacherId,
    required this.createdAt,
  });

  factory SchoolClass.fromMap(String id, Map<String, dynamic> data) {
    return SchoolClass(
      id: id,
      schoolId: data['schoolId'],
      name: data['name'],
      language: data['language'],
      classTeacherId: data['classTeacherId'],
      createdAt: DateTime.parse(data['createdAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'schoolId': schoolId,
      'name': name,
      'language': language,
      'classTeacherId': classTeacherId,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
