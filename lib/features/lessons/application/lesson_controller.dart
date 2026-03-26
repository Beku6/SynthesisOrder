import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/notifications/notification_scheduler.dart';
import '../../../shared/models/app_models.dart';
import '../data/in_memory_lesson_repository.dart';
import '../domain/lesson_repository.dart';

final notificationSchedulerProvider = Provider<NotificationScheduler>((ref) {
  return NoopNotificationScheduler();
});

final lessonRepositoryProvider = Provider<LessonRepository>((ref) {
  return InMemoryLessonRepository();
});

final lessonControllerProvider =
    AsyncNotifierProvider<LessonController, List<Lesson>>(LessonController.new);

class LessonController extends AsyncNotifier<List<Lesson>> {
  LessonRepository get _repository => ref.read(lessonRepositoryProvider);
  NotificationScheduler get _scheduler =>
      ref.read(notificationSchedulerProvider);

  @override
  Future<List<Lesson>> build() => _repository.fetchLessons();

  Future<void> reload() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_repository.fetchLessons);
  }

  Future<void> applyAlert(int lessonId, String label) async {
    state = await AsyncValue.guard(() async {
      await _scheduler.scheduleLessonAlert(
        lessonId: lessonId,
        alertLabel: label,
      );
      return _repository.applyAlert(lessonId: lessonId, alertLabel: label);
    });
  }

  Future<void> removeAlert(int lessonId) async {
    state = await AsyncValue.guard(() async {
      await _scheduler.cancelLessonAlert(lessonId);
      return _repository.removeAlert(lessonId);
    });
  }
}
