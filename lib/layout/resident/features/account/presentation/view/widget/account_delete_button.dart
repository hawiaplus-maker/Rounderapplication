import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/core/theme/app_theme.dart';

/// Destructive account action on the settings page. It stays outlined (unlike
/// the filled sign-out button) so the irreversible deletion is visually
/// separate from the regular account actions.
class AccountDeleteButton extends StatelessWidget {
  const AccountDeleteButton({
    super.key,
    required this.onPressed,
    this.deleting = false,
  });

  final VoidCallback onPressed;

  /// Whether the deletion request is in flight: the leading icon becomes a
  /// spinner and the button ignores further taps.
  final bool deleting;

  @override
  Widget build(BuildContext context) => OutlinedButton.icon(
    onPressed: deleting ? null : onPressed,
    style: OutlinedButton.styleFrom(
      foregroundColor: AppColors.coral,
      disabledForegroundColor: AppColors.coral.withValues(alpha: .6),
      side: BorderSide(color: AppColors.coral.withValues(alpha: .5)),
      minimumSize: const Size.fromHeight(50),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    icon: deleting
        ? const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: AppColors.coral,
            ),
          )
        : const Icon(Icons.delete_forever_outlined, size: 20),
    label: Text(AppLocaleKey.deleteAccount.tr()),
  );
}
