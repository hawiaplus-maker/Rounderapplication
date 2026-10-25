import 'dart:ui' as ui_direction show TextDirection;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/core/theme/app_theme.dart';
import 'package:rounder_application/layout/resident/features/onboarding/presentation/view/model/welcome_gift_option.dart';

/// Welcome-gift selection list.
class WelcomeGiftsView extends StatelessWidget {
  const WelcomeGiftsView({
    super.key,
    required this.selectedGiftKey,
    required this.onSelect,
    required this.onBack,
  });

  final String? selectedGiftKey;
  final ValueChanged<WelcomeGiftOption> onSelect;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final rtl = Directionality.of(context) == ui_direction.TextDirection.rtl;
    return ListView(
      key: const ValueKey('welcome-gifts'),
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
      children: [
        Text(
          AppLocaleKey.chooseWelcomeGiftTitle.tr(),
          style: const TextStyle(
            color: AppColors.white,
            fontSize: 26,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          AppLocaleKey.chooseWelcomeGiftBody.tr(),
          style: const TextStyle(color: AppColors.white, height: 1.5),
        ),
        const SizedBox(height: 20),
        for (final option in welcomeGiftOptions)
          _GiftCard(
            option: option,
            selected: selectedGiftKey == option.titleKey,
            onTap: () => onSelect(option),
          ),
        TextButton.icon(
          onPressed: onBack,
          icon: Transform.flip(
            flipX: rtl,
            child: const Icon(Icons.arrow_forward),
          ),
          label: Text(AppLocaleKey.back.tr()),
        ),
      ],
    );
  }
}

class _GiftCard extends StatelessWidget {
  const _GiftCard({
    required this.option,
    required this.selected,
    required this.onTap,
  });

  final WelcomeGiftOption option;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final rtl = Directionality.of(context) == ui_direction.TextDirection.rtl;
    return Card(
      color: selected ? AppColors.mint : AppColors.white.withValues(alpha: .96),
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: selected ? AppColors.coral : Colors.transparent,
          width: 2,
        ),
      ),
      child: ListTile(
        tileColor: selected ? AppColors.mint : AppColors.white,
        onTap: onTap,
        contentPadding: const EdgeInsets.all(14),
        leading: CircleAvatar(
          backgroundColor: AppColors.mint,
          child: Icon(option.icon, color: AppColors.petrol),
        ),
        title: Text(
          option.titleKey.tr(),
          style: const TextStyle(
            fontWeight: FontWeight.w800,
            color: AppColors.petrol,
          ),
        ),
        subtitle: Text(
          option.descriptionKey.tr(),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Icon(
          rtl ? Icons.chevron_left : Icons.chevron_right,
          color: AppColors.petrol,
        ),
      ),
    );
  }
}
