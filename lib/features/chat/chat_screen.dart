import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/security/session_manager.dart';
import '../../core/theme/app_colors.dart';
import '../../domain/models/message.dart';
import 'chat_notifier.dart';
import 'widgets/message_bubble.dart';
import 'widgets/message_input_bar.dart';
import 'widgets/presence_header.dart';
import 'widgets/swipe_to_reply.dart';

/// Chat Screen - Clean Slack-inspired 1-on-1 private chat
class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> with WidgetsBindingObserver {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(chatNotifierProvider.notifier).markAsRead();
      ref.read(chatNotifierProvider.notifier).setPresence(true);
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ref.read(chatNotifierProvider.notifier).setPresence(true);
      ref.read(chatNotifierProvider.notifier).markAsRead();
    } else if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached) {
      ref.read(chatNotifierProvider.notifier).setPresence(false);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    ref.read(chatNotifierProvider.notifier).setPresence(false);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
      );
    }
  }

  void _showMessageActionSheet(
    BuildContext context,
    Message message,
    bool isMe,
    ChatNotifier notifier,
    bool isDark,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? const Color(0xFF222529) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Quick emoji reaction bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: ['👍', '❤️', '😂', '😮', '😢', '🔥', '🎉'].asMap().entries.map((entry) {
                      final idx = entry.key;
                      final emoji = entry.value;
                      return TweenAnimationBuilder<double>(
                        tween: Tween<double>(begin: 0.0, end: 1.0),
                        duration: Duration(milliseconds: 200 + (idx * 40)),
                        curve: Curves.easeOutBack,
                        builder: (context, scale, child) {
                          return Transform.scale(
                            scale: scale,
                            child: child,
                          );
                        },
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(sheetContext);
                            notifier.addReaction(message.id, emoji);
                          },
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            child: Text(emoji, style: const TextStyle(fontSize: 24)),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                Divider(
                  color: isDark ? const Color(0xFF35373B) : AppColors.fog,
                  height: 1,
                ),

                // Reply
                ListTile(
                  leading: Icon(
                    Icons.reply_rounded,
                    color: isDark ? const Color(0xFFD1D2D3) : AppColors.charcoal,
                  ),
                  title: Text(
                    'Reply in thread',
                    style: TextStyle(
                      color: isDark ? const Color(0xFFD1D2D3) : AppColors.carbon,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(sheetContext);
                    notifier.startReply(message);
                  },
                ),

                // Copy Text (if text exists)
                if (message.content != null && message.content!.isNotEmpty)
                  ListTile(
                    leading: Icon(
                      Icons.copy_rounded,
                      color: isDark ? const Color(0xFFD1D2D3) : AppColors.charcoal,
                    ),
                    title: Text(
                      'Copy text',
                      style: TextStyle(
                        color: isDark ? const Color(0xFFD1D2D3) : AppColors.carbon,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(sheetContext);
                      Clipboard.setData(ClipboardData(text: message.content!));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Copied to clipboard'),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    },
                  ),

                // Star / Unstar
                ListTile(
                  leading: Icon(
                    message.isStarred
                        ? Icons.star_rounded
                        : Icons.star_border_rounded,
                    color: message.isStarred
                        ? const Color(0xFFECB22E)
                        : (isDark ? const Color(0xFFD1D2D3) : AppColors.charcoal),
                  ),
                  title: Text(
                    message.isStarred ? 'Unstar message' : 'Star message',
                    style: TextStyle(
                      color: isDark ? const Color(0xFFD1D2D3) : AppColors.carbon,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(sheetContext);
                    notifier.toggleStar(message.id);
                  },
                ),

                // Delete for me
                ListTile(
                  leading: const Icon(
                    Icons.delete_outline_rounded,
                    color: Color(0xFFE01E5A),
                  ),
                  title: const Text(
                    'Delete for me',
                    style: TextStyle(color: Color(0xFFE01E5A)),
                  ),
                  onTap: () {
                    Navigator.pop(sheetContext);
                    notifier.deleteForMe(message.id);
                  },
                ),

                // Delete for everyone (if current user sent it)
                if (isMe)
                  ListTile(
                    leading: const Icon(
                      Icons.delete_forever_rounded,
                      color: Color(0xFFE01E5A),
                    ),
                    title: const Text(
                      'Delete for everyone',
                      style: TextStyle(
                        color: Color(0xFFE01E5A),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(sheetContext);
                      notifier.deleteForEveryone(message.id);
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final chatState = ref.watch(chatNotifierProvider);
    final notifier = ref.read(chatNotifierProvider.notifier);

    final session = ref.watch(sessionManagerProvider);
    final currentUserId = switch (session) {
      SessionAuthenticated(:final userId) => userId,
      _ => '',
    };

    final messages = chatState.messages.reversed.toList();
    final otherUserName = chatState.otherUser?.displayName ?? 'Your partner';

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: isDark ? const Color(0xFF1A1D21) : AppColors.softWhite,
        body: SafeArea(
          child: Column(
            children: [
              // Slack-style Channel Presence Header
              PresenceHeader(
                onSearchTap: () => context.push('/chat/search'),
                onStarredTap: () => context.push('/chat/starred'),
                onSettingsTap: () => context.push('/chat/settings'),
              ),

              // Message Body
              Expanded(
                child: messages.isEmpty
                    ? _buildEmptyState(otherUserName, isDark)
                    : ListView.builder(
                        controller: _scrollController,
                        reverse: true,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final message = messages[index];
                          final isMe = message.senderId == currentUserId;
                          final replyToMessage = message.replyToId != null
                              ? chatState.messages.where((m) => m.id == message.replyToId).firstOrNull
                              : null;
                          final messageReactions = chatState.reactionsByMessageId[message.id] ?? const [];

                          return SwipeToReply(
                            key: ValueKey('swipe_${message.id}'),
                            onReply: () => notifier.startReply(message),
                            child: MessageBubble(
                              key: ValueKey(message.id),
                              domainMessage: message,
                              isSent: isMe,
                              reactions: messageReactions,
                              currentUserId: currentUserId,
                              repliedMessage: replyToMessage,
                              otherUserName: otherUserName,
                              onReactionTap: (emoji) => notifier.addReaction(message.id, emoji),
                              onReply: () => notifier.startReply(message),
                              onLongPress: () => _showMessageActionSheet(
                                context,
                                message,
                                isMe,
                                notifier,
                                isDark,
                              ),
                            ),
                          );
                        },
                      ),
              ),

              // Typing indicator
              if (chatState.typingIndicator != null &&
                  chatState.typingIndicator!.isTyping)
                _buildTypingIndicator(otherUserName, isDark),

              // Message Input Bar
              MessageInputBar(
                replyingTo: chatState.replyingTo,
                onCancelReply: notifier.cancelReply,
                onSendText: (text) {
                  notifier.sendTextMessage(text);
                  _scrollToBottom();
                },
                onSendMedia: (path, type, {isViewOnce = false}) {
                  notifier.sendMediaMessage(path, type, isViewOnce: isViewOnce);
                  _scrollToBottom();
                },
                onSendVoice: (path, duration) {
                  notifier.sendVoiceNote(path, duration);
                  _scrollToBottom();
                },
                onTyping: (isTyping) {
                  notifier.updateTyping(isTyping);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(String partnerName, bool isDark) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF222529) : AppColors.purpleHaze,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark ? const Color(0xFF35373B) : AppColors.lavenderMist,
                  width: 1,
                ),
              ),
              child: const Center(
                child: Text(
                  '#',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    color: AppColors.aubergine,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'This is the start of your direct conversation with $partnerName',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: isDark ? const Color(0xFFD1D2D3) : AppColors.carbon,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'All messages, media, and voice notes are private, encrypted, and synchronized in real time.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: isDark ? const Color(0xFFABABAD) : AppColors.charcoal,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypingIndicator(String partnerName, bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      alignment: Alignment.centerLeft,
      child: Text(
        '$partnerName is typing...',
        style: TextStyle(
          fontSize: 12,
          fontStyle: FontStyle.italic,
          color: isDark ? const Color(0xFFABABAD) : AppColors.midGray,
        ),
      ),
    );
  }
}
