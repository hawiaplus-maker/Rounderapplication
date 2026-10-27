import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/core/theme/app_theme.dart';
import 'package:rounder_application/layout/resident/features/association/presentation/view/widget/union_line.dart';
import 'package:rounder_application/layout/resident/features/association/presentation/view/widget/union_panel.dart';
import 'package:rounder_application/layout/resident/features/association/presentation/view/widget/union_prototype_note.dart';
import 'package:rounder_application/layout/resident/features/association/presentation/view/widget/union_sub_page.dart';

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
              textAlign: TextAlign.right,
              style: const TextStyle(color: Colors.white70),
            ),
            Text(
              '300 ${AppLocaleKey.currencySar.tr()}',
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              AppLocaleKey.dueDate.tr(),
              textAlign: TextAlign.right,
              style: const TextStyle(color: Colors.white70),
            ),
          ],
        ),
        SegmentedButton<bool>(
          segments: [
            ButtonSegment(
              value: false,
              label: Text(AppLocaleKey.paid.tr()),
            ),
            ButtonSegment(
              value: true,
              label: Text(AppLocaleKey.pending.tr()),
            ),
          ],
          selected: const {true},
          onSelectionChanged: (_) {},
        ),
        const SizedBox(height: 12),
        UnionPanel(
          children: [
            UnionLine(
              titleKey: AppLocaleKey.unitTitle,
              value: '300 ${AppLocaleKey.currencySar.tr()}',
            ),
            Text(
              '${AppLocaleKey.currentUnit.tr()} • ${AppLocaleKey.septemberDues.tr()}',
              textAlign: TextAlign.right,
              style: const TextStyle(color: AppColors.muted),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: FilledButton(
            onPressed: onComingSoon,
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.orange,
            ),
            child: Text(AppLocaleKey.pay.tr()),
          ),
        ),
        const UnionPrototypeNote(),
      ],
    );
  }
}
