import 'package:flutter/material.dart';
import 'package:pbl2/telas/tela_home.dart';
import 'dart:ui';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: TelaHome(), // Chamar o nome da tela aqui.
  ));
}

class DottedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double gap;
  final double radius;

  DottedBorderPainter({
    required this.color,
    required this.strokeWidth,
    required this.gap,
    required this.radius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final RRect rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(radius),
    );

    final Path path = Path()..addRRect(rrect);
    final Path metricsPath = Path();

    for (final PathMetric metric in path.computeMetrics()) {
      double distance = 0.0;
      while (distance < metric.length) {
        // Altera o 'length: 5' para mudar o comprimento de cada tracinho
        metricsPath.addPath(
          metric.extractPath(distance, distance + 5),
          Offset.zero,
        );
        distance += 5 + gap;
      }
    }
    canvas.drawPath(metricsPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
