import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/core/theme/app_theme.dart';
import 'package:rounder_application/layout/resident/features/association/presentation/view/widget/union_action_button.dart';
import 'package:rounder_application/layout/resident/features/association/presentation/view/widget/union_line.dart';
import 'package:rounder_application/layout/resident/features/association/presentation/view/widget/union_panel.dart';
import 'package:rounder_application/layout/resident/features/association/presentation/view/widget/union_prototype_note.dart';
import 'package:rounder_application/layout/resident/features/association/presentation/view/widget/union_sub_page.dart';

/// Association initiatives page.
class UnionInitiativePage extends StatelessWidget {
  const UnionInitiativePage({
    super.key,
    required this.onBack,
    required this.likes,
    required this.onLike,
    required this.onComingSoon,
  });

  final VoidCallback onBack;
  final int likes;
  final VoidCallback onLike;
  final VoidCallback onComingSoon;

  @override
  Widget build(BuildContext context) {
    return UnionSubPage(
      titleKey: AppLocaleKey.initiatives,
      onBack: onBack,
      children: [
        UnionPanel(
          children: [
            Text(
              AppLocaleKey.improveEntrance.tr(),
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w800,
                color: AppColors.petrol,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              AppLocaleKey.residentsJoined.tr(),
              textAlign: TextAlign.right,
            ),
            const SizedBox(height: 10),
            const LinearProgressIndicator(
              value: .7,
              color: AppColors.petrol,
              backgroundColor: AppColors.mint,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: onLike,
                child: Text('${AppLocaleKey.shareIdea.tr()}  •  $likes'),
              ),
            ),
          ],
        ),
        UnionPanel(
          children: [
            Text(
              AppLocaleKey.initiatives.tr(),
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                color: AppColors.petrol,
              ),
            ),
            UnionLine(
              titleKey: AppLocaleKey.cleaning,
              value: AppLocaleKey.cleaningCampaign.tr(),
            ),
            UnionActionButton(
              labelKey: AppLocaleKey.suggestInitiative,
              icon: Icons.add_circle_outline,
              onTap: onComingSoon,
            ),
          ],
        ),
        const UnionPrototypeNote(),
      ],
    );
  }
}
