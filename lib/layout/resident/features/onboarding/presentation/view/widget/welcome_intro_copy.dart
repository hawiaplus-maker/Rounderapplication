import 'package:flutter/material.dart';
import 'package:rounder_application/core/theme/app_theme.dart';

/// Headline + supporting copy block of an intro step (rendered text arrives
/// translated from the screen; this widget stays a pure display section).
class WelcomeIntroCopy extends StatelessWidget {
  const WelcomeIntroCopy({super.key, required this.headline, required this.body});
  final String headline;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          headline,
          textAlign: TextAlign.center,
          style: const TextStyle(color: AppColors.petrol, fontSize: 36, height: 50 / 36, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 12),
        Text(
          body,
          textAlign: TextAlign.center,
          style: const TextStyle(color: AppColors.petrol, fontSize: 15, height: 26 / 15),
        ),
      ],
    );
  }
}
