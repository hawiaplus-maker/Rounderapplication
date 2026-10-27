import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/core/theme/app_theme.dart';

/// Session-ending action shared by the account profile and settings pages.
/// The flow owns the confirmation dialog, the logout API and the auth state.
class AccountLogoutButton extends StatelessWidget {
  const AccountLogoutButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => FilledButton.tonalIcon(
    onPressed: onPressed,
    style: FilledButton.styleFrom(
      backgroundColor: AppColors.coral.withValues(alpha: .14),
      foregroundColor: AppColors.coral,
      minimumSize: const Size.fromHeight(50),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    icon: const Icon(Icons.logout_rounded, size: 20),
    label: Text(AppLocaleKey.signOut.tr()),
  );
}
