import 'package:flutter/foundation.dart';

@immutable
class SignInDraft {
  const SignInDraft({this.email = '', this.password = ''});

  final String email;
  final String password;

  SignInDraft copyWith({String? email, String? password}) {
    return SignInDraft(
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }
}

@immutable
class SignUpDraft {
  const SignUpDraft({
    this.step = 1,
    this.fullName = '',
    this.email = '',
    this.password = '',
    this.university = 'Abai University',
    this.faculty = '',
    this.courseYear = '',
    this.group = '',
    this.campusPreference = 'Main Building',
    this.deepFocusEnabled = true,
    this.smartNotificationsEnabled = true,
    this.calendarSyncEnabled = true,
  });

  final int step;
  final String fullName;
  final String email;
  final String password;
  final String university;
  final String faculty;
  final String courseYear;
  final String group;
  final String campusPreference;
  final bool deepFocusEnabled;
  final bool smartNotificationsEnabled;
  final bool calendarSyncEnabled;

  SignUpDraft copyWith({
    int? step,
    String? fullName,
    String? email,
    String? password,
    String? university,
    String? faculty,
    String? courseYear,
    String? group,
    String? campusPreference,
    bool? deepFocusEnabled,
    bool? smartNotificationsEnabled,
    bool? calendarSyncEnabled,
  }) {
    return SignUpDraft(
      step: step ?? this.step,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      password: password ?? this.password,
      university: university ?? this.university,
      faculty: faculty ?? this.faculty,
      courseYear: courseYear ?? this.courseYear,
      group: group ?? this.group,
      campusPreference: campusPreference ?? this.campusPreference,
      deepFocusEnabled: deepFocusEnabled ?? this.deepFocusEnabled,
      smartNotificationsEnabled:
          smartNotificationsEnabled ?? this.smartNotificationsEnabled,
      calendarSyncEnabled: calendarSyncEnabled ?? this.calendarSyncEnabled,
    );
  }
}
