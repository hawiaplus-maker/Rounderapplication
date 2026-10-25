import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';

import 'package:rounder_application/core/theme/app_theme.dart';
import 'package:rounder_application/layout/resident/features/dashboard/presentation/view/style/home_layout.dart';

/// Translucent white surface used by the home selector, cards and dock.
///
/// The dock additionally blurs (backdrop blur 20) whatever scrolls behind it.
class HomeGlassPanel extends StatelessWidget {
  const HomeGlassPanel({
    super.key,
    required this.child,
    this.padding,
    this.radius = HomeRadii.card,
    this.fill = AppColors.glassCardFill,
    this.stroke = AppColors.glassCardStroke,
    this.shadow,
    this.blurSigma,
    this.height,
    this.width,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double radius;
  final Color fill;
  final Color stroke;
  final List<BoxShadow>? shadow;
  final double? blurSigma;
  final double? height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    final BorderRadius borderRadius = BorderRadius.circular(radius);

    Widget panel = Container(
      height: height,
      width: width,
      padding: padding,
      decoration: BoxDecoration(
        color: fill,
        borderRadius: borderRadius,
        border: Border.all(color: stroke),
      ),
      child: child,
    );

    if (blurSigma != null) {
      panel = ClipRRect(
        borderRadius: borderRadius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blurSigma!, sigmaY: blurSigma!),
          child: panel,
        ),
      );
    }

    if (shadow == null) {
      return panel;
    }

    return DecoratedBox(
      decoration: BoxDecoration(borderRadius: borderRadius, boxShadow: shadow),
      child: panel,
    );
  }
}
