import 'dart:ui';

import 'package:flutter/material.dart';
import 'dart:math' as math;

class DashedBorder extends StatelessWidget {
  final Widget child;
  final double strokeWidth;
  final Color color;
  final Radius radius;
  final List<double> dashPattern; // Por ejemplo: [8, 4]

  const DashedBorder({
    Key? key,
    required this.child,
    this.strokeWidth = 1.0,
    this.color = Colors.grey,
    this.radius = const Radius.circular(8),
    this.dashPattern = const [8, 4],
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DashedBorderPainter(
        strokeWidth: strokeWidth,
        color: color,
        radius: radius,
        dashPattern: dashPattern,
      ),
      child: child,
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  final double strokeWidth;
  final Color color;
  final Radius radius;
  final List<double> dashPattern;

  _DashedBorderPainter({
    required this.strokeWidth,
    required this.color,
    required this.radius,
    required this.dashPattern,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    // Define el rectángulo con esquinas redondeadas
    final RRect rRect = RRect.fromRectAndRadius(
      Offset.zero & size,
      radius,
    );

    // Obtener el path completo
    final Path path = Path()..addRRect(rRect);

    // Dibuja el path con cuadro punteado con el método drawPathDash
    _drawDashedPath(canvas, path, paint);
  }

  void _drawDashedPath(Canvas canvas, Path source, Paint paint) {
    // Calcula la longitud total del path
    final PathMetrics pathMetrics = source.computeMetrics();
    for (final PathMetric pathMetric in pathMetrics) {
      double distance = 0.0;
      int index = 0;
      while (distance < pathMetric.length) {
        final double dashLength = dashPattern[index % dashPattern.length];
        // Si index es par, dibuja la parte (segmento "on")
        if (index % 2 == 0) {
          final double currentDashLength =
              math.min(dashLength, pathMetric.length - distance);
          final Path extractPath =
              pathMetric.extractPath(distance, distance + currentDashLength);
          canvas.drawPath(extractPath, paint);
        }
        distance += dashLength;
        index++;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedBorderPainter oldDelegate) {
    return oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.color != color ||
        oldDelegate.radius != radius ||
        oldDelegate.dashPattern != dashPattern;
  }
}
