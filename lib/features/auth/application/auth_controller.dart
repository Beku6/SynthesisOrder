import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../app/application/app_session_controller.dart';
import '../data/auth_providers.dart';
import '../domain/auth_models.dart';
import '../domain/auth_repository.dart';
import '../../users/domain/user_models.dart';

@immutable
class SignInFormState {
  const SignInFormState({
    this.draft = const SignInDraft(),
    this.emailError,
    this.passwordError,
    this.generalError,
    this.isSubmitting = false,
    this.isGoogleSubmitting = false,
  });

  final SignInDraft draft;
  final String? emailError;
  final String? passwordError;
  final String? generalError;
  final bool isSubmitting;
  final bool isGoogleSubmitting;

  SignInFormState copyWith({
    SignInDraft? draft,
    String? emailError,
    String? passwordError,
    String? generalError,
    bool? isSubmitting,
    bool? isGoogleSubmitting,
    bool clearEmailError = false,
    bool clearPasswordError = false,
    bool clearGeneralError = false,
  }) {
    return SignInFormState(
      draft: draft ?? this.draft,
      emailError: clearEmailError ? null : (emailError ?? this.emailError),
      passwordError: clearPasswordError
          ? null
          : (passwordError ?? this.passwordError),
      generalError: clearGeneralError
          ? null
          : (generalError ?? this.generalError),
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isGoogleSubmitting: isGoogleSubmitting ?? this.isGoogleSubmitting,
    );
  }
}

final signInControllerProvider =
    NotifierProvider<SignInController, SignInFormState>(SignInController.new);

class SignInController extends Notifier<SignInFormState> {
  AuthRepository get _repository => ref.read(authRepositoryProvider);
  AppSessionController get _session =>
      ref.read(appSessionControllerProvider.notifier);

  @override
  SignInFormState build() => const SignInFormState();

  void reset() {
    state = const SignInFormState();
  }

  void updateEmail(String value) {
    state = state.copyWith(
      draft: state.draft.copyWith(email: value),
      clearEmailError: true,
      clearGeneralError: true,
    );
  }

  void updatePassword(String value) {
    state = state.copyWith(
      draft: state.draft.copyWith(password: value),
      clearPasswordError: true,
      clearGeneralError: true,
    );
  }

  bool _validate() {
    String? emailError;
    String? passwordError;
    final email = state.draft.email.trim();

    if (email.isEmpty) {
      emailError = 'Enter your student email or ID.';
    } else if (email.contains('@') && !email.contains('.')) {
      emailError = 'Enter a valid email address.';
    }

    if (state.draft.password.isEmpty) {
      passwordError = 'Enter your password.';
    } else if (state.draft.password.length < 6) {
      passwordError = 'Password must be at least 6 characters.';
    }

    state = state.copyWith(
      emailError: emailError,
      passwordError: passwordError,
      clearEmailError: emailError == null,
      clearPasswordError: passwordError == null,
      clearGeneralError: true,
    );
    return emailError == null && passwordError == null;
  }

  Future<bool> submit() async {
    if (state.isSubmitting || !_validate()) {
      return false;
    }

    state = state.copyWith(isSubmitting: true);
    try {
      final result = await _repository.signIn(state.draft);
      final userId = result.userId;
      if (userId == null || !result.hasSession) {
        state = state.copyWith(
          generalError: 'Sign in failed. Please try again.',
        );
        return false;
      }
      _session.signIn(userId);
      return true;
    } on AuthException catch (error) {
      state = state.copyWith(generalError: error.message);
      return false;
    } catch (_) {
      state = state.copyWith(
        generalError: 'Sign in failed. Please check your credentials.',
      );
      return false;
    } finally {
      state = state.copyWith(isSubmitting: false);
    }
  }

  Future<void> submitWithGoogle() async {
    if (state.isGoogleSubmitting) {
      return;
    }

    state = state.copyWith(isGoogleSubmitting: true);
    try {
      await _repository.signInWithGoogle();
    } on AuthException catch (error) {
      state = state.copyWith(generalError: error.message);
    } catch (_) {
      state = state.copyWith(
        generalError: 'Google sign in is not available right now.',
      );
    } finally {
      state = state.copyWith(isGoogleSubmitting: false);
    }
  }

  Future<String?> sendRecoveryLink() async {
    final email = state.draft.email.trim();
    if (email.isEmpty) {
      state = state.copyWith(
        emailError: 'Enter your email first to recover access.',
      );
      return null;
    }

    await _repository.sendRecoveryLink(email);
    return email;
  }
}

@immutable
class SignUpFormState {
  const SignUpFormState({
    this.draft = const SignUpDraft(),
    this.generalError,
    this.isSubmitting = false,
  });

  final SignUpDraft draft;
  final String? generalError;
  final bool isSubmitting;

  SignUpFormState copyWith({
    SignUpDraft? draft,
    String? generalError,
    bool? isSubmitting,
    bool clearGeneralError = false,
  }) {
    return SignUpFormState(
      draft: draft ?? this.draft,
      generalError: clearGeneralError
          ? null
          : (generalError ?? this.generalError),
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }
}

final signUpControllerProvider =
    NotifierProvider<SignUpController, SignUpFormState>(SignUpController.new);

class SignUpController extends Notifier<SignUpFormState> {
  static const _campusOptions = [
    'campus.main',
    'campus.south',
    'campus.remote',
  ];

  AuthRepository get _repository => ref.read(authRepositoryProvider);
  AppSessionController get _session =>
      ref.read(appSessionControllerProvider.notifier);

  @override
  SignUpFormState build() => const SignUpFormState();

  void reset() {
    state = const SignUpFormState();
  }

  void updateFullName(String value) {
    state = state.copyWith(
      draft: state.draft.copyWith(fullName: value),
      clearGeneralError: true,
    );
  }

  void updateEmail(String value) {
    state = state.copyWith(
      draft: state.draft.copyWith(email: value),
      clearGeneralError: true,
    );
  }

  void updatePassword(String value) {
    state = state.copyWith(
      draft: state.draft.copyWith(password: value),
      clearGeneralError: true,
    );
  }

  void updateRole(UserRole value) {
    state = state.copyWith(
      draft: state.draft.copyWith(
        role: value,
        group: value == UserRole.teacher ? '' : null,
      ),
      clearGeneralError: true,
    );
  }

  void updateUniversity(String value) {
    state = state.copyWith(
      draft: state.draft.copyWith(university: value),
      clearGeneralError: true,
    );
  }

  void updateFaculty(String value) {
    state = state.copyWith(
      draft: state.draft.copyWith(faculty: value),
      clearGeneralError: true,
    );
  }

  void updateCourseYear(String value) {
    state = state.copyWith(
      draft: state.draft.copyWith(courseYear: value),
      clearGeneralError: true,
    );
  }

  void updateGroup(String value) {
    state = state.copyWith(
      draft: state.draft.copyWith(group: value),
      clearGeneralError: true,
    );
  }

  void cycleCampus() {
    final nextIndex =
        (_campusOptions.indexOf(state.draft.campusPreference) + 1) %
        _campusOptions.length;
    state = state.copyWith(
      draft: state.draft.copyWith(campusPreference: _campusOptions[nextIndex]),
      clearGeneralError: true,
    );
  }

  void toggleStudyMode() {
    state = state.copyWith(
      draft: state.draft.copyWith(
        deepFocusEnabled: !state.draft.deepFocusEnabled,
      ),
      clearGeneralError: true,
    );
  }

  void toggleSmartNotifications() {
    state = state.copyWith(
      draft: state.draft.copyWith(
        smartNotificationsEnabled: !state.draft.smartNotificationsEnabled,
      ),
      clearGeneralError: true,
    );
  }

  void toggleCalendarSync() {
    state = state.copyWith(
      draft: state.draft.copyWith(
        calendarSyncEnabled: !state.draft.calendarSyncEnabled,
      ),
      clearGeneralError: true,
    );
  }

  void nextStep() {
    if (state.draft.step >= 4) {
      return;
    }
    state = state.copyWith(
      draft: state.draft.copyWith(step: state.draft.step + 1),
      clearGeneralError: true,
    );
  }

  void previousStep() {
    if (state.draft.step <= 1) {
      return;
    }
    state = state.copyWith(
      draft: state.draft.copyWith(step: state.draft.step - 1),
      clearGeneralError: true,
    );
  }

  Future<void> completeCurrentStep() async {
    if (state.isSubmitting) {
      return;
    }

    if (state.draft.step < 4) {
      nextStep();
      return;
    }

    state = state.copyWith(isSubmitting: true);
    try {
      final result = await _repository.completeSignUp(state.draft);

      if (result.userId != null) {
        if (!result.hasSession) {
          try {
            final signInResult = await _repository.signIn(SignInDraft(
              email: state.draft.email,
              password: state.draft.password,
            ));
            if (signInResult.userId != null && signInResult.hasSession) {
              _session.signIn(signInResult.userId!);
              return;
            }
          } catch (_) {
            // Ignored, fallback to direct session injection
          }
        }
        
        _session.signIn(result.userId!);
        return;
      }

      state = state.copyWith(
        generalError: 'Could not automatically sign you in. Please sign in manually.',
      );
      _session.openSignIn();
    } on AuthException catch (error) {
      state = state.copyWith(generalError: error.message);
    } catch (_) {
      state = state.copyWith(
        generalError: 'Could not complete sign up. Please try again.',
      );
    } finally {
      state = state.copyWith(isSubmitting: false);
    }
  }
}
