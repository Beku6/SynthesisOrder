import '../domain/auth_models.dart';
import '../domain/auth_repository.dart';

class LocalAuthRepository implements AuthRepository {
  @override
  String? get currentUserId => null;

  @override
  Stream<String?> authStateChanges() => const Stream<String?>.empty();

  @override
  Future<AuthSubmissionResult> completeSignUp(SignUpDraft draft) async {
    await Future<void>.delayed(const Duration(milliseconds: 550));
    return AuthSubmissionResult(
      userId: 'local-sign-up',
      hasSession: true,
      email: draft.email,
    );
  }

  @override
  Future<void> sendRecoveryLink(String identity) async {
    await Future<void>.delayed(const Duration(milliseconds: 350));
  }

  @override
  Future<AuthSubmissionResult> signIn(SignInDraft draft) async {
    await Future<void>.delayed(const Duration(milliseconds: 550));
    return AuthSubmissionResult(
      userId: 'local-sign-in',
      hasSession: true,
      email: draft.email,
    );
  }

  @override
  Future<void> signInWithGoogle() async {
    await Future<void>.delayed(const Duration(milliseconds: 650));
  }

  @override
  Future<void> signOut() async {}
}
