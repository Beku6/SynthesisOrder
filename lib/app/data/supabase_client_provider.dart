import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@immutable
class SynorSupabaseConfig {
  const SynorSupabaseConfig({
    required this.url,
    required this.anonKey,
    this.authCallbackUrl = '',
  });

  factory SynorSupabaseConfig.fromEnvironment() {
    return const SynorSupabaseConfig(
      url: String.fromEnvironment('SUPABASE_URL'),
      anonKey: String.fromEnvironment('SUPABASE_ANON_KEY'),
      authCallbackUrl: String.fromEnvironment('SUPABASE_AUTH_CALLBACK_URL'),
    );
  }

  final String url;
  final String anonKey;
  final String authCallbackUrl;

  bool get isConfigured => url.isNotEmpty && anonKey.isNotEmpty;
}

final synorSupabaseConfigProvider = Provider<SynorSupabaseConfig>((ref) {
  throw UnimplementedError(
    'SynorSupabaseConfig must be overridden at startup.',
  );
});

final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  throw UnimplementedError('SupabaseClient must be overridden at startup.');
});

Future<SupabaseClient> initializeSynorSupabase(
  SynorSupabaseConfig config,
) async {
  if (!config.isConfigured) {
    throw StateError(
      'Missing SUPABASE_URL and SUPABASE_ANON_KEY. Run with '
      '--dart-define=SUPABASE_URL=... --dart-define=SUPABASE_ANON_KEY=...',
    );
  }

  await Supabase.initialize(
    url: config.url,
    anonKey: config.anonKey,
    authOptions: const FlutterAuthClientOptions(
      authFlowType: AuthFlowType.pkce,
    ),
  );
  return Supabase.instance.client;
}
