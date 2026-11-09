import 'package:flutter/material.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/layout/resident/features/account/presentation/view/screens/account_sub_page.dart';
import 'package:rounder_application/layout/resident/features/account/presentation/view/widget/account_contact_intro.dart';
import 'package:rounder_application/layout/resident/features/account/presentation/view/widget/account_contact_success_actions.dart';
import 'package:rounder_application/layout/resident/features/account/presentation/view/widget/account_contact_success_card.dart';

/// Contact success page shown after the support endpoint accepts the ticket.
class AccountContactSuccessPage extends StatelessWidget {
  const AccountContactSuccessPage({
    super.key,
    required this.onBack,
    required this.reference,
    required this.submittedAt,
    required this.onBackToHelp,
    required this.onSendAnother,
  });

  final VoidCallback onBack;
  final String reference;
  final DateTime submittedAt;
  final VoidCallback onBackToHelp;
  final VoidCallback onSendAnother;

  @override
  Widget build(BuildContext context) {
    return AccountSubPage(
      titleKey: AppLocaleKey.contactSuccessTitle,
      onBack: onBack,
      children: [
        AccountContactIntro(
          titleKey: AppLocaleKey.contactSuccessTitle,
          subtitleKey: AppLocaleKey.contactSuccessSubtitle,
        ),
        AccountContactSuccessCard(
          reference: reference,
          submittedAt: submittedAt,
        ),
        const SizedBox(height: 4),
        AccountContactSuccessActions(
          onBackToHelp: onBackToHelp,
          onSendAnother: onSendAnother,
        ),
      ],
    );
  }
}
