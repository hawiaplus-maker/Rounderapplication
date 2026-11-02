import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/core/theme/app_text_styles.dart';
import 'package:rounder_application/core/theme/app_theme.dart';

/// Approved guest action (design `Login / Guest`): mint pill, radius 16,
/// 44px minimum height — "browse now, register later".
class LoginGuestAction extends StatelessWidget {
  const LoginGuestAction({super.key, required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.mintLight,
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          constraints: const BoxConstraints(minHeight: 44),
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
          child: Text(
            AppLocaleKey.browseNowRegisterLater.tr(),
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyBold14.copyWith(color: AppColors.petrol),
          ),
        ),
      ),
    );
  }
}
