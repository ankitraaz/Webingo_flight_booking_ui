import 'package:flutter/material.dart';
import 'dart:ui';

class DottedLinePainter extends CustomPainter {
  final Color color;
  final double dashWidth;
  final double dashSpace;
  final bool isArc;

  DottedLinePainter({
    required this.color,
    this.dashWidth = 5.0,
    this.dashSpace = 5.0,
    this.isArc = false,
  });

  @override
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke;

    final path = Path();
    if (isArc) {
      final rect = Rect.fromLTWH(0, 0, size.width, size.height * 2);
      path.addArc(rect, 3.14159, 3.14159);
    } else {
      path.moveTo(0, size.height / 2);
      path.lineTo(size.width, size.height / 2);
    }

    for (final pathMetric in path.computeMetrics()) {
      double distance = 0.0;
      while (distance < pathMetric.length) {
        final segmentPath = pathMetric.extractPath(distance, distance + dashWidth);
        
        // Logic to bold ONLY the middle 2-3 dots (the "top" of the arc)
        final progress = distance / pathMetric.length;
        if (isArc && progress > 0.45 && progress < 0.55) {
          paint.strokeWidth = 2.8; // Bolder for the top dots
          paint.color = color.withOpacity(1.0); // Fully solid at top
        } else {
          paint.strokeWidth = 1.6; // Normal thickness for others
          paint.color = color.withOpacity(0.4); // Subtle fade for other dots
        }

        canvas.drawPath(segmentPath, paint);
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant DottedLinePainter oldDelegate) => 
    oldDelegate.color != color || 
    oldDelegate.dashWidth != dashWidth || 
    oldDelegate.dashSpace != dashSpace ||
    oldDelegate.isArc != isArc;
}
