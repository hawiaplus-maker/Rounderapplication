import 'package:flutter/material.dart';
import 'package:rounder_application/core/theme/app_theme.dart';

/// The units screens' empty journey (design: پیش from حوار same screen):
/// a welcoming glass card that invites linking the first home plus the
/// add-unit action. All copy arrives translated; heights hug their content.
class UnitsEmptyState extends StatelessWidget {
  const UnitsEmptyState({
    super.key,
    required this.title,
    required this.body,
    required this.hint,
    required this.actionLabel,
    required this.onAction,
  });

  final String title;
  final String body;
  final String hint;
  final String actionLabel;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: .92),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            textAlign: TextAlign.start,
            style: const TextStyle(
              color: AppColors.petrol,
              fontSize: 20,
              height: 30 / 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            body,
            textAlign: TextAlign.start,
            style: const TextStyle(
              color: AppColors.teal,
              fontSize: 15,
              height: 26 / 15,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            hint,
            textAlign: TextAlign.start,
            style: const TextStyle(
              color: AppColors.muted,
              fontSize: 12,
              height: 20 / 12,
            ),
          ),
          const SizedBox(height: 18),
          FilledButton(
            onPressed: onAction,
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.coral,
              foregroundColor: AppColors.petrol,
              minimumSize: const Size.fromHeight(48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Text(
              actionLabel,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.petrol,
                fontSize: 14,
                height: 22 / 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
