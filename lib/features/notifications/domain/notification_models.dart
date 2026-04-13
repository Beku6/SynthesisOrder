import 'package:flutter/foundation.dart';

enum NotificationType {
  assignment,
  exam,
  message,
  system,
  service;

  static NotificationType fromString(String value) {
    return NotificationType.values.firstWhere(
      (v) => v.name == value,
      orElse: () => NotificationType.system,
    );
  }
}

@immutable
class SynorNotification {
  const SynorNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.isRead,
    required this.createdAt,
  });

  final String id;
  final String title;
  final String message;
  final NotificationType type;
  final bool isRead;
  final DateTime createdAt;

  SynorNotification copyWith({
    bool? isRead,
  }) {
    return SynorNotification(
      id: id,
      title: title,
      message: message,
      type: type,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt,
    );
  }
}
