class Teacher {
  final String id;
  final String schoolId;
  final String lastName;
  final String firstName;
  final String middleName;
  final String login;
  final List<String> subjectIds;

  Teacher({
    required this.id,
    required this.schoolId,
    required this.lastName,
    required this.firstName,
    required this.middleName,
    required this.login,
    required this.subjectIds,
  });

  Map<String, dynamic> toMap() {
    return {
      'schoolId': schoolId,
      'lastName': lastName,
      'firstName': firstName,
      'middleName': middleName,
      'login': login,
      'subjectIds': subjectIds,
      'createdAt': DateTime.now(),
    };
  }

  factory Teacher.fromMap(String id, Map<String, dynamic> map) {
    return Teacher(
      id: id,
      schoolId: map['schoolId'],
      lastName: map['lastName'],
      firstName: map['firstName'],
      middleName: map['middleName'],
      login: map['login'],
      subjectIds: List<String>.from(map['subjectIds'] ?? []),
    );
  }
}
