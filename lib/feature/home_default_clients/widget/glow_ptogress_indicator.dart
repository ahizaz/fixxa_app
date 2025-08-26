import 'dart:math' as math;

import 'package:flutter/material.dart';

class GlowingProgressPainter extends CustomPainter {
  final double value;
  final Color color;

  GlowingProgressPainter({required this.value, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final double strokeWidth = 6;
    final double radius = math.min(size.width / 2, size.height / 2);
    final Offset center = Offset(radius, radius);
    final Rect rect = Rect.fromCircle(center: center, radius: radius - strokeWidth / 2);

    // Track paint (semi-transparent full circle)
    final Paint trackPaint = Paint()
      ..color = color.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    // Draw track as full circle
    canvas.drawCircle(center, radius - strokeWidth / 2, trackPaint);

    // Glow paint for progress (blurred outer)
    final Paint glowPaint = Paint()
      ..color = color.withValues(alpha: 0.35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..maskFilter = MaskFilter.blur(BlurStyle.outer, 10);

    // Progress paint (sharp)
    final Paint progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    // Draw glow for progress arc
    final double startAngle = -math.pi / 2;
    final double sweepAngle = 2 * math.pi * value.clamp(0.0, 1.0);
    canvas.drawArc(rect, startAngle, sweepAngle, false, glowPaint);

    // Draw sharp progress arc on top
    canvas.drawArc(rect, startAngle, sweepAngle, false, progressPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}