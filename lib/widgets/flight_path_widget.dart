import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'dotted_line_painter.dart';

class FlightPathWidget extends StatelessWidget {
  final String duration;

  const FlightPathWidget({super.key, required this.duration});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            alignment: Alignment.topCenter,
            clipBehavior: Clip.none,
            children: [
              SizedBox(
                width: 48,
                height: 24,
                child: CustomPaint(
                  painter: DottedLinePainter(
                    color: AppColors.dashLine.withValues(alpha: 0.5),
                    dashWidth: 4,
                    dashSpace: 3,
                    isArc: true,
                  ),
                ),
              ),
              Positioned(
                top: 10, // Perfectly centered on the smaller arc
                child: Transform.rotate(
                  angle: 1.1,
                  child: const Icon(
                    Icons.airplanemode_active,
                    color: AppColors.primaryBlue,
                    size: 14,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            duration,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.textMain,
            ),
          ),
        ],
      ),
    );
  }
}
