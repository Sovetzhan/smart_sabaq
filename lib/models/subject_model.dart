class Subject {
  final String id;
  final String schoolId;
  final String name;
  final DateTime createdAt;

  Subject({
    required this.id,
    required this.schoolId,
    required this.name,
    required this.createdAt,
  });

  factory Subject.fromMap(String id, Map<String, dynamic> data) {
    return Subject(
      id: id,
      schoolId: data['schoolId'],
      name: data['name'],
      createdAt: DateTime.parse(data['createdAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'schoolId': schoolId,
      'name': name,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
