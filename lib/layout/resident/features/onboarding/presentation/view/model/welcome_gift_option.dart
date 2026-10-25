import 'package:flutter/material.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';

/// One selectable welcome gift of the onboarding flow.
class WelcomeGiftOption {
  const WelcomeGiftOption({
    required this.titleKey,
    required this.descriptionKey,
    required this.icon,
  });

  final String titleKey;
  final String descriptionKey;
  final IconData icon;
}

const welcomeGiftOptions = <WelcomeGiftOption>[
  WelcomeGiftOption(
    titleKey: AppLocaleKey.giftHomeCare,
    descriptionKey: AppLocaleKey.giftHomeCareDesc,
    icon: Icons.home_repair_service_outlined,
  ),
  WelcomeGiftOption(
    titleKey: AppLocaleKey.giftServiceCredit,
    descriptionKey: AppLocaleKey.giftCreditDesc,
    icon: Icons.card_giftcard_outlined,
  ),
  WelcomeGiftOption(
    titleKey: AppLocaleKey.giftCleaning,
    descriptionKey: AppLocaleKey.giftCleaningDesc,
    icon: Icons.cleaning_services_outlined,
  ),
];
