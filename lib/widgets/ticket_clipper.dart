import 'package:flutter/material.dart';

class TicketClipper extends CustomClipper<Path> {
  final double holeRadius;
  final double holePosition;
  final double? holePositionFromBottom; // New fixed offset feature
  final List<double>? holePositions;
  final double borderRadius;

  TicketClipper({
    this.holeRadius = 15.0,
    this.holePosition = 0.6,
    this.holePositionFromBottom,
    this.holePositions,
    this.borderRadius = 24.0,
  });

  @override
  Path getClip(Size size) {
    final path = Path();
    
    // Draw the main rounded rectangle background
    path.addRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        Radius.circular(borderRadius),
      ),
    );

    // Scalloped cutouts at left and right
    final List<double> positions = holePositions ?? [holePosition];
    
    for (final pos in positions) {
      final yPos = holePositionFromBottom != null 
          ? size.height - holePositionFromBottom! 
          : size.height * pos;
      
      // Left Cutout
      path.addArc(
        Rect.fromCircle(center: Offset(0, yPos), radius: holeRadius),
        -1.57, // appx -90 degrees
        3.14,  // 180 degrees
      );

      // Right Cutout
      path.addArc(
        Rect.fromCircle(center: Offset(size.width, yPos), radius: holeRadius),
        1.57,  // 90 degrees
        3.14,
      );
    }
    
    path.fillType = PathFillType.evenOdd;
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}
