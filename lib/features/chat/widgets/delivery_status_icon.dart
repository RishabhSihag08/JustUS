import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// Delivery Status Icon - Shows message delivery status
/// pending (clock), sent (single tick), delivered (double gray), read (double blue)
class DeliveryStatusIcon extends StatelessWidget {
  final String status;
  final double size;

  const DeliveryStatusIcon({
    super.key,
    required this.status,
    this.size = 16,
  });

  @override
  Widget build(BuildContext context) {
    Color iconColor;
    IconData iconData;

    switch (status) {
      case 'pending':
        iconColor = AppColors.statusPending;
        iconData = Icons.schedule_rounded;
        break;
      case 'sent':
        iconColor = AppColors.statusSent;
        iconData = Icons.check_rounded;
        break;
      case 'delivered':
        iconColor = AppColors.statusDelivered;
        iconData = Icons.done_all_rounded;
        break;
      case 'read':
        iconColor = AppColors.statusRead;
        iconData = Icons.done_all_rounded;
        break;
      default:
        iconColor = AppColors.statusSent;
        iconData = Icons.check_rounded;
    }

    return status == 'delivered' || status == 'read'
        ? _buildDoubleTick(iconColor, size)
        : Icon(
            iconData,
            size: size,
            color: iconColor,
          );
  }

  Widget _buildDoubleTick(Color color, double size) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.check_rounded,
          size: size,
          color: color,
        ),
        SizedBox(width: size * 0.15),
        Icon(
          Icons.check_rounded,
          size: size,
          color: color,
        ),
      ],
    );
  }
}

/// Animated Delivery Status Icon with transitions
class AnimatedDeliveryStatusIcon extends StatefulWidget {
  final String status;
  final double size;

  const AnimatedDeliveryStatusIcon({
    super.key,
    required this.status,
    this.size = 16,
  });

  @override
  State<AnimatedDeliveryStatusIcon> createState() => _AnimatedDeliveryStatusIconState();
}

class _AnimatedDeliveryStatusIconState extends State<AnimatedDeliveryStatusIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 1.3).chain(CurveTween(curve: Curves.easeOutBack)),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.3, end: 1.0).chain(CurveTween(curve: Curves.elasticOut)),
        weight: 2,
      ),
    ]).animate(_controller);

    _rotationAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 0.0, end: 0.1).chain(CurveTween(curve: Curves.easeOut)),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 0.1, end: -0.1).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 2,
      ),
      TweenSequenceItem(
        tween: Tween(begin: -0.1, end: 0.0).chain(CurveTween(curve: Curves.easeIn)),
        weight: 1,
      ),
    ]).animate(_controller);

    _controller.forward();
  }

  @override
  void didUpdateWidget(covariant AnimatedDeliveryStatusIcon oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.status != widget.status) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Transform.rotate(
            angle: _rotationAnimation.value,
            child: DeliveryStatusIcon(
              status: widget.status,
              size: widget.size,
            ),
          ),
        );
      },
    );
  }
}