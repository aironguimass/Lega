import 'dart:ui';
import 'package:flutter/material.dart';

class DottedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double dashLength;
  final double gap;
  final double radius;

  DottedBorderPainter({
    required this.color,
    this.strokeWidth = 1.5,
    this.dashLength = 5.0,
    this.gap = 5.0,
    this.radius = 0.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..addRRect(RRect.fromRectAndRadius(
        Offset.zero & size,
        Radius.circular(radius),
      ));

    final dashPath = Path();
    for (final metric in path.computeMetrics()) {
      for (double distance = 0;
          distance < metric.length;
          distance += dashLength + gap) {
        dashPath.addPath(
            metric.extractPath(distance, distance + dashLength), Offset.zero);
      }
    }
    canvas.drawPath(dashPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
