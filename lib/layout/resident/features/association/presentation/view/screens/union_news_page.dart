import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/core/theme/app_theme.dart';
import 'package:rounder_application/layout/resident/features/association/presentation/view/widget/union_line.dart';
import 'package:rounder_application/layout/resident/features/association/presentation/view/widget/union_panel.dart';
import 'package:rounder_application/layout/resident/features/association/presentation/view/screens/union_sub_page.dart';

/// Association news page: announcements and shared documents.
class UnionNewsPage extends StatelessWidget {
  const UnionNewsPage({
    super.key,
    required this.onBack,
    required this.onComingSoon,
  });

  final VoidCallback onBack;
  final VoidCallback onComingSoon;

  @override
  Widget build(BuildContext context) {
    return UnionSubPage(
      titleKey: AppLocaleKey.unionNews,
      onBack: onBack,
      children: [
        UnionPanel(
          children: [
            Text(
              AppLocaleKey.announcement.tr(),
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppColors.petrol,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${AppLocaleKey.cleaning.tr()} • ${AppLocaleKey.announcementDate.tr()}',
              textAlign: TextAlign.right,
            ),
            Text(
              AppLocaleKey.visitUpcoming.tr(),
              textAlign: TextAlign.right,
              style: const TextStyle(color: AppColors.muted),
            ),
            TextButton(
              onPressed: onComingSoon,
              child: Text(AppLocaleKey.reviewNow.tr()),
            ),
          ],
        ),
        UnionPanel(
          children: [
            Text(
              AppLocaleKey.documents.tr(),
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                color: AppColors.petrol,
              ),
            ),
            UnionLine(
              titleKey: AppLocaleKey.financialDetails,
              value: AppLocaleKey.financialPdf.tr(),
            ),
            UnionLine(
              titleKey: AppLocaleKey.facilitiesReports,
              value: AppLocaleKey.cleaningPdf.tr(),
            ),
          ],
        ),
      ],
    );
  }
}
