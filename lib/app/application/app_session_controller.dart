import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/persistence/shared_preferences_provider.dart';
import '../../features/auth/data/auth_providers.dart';
import '../../features/auth/domain/auth_repository.dart';
import '../../l10n/l10n.dart';
import '../../shared/models/app_models.dart';
import '../data/local_app_preferences_repository.dart';
import '../domain/app_preferences_repository.dart';

@immutable
class AppSessionState {
  const AppSessionState({
    required this.themeMode,
    required this.locale,
    required this.onboardingCompleted,
    this.authUserId,
    this.showSignUp = false,
  });

  final ThemeMode themeMode;
  final Locale locale;
  final bool onboardingCompleted;
  final String? authUserId;
  final bool showSignUp;

  bool get isAuthenticated => authUserId != null;

  AuthStage get stage {
    if (!onboardingCompleted) return AuthStage.onboarding;
    if (isAuthenticated) return AuthStage.main;
    if (showSignUp) return AuthStage.signUp;
    return AuthStage.signIn;
  }

  AppSessionState copyWith({
    ThemeMode? themeMode,
    Locale? locale,
    bool? onboardingCompleted,
    String? authUserId,
    bool? showSignUp,
    bool clearAuthUser = false,
  }) {
    return AppSessionState(
      themeMode: themeMode ?? this.themeMode,
      locale: locale ?? this.locale,
      onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
      authUserId: clearAuthUser ? null : (authUserId ?? this.authUserId),
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
  AuthRepository get _auth => ref.read(authRepositoryProvider);

  @override
  AppSessionState build() {
    final subscription = _auth.authStateChanges().listen((userId) {
      if (state.authUserId != userId) {
        state = state.copyWith(authUserId: userId, showSignUp: false);
      }
    });
    ref.onDispose(subscription.cancel);

    return AppSessionState(
      themeMode: _preferences.readThemeMode(),
      locale: synorLocaleFromCode(_preferences.readLocaleCode()),
      onboardingCompleted: _preferences.readOnboardingCompleted(),
      authUserId: _auth.currentUserId,
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

  void signIn(String userId) {
    state = state.copyWith(authUserId: userId, showSignUp: false);
  }

  Future<void> signOut() async {
    await _auth.signOut();
    state = state.copyWith(clearAuthUser: true, showSignUp: false);
  }

  Future<void> toggleTheme() async {
    final nextMode = state.themeMode == ThemeMode.dark
        ? ThemeMode.light
        : ThemeMode.dark;
    await _preferences.writeThemeMode(nextMode);
    state = state.copyWith(themeMode: nextMode);
  }

  Future<void> setLocale(Locale locale) async {
    await _preferences.writeLocaleCode(locale.languageCode);
    state = state.copyWith(locale: locale);
  }
}
