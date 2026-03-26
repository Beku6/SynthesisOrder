import 'package:flutter/material.dart';

abstract class AppPreferencesRepository {
  ThemeMode readThemeMode();

  Future<void> writeThemeMode(ThemeMode mode);

  bool readOnboardingCompleted();

  Future<void> writeOnboardingCompleted(bool value);
}
