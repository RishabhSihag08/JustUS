import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/security/session_manager.dart';
import '../../../core/theme/app_colors.dart';
import '../../../domain/enums.dart';
import '../../../domain/models/message.dart';
import '../../../providers/repository_providers.dart';

/// Starred messages screen - Slack inspired
class StarredMessagesScreen extends ConsumerStatefulWidget {
  const StarredMessagesScreen({super.key});

  @override
  ConsumerState<StarredMessagesScreen> createState() => _StarredMessagesScreenState();
}

class _StarredMessagesScreenState extends ConsumerState<StarredMessagesScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return PopScope(
      canPop: true,
      child: Scaffold(
        backgroundColor: isDark ? AppColors.obsidianCharcoal : AppColors.obsidianCharcoal,
        body: SafeArea(
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.obsidianCharcoal : AppColors.obsidianCharcoal,
                  border: Border(
                    bottom: BorderSide(
                      color: isDark ? const Color(0xFF381F31) : AppColors.borderDark,
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      color: isDark ? AppColors.pureWhite : AppColors.pureWhite,
                      onPressed: () => Navigator.pop(context),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    const SizedBox(width: 12),
                    const Icon(
                      Icons.star_rounded,
                      color: AppColors.roseMauve,
                      size: 22,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Starred Messages',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.pureWhite,
                      ),
                    ),
                  ],
                ),
              ),

              // Starred messages list
              Expanded(
                child: _buildStarredList(context, isDark),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStarredList(BuildContext context, bool isDark) {
    final session = ref.watch(sessionManagerProvider);

    final userId = switch (session) {
      SessionAuthenticated(:final userId) => userId,
      _ => '',
    };

    if (userId.isEmpty) {
      return const Center(child: CircularProgressIndicator(color: AppColors.aubergine));
    }

    return StreamBuilder<List<Message>>(
      stream: ref.read(databaseProvider).starredMessagesDao.watchStarredMessagesAsMessages(userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: AppColors.aubergine));
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error loading starred messages',
              style: TextStyle(
                color: isDark ? const Color(0xFFABABAD) : AppColors.midGray,
              ),
            ),
          );
        }

        final starredMessages = snapshot.data ?? [];

        if (starredMessages.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.star_outline_rounded,
                  size: 56,
                  color: isDark ? const Color(0xFF454245) : AppColors.lavenderMist,
                ),
                const SizedBox(height: 16),
                Text(
                  'No starred messages',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: isDark ? const Color(0xFFD1D2D3) : AppColors.carbon,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Long-press any message and tap Star to save it here',
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark ? const Color(0xFFABABAD) : AppColors.midGray,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          itemCount: starredMessages.length,
          itemBuilder: (context, index) {
            final message = starredMessages[index];
            final isSent = message.senderId == userId;

            return _StarredMessageTile(
              message: message,
              isSent: isSent,
              isDark: isDark,
              onTap: () {
                Navigator.pop(context, message);
              },
            );
          },
        );
      },
    );
  }
}

/// Starred message tile widget
class _StarredMessageTile extends ConsumerWidget {
  final Message message;
  final bool isSent;
  final bool isDark;
  final VoidCallback onTap;

  const _StarredMessageTile({
    required this.message,
    required this.isSent,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: AppColors.surfaceDark,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: AppColors.borderDark,
            width: 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.star_rounded,
              size: 20,
              color: AppColors.roseMauve,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        isSent ? 'You' : 'Partner',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.pureWhite,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        _formatTime(message.createdAt),
                        style: TextStyle(
                          fontSize: 11,
                          color: isDark ? AppColors.mutedMauve : AppColors.mutedMauve,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  _buildMessagePreview(context, message),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessagePreview(BuildContext context, Message message) {
    switch (message.type) {
      case MessageType.text:
        return Text(
          message.content ?? '',
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 14,
            color: isDark ? const Color(0xFFD1D2D3) : AppColors.carbon,
          ),
        );
      case MessageType.image:
        return Row(
          children: [
            Icon(Icons.image_outlined, size: 16, color: isDark ? const Color(0xFFABABAD) : AppColors.charcoal),
            const SizedBox(width: 6),
            Text(
              (message.content?.isEmpty ?? true) ? 'Photo' : message.content!,
              style: TextStyle(
                fontSize: 14,
                color: isDark ? const Color(0xFFABABAD) : AppColors.charcoal,
              ),
            ),
          ],
        );
      case MessageType.video:
        return Row(
          children: [
            Icon(Icons.videocam_outlined, size: 16, color: isDark ? const Color(0xFFABABAD) : AppColors.charcoal),
            const SizedBox(width: 6),
            Text(
              (message.content?.isEmpty ?? true) ? 'Video' : message.content!,
              style: TextStyle(
                fontSize: 14,
                color: isDark ? const Color(0xFFABABAD) : AppColors.charcoal,
              ),
            ),
          ],
        );
      case MessageType.voice:
        return Row(
          children: [
            Icon(Icons.mic_none_rounded, size: 16, color: isDark ? const Color(0xFFABABAD) : AppColors.charcoal),
            const SizedBox(width: 6),
            Text(
              'Voice note',
              style: TextStyle(
                fontSize: 14,
                color: isDark ? const Color(0xFFABABAD) : AppColors.charcoal,
              ),
            ),
          ],
        );
      case MessageType.document:
        return Row(
          children: [
            Icon(Icons.description_outlined, size: 16, color: isDark ? const Color(0xFFABABAD) : AppColors.charcoal),
            const SizedBox(width: 6),
            Text(
              (message.content?.isEmpty ?? true) ? 'Document' : message.content!,
              style: TextStyle(
                fontSize: 14,
                color: isDark ? const Color(0xFFABABAD) : AppColors.charcoal,
              ),
            ),
          ],
        );
      case MessageType.viewOnce:
        return Row(
          children: [
            Icon(Icons.visibility_off_outlined, size: 16, color: isDark ? const Color(0xFFABABAD) : AppColors.charcoal),
            const SizedBox(width: 6),
            Text(
              'View-once media',
              style: TextStyle(
                fontSize: 14,
                color: isDark ? const Color(0xFFABABAD) : AppColors.charcoal,
              ),
            ),
          ],
        );
    }
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 7) {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'just now';
    }
  }
}
