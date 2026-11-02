import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/core/theme/app_text_styles.dart';
import 'package:rounder_application/core/theme/app_theme.dart';

/// Warranty summary card (design مطابقة 882:5138): heading plus the
/// start/end/duration spec rows. Values currently absent in the source data —
/// rendered as explicit "not available" rows straight from the frame copy.
class WarrantySummaryCard extends StatelessWidget {
  const WarrantySummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    final rows = [
      (AppLocaleKey.warrantyStart.tr(), AppLocaleKey.valueUnavailable.tr()),
      (AppLocaleKey.warrantyEnd.tr(), AppLocaleKey.valueUnavailableShort.tr()),
      (AppLocaleKey.warrantyDuration.tr(), AppLocaleKey.valueUnavailable.tr()),
    ];
    return _Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            AppLocaleKey.warrantyThisService.tr(),
            textAlign: TextAlign.start,
            style: AppTextStyles.bodyBold17.copyWith(color: AppColors.petrol),
          ),
          const SizedBox(height: 12),
          for (final row in rows) ...[
            Row(
              children: [
                Expanded(
                  child: Text(
                    row.$1,
                    textAlign: TextAlign.start,
                    style: AppTextStyles.bodySmall.copyWith(color: AppColors.muted),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  row.$2,
                  textAlign: TextAlign.end,
                  style: AppTextStyles.bodyBold14.copyWith(color: AppColors.petrol),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
        ],
      ),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: AppColors.white.withValues(alpha: .92),
      borderRadius: BorderRadius.circular(24),
    ),
    child: child,
  );
}
