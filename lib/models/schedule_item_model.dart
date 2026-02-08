import '../core/week_day.dart';

class ScheduleItem {
  final String id;
  final String schoolId;
  final WeekDay dayOfWeek;
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
  }) : assert(schoolId.isNotEmpty);

  Map<String, dynamic> toMap() {
    return {
      'schoolId': schoolId,
      'dayOfWeek': dayOfWeek.index,
      'classId': classId,
      'timeSlotId': timeSlotId,
      'subjectId': subjectId,
      'teacherId': teacherId,
    };
  }

  factory ScheduleItem.fromMap(String id, Map<String, dynamic> map) {
    return ScheduleItem(
      id: id,
      schoolId: map['schoolId'] as String,
      dayOfWeek: WeekDayX.fromInt(map['dayOfWeek'] as int),
      classId: map['classId'] as String,
      timeSlotId: map['timeSlotId'] as String,
      subjectId: map['subjectId'] as String,
      teacherId: map['teacherId'] as String,
    );
  }

  ScheduleItem copyWith({
    String? id,
    String? schoolId,
    WeekDay? dayOfWeek,
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
