import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/security/session_manager.dart';
import '../../../core/theme/app_colors.dart';
import '../../../domain/models/message.dart';
import '../chat_notifier.dart';

/// Search screen for messages - Slack inspired
class MessageSearchScreen extends ConsumerStatefulWidget {
  const MessageSearchScreen({super.key});

  @override
  ConsumerState<MessageSearchScreen> createState() => _MessageSearchScreenState();
}

class _MessageSearchScreenState extends ConsumerState<MessageSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  Timer? _debounceTimer;
  List<Message> _searchResults = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _focusNode.requestFocus();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _focusNode.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.trim();

    _debounceTimer?.cancel();
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
      return;
    }

    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      _performSearch(query);
    });
  }

  Future<void> _performSearch(String query) async {
    setState(() => _isSearching = true);
    try {
      final results = await ref.read(chatNotifierProvider.notifier).searchMessages(query);
      if (mounted) {
        setState(() {
          _searchResults = results;
          _isSearching = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isSearching = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return PopScope(
      canPop: true,
      child: Scaffold(
        backgroundColor: isDark ? const Color(0xFF1A1D21) : AppColors.softWhite,
        body: SafeArea(
          child: Column(
            children: [
              // Search App Bar (Slack Aubergine accent)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF222529) : Colors.white,
                  border: Border(
                    bottom: BorderSide(
                      color: isDark ? const Color(0xFF35373B) : AppColors.fog,
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      color: isDark ? const Color(0xFFD1D2D3) : AppColors.charcoal,
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF1A1D21) : AppColors.purpleHaze,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isDark ? const Color(0xFF35373B) : AppColors.lavenderMist,
                            width: 1,
                          ),
                        ),
                        child: TextField(
                          controller: _searchController,
                          focusNode: _focusNode,
                          autofocus: true,
                          style: TextStyle(
                            fontSize: 15,
                            color: isDark ? const Color(0xFFD1D2D3) : AppColors.carbon,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Search in conversation...',
                            hintStyle: TextStyle(
                              fontSize: 14,
                              color: isDark ? const Color(0xFF696969) : AppColors.midGray,
                            ),
                            prefixIcon: _isSearching
                                ? const Padding(
                                    padding: EdgeInsets.all(12),
                                    child: SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: AppColors.aubergine,
                                      ),
                                    ),
                                  )
                                : Icon(
                                    Icons.search,
                                    size: 20,
                                    color: isDark ? const Color(0xFFABABAD) : AppColors.midGray,
                                  ),
                            suffixIcon: _searchController.text.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.clear, size: 18),
                                    color: isDark ? const Color(0xFFABABAD) : AppColors.midGray,
                                    onPressed: () {
                                      _searchController.clear();
                                      _focusNode.requestFocus();
                                    },
                                  )
                                : null,
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                            isCollapsed: true,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Results
              Expanded(
                child: _buildResults(context, isDark),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResults(BuildContext context, bool isDark) {
    if (_searchController.text.trim().isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_rounded,
              size: 48,
              color: isDark ? const Color(0xFF454245) : AppColors.lavenderMist,
            ),
            const SizedBox(height: 12),
            Text(
              'Search conversation',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: isDark ? const Color(0xFFD1D2D3) : AppColors.carbon,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Type a word or phrase to find messages',
              style: TextStyle(
                fontSize: 13,
                color: isDark ? const Color(0xFFABABAD) : AppColors.midGray,
              ),
            ),
          ],
        ),
      );
    }

    if (_isSearching) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.aubergine),
      );
    }

    if (_searchResults.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 48,
              color: isDark ? const Color(0xFF454245) : AppColors.midGray,
            ),
            const SizedBox(height: 12),
            Text(
              'No results found',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: isDark ? const Color(0xFFD1D2D3) : AppColors.carbon,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Try searching for another keyword',
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
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final message = _searchResults[index];
        return _SearchResultTile(
          message: message,
          query: _searchController.text.trim(),
          isDark: isDark,
          onTap: () {
            Navigator.pop(context, message);
          },
        );
      },
    );
  }
}

/// Search result tile widget
class _SearchResultTile extends ConsumerWidget {
  final Message message;
  final String query;
  final bool isDark;
  final VoidCallback onTap;

  const _SearchResultTile({
    required this.message,
    required this.query,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.read(sessionManagerProvider);
    final userId = switch (session) {
      SessionAuthenticated(:final userId) => userId,
      _ => '',
    };
    final isSent = message.senderId == userId;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF222529) : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isDark ? const Color(0xFF35373B) : AppColors.fog,
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    color: isSent ? AppColors.aubergine : const Color(0xFF1264A3),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Center(
                    child: Text(
                      isSent ? 'Y' : 'P',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  isSent ? 'You' : 'Partner',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: isDark ? const Color(0xFFD1D2D3) : AppColors.carbon,
                  ),
                ),
                const Spacer(),
                Text(
                  _formatTime(message.createdAt),
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark ? const Color(0xFFABABAD) : AppColors.midGray,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            _buildHighlightedText(context, message),
          ],
        ),
      ),
    );
  }

  Widget _buildHighlightedText(BuildContext context, Message message) {
    final content = message.content ?? '';
    final lowerContent = content.toLowerCase();
    final lowerQuery = query.toLowerCase();

    if (!lowerContent.contains(lowerQuery)) {
      return Text(
        content,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 14,
          color: isDark ? const Color(0xFFD1D2D3) : AppColors.carbon,
        ),
      );
    }

    final spans = <TextSpan>[];
    int start = 0;

    while (true) {
      final index = lowerContent.indexOf(lowerQuery, start);
      if (index == -1) break;

      if (index > start) {
        spans.add(TextSpan(
          text: content.substring(start, index),
          style: TextStyle(
            fontSize: 14,
            color: isDark ? const Color(0xFFD1D2D3) : AppColors.carbon,
          ),
        ));
      }

      spans.add(TextSpan(
        text: content.substring(index, index + query.length),
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: isDark ? Colors.white : AppColors.aubergine,
          backgroundColor: isDark
              ? AppColors.aubergine.withValues(alpha: 0.5)
              : AppColors.lavenderMist,
        ),
      ));

      start = index + query.length;
    }

    if (start < content.length) {
      spans.add(TextSpan(
        text: content.substring(start),
        style: TextStyle(
          fontSize: 14,
          color: isDark ? const Color(0xFFD1D2D3) : AppColors.carbon,
        ),
      ));
    }

    return RichText(
      text: TextSpan(children: spans),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
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
