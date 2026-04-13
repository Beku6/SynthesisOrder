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
  static const _savedAlarmsKey = 'reminders.saved_alarms';

  static const _presets = [
    AlertPreset(
      label: 'quickAlert.preset.5Min',
      kind: AlertPresetKind.relative,
    ),
    AlertPreset(
      label: 'quickAlert.preset.10Min',
      kind: AlertPresetKind.relative,
    ),
    AlertPreset(
      label: 'quickAlert.preset.20Min',
      kind: AlertPresetKind.relative,
    ),
    AlertPreset(
      label: 'quickAlert.preset.30Min',
      kind: AlertPresetKind.relative,
    ),
    AlertPreset(
      label: 'quickAlert.preset.1Hour',
      kind: AlertPresetKind.relative,
    ),
    AlertPreset(
      label: 'quickAlert.preset.leaveOnTime',
      kind: AlertPresetKind.commute,
    ),
    AlertPreset(
      label: 'quickAlert.preset.wakeUpBeforeClass',
      kind: AlertPresetKind.wakeUp,
    ),
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
        academicType: 'alarm.type.wakeUp',
        hours: 7,
        minutes: 30,
      );
    }
    final json = jsonDecode(raw) as Map<String, dynamic>;
    return AlarmConfiguration(
      mode: json['mode'] == 'academic'
          ? AlarmMode.academic
          : AlarmMode.personal,
      academicType: json['academicType'] as String? ?? 'alarm.type.wakeUp',
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

  @override
  List<SavedAlarm> fetchSavedAlarms() {
    final raw = _preferences.getString(_savedAlarmsKey);
    if (raw == null) {
      return [];
    }
    final List<dynamic> list = jsonDecode(raw);
    return list
        .map((e) => SavedAlarm.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> saveSavedAlarms(List<SavedAlarm> alarms) async {
    final raw = jsonEncode(alarms.map((e) => e.toJson()).toList());
    await _preferences.setString(_savedAlarmsKey, raw);
  }
}
