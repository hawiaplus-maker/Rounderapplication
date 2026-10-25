import 'package:flutter/material.dart';
import 'package:rounder_application/core/images/app_images.dart';
import 'package:rounder_application/core/theme/app_theme.dart';

/// Approved login hero (design `Login / Ali phone hero`): the Ali phone pose
/// inside the brand orbit rings with the floating orbit lights. The artwork
/// slot is a fixed 206px decorative band; rings and lights keep the design's
/// relative positions, so it stays centered on any width.
class LoginHero extends StatelessWidget {
  const LoginHero({super.key});

  static const _lightPoints = [
    Alignment(-.60, -.37),
    Alignment(.75, .25),
    Alignment(-.66, 1.13),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 206,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          const _Ring(size: 184),
          const _Ring(size: 202),
          for (final point in _lightPoints)
            Align(alignment: point, child: const _Light()),
          Image.asset(
            AppImages.aliPhonePose,
            width: 139,
            height: 198,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }
}

class _Ring extends StatelessWidget {
  const _Ring({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      border: Border.all(
        width: .7,
        color: AppColors.white.withValues(alpha: .14),
      ),
    ),
  );
}

class _Light extends StatelessWidget {
  const _Light();

  @override
  Widget build(BuildContext context) => Container(
    width: 3,
    height: 3,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: AppColors.white.withValues(alpha: .88),
    ),
  );
}
