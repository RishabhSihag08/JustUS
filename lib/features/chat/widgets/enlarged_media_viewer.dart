import 'dart:io';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/theme/app_colors.dart';
import '../../../services/gallery_saver_service.dart';

/// Fullscreen interactive media viewer with pinch-to-zoom, pan, save to gallery, and share
class EnlargedMediaViewer extends StatefulWidget {
  final String mediaUrl;
  final String? caption;
  final String? senderName;
  final DateTime? timestamp;
  final String? heroTag;

  const EnlargedMediaViewer({
    super.key,
    required this.mediaUrl,
    this.caption,
    this.senderName,
    this.timestamp,
    this.heroTag,
  });

  /// Helper to open the viewer with smooth fade/scale transition
  static void open(
    BuildContext context, {
    required String mediaUrl,
    String? caption,
    String? senderName,
    DateTime? timestamp,
    String? heroTag,
  }) {
    Navigator.of(context).push(
      PageRouteBuilder<void>(
        opaque: false,
        barrierDismissible: true,
        pageBuilder: (context, animation, secondaryAnimation) {
          return EnlargedMediaViewer(
            mediaUrl: mediaUrl,
            caption: caption,
            senderName: senderName,
            timestamp: timestamp,
            heroTag: heroTag,
          );
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  @override
  State<EnlargedMediaViewer> createState() => _EnlargedMediaViewerState();
}

class _EnlargedMediaViewerState extends State<EnlargedMediaViewer> {
  final TransformationController _transformController = TransformationController();
  TapDownDetails? _doubleTapDetails;
  bool _isSaving = false;
  bool _showControls = true;

  @override
  void dispose() {
    _transformController.dispose();
    super.dispose();
  }

  void _handleDoubleTap() {
    if (_transformController.value != Matrix4.identity()) {
      _transformController.value = Matrix4.identity();
    } else {
      final position = _doubleTapDetails?.localPosition ?? Offset.zero;
      _transformController.value = Matrix4.diagonal3Values(2.5, 2.5, 1.0)
        ..setTranslationRaw(-position.dx * 1.5, -position.dy * 1.5, 0.0);
    }
  }

  Future<void> _saveMedia() async {
    if (_isSaving) return;
    setState(() => _isSaving = true);

    final success = await GallerySaverService.saveToGallery(widget.mediaUrl);
    if (!mounted) return;
    setState(() => _isSaving = false);

    ScaffoldMessenger.of(context).showSnackBar(
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

  Future<void> _shareMedia() async {
    try {
      if (File(widget.mediaUrl).existsSync()) {
        await Share.shareXFiles([XFile(widget.mediaUrl)], text: widget.caption);
      } else {
        await Share.share(widget.mediaUrl, subject: widget.caption);
      }
    } catch (e) {
      debugPrint('Share error: $e');
    }
  }

  Widget _buildMediaContent() {
    final isLocal = File(widget.mediaUrl).existsSync();

    Widget imageWidget;
    if (isLocal) {
      imageWidget = Image.file(
        File(widget.mediaUrl),
        fit: BoxFit.contain,
      );
    } else {
      imageWidget = Image.network(
        widget.mediaUrl,
        fit: BoxFit.contain,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          final total = loadingProgress.expectedTotalBytes;
          final current = loadingProgress.cumulativeBytesLoaded;
          return Center(
            child: CircularProgressIndicator(
              value: total != null ? current / total : null,
              color: AppColors.roseMauve,
              strokeWidth: 2.5,
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) => const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.broken_image_rounded, color: AppColors.mutedMauve, size: 56),
              SizedBox(height: 8),
              Text(
                'Failed to load media',
                style: TextStyle(color: AppColors.mutedMauve, fontSize: 14),
              ),
            ],
          ),
        ),
      );
    }

    if (widget.heroTag != null) {
      return Hero(
        tag: widget.heroTag!,
        child: imageWidget,
      );
    }

    return imageWidget;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Pinch-to-zoom interactive viewer
          GestureDetector(
            onTap: () => setState(() => _showControls = !_showControls),
            onDoubleTapDown: (details) => _doubleTapDetails = details,
            onDoubleTap: _handleDoubleTap,
            child: InteractiveViewer(
              transformationController: _transformController,
              minScale: 0.8,
              maxScale: 4.5,
              child: Center(
                child: _buildMediaContent(),
              ),
            ),
          ),

          // Top Action Header Bar
          AnimatedPositioned(
            duration: const Duration(milliseconds: 200),
            top: _showControls ? 0 : -100,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 8,
                bottom: 12,
                left: 12,
                right: 12,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.85),
                    Colors.transparent,
                  ],
                ),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 24),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          widget.senderName ?? 'Photo',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (widget.timestamp != null)
                          Text(
                            _formatDate(widget.timestamp!),
                            style: const TextStyle(
                              color: AppColors.mutedMauve,
                              fontSize: 12,
                            ),
                          ),
                      ],
                    ),
                  ),
                  // Share Button
                  IconButton(
                    icon: const Icon(Icons.share_rounded, color: Colors.white, size: 22),
                    tooltip: 'Share',
                    onPressed: _shareMedia,
                  ),
                  // Save to Gallery Button
                  IconButton(
                    icon: _isSaving
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.roseMauve,
                            ),
                          )
                        : const Icon(Icons.download_rounded, color: Colors.white, size: 24),
                    tooltip: 'Save to Gallery',
                    onPressed: _saveMedia,
                  ),
                ],
              ),
            ),
          ),

          // Bottom Caption Bar (if caption exists)
          if (widget.caption != null && widget.caption!.trim().isNotEmpty)
            AnimatedPositioned(
              duration: const Duration(milliseconds: 200),
              bottom: _showControls ? 0 : -100,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 16,
                  bottom: MediaQuery.of(context).padding.bottom + 16,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.85),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: Text(
                  widget.caption!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _formatDate(DateTime dt) {
    final local = dt.toLocal();
    final hour = local.hour % 12 == 0 ? 12 : local.hour % 12;
    final minute = local.minute.toString().padLeft(2, '0');
    final ampm = local.hour >= 12 ? 'PM' : 'AM';
    return '${local.day}/${local.month}/${local.year} at $hour:$minute $ampm';
  }
}
