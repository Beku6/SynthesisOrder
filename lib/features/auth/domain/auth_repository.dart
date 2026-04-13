import 'auth_models.dart';

abstract class AuthRepository {
  String? get currentUserId;

  Stream<String?> authStateChanges();

  Future<AuthSubmissionResult> signIn(SignInDraft draft);

  Future<void> signInWithGoogle();

  Future<void> sendRecoveryLink(String identity);

  Future<AuthSubmissionResult> completeSignUp(SignUpDraft draft);

  Future<void> signOut();
}
