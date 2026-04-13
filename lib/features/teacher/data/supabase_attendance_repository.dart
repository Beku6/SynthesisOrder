import 'package:supabase_flutter/supabase_flutter.dart';
import '../domain/attendance_models.dart';
import '../domain/attendance_repository.dart';

class SupabaseAttendanceRepository implements AttendanceRepository {
  const SupabaseAttendanceRepository(this._client);

  final SupabaseClient _client;

  @override
  Future<List<StudentAttendance>> fetchAttendanceList(int lessonId, int groupId) async {
    // 1. Fetch all students in the group
    final studentsResponse = await _client
        .from('users')
        .select('id, name')
        .eq('group_id', groupId)
        .eq('role', 'student');

    // 2. Fetch existing attendance for this lesson
    final attendanceResponse = await _client
        .from('lesson_attendance')
        .select('student_id, status')
        .eq('lesson_id', lessonId);

    final attendanceMap = {
      for (final row in (attendanceResponse as List))
        row['student_id'] as String: row['status'] as String
    };

    return (studentsResponse as List).map((student) {
      final id = student['id'] as String;
      final statusStr = attendanceMap[id];
      AttendanceStatus? status;
      if (statusStr != null) {
        status = AttendanceStatus.values.firstWhere(
          (e) => e.name == statusStr,
          orElse: () => AttendanceStatus.present,
        );
      }

      return StudentAttendance(
        studentId: id,
        studentName: student['name'] as String,
        status: status,
      );
    }).toList();
  }

  @override
  Future<void> updateAttendance(int lessonId, String studentId, AttendanceStatus status) async {
    await _client.from('lesson_attendance').upsert({
      'lesson_id': lessonId,
      'student_id': studentId,
      'status': status.name,
    }, onConflict: 'lesson_id, student_id');
  }
}
