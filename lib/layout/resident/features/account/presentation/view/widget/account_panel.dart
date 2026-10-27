import 'package:flutter/material.dart';
import 'package:rounder_application/core/theme/app_theme.dart';

/// Rounded content panel used across the account pages.
class AccountPanel extends StatelessWidget {
  const AccountPanel({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    // A Material (not a decorated Container) so the ListTiles/SwitchListTiles
    // it hosts paint their tile color and ink splashes on this panel instead
    // of the ancestor Scaffold's Material, which the background would hide.
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
      child: Material(
        color: AppColors.white.withValues(alpha: .93),
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: children,
          ),
        ),
      ),
    );
  }
}
