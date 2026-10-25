import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rounder_application/core/theme/app_theme.dart';

/// Tonal action row of the account pages.
class AccountActionButton extends StatelessWidget {
  const AccountActionButton({
    super.key,
    required this.labelKey,
    required this.icon,
    required this.onTap,
  });

  final String labelKey;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return FilledButton.tonalIcon(
      onPressed: onTap,
      icon: Icon(icon, size: 19),
      label: Text(labelKey.tr()),
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.mint,
        foregroundColor: AppColors.petrol,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }
}
