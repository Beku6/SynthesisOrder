import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/data/supabase_client_provider.dart';
import 'supabase_auth_repository.dart';
import '../domain/auth_repository.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return SupabaseAuthRepository(
    client: ref.watch(supabaseClientProvider),
    config: ref.watch(synorSupabaseConfigProvider),
  );
});
