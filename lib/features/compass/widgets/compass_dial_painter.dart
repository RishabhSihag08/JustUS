import 'dart:math';
import 'package:flutter/material.dart';

/// Custom Painter for the Rotating Compass Dial Face
/// Replicates the high-precision vector dial from references/compass screen reference/code.html
class CompassDialPainter extends CustomPainter {
  final double? referenceBearing;
  final double currentHeading;

  CompassDialPainter({
    this.referenceBearing,
    required this.currentHeading,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final scale = size.width / 300.0;
    final radiusOuter = 142.0 * scale;

    // 1. Reference Bearing Arc (Decoy feature when bearing is locked)
    if (referenceBearing != null) {
      _drawReferenceBearingArc(canvas, cx, cy, radiusOuter, scale);
    }

    // 2. 360 Degree Ticks (Every 2 degrees)
    final tickPaint = Paint()
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;

    for (int deg = 0; deg < 360; deg += 2) {
      final rad = (deg - 90) * (pi / 180);
      double tickLength = 4.0 * scale;
      Color strokeColor = const Color(0x40FFFFFF); // 25% white
      double strokeWidth = 1.0 * scale;

      if (deg % 30 == 0) {
        tickLength = 11.0 * scale;
        strokeColor = const Color(0xD9FFFFFF); // 85% white
        strokeWidth = 1.75 * scale;
      } else if (deg % 10 == 0) {
        tickLength = 8.0 * scale;
        strokeColor = const Color(0x8CFFFFFF); // 55% white
        strokeWidth = 1.25 * scale;
      } else if (deg % 5 == 0) {
        tickLength = 6.0 * scale;
        strokeColor = const Color(0x66FFFFFF); // 40% white
        strokeWidth = 1.0 * scale;
      }

      // Highlight North zone (348° to 12°) in orange
      if (deg >= 348 || deg <= 12) {
        if (deg == 0) {
          strokeColor = const Color(0xFFFF4500); // Full accent orange
        } else {
          strokeColor = const Color(0xB3FF4500); // 70% accent orange
        }
      }

      final x1 = cx + (radiusOuter - tickLength) * cos(rad);
      final y1 = cy + (radiusOuter - tickLength) * sin(rad);
      final x2 = cx + radiusOuter * cos(rad);
      final y2 = cy + radiusOuter * sin(rad);

      tickPaint
        ..color = strokeColor
        ..strokeWidth = strokeWidth;

      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), tickPaint);
    }

    // 3. Degree Numerals at every 30 degrees (0, 30, 60, ... 330)
    const degreeLabels = [0, 30, 60, 90, 120, 150, 180, 210, 240, 270, 300, 330];
    final labelRadius = 120.0 * scale;

    for (final deg in degreeLabels) {
      final rad = (deg - 90) * (pi / 180);
      final lx = cx + labelRadius * cos(rad);
      final ly = cy + labelRadius * sin(rad);

      final textSpan = TextSpan(
        text: deg.toString(),
        style: TextStyle(
          color: deg == 0 ? const Color(0xFFFF4500) : const Color(0xFFD1D1D6),
          fontSize: 11.5 * scale,
          fontWeight: FontWeight.w600,
          fontFamily: 'Inter',
        ),
      );

      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center,
      )..layout();

      textPainter.paint(
        canvas,
        Offset(lx - textPainter.width / 2, ly - textPainter.height / 2),
      );
    }

    // 4. Cardinal Direction Labels
    // North (N) - Large Accent Orange
    final northPainter = TextPainter(
      text: TextSpan(
        text: 'N',
        style: TextStyle(
          color: const Color(0xFFFF4500),
          fontSize: 21.0 * scale,
          fontWeight: FontWeight.w700,
          fontFamily: 'Inter',
        ),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    )..layout();

    northPainter.paint(
      canvas,
      Offset(cx - northPainter.width / 2, cy - (150 - 70) * scale),
    );

    // Cardinal Origin Indicator Triangle (pointing up to N)
    final trianglePath = Path()
      ..moveTo(cx, cy - 59.0 * scale)
      ..lineTo(cx - 6.0 * scale, cy - 47.0 * scale)
      ..lineTo(cx + 6.0 * scale, cy - 47.0 * scale)
      ..close();

    final trianglePaint = Paint()
      ..color = const Color(0xFFFF4500)
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    canvas.drawPath(trianglePath, trianglePaint);

    // East (E)
    final eastPainter = TextPainter(
      text: TextSpan(
        text: 'E',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20.0 * scale,
          fontWeight: FontWeight.w700,
          fontFamily: 'Inter',
        ),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    )..layout();

    eastPainter.paint(
      canvas,
      Offset(cx + (238 - 150) * scale - eastPainter.width / 2, cy - eastPainter.height / 2),
    );

    // South (S)
    final southPainter = TextPainter(
      text: TextSpan(
        text: 'S',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20.0 * scale,
          fontWeight: FontWeight.w700,
          fontFamily: 'Inter',
        ),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    )..layout();

    southPainter.paint(
      canvas,
      Offset(cx - southPainter.width / 2, cy + (234 - 150) * scale - southPainter.height / 2),
    );

    // West (W)
    final westPainter = TextPainter(
      text: TextSpan(
        text: 'W',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20.0 * scale,
          fontWeight: FontWeight.w700,
          fontFamily: 'Inter',
        ),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    )..layout();

    westPainter.paint(
      canvas,
      Offset(cx - (150 - 62) * scale - westPainter.width / 2, cy - westPainter.height / 2),
    );

    // Reference Bearing Pip marker
    if (referenceBearing != null) {
      final refRad = (referenceBearing! - 90) * (pi / 180);
      final rx = cx + (radiusOuter - 2) * cos(refRad);
      final ry = cy + (radiusOuter - 2) * sin(refRad);

      final pipPaint = Paint()
        ..color = const Color(0xFFFF4500)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(Offset(rx, ry), 3.5 * scale, pipPaint);
    }
  }

  void _drawReferenceBearingArc(Canvas canvas, double cx, double cy, double radiusOuter, double scale) {
    final ref = referenceBearing!;
    final cur = currentHeading;

    // Calculate angular deviation
    var diff = (cur - ref) % 360;
    if (diff > 180) diff -= 360;
    if (diff < -180) diff += 360;

    if (diff.abs() > 1.0) {
      final startAngleRad = (ref - 90) * (pi / 180);
      final sweepAngleRad = diff * (pi / 180);

      final arcPaint = Paint()
        ..color = const Color(0x4DFF4500) // subtle translucent orange
        ..style = PaintingStyle.stroke
        ..strokeWidth = 6.0 * scale
        ..strokeCap = StrokeCap.round
        ..isAntiAlias = true;

      final rect = Rect.fromCircle(center: Offset(cx, cy), radius: radiusOuter - 3 * scale);
      canvas.drawArc(rect, startAngleRad, sweepAngleRad, false, arcPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CompassDialPainter oldDelegate) {
    return oldDelegate.referenceBearing != referenceBearing ||
        oldDelegate.currentHeading != currentHeading;
  }
}

/// Custom Painter for the Center Fixed Reticle & Crosshair
/// Stays stationary while the dial rotates beneath it
class FixedReticlePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final scale = size.width / 300.0;

    final linePaint = Paint()
      ..color = const Color(0x66FFFFFF) // 40% white
      ..strokeWidth = 1.0
      ..isAntiAlias = true;

    // Horizontal crosshair line (68px wide)
    final hLen = 34.0 * scale;
    canvas.drawLine(Offset(cx - hLen, cy), Offset(cx + hLen, cy), linePaint);

    // Vertical crosshair line (68px high)
    final vLen = 34.0 * scale;
    canvas.drawLine(Offset(cx, cy - vLen), Offset(cx, cy + vLen), linePaint);

    // Center alignment guide ring (40px diameter)
    final circlePaint = Paint()
      ..color = const Color(0x33FFFFFF) // 20% white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..isAntiAlias = true;
    canvas.drawCircle(Offset(cx, cy), 20.0 * scale, circlePaint);

    // Center level dot (6px diameter)
    final dotPaint = Paint()
      ..color = const Color(0x80FFFFFF) // 50% white
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;
    canvas.drawCircle(Offset(cx, cy), 3.0 * scale, dotPaint);
  }

  @override
  bool shouldRepaint(covariant FixedReticlePainter oldDelegate) => false;
}
