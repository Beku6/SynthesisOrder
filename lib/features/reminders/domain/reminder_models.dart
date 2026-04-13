import '../../../shared/models/app_models.dart';

class AlarmConfiguration {
  const AlarmConfiguration({
    required this.mode,
    required this.academicType,
    required this.hours,
    required this.minutes,
  });

  final AlarmMode mode;
  final String academicType;
  final int hours;
  final int minutes;

  String get formattedTime =>
      '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';

  AlarmConfiguration copyWith({
    AlarmMode? mode,
    String? academicType,
    int? hours,
    int? minutes,
  }) {
    return AlarmConfiguration(
      mode: mode ?? this.mode,
      academicType: academicType ?? this.academicType,
      hours: hours ?? this.hours,
      minutes: minutes ?? this.minutes,
    );
  }
}

class SavedAlarm {
  const SavedAlarm({
    required this.id,
    required this.hours,
    required this.minutes,
    required this.label,
    required this.isEnabled,
    required this.mode,
    this.days = const [],
    this.snoozeEnabled = true,
    this.soundName = 'Default',
    this.academicType,
  });

  final String id;
  final int hours;
  final int minutes;
  final String label;
  final bool isEnabled;
  final AlarmMode mode;
  final List<int> days; // 1 = Monday, 7 = Sunday
  final bool snoozeEnabled;
  final String soundName;
  final String? academicType;

  String get formattedTime =>
      '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';

  SavedAlarm copyWith({
    int? hours,
    int? minutes,
    String? label,
    bool? isEnabled,
    AlarmMode? mode,
    List<int>? days,
    bool? snoozeEnabled,
    String? soundName,
    String? academicType,
  }) {
    return SavedAlarm(
      id: id,
      hours: hours ?? this.hours,
      minutes: minutes ?? this.minutes,
      label: label ?? this.label,
      isEnabled: isEnabled ?? this.isEnabled,
      mode: mode ?? this.mode,
      days: days ?? this.days,
      snoozeEnabled: snoozeEnabled ?? this.snoozeEnabled,
      soundName: soundName ?? this.soundName,
      academicType: academicType ?? this.academicType,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'hours': hours,
      'minutes': minutes,
      'label': label,
      'isEnabled': isEnabled,
      'mode': mode == AlarmMode.academic ? 'academic' : 'personal',
      'days': days,
      'snoozeEnabled': snoozeEnabled,
      'soundName': soundName,
      'academicType': academicType,
    };
  }

  factory SavedAlarm.fromJson(Map<String, dynamic> json) {
    return SavedAlarm(
      id: json['id'] as String,
      hours: json['hours'] as int,
      minutes: json['minutes'] as int,
      label: json['label'] as String? ?? '',
      isEnabled: json['isEnabled'] as bool? ?? true,
      mode: json['mode'] == 'academic' ? AlarmMode.academic : AlarmMode.personal,
      days: (json['days'] as List<dynamic>?)?.map((e) => e as int).toList() ??
          const [],
      snoozeEnabled: json['snoozeEnabled'] as bool? ?? true,
      soundName: json['soundName'] as String? ?? 'Default',
      academicType: json['academicType'] as String?,
    );
  }
}
