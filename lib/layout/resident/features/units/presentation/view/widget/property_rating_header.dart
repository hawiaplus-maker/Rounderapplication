import 'dart:ui' as ui_direction show TextDirection;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/core/theme/app_theme.dart';

/// Page title bar of the property rating screen (design 536:949).
class PropertyRatingHeader extends StatelessWidget {
  const PropertyRatingHeader({super.key, required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            AppLocaleKey.propertyRating.tr(),
            textAlign: TextAlign.start,
            style: const TextStyle(
              color: AppColors.white,
              fontSize: 23,
              height: 34 / 23,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        GestureDetector(
          onTap: onBack,
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.white.withValues(alpha: .15),
            ),
            alignment: Alignment.center,
            child: _BackChevron(),
          ),
        ),
      ],
    );
  }
}

class _BackChevron extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final rtl = Directionality.of(context) == ui_direction.TextDirection.rtl;
    return Icon(
      rtl ? Icons.chevron_right : Icons.chevron_left,
      size: 22,
      color: AppColors.white,
    );
  }
}
