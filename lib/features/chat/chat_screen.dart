import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/security/device_lock_service.dart';
import '../../core/security/session_manager.dart';
import '../../core/theme/app_colors.dart';
import '../../domain/enums.dart';
import '../../domain/models/message.dart';
import '../../providers/chat_visibility_provider.dart';
import '../../services/gallery_saver_service.dart';
import 'chat_notifier.dart';
import 'widgets/enlarged_media_viewer.dart';
import 'widgets/message_bubble.dart';
import 'widgets/message_input_bar.dart';
import 'widgets/presence_header.dart';
import 'widgets/swipe_to_reply.dart';
import 'widgets/typing_indicator.dart';

/// Chat Screen - Clean Slack-inspired 1-on-1 private chat
class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> with WidgetsBindingObserver {
  final ScrollController _scrollController = ScrollController();
  String? _highlightedMessageId;
  Timer? _highlightTimer;
  final Map<String, GlobalKey> _messageKeys = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(chatNotifierProvider.notifier).markAsRead();
      ref.read(chatNotifierProvider.notifier).setPresence(true);
      ref.read(isChatActiveProvider.notifier).setActive(true);
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ref.read(chatNotifierProvider.notifier).setPresence(true);
      ref.read(chatNotifierProvider.notifier).markAsRead();
      ref.read(isChatActiveProvider.notifier).setActive(true);
    } else if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached) {
      ref.read(chatNotifierProvider.notifier).setPresence(false);
      ref.read(isChatActiveProvider.notifier).setActive(false);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _highlightTimer?.cancel();
    ref.read(chatNotifierProvider.notifier).setPresence(false);
    ref.read(isChatActiveProvider.notifier).setActive(false);
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

  /// Scroll smoothly to a specific message and flash a highlight for 500ms
  void _scrollToAndHighlightMessage(String targetMessageId) {
    final chatState = ref.read(chatNotifierProvider);
    final reversedMessages = chatState.messages.reversed.toList();
    final targetIndex = reversedMessages.indexWhere((m) => m.id == targetMessageId);

    if (targetIndex == -1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Original message not found in conversation'),
          duration: Duration(seconds: 1),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final key = _messageKeys[targetMessageId];
    if (key?.currentContext != null) {
      Scrollable.ensureVisible(
        key!.currentContext!,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOutCubic,
        alignment: 0.5,
      );
    } else {
      final estimatedOffset = (targetIndex * 75.0).clamp(
        0.0,
        _scrollController.hasClients ? _scrollController.position.maxScrollExtent : 0.0,
      );
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          estimatedOffset,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeInOutCubic,
        ).then((_) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            final postKey = _messageKeys[targetMessageId];
            if (postKey?.currentContext != null) {
              Scrollable.ensureVisible(
                postKey!.currentContext!,
                duration: const Duration(milliseconds: 150),
                curve: Curves.easeOut,
                alignment: 0.5,
              );
            }
          });
        });
      }
    }

    setState(() {
      _highlightedMessageId = targetMessageId;
    });

    _highlightTimer?.cancel();
    _highlightTimer = Timer(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _highlightedMessageId = null;
        });
      }
    });
  }

  /// Save media from long-press or actions directly to Android Gallery
  Future<void> _saveMediaToGallery(BuildContext context, String mediaUrl) async {
    final messenger = ScaffoldMessenger.of(context);
    messenger.showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.roseMauve,
              ),
            ),
            SizedBox(width: 12),
            Text(
              'Saving to Gallery...',
              style: TextStyle(color: AppColors.titaniumText),
            ),
          ],
        ),
        duration: Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );

    final success = await GallerySaverService.saveToGallery(mediaUrl);
    if (!mounted) return;

    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              success ? Icons.check_circle_rounded : Icons.error_outline_rounded,
              color: success ? const Color(0xFF2EB67D) : const Color(0xFFE01E5A),
              size: 20,
            ),
            const SizedBox(width: 10),
            Text(
              success ? 'Saved to Gallery' : 'Failed to save to Gallery',
              style: const TextStyle(
                color: AppColors.titaniumText,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
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
      backgroundColor: AppColors.surfaceDark,
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
                  color: isDark ? const Color(0xFF4A2641) : AppColors.borderDark,
                  height: 1,
                ),

                // Reply
                ListTile(
                  leading: Icon(
                    Icons.reply_rounded,
                    color: isDark ? AppColors.roseMauve : AppColors.roseMauve,
                  ),
                  title: Text(
                    'Reply in thread',
                    style: TextStyle(
                      color: isDark ? AppColors.pureWhite : AppColors.pureWhite,
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
                      color: isDark ? AppColors.roseMauve : AppColors.roseMauve,
                    ),
                    title: Text(
                      'Copy text',
                      style: TextStyle(
                        color: isDark ? AppColors.pureWhite : AppColors.pureWhite,
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
                        ? AppColors.roseMauve
                        : (isDark ? AppColors.mutedMauve : AppColors.mutedMauve),
                  ),
                  title: Text(
                    message.isStarred ? 'Unstar message' : 'Star message',
                    style: TextStyle(
                      color: isDark ? AppColors.pureWhite : AppColors.pureWhite,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(sheetContext);
                    notifier.toggleStar(message.id);
                  },
                ),

                // Save to Gallery (for media messages: image & video)
                if (message.mediaUrl != null &&
                    message.mediaUrl!.isNotEmpty &&
                    (message.type == MessageType.image || message.type == MessageType.video))
                  ListTile(
                    leading: const Icon(
                      Icons.download_rounded,
                      color: AppColors.roseMauve,
                    ),
                    title: const Text(
                      'Save to Gallery',
                      style: TextStyle(
                        color: AppColors.pureWhite,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    onTap: () async {
                      Navigator.pop(sheetContext);
                      await _saveMediaToGallery(context, message.mediaUrl!);
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
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: const Color(0xFF2E1729),
                        content: const Row(
                          children: [
                            Icon(Icons.delete_outline_rounded, color: Color(0xFFE01E5A), size: 20),
                            SizedBox(width: 10),
                            Text(
                              'Message deleted for you',
                              style: TextStyle(color: AppColors.titaniumText, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        duration: const Duration(seconds: 2),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: const BorderSide(color: Color(0xFF5A2A4E), width: 1),
                        ),
                      ),
                    );
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
                    subtitle: const Text(
                      'This action cannot be undone',
                      style: TextStyle(
                        color: Color(0xFFE01E5A),
                        fontSize: 12,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(sheetContext);
                      _showDeleteForEveryoneConfirmation(
                        context,
                        message,
                        notifier,
                        isDark,
                      );
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showDeleteForEveryoneConfirmation(
    BuildContext context,
    Message message,
    ChatNotifier notifier,
    bool isDark,
  ) {
    showDialog(
      context: context,
      builder: (dialogCtx) {
        return AlertDialog(
          backgroundColor: AppColors.dialogDark,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: AppColors.borderDark, width: 1),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFE01E5A).withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.delete_forever_rounded,
                  color: Color(0xFFE01E5A),
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Delete for everyone?',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: isDark ? AppColors.pureWhite : AppColors.carbon,
                  ),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'This message will be permanently deleted for both you and your partner.',
                style: TextStyle(
                  fontSize: 14,
                  height: 1.4,
                  color: isDark ? AppColors.titaniumText : AppColors.charcoal,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFE01E5A).withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: const Color(0xFFE01E5A).withValues(alpha: 0.25),
                  ),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      color: Color(0xFFE01E5A),
                      size: 18,
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'This action cannot be undone.',
                        style: TextStyle(
                          color: Color(0xFFE01E5A),
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogCtx),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: isDark ? AppColors.mutedMauve : AppColors.midGray,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFFE01E5A),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              ),
              onPressed: () {
                Navigator.pop(dialogCtx);
                notifier.deleteForEveryone(message.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: const Color(0xFF2E1729),
                    content: const Row(
                      children: [
                        Icon(Icons.delete_sweep_rounded, color: Color(0xFFE01E5A), size: 20),
                        SizedBox(width: 10),
                        Text(
                          'Message deleted for everyone',
                          style: TextStyle(color: AppColors.titaniumText, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    duration: const Duration(seconds: 2),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(color: Color(0xFF5A2A4E), width: 1),
                    ),
                  ),
                );
              },
              child: const Text(
                'Delete for everyone',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
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
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        DeviceLockService.moveTaskToBack();
      },
      child: Scaffold(
        backgroundColor: AppColors.obsidianVoid,
        body: SafeArea(
          child: Column(
            children: [
              // Slack-style Channel Presence Header
              PresenceHeader(
                onSearchTap: () => context.push('/chat/search'),
                onStarredTap: () => context.push('/chat/starred'),
                onSettingsTap: () => context.push('/chat/settings'),
              ),

              // Message Body with Velvet & Obsidian Themed Doodle Wallpaper
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: AppColors.obsidianVoid,
                    image: DecorationImage(
                      image: AssetImage('assets/images/chat_bg.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
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
                            final bubbleKey = _messageKeys.putIfAbsent(message.id, () => GlobalKey());

                            return SwipeToReply(
                              key: ValueKey('swipe_${message.id}'),
                              onReply: () => notifier.startReply(message),
                              child: MessageBubble(
                                key: bubbleKey,
                                domainMessage: message,
                                isSent: isMe,
                                reactions: messageReactions,
                                currentUserId: currentUserId,
                                repliedMessage: replyToMessage,
                                otherUserName: otherUserName,
                                isHighlighted: _highlightedMessageId == message.id,
                                onReplyPreviewTap: replyToMessage != null
                                    ? () => _scrollToAndHighlightMessage(replyToMessage.id)
                                    : null,
                                onMediaTap: (message.mediaUrl != null && message.mediaUrl!.isNotEmpty)
                                    ? () {
                                        EnlargedMediaViewer.open(
                                          context,
                                          mediaUrl: message.mediaUrl!,
                                          caption: message.content != null && message.content!.isNotEmpty
                                              ? message.content
                                              : null,
                                          senderName: isMe ? 'You' : otherUserName,
                                          timestamp: message.createdAt,
                                          heroTag: 'media_${message.id}',
                                        );
                                      }
                                    : null,
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
              ),

              // Animated Typing Indicator matching reference GIF
              TypingIndicator(
                isVisible: chatState.typingIndicator != null &&
                    (chatState.typingIndicator!.isTyping ||
                        chatState.typingIndicator!.isRecording),
                partnerName: otherUserName,
                isRecording: chatState.typingIndicator?.isRecording ?? false,
                isDark: isDark,
              ),

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
                color: AppColors.toneOfDarkGrey,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.borderDark,
                  width: 1.5,
                ),
              ),
              child: const Center(
                child: Icon(
                  Icons.explore_rounded,
                  size: 32,
                  color: AppColors.roseMauve,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'This is the start of your encrypted sanctuary with $partnerName',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.pureWhite,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'All messages, media, and voice notes are private, encrypted, and synchronized in real time.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.mutedMauve,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }


}
