import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../chat_notifier.dart';
import '../../../domain/enums.dart';

/// Presence Header - Slack styled top navigation bar with partner info and status
class PresenceHeader extends ConsumerWidget {
  final VoidCallback? onSearchTap;
  final VoidCallback? onStarredTap;
  final VoidCallback? onSettingsTap;

  const PresenceHeader({
    super.key,
    this.onSearchTap,
    this.onStarredTap,
    this.onSettingsTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatState = ref.watch(chatNotifierProvider);

    final otherUser = chatState.otherUser;
    final typingIndicator = chatState.typingIndicator;

    final String partnerName = (otherUser?.displayName != null && otherUser!.displayName!.isNotEmpty)
        ? otherUser.displayName!
        : (otherUser?.role == UserRole.user1 ? 'User One' : 'User Two');
    final isOnline = otherUser?.isOnline ?? false;
    final isTyping = typingIndicator?.isTyping ?? false;
    final isRecording = typingIndicator?.isRecording ?? false;

    // Header background: Obsidian Charcoal with Velvet Plum border
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.obsidianVoid,
        border: const Border(
          bottom: BorderSide(
            color: AppColors.borderDark,
            width: 1,
          ),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x26000000),
            offset: Offset(0, 2),
            blurRadius: 6,
          ),
        ],
      ),
      child: Row(
        children: [
          // Sleek stealth avatar
          Stack(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: AppColors.toneOfDarkGrey,
                  borderRadius: BorderRadius.circular(19),
                  border: Border.all(
                    color: AppColors.borderDark,
                    width: 1.5,
                  ),
                ),
                child: Center(
                  child: Text(
                    partnerName.isNotEmpty ? partnerName[0].toUpperCase() : 'U',
                    style: const TextStyle(
                      color: AppColors.pureWhite,
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.7, end: 1.0),
                  duration: const Duration(milliseconds: 1200),
                  builder: (context, val, child) {
                    return Container(
                      width: 11,
                      height: 11,
                      decoration: BoxDecoration(
                        color: isOnline ? AppColors.roseMauve : AppColors.mutedMauve,
                        shape: BoxShape.circle,
                        boxShadow: isOnline
                            ? [
                                BoxShadow(
                                  color: AppColors.roseMauve.withValues(alpha: 0.5 * val),
                                  blurRadius: 4,
                                  spreadRadius: 1,
                                ),
                              ]
                            : null,
                        border: Border.all(
                          color: AppColors.obsidianVoid,
                          width: 2,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),

          const SizedBox(width: 12),

          // Partner Name & Status
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        partnerName,
                        style: const TextStyle(
                          color: AppColors.pureWhite,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.2,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                      decoration: BoxDecoration(
                        color: AppColors.roseMauve.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: AppColors.roseMauve.withValues(alpha: 0.3),
                          width: 0.8,
                        ),
                      ),
                      child: const Text(
                        'secure',
                        style: TextStyle(
                          color: AppColors.roseMauve,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                if (isTyping)
                  const Text(
                    'transmitting...',
                    style: TextStyle(
                      color: AppColors.roseMauve,
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                    ),
                  )
                else if (isRecording)
                  const Text(
                    'recording audio...',
                    style: TextStyle(
                      color: AppColors.roseMauve,
                      fontSize: 12,
                    ),
                  )
                else
                  Text(
                    isOnline ? 'Active now' : 'Away',
                    style: TextStyle(
                      color: isOnline ? AppColors.roseMauve : AppColors.mutedMauve,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              ],
            ),
          ),

          // Action Buttons
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildActionButton(
                icon: Icons.search_rounded,
                onTap: onSearchTap,
              ),
              _buildActionButton(
                icon: Icons.star_outline_rounded,
                onTap: onStarredTap,
              ),
              _buildActionButton(
                icon: Icons.settings_outlined,
                onTap: onSettingsTap,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required VoidCallback? onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        splashColor: Colors.white12,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Icon(
            icon,
            color: Colors.white,
            size: 22,
          ),
        ),
      ),
    );
  }
}