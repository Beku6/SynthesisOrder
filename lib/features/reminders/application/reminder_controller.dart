import 'package:flutter/foundation.dart';
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

final alarmListProvider =
    NotifierProvider<AlarmListController, List<SavedAlarm>>(
  AlarmListController.new,
);

class AlarmListController extends Notifier<List<SavedAlarm>> {
  RemindersRepository get _repository => ref.read(remindersRepositoryProvider);
  NotificationScheduler get _scheduler =>
      ref.read(notificationSchedulerProvider);

  @override
  List<SavedAlarm> build() {
    return _repository.fetchSavedAlarms();
  }

  Future<void> addAlarm(SavedAlarm alarm) async {
    state = [...state, alarm];
    await _repository.saveSavedAlarms(state);
    await _syncAlarm(alarm);
  }

  Future<void> updateAlarm(SavedAlarm alarm) async {
    state = [
      for (final a in state)
        if (a.id == alarm.id) alarm else a,
    ];
    await _repository.saveSavedAlarms(state);
    await _syncAlarm(alarm);
  }

  Future<void> deleteAlarm(String id) async {
    state = state.where((a) => a.id != id).toList();
    await _repository.saveSavedAlarms(state);
    await _scheduler.cancelAlarm(id);
  }

  Future<void> toggleAlarm(String id, bool isEnabled) async {
    SavedAlarm? updatedAlarm;
    state = state.map((a) {
      if (a.id == id) {
        updatedAlarm = a.copyWith(isEnabled: isEnabled);
        return updatedAlarm!;
      }
      return a;
    }).toList();
    
    await _repository.saveSavedAlarms(state);
    if (updatedAlarm != null) {
      await _syncAlarm(updatedAlarm!);
    }
  }

  Future<void> _syncAlarm(SavedAlarm alarm) async {
    if (alarm.isEnabled) {
      debugPrint('Scheduling alarm: ${alarm.id} at ${alarm.hours}:${alarm.minutes}');
      await _scheduler.scheduleAlarm(AlarmScheduleDraft(
        id: alarm.id,
        mode: alarm.mode,
        hours: alarm.hours,
        minutes: alarm.minutes,
        label: alarm.label,
      ));
    } else {
      debugPrint('Cancelling alarm: ${alarm.id}');
      await _scheduler.cancelAlarm(alarm.id);
    }
  }
}
