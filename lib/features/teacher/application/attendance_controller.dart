import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/supabase_attendance_repository.dart';
import '../domain/attendance_models.dart';
import '../domain/attendance_repository.dart';
import '../../../app/data/supabase_client_provider.dart';

final attendanceRepositoryProvider = Provider<AttendanceRepository>((ref) {
  return SupabaseAttendanceRepository(ref.watch(supabaseClientProvider));
});

final lessonAttendanceProvider = FutureProvider.family<List<StudentAttendance>, ({int lessonId, int groupId})>((ref, arg) {
  return ref.watch(attendanceRepositoryProvider).fetchAttendanceList(arg.lessonId, arg.groupId);
});

class AttendanceNotifier extends StateNotifier<AsyncValue<void>> {
  AttendanceNotifier(this._repository) : super(const AsyncData(null));

  final AttendanceRepository _repository;

  Future<void> markAttendance(int lessonId, String studentId, AttendanceStatus status) async {
    state = const AsyncLoading();
    try {
      await _repository.updateAttendance(lessonId, studentId, status);
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}

final attendanceNotifierProvider = StateNotifierProvider<AttendanceNotifier, AsyncValue<void>>((ref) {
  return AttendanceNotifier(ref.watch(attendanceRepositoryProvider));
});
