import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// Animated Typing Indicator matching reference GIF:
/// 1. Asymmetrical electric blue chat bubble with sharp bottom-left corner.
/// 2. Bouncy pop-in entrance (Curves.easeOutBack from Alignment.bottomLeft) and spring exit.
/// 3. Three white dots executing a staggered multi-phase wave motion:
///    - Staggered jump UP into a high plateau
///    - Hold at plateau
///    - Staggered drop DOWN with slight overshoot before returning to baseline
///    - Rest at baseline before looping
/// 4. Subtitle below the bubble in italic styling.
class TypingIndicator extends StatefulWidget {
  final bool isVisible;
  final String partnerName;
  final bool isRecording;
  final bool isDark;

  const TypingIndicator({
    super.key,
    required this.isVisible,
    required this.partnerName,
    this.isRecording = false,
    this.isDark = true,
  });

  @override
  State<TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator>
    with TickerProviderStateMixin {
  late final AnimationController _entryController;
  late final AnimationController _dotsController;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _sizeAnimation;

  @override
  void initState() {
    super.initState();

    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );

    _dotsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: Curves.easeOutBack,
        reverseCurve: Curves.easeInBack,
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: Curves.easeOut,
        reverseCurve: Curves.easeIn,
      ),
    );

    _sizeAnimation = CurvedAnimation(
      parent: _entryController,
      curve: Curves.easeInOutCubic,
    );

    if (widget.isVisible) {
      _entryController.value = 1.0;
      _dotsController.repeat();
    }
  }

  @override
  void didUpdateWidget(TypingIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isVisible != oldWidget.isVisible) {
      if (widget.isVisible) {
        _dotsController.repeat();
        _entryController.forward();
      } else {
        _entryController.reverse().then((_) {
          if (!mounted) return;
          if (!widget.isVisible) {
            _dotsController.stop();
          }
        });
      }
    }
  }

  @override
  void dispose() {
    _entryController.dispose();
    _dotsController.dispose();
    super.dispose();
  }

  /// Exact piece-wise motion curve extracted from reference GIF:
  /// - t: normalized timeline [0.0 .. 1.0] over 2400ms
  /// - dotIndex: 0, 1, or 2
  double _getDotOffset(double t, int dotIndex) {
    final delay = dotIndex * 0.045; // ~108ms delay between dots

    final w1Start = 0.08 + delay;
    final w1Peak = w1Start + 0.07;
    final w1End = w1Start + 0.16;

    final w2Start = 0.54 + delay;
    final w2Dip = w2Start + 0.08;
    final w2End = w2Start + 0.18;

    const double plateauY = -6.5;
    const double peakY = -11.0;
    const double dipY = 3.0;

    if (t < w1Start) {
      return 0.0;
    } else if (t < w1Peak) {
      final p = (t - w1Start) / (w1Peak - w1Start);
      return math.sin(p * math.pi / 2) * peakY;
    } else if (t < w1End) {
      final p = (t - w1Peak) / (w1End - w1Peak);
      return peakY + math.sin(p * math.pi / 2) * (plateauY - peakY);
    } else if (t < w2Start) {
      return plateauY;
    } else if (t < w2Dip) {
      final p = (t - w2Start) / (w2Dip - w2Start);
      final ease = (1 - math.cos(p * math.pi)) / 2;
      return plateauY + ease * (dipY - plateauY);
    } else if (t < w2End) {
      final p = (t - w2Dip) / (w2End - w2Dip);
      return dipY + math.sin(p * math.pi / 2) * (0.0 - dipY);
    } else {
      return 0.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: _sizeAnimation,
      alignment: Alignment.topLeft,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Padding(
          padding: const EdgeInsets.only(left: 12, top: 4, bottom: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Bubble with bouncy anchor scale
              ScaleTransition(
                scale: _scaleAnimation,
                alignment: Alignment.bottomLeft,
                child: Container(
                  width: 58,
                  height: 42,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceDark,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(18),
                      topRight: Radius.circular(18),
                      bottomRight: Radius.circular(18),
                      bottomLeft: Radius.circular(4),
                    ),
                    border: Border.all(
                      color: AppColors.roseMauve.withValues(alpha: 0.55),
                      width: 1.2,
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: AppColors.roseMauveGlow,
                        blurRadius: 8,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: AnimatedBuilder(
                    animation: _dotsController,
                    builder: (context, child) {
                      final t = _dotsController.value;
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(3, (index) {
                          final dy = _getDotOffset(t, index);
                          return Container(
                            margin: EdgeInsets.only(
                              left: index == 0 ? 0 : 2.5,
                              right: index == 2 ? 0 : 2.5,
                            ),
                            child: Transform.translate(
                              offset: Offset(0, dy),
                              child: Container(
                                width: 6.5,
                                height: 6.5,
                                decoration: const BoxDecoration(
                                  color: AppColors.roseMauve,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          );
                        }),
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(height: 5),

              // Subtitle: "<Name> is typing..." in italic styling
              Padding(
                padding: const EdgeInsets.only(left: 4),
                child: Text(
                  widget.isRecording
                      ? '${widget.partnerName} is recording audio...'
                      : '${widget.partnerName} is typing...',
                  style: TextStyle(
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                    color: widget.isDark
                        ? AppColors.mutedMauve
                        : AppColors.charcoal,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
