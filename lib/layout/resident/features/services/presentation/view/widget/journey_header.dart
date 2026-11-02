import 'dart:ui' as ui_direction;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rounder_application/core/theme/app_text_styles.dart';
import 'package:rounder_application/core/theme/app_theme.dart';

/// Title bar shared by all service journey pages.
class JourneyHeader extends StatelessWidget {
  const JourneyHeader({super.key, required this.titleKey, this.onBack, this.backButton = true})
    : assert(!backButton || onBack != null);

  final String titleKey;
  final VoidCallback? onBack;
  final bool backButton;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 12),
      child: Row(
        children: [
          if (backButton)
            IconButton(
              onPressed: onBack,
              icon: Icon(
                Directionality.of(context) == ui_direction.TextDirection.rtl
                    ? Icons.arrow_back_ios_new
                    : Icons.arrow_back_ios_new,
                color: AppColors.white,
              ),
            )
          else
            const SizedBox(width: 8),
          const Spacer(),
          Text(titleKey.tr(), style: AppTextStyles.extraBold21.copyWith(color: AppColors.white)),
          const SizedBox(width: 8),
          if (!backButton) const Icon(Icons.home_repair_service_outlined, color: AppColors.white),
        ],
      ),
    );
  }
}
