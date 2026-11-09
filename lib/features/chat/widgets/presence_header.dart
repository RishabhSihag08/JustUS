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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final chatState = ref.watch(chatNotifierProvider);

    final otherUser = chatState.otherUser;
    final typingIndicator = chatState.typingIndicator;

    final String partnerName = (otherUser?.displayName != null && otherUser!.displayName!.isNotEmpty)
        ? otherUser.displayName!
        : (otherUser?.role == UserRole.user1 ? 'User One' : 'User Two');
    final isOnline = otherUser?.isOnline ?? true;
    final isTyping = typingIndicator?.isTyping ?? false;
    final isRecording = typingIndicator?.isRecording ?? false;

    // Header background: Slack Deep Plum for branding
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A1D21) : AppColors.deepPlum,
        border: Border(
          bottom: BorderSide(
            color: isDark ? const Color(0xFF35373B) : AppColors.plumShadow,
            width: 1,
          ),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            offset: Offset(0, 2),
            blurRadius: 6,
          ),
        ],
      ),
      child: Row(
        children: [
          // Slack channel # or avatar
          Stack(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: AppColors.aubergine,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.lavenderMist.withValues(alpha: 0.3)),
                ),
                child: Center(
                  child: Text(
                    partnerName.isNotEmpty ? partnerName[0].toUpperCase() : '#',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  width: 11,
                  height: 11,
                  decoration: BoxDecoration(
                    color: isOnline ? AppColors.success : AppColors.midGray,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isDark ? const Color(0xFF1A1D21) : AppColors.deepPlum,
                      width: 2,
                    ),
                  ),
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
                          color: Colors.white,
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
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'direct',
                        style: TextStyle(
                          color: Colors.white70,
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
                    'typing...',
                    style: TextStyle(
                      color: AppColors.lavenderMist,
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                    ),
                  )
                else if (isRecording)
                  const Text(
                    'recording audio...',
                    style: TextStyle(
                      color: AppColors.warning,
                      fontSize: 12,
                    ),
                  )
                else
                  Text(
                    isOnline ? 'Active now' : 'Away',
                    style: TextStyle(
                      color: isOnline ? AppColors.success : Colors.white60,
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