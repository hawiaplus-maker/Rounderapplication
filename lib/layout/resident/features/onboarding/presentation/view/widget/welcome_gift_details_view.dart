import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/core/theme/app_theme.dart';
import 'package:rounder_application/layout/resident/features/onboarding/presentation/view/model/welcome_gift_option.dart';

/// Details of the chosen welcome gift.
class WelcomeGiftDetailsView extends StatelessWidget {
  const WelcomeGiftDetailsView({
    super.key,
    required this.option,
    required this.onSelectGift,
    required this.onBack,
  });

  final WelcomeGiftOption option;
  final VoidCallback onSelectGift;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return ListView(
      key: const ValueKey('welcome-gift-detail'),
      padding: const EdgeInsets.fromLTRB(20, 26, 20, 30),
      children: [
        CircleAvatar(
          radius: 46,
          backgroundColor: AppColors.mint,
          child: Icon(option.icon, color: AppColors.petrol, size: 42),
        ),
        const SizedBox(height: 24),
        Text(
          AppLocaleKey.giftDetails.tr(),
          style: const TextStyle(
            color: AppColors.white,
            fontSize: 26,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 10),
        Card(
          color: AppColors.white.withValues(alpha: .96),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  option.titleKey.tr(),
                  style: const TextStyle(
                    color: AppColors.petrol,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  option.descriptionKey.tr(),
                  style: const TextStyle(height: 1.7),
                ),
                const SizedBox(height: 20),
                Text(
                  AppLocaleKey.giftTerms.tr(),
                  style: const TextStyle(color: AppColors.muted),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        FilledButton(
          onPressed: onSelectGift,
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.coral,
            foregroundColor: AppColors.petrol,
            minimumSize: const Size.fromHeight(56),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: Text(AppLocaleKey.selectGift.tr()),
        ),
        TextButton(
          onPressed: onBack,
          child: Text(
            AppLocaleKey.back.tr(),
            style: const TextStyle(color: AppColors.petrol),
          ),
        ),
      ],
    );
  }
}
