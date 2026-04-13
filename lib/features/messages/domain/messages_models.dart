import 'package:flutter/foundation.dart';

@immutable
class ChatMessage {
  const ChatMessage({
    required this.id,
    required this.roomId,
    required this.senderId,
    required this.content,
    required this.createdAt,
    this.senderName,
  });

  final String id;
  final String roomId;
  final String senderId;
  final String content;
  final DateTime createdAt;
  final String? senderName;

  bool isMe(String currentUserId) => senderId == currentUserId;
}

@immutable
class ChatRoom {
  const ChatRoom({
    required this.id,
    required this.name,
    required this.isGroup,
    this.participantIds = const [],
  });

  final String id;
  final String name;
  final bool isGroup;
  final List<String> participantIds;
}
