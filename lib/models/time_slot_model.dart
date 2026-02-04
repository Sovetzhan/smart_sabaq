class TimeSlot {
  final String id;
  final String schoolId;
  final String startTime; // "08:00"
  final String endTime;   // "08:40"
  final int order;        // 1,2,3...

  TimeSlot({
    required this.id,
    required this.schoolId,
    required this.startTime,
    required this.endTime,
    required this.order,
  });

  Map<String, dynamic> toMap() {
    return {
      'schoolId': schoolId,
      'startTime': startTime,
      'endTime': endTime,
      'order': order,
    };
  }

  factory TimeSlot.fromMap(String id, Map<String, dynamic> map) {
    return TimeSlot(
      id: id,
      schoolId: map['schoolId'],
      startTime: map['startTime'],
      endTime: map['endTime'],
      order: map['order'],
    );
  }
}
