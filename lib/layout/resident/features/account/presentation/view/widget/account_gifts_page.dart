import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/core/theme/app_theme.dart';
import 'package:rounder_application/layout/resident/features/account/presentation/view/widget/account_panel.dart';
import 'package:rounder_application/layout/resident/features/account/presentation/view/widget/account_sub_page.dart';

/// Welcome-gift page of the account.
class AccountGiftsPage extends StatelessWidget {
  const AccountGiftsPage({
    super.key,
    required this.onBack,
    required this.onDiscoverGifts,
  });

  final VoidCallback onBack;
  final VoidCallback onDiscoverGifts;

  static const _gifts = <(String, String, IconData)>[
    (
      AppLocaleKey.giftHomeCare,
      AppLocaleKey.giftHomeCareDesc,
      Icons.home_repair_service_outlined,
    ),
    (
      AppLocaleKey.giftServiceCredit,
      AppLocaleKey.giftCreditDesc,
      Icons.account_balance_wallet_outlined,
    ),
    (
      AppLocaleKey.giftCleaning,
      AppLocaleKey.giftCleaningDesc,
      Icons.cleaning_services_outlined,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return AccountSubPage(
      titleKey: AppLocaleKey.gifts,
      onBack: onBack,
      children: [
        AccountPanel(
          children: [
            const Icon(
              Icons.card_giftcard_rounded,
              size: 44,
              color: AppColors.orange,
            ),
            const SizedBox(height: 12),
            Text(
              AppLocaleKey.chooseWelcomeGiftTitle.tr(),
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: AppColors.petrol,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              AppLocaleKey.chooseWelcomeGiftBody.tr(),
              textAlign: TextAlign.right,
              style: const TextStyle(color: AppColors.muted, height: 1.6),
            ),
            const SizedBox(height: 14),
            FilledButton.icon(
              onPressed: onDiscoverGifts,
              icon: const Icon(Icons.redeem_outlined),
              label: Text(AppLocaleKey.discoverGifts.tr()),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.orange,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
        for (final gift in _gifts)
          AccountPanel(
            children: [
              Row(
                children: [
                  Icon(gift.$3, color: AppColors.orange),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      gift.$1.tr(),
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                        color: AppColors.petrol,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                gift.$2.tr(),
                textAlign: TextAlign.right,
                style: const TextStyle(color: AppColors.muted),
              ),
            ],
          ),
      ],
    );
  }
}
