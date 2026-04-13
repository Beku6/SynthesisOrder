import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/models/app_models.dart';
import '../../../app/data/supabase_client_provider.dart';
import '../data/supabase_messages_repository.dart';
import '../domain/messages_repository.dart';

final messagesRepositoryProvider = Provider<MessagesRepository>((ref) {
  return SupabaseMessagesRepository(ref.watch(supabaseClientProvider));
});

final messagesProvider = FutureProvider<List<MessagePreview>>((ref) {
  return ref.watch(messagesRepositoryProvider).fetchMessages();
});
