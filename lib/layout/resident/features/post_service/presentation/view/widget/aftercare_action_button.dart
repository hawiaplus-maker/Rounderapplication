import 'package:flutter/material.dart';
import 'package:rounder_application/core/theme/app_theme.dart';

/// Full-width action of the after-service journey pages.
class AftercareActionButton extends StatelessWidget {
  const AftercareActionButton({
    super.key,
    required this.label,
    required this.fill,
    required this.onPressed,
  });

  final String label;
  final Color fill;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: fill,
        foregroundColor: AppColors.petrol,
        minimumSize: const Size.fromHeight(48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      child: Text(
        label,
        textAlign: TextAlign.center,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          color: AppColors.petrol,
          fontSize: 14,
          height: 22 / 14,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
