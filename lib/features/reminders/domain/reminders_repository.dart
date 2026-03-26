import '../../../core/notifications/notification_scheduler.dart';
import 'reminder_models.dart';

class AlertPreset {
  const AlertPreset({required this.label, required this.kind});

  final String label;
  final AlertPresetKind kind;
}

enum AlertPresetKind { relative, commute, wakeUp, custom }

abstract class RemindersRepository {
  Future<List<AlertPreset>> fetchQuickAlertPresets();

  AlarmConfiguration readAlarmConfiguration();

  Future<void> saveAlarmConfiguration(AlarmConfiguration configuration);

  Future<void> saveAlarmDraft(AlarmScheduleDraft draft);
}
