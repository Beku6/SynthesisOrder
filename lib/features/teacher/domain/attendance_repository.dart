import 'attendance_models.dart';

abstract class AttendanceRepository {
  Future<List<StudentAttendance>> fetchAttendanceList(int lessonId, int groupId);
  Future<void> updateAttendance(int lessonId, String studentId, AttendanceStatus status);
}
