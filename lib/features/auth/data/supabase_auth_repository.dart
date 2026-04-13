import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../app/data/supabase_client_provider.dart';
import '../domain/auth_models.dart';
import '../domain/auth_repository.dart';

class SupabaseAuthRepository implements AuthRepository {
  SupabaseAuthRepository({
    required SupabaseClient client,
    required SynorSupabaseConfig config,
  }) : _client = client,
       _config = config;

  final SupabaseClient _client;
  final SynorSupabaseConfig _config;

  @override
  String? get currentUserId => _client.auth.currentUser?.id;

  @override
  Stream<String?> authStateChanges() =>
      _client.auth.onAuthStateChange.map((state) => state.session?.user.id);

  @override
  Future<AuthSubmissionResult> signIn(SignInDraft draft) async {
    final response = await _client.auth.signInWithPassword(
      email: draft.email.trim(),
      password: draft.password,
    );
    return AuthSubmissionResult(
      userId: response.user?.id ?? response.session?.user.id,
      hasSession: response.session != null,
      email: response.user?.email,
    );
  }

  @override
  Future<void> signInWithGoogle() async {
    await _client.auth.signInWithOAuth(
      OAuthProvider.google,
      redirectTo: _config.authCallbackUrl.isEmpty
          ? null
          : _config.authCallbackUrl,
    );
  }

  @override
  Future<void> sendRecoveryLink(String identity) {
    return _client.auth.resetPasswordForEmail(
      identity,
      redirectTo: _config.authCallbackUrl.isEmpty
          ? null
          : _config.authCallbackUrl,
    );
  }

  @override
  Future<AuthSubmissionResult> completeSignUp(SignUpDraft draft) async {
    final response = await _client.auth.signUp(
      email: draft.email.trim(),
      password: draft.password,
      data: {
        'name': draft.fullName.trim(),
        'role': draft.role.name,
        'group': draft.group.trim(),
        'university': draft.university.trim(),
        'faculty': draft.faculty.trim(),
        'course_year': draft.courseYear.trim(),
      },
    );

    final user = response.user;
    if (user != null) {
      try {
        await _client.from('users').upsert({
          'id': user.id,
          'email': user.email ?? draft.email.trim(),
          'name': draft.fullName.trim(),
          'role': draft.role.name,
          'university': draft.university.trim(),
          'program': draft.faculty.trim(),
          'course_year': draft.courseYear.trim(),
        }, onConflict: 'id');
      } catch (_) {
        // Ignored, safe fallback if trigger missing
      }
    }

    return AuthSubmissionResult(
      userId: response.user?.id,
      hasSession: response.session != null,
      requiresEmailVerification: response.session == null,
      email: response.user?.email ?? draft.email.trim(),
    );
  }

  @override
  Future<void> signOut() => _client.auth.signOut();
}
