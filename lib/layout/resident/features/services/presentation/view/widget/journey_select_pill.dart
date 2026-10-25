import 'package:flutter/material.dart';
import 'package:rounder_application/core/theme/app_theme.dart';

/// Selectable outlined pill of the schedule/follow-up pages.
class JourneySelectPill extends StatelessWidget {
  const JourneySelectPill({
    super.key,
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(
        selected ? Icons.check_circle : icon,
        color: AppColors.petrol,
      ),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.petrol,
        alignment: Alignment.centerRight,
        side: const BorderSide(color: AppColors.mint),
      ),
    ),
  );
}
