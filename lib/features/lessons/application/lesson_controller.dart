import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/data/supabase_client_provider.dart';
import '../../../core/notifications/notification_scheduler.dart';
import '../../../core/persistence/shared_preferences_provider.dart';
import '../../../shared/models/app_models.dart';
import '../../users/application/current_user_controller.dart';
import '../../users/domain/user_models.dart';
import '../data/supabase_lesson_repository.dart';
import '../domain/lesson_repository.dart';

// Using notificationSchedulerProvider from core/notifications/notification_scheduler.dart


final lessonRepositoryProvider = Provider<LessonRepository>((ref) {
  return SupabaseLessonRepository(
    ref.watch(supabaseClientProvider),
    ref.watch(sharedPreferencesProvider),
  );
});

final lessonControllerProvider =
    AsyncNotifierProvider<LessonController, List<Lesson>>(LessonController.new);

class LessonController extends AsyncNotifier<List<Lesson>> {
  LessonRepository get _repository => ref.read(lessonRepositoryProvider);
  NotificationScheduler get _scheduler =>
      ref.read(notificationSchedulerProvider);

  @override
  Future<List<Lesson>> build() async {
    final user = await ref.watch(currentUserControllerProvider.future);
    if (user == null) {
      return const [];
    }
    return _repository.fetchLessonsForUser(user);
  }

  Future<void> reload() async {
    final user = await ref.read(currentUserControllerProvider.future);
    if (user == null) {
      state = const AsyncData([]);
      return;
    }
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _repository.fetchLessonsForUser(user));
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

  Future<void> createLesson(LessonMutation mutation) async {
    final actor = await _requireCurrentUser();
    state = await AsyncValue.guard(() async {
      await _repository.createLesson(actor: actor, mutation: mutation);
      return _repository.fetchLessonsForUser(actor);
    });
  }

  Future<void> updateLesson(LessonMutation mutation) async {
    final actor = await _requireCurrentUser();
    state = await AsyncValue.guard(() async {
      await _repository.updateLesson(actor: actor, mutation: mutation);
      return _repository.fetchLessonsForUser(actor);
    });
  }

  Future<SynorUser> _requireCurrentUser() async {
    final user = await ref.read(currentUserControllerProvider.future);
    if (user == null) {
      throw StateError('An authenticated user is required.');
    }
    return user;
  }
}
