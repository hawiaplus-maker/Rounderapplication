import 'dart:ui' as ui_direction show TextDirection;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/core/theme/app_theme.dart';

/// Read-only display of the phone being registered (`validate-mobile`'s
/// formatted `+966…` value). Handles are LTR data even inside the Arabic
/// layout, so the country code's "+" never reorders.
class RegisterPhoneSummary extends StatelessWidget {
  const RegisterPhoneSummary({super.key, required this.formattedMobile});
  final String formattedMobile;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocaleKey.phone.tr(),
          textAlign: TextAlign.start,
          style: const TextStyle(
            color: AppColors.petrol,
            fontSize: 16,
            height: 24 / 16,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          formattedMobile,
          // Phone data stays LTR inside the Arabic layout; otherwise the
          // leading "+" reorders to the end.
          textDirection: ui_direction.TextDirection.ltr,
          textAlign: TextAlign.start,
          style: const TextStyle(
            color: AppColors.petrol,
            fontSize: 17,
            height: 26 / 17,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
