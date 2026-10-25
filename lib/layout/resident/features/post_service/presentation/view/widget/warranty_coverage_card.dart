import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
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
            style: const TextStyle(
              color: AppColors.petrol,
              fontSize: 17,
              height: 26 / 17,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            AppLocaleKey.warrantyCoverageBody.tr(),
            textAlign: TextAlign.start,
            style: const TextStyle(
              color: AppColors.teal,
              fontSize: 14,
              height: 24 / 14,
            ),
          ),
          const Divider(height: 26),
          Text(
            AppLocaleKey.warrantyExclusionsTitle.tr(),
            textAlign: TextAlign.start,
            style: const TextStyle(
              color: AppColors.petrol,
              fontSize: 15,
              height: 24 / 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            AppLocaleKey.warrantyExclusionsBody.tr(),
            textAlign: TextAlign.start,
            style: const TextStyle(
              color: AppColors.teal,
              fontSize: 14,
              height: 24 / 14,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            AppLocaleKey.warrantyExclusionsNote.tr(),
            textAlign: TextAlign.start,
            style: const TextStyle(
              color: AppColors.muted,
              fontSize: 12,
              height: 20 / 12,
            ),
          ),
        ],
      ),
    );
  }
}
