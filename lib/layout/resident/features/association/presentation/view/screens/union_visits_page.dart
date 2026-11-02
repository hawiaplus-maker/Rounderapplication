import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rounder_application/core/constants/display_placeholder.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/core/theme/app_text_styles.dart';
import 'package:rounder_application/core/theme/app_theme.dart';
import 'package:rounder_application/layout/resident/features/association/presentation/view/widget/union_action_button.dart';
import 'package:rounder_application/layout/resident/features/association/presentation/view/widget/union_line.dart';
import 'package:rounder_application/layout/resident/features/association/presentation/view/widget/union_panel.dart';
import 'package:rounder_application/layout/resident/features/association/presentation/view/screens/union_sub_page.dart';

/// Association visits page: the upcoming visit and the completed one.
class UnionVisitsPage extends StatelessWidget {
  const UnionVisitsPage({
    super.key,
    required this.onBack,
    required this.onComingSoon,
  });

  final VoidCallback onBack;
  final VoidCallback onComingSoon;

  @override
  Widget build(BuildContext context) {
    return UnionSubPage(
      titleKey: AppLocaleKey.unionVisits,
      onBack: onBack,
      children: [
        UnionPanel(
          children: [
            Text(
              AppLocaleKey.visitUpcoming.tr(),
              textAlign: TextAlign.start,
              style: AppTextStyles.extraBold19.copyWith(color: AppColors.petrol),
            ),
            const SizedBox(height: 8),
            Text(AppLocaleKey.cleaning.tr(), textAlign: TextAlign.start),
            Text(
              AppLocaleKey.visitDateTime.tr(),
              textAlign: TextAlign.start,
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.muted),
            ),
            const SizedBox(height: 14),
            const CircularProgressIndicator(
              value: DisplayPlaceholder.progress,
              strokeWidth: 8,
              color: AppColors.petrol,
            ),
            const SizedBox(height: 8),
            UnionActionButton(
              labelKey: AppLocaleKey.visitUpcoming,
              icon: Icons.calendar_today_outlined,
              onTap: onComingSoon,
            ),
          ],
        ),
        UnionPanel(
          children: [
            Text(
              AppLocaleKey.visitCompleted.tr(),
              textAlign: TextAlign.start,
              style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w800, color: AppColors.petrol),
            ),
            UnionLine(
              titleKey: AppLocaleKey.facilitiesReports,
              value: AppLocaleKey.completedDate.tr(),
            ),
          ],
        ),
      ],
    );
  }
}
