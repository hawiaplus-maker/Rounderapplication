import 'dart:ui' as ui_direction show TextDirection;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rounder_application/core/theme/app_text_styles.dart';
import 'package:rounder_application/core/theme/app_theme.dart';

/// Page title bar of the after-service journey screens.
class AftercareHeader extends StatelessWidget {
  const AftercareHeader({super.key, required this.titleKey, required this.onBack});

  final String titleKey;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            titleKey.tr(),
            textAlign: TextAlign.start,
            style: AppTextStyles.headingBold23.copyWith(color: AppColors.white),
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
            child: const _BackChevron(),
          ),
        ),
      ],
    );
  }
}

class _BackChevron extends StatelessWidget {
  const _BackChevron();

  @override
  Widget build(BuildContext context) {
    final rtl = Directionality.of(context) == ui_direction.TextDirection.rtl;
    return Icon(
      rtl ? Icons.arrow_back_ios_new : Icons.arrow_back_ios_new,
      size: 22,
      color: AppColors.white,
    );
  }
}
