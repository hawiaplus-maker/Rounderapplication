import 'package:flutter/material.dart';
import 'package:rounder_application/core/theme/app_theme.dart';

/// Glass intro card above the auth content card: icon slot + up to two text
/// lines (instruction, optional phone display). Boxes hug their content so
/// translated lines grow instead of clipping.
class OtpIntroCard extends StatelessWidget {
  const OtpIntroCard({
    super.key,
    required this.icon,
    required this.firstLine,
    this.phoneLine,
  });
  final IconData icon;
  final String firstLine;
  final String? phoneLine;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: .15),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.white.withValues(alpha: .35),
          width: .8,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 28, color: AppColors.white),
          const SizedBox(height: 8),
          Text(
            firstLine,
            textAlign: TextAlign.start,
            style: const TextStyle(
              color: AppColors.white,
              fontSize: 15,
              height: 26 / 15,
            ),
          ),
          if (phoneLine != null) ...[
            const SizedBox(height: 8),
            Text(
              phoneLine!,
              // Phone data stays LTR inside the Arabic layout; otherwise the
              // leading "+" and masked digits are reordered.
              textDirection: TextDirection.ltr,
              textAlign: TextAlign.start,
              style: const TextStyle(
                color: AppColors.white,
                fontSize: 17,
                height: 26 / 17,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
