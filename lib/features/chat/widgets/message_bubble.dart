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

/// Message Bubble - WhatsApp-blended reactions & SVG read receipts
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
        ? _formatTime(context, domainMessage!.createdAt.toLocal())
        : (message?['time'] as String? ?? '');
    final status = domainMessage?.status.name ?? (message?['status'] as String? ?? 'sent');
    final isStarred = domainMessage?.isStarred ?? (message?['isStarred'] as bool? ?? false);
    final mediaUrl = domainMessage?.mediaUrl ?? (message?['mediaUrl'] as String?);
    final isViewOnce = domainMessage?.type == MessageType.viewOnce || (message?['isViewOnce'] as bool? ?? false);
    final isViewOnceViewed = domainMessage?.viewOnceViewed ?? (message?['viewOnceViewed'] as bool? ?? false);

    final hasReactions = reactions.isNotEmpty || ((message?['reactions'] as List?)?.isNotEmpty ?? false);

    return Align(
      alignment: isSent ? Alignment.centerRight : Alignment.centerLeft,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onLongPress: onLongPress,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.78,
            minWidth: hasReactions ? 75 : 0,
          ),
          margin: EdgeInsets.only(
            bottom: hasReactions ? 14 : 5,
            left: isSent ? 48 : 12,
            right: isSent ? 12 : 48,
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Unified Bubble (contains reply preview if any, message content, and footer)
              _buildBubble(
                context,
                type,
                text,
                mediaUrl,
                domainMessage?.mediaDuration,
                isViewOnce,
                isViewOnceViewed,
                time,
                status,
                isStarred,
                theme,
                colorScheme,
                isDark,
              ),

              // WhatsApp-style blended reaction badge
              if (hasReactions)
                Positioned(
                  bottom: -10,
                  left: 12,
                  child: _buildReactionBadge(isDark),
                ),
            ],
          ),
        ),
      ),
    );
  }

  /// Reply preview bar inside or above the bubble
  Widget _buildReplyPreview(ThemeData theme, ColorScheme colorScheme, bool isDark) {
    String senderName = 'Reply';
    String replyText = '';

    if (repliedMessage != null) {
      senderName = (repliedMessage!.senderId == currentUserId)
          ? 'You'
          : (otherUserName ?? 'Partner');
      replyText = repliedMessage!.content ??
          (repliedMessage!.type == MessageType.voice
              ? 'Voice note'
              : (repliedMessage!.type == MessageType.image
                  ? 'Photo'
                  : 'Media'));
    } else if (message?['replyTo'] != null) {
      final replyData = message!['replyTo'] as Map<String, dynamic>;
      senderName = replyData['senderName'] as String? ?? 'Reply';
      replyText = replyData['text'] as String? ?? '';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isDark
            ? (isSent ? const Color(0xFF280E2E) : const Color(0xFF1E2125))
            : (isSent ? const Color(0xFFEEDDFF) : const Color(0xFFEFEBF1)),
        borderRadius: BorderRadius.circular(6),
        border: Border(
          left: BorderSide(
            color: isSent ? AppColors.aubergine : AppColors.channelBlue,
            width: 3,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            senderName,
            style: TextStyle(
              color: isSent ? AppColors.aubergine : AppColors.channelBlue,
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
    String time,
    String status,
    bool isStarred,
    ThemeData theme,
    ColorScheme colorScheme,
    bool isDark,
  ) {
    final messageId = domainMessage?.id ?? (message?['id'] as String? ?? '');
    if (isViewOnce || type == 'viewOnce' || type == 'view_once') {
      return _buildViewOnceBubble(context, messageId, isViewOnceViewed, time, status, isStarred, isDark);
    }
    switch (type) {
      case 'text':
        return _buildTextBubble(theme, colorScheme, text, time, status, isStarred, isDark);
      case 'image':
      case 'video':
        return _buildMediaBubble(type, text, mediaUrl, isViewOnce, isViewOnceViewed, time, status, isStarred, colorScheme, isDark);
      case 'voice':
        return _buildVoiceBubble(mediaUrl, mediaDuration, time, status, isStarred, isDark);
      default:
        return _buildTextBubble(theme, colorScheme, text, time, status, isStarred, isDark);
    }
  }

  String _formatTime(BuildContext context, DateTime dt) {
    final local = dt.toLocal();
    final is24Hour = MediaQuery.alwaysUse24HourFormatOf(context);
    if (is24Hour) {
      return '${local.hour.toString().padLeft(2, '0')}:${local.minute.toString().padLeft(2, '0')}';
    } else {
      final hour = local.hour % 12 == 0 ? 12 : local.hour % 12;
      return '$hour:${local.minute.toString().padLeft(2, '0')}';
    }
  }

  /// Compact text bubble with inline or bottom-aligned timestamp + SVG read receipt
  Widget _buildTextBubble(
    ThemeData theme,
    ColorScheme colorScheme,
    String text,
    String time,
    String status,
    bool isStarred,
    bool isDark,
  ) {
    final bgColor = isSent
        ? (isDark ? const Color(0xFF381440) : AppColors.purpleHaze)
        : (isDark ? const Color(0xFF222529) : Colors.white);
    final borderColor = isSent
        ? (isDark ? const Color(0xFF611F69) : AppColors.lavenderMist)
        : (isDark ? const Color(0xFF35373B) : AppColors.fog);
    final textColor = isDark ? Colors.white : AppColors.carbon;

    final hasReply = repliedMessage != null || message?['replyTo'] != null;

    final messageContent = Wrap(
      alignment: WrapAlignment.end,
      crossAxisAlignment: WrapCrossAlignment.end,
      spacing: 8,
      runSpacing: 2,
      children: [
        Text(
          text,
          style: TextStyle(
            color: textColor,
            fontSize: 15,
            height: 1.35,
            fontWeight: FontWeight.w400,
          ),
        ),
        _buildFooterRow(time, status, isStarred, isDark),
      ],
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
      child: hasReply
          ? IntrinsicWidth(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildReplyPreview(theme, colorScheme, isDark),
                  const SizedBox(height: 2),
                  messageContent,
                ],
              ),
            )
          : messageContent,
    );
  }

  Widget _buildMediaBubble(
    String type,
    String text,
    String? mediaUrl,
    bool isViewOnce,
    bool isViewOnceViewed,
    String time,
    String status,
    bool isStarred,
    ColorScheme colorScheme,
    bool isDark,
  ) {
    final bgColor = isSent
        ? (isDark ? const Color(0xFF381440) : AppColors.purpleHaze)
        : (isDark ? const Color(0xFF222529) : Colors.white);
    final borderColor = isSent
        ? (isDark ? const Color(0xFF611F69) : AppColors.lavenderMist)
        : (isDark ? const Color(0xFF35373B) : AppColors.fog);

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
                padding: const EdgeInsets.fromLTRB(10, 8, 10, 2),
                child: Text(
                  text,
                  style: TextStyle(
                    color: isDark ? Colors.white : AppColors.carbon,
                    fontSize: 14,
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 2, 10, 6),
              child: Align(
                alignment: Alignment.bottomRight,
                child: _buildFooterRow(time, status, isStarred, isDark),
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
      color: colorScheme.surfaceContainerHighest,
      child: Center(
        child: Icon(
          type == 'image' ? Icons.image_rounded : Icons.videocam_rounded,
          color: colorScheme.onSurfaceVariant,
          size: 48,
        ),
      ),
    );
  }

  Widget _buildVoiceBubble(
    String? mediaUrl,
    int? mediaDuration,
    String time,
    String status,
    bool isStarred,
    bool isDark,
  ) {
    final bgColor = isSent
        ? (isDark ? const Color(0xFF381440) : AppColors.purpleHaze)
        : (isDark ? const Color(0xFF222529) : Colors.white);
    final borderColor = isSent
        ? (isDark ? const Color(0xFF611F69) : AppColors.lavenderMist)
        : (isDark ? const Color(0xFF35373B) : AppColors.fog);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          VoiceNotePlayer(
            audioUrl: mediaUrl,
            duration: mediaDuration != null ? Duration(milliseconds: mediaDuration) : null,
            isSent: isSent,
          ),
          const SizedBox(height: 3),
          _buildFooterRow(time, status, isStarred, isDark),
        ],
      ),
    );
  }

  Widget _buildViewOnceBubble(
    BuildContext context,
    String messageId,
    bool isViewOnceViewed,
    String time,
    String status,
    bool isStarred,
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
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: borderColor, width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
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
              const SizedBox(height: 2),
              _buildFooterRow(time, status, isStarred, isDark),
            ],
          ),
        ),
      ),
    );
  }

  /// Compact timestamp + SVG delivery status tick row
  Widget _buildFooterRow(
    String time,
    String status,
    bool isStarred,
    bool isDark,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isStarred) ...[
          const Icon(
            Icons.star_rounded,
            size: 11,
            color: AppColors.warning,
          ),
          const SizedBox(width: 3),
        ],
        Text(
          time,
          style: TextStyle(
            fontSize: 11,
            color: isDark ? Colors.white54 : AppColors.midGray,
            fontWeight: FontWeight.w400,
          ),
        ),
        if (isSent) ...[
          const SizedBox(width: 4),
          DeliveryStatusIcon(status: status, size: 14),
        ],
      ],
    );
  }

  /// Blended reaction badge overlapping the bottom edge of the bubble (WhatsApp-style)
  Widget _buildReactionBadge(bool isDark) {
    final Map<String, List<Reaction>> grouped = {};
    if (reactions.isNotEmpty) {
      for (final r in reactions) {
        grouped.putIfAbsent(r.emoji, () => []).add(r);
      }
    } else {
      final legacy = message?['reactions'] as List<dynamic>? ?? [];
      for (final r in legacy) {
        final emoji = r['emoji'] as String? ?? '❤️';
        grouped.putIfAbsent(emoji, () => []).add(
          Reaction(
            messageId: domainMessage?.id ?? '',
            userId: '',
            emoji: emoji,
            createdAt: DateTime.now(),
          ),
        );
      }
    }

    if (grouped.isEmpty) return const SizedBox.shrink();

    final totalCount = grouped.values.fold<int>(0, (sum, list) => sum + list.length);
    final firstEmoji = grouped.keys.first;

    // Background matches bubble color, border matches chat background for the cutout look
    final badgeBg = isSent
        ? (isDark ? const Color(0xFF381440) : AppColors.purpleHaze)
        : (isDark ? const Color(0xFF222529) : Colors.white);

    final cutoutBorderColor = isDark ? const Color(0xFF1A1D21) : AppColors.softWhite;

    return GestureDetector(
      onTap: () => onReactionTap?.call(firstEmoji),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        padding: totalCount > 1
            ? const EdgeInsets.symmetric(horizontal: 6, vertical: 2)
            : const EdgeInsets.all(3.5),
        decoration: BoxDecoration(
          color: badgeBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: cutoutBorderColor,
            width: 2.0,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.35),
              blurRadius: 3,
              offset: const Offset(0, 1.5),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ...grouped.entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 1),
                child: Text(
                  entry.key,
                  style: const TextStyle(fontSize: 12, height: 1.1),
                ),
              );
            }),
            if (totalCount > 1) ...[
              const SizedBox(width: 3),
              Text(
                '$totalCount',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white70 : AppColors.charcoal,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
