import 'package:flutter/material.dart';
import 'package:rounder_application/core/images/app_images.dart';
import 'package:rounder_application/core/theme/app_theme.dart';

/// Splash lockup (design `00 — سبلاش • Splash`): the approved wordmark inside
/// the brand orbit rings with the floating orbit lights. Decorative artwork —
/// identical in both languages, so the alignment fractions stay fixed.
class SplashBrandLockup extends StatelessWidget {
  const SplashBrandLockup({super.key});

  /// Light centers sit outside the orbit rings in the splash frame; the
  /// fractions are relative to the 202px ring box and overflow it on purpose.
  static const _lightPoints = [
    Alignment(-1.08, -.38),
    Alignment(1.35, .25),
    Alignment(-1.18, 1.15),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 202,
      height: 202,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          const _Ring(size: 184),
          const _Ring(size: 202),
          for (final point in _lightPoints)
            Align(alignment: point, child: const _Light()),
          Image.asset(
            AppImages.rounderWordmark,
            width: 180,
            height: 40,
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
