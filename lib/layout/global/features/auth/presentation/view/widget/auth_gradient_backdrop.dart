import 'package:flutter/material.dart';
import 'package:rounder_application/core/theme/app_theme.dart';

/// The approved auth brand wash (rounder-shared-widgets): petrol → teal →
/// mint → canvas → sand, shared by the login, register and OTP screens and
/// promoted here the moment it needed its third copy. `stops` stays a
/// parameter because the frames tweak it per screen.
class AuthGradientBackdrop extends StatelessWidget {
  const AuthGradientBackdrop({
    super.key,
    required this.child,
    this.stops = const [0, .17, .31, .52, .77, 1],
  });
  final Widget child;
  final List<double> stops;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: stops,
          colors: [
            AppColors.petrol,
            AppColors.petrol,
            AppColors.teal,
            AppColors.mintLight,
            AppColors.canvas,
            AppColors.sand,
          ],
        ),
      ),
      child: child,
    );
  }
}
