import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:rounder_application/core/theme/app_theme.dart';
import 'package:rounder_application/layout/resident/features/dashboard/presentation/view/style/home_text_styles.dart';

/// The next-service countdown gauge: a 137 × 64 half-ellipse made of a track
/// arc and a gradient progress arc, with the time inside and its unit under.
///
/// Drawn with a [CustomPainter] so the arc caps, gradient and stroke stay
/// vector sharp at any scale.
class CountdownGauge extends StatelessWidget {
  const CountdownGauge({
    super.key,
    required this.value,
    required this.unitLabel,
    this.progress = 0.72,
  });

  final String value;
  final String unitLabel;
  final double progress;

  static const double _width = 137;
  static const double _height = 64;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _width,
      height: _height,
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: CustomPaint(
              painter: _CountdownArcPainter(progress: progress),
            ),
          ),
          PositionedDirectional(
            top: 5,
            start: 0,
            end: 0,
            child: Text(
              value,
              textAlign: TextAlign.center,
              style: HomeTextStyles.countdownValue.copyWith(
                fontFeatures: const <FontFeature>[FontFeature.tabularFigures()],
              ),
            ),
          ),
          PositionedDirectional(
            bottom: 8,
            start: 0,
            end: 0,
            child: Text(
              unitLabel,
              textAlign: TextAlign.center,
              style: HomeTextStyles.countdownUnit,
            ),
          ),
        ],
      ),
    );
  }
}

class _CountdownArcPainter extends CustomPainter {
  const _CountdownArcPainter({required this.progress});

  final double progress;

  static const double _strokeWidth = 6;

  @override
  void paint(Canvas canvas, Size size) {
    // The visible half ellipse: ends at y = 22, bottom at y = 64.
    final Rect arcRect = Rect.fromCenter(
      center: Offset(size.width / 2, 22),
      width: size.width - 8,
      height: 84,
    );

    final Paint track = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = _strokeWidth
      ..strokeCap = StrokeCap.round
      ..color = AppColors.gaugeTrack;
    canvas.drawArc(arcRect, 0, math.pi, false, track);

    final Paint progressPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = _strokeWidth
      ..strokeCap = StrokeCap.round
      ..shader = const LinearGradient(
        colors: <Color>[
          AppColors.petrol,
          AppColors.countdownMid,
          AppColors.coral,
        ],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ).createShader(arcRect);

    // Progress runs from the left end of the arc towards the right one.
    canvas.drawArc(
      arcRect,
      math.pi,
      -math.pi * progress.clamp(0.0, 1.0),
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(_CountdownArcPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
