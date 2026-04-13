import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/data/supabase_client_provider.dart';
import '../data/supabase_notification_repository.dart';
import '../domain/notification_models.dart';

final notificationRepositoryProvider = Provider<SupabaseNotificationRepository>((ref) {
  return SupabaseNotificationRepository(ref.watch(supabaseClientProvider));
});

final notificationsStreamProvider = StreamProvider<List<SynorNotification>>((ref) {
  return ref.watch(notificationRepositoryProvider).watchNotifications();
});

final unreadNotificationsCountProvider = Provider<int>((ref) {
  final notifications = ref.watch(notificationsStreamProvider).value ?? [];
  return notifications.where((n) => !n.isRead).length;
});

class NotificationController extends StateNotifier<AsyncValue<void>> {
  NotificationController(this._repository) : super(const AsyncData(null));

  final SupabaseNotificationRepository _repository;

  Future<void> markAsRead(String id) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _repository.markAsRead(id));
  }

  Future<void> markAllAsRead() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _repository.markAllAsRead());
  }
}

final notificationControllerProvider =
    StateNotifierProvider<NotificationController, AsyncValue<void>>((ref) {
  return NotificationController(ref.watch(notificationRepositoryProvider));
});
