import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/security/session_manager.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/local/daos/messages_dao.dart';
import '../../../domain/models/message.dart';
import '../../../providers/repository_providers.dart';

/// View Once Viewer - Full-screen secure viewer for view-once media
class ViewOnceViewerScreen extends ConsumerStatefulWidget {
  final String messageId;

  const ViewOnceViewerScreen({super.key, required this.messageId});

  @override
  ConsumerState<ViewOnceViewerScreen> createState() => _ViewOnceViewerScreenState();
}

class _ViewOnceViewerScreenState extends ConsumerState<ViewOnceViewerScreen> {
  TransformationController? _transformationController;
  Message? _message;
  bool _isLoading = true;
  bool _hasMarkedViewed = false;

  @override
  void initState() {
    super.initState();
    _transformationController = TransformationController();
    _loadMessage();
  }

  @override
  void dispose() {
    _markAsViewed();
    _transformationController?.dispose();
    super.dispose();
  }

  Future<void> _loadMessage() async {
    try {
      final db = ref.read(databaseProvider);
      final raw = await db.messagesDao.getMessageById(widget.messageId);
      if (mounted) {
        setState(() {
          _message = raw?.toDomain();
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _markAsViewed() async {
    if (_hasMarkedViewed) return;
    _hasMarkedViewed = true;

    try {
      final session = ref.read(sessionManagerProvider);
      final userId = switch (session) {
        SessionAuthenticated(:final userId) => userId,
        _ => null,
      };
      if (userId != null) {
        await ref.read(chatRepositoryProvider).markViewOnceViewed(widget.messageId, userId);
      }
    } catch (e) {
      debugPrint('Mark view-once viewed note: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) {
          _markAsViewed();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            // Media viewer or loading/error
            Center(
              child: _buildMediaContent(),
            ),

            // Top banner
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: SafeArea(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1D1C1D).withValues(alpha: 0.85),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white12),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppColors.aubergine.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.lock_clock_outlined,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'View Once — will disappear after closing',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Close button
            Positioned(
              top: 0,
              right: 8,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(top: 8, right: 8),
                  child: IconButton(
                    onPressed: () {
                      _markAsViewed();
                      Navigator.pop(context);
                    },
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.6),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white24),
                      ),
                      child: const Icon(
                        Icons.close_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMediaContent() {
    if (_isLoading) {
      return const CircularProgressIndicator(
        color: AppColors.aubergine,
      );
    }

    final mediaUrl = _message?.mediaUrl;
    if (mediaUrl == null || mediaUrl.isEmpty) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF222529),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.timer_off_outlined,
              color: AppColors.midGray,
              size: 48,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'This view-once photo has expired',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      );
    }

    // Local file
    final file = File(mediaUrl);
    if (file.existsSync()) {
      return InteractiveViewer(
        transformationController: _transformationController,
        minScale: 1.0,
        maxScale: 4.0,
        child: Image.file(
          file,
          fit: BoxFit.contain,
        ),
      );
    }

    // Network image
    if (mediaUrl.startsWith('http')) {
      return InteractiveViewer(
        transformationController: _transformationController,
        minScale: 1.0,
        maxScale: 4.0,
        child: Image.network(
          mediaUrl,
          fit: BoxFit.contain,
          loadingBuilder: (context, child, progress) {
            if (progress == null) return child;
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.aubergine,
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) => _buildFallbackMessage('Failed to load image'),
        ),
      );
    }

    return _buildFallbackMessage('Media unavailable');
  }

  Widget _buildFallbackMessage(String message) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.broken_image_outlined, color: Colors.white54, size: 48),
        const SizedBox(height: 12),
        Text(
          message,
          style: const TextStyle(color: Colors.white70, fontSize: 14),
        ),
      ],
    );
  }
}
