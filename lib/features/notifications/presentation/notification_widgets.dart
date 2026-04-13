import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/theme/synor_design_tokens.dart';
import '../../../l10n/l10n.dart';
import '../../../shared/widgets/synor_widgets.dart';
import '../application/notification_controller.dart';
import '../domain/notification_models.dart';

class SynorNotificationBell extends ConsumerWidget {
  const SynorNotificationBell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unreadCount = ref.watch(unreadNotificationsCountProvider);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        SynorIconActionButton(
          icon: LucideIcons.bell,
          onTap: () => _showNotifications(context),
          radius: 16,
          backgroundColor: synorIsDark(context) ? SynorColors.white5 : Colors.white,
          foregroundColor: synorPrimaryText(context),
        ),
        if (unreadCount > 0)
          Positioned(
            right: -2,
            top: -2,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: SynorColors.rose500,
                shape: BoxShape.circle,
                border: Border.all(
                  color: synorIsDark(context) ? SynorColors.appBlack : Colors.white,
                  width: 2,
                ),
              ),
              constraints: const BoxConstraints(
                minWidth: 18,
                minHeight: 18,
              ),
              child: Center(
                child: Text(
                  unreadCount > 9 ? '9+' : '$unreadCount',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  void _showNotifications(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const NotificationListSheet(),
    );
  }
}

class NotificationListSheet extends ConsumerWidget {
  const NotificationListSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationsAsync = ref.watch(notificationsStreamProvider);

    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: synorIsDark(context) ? SynorColors.deepBlack : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          ),
          child: Column(
            children: [
              const SynorBottomSheetHandle(),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        context.l10n.notifications_title,
                        style: Theme.of(context).textTheme.headlineSmall,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    TextButton(
                      onPressed: () => ref.read(notificationControllerProvider.notifier).markAllAsRead(),
                      child: Text(context.l10n.notifications_markAllAsRead),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: notificationsAsync.when(
                  data: (notifications) {
                    if (notifications.isEmpty) {
                      return Center(
                        child: Text(context.l10n.notifications_empty),
                      );
                    }
                    return ListView.separated(
                      controller: scrollController,
                      padding: const EdgeInsets.all(24),
                      itemCount: notifications.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final notification = notifications[index];
                        return _NotificationTile(notification: notification);
                      },
                    );
                  },
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (err, stack) => Center(child: Text('Error: $err')),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _NotificationTile extends ConsumerWidget {
  const _NotificationTile({required this.notification});

  final SynorNotification notification;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SynorGlassPanel(
      radius: SynorRadii.card,
      padding: const EdgeInsets.all(16),
      backgroundColor: notification.isRead 
          ? Colors.transparent 
          : (synorIsDark(context) ? SynorColors.white5 : SynorColors.slate50),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _typeColor(notification.type).withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _typeIcon(notification.type),
              color: _typeColor(notification.type),
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification.title,
                  style: TextStyle(
                    color: synorPrimaryText(context),
                    fontWeight: notification.isRead ? FontWeight.w500 : FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  notification.message,
                  style: TextStyle(
                    color: synorSecondaryText(context),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          if (!notification.isRead)
            GestureDetector(
              onTap: () => ref.read(notificationControllerProvider.notifier).markAsRead(notification.id),
              child: Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.only(top: 6),
                decoration: const BoxDecoration(
                  color: SynorColors.indigo500,
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
    );
  }

  IconData _typeIcon(NotificationType type) {
    return switch (type) {
      NotificationType.assignment => LucideIcons.file_text,
      NotificationType.exam => LucideIcons.graduation_cap,
      NotificationType.message => LucideIcons.message_square,
      NotificationType.service => LucideIcons.compass,
      NotificationType.system => LucideIcons.info,
    };
  }

  Color _typeColor(NotificationType type) {
    return switch (type) {
      NotificationType.assignment => SynorColors.indigo500,
      NotificationType.exam => SynorColors.rose500,
      NotificationType.message => SynorColors.emerald500,
      NotificationType.service => SynorColors.amber500,
      NotificationType.system => SynorColors.slate500,
    };
  }
}
