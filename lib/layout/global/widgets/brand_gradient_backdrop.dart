import 'package:flutter/material.dart';
import 'package:rounder_application/core/theme/app_theme.dart';

/// Brand page wash shared by the resident features (rounder-shared-widgets):
/// the default resident gradient, the deeper union/account/service variant and
/// the onboarding variant. Presets keep the approved stops in one place;
/// callers only supply [child].
class BrandGradientBackdrop extends StatelessWidget {
  const BrandGradientBackdrop({super.key, required this.child})
    : stops = _residentStops,
      colors = _residentColors;

  const BrandGradientBackdrop.deep({super.key, required this.child})
    : stops = _deepStops,
      colors = _deepColors;

  const BrandGradientBackdrop.onboarding({super.key, required this.child})
    : stops = _onboardingStops,
      colors = _residentColors;

  static const List<double> _residentStops = [0, .25, .42, .6, .78, 1];
  static const List<double> _onboardingStops = [0, .19, .34, .57, .76, 1];
  static const List<double> _deepStops = [0, .25, .52, .72, 1];
  static const List<Color> _residentColors = [
    AppColors.petrol,
    AppColors.petrol,
    AppColors.teal,
    AppColors.mintLight,
    AppColors.canvas,
    AppColors.sand,
  ];
  static const List<Color> _deepColors = [
    AppColors.petrol,
    AppColors.teal,
    AppColors.mintDeep,
    AppColors.mint,
    AppColors.sand,
  ];

  final Widget child;
  final List<double> stops;
  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: stops,
          colors: colors,
        ),
      ),
      child: child,
    );
  }
}
