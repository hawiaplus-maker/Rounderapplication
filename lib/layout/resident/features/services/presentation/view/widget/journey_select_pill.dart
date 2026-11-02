import 'package:flutter/material.dart';
import 'package:rounder_application/core/theme/app_text_styles.dart';
import 'package:rounder_application/core/theme/app_theme.dart';

/// Selectable outlined pill of the schedule/follow-up pages.
class JourneySelectPill extends StatelessWidget {
  const JourneySelectPill({
    super.key,
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
    this.subtitle,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;
  final String? subtitle;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.petrol,
        alignment: AlignmentDirectional.centerStart,
        side: const BorderSide(color: AppColors.mint),
      ),
      child: Row(
        children: <Widget>[
          Icon(
            selected ? Icons.check_circle : icon,
            color: AppColors.petrol,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(label),
                if (subtitle != null && subtitle!.trim().isNotEmpty)
                  Text(
                    subtitle!,
                    style: AppTextStyles.tinyRegular.copyWith(color: AppColors.muted),
                  ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
