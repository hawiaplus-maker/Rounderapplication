import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/core/theme/app_text_styles.dart';
import 'package:rounder_application/core/theme/app_theme.dart';

/// Confirms closing the app from the resident home tab. Returns true only when
/// the resident explicitly chooses to exit — staying in the app is the primary
/// (safe) action, same as the sign-out dialog.
Future<bool> confirmExitApp(BuildContext context) async =>
    await showDialog<bool>(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: AppColors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 350),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  AppLocaleKey.exitAppTitle.tr(),
                  style: AppTextStyles.bodyBold21.copyWith(
                    color: AppColors.petrol,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  AppLocaleKey.exitAppConfirm.tr(),
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.teal,
                  ),
                ),
                const SizedBox(height: 28),
                FilledButton(
                  onPressed: () => Navigator.pop(context, false),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.orange,
                    foregroundColor: AppColors.petrol,
                    minimumSize: const Size.fromHeight(48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(AppLocaleKey.stayInApp.tr()),
                ),
                const SizedBox(height: 12),
                FilledButton.tonal(
                  onPressed: () => Navigator.pop(context, true),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.coral,
                    foregroundColor: AppColors.white,
                    minimumSize: const Size.fromHeight(48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(AppLocaleKey.exitApp.tr()),
                ),
              ],
            ),
          ),
        ),
      ),
    ) ??
    false;
