import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rounder_application/core/constants/display_placeholder.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/core/theme/app_text_styles.dart';
import 'package:rounder_application/core/theme/app_theme.dart';
import 'package:rounder_application/layout/resident/features/association/presentation/view/widget/union_line.dart';
import 'package:rounder_application/layout/resident/features/association/presentation/view/widget/union_panel.dart';
import 'package:rounder_application/layout/resident/features/association/presentation/view/screens/union_sub_page.dart';

/// Association dues page: amount, paid/pending split and the pay action.
class UnionDuesPage extends StatelessWidget {
  const UnionDuesPage({
    super.key,
    required this.onBack,
    required this.onComingSoon,
  });

  final VoidCallback onBack;
  final VoidCallback onComingSoon;

  @override
  Widget build(BuildContext context) {
    return UnionSubPage(
      titleKey: AppLocaleKey.myDues,
      onBack: onBack,
      children: [
        UnionPanel(
          glass: true,
          children: [
            Text(
              AppLocaleKey.dueAmount.tr(),
              textAlign: TextAlign.start,
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.white.withValues(alpha: .7)),
            ),
            Text(
              '${DisplayPlaceholder.number} ${AppLocaleKey.currencySar.tr()}',
              textAlign: TextAlign.start,
              style: AppTextStyles.extraBold30.copyWith(color: AppColors.white),
            ),
            Text(
              AppLocaleKey.dueDate.tr(),
              textAlign: TextAlign.start,
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.white.withValues(alpha: .7)),
            ),
          ],
        ),
        SegmentedButton<bool>(
          segments: [
            ButtonSegment(value: false, label: Text(AppLocaleKey.paid.tr())),
            ButtonSegment(value: true, label: Text(AppLocaleKey.pending.tr())),
          ],
          selected: const {true},
          onSelectionChanged: (_) {},
        ),
        const SizedBox(height: 12),
        UnionPanel(
          children: [
            UnionLine(
              titleKey: AppLocaleKey.unitTitle,
              value:
                  '${DisplayPlaceholder.number} ${AppLocaleKey.currencySar.tr()}',
            ),
            Text(
              '${AppLocaleKey.currentUnit.tr()} • ${AppLocaleKey.septemberDues.tr()}',
              textAlign: TextAlign.start,
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.muted),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: FilledButton(
            onPressed: onComingSoon,
            style: FilledButton.styleFrom(backgroundColor: AppColors.orange),
            child: Text(AppLocaleKey.pay.tr()),
          ),
        ),
      ],
    );
  }
}
