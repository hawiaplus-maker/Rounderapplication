import 'dart:ui' as ui_direction;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rounder_application/core/theme/app_text_styles.dart';
import 'package:rounder_application/core/theme/app_theme.dart';

/// Wide glass entry of the account page (gifts / units).
class ProfileEntryCard extends StatelessWidget {
  const ProfileEntryCard({
    super.key,
    required this.titleKey,
    required this.subtitleKey,
    required this.icon,
    required this.onTap,
  });

  final String titleKey, subtitleKey;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(22, 12, 22, 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.white.withValues(alpha: .15),
            border: Border.all(color: AppColors.white.withValues(alpha: .7)),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Row(
            children: [
              Icon(
                Directionality.of(context) == ui_direction.TextDirection.rtl
                    ? Icons.arrow_back_ios_new
                    : Icons.arrow_back_ios_new,
                color: AppColors.petrol,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      titleKey.tr(),
                      textAlign: TextAlign.end,
                      style: AppTextStyles.extraBold16.copyWith(
                        color: AppColors.petrol,
                      ),
                    ),
                    Text(
                      subtitleKey.tr(),
                      textAlign: TextAlign.end,
                      style: AppTextStyles.captionRegular.copyWith(color: AppColors.muted),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Icon(icon, color: AppColors.petrol, size: 27),
            ],
          ),
        ),
      ),
    );
  }
}
