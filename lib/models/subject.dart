class Subject {
  final String id;
  final String schoolId;
  final String name;

  Subject({
    required this.id,
    required this.schoolId,
    required this.name,
  });

  Map<String, dynamic> toMap() {
    return {
      'schoolId': schoolId,
      'name': name,
      'createdAt': DateTime.now(),
    };
  }

  factory Subject.fromMap(String id, Map<String, dynamic> map) {
    return Subject(
      id: id,
      schoolId: map['schoolId'],
      name: map['name'],
    );
  }
}

