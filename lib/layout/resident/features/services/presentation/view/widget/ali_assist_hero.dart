import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:rounder_application/core/images/app_images.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/core/theme/app_text_styles.dart';
import 'package:rounder_application/core/theme/app_theme.dart';

/// Header of the Ali assist page (Figma 382:448): the "attentive listening"
/// artwork facing the conversation title ("نفهم المشكلة سوا") and its intro
/// copy. Title on the directional start, artwork hugging the end.
class AliAssistHero extends StatelessWidget {
  const AliAssistHero({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                AppLocaleKey.aliProblemTitle.tr(),
                textAlign: TextAlign.start,
                style: AppTextStyles.headingBold22.copyWith(color: AppColors.white),
              ),
              const SizedBox(height: 8),
              Text(
                AppLocaleKey.aliProblemIntro.tr(),
                textAlign: TextAlign.start,
                maxLines: 2,
                style: AppTextStyles.bodySmall.copyWith(color: AppColors.white),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Image.asset(
          AppImages.aliSeat,
          width: 112,
          height: 140,
          fit: BoxFit.contain,
          filterQuality: FilterQuality.medium,
        ),
      ],
    );
  }
}