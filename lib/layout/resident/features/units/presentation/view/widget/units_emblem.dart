import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/core/theme/app_text_styles.dart';
import 'package:rounder_application/core/theme/app_theme.dart';
import 'package:rounder_application/logic/number_text_logic.dart';

/// "Linked homes" emblem shown above the unit cards (design 536:943): the
/// apartment badge and the linked count in the locale's plural form.
class UnitsEmblem extends StatelessWidget {
  const UnitsEmblem({super.key, required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final String language = Localizations.localeOf(context).languageCode;
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
            AppLocaleKey.linkedUnitsCount.plural(
              count,
              namedArgs: {'count': localizedNumber(count, language)},
            ),
            textAlign: TextAlign.start,
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.white.withValues(alpha: .85)),
          ),
        ),
      ],
    );
  }
}
