import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/core/theme/app_theme.dart';
import 'package:rounder_application/layout/resident/features/account/presentation/view/widget/account_header.dart';
import 'package:rounder_application/layout/resident/features/account/presentation/view/widget/account_panel.dart';

/// Account profile page: identity, linked units, gifts and account entries.
class AccountProfilePage extends StatelessWidget {
  const AccountProfilePage({
    super.key,
    required this.name,
    required this.homeName,
    required this.onEdit,
    required this.onGifts,
    required this.onUnits,
    required this.onManageHomes,
    required this.onSettings,
    required this.onNotifications,
    required this.onPrivacy,
    required this.onHelp,
  });

  final String name;
  final String homeName;
  final VoidCallback onEdit;
  final VoidCallback onGifts;
  final VoidCallback onUnits;
  final VoidCallback onManageHomes;
  final VoidCallback onSettings;
  final VoidCallback onNotifications;
  final VoidCallback onPrivacy;
  final VoidCallback onHelp;

  @override
  Widget build(BuildContext context) {
    return ListView(
      key: const ValueKey('account-profile'),
      padding: EdgeInsets.zero,
      children: [
        const AccountHeader(titleKey: AppLocaleKey.profile),
        Padding(
          padding: const EdgeInsets.fromLTRB(22, 12, 22, 20),
          child: Row(
            children: [
              CircleAvatar(
                radius: 42,
                backgroundColor: Colors.white24,
                child: Text(
                  name.isEmpty
                      ? AppLocaleKey.resident.tr().substring(0, 1)
                      : name.substring(0, 1),
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 29,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      name.isEmpty ? AppLocaleKey.resident.tr() : name,
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      AppLocaleKey.profileSubtitle.tr(),
                      style: const TextStyle(color: Colors.white70),
                    ),
                    TextButton.icon(
                      onPressed: onEdit,
                      icon: const Icon(
                        Icons.edit_outlined,
                        size: 17,
                        color: AppColors.white,
                      ),
                      label: Text(
                        AppLocaleKey.editProfile.tr(),
                        style: const TextStyle(color: AppColors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        AccountPanel(
          children: [
            Row(
              children: [
                const Icon(
                  Icons.apartment_rounded,
                  color: AppColors.orange,
                  size: 25,
                ),
                const Spacer(),
                Text(
                  AppLocaleKey.units.tr(),
                  style: const TextStyle(
                    color: AppColors.petrol,
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              AppLocaleKey.unitCount.tr(),
              style: const TextStyle(
                color: AppColors.petrol,
                fontSize: 27,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              AppLocaleKey.linkedHomes.tr(),
              style: const TextStyle(color: AppColors.muted),
            ),
            const Divider(height: 24),
            Row(
              children: [
                FilledButton(
                  onPressed: onManageHomes,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.orange,
                    foregroundColor: AppColors.white,
                  ),
                  child: Text(AppLocaleKey.manage.tr()),
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      homeName.isEmpty
                          ? AppLocaleKey.unitTitle.tr()
                          : homeName,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: AppColors.petrol,
                      ),
                    ),
                    Text(
                      '${AppLocaleKey.currentUnit.tr()} • ${AppLocaleKey.flatNumber.tr()}',
                      style: const TextStyle(
                        color: AppColors.muted,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              AppLocaleKey.linkedHomesNote.tr(),
              style: const TextStyle(color: AppColors.muted, fontSize: 11),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(22, 12, 22, 8),
          child: InkWell(
            onTap: onGifts,
            borderRadius: BorderRadius.circular(18),
            child: _EntryCard(
              titleKey: AppLocaleKey.gifts,
              subtitleKey: AppLocaleKey.discoverGifts,
              icon: Icons.card_giftcard_outlined,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(22, 12, 22, 8),
          child: InkWell(
            onTap: onUnits,
            borderRadius: BorderRadius.circular(18),
            child: _EntryCard(
              titleKey: AppLocaleKey.units,
              subtitleKey: AppLocaleKey.unitsSubtitle,
              icon: Icons.apartment_rounded,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(22, 12, 22, 5),
          child: Text(
            AppLocaleKey.accountDetails.tr(),
            textAlign: TextAlign.right,
            style: const TextStyle(color: AppColors.muted, fontSize: 13),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(22, 0, 22, 24),
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

class _EntryCard extends StatelessWidget {
  const _EntryCard({
    required this.titleKey,
    required this.subtitleKey,
    required this.icon,
  });

  final String titleKey;
  final String subtitleKey;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white24,
        border: Border.all(color: Colors.white70),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          const Icon(Icons.chevron_left, color: AppColors.petrol),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  titleKey.tr(),
                  style: const TextStyle(
                    color: AppColors.petrol,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  subtitleKey.tr(),
                  style: const TextStyle(
                    color: AppColors.muted,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Icon(icon, color: AppColors.petrol, size: 27),
        ],
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  const _MenuTile({
    required this.labelKey,
    required this.icon,
    required this.onTap,
  });

  final String labelKey;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => InkWell(
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
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: AppColors.petrol,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const Icon(Icons.chevron_left, color: AppColors.muted, size: 17),
        ],
      ),
    ),
  );
}
