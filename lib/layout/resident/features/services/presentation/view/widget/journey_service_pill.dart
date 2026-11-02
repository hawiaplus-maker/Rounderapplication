import 'package:flutter/material.dart';

import 'package:rounder_application/core/theme/app_text_styles.dart';
import 'package:rounder_application/core/theme/app_theme.dart';

/// Mint service row of the category / all-services lists (Figma 511:814):
/// full-width pill, Heading 20 petrol label centered — tappable.
class JourneyServicePill extends StatelessWidget {
  const JourneyServicePill({super.key, required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.mintLight,
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          height: 48,
          child: Center(
            child: Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.headingH2.copyWith(color: AppColors.petrol),
            ),
          ),
        ),
      ),
    );
  }
}