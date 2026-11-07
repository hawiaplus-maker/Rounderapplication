import 'package:flutter/material.dart';

import 'package:rounder_application/core/theme/app_text_styles.dart';
import 'package:rounder_application/core/theme/app_theme.dart';

/// Cairo type scale of the resident home frame (Figma 108:44).
///
/// The values are ported from the approved home prototype so the dashboard
/// keeps the same sizes, weights and line heights as the design.
abstract final class HomeTextStyles {
  static const String fontFamily = 'Cairo';

  // Brand + context.
  static final TextStyle weather = AppTextStyles.bodySemiBold11.copyWith(height: 1.2, color: AppColors.white);
  static final TextStyle city = AppTextStyles.bodySemiBold12.copyWith(height: 1.2, color: AppColors.white);

  // Hero.
  static final TextStyle greeting = AppTextStyles.bodySmall.copyWith(height: 1.5, color: AppColors.white);
  static final TextStyle heroName = AppTextStyles.headingBold31.copyWith(height: 44 / 31, color: AppColors.white);
  static final TextStyle heroQuestion = AppTextStyles.captionRegular.copyWith(height: 1.5, color: AppColors.white);
  static final TextStyle talkPill = AppTextStyles.bodyBold14.copyWith(height: 1.4, color: AppColors.white);

  // Emergency bar.
  static final TextStyle emergencyHint = AppTextStyles.bodySemiBold11.copyWith(height: 1.3, color: AppColors.white);
  static final TextStyle emergencyAction = AppTextStyles.bodyBold14.copyWith(height: 1.3, color: AppColors.white);

  // Dashboard heading.
  static final TextStyle dashboardTitle = AppTextStyles.headingH2.copyWith(height: 1.4, color: AppColors.white);
  static final TextStyle dashboardMeta = AppTextStyles.captionRegular.copyWith(height: 1.4, color: AppColors.white);

  // Unit selector — two-line column, 20px lines, like Figma 148:48.
  static final TextStyle unitTitle = AppTextStyles.captionBold13.copyWith(height: 20 / 13, color: AppColors.petrol);
  static final TextStyle unitSubtitle = AppTextStyles.captionRegular.copyWith(height: 20 / 12, color: AppColors.teal);

  // Cards.
  static final TextStyle cardTitle = AppTextStyles.captionBold13.copyWith(height: 1.5, color: AppColors.petrol);
  static final TextStyle cardTitleLarge = AppTextStyles.bodyBold14.copyWith(height: 1.45, color: AppColors.petrol);
  static final TextStyle balanceAmount = AppTextStyles.headingBold31.copyWith(height: 1.25, color: AppColors.white);
  static final TextStyle balanceCaption = AppTextStyles.captionRegular.copyWith(height: 1.5, color: AppColors.white);
  static final TextStyle balancePeriod = AppTextStyles.tinyRegular.copyWith(height: 1.5, color: AppColors.white);
  static final TextStyle healthScore = AppTextStyles.displayLarge.copyWith(height: 1.1, color: AppColors.petrol);
  static final TextStyle healthCaption = AppTextStyles.tinyRegular.copyWith(height: 1.4, color: AppColors.teal);
  static final TextStyle healthLabel = AppTextStyles.tinyRegular.copyWith(height: 1.4, color: AppColors.petrol);
  static final TextStyle healthValue = AppTextStyles.bodySemiBold11.copyWith(height: 1.4, color: AppColors.teal);

  // Visits.
  static final TextStyle sectionTitle = AppTextStyles.headingH3.copyWith(height: 1.35, color: AppColors.petrol);
  static final TextStyle sectionMeta = AppTextStyles.captionRegular.copyWith(height: 1.35, color: AppColors.teal);
  static final TextStyle chipLabel = AppTextStyles.bodySemiBold11.copyWith(height: 1.3, color: AppColors.petrol);
  static final TextStyle serviceName = AppTextStyles.captionBold.copyWith(height: 1.4, color: AppColors.petrol);
  static final TextStyle visitMetaSmall = AppTextStyles.tinyRegular.copyWith(height: 1.5, color: AppColors.teal);
  static final TextStyle visitMeta = AppTextStyles.captionRegular.copyWith(height: 1.5, color: AppColors.teal);
  static final TextStyle visitStatus = AppTextStyles.bodySemiBold12.copyWith(height: 1.4, color: AppColors.teal);
  static final TextStyle countdownRemaining = AppTextStyles.bodySemiBold11.copyWith(height: 1.4, color: AppColors.teal);
  static final TextStyle countdownValue = AppTextStyles.medium25.copyWith(height: 1.15, color: AppColors.petrol);
  static final TextStyle countdownUnit = AppTextStyles.tinyRegular.copyWith(height: 1.3, color: AppColors.teal);

  // Card action + dock.
  static final TextStyle cardButton = AppTextStyles.bodySemiBold12.copyWith(height: 1.35, color: AppColors.petrol);
  static final TextStyle dockLabel = AppTextStyles.captionRegular.copyWith(height: 1.25, color: AppColors.petrol);
  static final TextStyle dockLabelActive = AppTextStyles.captionBold.copyWith(height: 1.25, color: AppColors.petrol);
}
