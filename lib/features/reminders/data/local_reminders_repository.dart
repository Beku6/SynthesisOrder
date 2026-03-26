import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/notifications/notification_scheduler.dart';
import '../../../shared/data/mock_latency.dart';
import '../../../shared/models/app_models.dart';
import '../domain/reminder_models.dart';
import '../domain/reminders_repository.dart';

class LocalRemindersRepository implements RemindersRepository {
  LocalRemindersRepository(this._preferences);

  final SharedPreferences _preferences;

  static const _alarmConfigKey = 'reminders.alarm_configuration';

  static const _presets = [
    AlertPreset(label: '5 min before', kind: AlertPresetKind.relative),
    AlertPreset(label: '10 min before', kind: AlertPresetKind.relative),
    AlertPreset(label: '20 min before', kind: AlertPresetKind.relative),
    AlertPreset(label: '30 min before', kind: AlertPresetKind.relative),
    AlertPreset(label: '1 hour before', kind: AlertPresetKind.relative),
    AlertPreset(label: 'Leave on time', kind: AlertPresetKind.commute),
    AlertPreset(label: 'Wake up before class', kind: AlertPresetKind.wakeUp),
  ];

  @override
  Future<List<AlertPreset>> fetchQuickAlertPresets() async =>
      SynorMockLatency.resolve(
        _presets,
        duration: SynorMockLatency.quickAlerts,
      );

  @override
  AlarmConfiguration readAlarmConfiguration() {
    final raw = _preferences.getString(_alarmConfigKey);
    if (raw == null) {
      return const AlarmConfiguration(
        mode: AlarmMode.personal,
        academicType: 'Wake up',
        hours: 7,
        minutes: 30,
      );
    }
    final json = jsonDecode(raw) as Map<String, dynamic>;
    return AlarmConfiguration(
      mode: json['mode'] == 'academic'
          ? AlarmMode.academic
          : AlarmMode.personal,
      academicType: json['academicType'] as String? ?? 'Wake up',
      hours: json['hours'] as int? ?? 7,
      minutes: json['minutes'] as int? ?? 30,
    );
  }

  @override
  Future<void> saveAlarmConfiguration(AlarmConfiguration configuration) async {
    await _preferences.setString(
      _alarmConfigKey,
      jsonEncode({
        'mode': configuration.mode == AlarmMode.academic
            ? 'academic'
            : 'personal',
        'academicType': configuration.academicType,
        'hours': configuration.hours,
        'minutes': configuration.minutes,
      }),
    );
  }

  @override
  Future<void> saveAlarmDraft(AlarmScheduleDraft draft) async {
    await saveAlarmConfiguration(
      AlarmConfiguration(
        mode: draft.mode,
        academicType: draft.label,
        hours: draft.hours,
        minutes: draft.minutes,
      ),
    );
  }
}
