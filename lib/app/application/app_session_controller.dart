import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/persistence/shared_preferences_provider.dart';
import '../../shared/models/app_models.dart';
import '../data/local_app_preferences_repository.dart';
import '../domain/app_preferences_repository.dart';

@immutable
class AppSessionState {
  const AppSessionState({
    required this.themeMode,
    required this.onboardingCompleted,
    this.isAuthenticated = false,
    this.showSignUp = false,
  });

  final ThemeMode themeMode;
  final bool onboardingCompleted;
  final bool isAuthenticated;
  final bool showSignUp;

  AuthStage get stage {
    if (!onboardingCompleted) return AuthStage.onboarding;
    if (isAuthenticated) return AuthStage.main;
    if (showSignUp) return AuthStage.signUp;
    return AuthStage.signIn;
  }

  AppSessionState copyWith({
    ThemeMode? themeMode,
    bool? onboardingCompleted,
    bool? isAuthenticated,
    bool? showSignUp,
  }) {
    return AppSessionState(
      themeMode: themeMode ?? this.themeMode,
      onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      showSignUp: showSignUp ?? this.showSignUp,
    );
  }
}

final appPreferencesRepositoryProvider = Provider<AppPreferencesRepository>((
  ref,
) {
  return LocalAppPreferencesRepository(ref.watch(sharedPreferencesProvider));
});

final appSessionControllerProvider =
    NotifierProvider<AppSessionController, AppSessionState>(
      AppSessionController.new,
    );

class AppSessionController extends Notifier<AppSessionState> {
  AppPreferencesRepository get _preferences =>
      ref.read(appPreferencesRepositoryProvider);

  @override
  AppSessionState build() {
    return AppSessionState(
      themeMode: _preferences.readThemeMode(),
      onboardingCompleted: _preferences.readOnboardingCompleted(),
    );
  }

  Future<void> completeOnboarding() async {
    await _preferences.writeOnboardingCompleted(true);
    state = state.copyWith(onboardingCompleted: true, showSignUp: false);
  }

  void openSignUp() {
    state = state.copyWith(showSignUp: true);
  }

  void openSignIn() {
    state = state.copyWith(showSignUp: false);
  }

  void signIn() {
    state = state.copyWith(isAuthenticated: true, showSignUp: false);
  }

  void signOut() {
    state = state.copyWith(isAuthenticated: false, showSignUp: false);
  }

  Future<void> toggleTheme() async {
    final nextMode = state.themeMode == ThemeMode.dark
        ? ThemeMode.light
        : ThemeMode.dark;
    await _preferences.writeThemeMode(nextMode);
    state = state.copyWith(themeMode: nextMode);
  }
}
