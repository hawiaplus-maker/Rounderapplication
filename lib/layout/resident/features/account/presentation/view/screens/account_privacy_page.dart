import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/core/theme/app_theme.dart';
import 'package:rounder_application/layout/resident/features/account/presentation/view/widget/account_action_button.dart';
import 'package:rounder_application/layout/resident/features/account/presentation/view/widget/account_panel.dart';
import 'package:rounder_application/layout/resident/features/account/presentation/view/screens/account_sub_page.dart';

/// Privacy page: service-address/contact preferences and data review entries.
class AccountPrivacyPage extends StatelessWidget {
  const AccountPrivacyPage({
    super.key,
    required this.onBack,
    required this.addressUse,
    required this.requestContact,
    required this.onAddressUseChanged,
    required this.onRequestContactChanged,
    required this.onCommunicationPrefs,
    required this.onReviewData,
  });

  final VoidCallback onBack;
  final bool addressUse;
  final bool requestContact;
  final ValueChanged<bool> onAddressUseChanged;
  final ValueChanged<bool> onRequestContactChanged;
  final VoidCallback onCommunicationPrefs;
  final VoidCallback onReviewData;

  @override
  Widget build(BuildContext context) {
    return AccountSubPage(
      titleKey: AppLocaleKey.privacy,
      onBack: onBack,
      children: [
        AccountPanel(
          children: [
            Text(
              AppLocaleKey.privacyData.tr(),
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: AppColors.petrol,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 12),
            SwitchListTile(
              tileColor: Colors.white,
              contentPadding: EdgeInsets.zero,
              title: Text(AppLocaleKey.serviceAddress.tr()),
              subtitle: Text(AppLocaleKey.privacyAddressBody.tr()),
              value: addressUse,
              activeThumbColor: AppColors.orange,
              onChanged: onAddressUseChanged,
            ),
            SwitchListTile(
              tileColor: Colors.white,
              contentPadding: EdgeInsets.zero,
              title: Text(AppLocaleKey.requestContact.tr()),
              subtitle: Text(AppLocaleKey.privacyContactBody.tr()),
              value: requestContact,
              activeThumbColor: AppColors.orange,
              onChanged: onRequestContactChanged,
            ),
            Text(
              AppLocaleKey.optionalOffers.tr(),
              textAlign: TextAlign.right,
              style: const TextStyle(color: AppColors.muted, fontSize: 12),
            ),
          ],
        ),
        AccountPanel(
          children: [
            AccountActionButton(
              labelKey: AppLocaleKey.communicationPrefs,
              icon: Icons.tune,
              onTap: onCommunicationPrefs,
            ),
            const SizedBox(height: 9),
            AccountActionButton(
              labelKey: AppLocaleKey.reviewData,
              icon: Icons.person_outline,
              onTap: onReviewData,
            ),
          ],
        ),
      ],
    );
  }
}
