import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';

import 'widgets/compass_dial_painter.dart';
import 'widgets/vault_opening_overlay.dart';
import '../pin_pad/pin_pad_notifier.dart';
import '../../core/security/session_manager.dart';
import '../../core/router/app_router.dart';

/// Compass Decoy Screen
/// A fully functional, realistic compass interface acting as a decoy lock screen.
/// Rotating to secret headings and tapping the center silently triggers headless
/// dual-PIN authentication for User 1 or User 2.
class CompassDecoyScreen extends ConsumerStatefulWidget {
  const CompassDecoyScreen({super.key});

  @override
  ConsumerState<CompassDecoyScreen> createState() => _CompassDecoyScreenState();
}

class _CompassDecoyScreenState extends ConsumerState<CompassDecoyScreen>
    with SingleTickerProviderStateMixin {
  // Current heading in degrees (0.0 to 360.0)
  double _heading = 0.0;
  double _displayHeading = 0.0;
  double? _referenceBearing;

  // Stream & Sensor state
  StreamSubscription<CompassEvent>? _compassSubscription;
  bool _hasSensorData = false;
  bool _isManualDragging = false;
  bool _isAuthenticating = false;
  bool _isInSecretZone = false;

  // Vault opening animation state
  bool _showVaultOverlay = false;
  Future<void>? _authFuture;

  // Manual touch rotation variables
  double _panStartTouchAngle = 0.0;
  double _headingAtPanStart = 0.0;

  // Decoy settings state
  bool _useTrueNorth = true;

  // Smooth rotation animation
  late AnimationController _smoothController;
  double _animStartHeading = 0.0;
  double _animTargetHeading = 0.0;

  @override
  void initState() {
    super.initState();

    _smoothController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 180),
    )..addListener(() {
        if (!mounted) return;
        final t = Curves.easeOutCubic.transform(_smoothController.value);
        setState(() {
          _displayHeading = _normalizeHeading(_animStartHeading + (_animTargetHeading - _animStartHeading) * t);
        });
      });

    _initCompassSensor();
  }

  void _initCompassSensor() {
    try {
      _compassSubscription = FlutterCompass.events?.listen(
        (event) {
          if (!mounted) return;
          final heading = event.heading;
          if (heading != null) {
            _hasSensorData = true;
            if (!_isManualDragging) {
              _onSensorHeadingUpdated((heading % 360 + 360) % 360);
            }
          }
        },
        onError: (err) {
          debugPrint('Compass sensor error: $err');
          if (mounted) {
            setState(() {
              _hasSensorData = false;
            });
          }
        },
      );
    } catch (e) {
      debugPrint('Compass init error: $e');
      _hasSensorData = false;
    }
  }

  void _onSensorHeadingUpdated(double targetHeading) {
    _heading = targetHeading;
    _checkSecretAngleHaptic(targetHeading);

    // Shortest angular path interpolation
    final delta = _shortestAngleDelta(_displayHeading, targetHeading);
    _animStartHeading = _displayHeading;
    _animTargetHeading = _displayHeading + delta;

    _smoothController.forward(from: 0.0);
  }

  /// Subtle tactile tumbler feedback when rotating into the secret heading range
  void _checkSecretAngleHaptic(double heading) {
    final user1Heading = double.tryParse(dotenv.env['USER_1_HEADING'] ?? '') ?? 120.0;
    final user2Heading = double.tryParse(dotenv.env['USER_2_HEADING'] ?? '') ?? 260.0;
    const tolerance = 4.0;

    final inZone = _isHeadingMatching(heading, user1Heading, tolerance) ||
        _isHeadingMatching(heading, user2Heading, tolerance);

    if (inZone && !_isInSecretZone) {
      // Gentle mechanical tumbler click
      HapticFeedback.selectionClick();
    }
    _isInSecretZone = inZone;
  }

  double _shortestAngleDelta(double from, double to) {
    var diff = (to - from) % 360;
    if (diff > 180) diff -= 360;
    if (diff < -180) diff += 360;
    return diff;
  }

  double _normalizeHeading(double deg) {
    return (deg % 360 + 360) % 360;
  }

  @override
  void dispose() {
    _compassSubscription?.cancel();
    _smoothController.dispose();
    super.dispose();
  }

  /// Handle center reticle tap: Check for secret heading trigger or toggle reference bearing
  Future<void> _handleCenterTap() async {
    if (_showVaultOverlay || _isAuthenticating) return;

    final current = _normalizeHeading(_heading);

    // Read secret headings and PINs from environment
    final user1Heading = double.tryParse(dotenv.env['USER_1_HEADING'] ?? '') ?? 120.0;
    final user2Heading = double.tryParse(dotenv.env['USER_2_HEADING'] ?? '') ?? 260.0;
    const tolerance = 4.0;

    final user1Pin = dotenv.env['USER_1_PIN'] ?? '1234';
    final user2Pin = dotenv.env['USER_2_PIN'] ?? '5678';

    if (_isHeadingMatching(current, user1Heading, tolerance)) {
      // Secret Trigger: User 1 - Strong haptic confirmation & launch Vault Opening
      HapticFeedback.heavyImpact();
      _startVaultOpening(user1Pin);
    } else if (_isHeadingMatching(current, user2Heading, tolerance)) {
      // Secret Trigger: User 2 - Strong haptic confirmation & launch Vault Opening
      HapticFeedback.heavyImpact();
      _startVaultOpening(user2Pin);
    } else {
      // Innocent decoy action: Toggle reference bearing (standard Apple / Android Compass behavior)
      _toggleReferenceBearing();
    }
  }

  /// Heading comparison with tolerance buffer and circular wrap-around handling
  bool _isHeadingMatching(double current, double target, double tolerance) {
    final c = _normalizeHeading(current);
    final t = _normalizeHeading(target);
    var diff = (c - t).abs();
    if (diff > 180) {
      diff = 360 - diff;
    }
    return diff <= tolerance;
  }

  /// Launch Vault Opening loading sequence and headless authentication
  void _startVaultOpening(String pin) {
    _isAuthenticating = true;

    // Signal router that vault opening animation is in progress
    ref.read(isVaultOpeningProvider.notifier).setOpening(true);

    // Start background PIN verification immediately
    _authFuture = ref.read(pinPadNotifierProvider.notifier).submitPin(pin);

    setState(() {
      _showVaultOverlay = true;
    });
  }

  /// Invoked when Vault Opening sequence finishes and is ready to reveal chat
  void _onVaultOpeningComplete() {
    _isAuthenticating = false;
    ref.read(isVaultOpeningProvider.notifier).setOpening(false);

    if (mounted) {
      context.go('/chat');
    }
  }

  /// Realistic Decoy Feature: Lock / Unlock a reference bearing
  void _toggleReferenceBearing() {
    HapticFeedback.selectionClick();
    setState(() {
      if (_referenceBearing == null) {
        _referenceBearing = _normalizeHeading(_heading.roundToDouble());
      } else {
        _referenceBearing = null;
      }
    });
  }

  String _getCardinalDirection(double heading) {
    final normalized = _normalizeHeading(heading);
    if (normalized >= 337.5 || normalized < 22.5) return 'N';
    if (normalized < 67.5) return 'NE';
    if (normalized < 112.5) return 'E';
    if (normalized < 157.5) return 'SE';
    if (normalized < 202.5) return 'S';
    if (normalized < 247.5) return 'SW';
    if (normalized < 292.5) return 'W';
    return 'NW';
  }

  void _showSettingsModal() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: const Color(0xFF18191B),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Compass Settings',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.white70),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    const Divider(color: Color(0xFF2A2D32)),
                    const SizedBox(height: 8),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Use True North', style: TextStyle(color: Colors.white)),
                      subtitle: const Text('Requires location calibration', style: TextStyle(color: Colors.white54, fontSize: 12)),
                      value: _useTrueNorth,
                      activeTrackColor: const Color(0x66FF4500),
                      activeThumbColor: const Color(0xFFFF4500),
                      onChanged: (val) {
                        setModalState(() => _useTrueNorth = val);
                        setState(() => _useTrueNorth = val);
                      },
                    ),
                    const SizedBox(height: 8),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Sensor Status', style: TextStyle(color: Colors.white)),
                      subtitle: Text(
                        _hasSensorData ? 'Hardware Magnetometer Active' : 'Touch Fallback Active',
                        style: const TextStyle(color: Colors.white54, fontSize: 12),
                      ),
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: _hasSensorData ? const Color(0x332BAC76) : const Color(0x33FFB020),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _hasSensorData ? 'Calibrated' : 'Manual',
                          style: TextStyle(
                            color: _hasSensorData ? const Color(0xFF2BAC76) : const Color(0xFFFFB020),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text('Magnetic Declination', style: TextStyle(color: Colors.white)),
                      trailing: Text('0° 12\' E', style: TextStyle(color: Colors.white70)),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final dialSize = min(338.0, screenWidth - 48.0);
    final activeHeading = _isManualDragging ? _heading : _displayHeading;

    // Reset overlay if session gets locked
    ref.listen<SessionState>(sessionManagerProvider, (previous, next) {
      if (next is SessionLocked && mounted && _showVaultOverlay) {
        setState(() {
          _showVaultOverlay = false;
        });
      }
    });

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Top Bar with Minimalist Settings Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(width: 40),
                    // Decoy Title (Hidden/Subtle)
                    const SizedBox.shrink(),
                    IconButton(
                      icon: const Icon(
                        Icons.settings_outlined,
                        color: Colors.white70,
                        size: 24,
                      ),
                      tooltip: 'Compass Settings',
                      onPressed: _showSettingsModal,
                    ),
                  ],
                ),
              ),

              // Center Instrument Assembly
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Heading Display Readout (e.g. 15° N)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          '${activeHeading.round()}°',
                          style: const TextStyle(
                            fontSize: 52,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                            letterSpacing: -1.0,
                            fontFamily: 'Inter',
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _getCardinalDirection(activeHeading),
                          style: const TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ],
                    ),

                    // Reference Bearing Sub-Indicator (if active)
                    if (_referenceBearing != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        'Locked: ${_referenceBearing!.round()}° (${_getBearingDiffText(activeHeading, _referenceBearing!)})',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFFFF4500),
                        ),
                      ),
                    ] else
                      const SizedBox(height: 20),

                    const SizedBox(height: 16),

                    // Compass Dial Wrap Container
                    SizedBox(
                      width: dialSize,
                      height: dialSize,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Outer Bezel Body with radial depth and metallic border
                          Container(
                            width: dialSize,
                            height: dialSize,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: const RadialGradient(
                                center: Alignment.center,
                                radius: 0.9,
                                colors: [
                                  Color(0xFF202124),
                                  Color(0xFF17181A),
                                  Color(0xFF0F1011),
                                ],
                                stops: [0.0, 0.75, 1.0],
                              ),
                              border: Border.all(
                                color: const Color(0x1AFFFFFF),
                                width: 1.0,
                              ),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0xE6000000),
                                  blurRadius: 40,
                                  offset: Offset(0, 16),
                                ),
                              ],
                            ),
                            alignment: Alignment.center,
                            child: Container(
                              // Inner Recessed Disc
                              width: dialSize * 0.90,
                              height: dialSize * 0.90,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: const RadialGradient(
                                  center: Alignment.center,
                                  radius: 0.9,
                                  colors: [
                                    Color(0xFF1E1F23),
                                    Color(0xFF161719),
                                    Color(0xFF131416),
                                  ],
                                  stops: [0.0, 0.65, 1.0],
                                ),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color(0xB3000000),
                                    blurRadius: 12,
                                    spreadRadius: -2,
                                  ),
                                ],
                              ),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  // Rotating Dial Face (Counter-clockwise rotation by heading)
                                  Transform.rotate(
                                    angle: -activeHeading * (pi / 180),
                                    child: CustomPaint(
                                      size: Size(dialSize * 0.90, dialSize * 0.90),
                                      painter: CompassDialPainter(
                                        currentHeading: activeHeading,
                                        referenceBearing: _referenceBearing,
                                      ),
                                    ),
                                  ),

                                  // Center Fixed Crosshair & Reticle
                                  CustomPaint(
                                    size: Size(dialSize * 0.90, dialSize * 0.90),
                                    painter: FixedReticlePainter(),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // Outer Heading Indicator Notch (Top Orange Pointer at 12 o'clock)
                          Positioned(
                            top: -1.0,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 36,
                                  height: 3.5,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFF4500),
                                    borderRadius: BorderRadius.circular(2),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Color(0x99FF4500),
                                        blurRadius: 8,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 1),
                                CustomPaint(
                                  size: const Size(12, 7),
                                  painter: _TrianglePointerPainter(),
                                ),
                              ],
                            ),
                          ),

                          // Interactive Gesture Layer (Touch Rotation Fallback + Secret Center Tap)
                          GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTapUp: (details) {
                              final center = Offset(dialSize / 2, dialSize / 2);
                              final distance = (details.localPosition - center).distance;
                              if (distance <= 48.0) {
                                _handleCenterTap();
                              }
                            },
                            onPanStart: (details) {
                              final center = Offset(dialSize / 2, dialSize / 2);
                              final diff = details.localPosition - center;
                              if (diff.distance > 48.0) {
                                _isManualDragging = true;
                                _panStartTouchAngle = atan2(diff.dy, diff.dx);
                                _headingAtPanStart = _heading;
                              }
                            },
                            onPanUpdate: (details) {
                              if (_isManualDragging) {
                                final center = Offset(dialSize / 2, dialSize / 2);
                                final diff = details.localPosition - center;
                                final currentAngle = atan2(diff.dy, diff.dx);
                                final deltaAngleDeg = (currentAngle - _panStartTouchAngle) * 180 / pi;
                                final newHeading = _normalizeHeading(_headingAtPanStart - deltaAngleDeg);

                                _checkSecretAngleHaptic(newHeading);

                                setState(() {
                                  _heading = newHeading;
                                  _displayHeading = newHeading;
                                });
                              }
                            },
                            onPanEnd: (_) {
                              _isManualDragging = false;
                            },
                            onPanCancel: () {
                              _isManualDragging = false;
                            },
                            child: const SizedBox.expand(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Minimal Bottom Spacing & Home Indicator Bar
              Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: Container(
                  width: 140,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0x40FFFFFF),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Fullscreen Vault Opening Loading Animation & Transition Screen
        if (_showVaultOverlay)
          Positioned.fill(
            child: VaultOpeningOverlay(
              authFuture: _authFuture ?? Future.value(),
              onTransitionReady: _onVaultOpeningComplete,
            ),
          ),
      ],
    ),
  ),
);
  }

  String _getBearingDiffText(double heading, double ref) {
    var diff = (heading - ref).round();
    if (diff > 180) diff -= 360;
    if (diff < -180) diff += 360;
    if (diff == 0) return 'Aligned';
    return diff > 0 ? '+$diff°' : '$diff°';
  }
}

/// Downward pointing orange triangle notch painter
class _TrianglePointerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width / 2, size.height)
      ..close();

    final paint = Paint()
      ..color = const Color(0xFFFF4500)
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _TrianglePointerPainter oldDelegate) => false;
}
