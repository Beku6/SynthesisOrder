import 'auth_models.dart';

abstract class AuthRepository {
  Future<void> signIn(SignInDraft draft);

  Future<void> signInWithGoogle();

  Future<void> sendRecoveryLink(String identity);

  Future<void> completeSignUp(SignUpDraft draft);
}
