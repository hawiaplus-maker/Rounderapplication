import 'package:flutter/material.dart';
import 'package:rounder_application/core/theme/app_theme.dart';

/// Rounded content panel used across the association pages.
class UnionPanel extends StatelessWidget {
  const UnionPanel({super.key, required this.children, this.glass = false});

  final List<Widget> children;
  final bool glass;

  @override
  Widget build(BuildContext context) {
    // A Material (not a decorated Container) so the ListTiles it hosts paint
    // their tile color and ink splashes on this panel instead of the ancestor
    // Scaffold's Material, which the panel's background would hide.
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
      child: Material(
        color: glass
            ? AppColors.white.withValues(alpha: .2)
            : AppColors.white.withValues(alpha: .93),
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
          side: glass
              ? BorderSide(color: AppColors.white.withValues(alpha: .38))
              : BorderSide.none,
        ),
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
