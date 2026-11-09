import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show HapticFeedback;
import '../../../core/theme/app_colors.dart';

/// WhatsApp-style swipe-to-reply gesture wrapper
class SwipeToReply extends StatefulWidget {
  final Widget child;
  final VoidCallback? onReply;
  final bool enabled;

  const SwipeToReply({
    super.key,
    required this.child,
    this.onReply,
    this.enabled = true,
  });

  @override
  State<SwipeToReply> createState() => _SwipeToReplyState();
}

class _SwipeToReplyState extends State<SwipeToReply>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late Animation<double> _animation;

  double _dragOffset = 0.0;
  bool _hasTriggeredHaptic = false;
  static const double _threshold = 48.0;
  static const double _maxOffset = 76.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
    )..addListener(() {
        setState(() {
          _dragOffset = _animation.value;
        });
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    if (!widget.enabled || widget.onReply == null) return;

    // Only allow swiping to the right
    final newOffset = (_dragOffset + details.delta.dx * 0.6).clamp(0.0, _maxOffset);

    if (newOffset >= _threshold && !_hasTriggeredHaptic) {
      HapticFeedback.lightImpact();
      _hasTriggeredHaptic = true;
    } else if (newOffset < _threshold && _hasTriggeredHaptic) {
      _hasTriggeredHaptic = false;
    }

    setState(() {
      _dragOffset = newOffset;
    });
  }

  void _handleDragEnd(DragEndDetails details) {
    if (!widget.enabled || widget.onReply == null) return;

    if (_dragOffset >= _threshold) {
      widget.onReply?.call();
    }

    _animateBack();
  }

  void _handleDragCancel() {
    _animateBack();
  }

  void _animateBack() {
    _hasTriggeredHaptic = false;
    _animation = Tween<double>(begin: _dragOffset, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
    _controller.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final progress = (_dragOffset / _threshold).clamp(0.0, 1.0);
    final iconScale = Curves.easeOutBack.transform(progress);
    final iconOpacity = progress.clamp(0.0, 1.0);
    final iconRotation = (1.0 - progress) * (-0.35);

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onHorizontalDragUpdate: _handleDragUpdate,
      onHorizontalDragEnd: _handleDragEnd,
      onHorizontalDragCancel: _handleDragCancel,
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          // Animated reply icon behind the message bubble
          if (_dragOffset > 0)
            Positioned(
              left: 12 + (_dragOffset * 0.25),
              child: Opacity(
                opacity: iconOpacity,
                child: Transform.rotate(
                  angle: iconRotation,
                  child: Transform.scale(
                    scale: iconScale,
                    child: Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: _dragOffset >= _threshold
                            ? AppColors.aubergine
                            : (isDark ? const Color(0xFF2E3136) : const Color(0xFFE8E5EC)),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.12),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.reply_rounded,
                        size: 20,
                        color: _dragOffset >= _threshold
                            ? Colors.white
                            : (isDark ? Colors.white70 : AppColors.carbon),
                      ),
                    ),
                  ),
                ),
              ),
            ),

          // Message bubble translated horizontally
          Transform.translate(
            offset: Offset(_dragOffset, 0),
            child: widget.child,
          ),
        ],
      ),
    );
  }
}
