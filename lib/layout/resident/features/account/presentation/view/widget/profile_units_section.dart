import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rounder_application/core/constants/display_placeholder.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/core/theme/app_text_styles.dart';
import 'package:rounder_application/core/theme/app_theme.dart';
import 'package:rounder_application/layout/resident/features/account/presentation/view/widget/account_panel.dart';
import 'package:rounder_application/logic/number_text_logic.dart';

/// Linked-units card of the account page (design 511:812): the linked count,
/// the current residence and the manage action.
class ProfileUnitsSection extends StatelessWidget {
  const ProfileUnitsSection({
    super.key,
    required this.count,
    required this.homeName,
    required this.unitLabel,
    required this.onManage,
  });

  final int count;
  final String homeName, unitLabel;
  final VoidCallback onManage;

  @override
  Widget build(BuildContext context) {
    final String language = Localizations.localeOf(context).languageCode;
    final bool hasHome = count > 0;
    return AccountPanel(
      children: [
        Row(
          children: [
            const Icon(
              Icons.apartment_rounded,
              color: AppColors.orange,
              size: 25,
            ),
            const Spacer(),
            Text(
              AppLocaleKey.units.tr(),
              textAlign: TextAlign.start,
              style: AppTextStyles.extraBold19.copyWith(color: AppColors.petrol),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          hasHome ? localizedNumber(count, language) : '',
          textAlign: TextAlign.start,
          style: AppTextStyles.extraBold27.copyWith(color: AppColors.petrol),
        ),
        Text(
          hasHome
              ? AppLocaleKey.linkedUnitsCount.plural(
                  count,
                  namedArgs: {'count': localizedNumber(count, language)},
                )
              : AppLocaleKey.linkedHomes.tr(),
          textAlign: TextAlign.start,
          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.muted),
        ),
        const Divider(height: 24),
        Row(
          children: [
            FilledButton(
              onPressed: onManage,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.orange,
                foregroundColor: AppColors.white,
              ),
              child: Text(AppLocaleKey.manage.tr()),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    hasHome ? homeName : DisplayPlaceholder.text,
                    textAlign: TextAlign.end,
                    style: AppTextStyles.headingH4.copyWith(color: AppColors.petrol),
                  ),
                  Text(
                    _unitLine(context, unitLabel),
                    textAlign: TextAlign.end,
                    style: AppTextStyles.captionRegular.copyWith(color: AppColors.muted),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// `وحدة ١٢٠٤ • الوحدة الحالية` — the design's current-unit line; empty
  /// (hidden) while the dashboard has not returned a unit yet.
  String _unitLine(BuildContext context, String raw) {
    final String value = raw.trim();
    if (value.isEmpty) return '';
    final String unit = localizedNumericText(
      value,
      Localizations.localeOf(context).languageCode,
    );
    return '${AppLocaleKey.homeUnitWord.tr()} $unit • '
        '${AppLocaleKey.currentUnit.tr()}';
  }
}
