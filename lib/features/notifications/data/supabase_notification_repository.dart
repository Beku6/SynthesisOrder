import 'package:supabase_flutter/supabase_flutter.dart';
import '../domain/notification_models.dart';

class SupabaseNotificationRepository {
  const SupabaseNotificationRepository(this._client);

  final SupabaseClient _client;

  Stream<List<SynorNotification>> watchNotifications() {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return Stream.value([]);

    return _client
        .from('notifications')
        .stream(primaryKey: ['id'])
        .eq('user_id', userId)
        .order('created_at')
        .map((rows) => rows.map(_mapNotification).toList());
  }

  Future<void> markAsRead(String notificationId) async {
    await _client
        .from('notifications')
        .update({'is_read': true})
        .eq('id', notificationId);
  }

  Future<void> markAllAsRead() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return;

    await _client
        .from('notifications')
        .update({'is_read': true})
        .eq('user_id', userId);
  }

  SynorNotification _mapNotification(Map<String, dynamic> row) {
    return SynorNotification(
      id: row['id'] as String,
      title: row['title'] as String,
      message: row['message'] as String,
      type: NotificationType.fromString(row['type'] as String),
      isRead: row['is_read'] as bool,
      createdAt: DateTime.parse(row['created_at'] as String).toLocal(),
    );
  }
}
