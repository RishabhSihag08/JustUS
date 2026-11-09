import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../domain/models/message.dart';
import '../../../domain/models/reaction.dart';
import '../../../domain/enums.dart';
import 'delivery_status_icon.dart';
import 'voice_note_player.dart';

/// Message Bubble - Clean Slack-styled message bubble
class MessageBubble extends ConsumerWidget {
  final bool isSent;
  final Map<String, dynamic>? message;
  final Message? domainMessage;
  final List<Reaction> reactions;
  final String? currentUserId;
  final void Function(String emoji)? onReactionTap;
  final VoidCallback? onReply;
  final VoidCallback? onLongPress;
  final Message? repliedMessage;
  final String? otherUserName;

  const MessageBubble({
    super.key,
    required this.isSent,
    this.message,
    this.domainMessage,
    this.reactions = const [],
    this.currentUserId,
    this.onReactionTap,
    this.onReply,
    this.onLongPress,
    this.repliedMessage,
    this.otherUserName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final type = domainMessage?.type.name ?? (message?['type'] as String? ?? 'text');
    final text = domainMessage?.content ?? (message?['text'] as String? ?? '');
    final time = domainMessage != null
        ? '${domainMessage!.createdAt.hour.toString().padLeft(2, '0')}:${domainMessage!.createdAt.minute.toString().padLeft(2, '0')}'
        : (message?['time'] as String? ?? '');
    final status = domainMessage?.status.name ?? (message?['status'] as String? ?? 'sent');
    final isStarred = domainMessage?.isStarred ?? (message?['isStarred'] as bool? ?? false);
    final mediaUrl = domainMessage?.mediaUrl ?? (message?['mediaUrl'] as String?);
    final isViewOnce = domainMessage?.type == MessageType.viewOnce || (message?['isViewOnce'] as bool? ?? false);
    final isViewOnceViewed = domainMessage?.viewOnceViewed ?? (message?['viewOnceViewed'] as bool? ?? false);

    return Align(
      alignment: isSent ? Alignment.centerRight : Alignment.centerLeft,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onLongPress: onLongPress,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.78,
          ),
          margin: EdgeInsets.only(
            bottom: 6,
            left: isSent ? 48 : 12,
            right: isSent ? 12 : 48,
          ),
          child: Column(
            crossAxisAlignment: isSent ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              // Reply preview bar
              if (repliedMessage != null || message?['replyTo'] != null)
                _buildReplyPreview(theme, colorScheme, isDark),

              // Main bubble
              _buildBubble(context, type, text, mediaUrl, domainMessage?.mediaDuration, isViewOnce, isViewOnceViewed, theme, colorScheme, isDark),

              // Timestamp and status footer
              _buildFooter(time, status, isStarred, theme, colorScheme, isDark),

              // Reactions
              if (reactions.isNotEmpty || ((message?['reactions'] as List?)?.isNotEmpty ?? false))
                _buildReactions(theme, colorScheme, isDark),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReplyPreview(ThemeData theme, ColorScheme colorScheme, bool isDark) {
    String senderName = 'Reply';
    String replyText = '';

    if (repliedMessage != null) {
      senderName = (repliedMessage!.senderId == currentUserId)
          ? 'You'
          : (otherUserName ?? 'Partner');
      replyText = switch (repliedMessage!.type) {
        MessageType.voice => '🎤 Voice note',
        MessageType.image => '📷 Photo',
        MessageType.video => '🎥 Video',
        MessageType.viewOnce => '🔒 View-once media',
        _ => repliedMessage!.content ?? '',
      };
    } else if (message?['replyTo'] != null) {
      final reply = message?['replyTo'] as Map<String, dynamic>? ?? {};
      senderName = reply['senderName'] as String? ?? 'Reply';
      replyText = reply['text'] as String? ?? '';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2A2D32) : AppColors.purpleHaze,
        borderRadius: BorderRadius.circular(6),
        border: const Border(
          left: BorderSide(
            color: AppColors.aubergine,
            width: 3,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            senderName,
            style: const TextStyle(
              color: AppColors.aubergine,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 1),
          Text(
            replyText,
            style: TextStyle(
              color: isDark ? Colors.white70 : AppColors.charcoal,
              fontSize: 12,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildBubble(
    BuildContext context,
    String type,
    String text,
    String? mediaUrl,
    int? mediaDuration,
    bool isViewOnce,
    bool isViewOnceViewed,
    ThemeData theme,
    ColorScheme colorScheme,
    bool isDark,
  ) {
    final messageId = domainMessage?.id ?? (message?['id'] as String? ?? '');
    if (isViewOnce || type == 'viewOnce' || type == 'view_once') {
      return _buildViewOnceBubble(context, messageId, isViewOnceViewed, isDark);
    }
    switch (type) {
      case 'text':
        return _buildTextBubble(text, isDark);
      case 'image':
      case 'video':
        return _buildMediaBubble(type, text, mediaUrl, isViewOnce, isViewOnceViewed, colorScheme, isDark);
      case 'voice':
        return _buildVoiceBubble(mediaUrl, mediaDuration, isDark);
      default:
        return _buildTextBubble(text, isDark);
    }
  }

  Widget _buildTextBubble(String text, bool isDark) {
    // Slack-inspired minimalist bubbles
    final bgColor = isSent
        ? (isDark ? const Color(0xFF381440) : AppColors.purpleHaze)
        : (isDark ? const Color(0xFF222529) : Colors.white);
    final borderColor = isSent
        ? (isDark ? const Color(0xFF611F69) : AppColors.lavenderMist)
        : (isDark ? const Color(0xFF35373B) : AppColors.fog);
    final textColor = isDark ? Colors.white : AppColors.carbon;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(12),
          topRight: const Radius.circular(12),
          bottomLeft: Radius.circular(isSent ? 12 : 2),
          bottomRight: Radius.circular(isSent ? 2 : 12),
        ),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: 15,
          height: 1.4,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  Widget _buildMediaBubble(
    String type,
    String text,
    String? mediaUrl,
    bool isViewOnce,
    bool isViewOnceViewed,
    ColorScheme colorScheme,
    bool isDark,
  ) {
    final bgColor = isDark ? const Color(0xFF222529) : Colors.white;
    final borderColor = isDark ? const Color(0xFF35373B) : AppColors.fog;

    Widget mediaWidget;
    if (mediaUrl != null && File(mediaUrl).existsSync()) {
      mediaWidget = Image.file(
        File(mediaUrl),
        fit: BoxFit.cover,
        width: 240,
        height: 180,
      );
    } else if (mediaUrl != null && mediaUrl.startsWith('http')) {
      mediaWidget = Image.network(
        mediaUrl,
        fit: BoxFit.cover,
        width: 240,
        height: 180,
        errorBuilder: (context, error, stackTrace) => _buildPlaceholderMedia(type, colorScheme),
      );
    } else {
      mediaWidget = _buildPlaceholderMedia(type, colorScheme);
    }

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            mediaWidget,
            if (text.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  text,
                  style: TextStyle(
                    color: isDark ? Colors.white : AppColors.carbon,
                    fontSize: 14,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholderMedia(String type, ColorScheme colorScheme) {
    return Container(
      width: 240,
      height: 160,
      color: const Color(0xFFF0EDF2),
      child: Center(
        child: Icon(
          type == 'image' ? Icons.image_outlined : Icons.videocam_outlined,
          size: 44,
          color: AppColors.midGray,
        ),
      ),
    );
  }

  Widget _buildVoiceBubble(String? mediaUrl, int? mediaDuration, bool isDark) {
    final bgColor = isSent
        ? (isDark ? const Color(0xFF381440) : AppColors.purpleHaze)
        : (isDark ? const Color(0xFF222529) : Colors.white);
    final borderColor = isSent
        ? (isDark ? const Color(0xFF611F69) : AppColors.lavenderMist)
        : (isDark ? const Color(0xFF35373B) : AppColors.fog);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: VoiceNotePlayer(
        audioUrl: mediaUrl,
        duration: mediaDuration != null ? Duration(milliseconds: mediaDuration) : null,
        isSent: isSent,
      ),
    );
  }

  Widget _buildViewOnceBubble(
    BuildContext context,
    String messageId,
    bool isViewOnceViewed,
    bool isDark,
  ) {
    final bgColor = isSent
        ? (isDark ? const Color(0xFF381440) : AppColors.purpleHaze)
        : (isDark ? const Color(0xFF222529) : Colors.white);
    final borderColor = isSent
        ? (isDark ? const Color(0xFF611F69) : AppColors.lavenderMist)
        : (isDark ? const Color(0xFF35373B) : AppColors.fog);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          if (isViewOnceViewed) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('This view-once media has already expired'),
                duration: Duration(seconds: 2),
                behavior: SnackBarBehavior.floating,
              ),
            );
            return;
          }
          if (messageId.isNotEmpty) {
            context.push('/view-once/$messageId');
          }
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: borderColor, width: 1),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isViewOnceViewed ? Icons.check_circle_outline_rounded : Icons.lock_clock_outlined,
                color: isViewOnceViewed ? AppColors.success : AppColors.warning,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                isViewOnceViewed ? 'Opened view-once' : 'View Once Media',
                style: TextStyle(
                  color: isDark ? Colors.white : AppColors.carbon,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFooter(
    String time,
    String status,
    bool isStarred,
    ThemeData theme,
    ColorScheme colorScheme,
    bool isDark,
  ) {
    return Padding(
      padding: const EdgeInsets.only(top: 2, left: 4, right: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isStarred) ...[
            const Icon(
              Icons.star_rounded,
              size: 13,
              color: AppColors.warning,
            ),
            const SizedBox(width: 3),
          ],
          Text(
            time,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.midGray,
              fontWeight: FontWeight.w400,
            ),
          ),
          if (isSent) ...[
            const SizedBox(width: 4),
            DeliveryStatusIcon(status: status),
          ],
        ],
      ),
    );
  }

  Widget _buildReactions(ThemeData theme, ColorScheme colorScheme, bool isDark) {
    if (reactions.isEmpty) {
      final legacy = message?['reactions'] as List<dynamic>? ?? [];
      if (legacy.isEmpty) return const SizedBox.shrink();
      final Map<String, int> counts = {};
      for (final r in legacy) {
        final emoji = r['emoji'] as String? ?? '❤️';
        counts[emoji] = (counts[emoji] ?? 0) + 1;
      }

      return Padding(
        padding: const EdgeInsets.only(top: 3),
        child: Wrap(
          spacing: 4,
          runSpacing: 4,
          children: counts.entries.map((e) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF2A2D32) : const Color(0xFFF0EDF2),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isDark ? const Color(0xFF35373B) : AppColors.fog,
                ),
              ),
              child: Text(
                '${e.key} ${e.value}',
                style: const TextStyle(fontSize: 12),
              ),
            );
          }).toList(),
        ),
      );
    }

    final Map<String, List<Reaction>> grouped = {};
    for (final r in reactions) {
      grouped.putIfAbsent(r.emoji, () => []).add(r);
    }

    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Wrap(
        spacing: 4,
        runSpacing: 4,
        children: grouped.entries.map((entry) {
          final emoji = entry.key;
          final count = entry.value.length;
          final isMeReacted = currentUserId != null &&
              entry.value.any((r) => r.userId == currentUserId);

          final pillBg = isMeReacted
              ? (isDark ? const Color(0xFF4A154B).withValues(alpha: 0.6) : AppColors.purpleHaze)
              : (isDark ? const Color(0xFF2A2D32) : const Color(0xFFF0EDF2));

          final pillBorder = isMeReacted
              ? AppColors.aubergine
              : (isDark ? const Color(0xFF35373B) : AppColors.fog);

          return GestureDetector(
            onTap: () => onReactionTap?.call(emoji),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
              decoration: BoxDecoration(
                color: pillBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: pillBorder,
                  width: isMeReacted ? 1.5 : 1.0,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    emoji,
                    style: const TextStyle(fontSize: 13),
                  ),
                  if (count > 1) ...[
                    const SizedBox(width: 4),
                    Text(
                      '$count',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: isMeReacted ? FontWeight.w700 : FontWeight.w500,
                        color: isMeReacted
                            ? (isDark ? Colors.white : AppColors.aubergine)
                            : (isDark ? Colors.white70 : AppColors.charcoal),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
