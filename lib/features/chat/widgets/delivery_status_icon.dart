import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/theme/app_colors.dart';

/// Delivery Status Icon - Shows message delivery status using custom SVGs:
/// - pending: schedule clock icon
/// - sent: assets/icons/sent.svg (single checkmark)
/// - delivered: assets/icons/recieved.svg (double checkmark)
/// - read: assets/icons/read.svg (blue double checkmark)
class DeliveryStatusIcon extends StatelessWidget {
  final String status;
  final double size;
  final Color? color;

  const DeliveryStatusIcon({
    super.key,
    required this.status,
    this.size = 15,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final defaultTickColor = isDark ? AppColors.mutedMauve : AppColors.mutedMauve;

    switch (status) {
      case 'pending':
        return Icon(
          Icons.schedule_rounded,
          size: size,
          color: color ?? AppColors.statusPending,
        );
      case 'sent':
        return SvgPicture.asset(
          'assets/icons/sent.svg',
          width: size,
          height: size,
          colorFilter: ColorFilter.mode(
            color ?? defaultTickColor,
            BlendMode.srcIn,
          ),
        );
      case 'delivered':
        return SvgPicture.asset(
          'assets/icons/recieved.svg',
          width: size,
          height: size,
          colorFilter: ColorFilter.mode(
            color ?? defaultTickColor,
            BlendMode.srcIn,
          ),
        );
      case 'read':
        return SvgPicture.asset(
          'assets/icons/read.svg',
          width: size,
          height: size,
          colorFilter: ColorFilter.mode(
            color ?? AppColors.roseMauve,
            BlendMode.srcIn,
          ),
        );
      default:
        return SvgPicture.asset(
          'assets/icons/sent.svg',
          width: size,
          height: size,
          colorFilter: ColorFilter.mode(
            color ?? defaultTickColor,
            BlendMode.srcIn,
          ),
        );
    }
  }
}

/// Animated Delivery Status Icon with transitions
class AnimatedDeliveryStatusIcon extends StatefulWidget {
  final String status;
  final double size;
  final Color? color;

  const AnimatedDeliveryStatusIcon({
    super.key,
    required this.status,
    this.size = 15,
    this.color,
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
              color: widget.color,
            ),
          ),
        );
      },
    );
  }
}
