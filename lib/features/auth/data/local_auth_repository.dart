import '../domain/auth_models.dart';
import '../domain/auth_repository.dart';

class LocalAuthRepository implements AuthRepository {
  @override
  Future<void> completeSignUp(SignUpDraft draft) async {
    await Future<void>.delayed(const Duration(milliseconds: 550));
  }

  @override
  Future<void> sendRecoveryLink(String identity) async {
    await Future<void>.delayed(const Duration(milliseconds: 350));
  }

  @override
  Future<void> signIn(SignInDraft draft) async {
    await Future<void>.delayed(const Duration(milliseconds: 550));
  }

  @override
  Future<void> signInWithGoogle() async {
    await Future<void>.delayed(const Duration(milliseconds: 650));
  }
}
