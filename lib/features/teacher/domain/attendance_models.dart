import 'package:flutter/foundation.dart';

enum AttendanceStatus {
  present,
  late,
  absent;

  String get value => name;
}

@immutable
class StudentAttendance {
  const StudentAttendance({
    required this.studentId,
    required this.studentName,
    this.status,
  });

  final String studentId;
  final String studentName;
  final AttendanceStatus? status;

  StudentAttendance copyWith({AttendanceStatus? status}) {
    return StudentAttendance(
      studentId: studentId,
      studentName: studentName,
      status: status ?? this.status,
    );
  }
}
