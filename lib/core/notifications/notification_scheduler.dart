import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../shared/models/app_models.dart';

final notificationSchedulerProvider = Provider<NotificationScheduler>((ref) {
  // This will be overridden in main.dart with the real implementation
  return NoopNotificationScheduler();
});

class AlarmScheduleDraft {
  const AlarmScheduleDraft({
    required this.id,
    required this.mode,
    required this.hours,
    required this.minutes,
    required this.label,
  });

  final String id;
  final AlarmMode mode;
  final int hours;
  final int minutes;
  final String label;
}

abstract class NotificationScheduler {
  Future<void> scheduleLessonAlert({
    required int lessonId,
    required String alertLabel,
  });

  Future<void> cancelLessonAlert(int lessonId);

  Future<void> scheduleAlarm(AlarmScheduleDraft draft);

  Future<void> cancelAlarm(String alarmId);
}

class NoopNotificationScheduler implements NotificationScheduler {
  @override
  Future<void> cancelAlarm(String alarmId) async {}

  @override
  Future<void> cancelLessonAlert(int lessonId) async {}

  @override
  Future<void> scheduleAlarm(AlarmScheduleDraft draft) async {}

  @override
  Future<void> scheduleLessonAlert({
    required int lessonId,
    required String alertLabel,
  }) async {}
}
