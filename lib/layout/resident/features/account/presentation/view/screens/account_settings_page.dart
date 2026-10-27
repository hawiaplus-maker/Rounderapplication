import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/core/theme/app_theme.dart';
import 'package:rounder_application/layout/resident/features/account/presentation/view/widget/account_action_button.dart';
import 'package:rounder_application/layout/resident/features/account/presentation/view/widget/account_logout_button.dart';
import 'package:rounder_application/layout/resident/features/account/presentation/view/widget/account_panel.dart';
import 'package:rounder_application/layout/resident/features/account/presentation/view/screens/account_sub_page.dart';

/// Communication settings page of the account.
class AccountSettingsPage extends StatelessWidget {
  const AccountSettingsPage({
    super.key,
    required this.onBack,
    required this.orderUpdates,
    required this.offers,
    required this.onOrderUpdatesChanged,
    required this.onOffersChanged,
    required this.onEditProfile,
    required this.onPrivacy,
    required this.onLogout,
  });

  final VoidCallback onBack;
  final bool orderUpdates;
  final bool offers;
  final ValueChanged<bool> onOrderUpdatesChanged;
  final ValueChanged<bool> onOffersChanged;
  final VoidCallback onEditProfile;
  final VoidCallback onPrivacy;

  /// Ends the session: the account flow confirms, calls the logout API and
  /// clears the cached token before the boot gate reveals the login screen.
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    return AccountSubPage(
      titleKey: AppLocaleKey.settingsTitle,
      onBack: onBack,
      children: [
        AccountPanel(
          children: [
            Text(
              AppLocaleKey.aliHelps.tr(),
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: AppColors.petrol,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              AppLocaleKey.changeAnytime.tr(),
              textAlign: TextAlign.right,
              style: const TextStyle(color: AppColors.muted),
            ),
            SwitchListTile(
              tileColor: Colors.white,
              contentPadding: EdgeInsets.zero,
              title: Text(AppLocaleKey.requestUpdates.tr()),
              subtitle: Text(
                orderUpdates ? AppLocaleKey.on.tr() : AppLocaleKey.off.tr(),
              ),
              value: orderUpdates,
              activeThumbColor: AppColors.orange,
              onChanged: onOrderUpdatesChanged,
            ),
            SwitchListTile(
              tileColor: Colors.white,
              contentPadding: EdgeInsets.zero,
              title: Text(AppLocaleKey.offersAndGifts.tr()),
              subtitle: Text(
                offers ? AppLocaleKey.on.tr() : AppLocaleKey.off.tr(),
              ),
              value: offers,
              activeThumbColor: AppColors.orange,
              onChanged: onOffersChanged,
            ),
          ],
        ),
        AccountPanel(
          children: [
            AccountActionButton(
              labelKey: AppLocaleKey.editProfile,
              icon: Icons.edit_outlined,
              onTap: onEditProfile,
            ),
            const SizedBox(height: 9),
            AccountActionButton(
              labelKey: AppLocaleKey.privacy,
              icon: Icons.shield_outlined,
              onTap: onPrivacy,
            ),
          ],
        ),
        const SizedBox(height: 12),
        AccountLogoutButton(onPressed: onLogout),
      ],
    );
  }
}
