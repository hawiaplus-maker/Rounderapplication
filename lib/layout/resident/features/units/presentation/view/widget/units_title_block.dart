import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/core/theme/app_theme.dart';

/// Page title of the units journey: the large white "وحداتي" heading with its
/// supporting subtitle on the brand gradient.
class UnitsTitleBlock extends StatelessWidget {
  const UnitsTitleBlock({super.key});

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Text(
        AppLocaleKey.units.tr(),
        textAlign: TextAlign.start,
        style: const TextStyle(
          color: AppColors.white,
          fontSize: 34,
          height: 48 / 34,
          fontWeight: FontWeight.w700,
        ),
      ),
      const SizedBox(height: 4),
      Text(
        AppLocaleKey.unitsSubtitle.tr(),
        textAlign: TextAlign.start,
        style: TextStyle(
          color: AppColors.white.withValues(alpha: .8),
          fontSize: 14,
          height: 22 / 14,
        ),
      ),
    ],
  );
}
