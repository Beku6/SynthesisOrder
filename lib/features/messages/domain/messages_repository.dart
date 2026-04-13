import '../../../shared/models/app_models.dart';
import 'messages_models.dart';

abstract class MessagesRepository {
  Future<List<MessagePreview>> fetchMessages();

  Stream<List<ChatMessage>> watchRoomMessages(String roomId);

  Future<void> sendMessage(String roomId, String content);

  Future<String> getOrCreateDirectRoom(String otherUserId);
}
