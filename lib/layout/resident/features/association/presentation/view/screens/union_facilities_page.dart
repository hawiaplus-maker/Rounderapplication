import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/core/theme/app_text_styles.dart';
import 'package:rounder_application/core/theme/app_theme.dart';
import 'package:rounder_application/layout/resident/features/association/presentation/view/widget/union_action_button.dart';
import 'package:rounder_application/layout/resident/features/association/presentation/view/widget/union_line.dart';
import 'package:rounder_application/layout/resident/features/association/presentation/view/widget/union_panel.dart';
import 'package:rounder_application/layout/resident/features/association/presentation/view/screens/union_sub_page.dart';

/// Association facilities reports page.
class UnionFacilitiesPage extends StatelessWidget {
  const UnionFacilitiesPage({
    super.key,
    required this.onBack,
    required this.onComingSoon,
  });

  final VoidCallback onBack;
  final VoidCallback onComingSoon;

  @override
  Widget build(BuildContext context) {
    return UnionSubPage(
      titleKey: AppLocaleKey.facilitiesReports,
      onBack: onBack,
      children: [
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 1.35,
          children: [
            _FacilityTile(
              titleKey: AppLocaleKey.cleaning,
              status: AppLocaleKey.goodCondition.tr(),
              icon: Icons.cleaning_services_outlined,
            ),
            _FacilityTile(
              titleKey: AppLocaleKey.maintenance,
              status: AppLocaleKey.actionRequired.tr(),
              icon: Icons.elevator_outlined,
            ),
            _FacilityTile(
              titleKey: AppLocaleKey.utilities,
              status: AppLocaleKey.goodCondition.tr(),
              icon: Icons.lightbulb_outline,
            ),
            _FacilityTile(
              titleKey: AppLocaleKey.visitUpcoming,
              status: AppLocaleKey.pending.tr(),
              icon: Icons.water_drop_outlined,
            ),
          ],
        ),
        UnionPanel(
          children: [
            Text(
              AppLocaleKey.openReports.tr(),
              textAlign: TextAlign.start,
              style: AppTextStyles.extraBold19.copyWith(color: AppColors.petrol),
            ),
            UnionLine(
              titleKey: AppLocaleKey.maintenance,
              value: AppLocaleKey.elevatorFollowup.tr(),
            ),
            UnionActionButton(
              labelKey: AppLocaleKey.shareIdea,
              icon: Icons.add_circle_outline,
              onTap: onComingSoon,
            ),
            Text(
              AppLocaleKey.noReports.tr(),
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.muted),
            ),
          ],
        ),
      ],
    );
  }
}

class _FacilityTile extends StatelessWidget {
  const _FacilityTile({
    required this.titleKey,
    required this.status,
    required this.icon,
  });

  final String titleKey;
  final String status;
  final IconData icon;

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      color: AppColors.white.withValues(alpha: .92),
      borderRadius: BorderRadius.circular(20),
    ),
    padding: const EdgeInsets.all(14),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Icon(icon, color: AppColors.petrol),
        Text(
          titleKey.tr(),
          style: AppTextStyles.extraBold16.copyWith(color: AppColors.petrol),
        ),
        Text(
          status,
          style: AppTextStyles.captionRegular.copyWith(color: AppColors.muted),
        ),
      ],
    ),
  );
}
