import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/core/theme/app_theme.dart';

/// "Linked homes" emblem shown above the unit cards (design 536:943).
class UnitsEmblem extends StatelessWidget {
  const UnitsEmblem({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.white.withValues(alpha: .15),
            border: Border.all(
              color: AppColors.white.withValues(alpha: .35),
              width: .8,
            ),
          ),
          alignment: Alignment.center,
          child: const Icon(
            Icons.apartment_rounded,
            size: 24,
            color: AppColors.white,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            AppLocaleKey.linkedHomes.tr(),
            textAlign: TextAlign.start,
            style: TextStyle(
              color: AppColors.white.withValues(alpha: .85),
              fontSize: 14,
              height: 22 / 14,
            ),
          ),
        ),
      ],
    );
  }
}
