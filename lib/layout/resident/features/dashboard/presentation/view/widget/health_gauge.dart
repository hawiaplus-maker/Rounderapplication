import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:rounder_application/core/theme/app_theme.dart';

/// Half-ellipse health gauge of the property card.
///
/// The arc mirrors the exported `gauge-health.svg`: the same track, gradient,
/// stroke and round caps, but the progress follows the real percentage.
class HealthGauge extends StatelessWidget {
  const HealthGauge({super.key, required this.percent});

  final int percent;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 126,
      height: 73,
      child: CustomPaint(
        painter: _HealthGaugePainter(progress: percent.clamp(0, 100) / 100),
      ),
    );
  }
}

class _HealthGaugePainter extends CustomPainter {
  const _HealthGaugePainter({required this.progress});

  final double progress;

  static const double _strokeWidth = 11.4545;
  static const double _radius = 51.545;

  @override
  void paint(Canvas canvas, Size size) {
    final Rect arcRect = Rect.fromCircle(
      center: const Offset(63, 63),
      radius: _radius,
    );

    final Paint track = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = _strokeWidth
      ..strokeCap = StrokeCap.round
      ..color = AppColors.mint;
    canvas.drawArc(arcRect, math.pi, math.pi, false, track);

    if (progress <= 0) {
      return;
    }

    final Paint arc = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = _strokeWidth
      ..strokeCap = StrokeCap.round
      ..shader = const LinearGradient(
        colors: <Color>[
          AppColors.healthGaugeStart,
          AppColors.healthGaugeMid,
          AppColors.healthGaugeEnd,
        ],
        stops: <double>[0, 0.55, 1],
        begin: Alignment.bottomLeft,
        end: Alignment.topRight,
      ).createShader(arcRect);

    canvas.drawArc(arcRect, math.pi, math.pi * progress, false, arc);
  }

  @override
  bool shouldRepaint(_HealthGaugePainter oldDelegate) =>
      oldDelegate.progress != progress;
}
