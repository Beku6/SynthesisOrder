import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/application/app_session_controller.dart';
import '../data/local_auth_repository.dart';
import '../domain/auth_models.dart';
import '../domain/auth_repository.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return LocalAuthRepository();
});

@immutable
class SignInFormState {
  const SignInFormState({
    this.draft = const SignInDraft(),
    this.emailError,
    this.passwordError,
    this.isSubmitting = false,
    this.isGoogleSubmitting = false,
  });

  final SignInDraft draft;
  final String? emailError;
  final String? passwordError;
  final bool isSubmitting;
  final bool isGoogleSubmitting;

  SignInFormState copyWith({
    SignInDraft? draft,
    String? emailError,
    String? passwordError,
    bool? isSubmitting,
    bool? isGoogleSubmitting,
    bool clearEmailError = false,
    bool clearPasswordError = false,
  }) {
    return SignInFormState(
      draft: draft ?? this.draft,
      emailError: clearEmailError ? null : (emailError ?? this.emailError),
      passwordError: clearPasswordError
          ? null
          : (passwordError ?? this.passwordError),
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
    );
  }

  void updatePassword(String value) {
    state = state.copyWith(
      draft: state.draft.copyWith(password: value),
      clearPasswordError: true,
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
    );
    return emailError == null && passwordError == null;
  }

  Future<bool> submit() async {
    if (state.isSubmitting || !_validate()) {
      return false;
    }

    state = state.copyWith(isSubmitting: true);
    try {
      await _repository.signIn(state.draft);
      _session.signIn();
      return true;
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
      _session.signIn();
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
    this.isSubmitting = false,
  });

  final SignUpDraft draft;
  final bool isSubmitting;

  SignUpFormState copyWith({SignUpDraft? draft, bool? isSubmitting}) {
    return SignUpFormState(
      draft: draft ?? this.draft,
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }
}

final signUpControllerProvider =
    NotifierProvider<SignUpController, SignUpFormState>(SignUpController.new);

class SignUpController extends Notifier<SignUpFormState> {
  static const _campusOptions = [
    'Main Building',
    'South Campus',
    'Remote Study',
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
    state = state.copyWith(draft: state.draft.copyWith(fullName: value));
  }

  void updateEmail(String value) {
    state = state.copyWith(draft: state.draft.copyWith(email: value));
  }

  void updatePassword(String value) {
    state = state.copyWith(draft: state.draft.copyWith(password: value));
  }

  void updateUniversity(String value) {
    state = state.copyWith(draft: state.draft.copyWith(university: value));
  }

  void updateFaculty(String value) {
    state = state.copyWith(draft: state.draft.copyWith(faculty: value));
  }

  void updateCourseYear(String value) {
    state = state.copyWith(draft: state.draft.copyWith(courseYear: value));
  }

  void updateGroup(String value) {
    state = state.copyWith(draft: state.draft.copyWith(group: value));
  }

  void cycleCampus() {
    final nextIndex =
        (_campusOptions.indexOf(state.draft.campusPreference) + 1) %
        _campusOptions.length;
    state = state.copyWith(
      draft: state.draft.copyWith(campusPreference: _campusOptions[nextIndex]),
    );
  }

  void toggleStudyMode() {
    state = state.copyWith(
      draft: state.draft.copyWith(
        deepFocusEnabled: !state.draft.deepFocusEnabled,
      ),
    );
  }

  void toggleSmartNotifications() {
    state = state.copyWith(
      draft: state.draft.copyWith(
        smartNotificationsEnabled: !state.draft.smartNotificationsEnabled,
      ),
    );
  }

  void toggleCalendarSync() {
    state = state.copyWith(
      draft: state.draft.copyWith(
        calendarSyncEnabled: !state.draft.calendarSyncEnabled,
      ),
    );
  }

  void nextStep() {
    if (state.draft.step >= 4) {
      return;
    }
    state = state.copyWith(
      draft: state.draft.copyWith(step: state.draft.step + 1),
    );
  }

  void previousStep() {
    if (state.draft.step <= 1) {
      return;
    }
    state = state.copyWith(
      draft: state.draft.copyWith(step: state.draft.step - 1),
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
      await _repository.completeSignUp(state.draft);
      _session.signIn();
    } finally {
      state = state.copyWith(isSubmitting: false);
    }
  }
}
