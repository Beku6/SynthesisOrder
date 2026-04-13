import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../domain/app_preferences_repository.dart';

class LocalAppPreferencesRepository implements AppPreferencesRepository {
  LocalAppPreferencesRepository(this._preferences);

  final SharedPreferences _preferences;

  static const _themeModeKey = 'app.theme_mode';
  static const _localeCodeKey = 'app.locale_code';
  static const _onboardingCompletedKey = 'app.onboarding_completed';

  @override
  bool readOnboardingCompleted() =>
      _preferences.getBool(_onboardingCompletedKey) ?? false;

  @override
  String? readLocaleCode() => _preferences.getString(_localeCodeKey);

  @override
  ThemeMode readThemeMode() {
    final rawValue = _preferences.getString(_themeModeKey);
    return switch (rawValue) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.dark,
    };
  }

  @override
  Future<void> writeOnboardingCompleted(bool value) async {
    await _preferences.setBool(_onboardingCompletedKey, value);
  }

  @override
  Future<void> writeLocaleCode(String code) async {
    await _preferences.setString(_localeCodeKey, code);
  }

  @override
  Future<void> writeThemeMode(ThemeMode mode) async {
    final rawValue = switch (mode) {
      ThemeMode.light => 'light',
      ThemeMode.dark || ThemeMode.system => 'dark',
    };
    await _preferences.setString(_themeModeKey, rawValue);
  }
}
