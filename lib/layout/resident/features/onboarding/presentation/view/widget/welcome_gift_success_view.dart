import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/core/theme/app_theme.dart';

/// Completion state of the welcome-gift selection.
class WelcomeGiftSuccessView extends StatelessWidget {
  const WelcomeGiftSuccessView({
    super.key,
    required this.giftTitle,
    required this.onClose,
  });

  final String giftTitle;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) => Center(
    key: const ValueKey('welcome-gift-success'),
    child: Padding(
      padding: const EdgeInsets.all(26),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircleAvatar(
            radius: 48,
            backgroundColor: AppColors.mint,
            child: Icon(
              Icons.card_giftcard,
              color: AppColors.petrol,
              size: 42,
            ),
          ),
          const SizedBox(height: 18),
          Text(
            AppLocaleKey.giftSaved.tr(),
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.white,
              fontSize: 24,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            giftTitle,
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.white),
          ),
          const SizedBox(height: 22),
          FilledButton(
            onPressed: onClose,
            child: Text(AppLocaleKey.close.tr()),
          ),
        ],
      ),
    ),
  );
}
