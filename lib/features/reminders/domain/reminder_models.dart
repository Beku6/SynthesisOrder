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
