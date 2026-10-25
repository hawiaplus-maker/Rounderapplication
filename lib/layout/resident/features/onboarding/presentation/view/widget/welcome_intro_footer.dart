import 'package:flutter/material.dart';
import 'package:rounder_application/core/theme/app_theme.dart';

/// Bottom bar of an intro step: 3 progress pills lit right-to-left (RTL
/// reading order — the active one follows the step) + the primary CTA.
class WelcomeIntroFooter extends StatelessWidget {
  const WelcomeIntroFooter({
    super.key,
    required this.step,
    required this.ctaLabel,
    required this.onNext,
  });
  final int step; // 1..3
  final String ctaLabel;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _ProgressPill(active: step - 1 == 0),
            const SizedBox(width: 15),
            _ProgressPill(active: step - 1 == 1),
            const SizedBox(width: 15),
            _ProgressPill(active: step - 1 == 2),
          ],
        ),
        const SizedBox(height: 30),
        FilledButton(
          onPressed: onNext,
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.coral,
            foregroundColor: AppColors.petrol,
            minimumSize: const Size.fromHeight(56),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: Text(
            ctaLabel,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.petrol,
              fontSize: 19,
              height: 32 / 19,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

class _ProgressPill extends StatelessWidget {
  const _ProgressPill({required this.active});

  final bool active;

  @override
  Widget build(BuildContext context) => AnimatedContainer(
    duration: const Duration(milliseconds: 220),
    width: 24,
    height: 6,
    decoration: BoxDecoration(
      color: active ? AppColors.petrol : AppColors.mintLight,
      borderRadius: BorderRadius.circular(3),
    ),
  );
}
