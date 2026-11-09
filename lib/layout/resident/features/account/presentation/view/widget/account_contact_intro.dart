import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rounder_application/core/theme/app_text_styles.dart';
import 'package:rounder_application/core/theme/app_theme.dart';

/// Large page title + supporting line shown on the account gradient header
/// area of the contact and contact-success pages.
class AccountContactIntro extends StatelessWidget {
  const AccountContactIntro({
    super.key,
    required this.titleKey,
    required this.subtitleKey,
  });

  final String titleKey;
  final String subtitleKey;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0, 6, 0, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            titleKey.tr(),
            textAlign: TextAlign.start,
            style: AppTextStyles.displayLarge.copyWith(color: AppColors.white),
          ),
          const SizedBox(height: 2),
          Text(
            subtitleKey.tr(),
            textAlign: TextAlign.start,
            style: AppTextStyles.bodyRegular15.copyWith(
              color: AppColors.mintDeep,
            ),
          ),
        ],
      ),
    );
  }
}
