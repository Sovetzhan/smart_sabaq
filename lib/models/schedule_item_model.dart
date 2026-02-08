class ScheduleItem {
  final String id;
  final String schoolId;
  final int dayOfWeek; // 1-7
  final String classId;
  final String timeSlotId;
  final String subjectId;
  final String teacherId;

  ScheduleItem({
    required this.id,
    required this.schoolId,
    required this.dayOfWeek,
    required this.classId,
    required this.timeSlotId,
    required this.subjectId,
    required this.teacherId,
  });

  Map<String, dynamic> toMap() {
    return {
      'schoolId': schoolId,
      'dayOfWeek': dayOfWeek,
      'classId': classId,
      'timeSlotId': timeSlotId,
      'subjectId': subjectId,
      'teacherId': teacherId,
    };
  }

  factory ScheduleItem.fromMap(String id, Map<String, dynamic> map) {
    return ScheduleItem(
      id: id,
      schoolId: map['schoolId'],
      dayOfWeek: map['dayOfWeek'],
      classId: map['classId'],
      timeSlotId: map['timeSlotId'],
      subjectId: map['subjectId'],
      teacherId: map['teacherId'],
    );
  }
  ScheduleItem copyWith({
    String? id,
    String? schoolId,
    int? dayOfWeek,
    String? classId,
    String? timeSlotId,
    String? subjectId,
    String? teacherId,
  }) {
    return ScheduleItem(
      id: id ?? this.id,
      schoolId: schoolId ?? this.schoolId,
      dayOfWeek: dayOfWeek ?? this.dayOfWeek,
      classId: classId ?? this.classId,
      timeSlotId: timeSlotId ?? this.timeSlotId,
      subjectId: subjectId ?? this.subjectId,
      teacherId: teacherId ?? this.teacherId,
    );
  }


}

