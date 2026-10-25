import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rounder_application/core/theme/app_theme.dart';

/// Tonal action row of the service journey pages.
class JourneyActionButton extends StatelessWidget {
  const JourneyActionButton({
    super.key,
    required this.labelKey,
    required this.icon,
    required this.onAction,
  });

  final String labelKey;
  final IconData icon;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
    child: FilledButton.tonalIcon(
      onPressed: onAction,
      icon: Icon(icon),
      label: Text(labelKey.tr()),
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.mint,
        foregroundColor: AppColors.petrol,
        alignment: Alignment.centerRight,
      ),
    ),
  );
}
