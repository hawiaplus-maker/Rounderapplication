import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/core/theme/app_theme.dart';

/// Primary action of the property rating screen: jump to facilities reports.
class PropertyRatingFacilitiesButton extends StatelessWidget {
  const PropertyRatingFacilitiesButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.coral,
        foregroundColor: AppColors.petrol,
        minimumSize: const Size.fromHeight(48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      child: Text(
        AppLocaleKey.toFacilitiesReports.tr(),
        textAlign: TextAlign.center,
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
