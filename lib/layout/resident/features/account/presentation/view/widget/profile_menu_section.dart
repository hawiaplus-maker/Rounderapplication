import 'dart:ui' as ui_direction;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/core/theme/app_text_styles.dart';
import 'package:rounder_application/core/theme/app_theme.dart';
import 'package:rounder_application/layout/resident/features/account/presentation/view/widget/account_panel.dart';

/// Account details label and the 2×2 entries (settings, notifications,
/// privacy, help) of the account page.
class ProfileMenuSection extends StatelessWidget {
  const ProfileMenuSection({
    super.key,
    required this.onSettings,
    required this.onNotifications,
    required this.onPrivacy,
    required this.onHelp,
  });

  final VoidCallback onSettings, onNotifications, onPrivacy, onHelp;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(22, 12, 22, 5),
          child: Text(
            AppLocaleKey.accountDetails.tr(),
            textAlign: TextAlign.start,
            style: AppTextStyles.captionRegular13.copyWith(color: AppColors.muted),
          ),
        ),
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(22, 0, 22, 24),
          child: AccountPanel(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _MenuTile(
                      labelKey: AppLocaleKey.settings,
                      icon: Icons.tune,
                      onTap: onSettings,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _MenuTile(
                      labelKey: AppLocaleKey.notifications,
                      icon: Icons.notifications_none,
                      onTap: onNotifications,
                    ),
                  ),
                ],
              ),
              const Divider(height: 20),
              Row(
                children: [
                  Expanded(
                    child: _MenuTile(
                      labelKey: AppLocaleKey.privacy,
                      icon: Icons.verified_user_outlined,
                      onTap: onPrivacy,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _MenuTile(
                      labelKey: AppLocaleKey.help,
                      icon: Icons.headset_mic_outlined,
                      onTap: onHelp,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MenuTile extends StatelessWidget {
  const _MenuTile({required this.labelKey, required this.icon, required this.onTap});

  final String labelKey;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    // Deep-entry affordance: in RTL it points left, mirrored in LTR.
    final rtl = Directionality.of(context) == ui_direction.TextDirection.rtl;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 5),
        child: Row(
          children: [
            Icon(icon, color: AppColors.petrol, size: 21),
            const SizedBox(width: 7),
            Expanded(
              child: Text(
                labelKey.tr(),
                textAlign: TextAlign.end,
                style: AppTextStyles.captionSemiBold13.copyWith(color: AppColors.petrol),
              ),
            ),
            const SizedBox(width: 7),
            Icon(rtl ? Icons.circle : Icons.chevron_left, color: AppColors.muted, size: 8),
          ],
        ),
      ),
    );
  }
}
