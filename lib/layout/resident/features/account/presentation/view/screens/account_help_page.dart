import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/core/theme/app_theme.dart';
import 'package:rounder_application/layout/resident/features/account/presentation/view/widget/account_action_button.dart';
import 'package:rounder_application/layout/resident/features/account/presentation/view/widget/account_panel.dart';
import 'package:rounder_application/layout/resident/features/account/presentation/view/widget/account_sub_page.dart';

/// Help page: support entry and the FAQ list.
class AccountHelpPage extends StatelessWidget {
  const AccountHelpPage({
    super.key,
    required this.onBack,
    required this.onContactUs,
  });

  final VoidCallback onBack;
  final VoidCallback onContactUs;

  @override
  Widget build(BuildContext context) {
    return AccountSubPage(
      titleKey: AppLocaleKey.help,
      onBack: onBack,
      children: [
        AccountPanel(
          children: [
            Text(
              AppLocaleKey.faqTitle.tr(),
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: AppColors.petrol,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            AccountActionButton(
              labelKey: AppLocaleKey.contactUs,
              icon: Icons.support_agent,
              onTap: onContactUs,
            ),
          ],
        ),
        AccountPanel(
          children: [
            _FaqTile(
              questionKey: AppLocaleKey.faqHome,
              answerKey: AppLocaleKey.faqHomeAnswer,
            ),
            _FaqTile(
              questionKey: AppLocaleKey.faqPayment,
              answerKey: AppLocaleKey.faqPaymentAnswer,
            ),
            _FaqTile(
              questionKey: AppLocaleKey.faqGift,
              answerKey: AppLocaleKey.faqGiftAnswer,
            ),
            Text(
              AppLocaleKey.faqHint.tr(),
              textAlign: TextAlign.right,
              style: const TextStyle(color: AppColors.muted, fontSize: 12),
            ),
          ],
        ),
      ],
    );
  }
}

class _FaqTile extends StatelessWidget {
  const _FaqTile({required this.questionKey, required this.answerKey});

  final String questionKey;
  final String answerKey;

  @override
  Widget build(BuildContext context) => ExpansionTile(
    tilePadding: EdgeInsets.zero,
    title: Text(
      questionKey.tr(),
      textAlign: TextAlign.right,
      style: const TextStyle(
        color: AppColors.petrol,
        fontWeight: FontWeight.w700,
      ),
    ),
    children: [
      Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Text(
          answerKey.tr(),
          textAlign: TextAlign.right,
          style: const TextStyle(color: AppColors.muted, height: 1.5),
        ),
      ),
    ],
  );
}
