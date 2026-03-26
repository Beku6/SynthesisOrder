import '../../shared/models/app_models.dart';

class AlarmScheduleDraft {
  const AlarmScheduleDraft({
    required this.mode,
    required this.hours,
    required this.minutes,
    required this.label,
  });

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
