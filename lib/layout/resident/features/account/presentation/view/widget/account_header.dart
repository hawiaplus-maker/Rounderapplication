import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rounder_application/core/images/app_images.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/core/theme/app_theme.dart';

/// Title bar shared by all account pages.
class AccountHeader extends StatelessWidget {
  const AccountHeader({
    super.key,
    required this.titleKey,
    this.onBack,
    this.showBack = false,
  }) : assert(!showBack || onBack != null);

  final String titleKey;
  final VoidCallback? onBack;
  final bool showBack;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 16, 22, 12),
      child: Row(
        children: [
          if (showBack)
            TextButton.icon(
              onPressed: onBack,
              icon: const Icon(Icons.chevron_left, color: AppColors.white),
              label: Text(
                AppLocaleKey.back.tr(),
                style: const TextStyle(color: AppColors.white),
              ),
            )
          else
            Text(
              titleKey.tr(),
              style: const TextStyle(
                color: AppColors.white,
                fontSize: 17,
                fontWeight: FontWeight.w700,
              ),
            ),
          const Spacer(),
          Image.asset(
            AppImages.rounderLogo,
            height: 28,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }
}
