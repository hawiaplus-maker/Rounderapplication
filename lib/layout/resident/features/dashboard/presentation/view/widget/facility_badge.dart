import 'package:flutter/material.dart';

import 'package:rounder_application/core/theme/app_theme.dart';
import 'package:rounder_application/layout/resident/features/dashboard/presentation/view/style/home_layout.dart';
import 'package:rounder_application/layout/resident/features/dashboard/presentation/view/style/home_text_styles.dart';

/// Mint pill used to tag the visit cards with the facility type.
class FacilityBadge extends StatelessWidget {
  const FacilityBadge({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 137),
      height: 22,
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: AppColors.mintLight,
        borderRadius: BorderRadius.circular(HomeRadii.chip),
      ),
      alignment: AlignmentDirectional.center,
      child: Text(
        label,
        style: HomeTextStyles.chipLabel,
        textAlign: TextAlign.center,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
