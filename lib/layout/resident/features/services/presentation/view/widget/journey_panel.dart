import 'package:flutter/material.dart';
import 'package:rounder_application/core/theme/app_theme.dart';

/// Rounded content panel used across the service journey pages.
class JourneyPanel extends StatelessWidget {
  const JourneyPanel({super.key, required this.children, this.glass = false});

  final List<Widget> children;
  final bool glass;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 8, 20, 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: glass
            ? AppColors.white.withValues(alpha: .2)
            : AppColors.white.withValues(alpha: .94),
        border: glass
            ? Border.all(color: AppColors.white.withValues(alpha: .38))
            : null,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      ),
    );
  }
}
