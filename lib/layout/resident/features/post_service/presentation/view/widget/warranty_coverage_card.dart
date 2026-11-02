import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/core/theme/app_text_styles.dart';
import 'package:rounder_application/core/theme/app_theme.dart';

/// Warranty coverage card (design 882:5138): what the warranty covers today
/// plus the exclusions/start guidance, all as explicit unavailable-state copy.
class WarrantyCoverageCard extends StatelessWidget {
  const WarrantyCoverageCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: .92),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            AppLocaleKey.warrantyCoverageTitle.tr(),
            textAlign: TextAlign.start,
            style: AppTextStyles.bodyBold17.copyWith(color: AppColors.petrol),
          ),
          const SizedBox(height: 8),
          Text(
            AppLocaleKey.warrantyCoverageBody.tr(),
            textAlign: TextAlign.start,
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.teal, height: 24 / 14),
          ),
          const Divider(height: 26),
          Text(
            AppLocaleKey.warrantyExclusionsTitle.tr(),
            textAlign: TextAlign.start,
            style: AppTextStyles.bodyBold15.copyWith(color: AppColors.petrol),
          ),
          const SizedBox(height: 8),
          Text(
            AppLocaleKey.warrantyExclusionsBody.tr(),
            textAlign: TextAlign.start,
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.teal, height: 24 / 14),
          ),
          const SizedBox(height: 6),
          Text(
            AppLocaleKey.warrantyExclusionsNote.tr(),
            textAlign: TextAlign.start,
            style: AppTextStyles.captionRegular.copyWith(color: AppColors.muted),
          ),
        ],
      ),
    );
  }
}
