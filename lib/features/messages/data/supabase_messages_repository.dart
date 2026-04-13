import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../shared/models/app_models.dart';
import '../domain/messages_models.dart';
import '../domain/messages_repository.dart';

class SupabaseMessagesRepository implements MessagesRepository {
  const SupabaseMessagesRepository(this._client);

  final SupabaseClient _client;

  @override
  Future<List<MessagePreview>> fetchMessages() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return [];

    // Fetch all rooms the user is in
    final participantRows = await _client
        .from('chat_participants')
        .select('room_id')
        .eq('user_id', userId);

    if (participantRows.isEmpty) return [];

    final roomIds = participantRows.map((p) => p['room_id'] as String).toList();

    // For each room, get the latest message and the "other" participant's name
    // This is a complex query, for MVP stabilization we'll fetch them in parallel 
    // or use a smart RPC if it existed. Let's do a join-based select.
    
    final previews = <MessagePreview>[];

    for (final roomId in roomIds) {
      final latestMessageRow = await _client
          .from('chat_messages')
          .select('content, created_at, sender:users!sender_id(name)')
          .eq('room_id', roomId)
          .order('created_at', ascending: false)
          .limit(1)
          .maybeSingle();

      if (latestMessageRow == null) continue;

      // Find the name of the other person in the room (if it's a 1-on-1)
      final otherParticipantRow = await _client
          .from('chat_participants')
          .select('user:users(name)')
          .eq('room_id', roomId)
          .neq('user_id', userId)
          .limit(1)
          .maybeSingle();

      final otherUser = otherParticipantRow?['user'] as Map<String, dynamic>?;
      final otherName = otherUser?['name'] as String? ?? 'Group Chat';

      previews.add(
        MessagePreview(
          roomId: roomId,
          name: otherName,
          preview: latestMessageRow['content'] as String,
          timestamp: _formatTimestamp(latestMessageRow['created_at'] as String),
          fallbackIcon: null, // Could map based on group status
        ),
      );
    }

    return previews;
  }

  @override
  Stream<List<ChatMessage>> watchRoomMessages(String roomId) {
    return _client
        .from('chat_messages')
        .stream(primaryKey: ['id'])
        .eq('room_id', roomId)
        .order('created_at')
        .map((rows) => rows.map(_mapMessage).toList());
  }

  @override
  Future<void> sendMessage(String roomId, String content) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) throw StateError('Not authenticated');

    await _client.from('chat_messages').insert({
      'room_id': roomId,
      'sender_id': userId,
      'content': content,
    });
  }

  @override
  Future<String> getOrCreateDirectRoom(String otherUserId) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) throw StateError('Not authenticated');

    // Find if a 1-on-1 room already exists between these two users
    final response = await _client.rpc('get_or_create_direct_room', params: {
      'user1': userId,
      'user2': otherUserId,
    });

    return response as String;
  }

  ChatMessage _mapMessage(Map<String, dynamic> row) {
    return ChatMessage(
      id: row['id'] as String,
      roomId: row['room_id'] as String,
      senderId: row['sender_id'] as String,
      content: row['content'] as String,
      createdAt: DateTime.parse(row['created_at'] as String).toLocal(),
    );
  }

  String _formatTimestamp(String iso) {
    final date = DateTime.parse(iso).toLocal();
    final now = DateTime.now();
    if (date.year == now.year && date.month == now.month && date.day == now.day) {
      return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    }
    return '${date.day}/${date.month}';
  }
}
