import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/async/synor_async_state_view.dart';
import '../../../l10n/l10n.dart';
import '../../../shared/widgets/synor_widgets.dart';
import '../application/messages_controller.dart';
import '../../../app/router/app_route_controller.dart';

class MessagesScreen extends ConsumerWidget {
  const MessagesScreen({super.key, required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messagesAsync = ref.watch(messagesProvider);
    final router = ref.read(appRouteControllerProvider);
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(24, 48, 24, 16),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: synorIsDark(context)
                    ? const Color(0x1AFFFFFF)
                    : const Color(0xFFE2E8F0),
              ),
            ),
          ),
          child: Row(
            children: [
              SynorIconActionButton(
                icon: LucideIcons.chevron_left,
                onTap: onBack,
                buttonSize: 40,
                radius: 999,
                size: 24,
                backgroundColor: Colors.transparent,
                borderColor: Colors.transparent,
                boxShadow: const [],
                foregroundColor: synorIsDark(context)
                    ? Colors.white
                    : const Color(0xFF0F172A),
              ),
              const SizedBox(width: 16),
              Text(
                context.l10n.messages_title,
                style: TextStyle(
                  color: synorPrimaryText(context),
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: SynorAsyncStateView(
            value: messagesAsync,
            loadingTitle: context.l10n.messages_loadingTitle,
            loadingMessage: context.l10n.messages_loadingMessage,
            onRetry: () => ref.invalidate(messagesProvider),
            data: (messages) => ListView.separated(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
              itemCount: messages.length,
              separatorBuilder: (_, _) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final preview = messages[index];
                return MessageTile(
                  preview: preview,
                  onTap: () => router.goToChatRoom(preview.roomId),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
