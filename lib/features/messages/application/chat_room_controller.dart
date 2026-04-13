import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../application/messages_controller.dart';
import '../data/supabase_messages_repository.dart';
import '../domain/messages_models.dart';

final chatRoomMessagesProvider = StreamProvider.family<List<ChatMessage>, String>((ref, roomId) {
  final repository = ref.watch(messagesRepositoryProvider);
  return repository.watchRoomMessages(roomId);
});

class ChatRoomNotifier extends StateNotifier<AsyncValue<void>> {
  ChatRoomNotifier(this._repository) : super(const AsyncData(null));

  final SupabaseMessagesRepository _repository;

  Future<void> sendMessage(String roomId, String content) async {
    if (content.trim().isEmpty) return;
    
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _repository.sendMessage(roomId, content.trim()));
  }

  Future<String> getOrCreateDirectRoom(String otherUserId) async {
    return _repository.getOrCreateDirectRoom(otherUserId);
  }
}

final chatRoomNotifierProvider = StateNotifierProvider<ChatRoomNotifier, AsyncValue<void>>((ref) {
  return ChatRoomNotifier(ref.watch(messagesRepositoryProvider) as SupabaseMessagesRepository);
});
