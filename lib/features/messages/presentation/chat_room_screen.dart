import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/router/app_route_controller.dart';
import '../../../app/theme/synor_design_tokens.dart';
import '../../../core/async/synor_async_state_view.dart';
import '../../../shared/widgets/synor_widgets.dart';
import '../../users/application/current_user_controller.dart';
import '../application/chat_room_controller.dart';
import '../domain/messages_models.dart';

class ChatRoomScreen extends ConsumerStatefulWidget {
  const ChatRoomScreen({super.key, required this.roomId, required this.roomName});

  final String roomId;
  final String roomName;

  @override
  ConsumerState<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends ConsumerState<ChatRoomScreen> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    ref.read(chatRoomNotifierProvider.notifier).sendMessage(widget.roomId, text);
    _messageController.clear();
    
    // Smooth scroll to bottom
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0,
          duration: SynorMotion.overlay,
          curve: Curves.easeOutCubic,
        );
      }
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final messagesAsync = ref.watch(chatRoomMessagesProvider(widget.roomId));
    final currentUser = ref.watch(currentUserControllerProvider).valueOrNull;
    final router = ref.read(appRouteControllerProvider);

    return Column(
      children: [
        // Header
        Container(
          padding: const EdgeInsets.fromLTRB(16, 48, 24, 16),
          decoration: BoxDecoration(
            color: synorIsDark(context) ? SynorColors.appBlack : Colors.white,
            border: Border(
              bottom: BorderSide(
                color: synorIsDark(context) ? SynorColors.white10 : SynorColors.slate200,
              ),
            ),
          ),
          child: Row(
            children: [
              SynorIconActionButton(
                icon: LucideIcons.chevron_left,
                onTap: router.closeChatRoom,
                buttonSize: 40,
                radius: 12,
                backgroundColor: Colors.transparent,
                borderColor: Colors.transparent,
              ),
              const SizedBox(width: 8),
              CircleAvatar(
                radius: 18,
                backgroundColor: SynorColors.indigo500.withValues(alpha: 0.1),
                child: Text(
                  widget.roomName.isNotEmpty ? widget.roomName[0] : '?',
                  style: const TextStyle(color: SynorColors.indigo500, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.roomName,
                      style: TextStyle(
                        color: synorPrimaryText(context),
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'Online', // Could be dynamic in next phases
                      style: TextStyle(
                        color: SynorColors.emerald500,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              SynorIconActionButton(
                icon: LucideIcons.video,
                onTap: () {}, // Future feature
                radius: 12,
                size: 20,
                backgroundColor: Colors.transparent,
                borderColor: Colors.transparent,
              ),
            ],
          ),
        ),

        // Message List
        Expanded(
          child: SynorAsyncStateView(
            value: messagesAsync,
            data: (messages) {
              final reversedMessages = messages.reversed.toList();
              return ListView.builder(
                controller: _scrollController,
                reverse: true, // New messages at bottom
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
                itemCount: reversedMessages.length,
                itemBuilder: (context, index) {
                  final message = reversedMessages[index];
                  final isMe = message.isMe(currentUser?.id ?? '');
                  return _MessageBubble(message: message, isMe: isMe);
                },
              );
            },
          ),
        ),

        // Input Area
        Container(
          padding: EdgeInsets.fromLTRB(20, 12, 20, 32 + MediaQuery.viewInsetsOf(context).bottom),
          decoration: BoxDecoration(
            color: synorIsDark(context) ? SynorColors.deepBlack : Colors.white,
            border: Border(
              top: BorderSide(
                color: synorIsDark(context) ? SynorColors.white5 : SynorColors.slate100,
              ),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: synorIsDark(context) ? SynorColors.white5 : SynorColors.slate50,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Type a message...',
                      border: InputBorder.none,
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              PressableScale(
                onTap: _sendMessage,
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [SynorColors.indigo500, SynorColors.indigo600],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x336366F1),
                        blurRadius: 12,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(LucideIcons.send_horizontal, color: Colors.white, size: 20),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.message, required this.isMe});

  final ChatMessage message;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width * 0.75),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isMe 
                  ? SynorColors.indigo500 
                  : (synorIsDark(context) ? SynorColors.white10 : SynorColors.slate100),
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(20),
                topRight: const Radius.circular(20),
                bottomLeft: Radius.circular(isMe ? 20 : 4),
                bottomRight: Radius.circular(isMe ? 4 : 20),
              ),
              gradient: isMe ? const LinearGradient(
                colors: [SynorColors.indigo500, SynorColors.indigo600],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ) : null,
            ),
            child: Text(
              message.content,
              style: TextStyle(
                color: isMe ? Colors.white : synorPrimaryText(context),
                fontSize: 15,
                height: 1.4,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '12:45', // Should be dynamic in next phases
            style: TextStyle(
              color: synorSecondaryText(context),
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}
