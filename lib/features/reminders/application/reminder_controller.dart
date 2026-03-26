import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/notifications/notification_scheduler.dart';
import '../../../core/persistence/shared_preferences_provider.dart';
import '../../../shared/models/app_models.dart';
import '../../lessons/application/lesson_controller.dart';
import '../data/local_reminders_repository.dart';
import '../domain/reminder_models.dart';
import '../domain/reminders_repository.dart';

final remindersRepositoryProvider = Provider<RemindersRepository>((ref) {
  return LocalRemindersRepository(ref.watch(sharedPreferencesProvider));
});

final quickAlertPresetsProvider = FutureProvider<List<AlertPreset>>((ref) {
  return ref.watch(remindersRepositoryProvider).fetchQuickAlertPresets();
});

final alarmControllerProvider =
    NotifierProvider<AlarmController, AlarmConfiguration>(AlarmController.new);

class AlarmController extends Notifier<AlarmConfiguration> {
  RemindersRepository get _repository => ref.read(remindersRepositoryProvider);
  NotificationScheduler get _scheduler =>
      ref.read(notificationSchedulerProvider);

  @override
  AlarmConfiguration build() => _repository.readAlarmConfiguration();

  Future<void> setMode(AlarmMode mode) async {
    state = state.copyWith(mode: mode);
    await _repository.saveAlarmConfiguration(state);
  }

  Future<void> setAcademicType(String type) async {
    state = state.copyWith(academicType: type);
    await _repository.saveAlarmConfiguration(state);
  }

  Future<void> adjustTime({required bool isHours, required int delta}) async {
    state = state.copyWith(
      hours: isHours ? (state.hours + delta + 24) % 24 : null,
      minutes: isHours ? null : (state.minutes + delta + 60) % 60,
    );
    await _repository.saveAlarmConfiguration(state);
  }

  Future<void> saveAlarm() async {
    final draft = AlarmScheduleDraft(
      mode: state.mode,
      hours: state.hours,
      minutes: state.minutes,
      label: state.mode == AlarmMode.personal ? 'Personal' : state.academicType,
    );
    await _repository.saveAlarmDraft(draft);
    await _scheduler.scheduleAlarm(draft);
  }
}
