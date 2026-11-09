import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/core/theme/app_text_styles.dart';
import 'package:rounder_application/core/theme/app_theme.dart';

/// Guest-mode gate shared by the resident tabs that need a signed-in account
/// (orders, account). The guest can keep browsing the public tabs; the action
/// returns them to the login screen.
class GuestGateView extends StatelessWidget {
  const GuestGateView({
    super.key,
    required this.titleKey,
    required this.bodyKey,
    required this.onSignIn,
    this.icon = Icons.lock_outline_rounded,
  });

  final String titleKey, bodyKey;
  final VoidCallback onSignIn;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 380),
          child: Material(
            color: AppColors.white.withValues(alpha: .95),
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Icon(icon, size: 48, color: AppColors.petrol),
                  const SizedBox(height: 16),
                  Text(
                    titleKey.tr(),
                    textAlign: TextAlign.center,
                    style: AppTextStyles.extraBold20.copyWith(
                      color: AppColors.petrol,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    bodyKey.tr(),
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.muted,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: onSignIn,
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.orange,
                      foregroundColor: AppColors.petrol,
                      minimumSize: const Size.fromHeight(50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(AppLocaleKey.signIn.tr()),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
