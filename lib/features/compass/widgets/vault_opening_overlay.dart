import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/app_colors.dart';

/// Vault Opening Loading Screen & Animation
/// Displays a high-tech mechanical vault opening sequence with smooth rotation,
/// tumbler unlocking, status text progression, and seamless transition to the chat screen.
class VaultOpeningOverlay extends StatefulWidget {
  final Future<void> authFuture;
  final VoidCallback onTransitionReady;

  const VaultOpeningOverlay({
    super.key,
    required this.authFuture,
    required this.onTransitionReady,
  });

  @override
  State<VaultOpeningOverlay> createState() => _VaultOpeningOverlayState();
}

class _VaultOpeningOverlayState extends State<VaultOpeningOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _wheelRotation;
  late Animation<double> _outerRingRotation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _fadeAnimation;

  String _statusText = 'Aligning security tumblers...';
  bool _isUnlocked = false;
  bool _transitionTriggered = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    // Initial strong haptic feedback confirming press registered
    HapticFeedback.heavyImpact();

    // Wheel rotates 90 degrees with mechanical easing
    _wheelRotation = Tween<double>(begin: 0.0, end: pi / 2).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.15, 0.70, curve: Curves.easeInOutCubic),
      ),
    );

    // Outer notched ring counter-rotates slightly
    _outerRingRotation = Tween<double>(begin: 0.0, end: -pi / 4).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.85, curve: Curves.easeOutQuad),
      ),
    );

    // Subtle scale pulse
    _pulseAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.92, end: 1.0)
            .chain(CurveTween(curve: Curves.easeOutBack)),
        weight: 40,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.0),
        weight: 40,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.08)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 20,
      ),
    ]).animate(_controller);

    // Overlay entrance fade
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.25, curve: Curves.easeIn),
    );

    _controller.addListener(() {
      final value = _controller.value;

      // Stage 1: Aligning (0.0 - 0.45)
      if (value < 0.45 && _statusText != 'Aligning security tumblers...') {
        setState(() {
          _statusText = 'Aligning security tumblers...';
        });
      }
      // Stage 2: Decrypting (0.45 - 0.75)
      else if (value >= 0.45 && value < 0.75 && _statusText != 'Opening private vault...') {
        HapticFeedback.mediumImpact();
        setState(() {
          _statusText = 'Opening private vault...';
          _isUnlocked = true;
        });
      }
      // Stage 3: Access Granted (0.75 - 1.0)
      else if (value >= 0.75 && _statusText != 'Access Granted') {
        HapticFeedback.selectionClick();
        setState(() {
          _statusText = 'Access Granted';
        });
      }
    });

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _finishAndTransition();
      }
    });

    // Start opening animation
    _controller.forward();
  }

  Future<void> _finishAndTransition() async {
    if (_transitionTriggered) return;
    _transitionTriggered = true;

    // Await auth verification if still pending
    try {
      await widget.authFuture;
    } catch (_) {}

    // Final subtle confirmation haptic and callback
    HapticFeedback.lightImpact();
    widget.onTransitionReady();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        color: AppColors.obsidianCharcoal,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Ambient Radial Glow
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.center,
                    radius: 0.85,
                    colors: [
                      _isUnlocked
                          ? AppColors.mulberryWine.withValues(alpha: 0.35) // Velvet wine glow
                          : AppColors.roseMauve.withValues(alpha: 0.25),   // Rose Mauve glow
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),

            // Center Vault Assembly
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform.scale(
                  scale: _pulseAnimation.value,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Mechanical Vault Door Graphic
                      SizedBox(
                        width: 220,
                        height: 220,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Outer Notched Ring (rotating counter-clockwise)
                            Transform.rotate(
                              angle: _outerRingRotation.value,
                              child: CustomPaint(
                                size: const Size(220, 220),
                                painter: _VaultOuterRingPainter(),
                              ),
                            ),

                            // Middle Steel Bezel
                            Container(
                              width: 176,
                              height: 176,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: const RadialGradient(
                                  colors: [
                                    Color(0xFF282A2E),
                                    Color(0xFF1E2024),
                                    Color(0xFF141518),
                                  ],
                                  stops: [0.0, 0.7, 1.0],
                                ),
                                border: Border.all(
                                  color: _isUnlocked
                                      ? AppColors.roseMauve
                                      : const Color(0x33FFFFFF),
                                  width: 1.5,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.8),
                                    blurRadius: 20,
                                    offset: const Offset(0, 10),
                                  ),
                                  if (_isUnlocked)
                                    BoxShadow(
                                      color: AppColors.roseMauve.withValues(alpha: 0.35),
                                      blurRadius: 25,
                                      spreadRadius: 2,
                                    ),
                                ],
                              ),
                            ),

                            // Inner Rotating Safe Handle Wheel (90 degrees rotation)
                            Transform.rotate(
                              angle: _wheelRotation.value,
                              child: CustomPaint(
                                size: const Size(140, 140),
                                painter: _VaultHandleWheelPainter(
                                  isUnlocked: _isUnlocked,
                                ),
                              ),
                            ),

                            // Center Lock Icon
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 250),
                              transitionBuilder: (child, anim) =>
                                  ScaleTransition(scale: anim, child: child),
                              child: Icon(
                                _isUnlocked
                                    ? Icons.lock_open_rounded
                                    : Icons.lock_rounded,
                                key: ValueKey(_isUnlocked),
                                size: 34,
                                color: _isUnlocked
                                    ? AppColors.roseMauve
                                    : Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 38),

                      // "VAULT OPENING" Title
                      const Text(
                        'VAULT OPENING',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 3.5,
                          color: Colors.white,
                          fontFamily: 'Inter',
                        ),
                      ),

                      const SizedBox(height: 10),

                      // Dynamic Status Text
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        child: Text(
                          _statusText,
                          key: ValueKey(_statusText),
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0.5,
                            color: _isUnlocked
                                ? AppColors.roseMauve
                                : Colors.white60,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Sleek Glowing Progress Bar
                      SizedBox(
                        width: 170,
                        height: 3,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(1.5),
                          child: Stack(
                            children: [
                              Container(
                                color: const Color(0x26FFFFFF),
                              ),
                              FractionallySizedBox(
                                widthFactor: _controller.value.clamp(0.0, 1.0),
                                child: Container(
                                  decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        AppColors.mulberryWine,
                                        AppColors.roseMauve,
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// Custom painter for the outer notched mechanical ring
class _VaultOuterRingPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final radius = size.width / 2 - 4;

    final ringPaint = Paint()
      ..color = const Color(0x33FFFFFF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    canvas.drawCircle(Offset(cx, cy), radius, ringPaint);

    // Draw mechanical teeth / notches around perimeter
    final notchPaint = Paint()
      ..color = const Color(0x55FFFFFF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    const notchCount = 24;
    for (int i = 0; i < notchCount; i++) {
      final angle = (i * 360 / notchCount) * (pi / 180);
      final x1 = cx + (radius - 5) * cos(angle);
      final y1 = cy + (radius - 5) * sin(angle);
      final x2 = cx + radius * cos(angle);
      final y2 = cy + radius * sin(angle);
      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), notchPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Custom painter for the 4-spoke safe handle wheel
class _VaultHandleWheelPainter extends CustomPainter {
  final bool isUnlocked;

  _VaultHandleWheelPainter({required this.isUnlocked});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final spokeRadius = size.width / 2 - 8;

    final spokePaint = Paint()
      ..color = isUnlocked ? AppColors.roseMauve : const Color(0x8CFFFFFF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round;

    final gripPaint = Paint()
      ..color = isUnlocked ? AppColors.roseMauve : Colors.white
      ..style = PaintingStyle.fill;

    // 4 Spoke bars (cross arrangement)
    for (int i = 0; i < 4; i++) {
      final angle = (i * 90) * (pi / 180);
      final x1 = cx + 22 * cos(angle);
      final y1 = cy + 22 * sin(angle);
      final x2 = cx + spokeRadius * cos(angle);
      final y2 = cy + spokeRadius * sin(angle);

      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), spokePaint);
      canvas.drawCircle(Offset(x2, y2), 5.5, gripPaint);
    }

    // Center circular hub rim
    final hubPaint = Paint()
      ..color = const Color(0x40FFFFFF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawCircle(Offset(cx, cy), 28, hubPaint);
  }

  @override
  bool shouldRepaint(covariant _VaultHandleWheelPainter oldDelegate) {
    return oldDelegate.isUnlocked != isUnlocked;
  }
}
