import 'package:flutter/material.dart';

abstract class AppPreferencesRepository {
  ThemeMode readThemeMode();

  Future<void> writeThemeMode(ThemeMode mode);

  String? readLocaleCode();

  Future<void> writeLocaleCode(String code);

  bool readOnboardingCompleted();

  Future<void> writeOnboardingCompleted(bool value);
}
